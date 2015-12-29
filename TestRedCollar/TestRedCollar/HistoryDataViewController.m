//
//  HistoryDataViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HistoryDataViewController.h"
#import "HistoryDataCell.h"
#import "JSON.h"
#import "AutoAlertView.h"
#import "HistoryDataModel.h"

@interface HistoryDataViewController ()
{
    UITableView *mTableView;
}
@end

@implementation HistoryDataViewController

@synthesize mDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"历史数据";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    

    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"我的量体数据";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height-84)];
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, backView.bounds.size.width, backView.bounds.size.height-35)];
    mTableView.delegate = self;
    mTableView.dataSource =self;
    [backView addSubview:mTableView];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    mLabel.text = [NSString stringWithFormat:@"%@顾客的数据：",mDict[@"user_name"]];
    mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.textColor = [UIColor darkGrayColor];
    [backView addSubview:mLabel];
    
//    int num = 0;
//    for (int i = 0; i<3; i++) {
//        for (int j = 0; j<7; j++) {
//            double w = 100;
//            double h = 25;
//            double x = 5+i*w;
//            double y = 40+j*h;
//            mLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
//            mLabel.font = [UIFont systemFontOfSize:13];
//            mLabel.textColor = WORDGRAYCOLOR;
//            [backView addSubview:mLabel];
//            if (num == 0) {
//                mLabel.text = [NSString stringWithFormat:@"领围:%@CM",mDict[@"lw"]];
//            }
//            else if (num == 1) {
//                mLabel.text = [NSString stringWithFormat:@"胸围:%@CM",mDict[@"xw"]];
//            }
//            else if (num == 2) {
//                mLabel.text = [NSString stringWithFormat:@"中腰围:%@CM",mDict[@"zyw"]];
//            }
//            else if (num == 3) {
//                mLabel.text = [NSString stringWithFormat:@"臀围:%@CM",mDict[@"tw"]];
//            }
//            else if (num == 4) {
//                mLabel.text = [NSString stringWithFormat:@"上臀围:%@CM",mDict[@"stw"]];
//            }
//            else if (num == 5) {
//                mLabel.text = [NSString stringWithFormat:@"总肩宽:%@CM",mDict[@"zjk"]];
//            }
//            else if (num == 6) {
//                mLabel.text = [NSString stringWithFormat:@"右袖长:%@CM",mDict[@"yxc"]];
//            }
//            else if (num == 7) {
//                mLabel.text = [NSString stringWithFormat:@"左袖长:%@CM",mDict[@"zxc"]];
//            }
//            else if (num == 8) {
//                mLabel.text = [NSString stringWithFormat:@"前肩宽:%@CM",mDict[@"qjk"]];
//            }
//            else if (num == 9) {
//                mLabel.text = [NSString stringWithFormat:@"后衣长:%@CM",mDict[@"hyc"]];
//            }
//            else if (num == 10) {
//                mLabel.text = [NSString stringWithFormat:@"腰围:%@CM",mDict[@"yw"]];
//            }
//            else if (num == 11) {
//                mLabel.text = [NSString stringWithFormat:@"通档:%@CM",mDict[@"td"]];
//            }
//            else if (num == 12) {
//                mLabel.text = [NSString stringWithFormat:@"后腰高:%@CM",mDict[@"hyg"]];
//            }
//            else if (num == 13) {
//                mLabel.text = [NSString stringWithFormat:@"前腰高:%@CM",mDict[@"qyg"]];
//            }
//            else if (num == 14) {
//                mLabel.text = [NSString stringWithFormat:@"裤口:%@CM",mDict[@"kk"]];
//            }
//            else if (num == 15) {
//                mLabel.text = [NSString stringWithFormat:@"后腰节:%@CM",mDict[@"hyjc"]];
//            }
//            else if (num == 16) {
//                mLabel.text = [NSString stringWithFormat:@"前腰节:%@CM",mDict[@"qyj"]];
//            }
//            else if (num == 17) {
//                mLabel.text = [NSString stringWithFormat:@"腿根围:%@CM",mDict[@"tgw"]];
//            }
//            else if (num == 18) {
//                mLabel.text = [NSString stringWithFormat:@"左裤长:%@CM",mDict[@"zkc"]];
//            }
//            else if (num == 19) {
//                mLabel.text = [NSString stringWithFormat:@"右裤长:%@CM",mDict[@"ykc"]];
//            }
//            else if (num == 20) {
//                mLabel.text = [NSString stringWithFormat:@"膝围:%@CM",mDict[@"xw"]];
//            }
//            num++;
//        }
//    }
    
    
                       
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    mLabel.textColor = [UIColor darkGrayColor];
    mLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        mLabel.text = [NSString stringWithFormat:@"领围:%@CM",mDict[@"lw"]];
    }
    else if (indexPath.row == 1) {
        mLabel.text = [NSString stringWithFormat:@"胸围:%@CM",mDict[@"xw"]];
    }
    else if (indexPath.row == 2) {
        mLabel.text = [NSString stringWithFormat:@"中腰围:%@CM",mDict[@"zyw"]];
    }
    else if (indexPath.row == 3) {
        mLabel.text = [NSString stringWithFormat:@"臀围:%@CM",mDict[@"tw"]];
    }
    else if (indexPath.row == 4) {
        mLabel.text = [NSString stringWithFormat:@"上臀围:%@CM",mDict[@"stw"]];
    }
    else if (indexPath.row == 5) {
        mLabel.text = [NSString stringWithFormat:@"总肩宽:%@CM",mDict[@"zjk"]];
    }
    else if (indexPath.row == 6) {
        mLabel.text = [NSString stringWithFormat:@"右袖长:%@CM",mDict[@"yxc"]];
    }
    else if (indexPath.row == 7) {
        mLabel.text = [NSString stringWithFormat:@"左袖长:%@CM",mDict[@"zxc"]];
    }
    else if (indexPath.row == 8) {
        mLabel.text = [NSString stringWithFormat:@"前肩宽:%@CM",mDict[@"qjk"]];
    }
    else if (indexPath.row == 9) {
        mLabel.text = [NSString stringWithFormat:@"后衣长:%@CM",mDict[@"hyc"]];
    }
    else if (indexPath.row == 10) {
        mLabel.text = [NSString stringWithFormat:@"腰围:%@CM",mDict[@"yw"]];
    }
    else if (indexPath.row == 11) {
        mLabel.text = [NSString stringWithFormat:@"通档:%@CM",mDict[@"td"]];
    }
    else if (indexPath.row == 12) {
        mLabel.text = [NSString stringWithFormat:@"后腰高:%@CM",mDict[@"hyg"]];
    }
    else if (indexPath.row == 13) {
        mLabel.text = [NSString stringWithFormat:@"前腰高:%@CM",mDict[@"qyg"]];
    }
    else if (indexPath.row == 14) {
        mLabel.text = [NSString stringWithFormat:@"裤口:%@CM",mDict[@"kk"]];
    }
    else if (indexPath.row == 15) {
        mLabel.text = [NSString stringWithFormat:@"后腰节:%@CM",mDict[@"hyjc"]];
    }
    else if (indexPath.row == 16) {
        mLabel.text = [NSString stringWithFormat:@"前腰节:%@CM",mDict[@"qyj"]];
    }
    else if (indexPath.row == 17) {
        mLabel.text = [NSString stringWithFormat:@"腿根围:%@CM",mDict[@"tgw"]];
    }
    else if (indexPath.row == 18) {
        mLabel.text = [NSString stringWithFormat:@"左裤长:%@CM",mDict[@"zkc"]];
    }
    else if (indexPath.row == 19) {
        mLabel.text = [NSString stringWithFormat:@"右裤长:%@CM",mDict[@"ykc"]];
    }
    else if (indexPath.row == 20) {
        mLabel.text = [NSString stringWithFormat:@"膝围:%@CM",mDict[@"xw"]];
    }
    [cell.contentView addSubview:mLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
- (void)dealloc {
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownmanager);
}

- (void)StartDownload {
    if (_mDownmanager) {
        return;
    }
    [self StartLoading];
    
    _mDownmanager = [[ImageDownManager alloc] init];
    _mDownmanager.delegate = self;
    _mDownmanager.OnImageDown = @selector(OnLoadFinish:);
    _mDownmanager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@order.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //rctailor.ec51.com.cn/soaapi/soap/order.php?act=getFigure&token=ae9798f58888486ac828bf25f4b8297a
    [dict setObject:@"getFigure" forKey:@"act"];
    //[dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"ae9798f58888486ac828bf25f4b8297a" forKey:@"token"];
    [_mDownmanager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        if ([dict objectForKey:@"msg"]) {
            NSString *msg = [dict objectForKey:@"msg"];
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
        else{
            HistoryDataModel *model =[[HistoryDataModel alloc]init];
            for (NSString *key in dict) {
                [model setValue:dict[key] forKey:key];
            }
            [self.mArray addObject:model];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    HistoryDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HistoryDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.mImageView.hidden = (indexPath.row != gHistoryIndex);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    gHistoryIndex = indexPath.row;
    [self GoBack];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
