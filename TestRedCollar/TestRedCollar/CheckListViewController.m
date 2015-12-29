//
//  CheckListViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CheckListViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "UserAddressListViewController.h"
#import "UserAddressInfoViewController.h"
#import "AddNewAddressViewController.h"
#import "InvoiceViewController.h"
#import "ShoppingCarModel.h"
#import "CheckGoodsListViewController.h"
#import "ServiceViewController.h"
#import "HistoryDataViewController.h"
#import "AutoAlertView.h"
#import "MakeAnAppointmentOfFigureViewController.h"
#import "PayViewController.h"
@interface CheckListViewController ()
{
    UIScrollView *_scrollView;
    ImageDownManager *_orderManager;
    ImageDownManager *_getFigureManager;
    ImageDownManager *_mAddressDownManager;
    UILabel *_nameLabel;
    UILabel *_numberLabel;
    UILabel *_addressLabel;
    UILabel *_invoiceLabel;
    UILabel *_totalPay;
    
    int _invoiceneed;
    NSString *_invoiceType;
    NSString *_invoiceTitle;
    
    UIButton *_mSelectBtn;
    
    int _iCount;
    int _iHeight;
    int _iGap;
    bool _needFigure;//需不需要量体
    bool _hasHisData;
    //历史数据 日期
    UILabel *_hisDataDate;
    //历史数据
    NSDictionary *_hisDataDict;
    //
    NSString *_figure;
    
    NSString *_serviceId;
    NSString *_address;
    NSString *_mobile;
    NSString *_realname;
    NSString *_regionId;
    NSString *_regionName;
    NSString *_retime;
}
@end

@implementation CheckListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [self Cancel];
    SAFE_CANCEL_ARC(_getFigureManager);
    SAFE_CANCEL_ARC(_orderManager);
}
- (void)Cancel {
    [self StopLoading];
}



- (void)OnGetAddressFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"地址----->%@",dict);
    [self StopLoading];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        for (NSString *idKey in dict) {
            if (dict[idKey] && [dict[idKey] isKindOfClass:[NSDictionary class]] && dict[idKey][@"def_addr"] && [dict[idKey][@"def_addr"] intValue] == 1) {
                _nameLabel.text = dict[idKey][@"consignee"];
                _numberLabel.text = dict[idKey][@"phone_mob"];
                _addressLabel.text = dict[idKey][@"address"];
            }
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    NSLog(@"下载失败");
    SAFE_CANCEL_ARC(sender);
    [self Cancel];
}
- (void)GetFigureDownload
{
    [self StartLoading];
    _getFigureManager = [[ImageDownManager alloc] init];
    _getFigureManager.delegate = self;
    _getFigureManager.OnImageDown = @selector(OnGetFigureFinish:);
    _getFigureManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@order.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"getFigure" forKey:@"act"];
    [_getFigureManager PostHttpRequest:urlstr :dict];
}
- (void)OnGetFigureFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"有没有历史数据------>%@",dict);
    //[AutoAlertView ShowAlert:@"" message:dict[@"msg"]];
    if ([[dict objectForKey:@"statusCode"] intValue]==1) {
        _hasHisData = NO;
        //NSLog(@"_hasHisData--->%d",_hasHisData);
    }
    else{
        _hasHisData = YES;
        _hisDataDict = dict;
    }
    [self createMeasure:_iHeight];
}
- (void)StartAddressDownload
{
    //rctailor.ec51.com.cn/soaapi/soap/flow.php?act=getConsigneeList&token=8d4c69dee19607d277fe72650a9d3712
    
    [self StartLoading];
    _mAddressDownManager = [[ImageDownManager alloc] init];
    _mAddressDownManager.delegate = self;
    _mAddressDownManager.OnImageDown = @selector(OnGetAddressFinish:);
    _mAddressDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"getConsigneeList" forKey:@"act"];
    [_mAddressDownManager PostHttpRequest:urlstr :dict];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _invoiceneed = 0;
    _invoiceType = @"个人";
    
    _invoiceTitle = @"";
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"核对订单";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 800);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = WORDGRAYCOLOR;
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = WORDGRAYCOLOR;
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.textColor = WORDGRAYCOLOR;
    
    _iHeight = 45;
    _iGap = 20;
    _iCount = 0;
    [self GetFigureDownload];
}
- (void)goodsListViewClick
{
    CheckGoodsListViewController *cvc = [[CheckGoodsListViewController alloc]init];
    cvc.dataArray = self.goodsArray;
    [self.navigationController pushViewController:cvc animated:YES];
}
- (void)invoiceViewTapClick
{
    InvoiceViewController *ivc = [[InvoiceViewController alloc]init];
    ivc.blocks = ^(int index,NSString *typeStr,NSString *title){
        if (index == 0) {
            _invoiceLabel.text = @"不需要发票";
        }
        else if (index == 1){
            _invoiceLabel.text = @"需要发票";
        }
        _invoiceneed = index;
        _invoiceType = typeStr;
        _invoiceTitle = title;
        NSLog(@"_invoiceneed--->%d",_invoiceneed);
        NSLog(@"_invoiceType--->%@",_invoiceType);
        NSLog(@"_invoiceTitle--->%@",_invoiceTitle);
    };
    ivc.index = _invoiceneed;
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)EditAddress
{
    NSLog(@"收货地址");
    UserAddressListViewController *uvc = [[UserAddressListViewController alloc]init];
    uvc.type = 1;
    uvc.blocksAd = ^(ConsigneeList *model){
        _nameLabel.text = model.consignee;
        _numberLabel.text = model.phone_mob;
        _addressLabel.text = [NSString stringWithFormat:@"%@%@",model.region_name,model.address];
    };
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)createMeasure:(int)iHeight
{
    _needFigure = NO;//不需要量体
    for (int i = 0; i<self.goodsArray.count; i++) {
        ShoppingCarModel *model = self.goodsArray[i];
        if ([model.is_diy boolValue]) {
            _needFigure = YES;
        }
    }
    if (_needFigure) {
        if (_hasHisData) {
            _iCount = 4;
            UIView *bgVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, iHeight*_iCount)];
            bgVIew.backgroundColor = [UIColor whiteColor];
            [_scrollView addSubview:bgVIew];
            
            for (int i = 0 ; i<_iCount-1; i++) {
                double w = self.view.bounds.size.width;
                double h = 1;
                double x = 15;
                double y = (i+1)*iHeight;
                UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
                if (i==0) {
                    lineView.frame = CGRectMake(0, y, w, h);
                }
                lineView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
                [bgVIew addSubview:lineView];
            }
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
            titleLabel.text = @"量体数据";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor darkGrayColor];
            [bgVIew addSubview:titleLabel];
            
            NSString *dateStr = [_hisDataDict objectForKey:@"create_date"];
            NSArray *dataArr = [dateStr componentsSeparatedByString:@" "];
            NSString *Str = dataArr[0];
            NSLog(@"Str----->%@",Str);
            _hisDataDate = [[UILabel alloc]initWithFrame:CGRectMake(130, 16+iHeight, 100, 20)];
            //_hisDataDate.backgroundColor = [UIColor redColor];
            _hisDataDate.font = [UIFont systemFontOfSize:14];
            _hisDataDate.textColor = [UIColor darkGrayColor];
            _hisDataDate.text = Str;
            [bgVIew addSubview:_hisDataDate];
            
            if (_hisDataDict[@"idfigure"]) {
                _figure = _hisDataDict[@"idfigure"];
            }
            
            UILabel *chooseOld = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight, 120, 20)];
            chooseOld.text = @"选择已有数据";
            chooseOld.font = [UIFont systemFontOfSize:15];
            chooseOld.textColor = WORDGRAYCOLOR;
            [bgVIew addSubview:chooseOld];
            
            UILabel *visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight*2, 120, 20)];
            visitLabel.text = @"上门量体";
            visitLabel.font = [UIFont systemFontOfSize:15];
            visitLabel.textColor = WORDGRAYCOLOR;
            [bgVIew addSubview:visitLabel];
            
            visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight*3, 120, 20)];
            visitLabel.text = @"到附近服务点量体";
            visitLabel.font = [UIFont systemFontOfSize:15];
            visitLabel.textColor = WORDGRAYCOLOR;
            [bgVIew addSubview:visitLabel];
            
            for (int i = 0; i<_iCount-1; i++) {
                
                UIImageView *subView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-53, 16+iHeight*(i+1), 7.5, 12.5)];
                subView.image = [UIImage imageNamed:@"52.png"];
                [bgVIew addSubview:subView];
                
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.frame = CGRectMake(self.view.bounds.size.width-50, iHeight*(i+1), 45, 45);
                [selectBtn setImage:[UIImage imageNamed:@"53_2"] forState:UIControlStateNormal];
                [selectBtn setImage:[UIImage imageNamed:@"53"] forState:UIControlStateSelected];
                selectBtn.tag = 1500+i;
                [selectBtn addTarget:self action:@selector(OnHasHisDataSelectClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgVIew addSubview:selectBtn];
                
                if (i==0) {
                    _mSelectBtn = selectBtn;
                    _mSelectBtn.selected = YES;
                }
            }
        }
        else{
            _iCount = 3;
            UIView *bgVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, iHeight*_iCount)];
            bgVIew.backgroundColor = [UIColor whiteColor];
            [_scrollView addSubview:bgVIew];
            
            _figure = @"-2";
            
            for (int i = 0 ; i<_iCount-1; i++) {
                double w = self.view.bounds.size.width;
                double h = 1;
                double x = 15;
                double y = (i+1)*iHeight;
                UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
                if (i==0) {
                    lineView.frame = CGRectMake(0, y, w, h);
                }
                lineView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
                [bgVIew addSubview:lineView];
            }
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
            titleLabel.text = @"量体数据";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor darkGrayColor];
            [bgVIew addSubview:titleLabel];
            
            UILabel *visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight*(_iCount-2), 120, 20)];
            visitLabel.text = @"上门量体";
            visitLabel.font = [UIFont systemFontOfSize:15];
            visitLabel.textColor = WORDGRAYCOLOR;
            [bgVIew addSubview:visitLabel];
            
            visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+iHeight*(_iCount-1), 120, 20)];
            visitLabel.text = @"到附近服务点量体";
            visitLabel.font = [UIFont systemFontOfSize:15];
            visitLabel.textColor = WORDGRAYCOLOR;
            [bgVIew addSubview:visitLabel];
            
            for (int i = 0; i<_iCount-1; i++) {
                UIImageView *subView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-53, 16+iHeight*(i+1), 7.5, 12.5)];
                subView.image = [UIImage imageNamed:@"52.png"];
                [bgVIew addSubview:subView];
                
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.frame = CGRectMake(self.view.bounds.size.width-50, iHeight*(i+1), 45, 45);
                [selectBtn setImage:[UIImage imageNamed:@"53_2"] forState:UIControlStateNormal];
                [selectBtn setImage:[UIImage imageNamed:@"53"] forState:UIControlStateSelected];
                selectBtn.tag = 1500+i;
                [selectBtn addTarget:self action:@selector(OnNotHisDataSelectClick:) forControlEvents:UIControlEventTouchUpInside];
                [bgVIew addSubview:selectBtn];
                
                if (i==0) {
                    _mSelectBtn = selectBtn;
                    _mSelectBtn.selected = YES;
                }
            }
        }
    }
    [self createAddress:_iHeight :_iGap :_iCount];
    [self StartAddressDownload];
}
- (void)OnNotHisDataSelectClick:(UIButton *)sender{
    [_mSelectBtn setSelected:NO];
    [sender setSelected:YES];
    _mSelectBtn = sender;
    if (sender.tag == 1500) {
        NSLog(@"上门量取");
        _figure = @"-2";
        ServiceViewController *ctrl = [[ServiceViewController alloc] init];
        ctrl.mblock = ^(NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime){
            NSLog(@"okko--->%@",address);
            _address = address;
            _mobile = mobile;
            _realname = realname;
            _regionId = region_id;
            _regionName = region_name;
            _retime = retime;
        };
        ctrl.is_free = NO;
        ctrl.block = ^(NSString *str){
            _serviceId  = str;
            NSLog(@"_serviceId-->%@",_serviceId);
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if(sender.tag == 1501){
        _figure = @"-1";
        ServiceViewController *ctrl = [[ServiceViewController alloc] init];
        ctrl.mblock = ^(NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime){
            NSLog(@"okko--->%@",address);
            _address = address;
            _mobile = mobile;
            _realname = realname;
            _regionId = region_id;
            _regionName = region_name;
            _retime = retime;
        };
        ctrl.is_free = YES;
        ctrl.block = ^(NSString *str){
            _serviceId  = str;
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
- (void)OnHasHisDataSelectClick:(UIButton *)sender {
    [_mSelectBtn setSelected:NO];
    [sender setSelected:YES];
    _mSelectBtn = sender;
    
    if (sender.tag == 1500) {
        HistoryDataViewController *ctrl = [[HistoryDataViewController alloc] init];
        ctrl.mDict = _hisDataDict;
        if (_hisDataDict[@"idfigure"]) {
            _figure = _hisDataDict[@"idfigure"];
        }
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (sender.tag == 1501) {
        NSLog(@"上门量取");
        _figure = @"-2";
        ServiceViewController *ctrl = [[ServiceViewController alloc] init];
        ctrl.mblock = ^(NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime){
            NSLog(@"okko--->%@",address);
            _address = address;
            _mobile = mobile;
            _realname = realname;
            _regionId = region_id;
            _regionName = region_name;
            _retime = retime;
        };
        ctrl.is_free = NO;
        ctrl.block = ^(NSString *str){
            _serviceId  = str;
            NSLog(@"_serviceId-->%@",_serviceId);
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (sender.tag == 1502){
        _figure = @"-1";
        ServiceViewController *ctrl = [[ServiceViewController alloc] init];
        ctrl.mblock = ^(NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime){
            NSLog(@"okko--->%@",address);
            _address = address;
            _mobile = mobile;
            _realname = realname;
            _regionId = region_id;
            _regionName = region_name;
            _retime = retime;
        };
        ctrl.is_free = YES;
        ctrl.block = ^(NSString *str){
            _serviceId  = str;
        };
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
-(void)createAddress:(int)iHeight :(int)iGap :(int)iCount
{
    
    UIView *bgVIew = [[UIView alloc]initWithFrame:CGRectMake(0, iHeight*_iCount+10+iGap, self.view.bounds.size.width, iHeight*3)];
    bgVIew.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgVIew];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EditAddress)];
    [bgVIew addGestureRecognizer:tap];
    
    for (int i = 0 ; i<2; i++) {
        double w = self.view.bounds.size.width;
        double h = 1;
        double x = 15;
        double y = (i+1)*iHeight;
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        if (i==0) {
            lineView.frame = CGRectMake(0, y, w, h);
        }
        lineView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        [bgVIew addSubview:lineView];
    }
    
    UILabel *addressInfo = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 120, 20)];
    addressInfo.text = @"收货人信息";
    addressInfo.font = [UIFont systemFontOfSize:16];
    addressInfo.textColor = [UIColor darkGrayColor];
    [bgVIew addSubview:addressInfo];
    
    _nameLabel.frame = CGRectMake(15, 16+iHeight, 100, 20);
    [bgVIew addSubview:_nameLabel];
    
    _numberLabel.frame = CGRectMake(self.view.bounds.size.width-110, 16+iHeight, 100, 20);
    [bgVIew addSubview:_numberLabel];
    
    _addressLabel.frame = CGRectMake(15, 16+iHeight*2, self.view.bounds.size.width-40, 20);
    [bgVIew addSubview:_addressLabel];
    
    _iCount +=3;
    [self createRemainingUI];
}
- (void)createRemainingUI
{
    //支付方式
    UIImageView *payWayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+_iGap*2+_iHeight*_iCount, self.view.bounds.size.width, _iHeight)];
    payWayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:payWayView];
    
    UILabel *payWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
    payWayLabel.text = @"支付方式";
    payWayLabel.font = [UIFont systemFontOfSize:16];
    payWayLabel.textColor = [UIColor darkGrayColor];
    [payWayView addSubview:payWayLabel];
    
    UILabel *selectedPayWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-90, 16, 80, 20)];
    selectedPayWayLabel.text = @"支付宝";
    selectedPayWayLabel.font = [UIFont systemFontOfSize:15];
    selectedPayWayLabel.textColor = WORDGRAYCOLOR;
    [payWayView addSubview:selectedPayWayLabel];
    
    _iCount+=1;
    //配送方式
    
    UIImageView *deliveryWayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+_iGap*3+_iHeight*_iCount, self.view.bounds.size.width, _iHeight)];
    deliveryWayView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:deliveryWayView];
    
    UILabel *deliveryWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
    deliveryWayLabel.text = @"配送方式";
    deliveryWayLabel.font = [UIFont systemFontOfSize:16];
    deliveryWayLabel.textColor = [UIColor darkGrayColor];
    [deliveryWayView addSubview:deliveryWayLabel];
    
    UILabel *selecteddeLiveryWayLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-90, 16, 80, 20)];
    selecteddeLiveryWayLabel.text = @"顺丰快递";
    selecteddeLiveryWayLabel.font = [UIFont systemFontOfSize:15];
    selecteddeLiveryWayLabel.textColor = WORDGRAYCOLOR;
    [deliveryWayView addSubview:selecteddeLiveryWayLabel];
    _iCount+=1;
    
    //发票信息
    UIImageView *invoiceView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+_iGap*4+_iHeight*_iCount, self.view.bounds.size.width, _iHeight*2)];
    invoiceView.userInteractionEnabled =YES;
    invoiceView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:invoiceView];
    UITapGestureRecognizer *invoiceViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(invoiceViewTapClick)];
    [invoiceView addGestureRecognizer:invoiceViewTap];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _iHeight, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    [invoiceView addSubview:lineView];
    
    UILabel *invoiceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
    invoiceTitleLabel.text = @"发票信息";
    invoiceTitleLabel.font = [UIFont systemFontOfSize:16];
    invoiceTitleLabel.textColor = [UIColor darkGrayColor];
    [invoiceView addSubview:invoiceTitleLabel];
    
    _invoiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16+_iHeight, 150, 20)];
    _invoiceLabel.font = [UIFont systemFontOfSize:15];
    _invoiceLabel.textColor = WORDGRAYCOLOR;
    _invoiceLabel.text = @"不需要发票";
    [invoiceView addSubview:_invoiceLabel];
    
    UIImageView *subView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-30, 20+_iHeight, 7.5, 12.5)];
    subView.image = [UIImage imageNamed:@"52.png"];
    [invoiceView addSubview:subView];
    
    _iCount+=2;
    
    //商品清单
    UIImageView *goodsListView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+_iGap*5+_iHeight*_iCount, self.view.bounds.size.width, _iHeight)];
    goodsListView.userInteractionEnabled = YES;
    goodsListView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:goodsListView];
    
    UITapGestureRecognizer *goodsListViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsListViewClick)];
    [goodsListView addGestureRecognizer:goodsListViewTap];
    
    UILabel *goodsListLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
    goodsListLabel.text = @"商品清单";
    goodsListLabel.font = [UIFont systemFontOfSize:16];
    goodsListLabel.textColor = [UIColor darkGrayColor];
    [goodsListView addSubview:goodsListLabel];
    
    UIImageView *subView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-30, 20, 7.5, 12.5)];
    subView1.image = [UIImage imageNamed:@"52.png"];
    [goodsListView addSubview:subView1];
    _iCount+=1;
    
    //总额
    UIImageView *totalView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10+_iGap*6+_iHeight*_iCount, self.view.bounds.size.width, _iHeight)];
    totalView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:totalView];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 100, 20)];
    totalLabel.text = @"应付总额";
    totalLabel.font = [UIFont systemFontOfSize:16];
    totalLabel.textColor = [UIColor darkGrayColor];
    [totalView addSubview:totalLabel];
    
    _totalPay = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-100, 16, 90, 20)];
    _totalPay.textColor = WORDREDCOLOR;
    _totalPay.font = [UIFont systemFontOfSize:14];
    float total = 0;
    for (ShoppingCarModel *model in self.goodsArray) {
        total = total + [model.price floatValue]*model.quantity;
    }
    _totalPay.text = [NSString stringWithFormat:@"%.2f元",total];
    [totalView addSubview:_totalPay];
    //提交按钮
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(20, 10+_iGap*7+_iHeight*(_iCount+1), self.view.bounds.size.width-40, _iHeight);
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"checklist_commit.png"] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buyBtn];
    
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, buyBtn.frame.origin.y+_iHeight+30);
    
    [self DealAddressLabel];
}
- (void)DealAddressLabel{
    if (kkAddress) {
        //_nameLabel =
    }
}

- (void)buyBtnClick
{
    NSLog(@"购买");
    NSLog(@"%@",_figure);
    if (!_numberLabel.text || !_addressLabel.text || !_nameLabel.text) {
        [AutoAlertView ShowAlert:@"请输入收货地址" message:nil];
        return;
    }
    [self StartLoading];
    _orderManager = [[ImageDownManager alloc] init];
    _orderManager.delegate = self;
    _orderManager.OnImageDown = @selector(OnOrderFinish:);
    _orderManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@order.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"submitOrder" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%d",_invoiceneed] forKey:@"invoiceneed"];
    if (_invoiceneed == 1) {
        [dict setObject:_invoiceType forKey:@"invoicetype"];
        [dict setObject:_invoiceTitle forKey:@"invoicetitle"];
        [dict setObject:@"服装" forKey:@"invoicecontent"];
    }
    if(_needFigure && [_figure intValue]>1){
        NSLog(@"选择了历史数据");
        if (_hisDataDict[@"idfigure"]) {
            [dict setObject:_hisDataDict[@"idfigure"] forKey:@"figure"];
        }
    }
    else if([_figure intValue] < 0){
        if (_address && _mobile && _realname &&_regionId && _regionName &&_retime && _serviceId) {
            [dict setObject:_address forKey:@"address"];
            [dict setObject:_mobile forKey:@"mobile"];
            [dict setObject:_realname forKey:@"realname"];
            [dict setObject:_regionId forKey:@"region_id"];
            [dict setObject:_regionName forKey:@"region_name"];
            [dict setObject:_retime forKey:@"retime"];
            [dict setObject:_serviceId forKey:@"service"];
            if ([_figure intValue] == -1) {
                [dict setObject:@"-1" forKey:@"figure"];
            }
            else if([_figure intValue] == -2){
                [dict setObject:@"-2" forKey:@"figure"];
            }
        }
        else{
            [self StopLoading];
            [AutoAlertView ShowMessage:@"请填写量体参数"];
            return;
        }
    }
    [_orderManager PostHttpRequest:urlstr :dict];
}
- (void)OnOrderFinish:(ImageDownManager *)sender
{
    [self StopLoading];
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"---->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if (dict[@"stateCode"] && [dict[@"stateCode"] intValue] == 0) {
            PayViewController *pvc = [[PayViewController alloc]init];
            pvc.payURL = dict[@"oInfo"][@"pay_url"];
            [self.navigationController pushViewController:pvc animated:YES];
            //[self presentViewController:pvc animated:YES completion:nil];
        }
        else{
            [AutoAlertView ShowMessage:dict[@"oInfo"]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
