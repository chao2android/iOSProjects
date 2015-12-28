//
//  TJRegistViewController.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseViewController.h"

typedef NS_ENUM(NSInteger, PageType){
    PageType_Register,
    PageType_Forget,
    PageType_Bind
};
typedef enum {
    Page_Push=0,
    Page_Present_Por,
    Page_Present_Land
}LoginPageType;

@interface TJRegistViewController : TJBaseViewController

@property (nonatomic,assign) PageType pageType;
@property (nonatomic, assign)LoginPageType  enterloginType;

-(instancetype)init:(PageType)verifyType;

@end
