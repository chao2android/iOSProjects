//
//  MyCustomDetailViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-22.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
@interface MyCustomDetailViewController : BaseADViewController<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
}
@property (copy,nonatomic) NSString *rec_id;
@property (copy,nonatomic) NSString *IDStr;

- (void)StartDownload;

@end
