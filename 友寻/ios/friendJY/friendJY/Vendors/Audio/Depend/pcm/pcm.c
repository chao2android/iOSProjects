#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <stdlib.h>
#include <fcntl.h>
#include "pcm.h"

#define DEBUG_PCM 0

/* From WmfDecBytesPerFrame in dec_input_format_tab.cpp */
const int sizesdec[] = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 6, 5, 5, 0, 0, 0, 0 };
const int sizesenc[] = { 13, 14, 16, 18, 20, 21, 27, 32, 6, 7, 6, 6, 0, 0, 0, 1 };
const enum Mode modes[] = {MR475, MR515, MR59, MR67, MR74, MR795, MR102, MR122, MRDTX, N_MODES, N_MODES, N_MODES, N_MODES, N_MODES, N_MODES, N_MODES};

static void writeString(int fd, const char *str){
    ssize_t len = write(fd, str, 4);
    if(len!=4){
        printf("Write error: %s %d bytes wroten\n", str, (int)len);
    }
}
static void ReadString(int fd, char *str) {
    ssize_t len = read(fd, str, 4);
    if(len!=4)
        printf("Read error: expect %d bytes while read %d bytes\n", 4, (int)len);
	str[4] = '\0';
}
static void WriteFloat64(int fd, double d, int bigend) {
    unsigned char buf[8];
    unsigned char *p = (unsigned char*)&d;
    
    int i;
    int len;
    
    
    for(i=0; i<8; i++)
        buf[bigend?(7-i):i]=p[i];
    
    len = (int)write(fd, buf, 8);
    if(len != 8){
        printf("write float64 error: %d bytes wroten\n", len);
    }
}
static double ReadFloat64(int fd, int bigend) {
    unsigned char buf[8];
    ssize_t len;
    int i;
    double ret;
    unsigned char *p = (unsigned char*)&ret;
    len = read(fd, buf, 8);
    
    if(len != 8){
        printf("read float64 error: %d bytes read\n", (int)len);
        return (unsigned int)-1;
    }
    
    for(i=0; i<8; i++)
        p[i] = buf[bigend?(7-i):i];
    
	return ret;
}
static void writeInt32(int fd, unsigned int value, int bigend){
    unsigned char buf[4];
    ssize_t len;
    
	if(bigend){
        buf[0] = (unsigned char)((value >> 24) & 0xff);
        buf[1] = (unsigned char)((value >> 16) & 0xff);
        buf[2] = (unsigned char)((value >> 8 ) & 0xff);
        buf[3] = (unsigned char)((value >> 0 ) & 0xff);
	}else{
        buf[0] = (unsigned char)((value >> 0 ) & 0xff);
        buf[1] = (unsigned char)((value >> 8 ) & 0xff);
        buf[2] = (unsigned char)((value >> 16) & 0xff);
        buf[3] = (unsigned char)((value >> 24) & 0xff);
	}
    len = write(fd, buf, sizeof(value));
    if(len != 4){
        printf("write int error: 0x%08X  %d bytes wroten\n", value, (int)len);
    }
}
static unsigned int ReadInt32(int fd, int bigend) {
	unsigned int value = 0;
    unsigned char buf[4];
    ssize_t len;
    len = read(fd, buf, sizeof(value));
    if(len != sizeof(value)){
        printf("read int error: %d bytes read\n", (int)len);
        return (unsigned int)-1;
    }
    
	if(bigend){
        value = (buf[0]<<24) + (buf[1]<<16) + (buf[2]<<8) + (buf[3]<<0);
	}else{
        value = (buf[3]<<24) + (buf[2]<<16) + (buf[1]<<8) + (buf[0]<<0);
	}
	return value;
}
static void writeInt16(int fd, unsigned int value, int bigend){
    unsigned char buf[4];
    ssize_t len;
    
	if(bigend){
        buf[0] = (unsigned char)((value >> 8) & 0xff);
        buf[1] = (unsigned char)((value >> 0) & 0xff);
	}
	else{
        buf[0] = (unsigned char)((value >> 8) & 0xff);
        buf[1] = (unsigned char)((value >> 0) & 0xff);
	}
    len = write(fd, buf, 2);
    if(len!=2)
        printf("Write int16 error: 0x%04X %d bytes wroten\n", value, (int)len);
}
int checkFileInfo(AudioInfo* pTypeIn){
    if(pTypeIn){
        switch(pTypeIn->type){
            case MType_amr:
                break;
            case MType_PCMCaf:
            case MType_PCMWave:
                if(pTypeIn->pcmdatalength==0){
                    printf("Error: data length of pcm file shoule NOT equal to zero.\n");
                    return 0;
                }
                if(pTypeIn->bitsPerSample/8*pTypeIn->channels != pTypeIn->bytesPerFrame){
                    printf("Error: bitsPerSample(%d)/8*channels(%d) != bytesPerFrame(%d)\n", pTypeIn->bitsPerSample, pTypeIn->channels, pTypeIn->bytesPerFrame);
                    return 0;
                }
                if(pTypeIn->bytesPerFrame*pTypeIn->sampleRate != pTypeIn->bytesPerSec){
                    printf("Error: bytesPerFrame(%d)*sampeRate(%d) != bytesPerSec(%d)\n", pTypeIn->bytesPerFrame, pTypeIn->sampleRate, pTypeIn->bytesPerSec);
                    return 0;
                }
                break;
            default:
                printf("Error: unrecognized format\n");
                return 0;
        }
    }
    return 1;
}
static unsigned int ReadInt16(int fd, int bigend){
    unsigned char buf[4];
    ssize_t len;
	unsigned int value = 0;
    
    len = read(fd, buf, 2);
    if(len!=2){
        printf("read int16 error: %d readed\n", (int)len);
        return -1;
    }
	
	if(bigend){
		value = buf[0]<<8 + buf[1];
	}else{
		value = buf[1]<<8 + buf[0];
	}
	return value;
}

void writePCMHeader(int fd, AudioInfo* pInfo)
{
    double rate;
    if(lseek(fd, 0, SEEK_SET)){
        printf("error seek to file begining\n");
        return;
    }
    if(fd<0 || !pInfo)
        return;
    if(pInfo->type==MType_PCMWave){
        writeString(fd, "RIFF");
        writeInt32(fd, 4 + 8 + 16 + 8 + pInfo->pcmdatalength, 0);
        writeString(fd, "WAVE");

        writeString(fd, "fmt ");
        writeInt32(fd, 16, 0);
        writeInt16(fd, 1, 0);                    /* Format */
        writeInt16(fd, pInfo->channels, 0);      /* Channels */ 
        writeInt32(fd, pInfo->sampleRate, 0);    /* Samplerate */
        writeInt32(fd, pInfo->bytesPerSec, 0);   /* Bytes per sec */
        writeInt16(fd, pInfo->bytesPerFrame, 0); /* Bytes per frame */
        writeInt16(fd, pInfo->bitsPerSample, 0); /* Bits per sample */

        writeString(fd, "data");
        writeInt32(fd, pInfo->pcmdatalength, 0);
    }else if(pInfo->type==MType_PCMCaf){
        writeString(fd, "caff");
        writeInt32(fd, 0x10000, 1);             /* version */
        
        writeString(fd, "desc");
        writeInt32(fd, 0, 1);                   /* high 4 bytes for lengh */
        writeInt32(fd, 0x20, 1);                /* lower 4 bytes for length */
        rate = pInfo->sampleRate;
        WriteFloat64(fd, rate, 1);              /* sample rate */
        writeString(fd, "lpcm");                /* format */
        writeInt32(fd, 0x02, 1);                /* flag */
        writeInt32(fd, pInfo->bytesPerFrame, 1); 
        writeInt32(fd, 1, 1);                   /* frames per package */
        writeInt32(fd, pInfo->channels, 1); 
        writeInt32(fd, pInfo->bitsPerSample, 1); 
        writeString(fd, "data");
        writeInt32(fd, 0, 1);
        writeInt32(fd, pInfo->pcmdatalength, 1);
        writeInt32(fd, 1, 1);
    }
}
int initPCMForWrite(const char *filename, AudioInfo* pInfo) 
{
    int fd;
    if(!pInfo || (pInfo->type!=MType_PCMCaf && pInfo->type!=MType_PCMWave))
        return -1;
    if(!checkFileInfo(pInfo))
        return -1;
    
    fd = open(filename, O_RDWR | O_CREAT);
    if(fd<0)return fd;
    
    writePCMHeader(fd, pInfo);
	return fd;
}
int initPCMForRead(const char *filename, AudioInfo* pTypeIn) 
{
	char buf[5];
	int bigend;
    double rate;
    unsigned int len=0;
    unsigned int value;
    
    int fd = open(filename, O_RDONLY);
	if(fd<0)
		return fd;
    
    if(lseek(fd, 0, SEEK_SET)){
        printf("error seek to file begining\n");
        return -1;
    }
    if(pTypeIn)memset(pTypeIn, sizeof(AudioInfo), 0);
    
	ReadString(fd, buf);
	if(!memcmp("RIFF", buf, 4)){
        if(pTypeIn)pTypeIn->type = MType_PCMWave;
        
		bigend = 0;
		value = ReadInt32(fd, bigend);
        if(pTypeIn)pTypeIn->pcmHeaderlength = value;
		
	    ReadString(fd, buf);
		if(memcmp("WAVE", buf, 4)){
            close(fd);
            return -1;
        }
		
		ReadString(fd, buf);
		if(memcmp("fmt ", buf, 4)){
            close(fd);
            return -1;
        }
			
		ReadInt32(fd, bigend);
		ReadInt16(fd, bigend);                  /* Format */
		value = ReadInt16(fd, bigend);          /* Channels */
        if(pTypeIn)pTypeIn->channels = value;
        
		value = ReadInt32(fd, bigend);          /* Samplerate */
        if(pTypeIn)pTypeIn->sampleRate = value;
        
		value = ReadInt32(fd, bigend);          /* Bytes per sec */
        if(pTypeIn)pTypeIn->bytesPerSec = value;
        
		value = ReadInt16(fd, bigend);          /* Bytes per frame */
        if(pTypeIn)pTypeIn->bytesPerFrame = value;
        
		value = ReadInt16(fd, bigend);          /* Bits per sample */
        if(pTypeIn)pTypeIn->bitsPerSample = value;
        
    	do{
	   		lseek(fd, len, SEEK_CUR);
  	   		ReadString(fd, buf);
       		if(buf[4]==EOF){
         		printf("error end of the file\n");
                close(fd);
                return -1;
       		}
      
       		len = ReadInt32(fd, bigend);
	    }while(memcmp("data", buf, 4));
        if(pTypeIn){
            pTypeIn->pcmdatalength = len;
            pTypeIn->pcmHeaderlength -= pTypeIn->pcmdatalength;
            pTypeIn->lengthwithSenconds = pTypeIn->pcmdatalength/pTypeIn->bytesPerSec;
            pTypeIn->bigend = 0;
        }
	}
    else if(!memcmp("caff", buf, 4)){
		bigend = 1;
        if(pTypeIn)pTypeIn->type = MType_PCMCaf;
        
		ReadInt32(fd, bigend);                  /* version */

		/* desc segment */
	    ReadString(fd, buf);
		if(memcmp("desc", buf, 4)){
			printf("%s seg get while desc is expected\n", buf);
            close(fd);
            return -1;
		}
		if(ReadInt32(fd, bigend)){
			printf("seg %s is too big to support\n", buf);
            close(fd);
            return -1;
		}
		len = ReadInt32(fd, bigend);
		if(len!=0x20){
			printf("desc length(%d while expect %d) error\n", len, 0x20);
            close(fd);
            return -1;
		}
        
        rate = ReadFloat64(fd, bigend);         /* sample rate */
        if(pTypeIn)pTypeIn->sampleRate = rate;
        
        ReadString(fd, buf);                    /* formate */
		if(memcmp("lpcm", buf, 4)){
            close(fd);
            return -1;
        }
        
		value = ReadInt32(fd, bigend);          /* flag */
        if(pTypeIn)pTypeIn->bigend = !value&(1L << 1);
        
		value = ReadInt32(fd, bigend);          /* bytes per packet */
        if(pTypeIn)pTypeIn->bytesPerFrame = value;
        
		value = ReadInt32(fd, bigend);          /* Frames Per Packet */
        
		value = ReadInt32(fd, bigend);          /* channels per frame */
        if(pTypeIn)pTypeIn->channels = value;
        
		value = ReadInt32(fd, bigend);          /* bits per channels(sample) */
        if(pTypeIn)pTypeIn->bitsPerSample = value;
        
		len = 0;
		
    	do{
	   		lseek(fd, len, SEEK_CUR);
            
  	   		ReadString(fd, buf);
       		if(buf[4]==EOF){
         		printf("error end of the file\n");
                close(fd);
                return -1;
       		}
      
			if(ReadInt32(fd, bigend)){
				printf("set %s is too big to support\n", buf);
                close(fd);
                return -1;
			}
       		len = ReadInt32(fd, bigend);
	    }while(memcmp("data", buf, 4));
        /* calculate other */
        if(pTypeIn){
            pTypeIn->pcmdatalength = len;
            pTypeIn->bytesPerSec = pTypeIn->sampleRate * pTypeIn->bytesPerFrame;
            pTypeIn->lengthwithSenconds = pTypeIn->pcmdatalength / pTypeIn->bytesPerSec;
        }
        ReadInt32(fd, bigend);
	}
    else{
        close(fd);
        return -1;
    }
#if DEBUG_PCM  
    printf("********************************************\n");
    printf("* PCM Info:\n");
    printf("*   format: %s\n", (pTypeIn->type==MType_PCMWave)?"wav":"caf");
    printf("*   rate:   %d\n", pTypeIn->sampleRate);
    printf("*   channel:%d\n", pTypeIn->channels);
    printf("*   bits:   %d\n", pTypeIn->bitsPerSample);
    printf("*   bigend: %s\n", pTypeIn->bigend?"true":"false");
    printf("*   time:   %.2fs\n", pTypeIn->lengthwithSenconds);
    printf("********************************************\n");
#endif     
	return fd;
}
void writePCMData(int fd, const unsigned char* data, int length)
{
	if (fd<0)
		return;
	write(fd, data, length);
}
int readPCMData(int fd, unsigned short* data, int length, AudioInfo *pInfo)
{
	int i, m;
    unsigned char buf[2];
    unsigned int offset;

    if (fd<0 || !pInfo)
		return 0;
    
    if(pInfo->type!=MType_PCMWave && pInfo->type!=MType_PCMCaf){
        printf("ERROR: only pcm file can be readed\n");
        return 0;
    }
    for(i=0; i<length;i++)
    {
        m = (int)read(fd, buf, pInfo->bitsPerSample/8);
        lseek(fd, (pInfo->channels-1)*pInfo->bitsPerSample/8, SEEK_CUR);
        if(m != pInfo->bitsPerSample/8){
            offset = lseek(fd, 0, SEEK_CUR);
            printf("read error: %d bytes read(%d bytes expected, i=%d seek=0x%X)\n", m, 2, i, offset);
            break;
        }
        
        for(m=0; m<pInfo->bitsPerSample/8; m++){
            if(pInfo->bigend){
                data[i] += buf[m]<<((pInfo->bitsPerSample/8-m-1)*8);
            }else{
                data[i] += buf[m]<<(m*8);
            }
        }
    }
    return i;
}
void convertAmr2Caf(const char *fileamr, const char *filecaf, AudioInfo* pTypeIn, AudioInfo* pTypeOut)
{
    int fdamr;
    int fdcaf;
    unsigned char header[6];
    unsigned char buffer[32];
    short outbuffer[160];
    unsigned char littleendian[320];
    int size;
    int n;
    int i;
    unsigned char* ptr;
    
    struct timeval start, end;
    gettimeofday(&start, NULL);
    
    if(!fileamr || !filecaf || !pTypeIn || !pTypeOut)
        return;
    
    fdamr = open(fileamr, O_RDONLY);
    if (fdamr<0){
        printf("%s open error\n", fileamr);
        return;
    }
    
    n = (int)read(fdamr, header, 6);
    if (n != 6 || memcmp(header, "#!AMR\n", 6)) {
        printf("Bad header\n");
        close(fdamr);
        return;
    }
    
    memset(pTypeOut, 0, sizeof(AudioInfo));
    memset(pTypeIn, 0, sizeof(AudioInfo));
    pTypeIn->type = MType_amr;
    
    pTypeOut->type = MType_PCMCaf;
    pTypeOut->sampleRate = 8000;
    pTypeOut->bitsPerSample = 16;
    pTypeOut->channels = 1;
    pTypeOut->pcmdatalength = 4;
    pTypeOut->bytesPerFrame = pTypeOut->channels * pTypeOut->bitsPerSample / 8;
    pTypeOut->bytesPerSec = pTypeOut->bytesPerFrame * pTypeOut->sampleRate;
    
    unlink(filecaf);
    
    fdcaf = initPCMForWrite(filecaf, pTypeOut);
    if (fdcaf<0){
        close(fdamr); 
        return;
    }
    
    void* p = Decoder_Interface_init();
    while (1) {
        /* Read the mode byte */
        n = read(fdamr, buffer, 1);
        if (n <= 0)
            break;
        /* Find the packet size */
        size = sizesdec[(buffer[0] >> 3) & 0x0f];
        if (size <= 0)break;
        n = read(fdamr, buffer + 1, size);
        if (n != size)
            break;
        
        /* Decode the packet */
        Decoder_Interface_Decode(p, buffer, outbuffer, 0);
        
        /* Convert to little endian and write to wav */
        ptr = littleendian;
        for (i = 0; i < 160; i++) {
            *ptr++ = (outbuffer[i] >> 0) & 0xff;
            *ptr++ = (outbuffer[i] >> 8) & 0xff;
        }
        writePCMData(fdcaf, littleendian, 320);
        
        pTypeOut->pcmdatalength += 320;
    }
    writePCMHeader(fdcaf, pTypeOut);
    close(fdamr);
    close(fdcaf);
    chmod(filecaf, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH);
    Decoder_Interface_exit(p);
    
    gettimeofday(&end, NULL);
    
#if DEBUG_PCM  
    printf("file created: [%s]\n", filecaf);
    printf("time comsumption: %lds %dus\n", end.tv_sec-start.tv_sec, end.tv_usec-start.tv_usec);
#endif
    
    pTypeIn->codeTime = end.tv_sec-start.tv_sec + (end.tv_usec-start.tv_usec)/1000000;
    pTypeOut->lengthwithSenconds = pTypeOut->pcmdatalength/pTypeOut->bytesPerSec;
    pTypeIn->amr_mode = modes[(buffer[0] >> 3) & 0x0f];
    pTypeIn->lengthwithSenconds = pTypeOut->lengthwithSenconds;
    pTypeOut->codeTime = pTypeIn->codeTime;
}
void convertCaf2Amr(const char *filecaf, const char *fileamr, enum Mode mode, AudioInfo* pTypeIn, AudioInfo* pTypeOut)
{
    int fdamr;
    int fdcaf;
    void *p;
    int ret;
    int n, i=0;
    unsigned short *buf;
    int bytesPerPac;
    unsigned char outbuf[32];
    
    struct timeval start, end;
    gettimeofday(&start, NULL);

    if(!fileamr || !filecaf || !pTypeIn || !pTypeOut)
        return;
    
    memset(pTypeOut, 0, sizeof(AudioInfo));
    memset(pTypeIn, 0, sizeof(AudioInfo));
    
    fdcaf = initPCMForRead(filecaf, pTypeIn);
    if(!checkFileInfo(pTypeIn)){
        printf("%s formate error\n", filecaf);
        return;
    }
    if(fdcaf<0){
        printf("%s open error\n", filecaf);
        return;
    }
    if(pTypeIn->sampleRate!=8000){
        printf("ERROR: only 8khz PCM audio is supported.\n");
        return;
    }
    bytesPerPac = pTypeIn->sampleRate/50;
    buf = (unsigned short *)malloc(sizeof(unsigned short)*bytesPerPac);
    
    unlink(fileamr);
    fdamr = open(fileamr, O_RDWR|O_CREAT);
    if(fdamr<0){
        printf("%s open error\n", fileamr);
        close(fdcaf);
        free(buf);
        return;
    }
    write(fdamr, "#!AMR\n", 6);
    
    p = Encoder_Interface_init(0);
    do{
        ret = readPCMData(fdcaf, buf, bytesPerPac, pTypeIn);
        if(ret == bytesPerPac){
            n = Encoder_Interface_Encode(p, mode, (short*)buf, outbuf, 0);
          i++;
          if(i>8)
                write(fdamr, outbuf, n);
        }
    }while(ret==bytesPerPac);
    close(fdamr);
    close(fdcaf);
    chmod(fileamr, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH);
    Encoder_Interface_exit(p);

    free(buf);
    
    gettimeofday(&end, NULL);
    
#if DEBUG_PCM  
    printf("file created: [%s]\n", fileamr);
    printf("time comsumption: %lds %dus\n", end.tv_sec-start.tv_sec, end.tv_usec-start.tv_usec);
#endif
    pTypeIn->codeTime = end.tv_sec-start.tv_sec + (end.tv_usec-start.tv_usec)/1000000;
    pTypeOut->type = MType_amr;
    pTypeOut->amr_mode = mode;
    pTypeOut->lengthwithSenconds = pTypeIn->lengthwithSenconds;
    pTypeOut->codeTime = pTypeIn->codeTime;
}

