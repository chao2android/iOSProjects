//
//  HistoryDataViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyHistoryDataViewController.h"
#import "HistoryDataCell.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "AutoAlertView.h"
#import "HistoryDataModel.h"

@interface MyHistoryDataViewController ()
{
    UITableView *mTableView;
    ImageDownManager *_mDownmanager;
    ImageDownManager *_sDownmanager;
    UILabel *_nameLabel;
    NSDictionary *_sDict;
}
@end

@implementation MyHistoryDataViewController

@synthesize mDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sDict = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"我的量体数据";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    
    [self StartDownload];
    /*
    int num = 0;
    for (int i = 0; i<3; i++) {
        for (int j = 0; j<7; j++) {
            double w = 100;
            double h = 25;
            double x = 5+i*w;
            double y = 40+j*h;
            mLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
            mLabel.font = [UIFont systemFontOfSize:13];
            mLabel.textColor = WORDGRAYCOLOR;
            [backView addSubview:mLabel];
            if (num == 0) {
                mLabel.text = [NSString stringWithFormat:@"领围:%@CM",mDict[@"lw"]];
            }
            else if (num == 1) {
                mLabel.text = [NSString stringWithFormat:@"胸围:%@CM",mDict[@"xw"]];
            }
            else if (num == 2) {
                mLabel.text = [NSString stringWithFormat:@"中腰围:%@CM",mDict[@"zyw"]];
            }
            else if (num == 3) {
                mLabel.text = [NSString stringWithFormat:@"臀围:%@CM",mDict[@"tw"]];
            }
            else if (num == 4) {
                mLabel.text = [NSString stringWithFormat:@"上臀围:%@CM",mDict[@"stw"]];
            }
            else if (num == 5) {
                mLabel.text = [NSString stringWithFormat:@"总肩宽:%@CM",mDict[@"zjk"]];
            }
            else if (num == 6) {
                mLabel.text = [NSString stringWithFormat:@"右袖长:%@CM",mDict[@"yxc"]];
            }
            else if (num == 7) {
                mLabel.text = [NSString stringWithFormat:@"左袖长:%@CM",mDict[@"zxc"]];
            }
            else if (num == 8) {
                mLabel.text = [NSString stringWithFormat:@"前肩宽:%@CM",mDict[@"qjk"]];
            }
            else if (num == 9) {
                mLabel.text = [NSString stringWithFormat:@"后衣长:%@CM",mDict[@"hyc"]];
            }
            else if (num == 10) {
                mLabel.text = [NSString stringWithFormat:@"腰围:%@CM",mDict[@"yw"]];
            }
            else if (num == 11) {
                mLabel.text = [NSString stringWithFormat:@"通档:%@CM",mDict[@"td"]];
            }
            else if (num == 12) {
                mLabel.text = [NSString stringWithFormat:@"后腰高:%@CM",mDict[@"hyg"]];
            }
            else if (num == 13) {
                mLabel.text = [NSString stringWithFormat:@"前腰高:%@CM",mDict[@"qyg"]];
            }
            else if (num == 14) {
                mLabel.text = [NSString stringWithFormat:@"裤口:%@CM",mDict[@"kk"]];
            }
            else if (num == 15) {
                mLabel.text = [NSString stringWithFormat:@"后腰节:%@CM",mDict[@"hyjc"]];
            }
            else if (num == 16) {
                mLabel.text = [NSString stringWithFormat:@"前腰节:%@CM",mDict[@"qyj"]];
            }
            else if (num == 17) {
                mLabel.text = [NSString stringWithFormat:@"腿根围:%@CM",mDict[@"tgw"]];
            }
            else if (num == 18) {
                mLabel.text = [NSString stringWithFormat:@"左裤长:%@CM",mDict[@"zkc"]];
            }
            else if (num == 19) {
                mLabel.text = [NSString stringWithFormat:@"右裤长:%@CM",mDict[@"ykc"]];
            }
            else if (num == 20) {
                mLabel.text = [NSString stringWithFormat:@"膝围:%@CM",mDict[@"xw"]];
            }
            num++;
        }
    }
    */
    
                       
}

- (void)dealloc {
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownmanager);
    SAFE_CANCEL_ARC(_sDownmanager);
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
    [dict setObject:@"getFigure" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
//    [dict setObject:@"ae9798f58888486ac828bf25f4b8297a" forKey:@"token"];
    [_mDownmanager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"----->%@", dict);
        if ([dict objectForKey:@"msg"]) {
            NSString *msg = [dict objectForKey:@"msg"];
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
        else{
            self.mDict = dict;
            //[self selfCreateUI];
            [self DwonloadSe];
        }
    }
}
- (void)DwonloadSe{
    if (_sDownmanager) {
        return;
    }
    [self StartLoading];
    //http://www.rctailor.com/soaapi/soap/service.php?act=info&idserve=5
    _sDownmanager = [[ImageDownManager alloc] init];
    _sDownmanager.delegate = self;
    _sDownmanager.OnImageDown = @selector(OnDLoadFinish:);
    _sDownmanager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@service.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"info" forKey:@"act"];
    [dict setObject:self.mDict[@"idserve"] forKey:@"idserve"];
    [_sDownmanager PostHttpRequest:urlstr :dict];
}
- (void)OnDLoadFinish:(ImageDownManager *)sender{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"----->%@", dict);
        if ([dict objectForKey:@"msg"]) {
            NSString *msg = [dict objectForKey:@"msg"];
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
        else{
            _sDict = dict;
            [self selfCreateUI];
        }
    }
}
- (void)selfCreateUI{
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, self.view.bounds.size.height-114)];
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 25)];
    _nameLabel.text = [NSString stringWithFormat:@"%@顾客的数据：",mDict[@"user_name"]];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:_nameLabel];
    
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, backView.bounds.size.width, backView.bounds.size.height-35)];
    mTableView.delegate = self;
    mTableView.dataSource =self;
    [backView addSubview:mTableView];
    [mTableView reloadData];
    
    backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height-104+10, self.view.bounds.size.width-20, 84)];
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 130, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor blackColor];
    mLabel.text = @"数据录入时间：";
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 23, 130, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor blackColor];
    mLabel.text = @"服务点名称：";
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 43, 130, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor blackColor];
    mLabel.text = @"地址：";
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 63, 130, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor blackColor];
    mLabel.text = @"电话：";
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 3, self.view.bounds.size.width-120, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:12];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor darkGrayColor];
    mLabel.text = self.mDict[@"create_date"];
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 23, self.view.bounds.size.width-120, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:12];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor darkGrayColor];
    mLabel.text = _sDict[@"company_name"];
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 43, self.view.bounds.size.width-120, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:12];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor darkGrayColor];
    mLabel.text = _sDict[@"serve_address"];
    [backView addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 63, self.view.bounds.size.width-120, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:12];
    mLabel.textAlignment= NSTextAlignmentLeft;
    mLabel.textColor = [UIColor darkGrayColor];
    mLabel.text = _sDict[@"mobile"];
    [backView addSubview:mLabel];
    
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
