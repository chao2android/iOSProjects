//
//  CoolDetailViewController.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"
#import "CoolListModel.h"
#import "ImageDownManager.h"
#import "UserStatusManager.h"

#define HIGHT 480
@interface CoolDetailViewController : BaseADViewController<UIScrollViewDelegate, UIAlertViewDelegate> {
    UIScrollView *_scrollView;
    UIAlertView *_alert;
}
@property(nonatomic,strong)CoolListModel *model;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@property(nonatomic,strong)NSString *PictureID;//街拍图片ID;
@property(nonatomic,strong)NSMutableArray *mArray;
@property(nonatomic,assign)int type;//街拍和设计区分
@property(nonatomic,assign)int hasNext;
@property(nonatomic,copy)void(^updateBlock)(int type,NSString *content); //type 修改"喜欢"还是"评论"的个数,content修改的内容
@property(nonatomic,assign) BOOL isReloadComment;
@property (nonatomic, strong) UserStatusManager *mStatusManager;
@end
