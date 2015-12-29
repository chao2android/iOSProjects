//
//  UserNameViewController.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
#import "ImageDownManager.h"

typedef enum: NSUInteger {
    typeName = 0,
    typeSignature
}InfoSelectType;

@interface UserNameViewController : BaseADViewController
@property (nonatomic, assign) InfoSelectType type;
@property(nonatomic,assign)NSString *theTitleText;
@property(nonatomic,copy)NSString *theContentText;

@property(nonatomic,assign) SEL onSaveClick;
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end
