//
//  MoneyHomeView.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MoneyHomeView.h"
#import "MoneyRecordCell.h"
#import "ExchangeListCell.h"
#import "HowGetMoneyCell.h"
#import "ExchangeInfoViewController.h"

@implementation MoneyHomeView

//酷特币
-(void)onMoneyClick{
    if (isShowMoney) {
        return;
    }
    isShowMoney=YES;
    [_moneyButton setImage:[UIImage imageNamed:@"128_2"] forState:UIControlStateNormal];
    [_integralButton setImage:[UIImage imageNamed:@"129"] forState:UIControlStateNormal];
    
    [self refreshTheData];
}

//积分
-(void)onIntegralClick{
    if (!isShowMoney) {
        return;
    }
    isShowMoney=NO;
    [_moneyButton setImage:[UIImage imageNamed:@"128"] forState:UIControlStateNormal];
    [_integralButton setImage:[UIImage imageNamed:@"129_2"] forState:UIControlStateNormal];
    
    [self refreshTheData];
}

-(void)loadMyInfoView{
    //头像
    UIButton *tButton=[UIButton buttonWithType:UIButtonTypeCustom];
    tButton.frame=CGRectMake((theTopImageView.frame.size.width-57)/2, 7, 57, 57);
    [tButton setImage:[UIImage imageNamed:@"127"] forState:UIControlStateNormal];
    tButton.adjustsImageWhenHighlighted=NO;
    //    [tButton addTarget:self action:@selector(onMyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [theTopImageView addSubview:tButton];
    
    //姓名
    theNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, tButton.frame.origin.y+tButton.frame.size.height+2, theTopImageView.frame.size.width, 23)];
    theNameLabel.backgroundColor=[UIColor clearColor];
    theNameLabel.textAlignment=UITextAlignmentCenter;
    theNameLabel.textColor=[UIColor whiteColor];
    theNameLabel.font=[UIFont boldSystemFontOfSize:18];
    theNameLabel.text=@"李元芳";
    [theTopImageView addSubview:theNameLabel];
    
    //酷特币
    _moneyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _moneyButton.frame=CGRectMake(0, 0, 103, theTopImageView.frame.size.height);
    [_moneyButton setImage:[UIImage imageNamed:@"128_2"] forState:UIControlStateNormal];
    _moneyButton.adjustsImageWhenHighlighted=NO;
    [_moneyButton addTarget:self action:@selector(onMoneyClick) forControlEvents:UIControlEventTouchDown];
    [theTopImageView addSubview:_moneyButton];
    
    //积分
    _integralButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _integralButton.frame=CGRectMake(theTopImageView.frame.size.width-103, 0, 103, theTopImageView.frame.size.height);
    [_integralButton setImage:[UIImage imageNamed:@"129"] forState:UIControlStateNormal];
    _integralButton.adjustsImageWhenHighlighted=NO;
    [_integralButton addTarget:self action:@selector(onIntegralClick) forControlEvents:UIControlEventTouchDown];
    [theTopImageView addSubview:_integralButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        theTopImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 90)];
        theTopImageView.image=[UIImage imageNamed:@"130"];
        theTopImageView.userInteractionEnabled=YES;
        [self addSubview:theTopImageView];
        
        //酷特币/积分
        isShowMoney=YES;
        //个人信息
        [self loadMyInfoView];
        
        //收入/消费/兑换/如何
        UIImageView *tImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, theTopImageView.frame.size.height, self.frame.size.width, 41)];
        tImageView.userInteractionEnabled = YES;
        tImageView.image = [UIImage imageNamed:@"82.png"];
        [self addSubview:tImageView];
        
        NSArray *tNameList=@[@131,@134,@133,@132];
        int iWidth = frame.size.width/4;
        for (int i = 0; i < 4; i ++) {
            NSString *imagename = [NSString stringWithFormat:@"%d.png", [tNameList[i] integerValue]];
            NSString *imagename2 = [NSString stringWithFormat:@"%d_2.png", [tNameList[i] integerValue]];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(iWidth*i+(iWidth-62)/2, 0, 62, 40);
            btn.tag = i+33000;
            btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imagename2] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(OnTabSelect:) forControlEvents:UIControlEventTouchUpInside];
            [tImageView addSubview:btn];
            if (i == 0) {
                mSelectBtn = btn;
                [mSelectBtn setSelected:YES];
            }
        }
        
        iCurType=0;
        
        _theList=[[NSMutableArray alloc] init];
        
        int iTop=tImageView.frame.origin.y+tImageView.frame.size.height;
        int iHeight=self.frame.size.height-iTop;
        
        _theTable=[[UITableView alloc] initWithFrame:CGRectMake(0, iTop, self.frame.size.width, iHeight) style:UITableViewStylePlain];
        _theTable.backgroundColor=[UIColor clearColor];
        _theTable.delegate=self;
        _theTable.dataSource=self;
        _theTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:_theTable];
        
        [self loadShouRu];
        
    }
    return self;
}

- (void)OnTabSelect:(UIButton *)sender {
    int index = sender.tag-33000;
    if (iCurType == index) {
        return;
    }
    
    iCurType=index;
    
    [mSelectBtn setSelected:NO];
    mSelectBtn = sender;
    [mSelectBtn setSelected:YES];
    
    [self refreshTheData];
    
}

-(void)refreshTheData{
    [_theList removeAllObjects];
    [_theTable reloadData];
    
    switch (iCurType) {
        case 0:
        {
            //收入
            [self loadShouRu];
        }
            break;
        case 1:
        {
            //消费
            [self loadXiaoFei];
        }
            break;
        case 2:
        {
            //兑换
            [self loadDuiHuan];
        }
            break;
        case 3:
        {
            //如何
            [self loadHow];
        }
            break;
        default:
            break;
    }
    
    [_theTable reloadData];
}

//收入
-(void)loadShouRu{
    if (isShowMoney) {
        //币
        [_theList addObject:@{@"one":@"时间",@"two":@"动作",@"three":@"酷特币"}];
        [_theList addObject:@{@"one":@"2013-12-08",@"two":@"手机邮箱认证成功",@"three":@"20"}];
        [_theList addObject:@{@"one":@"2013-12-08",@"two":@"每日登录",@"three":@"10"}];
        [_theList addObject:@{@"one":@"2013-12-25",@"two":@"邀请好友注册",@"three":@"50"}];
        [_theList addObject:@{@"one":@"2014-01-17",@"two":@"拍照上传",@"three":@"60"}];
        [_theList addObject:@{@"one":@"2014-02-19",@"two":@"设计被推荐",@"three":@"200"}];
        [_theList addObject:@{@"one":@"2014-02-20",@"two":@"设计被推荐",@"three":@"200"}];
        [_theList addObject:@{@"one":@"2014-02-26",@"two":@"设计被推荐",@"three":@"200"}];
    }else{
        //分
        [_theList addObject:@{@"one":@"时间",@"two":@"动作",@"three":@"积分"}];
        [_theList addObject:@{@"one":@"2013-12-08",@"two":@"手机邮箱认证成功",@"three":@"20"}];
        [_theList addObject:@{@"one":@"2013-12-08",@"two":@"每日登录",@"three":@"10"}];
        [_theList addObject:@{@"one":@"2013-12-25",@"two":@"邀请好友注册",@"three":@"50"}];
        [_theList addObject:@{@"one":@"2014-01-17",@"two":@"拍照上传",@"three":@"60"}];
        [_theList addObject:@{@"one":@"2014-02-19",@"two":@"设计被推荐",@"three":@"200"}];
        [_theList addObject:@{@"one":@"2014-02-20",@"two":@"设计被推荐",@"three":@"200"}];
        [_theList addObject:@{@"one":@"2014-02-26",@"two":@"设计被推荐",@"three":@"200"}];
    }
}

//消费
-(void)loadXiaoFei{
    if (isShowMoney) {
        //币
        [_theList addObject:@{@"one":@"时间",@"two":@"动作",@"three":@"酷特币"}];
        [_theList addObject:@{@"one":@"2013-12-18",@"two":@"定制西服1",@"three":@"20000"}];
        [_theList addObject:@{@"one":@"2013-12-18",@"two":@"定制西服2",@"three":@"20000"}];
        [_theList addObject:@{@"one":@"2013-12-21",@"two":@"定制西服3",@"three":@"20000"}];
        [_theList addObject:@{@"one":@"2014-02-17",@"two":@"定制西服4",@"three":@"20000"}];
        [_theList addObject:@{@"one":@"2014-02-22",@"two":@"定制西服5",@"three":@"20000"}];
        [_theList addObject:@{@"one":@"2014-02-23",@"two":@"定制西服6",@"three":@"20000"}];
        [_theList addObject:@{@"one":@"2014-02-25",@"two":@"定制西服7",@"three":@"20000"}];
    }else{
        //分
        [_theList addObject:@{@"one":@"时间",@"two":@"动作",@"three":@"积分"}];
        [_theList addObject:@{@"one":@"2013-12-18",@"two":@"定制西服1",@"three":@"30000"}];
        [_theList addObject:@{@"one":@"2013-12-18",@"two":@"定制西服2",@"three":@"30000"}];
        [_theList addObject:@{@"one":@"2013-12-21",@"two":@"定制西服3",@"three":@"30000"}];
        [_theList addObject:@{@"one":@"2014-02-17",@"two":@"定制西服4",@"three":@"30000"}];
        [_theList addObject:@{@"one":@"2014-02-22",@"two":@"定制西服5",@"three":@"30000"}];
        [_theList addObject:@{@"one":@"2014-02-23",@"two":@"定制西服6",@"three":@"30000"}];
        [_theList addObject:@{@"one":@"2014-02-25",@"two":@"定制西服7",@"three":@"30000"}];
    }
}

//兑换
-(void)loadDuiHuan{
    NSArray *tList=@[@"精美条纹领带",@"精美方纹领带",@"精美波点领带",@"精美波点领带",@"精美蓝宝石袖扣",@"纯手工皮包"];
    for (int i=0; i<tList.count; i++) {
        [_theList addObject:@{@"logo":[NSString stringWithFormat:@"%d",139+i],
                              @"name":tList[i],
                              @"money":@"需酷特币: 12000",
                              @"count":[NSString stringWithFormat:@"%d",i%2]}];
    }
}

//如何
-(void)loadHow{
    if (isShowMoney) {
        //币
        [_theList addObject:@{@"one":@"动作",@"two":@"酷特币"}];
        [_theList addObject:@{@"one":@"手机邮箱认证成功",@"two":@"20"}];
        [_theList addObject:@{@"one":@"每日登录",@"two":@"10"}];
        [_theList addObject:@{@"one":@"邀请好友注册",@"two":@"50"}];
        [_theList addObject:@{@"one":@"拍照上传",@"two":@"60"}];
        [_theList addObject:@{@"one":@"设计被推荐",@"two":@"200"}];
    }else{
        //分
        [_theList addObject:@{@"one":@"动作",@"two":@"积分"}];
        [_theList addObject:@{@"one":@"手机邮箱认证成功",@"two":@"200"}];
        [_theList addObject:@{@"one":@"每日登录",@"two":@"100"}];
        [_theList addObject:@{@"one":@"邀请好友注册",@"two":@"500"}];
        [_theList addObject:@{@"one":@"拍照上传",@"two":@"600"}];
        [_theList addObject:@{@"one":@"设计被推荐",@"two":@"2000"}];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (iCurType == 2) {
        int iCount=_theList.count/3;
        if (_theList.count%3) {
            iCount++;
        }
        return iCount;
    }
    return _theList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //行高
    if(iCurType == 2){
        return  161;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iCurType == 0 || iCurType == 1) {
        //酷吧
        static NSString *CellIdentifier = @"Cell00";
        MoneyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyRecordCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell resetInfoDict:_theList[indexPath.row]];
        if (indexPath.row%2) {
            //白色
            cell.backgroundColor=[UIColor whiteColor];
        }else{
            cell.backgroundColor=[UIColor colorWithWhite:0.83 alpha:1.0];
        }
        return cell;
    }else if(iCurType == 2){
        //订单
        static NSString *CellIdentifier = @"Cell02";
        ExchangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeListCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
            cell.onButtonClick=@selector(onExchangeButtonClick:);
            cell.onInfoClick=@selector(onExchangeInfoClick:);
        }
        [cell resetInfoIndex:indexPath.row*3 list:_theList];
        return cell;
    }else if(iCurType == 3){
        //订单
        static NSString *CellIdentifier = @"Cell03";
        HowGetMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HowGetMoneyCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [cell resetInfoDict:_theList[indexPath.row]];
        if (indexPath.row%2) {
            //白色
            cell.backgroundColor=[UIColor whiteColor];
        }else{
            cell.backgroundColor=[UIColor colorWithWhite:0.83 alpha:1.0];
        }
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

//兑换click
-(void)onExchangeButtonClick:(NSNumber*)aNum{
    [self showMsg:@"兑换成功"];
}

//兑换详情click
-(void)onExchangeInfoClick:(NSNumber*)aNum{
    NSDictionary *dict=_theList[aNum.integerValue];
    ExchangeInfoViewController *tViewCtr=[[ExchangeInfoViewController alloc] init];
    tViewCtr.theInfoName=dict[@"name"];
    [self.mRootCtrl.navigationController pushViewController:tViewCtr animated:YES];
}

@end
