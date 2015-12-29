//
//  ChatListViewController.h
//  MicroVideo
//
//  Created by iHope on 12-11-19.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpDownManager.h"
#import "RefreshTableView.h"
#import "InputViewController.h"
#import "AudioRecordManager.h"
#import "ChatNewManager.h"

@interface ChatListViewController : InputViewController<UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegate, InputViewControllerDelegate> {
    NSMutableArray *mArray;
    RefreshTableView *mTableView;
    ASIHttpDownManager *mDownManager;
    int miPage;
    TChatType mType;
    UIActivityIndicatorView *mActView;
    int miPlayIndex;
    ChatNewManager *mNewManager;
}

@property (nonatomic, assign) TChatType mType;
@property (nonatomic, retain) NSString *mUserID;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@end
