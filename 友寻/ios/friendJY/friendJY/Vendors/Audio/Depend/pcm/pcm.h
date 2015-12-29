#ifndef PCM_H
#define PCM_H

#include <stdio.h>
#include <time.h>
#include "interf_dec.h"
#include "interf_enc.h"

typedef enum{
    MType_PCMWave,
    MType_PCMCaf,
    MType_amr,
}MediaType;

typedef struct {
    MediaType type;
    
    // for PCM
    unsigned int bitsPerSample;
    unsigned int sampleRate;
    unsigned int bytesPerSec;
    unsigned int bytesPerFrame;
    unsigned int channels;
    unsigned int pcmdatalength;
    unsigned int pcmHeaderlength;
    unsigned int bigend;
    
    // for Amr
    enum Mode amr_mode;
    
    // for ALL
    float codeTime;
    float lengthwithSenconds;
}AudioInfo;

extern const int sizesdec[];
extern const int sizesenc[];
extern const enum Mode modes[];

void convertAmr2Caf(const char *fileamr, const char *filecaf, AudioInfo* pTypeIn, AudioInfo* pTypeOut);
void convertCaf2Amr(const char *filecaf, const char *fileamr, enum Mode mode, AudioInfo* pTypeIn, AudioInfo* pTypeOut);
#endif

