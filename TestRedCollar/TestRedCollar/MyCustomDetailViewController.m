//
//  MyCustomDetailViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-22.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MyCustomDetailViewController.h"
#import "ShopCarViewController.h"
#import "PersonalizedSignatureViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "MyCusttomFabricModel.h"
#import "MycusttomMaterialModel.h"
#import "MyCusttomButtonsModel.h"
#import "NetImageView.h"
#import "CategorySelectedView.h"
#import "TypeSelectView.h"
#import "LoginViewController.h"
#import "AutoAlertView.h"
#import "LocationBtn.h"
#import "MyCusttomDetailDetailViewController.h"
#import "ShareSheetView.h"
#import "ShowBiaoViewController.h"
#import "UMSocialWechatHandler.h"
@interface MyCustomDetailViewController ()
{
    UIScrollView *_scrollView;
    UIView *_DIYView;
    UITextField *_heightField;
    UITextField *_weightField;
    UILabel *_totalPriceLabel;
    UIView *_contentView;
    //DIY
    UIButton *_seleBtn1;
    UIButton *_seleBtn2;
    UIButton *_seleBtn3;
    UIButton *_seleBtn4;
    UIButton *_seleBtn5;
    UIButton *_seleBtn6;
    UIButton *_measureTypeBtn;
    
    UIView *_measureView;
    UIView *_standardView;
    
    UIView *_mBackView;
    
    ImageDownManager *_mDownManager;
    ImageDownManager *_addFavorite;
    ImageDownManager *_addCartManager;
    ImageDownManager *_downRelaManager;
    
    UIButton *_keyboardCancleBut;
    UIButton *_sizePopVIewCancleBtn;
    // 存分类id和名字
    NSMutableArray *_categoryArray;
    // style 二分类 name
    NSMutableArray *_styleErNameArray;
    
    // 按照名字顺序排列数据
    NSMutableArray *_dataArray;
    //
    NSArray *_DIYDataArray;
    //数据数组
    NSMutableArray *_materialArray;
    NSMutableArray *_sizeArray;
 
    UITableView *_sizePopView;
    UILabel *_sizeLabel;
    
    //面料的编号数组 用于取图片
    NSMutableArray *_fabricNameArray;
    
    //加入购物车的 大图参数
    NSString *_addCartBigImgUrl;
    //大图 地址
    NSString *_imgUrl;
    //
    NSMutableArray *_bigImgArray;
    //
    NetImageView *_bigImg;
    NSDictionary *_customsDict;
    
    //单耗计算价格
    NSString *_fabric_m;
    NSString *_lining_m;
    
    //记住当前选择的 面料 和 里料（和单耗一起 计算价格）
    MyCusttomFabricModel *_seleFabricModel;
    MyCusttomFabricModel *_seleMaterialModel;
    //工艺 价格
    double _processPrice;
    
    //服务价格
    NSString *_service_fee;
    
    //is_diy
    NSString *_is_diy;
    //item
    NSMutableString *_item;
    
    
    NSMutableArray *_colorArray;
    NSMutableArray *_locationArray;
    NSMutableArray *_fontArray;
    
    //记住选择的组件(拼接ITEM)
    NSMutableArray *_markArray;
    
    //签名内容
    NSString *_emb;
    
    //
    NSMutableArray *_relationGoodsArray;
}
@end

@implementation MyCustomDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    }
    return self;
}
- (void)reloadTitle:(int)index{
    switch (index) {
        case 3:
            self.title = @"西装定制";
            break;
        case 3000:
            self.title = @"衬衣定制";
            break;
        case 4000:
            self.title = @"马甲定制";
            break;
        case 2000:
            self.title = @"西裤定制";
            break;
        case 6000:
            self.title = @"大衣定制";
            break;
        default:
            break;
    }
}
- (void)AddCart{
    if ([_is_diy isEqualToString:@"1"]) {
        if (_heightField.text.length==0) {
            [AutoAlertView ShowMessage:@"请输入身高"];
            return;
        }
        else if (_weightField.text.length==0){
            [AutoAlertView ShowMessage:@"请输入体重"];
            return;
        }
    }
    else if([_is_diy isEqualToString:@"0"]){
    }
    
    [self StartLoading];
    NSLog(@"_is_diy--->%@",_is_diy);
    _addCartManager = [[ImageDownManager alloc] init];
    _addCartManager.delegate = self;
    _addCartManager.OnImageDown = @selector(OnAddCartFinish:);
    _addCartManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlStr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    float price = [_totalPriceLabel.text floatValue];
    int d = (int)(price * 10) % 10;
    if (d>=5) {
        price = price+1;
    }
    
    NSLog(@"price-->%d",(int)price);
    //标准码
    [dict setObject:_is_diy forKey:@"is_diy"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"addCart" forKey:@"act"];
    [dict setObject:self.IDStr forKey:@"goodsId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(int)price] forKey:@"total"];
    [dict setObject:_emb forKey:@"emb_con"];
    [dict setObject:_addCartBigImgUrl forKey:@"imgcode"];
    [dict setObject:_item forKey:@"item"];
    if ([_is_diy isEqualToString:@"0"]) {
        [dict setObject:_sizeLabel.text forKey:@"spec"];
        
        //测试
        //[dict setObject:@"8001:616815|313:315|371:1343|24:130|24:148|24:195|24:215|24:31914|24:36|417:31173|417:528|417:420" forKey:@"item"];
    }
    //量体
    else if ([_is_diy isEqualToString:@"1"]){
        [dict setObject:_heightField.text forKey:@"height"];
        [dict setObject:_weightField.text forKey:@"weight"];
        //测试
        //[dict setObject:@"8001:616815|313:315|371:1343|24:130|24:148|24:195|24:215|24:31914|24:36|417:31173|417:528|417:420" forKey:@"item"];
    }
    if (self.rec_id) {
        [dict setObject:self.rec_id forKey:@"rec_id"];
    }
    [_addCartManager PostHttpRequest:urlStr :dict];
}
- (void)OnAddCartFinish:(ImageDownManager *)sender{
    [self StopLoading];
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"addCartDict--->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"成功了吗？--->%@",dict[@"msg"]);
        if ([dict[@"code"] intValue]==0) {
            ShopCarViewController *svc = [[ShopCarViewController alloc]init];
            [self.navigationController pushViewController:svc animated:YES];
        }
        else if([dict[@"code"] intValue]==1){
            [AutoAlertView ShowMessage:dict[@"msg"]];
        }
    }
}
- (void)AddFavorite{
    [self.view endEditing:YES];
    if (![UserInfoManager Share].mbLogin) {
        LoginViewController *ctrl = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else{
        [self StartLoading];
        _addFavorite = [[ImageDownManager alloc] init];
        _addFavorite.delegate = self;
        _addFavorite.OnImageDown = @selector(OnAddFinish:);
        _addFavorite.OnImageFail = @selector(OnLoadFail:);
        NSString *urlstr =[NSString stringWithFormat:@"%@goods.php",SERVER_URL];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"addCstCollect" forKey:@"act"];
        [dict setObject:kkToken forKey:@"token"];
        [dict setObject:self.IDStr forKey:@"cstId"];
        [_addFavorite PostHttpRequest:urlstr :dict];
    }
}
- (void)OnAddFinish:(ImageDownManager *)sender{
    [self StopLoading];
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"dict---->%@",dict);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        [AutoAlertView ShowMessage:dict[@"msg"]];
    }
}

- (void)ShareClick{
    NSString *imagename = [_customsDict objectForKey:@"cst_image"];
    NSString *shareID = [_customsDict objectForKey:@"cst_id"];
    UIImage *image = [UIImage imageWithContentsOfFile:[NetImageView GetLocalPathOfUrl:imagename]];
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    ShareSheetView *view = [[ShareSheetView alloc] initWithFrame:keywindow.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view.mImage = image;
    view.mContent = [_customsDict objectForKey:@"cst_name"];
    view.mShareUrl = [NSString stringWithFormat:@"http://m.rctailor.com/index.php/custom-info-%@.html",shareID];
    view.mRootCtrl = self;
    // "http://m.rctailor.com/index.php/custom-info-"+ customs.cst_id + ".html"
    [UMSocialWechatHandler setWXAppId:WX_APPID url:view.mShareUrl];
    [keywindow addSubview:view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sButton setBackgroundImage:[UIImage imageNamed:@"mycusttom_detail_shoucang.png"] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(AddFavorite) forControlEvents:UIControlEventTouchUpInside];
    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mButton setBackgroundImage:[UIImage imageNamed:@"1_12000.png"] forState:UIControlStateNormal];
    [mButton addTarget:self action:@selector(ShareClick) forControlEvents:UIControlEventTouchUpInside];
    NSArray *btnArray = [NSArray arrayWithObjects:mButton,sButton, nil];
    [self AddRightImageBtns:btnArray];

    _is_diy = @"1";
    _emb = @" ";
    _dataArray = [[NSMutableArray alloc]init];
    _categoryArray = [[NSMutableArray alloc]init];
    _styleErNameArray = [[NSMutableArray alloc]init];
    _materialArray = [[NSMutableArray alloc]init];
    _sizeArray = [[NSMutableArray alloc]init];
    _fabricNameArray = [[NSMutableArray alloc]init];
    _bigImgArray = [[NSMutableArray alloc]init];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 900);
    [self.view addSubview:_scrollView];
    
    //总价
    _totalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(97, 599, 80, 20)];
    _totalPriceLabel.textColor = WORDREDCOLOR;
    _totalPriceLabel.font = [UIFont systemFontOfSize:15];
    _totalPriceLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_totalPriceLabel];
    
    //大图
    _bigImg = [[NetImageView alloc]initWithFrame:CGRectMake(18, 0, _scrollView.frame.size.width-36, 385)];
    _bigImg.mImageType = TImageType_CutFill;
    [_scrollView addSubview:_bigImg];
    
    _keyboardCancleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyboardCancleBut.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.contentSize.height);
    [_keyboardCancleBut addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    _sizePopVIewCancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sizePopVIewCancleBtn.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.contentSize.height);
    [_sizePopVIewCancleBtn addTarget:self action:@selector(OnPopCancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 365, self.view.bounds.size.width, 85)];
    [_scrollView addSubview:_contentView];
    
}
- (void)RefreshTotalPrice{
    //NSLog(@"_dataArray--->%@    %@",_seleFabricModel,_seleMaterialModel);
    //NSLog(@"--->%@  --->%@  --->%@  --->%@  --->%@  ",_seleFabricModel.price,_fabric_m,_seleMaterialModel.price,_lining_m,_service_fee);
    double price =  [_seleFabricModel.price doubleValue]*[_fabric_m doubleValue]+[_seleMaterialModel.price doubleValue]*[_lining_m doubleValue]+[_service_fee doubleValue]+ _processPrice;
    double h = [_heightField.text doubleValue];
    double w = [_weightField.text doubleValue];
    if (h<=190 && w<=100) {
    }
    else if (((h<=200 && h>190) && w<=120) || ((w<=120 && w>100) && h<=200)) {
        price =[_seleFabricModel.price doubleValue]*[_fabric_m doubleValue]+ [_seleFabricModel.price doubleValue]*1.5+[_seleMaterialModel.price doubleValue]*[_lining_m doubleValue]+[_service_fee doubleValue]+ _processPrice;
    }
    else if (h>200 || w>120) {
        price = [_seleFabricModel.price doubleValue]*[_fabric_m doubleValue]+[_seleFabricModel.price doubleValue]*2+[_seleMaterialModel.price doubleValue]*[_lining_m doubleValue]+[_service_fee doubleValue] + _processPrice;
    }
    int d = (int)(price * 10) % 10;
    if (d>=5) {
        price = price+1;
    }
    float jPrice = (int)price;
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f元",jPrice];
}

- (void)cancle
{
    SAFE_CANCEL_ARC(_downRelaManager);
    SAFE_CANCEL_ARC(_mDownManager);
    SAFE_CANCEL_ARC(_addFavorite);
    SAFE_CANCEL_ARC(_addCartManager);
}
- (void)StartDownload{
    [self StartDownloadReala];
    
}
- (void)StartDownloadReala{
    _relationGoodsArray = [[NSMutableArray alloc]init];
    if (_downRelaManager) {
        return;
    }
    [self StartLoading];
    _downRelaManager = [[ImageDownManager alloc] init];
    _downRelaManager.delegate = self;
    _downRelaManager.OnImageDown = @selector(OnLoadRelaFinish:);
    _downRelaManager.OnImageFail = @selector(OnLoadFail:);
    //http://rctailor.com//soaapi/soap/goods.php?act=getRelGoods&id=229
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.IDStr forKey:@"id"];
    [dict setObject:@"getRelGoods" forKey:@"act"];
    [_downRelaManager PostHttpRequest:urlstr :dict];
}
- (void)OnLoadRelaFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"相关基本款--%@",dict);
    for (NSString *key in dict) {
        NSDictionary *goodDict = dict[key];
        [_relationGoodsArray addObject:goodDict];
    }
    [self StartDownloadData];
}
- (void)StartDownloadData{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"http://www.rctailor.com/index.php/custom-get_basis-%@.html",self.IDStr];
    //NSString *urlstr = @"http://rctailor.ec51.com.cn/index.php/custom-get_basis-199.html";
    //NSLog(@"url---->%@",urlstr);
    NSDictionary *dict = [NSDictionary dictionary];
    [_mDownManager PostHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender
{
    [self StopLoading];
    NSDictionary *mdict = [sender.mWebStr JSONValue];
    if (mdict && [mdict isKindOfClass:[NSDictionary class]] && [mdict[@"status"] intValue]==1){
        NSDictionary *dict = [mdict objectForKey:@"data"];
        NSDictionary *dataDict = [dict objectForKey:@"data"];
        NSDictionary *catedict = [dict objectForKey:@"category"];
        NSArray *buttonsArray = [dict objectForKey:@"buttons"];
        _customsDict = dict[@"customs"];
        
        //工艺价格
        NSArray *processArray = dict[@"process"];
        for (int i = 0; i<processArray.count; i++) {
            NSDictionary *pp = processArray[i];
            _processPrice = _processPrice +[pp[@"price"] doubleValue];
        }
        
        //单耗
        _fabric_m = dict[@"consumption"][@"fabric_m"];
        _lining_m = dict[@"consumption"][@"lining_m"];
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            //取得分类 id 名字
            //1.取得一定存在的面料
            //名字
            [_categoryArray addObject:@"面料选择"];
            //数据
            NSArray *fabricIDArr = [dict objectForKey:@"fabric"];
            if (fabricIDArr && [fabricIDArr isKindOfClass:[NSArray class]]) {
                //NSLog(@"%@",fabricIDArr);
                for (int i = 0; i<fabricIDArr.count; i++) {
                    NSString *key = [NSString stringWithFormat:@"%@",fabricIDArr[i]];
                    NSDictionary *fabricDict = [dataDict objectForKey:key];
                    //NSLog(@"%@",fabricDict);
                    if (fabricDict && [fabricDict isKindOfClass:[NSDictionary class]]) {
                        for (NSString *key2 in fabricDict) {
                            NSDictionary *partDict = fabricDict[key2][@"part"];
                            if (partDict && [partDict isKindOfClass:[NSDictionary class]]) {
                                NSMutableArray *mArray = [[NSMutableArray alloc]init];
                                for (NSString *key3 in partDict) {
                                    
                                    if ([partDict[key3] count]>0) {
                                        MyCusttomFabricModel *model = [[MyCusttomFabricModel alloc]init];
                                        NSDictionary *infoDict= partDict[key3][@"info"];
                                        for (NSString *key4 in infoDict) {
                                            [model setValue:infoDict[key4] forKey:key4];
                                        }
                                        [_fabricNameArray addObject:model.code];
                                        [mArray addObject:model];
                                    }
                                    
                                    
                                }
                                [_dataArray addObject:mArray];
                            }
                        }
                    }
                }
            }
            //design
            //
            NSMutableDictionary *sinDict = [[NSMutableDictionary alloc]initWithCapacity:0];//存签名数据
            NSMutableDictionary *tDict = [[NSMutableDictionary alloc]initWithCapacity:0];
            NSArray *materialIDArr = [dict objectForKey:@"material"];
            NSArray *designIDArr = [dict objectForKey:@"design"];
            if (designIDArr && [designIDArr isKindOfClass:[NSArray class]]) {
                
                for (int i = 0; i<designIDArr.count; i++) {
                    NSString *key = [NSString stringWithFormat:@"%@",designIDArr[i]];
                    NSDictionary *designErDict = [dataDict objectForKey:key];
                    if (designErDict && [designErDict isKindOfClass:[NSDictionary class]]) {
                        for (NSString *key1 in designErDict) {
                            //先找里料 找到 加到第二 删除
                            for (int j = 0; j<materialIDArr.count; j++) {
                                if ([key1 isEqualToString:[NSString stringWithFormat:@"%@",materialIDArr[j]]]) {
                                    //NSLog(@"有里料");
                                    [_categoryArray addObject:@"里料设计"];
                                    
                                    NSDictionary *partDict = designErDict[key1][@"part"];
                                    
                                    for (NSString *key2 in partDict) {
                                        NSDictionary *infoDict = partDict[key2][@"info"];
                                        MyCusttomFabricModel *model = [[MyCusttomFabricModel alloc]init];
                                        for (NSString *key3 in infoDict) {
                                            [model setValue:infoDict[key3] forKey:key3];
                                        }
                                        [_materialArray addObject:model];
                                    }
                                    [_dataArray addObject:_materialArray];
                                    //删除
                                    
                                    tDict = [designErDict mutableCopy];
                                    [tDict removeObjectForKey:key1];
                                    //NSLog(@"tDict--->%@",tDict);
                                }
                            }
                        }
                        BOOL b = 0;
                        for (NSString *key1 in designErDict) {
                            //再找签名，找到 存住。删除。
                            NSDictionary *sDict = designErDict[key1][@"part"];
                            if (sDict && [sDict isKindOfClass:[NSDictionary class]]) {
                                for (NSString *key2 in sDict) {
                                    NSDictionary *infoDict = sDict[key2][@"info"];
                                    if ([infoDict[@"personality"] isEqualToString:@"location"]) {
                                        sinDict = [sDict mutableCopy];
                                        [tDict removeObjectForKey:key1];
                                        
                                        for (NSString *key3 in tDict) {
                                            NSDictionary *caDict = catedict[key3];
                                            if (caDict && [caDict isKindOfClass:[NSDictionary class]]) {
                                                [_categoryArray addObject:caDict[@"cate_name"]];
                                            }
                                        }
                                        b=1;
                                        break;
                                    }
                                }if (b==1) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            //找到扣子 加到 第三，删除。留下剩余的。
            for (NSString *key in tDict) {
                for (int i = 0; i<buttonsArray.count; i++) {
                    if ([key isEqualToString:[NSString stringWithFormat:@"%@",buttonsArray[i]]]) {
                        //加名字
                        //[_categoryArray addObject:@"扣子装饰"];
                        //加数据， 然后删除
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        NSDictionary *butDict = tDict[key][@"part"];
                        for (NSString *key2 in butDict) {
                            NSDictionary *infoDict = butDict[key2][@"info"];
                            MyCusttomFabricModel *model = [[MyCusttomFabricModel alloc]init];
                            for (NSString *key3 in infoDict) {
                                [model setValue:infoDict[key3] forKey:key3];
                            }
                            [arr addObject:model];
                        }
                        [_dataArray addObject:arr];
                        //删除
                        [tDict removeObjectForKey:key];
                    }
                }
            }
            //数据 (design 剩余的)
            for (NSString *key3 in tDict) {
                NSMutableArray *diArray = [[NSMutableArray alloc]init];
                if (tDict[key3] && [tDict isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *di = tDict[key3][@"part"];
                    for (NSString *key4 in di) {
                        NSDictionary *infoDict = di[key4][@"info"];
                        MyCusttomFabricModel *model = [[MyCusttomFabricModel alloc]init];
                        for (NSString *key5 in infoDict) {
                            [model setValue:infoDict[key5] forKey:key5];
                        }
                        [diArray addObject:model];
                    }
                    [_dataArray addObject:diArray];
                }
            }
            
            
            NSArray *styleIDArr = dict[@"style"];
            if (styleIDArr && [styleIDArr isKindOfClass:[NSArray class]]) {
                for (int i = 0; i<styleIDArr.count; i++) {
                    NSString *key =[NSString stringWithFormat:@"%@",styleIDArr[i]];
                    NSDictionary *styleDict = dataDict[key];
                    if (styleDict && [styleDict isKindOfClass:[NSDictionary class]]) {
                        //名字
                        NSDictionary *nDict = catedict[key];
                        [_categoryArray addObject:nDict[@"cate_name"]];
                        
                        //加数据
                        NSDictionary *tyDict = dataDict[key];
                        NSMutableArray *styArr = [[NSMutableArray alloc]init];
                        for (NSString *key2 in tyDict) {
                            //style 的 二级名字
                            NSDictionary *cadi = catedict[key2];
                            if (cadi && [cadi isKindOfClass:[NSDictionary class]]) {
                                [_styleErNameArray addObject:cadi[@"cate_name"]];
                            }
                            NSMutableArray *styArr2 = [[NSMutableArray alloc]init];
                            NSDictionary *dict2 = tyDict[key2][@"part"];
                            if (dict2 && [dict2 isKindOfClass:[NSDictionary class]]) {
                                for (NSString *key3 in dict2) {
                                    NSDictionary *jDict = dict2[key3];
                                    if (jDict && [jDict isKindOfClass:[NSDictionary class]]) {
                                        NSDictionary *infoDict = jDict[@"info"];
                                        if (infoDict && [infoDict isKindOfClass:[NSDictionary class]]) {
                                            MyCusttomFabricModel *model = [[MyCusttomFabricModel alloc]init];
                                            for (NSString *key4 in infoDict) {
                                                [model setValue:infoDict[key4] forKey:key4];
                                            }
                                            [styArr2 addObject:model];
                                        }
                                    }
                                    
                                }
                                [styArr addObject:styArr2];
                            }
                        }
                        [_dataArray addObject:styArr];
                    }
                }
            }
            //加个性签名
            NSMutableArray *sinArr = [[NSMutableArray alloc]init];
            if (sinDict && [sinDict isKindOfClass:[NSDictionary class]]) {
                //名字
                [_categoryArray addObject:@"个性签名"];
                //数据
                for (NSString *key in sinDict) {
                    NSDictionary *siD = sinDict[key][@"info"];
                    MyCusttomFabricModel *model = [[MyCusttomFabricModel alloc]init];
                    for (NSString *key1 in siD) {
                        [model setValue:siD[key1] forKey:key1];
                    }
                    [sinArr addObject:model];
                }
                [_dataArray addObject:sinArr];
            }
//            NSLog(@"sindict---->%@",sinDict);
//            NSLog(@"_dataArray--->%@",_dataArray);
//            NSLog(@"_category--->%@",_categoryArray);
            
           //对应的图片的网址
            if (_fabricNameArray.count > 0) {
                NSString *mlNameKey = [NSString stringWithFormat:@"ML%@",_fabricNameArray[0]];
                //NSArray *arr = dict[mlNameKey];
                _bigImgArray = dict[mlNameKey];
            }
            
            
            //解析SIZE数据
            _sizeArray = dict[@"size"];
            //NSLog(@"_sizeArray-->%@",_sizeArray);
            
        }
        [self CreateSurfaceMaterialView:0];
    }
    //导航栏的 title
    NSString *cst_cate = _customsDict[@"cst_cate"];
    int index = [cst_cate intValue];
    [self reloadTitle:index];
    
    //计算价格
    _seleFabricModel = _dataArray[0][0];
    
    if (_materialArray.count>0) {
        _seleMaterialModel = _materialArray[0];
    }
    else{
        [_seleMaterialModel setValue:@"0" forKeyPath:@"price"];
    }
    _service_fee = _customsDict[@"service_fee"];
    [self RefreshTotalPrice];
    [self CreateBottomUI];
    //大图网址
    _addCartBigImgUrl = _bigImgArray[0];
    
    //分离出来 签名的每项数据
    [self dealPersnalData];
    
    //item
    //8001:616815|313:315|371:1343|24:130|24:148|24:195|24:215|24:31914|24:36|417:31173|417:528|417:420
    
    _markArray = [[NSMutableArray alloc]init];
    NSNumber *num = [NSNumber numberWithInt:0];
    for (int i = 0; i<_dataArray.count; i++) {
        if (i<_dataArray.count-1 && [_dataArray[i][0] isKindOfClass:[MyCusttomFabricModel class]] ) {
            [_markArray addObject:num];
        }
        else if (i<_dataArray.count-1 && [_dataArray[i][0] isKindOfClass:[NSArray class]]){
            NSMutableArray *subArr = [[NSMutableArray alloc]init];
            for (int j = 0; j<[_dataArray[i] count]; j++) {
                [subArr addObject:num];
            }
            [_markArray addObject:subArr];
        }
        else if (i == _dataArray.count-1){
            NSMutableArray *subArr = [[NSMutableArray alloc]init];
            [subArr addObject:num];
            
            [subArr addObject:num];
            
            [subArr addObject:num];
            [_markArray addObject:subArr];
        }
    }
    NSLog(@"_dataArray--->%@",_dataArray);
    NSLog(@"_markArray--->%@",_markArray);
}

- (void)dealPersnalData
{
    NSArray *perArray = [_dataArray lastObject];
    _fontArray = [[NSMutableArray alloc]init];
    _locationArray = [[NSMutableArray alloc]init];
    _colorArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<perArray.count; i++) {
        MyCusttomFabricModel *model = perArray[i];
        if ([model.personality isEqualToString:@"color"]) {
            [_colorArray addObject:model];
        }
        else if ([model.personality isEqualToString:@"location"]){
            [_locationArray addObject:model];
        }
        else if ([model.personality isEqualToString:@"font"]){
            [_fontArray addObject:model];
        }
    }
    [_dataArray removeLastObject];
    NSArray *arr = [NSArray arrayWithObjects:_fontArray,_colorArray,_locationArray, nil];
    [_dataArray addObject:arr];
}

- (void)OnPopCancelClick
{
    [_sizePopVIewCancleBtn removeFromSuperview];
    _sizePopView.hidden = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sizeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"id";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    cell.textLabel.text = _sizeArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_sizePopVIewCancleBtn removeFromSuperview];
    _sizeLabel.text = _sizeArray[indexPath.row];
    _sizePopView.hidden = YES;
}
- (void)OnSelected:(UITapGestureRecognizer *)tap
{
    [_sizePopVIewCancleBtn removeFromSuperview];
    _sizeLabel.text = _sizeArray[tap.view.tag];
    _sizePopView.hidden = YES;
}
- (void)OnLoadFail:(ImageDownManager *)sender
{
    SAFE_CANCEL_ARC(sender);
}

- (void)CreateSurfaceMaterialView:(int)index
{
    //NSLog(@"index--->%d",index);
    UIScrollView *surfaceMaterialView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 70)];
    surfaceMaterialView.backgroundColor = [UIColor clearColor];
    surfaceMaterialView.showsHorizontalScrollIndicator = NO;
    surfaceMaterialView.tag = 1000+index;
    
    [_contentView addSubview:surfaceMaterialView];
    NSArray *ar = _dataArray[index];
    int iWidth = (self.view.bounds.size.width-45)/8;
    for (int i = 0; i<ar.count; i++) {
        MyCusttomFabricModel *model = ar[i];
        NetImageView *fabricView = [[NetImageView alloc]initWithFrame:CGRectMake(5+i*(iWidth+5), 12, iWidth, 38)];
        fabricView.mImageType = TImageType_CutFill;
        [surfaceMaterialView addSubview:fabricView];
        if (index == 0) {
            [fabricView GetImageByStr:model.part_small];
        }
        else{
            [fabricView GetImageByStr:model.s_img];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(3+i*(iWidth+5), 10, iWidth+4, 38+4);
        if (index==0) {
            btn.tag = 300+i;
            if (i==0) {
                _seleBtn1 = btn;
                _seleBtn1.selected = YES;
            }
        }
        else if (index==1) {
            btn.tag = 310+i;
            if (i==0) {
                _seleBtn2 = btn;
                _seleBtn2.selected = YES;
            }
        }
        else if (index==2) {
            btn.tag = 320+i;
            if (i==0) {
                _seleBtn3 = btn;
                _seleBtn3.selected = YES;
            }
        }
        else if (index==3) {
            btn.tag = 330+i;
            if (i==0) {
                _seleBtn4 = btn;
                _seleBtn4.selected = YES;
            }
        }
        else if (index==4) {
            btn.tag = 340+i;
            if (i==0) {
                _seleBtn5 = btn;
                _seleBtn5.selected = YES;
            }
        }
        else if (index==5) {
            btn.tag = 350+i;
            if (i==0) {
                _seleBtn6 = btn;
                _seleBtn6.selected = YES;
            }
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"custtom_sele_btn.png"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"custtom_nor_btn.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ChooseSurfaceMaterialBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [surfaceMaterialView addSubview:btn];
    }
}


- (void)ChooseSurfaceMaterialBtnClick:(UIButton *)btn
{
    NSLog(@"btn.tag--->%d",btn.tag);
    if (btn.tag<310) {
        _seleBtn1.selected = NO;
        _seleBtn1 = btn;
        _seleBtn1.selected = YES;
        NSArray *mlArr = _dataArray[0];
        _seleFabricModel = mlArr[btn.tag-300];
        [self RefreshTotalPrice];
        
        NSNumber *num =  [NSNumber numberWithInt:btn.tag-300];
        [_markArray replaceObjectAtIndex:0 withObject:num];
    }
    else if (btn.tag<320&&btn.tag>=310) {
        _seleBtn2.selected = NO;
        _seleBtn2 = btn;
        _seleBtn2.selected = YES;
        //www.rctailor.com/custom/231/DSA490A//material/FLL624-123.jpg
        //http://www.rctailor.com/upload_user_photo/custom/256/DSA507A/material/FLLDL015.jpg
        //面料编号
        NSArray *mlArr = _dataArray[0];
        MyCusttomFabricModel *model = mlArr[0];
        NSString *mlStr = model.code;
        //里料 big_img
        NSArray *llArr = _dataArray[1];
        model = llArr[btn.tag-310];
        NSString *llStr = model.b_img;
        //刷新大图
        NSString *imgURl = [NSString stringWithFormat:@"http://www.rctailor.com/upload_user_photo/custom/%@/%@/%@",self.IDStr,mlStr,llStr];
        NSLog(@"imgURl--->%@",imgURl);
        [_bigImg GetImageByStr:imgURl];
        
        
        //计算价格
        if (_materialArray.count>0) {
            _seleMaterialModel = llArr[btn.tag - 310];
        }
        [self RefreshTotalPrice];
        
        NSNumber *num =  [NSNumber numberWithInt:btn.tag-310];
        [_markArray replaceObjectAtIndex:1 withObject:num];
    }
    else if (btn.tag<330&&btn.tag>=320) {
        _seleBtn3.selected = NO;
        _seleBtn3 = btn;
        _seleBtn3.selected = YES;
        
        //http://www.rctailor.com/custom/231/DSA490A/10004/KZ611-HK214-XX178-XKD148-XKDXS132-QMK37-MLDSA490A.jpg
        //http://dev.qqtailor.com/upload_user_photo/custom/231/DSA490A/10004/KZ611-HK214-XX178-XKD148-XKDXS132-BTX51-QMK37-MLDSA490A.jpg
        if (_dataArray[2] && [_dataArray[2][0] isKindOfClass:[MyCusttomFabricModel class]] && _fabricNameArray.count>0) {
            MyCusttomFabricModel *model= _dataArray[2][btn.tag-320];
            NSString *str = [NSString stringWithFormat:@"KZ%@",model.part_id];
            NSLog(@"str.lenth--->%d",str.length);
            for (int i = 0; i<_bigImgArray.count; i++) {
                NSString *mStr = _bigImgArray[i];
                NSLog(@"mStr.lenth--->%d",mStr.length);
                for (int j = 0; j<mStr.length - str.length; j++) {
                    NSRange range = {j,str.length};
                    NSString *subStr = [mStr substringWithRange:range];
                    if ([str isEqualToString:subStr]) {
                        if (_fabricNameArray.count > 0) {
                            _addCartBigImgUrl = mStr;
                            _imgUrl = [NSString stringWithFormat:@"http://www.rctailor.com/upload_user_photo/custom/%@/%@/10004/%@.jpg",self.IDStr,_fabricNameArray[0],mStr];
                            [_bigImg GetImageByStr:_imgUrl];
                        }
                    }
                }
            }
        }
        
        NSNumber *num =  [NSNumber numberWithInt:btn.tag-320];
        [_markArray replaceObjectAtIndex:2 withObject:num];
    }
    else if (btn.tag<340&&btn.tag>=330) {
        _seleBtn4.selected = NO;
        _seleBtn4 = btn;
        _seleBtn4.selected = YES;
    }
    else if (btn.tag<350&&btn.tag>=340) {
        _seleBtn5.selected = NO;
        _seleBtn5 = btn;
        _seleBtn5.selected = YES;
    }
    else if (btn.tag<360&&btn.tag>=350) {
        _seleBtn6.selected = NO;
        _seleBtn6 = btn;
        _seleBtn6.selected = YES;
    }
    NSLog(@"_markArray--->%@",_markArray);
}

- (void)CreateDIYSubView:(int)index{
    UIScrollView *frontGateStyleScrollView = [[UIScrollView alloc]initWithFrame:_DIYView.bounds];
    frontGateStyleScrollView.backgroundColor = [UIColor clearColor];
    frontGateStyleScrollView.tag =1800+index;
    [_DIYView addSubview:frontGateStyleScrollView];
    
    
    int iWidth = (self.view.bounds.size.width-120)/6;
    for (int i = 0; i<[_DIYDataArray[index] count]; i++) {
        MyCusttomFabricModel *model = _DIYDataArray[index][i];
        NetImageView *fabricView = [[NetImageView alloc]initWithFrame:CGRectMake(10+i*(iWidth+20), 10, iWidth, 35)];
        fabricView.mImageType = TImageType_CutFill;
        [frontGateStyleScrollView addSubview:fabricView];
        [fabricView GetImageByStr:model.s_img];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7+i*(iWidth+20), 7, iWidth+6, 35+6);
        [btn setBackgroundImage:[UIImage imageNamed:@"custtom_sele_btn.png"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"custtom_nor_btn.png"] forState:UIControlStateNormal];
        btn.tag = 200+i+index*10000;
        [btn addTarget:self action:@selector(DiyfrontGateStyleSeleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [frontGateStyleScrollView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        }
    }
}

- (void)CreateDIYView:(int)index
{
    _DIYDataArray = _dataArray[index];
    UIScrollView *diyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _contentView.frame.size.height)];
    diyScrollView.backgroundColor = [UIColor clearColor];
    diyScrollView.showsHorizontalScrollIndicator = NO;
    diyScrollView.showsVerticalScrollIndicator = NO;
    diyScrollView.tag = 1000+index;
    [_contentView addSubview:diyScrollView];
    
    CategorySelectedView *SeleView = [[CategorySelectedView alloc]initWithFrame:CGRectMake(0, 55, self.view.bounds.size.width, 30)];
    SeleView.Color = [UIColor colorWithWhite:0.93 alpha:1];
    [SeleView reloadColor];
    SeleView.miIndex = 0;
    SeleView.mArray = _styleErNameArray;
    [SeleView reloadData];
    SeleView.delegate = self;
    SeleView.OnTypeSelect = @selector(DiyTypeSeleBtnClick:);
    [diyScrollView addSubview:SeleView];
    
    _DIYView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 55)];
    _DIYView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [diyScrollView addSubview:_DIYView];
    
    [self CreateDIYSubView:0];
    
}


- (void)DiyTypeSeleBtnClick:(CategorySelectedView *)sender
{
    BOOL d = NO;
    for (UIScrollView *view in _DIYView.subviews) {
        if (view.tag == sender.miIndex+1800) {
            d = YES;
        }
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.hidden = (view.tag!= sender.miIndex+1800);
        }
    }
    if (d == NO) {
        
        for (int i = 0; i<_DIYDataArray.count; i++) {
            if (sender.miIndex == i) {
                [self CreateDIYSubView:i];
            }
        }
    }
}


- (void)DiyfrontGateStyleSeleBtnClick:(UIButton *)btn;
{
    int index = btn.tag/10000;
    UIScrollView *view = (UIScrollView *)[_DIYView viewWithTag:index+1800];
    for (UIButton *subBtn in view.subviews) {
        if (subBtn && [subBtn isKindOfClass:[UIButton class]] &&subBtn.selected) {
            subBtn.selected = NO;
        }
    }
    btn.selected = YES;
    int btnCount = btn.tag-index*10000-200;
    
    NSMutableArray *arr = _markArray[_markArray.count-2];
    NSNumber *num = [NSNumber numberWithInt:btnCount];
    [arr replaceObjectAtIndex:index withObject:num];
    NSLog(@"_markArray--->%@",_markArray);
}

- (void)CreateBottomUI
{
    //大图片
    [_bigImg GetImageByStr:_customsDict[@"cst_image"]];
    
    UIImageView *seleViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 450, self.view.bounds.size.width, 40)];
    seleViewBg.backgroundColor = [UIColor clearColor];
    seleViewBg.userInteractionEnabled = YES;
    [_scrollView addSubview:seleViewBg];
    CategorySelectedView *SeleView = [[CategorySelectedView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    SeleView.miIndex = 0;
    SeleView.mArray = _categoryArray;
    [SeleView reloadData];
    SeleView.delegate = self;
    SeleView.OnTypeSelect = @selector(btnClick:);
    [seleViewBg addSubview:SeleView];
    
    UIView *measureTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 490, self.view.bounds.size.width, 40)];
    measureTypeView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:measureTypeView];
    
    LocationBtn *lBtn = [LocationBtn buttonWithType:UIButtonTypeCustom];
    lBtn.frame = CGRectMake(50, 12, 15+90, 21);
    [lBtn setImage:[UIImage imageNamed:@"gg_07.png"] forState:UIControlStateNormal];
    [lBtn setImage:[UIImage imageNamed:@"53@2x.png"] forState:UIControlStateSelected];
    lBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [lBtn setTitle:@"我需要量体" forState:UIControlStateNormal];
    [lBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    lBtn.tag = 1400;
    [lBtn addTarget:self action:@selector(MeasureTypeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [measureTypeView addSubview:lBtn];
    _measureTypeBtn = lBtn;
    _measureTypeBtn.selected = YES;
    
    lBtn = [LocationBtn buttonWithType:UIButtonTypeCustom];
    lBtn.frame = CGRectMake(170, 12, 15+90, 21);
    [lBtn setImage:[UIImage imageNamed:@"gg_07.png"] forState:UIControlStateNormal];
    [lBtn setImage:[UIImage imageNamed:@"53@2x.png"] forState:UIControlStateSelected];
    lBtn.tag = 1401;
    lBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [lBtn setTitle:@"选择标准码" forState:UIControlStateNormal];
    [lBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [lBtn addTarget:self action:@selector(MeasureTypeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [measureTypeView addSubview:lBtn];
    
    _measureView = [[UIView alloc]initWithFrame:CGRectMake(0, 530, self.view.bounds.size.width, 50)];
    _measureView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_measureView];
    
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, 30, 20)];
    heightLabel.font = [UIFont systemFontOfSize:13];
    heightLabel.text = @"身高";
    heightLabel.backgroundColor = [UIColor clearColor];
    heightLabel.textColor = [UIColor darkGrayColor];
    [_measureView addSubview:heightLabel];
    
    _heightField = [[UITextField alloc]initWithFrame:CGRectMake(55, 13, 65, 24)];
    _heightField.borderStyle = UITextBorderStyleRoundedRect;
    _heightField.delegate = self;
    _heightField.font = [UIFont systemFontOfSize:13];
    _heightField.textColor = [UIColor darkGrayColor];
    _heightField.textAlignment = NSTextAlignmentRight;
    [_measureView addSubview:_heightField];
    
    heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 15, 25, 20)];
    heightLabel.text = @"CM";
    heightLabel.backgroundColor = [UIColor clearColor];
    heightLabel.font = [UIFont systemFontOfSize:13];
    heightLabel.textColor = [UIColor darkGrayColor];
    [_measureView addSubview:heightLabel];
    
    heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 15, 30, 20)];
    heightLabel.backgroundColor = [UIColor clearColor];
    heightLabel.font = [UIFont systemFontOfSize:13];
    heightLabel.text = @"体重";
    heightLabel.textColor = [UIColor darkGrayColor];
    [_measureView addSubview:heightLabel];
    
    _weightField = [[UITextField alloc]initWithFrame:CGRectMake(200, 13, 65, 24)];
    _weightField.borderStyle = UITextBorderStyleRoundedRect;
    _weightField.delegate = self;
    _weightField.font = [UIFont systemFontOfSize:13];
    _weightField.textColor = [UIColor darkGrayColor];
    _weightField.textAlignment = NSTextAlignmentRight;
    [_measureView addSubview:_weightField];
    
    heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 15, 25, 20)];
    heightLabel.backgroundColor = [UIColor clearColor];
    heightLabel.font = [UIFont systemFontOfSize:13];
    heightLabel.text = @"KG";
    heightLabel.textColor = [UIColor darkGrayColor];
    [_measureView addSubview:heightLabel];
    
    _mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35)];
    _mBackView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    //_mBackView.backgroundColor = [UIColor yellowColor];
    _mBackView.userInteractionEnabled = YES;
    _mBackView.hidden = YES;
    [self.view addSubview:_mBackView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 2, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(OnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_mBackView addSubview:cancelBtn];
    
    UILabel *tiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    tiLabel.center = CGPointMake(self.view.bounds.size.width/2,15);
    tiLabel.backgroundColor = [UIColor clearColor];
    tiLabel.text = @"请输入";
    tiLabel.textAlignment = NSTextAlignmentCenter;
    tiLabel.font = [UIFont systemFontOfSize:16];
    tiLabel.textColor = [UIColor darkGrayColor];
    [_mBackView addSubview:tiLabel];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.view.frame.size.width-50, 2, 40, 30);
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn setTitleColor:WORDGRAYCOLOR forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(OnSendClick) forControlEvents:UIControlEventTouchUpInside];
    [_mBackView addSubview:sendBtn];
    
    _standardView = [[UIView alloc]initWithFrame:CGRectMake(0, 530, self.view.bounds.size.width, 50)];
    _standardView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_standardView];
    _standardView.hidden = YES;
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 50, 20)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.font = [UIFont systemFontOfSize:13];
    mLabel.text = @"选择";
    mLabel.textColor = [UIColor darkGrayColor];
    [_standardView addSubview:mLabel];
    
    
    _sizePopView = [[UITableView alloc]initWithFrame:CGRectMake(70, 545-125, 170, 125)];
    _sizePopView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _sizePopView.hidden = YES;
    //_sizePopView.hidden = NO;
    _sizePopView.delegate = self;
    _sizePopView.dataSource = self;
    [_scrollView addSubview:_sizePopView];
    
    
    _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 170, 20)];
    if (_sizeArray.count > 0) {
        _sizeLabel.text = _sizeArray[0];
    }
    _sizeLabel.font = [UIFont systemFontOfSize:13];
    _sizeLabel.textColor = [UIColor darkGrayColor];
    [_standardView addSubview:_sizeLabel];
    
    UIImageView *popViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(70, 15, 170, 20)];
    popViewBg.image = [UIImage imageNamed:@"pop_label_bg.png"];
    popViewBg.userInteractionEnabled = YES;
    [_standardView addSubview:popViewBg];
    
    [_standardView bringSubviewToFront:_sizeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SizeClick)];
    [popViewBg addGestureRecognizer:tap];
    
    //尺码表 按钮
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(247, 15, 63, 20);
    [cBtn setTitle:@"查看尺码表" forState:UIControlStateNormal];
    [cBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cBtn addTarget:self action:@selector(ShowBiao) forControlEvents:UIControlEventTouchUpInside];
    [_standardView addSubview:cBtn];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 580, self.view.bounds.size.width, 0.6)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [_scrollView addSubview:line];
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 530, self.view.bounds.size.width, 0.6)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [_scrollView addSubview:line];
    
    heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 600, 80, 20)];
    heightLabel.text = @"应付总额：";
    heightLabel.font = [UIFont systemFontOfSize:16];
    heightLabel.textColor = [UIColor darkGrayColor];
    heightLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:heightLabel];
    
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(self.view.bounds.size.width-95, 595, 76.5, 30);
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"CustomDetailBuy.png"] forState:UIControlStateNormal];
    buyBtn.tag = 200;
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buyBtn];
    
    [self CreateRelaUI];
}
- (void)ShowBiao{
    ShowBiaoViewController *svc = [[ShowBiaoViewController alloc]init];
    svc.idStr = _customsDict[@"cst_cate"];
    [self.navigationController pushViewController:svc animated:YES];
    
}
- (void)GetCusttomDetail{
    NSLog(@"跳到网页");
    MyCusttomDetailDetailViewController *dvc = [[MyCusttomDetailDetailViewController alloc]init];
    dvc.urlString = _customsDict[@"cst_content"];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)CreateRelaUI
{
    UIImageView *desBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 638, self.view.bounds.size.width, 69.5)];
    desBg.userInteractionEnabled = YES;
    desBg.image = [UIImage imageNamed:@"mycusttom_detail_detail.png"];
    [_scrollView addSubview:desBg];
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GetCusttomDetail)];
    [desBg addGestureRecognizer:click];
    
    UIImageView *subView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-20, 30, 11, 16.5)];
    subView.image = [UIImage imageNamed:@"mycusttom_detail_des_sub2.png"];
    [desBg addSubview:subView];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width-30, 20)];
    mLabel.textColor = [UIColor darkGrayColor];
    mLabel.font = [UIFont systemFontOfSize:13];
    mLabel.text = _customsDict[@"cst_name"];
    [desBg addSubview:mLabel];
    
    mLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, self.view.bounds.size.width-50, 35)];
    mLabel.textColor = WORDGRAYCOLOR;
    mLabel.font = [UIFont systemFontOfSize:11];
    mLabel.text = _customsDict[@"cst_description"];
    mLabel.numberOfLines = 2;
    [desBg addSubview:mLabel];
    
    UIImageView *titleView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 720, 189/2, 25)];
    titleView.image = [UIImage imageNamed:@"mycusttom_detail_rela_title.png"];
    [_scrollView addSubview:titleView];
    
    UIScrollView *subGoodsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 755, self.view.bounds.size.width, 125)];
    subGoodsView.backgroundColor = [UIColor clearColor];
    subGoodsView.showsHorizontalScrollIndicator = NO;
    subGoodsView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:subGoodsView];
    
    for (int i = 0; i<_relationGoodsArray.count; i++) {
        double w = 80;
        double h = 130;
        double x = 20 + i*(80+20);
        double y = 0;
        UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        bg.tag = i+90;
        bg.userInteractionEnabled = YES;
        [subGoodsView addSubview:bg];
        UIImageView *imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, 105)];
        imgBg.image = [UIImage imageNamed:@"mycusttom_detail_subgoods.png"];
        [bg addSubview:imgBg];
        
        NetImageView *netView = [[NetImageView alloc]initWithFrame:CGRectMake(1, 1, w-2, 105-2)];
        netView.mImageType = TImageType_CutFill;
        [bg addSubview:netView];
        [netView GetImageByStr:_relationGoodsArray[i][@"cst_image"]];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 105, w, 25)];
        nameLabel.text = _relationGoodsArray[i][@"cst_name"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:11.5];
        nameLabel.textColor = [UIColor darkGrayColor];
        [bg addSubview:nameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SubgoodsClick:)];
        [bg addGestureRecognizer:tap];
    }
    subGoodsView.contentSize = CGSizeMake(20+_relationGoodsArray.count*(100), 125);
    
}
- (void)SubgoodsClick:(UITapGestureRecognizer *)tap{
    NSLog(@"tap-->%d",tap.view.tag);
    MyCustomDetailViewController *mcdvc = [[MyCustomDetailViewController alloc] init];
    NSDictionary *dict = _relationGoodsArray[tap.view.tag-90];
    mcdvc.IDStr = dict[@"cst_id"];
    [mcdvc StartDownload];
    [self.navigationController pushViewController:mcdvc animated:YES];
}
- (void)SizeClick
{
    NSLog(@"ok");
    [_scrollView addSubview:_sizePopVIewCancleBtn];
    _sizePopView.hidden = NO;
    [_scrollView bringSubviewToFront:_sizePopView];
}
- (void)OnSendClick{
    _mBackView.hidden = YES;
    _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
    [_scrollView setContentOffset:CGPointMake(0, 244) animated:YES];
    [_keyboardCancleBut removeFromSuperview];
    if ([_weightField isFirstResponder]) {
        [_weightField resignFirstResponder];
    }
    else{
        [_heightField resignFirstResponder];
    }
}
- (void)OnCancelClick{
    if (!_mBackView.hidden) {
        [_keyboardCancleBut removeFromSuperview];
        _mBackView.hidden = YES;
        _mBackView.frame = CGRectMake(0, self.view.frame.size.height-35, self.view.frame.size.width, 35);
        [_scrollView setContentOffset:CGPointMake(0, 244) animated:YES];
        
        if ([_weightField isFirstResponder]) {
            [_weightField resignFirstResponder];
        }
        else{
            [_heightField resignFirstResponder];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_scrollView setContentOffset:CGPointMake(0, 444) animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void)RegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CusttomKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CusttomKeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [self RegisterForKeyboardNotifications];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)CusttomKeyboardWillShow:(NSNotification *) notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [_scrollView addSubview:_keyboardCancleBut];
    
    int iHeight = keyboardSize.height;
    //    if (iHeight>35) {
    //        iHeight -= 35;
    //    }
    _mBackView.hidden = NO;
    NSLog(@"keyboardWasShown%d", iHeight);
    [UIView animateWithDuration:0.1 animations:^{
        _mBackView.frame = CGRectMake(0, self.view.frame.size.height-iHeight-35, self.view.frame.size.width, 35);
    } completion:nil];
    
}
- (void)CusttomKeyboardWillHidden:(NSNotification *) notif{
    //刷新 总价格
    [self RefreshTotalPrice];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancle];
}

- (void)MeasureTypeSwitch:(UIButton *)btn
{
    if (_measureTypeBtn!=btn) {
        _measureTypeBtn.selected = NO;
        _measureTypeBtn = btn;
        _measureTypeBtn.selected = YES;
        if (btn.tag == 1400) {
            _measureView.hidden = NO;
            _standardView.hidden = YES;
            _is_diy = @"1";
        }
        if (btn.tag == 1401) {
            _measureView.hidden = YES;
            _standardView.hidden = NO;
            _heightField.text = @"";
            _weightField.text = @"";
            [self RefreshTotalPrice];
            _is_diy = @"0";
        }
    }
}
- (void)buyBtnClick:(UIButton *)btn
{
    if (![UserInfoManager Share].mbLogin) {
        LoginViewController *ctrl = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else{
        [self CreateItem];
        [self AddCart];
    }
}
- (void)CreateItem{
    _item = [[NSMutableString alloc]initWithCapacity:0];
    for (int i = 0; i<_dataArray.count; i++) {
        if (i<_dataArray.count-1 && [_dataArray[i][0] isKindOfClass:[MyCusttomFabricModel class]] ) {
            NSNumber *num = _markArray[i];
            MyCusttomFabricModel *model = _dataArray[i][[num intValue] ];
            [_item appendString:model.parent_cate];
            [_item appendString:@":"];
            [_item appendString:model.part_id];
            [_item appendString:@"|"];
        }
        else if (i<_dataArray.count-1 && [_dataArray[i][0] isKindOfClass:[NSArray class]]){
            for (int j = 0; j<[_dataArray[i] count]; j++) {
                NSNumber *num = _markArray[i][j];
                MyCusttomFabricModel *model = _dataArray[i][j][[num intValue]];
                [_item appendString:model.top_cate];
                [_item appendString:@":"];
                [_item appendString:model.part_id];
                [_item appendString:@"|"];
            }
        }
        else if (i == _dataArray.count-1){
            NSArray *arr = [_markArray lastObject];
            NSNumber *num = arr[0];
            MyCusttomFabricModel *model = _fontArray[[num intValue]];
            [_item appendString:model.parent_cate];
            [_item appendString:@":"];
            [_item appendString:model.part_id];
            [_item appendString:@"|"];
            num = arr[1];
            model = _colorArray[[num intValue]];
            [_item appendString:model.parent_cate];
            [_item appendString:@":"];
            [_item appendString:model.part_id];
            [_item appendString:@"|"];
            num = arr[2];
            model = _locationArray[[num intValue]];
            [_item appendString:model.parent_cate];
            [_item appendString:@":"];
            [_item appendString:model.part_id];
        }
    }
    NSLog(@"_ITEM-->%@",_item);
}
- (void)btnClick:(CategorySelectedView *)sender
{
    if (sender.miIndex == 0) {
        [_bigImg GetImageByStr:_customsDict[@"cst_image"]];
    }
    BOOL b = NO;
    for (UIScrollView *view in _contentView.subviews) {
        if (view.tag-1000 == sender.miIndex) {
            b = YES;
        }
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.hidden = (view.tag-1000 != sender.miIndex);
        }
    }
    if (b == NO) {
    //说明 还没有创建
        if (sender.miIndex <_dataArray.count-1) {
            for (int i = 0; i<_dataArray.count; i++) {
                if (sender.miIndex == i) {
                    if (_dataArray[sender.miIndex][0] && [_dataArray[sender.miIndex][0] isKindOfClass:[MyCusttomFabricModel class]]) {
                        [self CreateSurfaceMaterialView:sender.miIndex];
                        //NSLog(@"ooko");
                    }
                    else if (_dataArray[sender.miIndex][0] && [_dataArray[sender.miIndex][0] isKindOfClass:[NSArray class]]){
                        [self CreateDIYView:sender.miIndex];
                    }
                }
            }
        }
        //创建签名 页面
        else if(sender.miIndex == _dataArray.count-1) {
            PersonalizedSignatureViewController *pvc = [[PersonalizedSignatureViewController alloc]init];
            pvc.fontArray = [_dataArray lastObject][0];
            pvc.colorArray = [_dataArray lastObject][1];
            pvc.locationArray = [_dataArray lastObject][2];
            pvc.emb = _emb;
            NSArray *fArr = [_markArray lastObject];
            if (fArr && [fArr isKindOfClass:[NSArray class]] && (fArr.count == 3)) {
                pvc.a = [fArr[0] intValue];
                pvc.b = [fArr[1] intValue];
                pvc.c = [fArr[2] intValue];
            }
            pvc.block = ^(NSString *emb,int a,int b,int c){
                NSLog(@"%d  %d  %d %@",a,b,c,emb);
                NSArray *fontArr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:a],[NSNumber numberWithInt:b],[NSNumber numberWithInt:c], nil];
                [_markArray removeLastObject];
                [_markArray addObject:fontArr];
                _emb = emb;
                NSLog(@"%@",_markArray);
            };
            [self.navigationController pushViewController:pvc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
