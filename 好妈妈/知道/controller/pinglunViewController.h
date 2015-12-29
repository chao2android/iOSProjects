//
//  pinglunViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-16.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "TishiView.h"
#import "MBProgressHUD.h"
#import "EmoKeyboardView.h"
@protocol pinglunViewControllerDelegate <NSObject>

-(void)sendComment:(NSString *)comment;

@end

@interface pinglunViewController : UIViewController<UITextViewDelegate,AnalysisClassDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AnalysisClass * analysis;
  TishiView *_tsView;
  
  MBProgressHUD * HUD;
  
  EmoKeyboardView * emokeyView;
  UIView * inputView;
  BOOL jianpanBool;
  BOOL shareBool;

  UIImageView *sendIV;
  
  UIImageView *imagebgView;
  
  NSMutableDictionary * asiDictiong;
  UITableView *_uitable;
    NSMutableArray * _shareTypeArray;
  
}
@property (retain,nonatomic)NSMutableArray * shareArray;


@property (nonatomic,retain) NSString * commentID;
@property (nonatomic,retain) NSString * cID;

@property (nonatomic,assign) id <pinglunViewControllerDelegate>delegate;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIPopoverController *uiPopoverController;

@end
