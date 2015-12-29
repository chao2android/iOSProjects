//
//  devfs.h
//  FXLabelExample
//
//  Created by WangGaoquan on 12-2-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define     KX_FILE_HANDLE              FILE *
#define     KX_INVALID_FILE_HANDLE      NULL
#define     KX_FOPEN_READ               "rb"
#define     KX_FOPEN_CREATE             "w+"
#define     KX_SEEK_SET                 SEEK_SET

KX_FILE_HANDLE devFS_openFile(const char *path, const char *mode);
int devFS_closeFile(KX_FILE_HANDLE fh);
size_t devFS_readFile(KX_FILE_HANDLE fh, void *buffer, size_t length);
size_t devFS_writeFile(KX_FILE_HANDLE fh, void *buffer, size_t length);
int devFS_seek(KX_FILE_HANDLE fh, long offset, int fromwhere);
int devFS_isHandleValid(KX_FILE_HANDLE fh);
