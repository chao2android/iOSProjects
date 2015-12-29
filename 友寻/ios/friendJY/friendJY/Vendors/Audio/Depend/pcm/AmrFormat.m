//
//  AmrFormat.m
//  JiaYuan
//
//  Created by  on 12-10-9.
//  Copyright (c) 2012年 JiaYuan. All rights reserved.
//

#import "AmrFormat.h"

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>


static int writePackageToAmr(AmrInfo *pInfo, void *pBuf);
void* compress_thread(void *pData);

static char *pCompressPath = NULL;

static void interruptionListener(void *    inClientData,
                                 UInt32    inInterruptionState)
{
    if(inInterruptionState)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"interruptionListener" object:nil];
    }
}

id amrFormat;
bool playBegan;

@implementation AmrFormat
@synthesize delegate;
@synthesize recordIdentifier = _recordIdentifier;
@synthesize playIdentifier = _playIdentifier;

/*****************************************************************
 *
 *  Common function
 *
 *****************************************************************
 */

unsigned int getAmrTimeMsLength(const char* path){
    KX_FILE_HANDLE fdamr;
    int n, size;
    unsigned int timems = 0;
    char buf[32];
#if AUDIO_FILE_ANA
    int idx=0,count=0;
#endif
    
    chmod(path, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH);
    fdamr = devFS_openFile(path, KX_FOPEN_READ);
    if(!devFS_isHandleValid(fdamr)){
        printf("ERROR: file open error. [%s]\n", path);
        return (unsigned int)-1;
    }
    
    n = (int)devFS_readFile(fdamr, buf, 6);
    if(n!=6 || memcmp(buf, "#!AMR\n", n)){
        printf("ERROR: %s is not amr-nb file.\n", path);
        devFS_closeFile(fdamr);
        return (unsigned int)-1;
    }
#if AUDIO_FILE_ANA
    printf("file path: [%s]\n", path);
#endif
    
    do{
        n = devFS_readFile(fdamr, buf, 1);
        if (n != 1) break;
        
        /* Find the packet size */
        size = sizesdec[(buf[0] >> 3) & 0x0f];
#if AUDIO_FILE_ANA
        if(idx!=((buf[0] >> 3) & 0x0f))
        {
            if(idx)
                printf("* %d count:%d = %dms (size=%d)\n", idx, count, count*20, sizesdec[idx]*count);
            idx = (buf[0] >> 3) & 0x0f;
            count = 1;
        }
        else
            count++;
#endif 
        
        if (size <= 0)
            continue;
        assert(size<32);
        n = devFS_readFile(fdamr, buf + 1, size);
        if (n != size)
            break;
        timems += 20;
    }while(1);
    
#if AUDIO_FILE_ANA
    if(idx)
        printf("* %d count:%d = %dms\n", idx, count, count*20);
#endif
    
    devFS_closeFile(fdamr);
    return timems;
}

void initPCMArgs(AmrInfo *pInfo)
{
    pInfo->des.mSampleRate = 8000.0;
    pInfo->des.mFormatID = kAudioFormatLinearPCM;
    pInfo->des.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    pInfo->des.mBytesPerPacket = sizeof(short);
    pInfo->des.mFramesPerPacket = 1;
    pInfo->des.mBytesPerFrame = sizeof(short);
    pInfo->des.mChannelsPerFrame = 1;
    pInfo->des.mBitsPerChannel = sizeof(short)*8;
    pInfo->des.mReserved = 0;
    pInfo->m_Done = 0;
    
    pthread_mutex_init(&pInfo->mutex, NULL);
}
void initPlayAmr(AmrInfo *pInfo)
{
    if(!pInfo)
        return;
    
    initPCMArgs(pInfo);
    
    if(devFS_isHandleValid(pInfo->fdin)){
        devFS_closeFile(pInfo->fdin);
        pInfo->fdin=KX_INVALID_FILE_HANDLE;
    }
    if(devFS_isHandleValid(pInfo->fdstart)){
        devFS_closeFile(pInfo->fdstart);
        pInfo->fdstart=KX_INVALID_FILE_HANDLE;
    }
    if(devFS_isHandleValid(pInfo->fdend)){
        devFS_closeFile(pInfo->fdend);
        pInfo->fdend=KX_INVALID_FILE_HANDLE;
    }
    
    pInfo->play_time_msec_cur = 0;
    pInfo->play_time_msec = 0;
    
    if(pInfo->pDecode){
        Decoder_Interface_exit(pInfo->pDecode);
    }
    pInfo->pDecode = Decoder_Interface_init();
}
void initRecordAmr(AmrInfo *pInfo)
{
    if(!pInfo)
        return;
    
    initPCMArgs(pInfo);
    
    if(devFS_isHandleValid(pInfo->fdout)){
        devFS_closeFile(pInfo->fdout);
        pInfo->fdout=KX_INVALID_FILE_HANDLE;
    }
    pInfo->record_time_msec_cur = 0;
    pInfo->record_time_msec = MAXRECORDTIME;
    if(pInfo->pEncode){
        Encoder_Interface_exit(pInfo->pEncode);
    }
    pInfo->pEncode = Encoder_Interface_init(0);
    
    pInfo->tAudioBuf.iCur = 0;
    pInfo->tAudioBuf.n = 0;
    pInfo->tAudioBuf.iTotal = 50 * 60;
    pInfo->m_Done = 0;
    if(!pInfo->tAudioBuf.buf)
        pInfo->tAudioBuf.buf = (short *)malloc(pInfo->tAudioBuf.iTotal*BUFFER_RECORD);
    if(!pInfo->tAudioBuf.buf){
        printf("********** malloc buffer for compress error. ************\n");
        pInfo->tAudioBuf.iCur = 0;
        pInfo->tAudioBuf.iTotal = 0;
    }
    else
        pthread_create(&pInfo->thread, NULL, compress_thread, pInfo);
}

static int readPackageFromAmr(AmrInfo *pInfo, void *pBuf, AudioQueueParameterValue *pVal)
{
    int n, size;
    unsigned char buffer[500];
    
READ_START_AMR:
    if(!devFS_isHandleValid(pInfo->fdstart))
        goto READ_AUDIO_AMR;
    
    n = devFS_readFile(pInfo->fdstart, buffer, 1);
    if (n <= 0)
        goto READ_AUDIO_AMR;
    
    /* Find the packet size */
    size = sizesdec[(buffer[0] >> 3) & 0x0f];
    if (size <= 0)
        goto READ_START_AMR;
    
    n = devFS_readFile(pInfo->fdstart, buffer + 1, size);
    if (n != size)
        goto READ_AUDIO_AMR;
    
    *pVal = 0.3;
    goto START_DECODE;
    
READ_AUDIO_AMR:
    if(devFS_isHandleValid(pInfo->fdstart)){
        devFS_closeFile(pInfo->fdstart);
        pInfo->fdstart = KX_INVALID_FILE_HANDLE;
    }
    if(!devFS_isHandleValid(pInfo->fdin))
        goto READ_END_AMR;
    n = devFS_readFile(pInfo->fdin, buffer, 1);
    if (n <= 0) 
        goto READ_END_AMR;
    
    /* Find the packet size */
    size = sizesdec[(buffer[0] >> 3) & 0x0f];
    if (size <= 0)
        goto READ_AUDIO_AMR;
    
    n = devFS_readFile(pInfo->fdin, buffer + 1, size);
    if (n != size)
        goto READ_END_AMR;
    
    pInfo->play_time_msec_cur += 20;
    
    if (playBegan)
    {
        if ([NSThread isMainThread])
        {
            [amrFormat setPlayTime];
        }else 
        {
            [amrFormat performSelectorOnMainThread:@selector(setPlayTime) withObject:nil waitUntilDone:NO];
        }
    }
    
    *pVal = 1.0;
    goto START_DECODE;
    
READ_END_AMR:
    if(devFS_isHandleValid(pInfo->fdin)){
        devFS_closeFile(pInfo->fdin);
        pInfo->fdin = KX_INVALID_FILE_HANDLE;
    }
    if(!devFS_isHandleValid(pInfo->fdend)){
//        pInfo->m_Done = 1;
        return 0;
    }
    n = devFS_readFile(pInfo->fdend, buffer, 1);
    if (n <= 0) {
//        pInfo->m_Done = 1;
        devFS_closeFile(pInfo->fdend);
        pInfo->fdend = KX_INVALID_FILE_HANDLE;
        return 0;
    }
    
    /* Find the packet size */
    size = sizesdec[(buffer[0] >> 3) & 0x0f];
    if (size <= 0)
        goto READ_END_AMR;
    
    n = devFS_readFile(pInfo->fdend, buffer + 1, size);
    if (n != size){
//        pInfo->m_Done = 1;
        devFS_closeFile(pInfo->fdend);
        pInfo->fdend = KX_INVALID_FILE_HANDLE;
        return 0;
    }
    if(pInfo->play_time_msec_cur < pInfo->play_time_msec)
        pInfo->play_time_msec_cur += 20;
    *pVal = 0.3;
START_DECODE:
    /* Decode the packet */
    Decoder_Interface_Decode(pInfo->pDecode, buffer, (short *)pBuf, 0);
    return 160;
}
static int writePackageToAmr(AmrInfo *pInfo, void *pBuf)
{
    unsigned char buffer[500];
    Encoder_Interface_Encode(pInfo->pEncode, pInfo->mode, (short *)pBuf, buffer, 0);
    
    if(devFS_isHandleValid(pInfo->fdout) && (32 == devFS_writeFile(pInfo->fdout, buffer, 32)))
        return 160;
    else
        return 0;
}
int audiobuf_add(AmrInfo *pInfo, short *buf)
{
    audioBuf *pnod;
    int idx;
    int ret=0;
    
    pthread_mutex_lock(&pInfo->mutex);    
    
    if(!pInfo || !pInfo->tAudioBuf.iTotal){
        ret = -1;
        goto audiobuf_add_exit;
    }
    
    pnod=&pInfo->tAudioBuf;
    
    if((pnod->iCur >= pnod->iTotal) || 
       (pnod->iTotal!=3000) ||
       (pnod->n > pnod->iTotal))
        printf("****************** place1: cur=%d n=%d total=%d \n", pnod->iCur, pnod->n, pnod->iTotal);
    
    if(!pnod || !pnod->buf){
        ret = -1;
        goto audiobuf_add_exit;
    }
    
    idx = (pnod->iCur + pnod->n)%pnod->iTotal;
    if(pnod->n>=pnod->iTotal){
        ret = -1;
        goto audiobuf_add_exit;
    }
    
    memcpy(&pnod->buf[idx*160], buf, 160*sizeof(short));
    pnod->n++;
    pInfo->record_time_msec_cur += 20;
    
    if((pnod->iCur >= pnod->iTotal) || 
       (pnod->iTotal!=3000) ||
       (pnod->n > pnod->iTotal))
        printf("****************** place2: cur=%d n=%d total=%d \n", pnod->iCur, pnod->n, pnod->iTotal);
audiobuf_add_exit:
    pthread_mutex_unlock(&pInfo->mutex);
    return ret;
}

/*****************************************************************
 *
 *  compress thread
 *
 *****************************************************************
 */
void* compress_thread(void *pData)
{
    AmrInfo *pInfo = (AmrInfo *)pData;
    pInfo->m_compressDone = 0;
    int ret;
    if(pInfo){
        while((pInfo->m_Done==0) || (pInfo->tAudioBuf.n>0)){
            if((pInfo->tAudioBuf.iCur >= pInfo->tAudioBuf.iTotal) || 
               (pInfo->tAudioBuf.iTotal!=3000) ||
               (pInfo->tAudioBuf.n > pInfo->tAudioBuf.iTotal))
                printf("****************** place3 cur=%d n=%d total=%d \n", pInfo->tAudioBuf.iCur, pInfo->tAudioBuf.n, pInfo->tAudioBuf.iTotal);
            
            if(pInfo->tAudioBuf.n){
                ret = writePackageToAmr(pInfo, &pInfo->tAudioBuf.buf[pInfo->tAudioBuf.iCur*160]);
                if(ret != 160){
                    printf("****************** write error(ret=%d err=%d).\n", ret, errno);
                }
                
                pthread_mutex_lock(&pInfo->mutex);
                pInfo->tAudioBuf.iCur = (pInfo->tAudioBuf.iCur+1)%pInfo->tAudioBuf.iTotal;
                pInfo->tAudioBuf.n--;
                pthread_mutex_unlock(&pInfo->mutex);
            }
        }
    }
    if(devFS_isHandleValid(pInfo->fdout)){
        devFS_closeFile(pInfo->fdout);
        pInfo->fdout = KX_INVALID_FILE_HANDLE;
    }
    if(pCompressPath) free(pCompressPath);
    pCompressPath = NULL;
#if RECORD_DEBUG
    printf("****************** compress thread exit. step 3\n");
#endif
    pInfo->m_compressDone = 1;
    if ([NSThread isMainThread])
    {
        [amrFormat recordFinish];
    }else
    {
        [amrFormat performSelectorOnMainThread:@selector(recordFinish) withObject:nil waitUntilDone:NO];
    }
    releaseResource(pInfo);
    
    return NULL;
}

/*****************************************************************
 *
 *  Amr player
 *
 *****************************************************************
 */
void _stop_PlayerAmr(AmrInfo *pInfo)
{
    if(!pInfo)
        return;
    
    if(devFS_isHandleValid(pInfo->fdstart)){
        devFS_closeFile(pInfo->fdstart);
        pInfo->fdstart = KX_INVALID_FILE_HANDLE;
    }
    
    if(devFS_isHandleValid(pInfo->fdin)){
        devFS_closeFile(pInfo->fdin);
        pInfo->fdin = KX_INVALID_FILE_HANDLE;
    }
    if(devFS_isHandleValid(pInfo->fdend)){
        devFS_closeFile(pInfo->fdend);
        pInfo->fdend = KX_INVALID_FILE_HANDLE;
    }
    
    pInfo->play_time_msec_cur = pInfo->play_time_msec;
    if (!pInfo->m_Done)
    {
        releaseResource(pInfo);
        if ([NSThread isMainThread])
        {
            [amrFormat playFinish];
        }else 
        {
            [amrFormat performSelectorOnMainThread:@selector(playFinish) withObject:nil waitUntilDone:NO];
        }
    }
    
    pInfo->m_Done = 1;
}
static void AQBufferCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inCompleteAQBuffer) 
{
    AmrInfo * pInfo = (AmrInfo *)inUserData;
    if (pInfo->m_Done)
    {
        return;
    }
    int n,i;
    short *p;
    
    AudioQueueParameterEvent event;
    event.mID = kAudioQueueParam_Volume;
    event.mValue = 1.0;
    
    p = inCompleteAQBuffer->mAudioData;
    
    for(i=0; i<BUFFER_PLAY/(160*(sizeof(short))); i++){
        n = readPackageFromAmr(pInfo, &p[i*160], &event.mValue);
        if(n==0)
            break;
    }
    
    if(0 == i){
        _stop_PlayerAmr(pInfo);
    }else{
        inCompleteAQBuffer->mAudioDataByteSize = i * 160 * sizeof(short);
        AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, 0, NULL);
        //        AudioQueueEnqueueBufferWithParameters(inAQ, inCompleteAQBuffer, 0, NULL, 0, 0, 1, &event, NULL, NULL);
    }
}
void stopPlayAmr(AmrInfo *pInfo)
{
    if(!pInfo)
        return;
    if(pInfo->mQueue){
#if AUDIO_QUEUE_PLAY
        printf(".................. AMR player end ( %d of %d ms)\n", (unsigned int)pInfo->play_time_msec_cur, pInfo->play_time_msec);
#endif  
        AudioQueueStop(pInfo->mQueue, false);
        AudioQueueDispose(pInfo->mQueue, true);
        pInfo->mQueue = NULL;
        for(int i=0; i<BUFFER_NUMER; i++)
            pInfo->mInBuffers[i] = NULL;
    }
    _stop_PlayerAmr(pInfo);
}
OSStatus playAmr(AmrInfo *pInfo, const char* path, const char *startamr, const char *endamr, CFRunLoopRef refLoop)
{
    OSStatus result;
    int i = 0;
    
    if(!pInfo)
        return -1;
    
    if(!path || strlen(path)<=0)
        return -2;
    
    initPlayAmr(pInfo);
    
    pInfo->play_time_msec = getAmrTimeMsLength(path);
    if(pInfo->play_time_msec == (unsigned int)-1){
        printf("ERROR: get time length of amr files.\n");
        return -3;
    }
    
    pInfo->fdin = devFS_openFile(path, KX_FOPEN_READ);
    devFS_seek(pInfo->fdin, 6, KX_SEEK_SET);
    
    if(endamr && strlen(endamr)>0){
        pInfo->fdend = devFS_openFile(endamr, KX_FOPEN_READ);
        if(devFS_isHandleValid(pInfo->fdend))
            devFS_seek(pInfo->fdend, 6, KX_SEEK_SET);
        else
            printf("********* ERROR: %s open error.\n", endamr);
    }
    
    if(startamr && strlen(startamr)>0){
        pInfo->fdstart = devFS_openFile(startamr, KX_FOPEN_READ);
        if(devFS_isHandleValid(pInfo->fdstart))
            devFS_seek(pInfo->fdstart, 6, KX_SEEK_SET);
        else
            printf("********* ERROR: %s open error.\n", startamr);
    }
    
    if(!pInfo->mQueue){
        result = AudioQueueNewOutput(&pInfo->des, AQBufferCallback, 
                                     pInfo, refLoop, 
                                     kCFRunLoopCommonModes, 0, 
                                     &pInfo->mQueue);
        if(result){
            printf("ERROR: AudioQueueNew failed: %ld\n", result);
            return result;
        }
    }
    
    for(int i=0; i<BUFFER_NUMER; i++){
        if(!pInfo->mInBuffers[i]){
            result = AudioQueueAllocateBuffer(pInfo->mQueue, BUFFER_PLAY, &pInfo->mInBuffers[i]);
            if(result){
                printf("ERROR: AudioQueueAllocateBuffer failed: %ld\n", result);
                return result;
            }
        }
        AQBufferCallback(pInfo, pInfo->mQueue, pInfo->mInBuffers[i]);
    }
    pInfo->play_time_msec_cur = 0;
    
    // set the volume of the queue
    result = AudioQueueSetParameter(pInfo->mQueue, kAudioQueueParam_Volume, 1);
    if(result){
        printf("ERROR: set queue volume failed: %ld\n", result);
        //        stopPlayAmr(pInfo);
        //        return result;
    }
    do{
        i++;
        result = AudioQueueStart(pInfo->mQueue, NULL);
        if(result) usleep(200000);
    } while(result && i<4);
    
    if(result){
        printf("AudioQueueStart failed: %ld\n", result);
    }
    
#if AUDIO_QUEUE_PLAY
    else
        printf("start play amr(i=%d): %s\n", i, path);
#endif
    return result;
}

/*****************************************************************
 *
 *  Amr record
 *
 *****************************************************************
 */

static void AQBufferRecordCallback(void * inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp * inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    AmrInfo * pInfo = (AmrInfo *)inUserData;
    if (pInfo->m_Done)
    {
        return;
    }
    int n,i;
    short *p;
    unsigned int v=0;
    p = inBuffer->mAudioData;
    
    if(pInfo->m_Done)
        return;
    
    for(i=0; i<inNumPackets/160; i++){
        for(n=0; n<40; n++)
            if(abs(p[n<<2]) > v)
                v = abs(p[n<<2]);
        if(n==0)
            break;
        audiobuf_add(pInfo, p);
        p =  &p[160];
    }
    
    if(v>pInfo->curRecordPower)
        pInfo->curRecordPower = v;
    else
        pInfo->curRecordPower = (pInfo->curRecordPower*3+v)>>2;
    
    if ([NSThread isMainThread])
    {
        [amrFormat setRecordTime];
    }else 
    {
        [amrFormat performSelectorOnMainThread:@selector(setRecordTime) withObject:nil waitUntilDone:NO];
    }
    
    if(pInfo->record_time_msec>MAXRECORDTIME)
        pInfo->record_time_msec = MAXRECORDTIME;
    
    if(pInfo->record_time_msec_cur>=pInfo->record_time_msec){
        if(!pInfo->m_Done){
            stopRecordAmr(pInfo);
        }
    }
    else
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}
void stopRecordAmr(AmrInfo *pInfo)
{
    if(!pInfo){
        return;
    }
    
#if RECORD_DEBUG
    printf("****************** stop record. step 1\n");
#endif
    
    pInfo->record_time_msec = pInfo->record_time_msec_cur;
    
#if AUDIO_QUEUE_RECORD
    printf(".................. AMR recorder finished (%d ms of %d ms)\n", pInfo->record_time_msec_cur, pInfo->record_time_msec);
#endif
    if(pInfo->mQueue){
        AudioQueueStop(pInfo->mQueue, false);
        AudioQueueDispose(pInfo->mQueue, true);
        pInfo->mQueue = NULL;
        for(int i=0; i<BUFFER_NUMER; i++)
            pInfo->mOutBuffers[i] = NULL;
    }
    
    pInfo->m_Done = 1;
}

OSStatus recordAmr(AmrInfo *pInfo, const char* path, enum Mode mod, CFRunLoopRef refLoop)
{
    OSStatus result;
    int i=0;
    
    if(!pInfo && (pInfo->record_time_msec>pInfo->record_time_msec_cur))
        return -1;
    
    if(pCompressPath) free(pCompressPath);
    pCompressPath = NULL;
    
    initRecordAmr(pInfo);
    
    unlink(path);
    pInfo->fdout = devFS_openFile(path, KX_FOPEN_CREATE);
    if(!devFS_isHandleValid(pInfo->fdout)){
        pInfo->record_time_msec = pInfo->record_time_msec_cur = 0;
        printf("%s open error\n", path);
        return -1;
    }
    devFS_writeFile(pInfo->fdout, "#!AMR\n", 6);
    
    pInfo->mode = mod;
    
    if(!pInfo->mQueue){
        result = AudioQueueNewInput(&pInfo->des, AQBufferRecordCallback, pInfo, refLoop, kCFRunLoopCommonModes, 0, &pInfo->mQueue);
        if(result){
            pInfo->mQueue = 0;
            printf("ERROR: AudioQueueNew failed: %ld\n", result);
            return result;
        }
    }
    for(int i=0; i<BUFFER_NUMER; i++){
        if(!pInfo->mOutBuffers[i]){
            result = AudioQueueAllocateBuffer(pInfo->mQueue, BUFFER_RECORD, &pInfo->mOutBuffers[i]);
            if(result){
                printf("ERROR: AudioQueueAllocateBuffer failed: %ld\n", result);
                return result;
            }
        }
        result = AudioQueueEnqueueBuffer(pInfo->mQueue, pInfo->mOutBuffers[i], 0, NULL);
        if(result){
            printf("AudioQueueEnqueueBuffer failed: %ld\n", result);
            return result;
        }
    }
    
    // set the volume of the queue
    //    result = AudioQueueSetParameter(pInfo->mQueue, kAudioQueueParam_Volume, 1);
    //    if(result){
    //        printf("ERROR: set queue volume failed: %ld\n", result);
    //    }
    
    do{
        i++;
        result = AudioQueueStart(pInfo->mQueue, NULL);
        if(result){
            printf("RECORD: AudioQueueStart: %ld\n", result);
            usleep(200000);
        }
        
    }while(result && i<4);
    
    if(result){
        printf("AudioQueueStart failed: %ld\n", result);
        pInfo->record_time_msec = pInfo->record_time_msec_cur = 0;
    }
    else{
        pCompressPath = (char*)malloc(strlen(path)+1);
        if(pCompressPath)
            strcpy(pCompressPath, path);
        
#if AUDIO_QUEUE_RECORD
        printf("start record amr(i=%d): %s\n", i, path);
#endif
    }
    return result;
}

void releaseResource(AmrInfo *pInfo)
{
    int i;
    
    if(!pInfo)
        return;
    
#if RECORD_DEBUG
    printf("****************** release resource. step 5\n");
#endif
    
    if(pInfo->mQueue){
        if (AudioQueueStop(pInfo->mQueue, false)) {
            printf("AudioQueueStop(false) failed.\n");
        }
        if(AudioQueueDispose(pInfo->mQueue, true)){
            printf("AudioQueueDispose(true) failed.\n");
        }
        pInfo->mQueue = 0;
        for(i=0; i<BUFFER_NUMER; i++){
            pInfo->mOutBuffers[i]=NULL;
            pInfo->mInBuffers[i] =NULL;
        }
    }
    if(pInfo->pEncode){
        Encoder_Interface_exit(pInfo->pEncode);
        pInfo->pEncode = NULL;
    }
    if(pInfo->pDecode){
        Decoder_Interface_exit(pInfo->pDecode);
        pInfo->pDecode = NULL;
    }
    
    if(devFS_isHandleValid(pInfo->fdstart))
        devFS_closeFile(pInfo->fdstart);
    pInfo->fdstart =  KX_INVALID_FILE_HANDLE;
    
    if(devFS_isHandleValid(pInfo->fdend))
        devFS_closeFile(pInfo->fdend);
    pInfo->fdend = KX_INVALID_FILE_HANDLE;
    
    if(devFS_isHandleValid(pInfo->fdout))
        devFS_closeFile(pInfo->fdout);
    pInfo->fdout = KX_INVALID_FILE_HANDLE;
    
    if(devFS_isHandleValid(pInfo->fdin))
        devFS_closeFile(pInfo->fdin);
    pInfo->fdin = KX_INVALID_FILE_HANDLE;
    
    if(pInfo->tAudioBuf.buf)
        free(pInfo->tAudioBuf.buf);
    pInfo->tAudioBuf.buf = NULL;
}


/*****************************************************************
 *
 *  OC function
 *
 *****************************************************************
 */
#pragma mark - life cycle
-(id)init
{
    OSStatus error;
//    _category = kAudioSessionCategory_MediaPlayback;
    
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordInterrupted) name:@"interruptionListener" object:nil];
        
        memset(&_recordInfo, 0, sizeof(_recordInfo));
        memset(&_playInfo, 0, sizeof(_playInfo));
        
        error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
        if (error) printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)error);
        /*
        error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(_category), &_category);
        if (error) printf("couldn't set audio category!");
        
        error = AudioSessionSetActive(true);
        if (error) printf("AudioSessionSetActive (true) failed");
        */
    }
    return self;
}

-(void)dealloc
{
    AudioSessionSetActive(false);
    amrFormat = nil;
    delegate = nil;
    [self waitingCompressThreadFinish];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"interruptionListener" object:nil];
    if ([self isRecordingAmr])
    {
        stopRecordAmr(&_recordInfo);
    }
    if ([self isPlayingAmr])
    {
        stopPlayAmr(&_playInfo);
    }
    releaseResource(&_recordInfo);
    releaseResource(&_playInfo);
    self.recordIdentifier = nil;
    self.playIdentifier = nil;
    [_audioPlayer release], _audioPlayer = nil;
    [super dealloc];
}

#pragma mark - custom action

-(void)recordInterrupted
{
    _recordInfo.record_time_msec = _recordInfo.record_time_msec_cur;
    AudioQueueStop(_recordInfo.mQueue, false);
}

-(bool)isRecordingAmr
{
    if (_recordInfo.tAudioBuf.buf && ((_recordInfo.record_time_msec_cur < _recordInfo.record_time_msec) || (_recordInfo.tAudioBuf.n > 0))) return YES;
    else return NO;
}

-(bool)isPlayingAmr
{
    if ((_playInfo.fdin>=0 || _playInfo.fdstart>=0 || _playInfo.fdend>=0) && (_playInfo.play_time_msec_cur < _playInfo.play_time_msec)) return YES;
    else return NO;
}

-(void)stopRecordAmr
{
    stopRecordAmr(&_recordInfo);
}

-(void)stopPlayAmr
{
    stopPlayAmr(&_playInfo);
}

-(void)changeSession:(UInt32)category
{
    if (category == _category)
    {
        return;
    }
    _category = category;
//    AudioSessionSetActive(false);
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(_category), &_category);
    AudioSessionSetActive(true);
}

-(void)startRecordAmr:(NSString *)path identifier:(NSString *)identifier
{
    [self waitingCompressThreadFinish];
    
    amrFormat = self;
    self.recordIdentifier = identifier;
    [self changeSession:kAudioSessionCategory_PlayAndRecord];
    
    OSStatus ret = recordAmr(&_recordInfo, [path UTF8String], MR122, NULL);
    
    if (ret)
    {
        _recordInfo.m_Done = 1;
        if ([NSThread isMainThread])
        {
            [self recordError];
        }else 
        {
            [self performSelectorOnMainThread:@selector(recordError) withObject:nil waitUntilDone:NO];
        }
    }else 
    {
        if ([NSThread isMainThread])
        {
            [self recordBegin];
        }else 
        {
            [self performSelectorOnMainThread:@selector(recordBegin) withObject:nil waitUntilDone:NO];
        }
    }
}

-(void)recordBegin
{
    if ([delegate respondsToSelector:@selector(amrFormatRecordBegan:identifier:)])
    {
        [delegate amrFormatRecordBegan:self identifier:_recordIdentifier];
    }
}

-(void)recordError
{
    if ([delegate respondsToSelector:@selector(amrFormatRecordError:identifier:)])
    {
        [delegate amrFormatRecordError:self identifier:_recordIdentifier];
    }
}

-(void)setRecordTime
{
    if ([delegate respondsToSelector:@selector(amrFormatRecord:identifier:changeTime:volum:)])
    {
        [delegate amrFormatRecord:self identifier:_recordIdentifier changeTime:_recordInfo.record_time_msec_cur volum:_recordInfo.curRecordPower];
    }
}

-(void)recordFinish
{
    if ([delegate respondsToSelector:@selector(amrFormatRecordFinished:identifier:amrLength:)])
    {
        [delegate amrFormatRecordFinished:self identifier:_recordIdentifier amrLength:_recordInfo.record_time_msec];
        
        if (!_audioPlayer)
        {
            NSURL * url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"playend" ofType:@"wav"]];
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [url release];
        }
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
    }
}

-(void)startPlayAmr:(NSString *)path identifier:(NSString *)identifier
{
    amrFormat = self;
    self.playIdentifier = identifier;
    [self changeSession:kAudioSessionCategory_MediaPlayback];
    _playBegan = NO;
    playBegan = _playBegan;
    
    OSStatus ret = playAmr(&_playInfo, [path UTF8String], NULL, NULL, NULL);
    
    if (ret)
    {
        _playInfo.m_Done = 1;
        if ([NSThread isMainThread])
        {
            [self playError];
        }else 
        {
            [self performSelectorOnMainThread:@selector(playError) withObject:nil waitUntilDone:NO];
        }
    }else 
    {
        _playBegan = YES;
        playBegan = _playBegan;
        if ([NSThread isMainThread])
        {
            [self playBegin];
        }else 
        {
            [self performSelectorOnMainThread:@selector(playBegin) withObject:nil waitUntilDone:NO];
        }
    }
}

-(void)playBegin
{
    if ([delegate respondsToSelector:@selector(amrFormatPlayBegan:identifier:)])
    {
        [delegate amrFormatPlayBegan:self identifier:_playIdentifier];
    }
}

-(void)playError
{
    if ([delegate respondsToSelector:@selector(amrFormatPlayError:identifier:)])
    {
        [delegate amrFormatPlayError:self identifier:_playIdentifier];
    }
}

-(void)setPlayTime
{
    if ([delegate respondsToSelector:@selector(amrFormatPlay:identifier:changeTime:totallyTime:)])
    {
        [delegate amrFormatPlay:self identifier:_playIdentifier changeTime:_playInfo.play_time_msec_cur totallyTime:_playInfo.play_time_msec];
    }
}

-(void)playFinish
{
    if ([delegate respondsToSelector:@selector(amrFormatPlayFinished:identifier:)])
    {
        [delegate amrFormatPlayFinished:self identifier:_playIdentifier];
    }
}

-(void)waitingCompressThreadFinish
{
    pthread_join(_recordInfo.thread, NULL);
    _recordInfo.thread = NULL;
}

@end
