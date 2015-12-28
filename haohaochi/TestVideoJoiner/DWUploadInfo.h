//
//  DWUploadInfo.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWUploadInfo : NSObject {
    
}

@property (nonatomic, strong) NSString *mTitle;
@property (nonatomic, strong) NSString *mContent;
@property (nonatomic, strong) NSString *mAddress;
@property (nonatomic, strong) NSString *mCityID;
@property (nonatomic, strong) NSString *mThumbPath;
@property (nonatomic, assign) float mLatitude;
@property (nonatomic, assign) float mLongitude;

@end
