//
//  contentViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-11.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pinglunViewController.h"
#import "AnalysisClass.h"
#import "TishiView.h"

#import "PullingRefreshTableView.h"

#import "ImageTextLabel.h"
#import "IBActionSheet.h"

#import "MBProgressHUD.h"

#import "AudioPlayer.h"
#import "NCMusicEngine.h"

@interface contentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,pinglunViewControllerDelegate,AnalysisClassDelegate,UIActionSheetDelegate,IBActionSheetDelegate,NCMusicEngineDelegate>{

  AudioPlayer *_audioPlayer;
    NCMusicEngine *_player;

  PullingRefreshTableView *_uitable;
  NSMutableDictionary *_muDic;
  
  NSMutableArray *_muArr;
  NSMutableArray *_muUserArr;

  
  ImageTextLabel *titLab;
  UIButton *starBut;
  BOOL isStar;
  BOOL isZan;
  
    AnalysisClass * analysis;
  
  MBProgressHUD * myHUD;

  
  int page;
}

@property (nonatomic ,retain )NSString *contentID;

@end
