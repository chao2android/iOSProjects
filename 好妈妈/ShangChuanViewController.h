//
//  ShangChuanViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-18.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "AsyncImageView.h"
@class TishiView;
@interface ShangChuanViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,AnalysisClassDelegate,UITextViewDelegate>
{
    AsyncImageView * touxiangImageView;
    UIView * tiaojianView;
    UIImageView * backImageView;
    UITextView * smTextView;
    AnalysisClass * analysis;
    int gongkai;
    TishiView * tishiView;
}
@property (retain,nonatomic)NSMutableArray * shareArray;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic)NSMutableArray * shareTypeArray;

@end
