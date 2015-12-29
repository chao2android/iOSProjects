//
//  JYContactSearchView.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/27.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPhoneContactsModel;
@class JYContactSearchView;
/**
 *  通讯录搜索视图协议
 */
@protocol JYContactSearchViewDelegate<NSObject>

@required
/**
 *  搜索完成
 *
 *  @param contactsView 搜索视图
 *  @param contact      选择的通讯录联系人
 */
- (void)contactSearchView:(JYContactSearchView*)contactsView didFinishedSearchWithContactsModel:(JYPhoneContactsModel*)contact;
/**
 *  取消搜索
 *
 *  @param contactSearchView 搜索视图
 *
 */
- (void)contactSearchViewShouldCancelSearch:(JYContactSearchView*)contactSearchView;

@end

@interface JYContactSearchView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    @private
    UITableView *_contactsTableView;
    UITextField *_searchTextField;
    NSMutableArray *_siftContactsList;
    UILabel *noResultLab;
}
/**
 *  手机联系人
 */
@property (nonatomic, strong) NSArray *contactsList;
/**
 *  搜索视图代理
 */
@property (nonatomic, assign) id<JYContactSearchViewDelegate>delegate;
/**
 *  进入搜索视图的时候调用开始编辑
 */
- (void)beginEdit;

@end





