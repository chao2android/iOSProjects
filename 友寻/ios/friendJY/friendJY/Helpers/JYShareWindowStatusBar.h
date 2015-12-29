//
//  ShareWindowStatusBar.h
//  JiaYuan
//
//  Created by HsiuJane Sang on 10/25/11.
//  Copyright (c) 2011 JiaYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYShareWindowStatusBar : UIWindow {

    UILabel *showLabel;
    UIButton *actionBtn;
}
@property (nonatomic,strong)UIButton *actionBtn;
@property (nonatomic,strong)UILabel *showLabel;
-(void)showStatusWithMessage:(NSString*)msg;
-(void)hideStatus;

-(void)showActionBtnWithMessage:(NSString*)msg;
-(void)hideActionBtn;
@end
