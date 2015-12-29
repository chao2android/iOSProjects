//
//  devfs.m
//  FXLabelExample
//
//  Created by WangGaoquan on 12-2-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#include "devfs.h"


KX_FILE_HANDLE devFS_openFile(const char *path, const char *mode){
    return fopen(path, mode);
}

size_t devFS_readFile(KX_FILE_HANDLE fh, void *buffer, size_t length){
    if (fh == KX_INVALID_FILE_HANDLE) {
        return -1;
    }
    return fread(buffer, sizeof(char), length, fh);
}

int devFS_isHandleValid(KX_FILE_HANDLE fh){
    return fh != KX_INVALID_FILE_HANDLE;
}

int devFS_closeFile(KX_FILE_HANDLE fh){
    if (fh == KX_INVALID_FILE_HANDLE) {
        return 0;
    }
    return fclose(fh);
}

int devFS_seek(KX_FILE_HANDLE fh, long offset, int fromwhere){
    if (fh == KX_INVALID_FILE_HANDLE) {
        return -1;
    }
    
    return fseek(fh, offset, fromwhere);
}

size_t devFS_writeFile(KX_FILE_HANDLE fh, void *buffer, size_t length){
    if (fh == KX_INVALID_FILE_HANDLE) {
        return -1;
    }
    
    return fwrite(buffer, sizeof(char), length, fh);
}