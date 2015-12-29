//
//  JYProfileSetRootController.h
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//
/*
 基于设置界面的根视图 继承自JYBaseController
 */
#import "JYBaseController.h"
#import "JYHttpServeice.h"

#define kSettingCellID @"settingCellID"
#define kSettingHeaderViewHeight 30.0f
#define kSettingFirstHeaderViewHeight 34.0f
#define kSettingCellHeight 44.0f
#define kSettingLogoutBtnYPadding 40.0f
#define kSettingLogoutBtnXPadding 15.0f
#define kSettingCellXPadding 15.0f
//#define kSettingCellLabYPadding 
#define kSettingFooterViewHeight 124.0f
#define kSettingDefaultFont [UIFont systemFontOfSize:14.0f]
#define kSettingDefaultBgColor [JYHelpers setFontColorWithString:@"#edf1f4"] //背景颜色

//为了少建一个控制器，区分通过找回密码进入修改密码和直接通过原密码修改密码
typedef NS_ENUM(NSInteger, JYModifyPwdStyle){
    JYModifyPwdStyleFind,
    JYModifyPwdStyleChange
};

typedef NS_ENUM(NSInteger, JYPrivacyDetailStyle){
    JYPrivacyDetailStyleFriendChat,
    JYPrivacyDetailStyleShowMaterial
};
@interface JYProfileSetRootController : JYBaseController
{
    UITableView *_tableView;
    NSArray *_cellTitleArr;
}
@property (nonatomic, strong) NSArray *cellTitleArr;//用于存储cellTitle
@property (nonatomic, copy) NSString *phoneNum;//存储当前账号的电话
- (void)initTableView;
- (void)initFooterView;

//方便重写
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
