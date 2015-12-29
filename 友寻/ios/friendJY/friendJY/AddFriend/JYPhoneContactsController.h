//
//  JYPhoneContactsController.h
//  friendJY
//
//  Created by 高斌 on 15/3/9.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import <MessageUI/MessageUI.h>
//#import <CoreTelephony/CTCarrier.h>

@interface JYPhoneContactsController : JYBaseController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MFMessageComposeViewControllerDelegate>
{
    UITableView *_table;
    NSMutableArray *_selectedContactsIndexList;
//    UILabel *_selectedNameLab;
    UIButton *_inviteBtn;
}
//@property (nonatomic, assign) BOOL isUpList;
@property (nonatomic, assign) NSInteger friendNum;
@end
