//
//  UserInfoManager.h
//  好妈妈
//
//  Created by Hepburn Alex on 14-6-25.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject {
    
}

+ (UserInfoManager *)Share;
@property (nonatomic, assign) NSString *mMsgID;

@end
