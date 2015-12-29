//
//  FabuViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyncImageView;
#import "EmoKeyboardView.h"
#import "AnalysisClass.h"
@class TishiView;
@interface FabuViewController : UIViewController<UIActionSheetDelegate,AnalysisClassDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_shareTypeArray;
    EmoKeyboardView * emokeyView;
    AnalysisClass * analysis;
    UIImageView * backImageView;
    UIView * inputView;
    UITableView * myTableView;
    BOOL tableviewBool;
    int tableviewselecell;
    BOOL jianpanBool;
    UIView * aView;


}
@property (retain,nonatomic)NSMutableArray * shareArray;
@property (retain,nonatomic)TishiView * tishiView;
@property (retain,nonatomic)AsyncImageView *playImageView;
@property (retain,nonatomic)NSMutableDictionary *oldDictionary;
@property (retain,nonatomic)UITextField * biaotiTextField;
@property (retain,nonatomic)UITextView * contentTextView;
@property (retain,nonatomic)AsyncImageView * touxiangImageView;
@property (retain,nonatomic)NSMutableDictionary * tableviewDic;
@end
