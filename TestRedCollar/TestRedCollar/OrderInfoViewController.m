//
//  OrderInfoViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderTrackViewController.h"
//#import "CustomDetailViewController.h"
#import "CartItemList.h"
#import "NetImageView.h"
#import "PayViewController.h"

@interface OrderInfoViewController ()
{
    UIScrollView *mScrollView;
    UITableView *myTableView;
    int iHeight;
}

@end

@implementation OrderInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"self.list--->%@",self.list.source_from);
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"订单详情";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.contentSize = CGSizeMake(320, 560+70*_list.cartItemArr.count);
    mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mScrollView];
    
    [self orderInfoView];
    [self priceDetailView];
    [self clothesDetailView];
    [self userDetailView];
    [self payModeView];
    [self sendWayView];
    //[self invoiceInfoView];
}

- (void)orderInfoView
{
    UIImageView *statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 320, 64)];
    statusImage.image = [UIImage imageNamed:@"my_50.png"];
    statusImage.backgroundColor = [UIColor clearColor];
    [mScrollView addSubview:statusImage];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 22)];
    statusLabel.backgroundColor = [UIColor clearColor];
    
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textColor = WORDGRAYCOLOR;
    [statusImage addSubview:statusLabel];
    
    if ([_list.orderStatus integerValue] == 0) {
        statusLabel.text = @"订单状态：已付款";
    }else if ([_list.orderStatus integerValue] == 1) {
        statusLabel.text = @"订单状态：未付款";
    }else if ([_list.orderStatus integerValue] == 2) {
        statusLabel.text = @"订单状态：已取消";
    }else if ([_list.orderStatus integerValue] == 3) {
        statusLabel.text = @"订单状态：完成";
    }
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 32, 200, 22)];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.text = [NSString stringWithFormat:@"订单号：%@",_list.orderCode];
    numLabel.textColor = WORDGRAYCOLOR;
    numLabel.font = [UIFont systemFontOfSize:14];
    [statusImage addSubview:numLabel];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(240, 29, 63, 30);
    [payBtn setBackgroundImage:[UIImage imageNamed:@"3_51.png"] forState:UIControlStateNormal];
    payBtn.hidden = YES;
    [payBtn setTitle:@"去付款" forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [payBtn addTarget:self action:@selector(PayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mScrollView addSubview:payBtn];
    if ([self.list.source_from isEqualToString:@"app"] || [self.list.source_from isEqualToString:@"wap"]) {
        payBtn.hidden =(![_list.orderStatus integerValue] == 1);
    }
    
//    //跟踪
//    UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    tButton.frame = CGRectMake(240, 29, 71, 30);
//    [tButton setBackgroundImage:[UIImage imageNamed:@"button_track"] forState:UIControlStateNormal];
//    [tButton addTarget:self action:@selector(onTrackClick) forControlEvents:UIControlEventTouchUpInside];
//    [mScrollView addSubview:tButton];
    
}
- (void)PayBtnClick
{
    NSLog(@"self.list.payUrl---->%@",self.list.payUrl);
    PayViewController *pvc = [[PayViewController alloc]init];
    pvc.payURL = self.list.payUrl;
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)priceDetailView
{
    UIImageView *priceImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, 300, 150)];
    priceImage.image = [UIImage imageNamed:@"my_54.png"];
    priceImage.backgroundColor = [UIColor clearColor];
    [mScrollView addSubview:priceImage];
    
    UILabel *priceName = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 20)];
    priceName.text = @"订单金额";
    priceName.backgroundColor = [UIColor clearColor];
    priceName.font = [UIFont systemFontOfSize:18];
    [priceImage addSubview:priceName];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 150, 20)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",_list.orderMoney];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.textColor = WORDREDCOLOR;
    [priceImage addSubview:priceLabel];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 280, 1)];
    lineImage.image = [UIImage imageNamed:@"my_32.png"];
    lineImage.backgroundColor = [UIColor clearColor];
    [priceImage addSubview:lineImage];
    
    for (int i = 0; i < 3; i++)
    {
        UILabel *aLabel = [[UILabel alloc] init];
        aLabel.frame = CGRectMake(10, 58+25*i, 90, 20);
        aLabel.backgroundColor = [UIColor clearColor];
        if (i == 0)
        {
            aLabel.text = @"商品金额:";
        }
        else if (i == 1)
        {
            aLabel.text = @"-返现:";
        }
        else if (i == 2)
        {
            aLabel.text = @"+运费:";
        }
        aLabel.font = [UIFont systemFontOfSize:15];
        aLabel.textColor = WORDGRAYCOLOR;
        [priceImage addSubview:aLabel];
    }
    
    for (int i = 0; i < 3; i++)
    {
        UILabel *bLabel = [[UILabel alloc] init];
        bLabel.frame = CGRectMake(200, 58+25*i, 90, 20);
        bLabel.backgroundColor = [UIColor clearColor];
        if (i == 0)
        {
            bLabel.text = [NSString stringWithFormat:@"￥%@",_list.orderMoney];
        }
        else if (i == 1)
        {
            bLabel.text = @"￥0.00";
        }
        else if (i == 2)
        {
            bLabel.text = @"￥0.00";
        }
        bLabel.font = [UIFont systemFontOfSize:15];
        bLabel.textAlignment = NSTextAlignmentRight;
        bLabel.textColor = WORDREDCOLOR;
        [priceImage addSubview:bLabel];
    }
}

- (void)clothesDetailView
{
    UIImageView *imagebackground = [[UIImageView alloc] init];
    imagebackground.frame = CGRectMake(0, 260, self.view.frame.size.width, 70*_list.cartItemArr.count);
    imagebackground.image = [UIImage imageNamed:@"my_39.png"];
    [mScrollView addSubview:imagebackground];
    
    for (int i = 0; i < _list.cartItemArr.count; i++)
    {
        CartItemList * cartList = [_list.cartItemArr objectAtIndex:i];
        
        UIImageView *lineImage = [[UIImageView alloc] init];
        if (i != 0)
        {
            lineImage.frame = CGRectMake(0, 70*i, self.view.frame.size.width, 1);
        }
        lineImage.image = [UIImage imageNamed:@"my_32"];
        lineImage.backgroundColor = [UIColor redColor];
        [imagebackground addSubview:lineImage];
        
        NetImageView *clothesImage = [[NetImageView alloc] init];
        clothesImage.frame = CGRectMake(15, 10*(i+1)+60*i, 50*3/4, 50);
        clothesImage.backgroundColor = [UIColor clearColor];
        //clothesImage.image = [UIImage imageNamed:@"my_21"];
        [clothesImage GetImageByStr:cartList.goodsImage];
        [imagebackground addSubview:clothesImage];
        
        int iWidth = clothesImage.frame.origin.x+clothesImage.frame.size.width+15;
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(iWidth, 15+70*i, 205, 20);
//        label1.text = @"基本款E35";
        label1.text = cartList.goodsName;
        label1.font = [UIFont systemFontOfSize:15];
        label1.backgroundColor = [UIColor clearColor];
        [imagebackground addSubview:label1];
        
        CGSize size = [label1.text sizeWithFont:[UIFont systemFontOfSize:15]];
        if (size.width < 205) {
            [label1 sizeToFit];
        }
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(label1.frame.origin.x+label1.frame.size.width+10, 18+70*i, 40, 15);
        label2.text = cartList.type_name;
        label2.font = [UIFont systemFontOfSize:15];
        label2.backgroundColor = [UIColor clearColor];
        [imagebackground addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.frame = CGRectMake(iWidth, 40*(i+1)+30*i, 80, 15);
//        label3.text = @"￥800.00";
        label3.text = [NSString stringWithFormat:@"￥%@",cartList.goodsPrice];
        label3.textColor = WORDREDCOLOR;
        label3.font = [UIFont systemFontOfSize:15];
        label3.backgroundColor = [UIColor clearColor];
        [imagebackground addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] init];
        label4.frame = CGRectMake(170, 40*(i+1)+30*i, 60, 15);
//        label4.text = @"数量:1";
        label4.text = [NSString stringWithFormat:@"数量:%@",cartList.goodsQuantity];
        label4.font = [UIFont systemFontOfSize:15];
        label4.backgroundColor = [UIColor clearColor];
        [imagebackground addSubview:label4];
    }
    
    iHeight = imagebackground.frame.origin.y+imagebackground.frame.size.height+15;
}

- (void)userDetailView
{
    UIImageView *detailImage = [[UIImageView alloc] init];
    detailImage.frame = CGRectMake(0, iHeight, self.view.frame.size.width, 105);
    detailImage.image = [UIImage imageNamed:@"my_39.png"];
    [mScrollView addSubview:detailImage];
    
    UIImageView *detailLine = [[UIImageView alloc] init];
    detailLine.frame = CGRectMake(15, 50, self.view.frame.size.width-15, 1);
    detailLine.image = [UIImage imageNamed:@"my_32"];
    detailLine.backgroundColor = [UIColor redColor];
    [detailImage addSubview:detailLine];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(15, 15, 80, 20);
    nameLabel.text = _list.consigneeName;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:18];
    [detailImage addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(200, 15, 105, 20);
    phoneLabel.text = _list.consigneePhone;
    phoneLabel.backgroundColor = [UIColor clearColor];
    [detailImage addSubview:phoneLabel];
    
    UILabel *placeLabel = [[UILabel alloc] init];
    placeLabel.frame = CGRectMake(15, 55, 290, 40);
    placeLabel.text = _list.consigneeAddress;
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.textColor = WORDGRAYCOLOR;
    placeLabel.numberOfLines = 2;
    placeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [detailImage addSubview:placeLabel];
    
    iHeight = iHeight+detailImage.frame.size.height+15;
}

- (void)payModeView
{
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.frame = CGRectMake(0, iHeight, 320, 50);
    backImage.backgroundColor = [UIColor clearColor];
    backImage.image = [UIImage imageNamed:@"my_51"];
    [mScrollView addSubview:backImage];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 15, 80, 20);
    label.text = @"支付方式";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    [backImage addSubview:label];
    
    UILabel *wayLabel = [[UILabel alloc] init];
    wayLabel.frame = CGRectMake(100, 15, 80, 20);
    wayLabel.text = @"货到付款";
    wayLabel.font = [UIFont systemFontOfSize:16];
    wayLabel.backgroundColor = [UIColor clearColor];
    wayLabel.textColor = WORDGRAYCOLOR;
    [backImage addSubview:wayLabel];
    
    if ([_list.payWay integerValue] == 0)
    {
        wayLabel.text = @"支付宝支付";
    }
    else if ([_list.payWay integerValue] == 1)
    {
        wayLabel.text = @"银联支付";
    }
    else if ([_list.payWay integerValue] == 2)
    {
        wayLabel.text = @"货到付款";
    }
    iHeight += backImage.frame.size.height+15;
}

- (void)sendWayView
{
    UIImageView *sendlImage = [[UIImageView alloc] init];
    sendlImage.frame = CGRectMake(0, iHeight, self.view.frame.size.width, 50);
    sendlImage.image = [UIImage imageNamed:@"my_39.png"];
    [mScrollView addSubview:sendlImage];
    
//    UIImageView *detailLine = [[UIImageView alloc] init];
//    detailLine.frame = CGRectMake(15, 50, self.view.frame.size.width-15, 1);
//    detailLine.image = [UIImage imageNamed:@"my_32"];
//    detailLine.backgroundColor = [UIColor clearColor];
//    [sendlImage addSubview:detailLine];
    
    UILabel *wayLabel = [[UILabel alloc] init];
    wayLabel.frame = CGRectMake(15, 15, 80, 20);
    wayLabel.text = @"配送方式";
    wayLabel.backgroundColor = [UIColor clearColor];
    wayLabel.font = [UIFont systemFontOfSize:18];
    [sendlImage addSubview:wayLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(110, 15, 105, 20);
    nameLabel.text = @"顺丰快递";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = WORDGRAYCOLOR;
    [sendlImage addSubview:nameLabel];
    
//    UILabel *sendTime = [[UILabel alloc] init];
//    sendTime.frame = CGRectMake(15, 60, 290, 20);
//    sendTime.text = @"配送时间：9：00-15：00";
//    sendTime.textColor = WORDGRAYCOLOR;
//    sendTime.backgroundColor = [UIColor clearColor];
//    sendTime.font = [UIFont systemFontOfSize:13];
//    [sendlImage addSubview:sendTime];
//    
//    UILabel *sendDate = [[UILabel alloc] init];
//    sendDate.frame = CGRectMake(15, 80, 290, 20);
//    sendDate.text = @"送货日期：只工作日送货（双休日、假日不用送）";
//    sendDate.textColor = WORDGRAYCOLOR;
//    sendDate.backgroundColor = [UIColor clearColor];
//    sendDate.font = [UIFont systemFontOfSize:13];
//    [sendlImage addSubview:sendDate];
}

//- (void)invoiceInfoView
//{
//    UIImageView *invoiceImage = [[UIImageView alloc] init];
//    invoiceImage.frame = CGRectMake(0, 785, self.view.frame.size.width, 105);
//    invoiceImage.image = [UIImage imageNamed:@"my_39.png"];
//    [mScrollView addSubview:invoiceImage];
//    
//    UIImageView *detailLine = [[UIImageView alloc] init];
//    detailLine.frame = CGRectMake(15, 50, self.view.frame.size.width-15, 1);
//    detailLine.image = [UIImage imageNamed:@"my_32"];
//    detailLine.backgroundColor = [UIColor redColor];
//    [invoiceImage addSubview:detailLine];
//    
//    UILabel *infoLabel = [[UILabel alloc] init];
//    infoLabel.frame = CGRectMake(15, 15, 80, 20);
//    infoLabel.text = @"发票信息";
//    infoLabel.backgroundColor = [UIColor clearColor];
//    infoLabel.font = [UIFont systemFontOfSize:18];
//    [invoiceImage addSubview:infoLabel];
//    
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.frame = CGRectMake(110, 15, 105, 20);
//    nameLabel.text = @"普通发票";
//    nameLabel.textColor = WORDGRAYCOLOR;
//    nameLabel.backgroundColor = [UIColor clearColor];
//    [invoiceImage addSubview:nameLabel];
//    
//    UILabel *invoiceName = [[UILabel alloc] init];
//    invoiceName.frame = CGRectMake(15, 60, 290, 20);
//    invoiceName.text = @"发票抬头：个人";
//    invoiceName.font = [UIFont systemFontOfSize:13];
//    invoiceName.textColor = WORDGRAYCOLOR;
//    [invoiceImage addSubview:invoiceName];
//    
//    UILabel *invoiceContent = [[UILabel alloc] init];
//    invoiceContent.frame = CGRectMake(15, 70, 290, 40);
//    invoiceContent.text = @"发票内容：明细";
//    invoiceContent.font = [UIFont systemFontOfSize:13];
//    invoiceContent.textColor = WORDGRAYCOLOR;
//    [invoiceImage addSubview:invoiceContent];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////跟踪
//-(void)onTrackClick{
//    OrderTrackViewController *ctrl = [[OrderTrackViewController alloc] init];
//    [self.navigationController pushViewController:ctrl animated:YES];
//}

////衣服详情
//-(void)onInfoClick{
//    CustomDetailViewController *ctrl = [[CustomDetailViewController alloc] init];
//    [self.navigationController pushViewController:ctrl animated:YES];
//}


@end
