//
//  UserStatusManager.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-8-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownManager.h"

@interface UserStatusManager : NSObject {
    
}

@property (nonatomic, assign) BOOL mbNotice;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnLoadStatus;
@property (nonatomic, strong) ImageDownManager *mDownManager;

- (void)GetUserStatus:(NSString *)userid;
- (void)Cancel;

@end
