//
//  ThemeDetialViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ThemeDetialViewController.h"
#import "ThemeSubGoodsView.h"
#import "CommentView.h"
#import "NewCommentView.h"
#import "CoolCommentView.h"
#import "ShareSheetView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "SingleListModel.h"
#import "AutoAlertView.h"
#import "NetImageView.h"
#import "ShopCarViewController.h"
#import "CommentModel.h"
#import "CoolCommentModel.h"
#import "MyCustomDetailViewController.h"
#import "LoginViewController.h"
#import "ThemeCommentListViewController.h"
#import "UMSocialWechatHandler.h"
#import "FansInfoViewController.h"
#import "CoolCommentListViewController.h"
#import "PickerSelectView.h"
#import "ShowBiaoViewController.h"

static int hasNest;
@interface ThemeDetialViewController ()
{
    UIScrollView *_scrollView;
    UIImageView *_headView;
    ImageDownManager *_mDownManager;
    ImageDownManager *_addCartDownManager;
    ImageDownManager *_favoManager;
    ImageDownManager *_commentManager;
    ImageDownManager *_downRelaCommentManager;
    UIPageControl *_pageControl;
    NSMutableArray *_listDataArray;
    NSMutableArray *_selectedGoodsArray;
    NSMutableArray *_commentListArray;
    NSString *_imgUrlString;
    NSString *_desImgUrlString;
    UILabel *_selectedPriceLabel;
    UILabel *_selectedCountLabel;
    int _iY;
    NSMutableArray *_seleViewArray;
    UIImageView *_seleImageView;
    
    NSMutableArray *_sizeLabelArray;
    
    ThemeSubGoodsView *_seleSubGoodsView;
    //简介
    NSString *_desString;
    BOOL _isNewComment;
    UIImageView *_commentViewBg;
    
    PickerSelectView *mPickerView;
    int miIndex;
}
@end

@implementation ThemeDetialViewController

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
    _listDataArray = [[NSMutableArray alloc]init];
    _commentListArray = [[NSMutableArray alloc]init];
    _seleViewArray = [[NSMutableArray alloc]init];
    _sizeLabelArray = [[NSMutableArray alloc]init];
    _imgUrlString = [[NSString alloc]init];
    _isNewComment = NO;
    
    [self StartDownload];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    
    
#pragma mark 底部视图
    UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.userInteractionEnabled = YES;
    botView.image = [UIImage imageNamed:@"22底.png"];
    [self.view addSubview:botView];
    
    int iWidth = self.view.frame.size.width/3;
    for (int i = 0; i < 3; i ++) {
        NSString *imagename = [NSString stringWithFormat:@"%d.png", i+112];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*iWidth, 0, iWidth, 50);
        [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        btn.tag = i+1600;
        [btn addTarget:self action:@selector(OnBotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:btn];
    }
}
- (void)reloadUI
{
    
#pragma mark 图片横向滚动视图
    UIScrollView *imgScrollView = [[UIScrollView alloc]initWithFrame:_scrollView.frame];
    imgScrollView.showsHorizontalScrollIndicator = NO;
    imgScrollView.bounces = NO;
    imgScrollView.pagingEnabled = YES;
    imgScrollView.delegate = self;
    [_scrollView addSubview:imgScrollView];
    for (int i = 0; i <1; i++) {
        double w = self.view.bounds.size.width;
        double h = imgScrollView.frame.size.height;
        double x = i * w;
        double y = 0;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        //[imgView setImageWithURL:[NSURL URLWithString:_imgUrlString]];
        NetImageView *netImg = [[NetImageView alloc]initWithFrame:imgView.bounds];
        netImg.mImageType = TImageType_CutFill;
        [imgView addSubview:netImg];
        [netImg GetImageByStr:_imgUrlString];
        [imgScrollView addSubview:imgView];
    }
    imgScrollView.contentSize = CGSizeMake(1 * self.view.bounds.size.width, self.view.bounds.size.height-50);
    
    /*
     _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, _scrollView.frame.size.height-40, 100, 30)];
     _pageControl.numberOfPages = _scrollCount;
     _pageControl.currentPage = 0;
     [_scrollView addSubview:_pageControl];
     */
    
#pragma mark 包含的单品
    UIImageView *subGoodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.view.bounds.size.height-40, 87, 24.5)];
    subGoodsImageView.image = [UIImage imageNamed:@"a_14.png"];
    [_scrollView addSubview:subGoodsImageView];
    
    _seleViewArray = [[NSMutableArray alloc]init];
    _iY = self.view.bounds.size.height;
    for (int i = 0 ; i < _listDataArray.count; i++) {
        SingleListModel *model = [_listDataArray objectAtIndex:i];
        double w = 290;
        double h = 115;
        double x = 15;
        double y = _iY+(h+8)*i-10;
        ThemeSubGoodsView *subView = [[ThemeSubGoodsView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        [subView loadContent:model];
        subView.tag = i;
        subView.delegate = self;
        subView.didSelected = @selector(didClickGood:);
        subView.designBtnClick = @selector(designBtnClick:);
        subView.seleSize = @selector(seleSizeClick:);
        subView.showBiao = @selector(ShowChiMaBiao:);
        NSArray *arr = [[NSArray alloc]init];
        arr = model.biaoZhunMa;
        subView.sizeLabel.text = arr[0];
        [_sizeLabelArray addObject:subView];
        [_scrollView addSubview:subView];
        
    }
    _iY = _iY + _listDataArray.count * 123-8;
#pragma -mark  中间 购买 部分
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(15, _iY, self.view.bounds.size.width-30, 60)];
    _headView.userInteractionEnabled = YES;
    //[_headView setImage:[UIImage imageNamed:@"theme_detail_head_bg.png"]];
    _headView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_headView];
    
    UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 25)];
    [buyLabel setText:@"购买此主题"];
    buyLabel.backgroundColor = [UIColor clearColor];
    buyLabel.font = [UIFont systemFontOfSize:15];
    buyLabel.textColor =[UIColor darkGrayColor];
    [_headView addSubview:buyLabel];
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 32, 40, 20)];
    subLabel.font = [UIFont systemFontOfSize:11];
    subLabel.text = @"已选择";
    subLabel.textColor = WORDGRAYCOLOR;
    subLabel.backgroundColor = [UIColor clearColor];
    [_headView addSubview:subLabel];
    
    subLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 32, 70, 20)];
    subLabel.font = [UIFont systemFontOfSize:11];
    subLabel.text = @"件配搭套餐价:";
    subLabel.textColor = WORDGRAYCOLOR;
    subLabel.backgroundColor = [UIColor clearColor];
    [_headView addSubview:subLabel];
    
    _selectedCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, 31, 15, 20)];
    _selectedCountLabel.font = [UIFont systemFontOfSize:12];
    _selectedCountLabel.textColor = WORDREDCOLOR;
    _selectedCountLabel.textAlignment = UITextAlignmentCenter;
    _selectedCountLabel.backgroundColor = [UIColor clearColor];
    [_headView addSubview:_selectedCountLabel];
    
    _selectedPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 31, 70, 20)];
    _selectedPriceLabel.font = [UIFont systemFontOfSize:12];
    _selectedPriceLabel.textColor = WORDREDCOLOR;
    _selectedCountLabel.backgroundColor = [UIColor clearColor];
    [_headView addSubview:_selectedPriceLabel];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(190, 20, 83, 25);
    [buyBtn addTarget:self action:@selector(OnbuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setImage:[UIImage imageNamed:@"theme_detail_buy_btn.png"] forState:UIControlStateNormal];
    [_headView addSubview:buyBtn];
    int count = [_listDataArray count];
    float totalPrice = 0.0;
    for (SingleListModel *model in _listDataArray) {
        totalPrice+=[model.price floatValue];
    }
    _selectedCountLabel.text = [NSString stringWithFormat:@"%d",count];
    _selectedPriceLabel.text = [NSString stringWithFormat: @"¥%.2f",totalPrice];
    _iY +=75;
    
#pragma mark 简介
    UIImageView  *desView = [[UIImageView alloc]initWithFrame:CGRectMake(15, _iY-4, 88.5, 25)];
    desView.image = [UIImage imageNamed:@"QQ图片20140809092214_06.png"];
    [_scrollView addSubview:desView];
    
    desView = [[UIImageView alloc]initWithFrame:CGRectMake(15, _iY+31, self.view.bounds.size.width-30, 560)];
    desView.userInteractionEnabled = YES;
    desView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:desView];
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, desView.bounds.size.width-10, 45)];
    //desLabel.backgroundColor = [UIColor redColor];
    desLabel.numberOfLines = 3;
    desLabel.text = _desString;
    desLabel.font = [UIFont systemFontOfSize:13];
    desLabel.textColor = [UIColor darkGrayColor];
    desLabel.textAlignment = UITextAlignmentLeft;
    [desView addSubview:desLabel];
    
    NetImageView *netView = [[NetImageView alloc]initWithFrame:CGRectMake(0, 60, desView.bounds.size.width, desView.bounds.size.height - 60)];
    [desView addSubview:netView];
    [netView GetImageByStr:_desImgUrlString];
    
    UIImageView *commentHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(15, _iY+110+500, 87, 27)];
    commentHeadView.image = [UIImage imageNamed:@"111.png"];
    [_scrollView addSubview:commentHeadView];
    
    [self StartDownloadRelaComment];
}

#pragma mark 相关评论

- (void)reloadCommentView{
//    _commentViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, _iY+110, self.view.bounds.size.width, 10)];
//    _commentViewBg.backgroundColor = [UIColor clearColor];
//    _commentViewBg.userInteractionEnabled = YES;
//    [_scrollView addSubview:_commentViewBg];
    
    int mY = 0;
    if (_commentListArray.count>0) {
        for (int i = 0; i<(_commentListArray.count<4?_commentListArray.count:4); i++) {
            CoolCommentModel *model = [_commentListArray objectAtIndex:i];
            double w = self.view.bounds.size.width-20;
            double h = 55;
            double x = 10;
            double y = _iY +110+500 + 30+(h+5)*i;
            NewCommentView *comView = [[NewCommentView alloc]initWithFrame:CGRectMake(x, y, w, h)];
            comView.tag = i;
            comView.delegate = self;
            comView.didSelected = @selector(didClickComment:);
            [comView loadCoolCommentContent:model];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreCommentButtonClick)];
            [comView.commentView addGestureRecognizer:tap];
            [_scrollView addSubview:comView];
        }
        if (_commentListArray.count >= 4) {
            UIButton *moreBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.frame = CGRectMake(120, 0, 263/2, 58/2);
            moreBtn.center = CGPointMake(self.view.bounds.size.width/2, 4*123+self.view.bounds.size.height+55+(55+5)*4+50+500);
            [moreBtn setBackgroundImage:[UIImage imageNamed:@"theme_detail_more_commentBtn.png"] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreCommentButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:moreBtn];
            mY = _iY+4*60+80;
        }
        if (_commentListArray.count < 4) {
            mY = _iY+_commentListArray.count*60+80;
        }
    }
    
    if (_commentListArray.count == 0) {
        UILabel *notiLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, _iY+110+35+500, self.view.bounds.size.width-50, 30)];
        notiLabel.text = @"暂无评论";
        notiLabel.textAlignment = UITextAlignmentCenter;
        notiLabel.backgroundColor = [UIColor whiteColor];
        notiLabel.textColor = [UIColor darkGrayColor];
        [_scrollView addSubview:notiLabel];
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _listDataArray.count*123+self.view.bounds.size.height+123+180+500);
    }
    if (_commentListArray.count !=0 ) {
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, mY+110+500);
    }
}


#pragma mark 点击单品的处理方法

- (void)RemovePickView {
    @autoreleasepool {
        if (mPickerView) {
            [mPickerView removeFromSuperview];
            mPickerView = nil;
        }
    }
}
- (void)OnPickSelect:(PickerSelectView *)sender {
    
    _seleSubGoodsView.sizeLabel.text = sender.mSelectStr;
    [self RemovePickView];
}
- (void)ShowChiMaBiao:(ThemeSubGoodsView *)sender{
    SingleListModel *model = _listDataArray[sender.tag];
    ShowBiaoViewController *svc = [[ShowBiaoViewController alloc]init];
    svc.idStr = [NSString stringWithFormat:@"%d",model.cst_cate];
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)seleSizeClick:(ThemeSubGoodsView *)sender
{
    _seleSubGoodsView = _sizeLabelArray[sender.tag];
    miIndex = sender.tag;
    [self RemovePickView];
    mPickerView = [[PickerSelectView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 260)];
    mPickerView.backgroundColor = [UIColor whiteColor];
    mPickerView.delegate = self;
    mPickerView.OnPickerSelect = @selector(OnPickSelect:);
    mPickerView.OnPickerCancel = @selector(RemovePickView);
    [self.view addSubview:mPickerView];
    [mPickerView reloadData:[self GetPickArray:sender.tag]];
}
- (NSArray *)GetPickArray:(int)index {
    NSArray *arr = [[NSArray alloc]init];
    SingleListModel *model = _listDataArray[index];
    arr = model.biaoZhunMa;
    NSLog(@"arr---->%@",arr);
    return arr;
}


- (void)didClickGood:(ThemeSubGoodsView *)sender
{
    NSLog(@"sender.tag---->%d",sender.tag);
    NSDictionary *dict = _selectedGoodsArray[sender.tag];
    if ([[dict objectForKey:@"state"] boolValue]) {
        [dict setValue:[NSNumber numberWithBool:NO] forKey:@"state"];
    }
    else if(![[dict objectForKey:@"state"] boolValue]){
        [dict setValue:[NSNumber numberWithBool:YES] forKey:@"state"];
    }
    NSLog(@"_selectedGoodsArray---->%@",_selectedGoodsArray[sender.tag]);
    [self RefreshCountAndPrice];
}
//价格四舍五入
- (float)DealPrice:(NSString *)priceString{
    float price = [priceString floatValue];
    if ((int)(price * 10)%10 >= 5) {
        price = (int)price + 1;
    }
    else{
        price = (int)price;
    }
    return price;
}

- (void)RefreshCountAndPrice
{
    NSLog(@"_selectedGoodsArray---->%@",_selectedGoodsArray);
    int count = 0;
    float totalPrice = 0.0;
    for (NSDictionary *dict in _selectedGoodsArray) {
        if ([[dict objectForKey:@"state"] boolValue]) {
            count ++;
            SingleListModel *model = [dict objectForKey:@"goods"];
            totalPrice +=[self DealPrice:model.price];
        }
    }
    _selectedCountLabel.text = [NSString stringWithFormat:@"%d",count];
    _selectedPriceLabel.text = [NSString stringWithFormat: @"¥%.2f",totalPrice];
}
- (void)designBtnClick:(NSNumber *)number
{
    NSLog(@"设计第%d个单品",[number intValue]);
    MyCustomDetailViewController *mdvc = [[MyCustomDetailViewController alloc]init];
    SingleListModel *model = _listDataArray[[number intValue]];
    mdvc.IDStr = [NSString stringWithFormat:@"%d",model.cst_id];
    [mdvc StartDownload];
    [self.navigationController pushViewController:mdvc animated:YES];
}
#pragma mark 获取全部评论
- (void)moreCommentButtonClick {
    NSLog(@"点击进入更多评论");
    CoolCommentListViewController *vc = [[CoolCommentListViewController alloc]init];
    vc.urlID = [NSString stringWithFormat:@"%d",self.mThemeID];
    vc.isTheme = YES;
    [self.navigationController pushViewController:vc animated:YES];
    vc.title = @"评论";
}

#pragma mark 下载
- (void)dealloc {
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
    SAFE_CANCEL_ARC(_addCartDownManager);
    SAFE_CANCEL_ARC(_favoManager);
    SAFE_CANCEL_ARC(_commentManager);
    SAFE_CANCEL_ARC(_downRelaCommentManager)
}

- (void)StartDownloadRelaComment
{
    if (_downRelaCommentManager) {
        return;
    }
    [self StartLoading];
    //rctailor.ec51.com.cn/soaapi/soap/goods.php?act=getThemeComment&pageSize=1&pageIndex=1&id=23
    _downRelaCommentManager = [[ImageDownManager alloc] init];
    _downRelaCommentManager.delegate = self;
    _downRelaCommentManager.OnImageDown = @selector(OnLoadCommentFinish:);
    _downRelaCommentManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getThemeComment" forKey:@"act"];
    [dict setObject:@"30" forKey:@"pageSize"];
    [dict setObject:@"1" forKey:@"pageIndex"];
    [dict setObject:[NSString stringWithFormat:@"%d", self.mThemeID] forKey:@"id"];
    [_downRelaCommentManager PostHttpRequest:urlstr :dict];
}
- (void)OnLoadCommentFinish:(ImageDownManager *)sender
{
    [self StopLoading];
    SAFE_CANCEL_ARC(_downRelaCommentManager);
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"评论dict————>%@",dict);
    hasNest = [dict[@"hasNext"] intValue];
    NSDictionary *listDict = [dict objectForKey:@"list"];
    if (listDict && [listDict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [UserInfoManager DictionaryToArray:listDict];
        for (NSDictionary *commentDict in array) {
            CoolCommentModel *model = [CoolCommentModel CreateWithDict:commentDict];
            [_commentListArray addObject:model];
        }
    }
    [self reloadCommentView];
}
- (void)StartDownload
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSLog(@"kkToken---->%@",kkToken);
    NSLog(@"kkUserID---->%@",kkUserID);
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //[dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"getThemeDetail" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%d", self.mThemeID] forKey:@"id"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    if (sender == _mDownManager) {
        [self StopLoading];
        SAFE_CANCEL_ARC(_mDownManager);
        NSDictionary *dict = [sender.mWebStr JSONValue];
        NSLog(@"dict---->%@",dict);
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            self.mDict = dict;
            self.title = [dict objectForKey:@"name"];
            _desString = dict[@"desc"];
            _selectedGoodsArray = [[NSMutableArray alloc]init];
            _imgUrlString = [dict objectForKey:@"image"];
            _desImgUrlString = [dict objectForKey:@"content"];
            
            if ([dict objectForKey:@"list"] && [[dict objectForKey:@"list"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *listDict = [[NSDictionary alloc]initWithDictionary:[dict objectForKey:@"list"]];
                if (listDict &&[listDict isKindOfClass:[NSDictionary class]]) {
                    for (NSString *keyStr in listDict) {
                        NSDictionary *singleListDict = [[NSDictionary alloc]initWithDictionary:[listDict objectForKey:keyStr]];
                        SingleListModel *model = [[SingleListModel alloc]init];
                        for (NSString *key in singleListDict) {
                            [model setValue:singleListDict[key] forKey:key];
                        }
                        [_listDataArray addObject:model];
                        NSMutableDictionary *modelDict = [NSMutableDictionary dictionaryWithCapacity:0];
                        [modelDict setObject:[NSNumber numberWithBool:1] forKey:@"state"];
                        [modelDict setObject:model forKey:@"goods"];
                        [_selectedGoodsArray addObject:modelDict];
                    }
                }
            }
        }
    }
    [self reloadUI];
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    NSLog(@"下载失败");
    [self StopLoading];
    SAFE_CANCEL_ARC(sender);
}
#pragma mark 购买btn
- (void)OnbuyBtnClick
{
    if (![UserInfoManager Share].mbLogin) {
        LoginViewController *ctrl = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else{
        [self addCart];
    }
}
#pragma mark 添加购物车
- (void)addCart
{
    [self StartLoading];
    _addCartDownManager = [[ImageDownManager alloc] init];
    _addCartDownManager.delegate = self;
    _addCartDownManager.OnImageDown = @selector(OnAddCartFinish:);
    _addCartDownManager.OnImageFail = @selector(OnLoadFail:);
    //rctailor.ec51.com.cn//soaapi/soap/flow.php?act=addCart&token=639d8b5b131b90e28b3e66ca2b86c800&goodsId=45&is_diy=0&spec=185/96B
    NSString *urlStr = [NSString stringWithFormat:@"%@flow.php",SERVER_URL];
    NSMutableArray *goods_idArray = [[NSMutableArray alloc]init];
    for (NSDictionary *modelDict in _selectedGoodsArray) {
        if ([[modelDict objectForKey:@"state"] boolValue]) {
            SingleListModel *model = [modelDict objectForKey:@"goods"];
            NSString *str = [NSString stringWithFormat:@"%d",model.cst_id];
            [goods_idArray addObject:str];
        }
    }
    NSMutableString *goods_idStr = [[NSMutableString alloc]init];
    for (int i = 0; i<goods_idArray.count; i++) {
        if (i<goods_idArray.count-1) {
            NSString *str = [NSString stringWithFormat:@"%@,",goods_idArray[i]];
            [goods_idStr appendString:str];
        }
        else if (i==goods_idArray.count-1){
            [goods_idStr appendString:goods_idArray[i]];
        }
    }
    NSLog(@"goods_idStr---->%@",goods_idStr);
    NSMutableString *sizeStr = [[NSMutableString alloc]init];
    for (int i = 0; i<goods_idArray.count; i++) {
        ThemeSubGoodsView *subView = _sizeLabelArray[i];
        if (i<goods_idArray.count-1) {
            [sizeStr appendString:[NSString stringWithFormat:@"%@,",subView.sizeLabel.text]];
        }
        if (i==goods_idArray.count-1) {
            [sizeStr appendString:subView.sizeLabel.text];
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"addCart" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%d", self.mThemeID] forKey:@"disid"];
    [dict setObject:goods_idStr forKey:@"goodsId"];
    [dict setObject:sizeStr forKey:@"spec"];
    [dict setObject:@"dis" forKey:@"type"];
    [_addCartDownManager PostHttpRequest:urlStr :dict];
}
- (void)OnAddCartFinish:(ImageDownManager *)sender
{
    NSLog(@"----->%@",sender.mWebStr);
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self StopLoading];
    if ([[dict objectForKey:@"code"] intValue] == 1) {
        [AutoAlertView ShowAlert:@"提示" message:dict[@"msg"]];
        return;
    }
    else{
        ShopCarViewController *shopCar = [[ShopCarViewController alloc] init];
        shopCar.theTitleText = @"购物车";
        [self.navigationController pushViewController:shopCar animated:YES];
    }
}


#pragma mark 点击评论的处理方法
- (void)didClickComment:(CoolCommentModel *)model
{
    FansInfoViewController *ctrl = [[FansInfoViewController alloc] init];
    ctrl.isAdded=YES;
    ctrl.userID = model.uid;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark 底部btn的处理方法
- (void)OnBotBtnClick:(UIButton *)sender {
    int index = sender.tag-1600;
    if (index == 0) {
        if (![UserInfoManager Share].mbLogin) {
            LoginViewController *ctrl = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }else{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CoolCommentView *commentView = [[CoolCommentView alloc] initWithFrame:window.bounds];
            commentView.delegate = self;
            commentView.sendClick = @selector(SendComment:);
            [window addSubview:commentView];
        }
    }
    else if (index == 1){
        NSLog(@"添加收藏");
        if (![UserInfoManager Share].mbLogin) {
            LoginViewController *ctrl = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        else{
            [self AddFavorite];
        }
    }
    else if (index == 2) {
        [self OnShareClick];
    }
}

- (void)OnShareClick {
    NSString *imagename = [self.mDict objectForKey:@"image"];
    UIImage *image = [UIImage imageWithContentsOfFile:[NetImageView GetLocalPathOfUrl:imagename]];
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    ShareSheetView *view = [[ShareSheetView alloc] initWithFrame:keywindow.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view.mImage = image;
    view.mContent = [self.mDict objectForKey:@"name"];
    view.mShareUrl = [self.mDict objectForKey:@"out_url"];
    view.mRootCtrl = self;
    [UMSocialWechatHandler setWXAppId:WX_APPID url:view.mShareUrl];
    [keywindow addSubview:view];
}


- (void)SendComment:(NSString *)sender
{
    NSLog(@"发送--->%@",sender);
    if ([sender isEqual:[NSNull null]] || [sender isEqual:@""]) {
        [AutoAlertView ShowAlert:@"提示" message:@"评论内容不能为空"];
        return;
    }
    
    [self StartLoading];
    
    //rctailor.ec51.com.cn/soaapi/soap/goods.php?act=addThemeComment&token=639d8b5b131b90e28b3e66ca2b86c800&id=21&content=nihao
    _commentManager = [[ImageDownManager alloc] init];
    _commentManager.delegate = self;
    _commentManager.OnImageDown = @selector(SendCommentFinish:);
    _commentManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"addThemeComment" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%d", self.mThemeID] forKey:@"id"];
    [dict setObject:sender forKey:@"content"];
    [_commentManager PostHttpRequest:urlstr :dict];
}
- (void)SendCommentFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self StopLoading];
    SAFE_CANCEL_ARC(sender);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"dict---->%@",dict);
        NSLog(@"----->%@",[dict objectForKey:@"msg"]);
        [AutoAlertView ShowAlert:@"提示" message:[dict objectForKey:@"msg"]];
        if ([dict[@"statusCode"] intValue] == 0) {
            for (CoolCommentView *view in _scrollView.subviews) {
                if ([view isKindOfClass:[CoolCommentView class]]) {
                    [view removeFromSuperview];
                }
                [_commentListArray removeAllObjects];
                [self StartDownloadRelaComment];
            }
        }
    }
}
- (void)AddFavorite
{
    [self StartLoading];
    _favoManager = [[ImageDownManager alloc] init];
    _favoManager.delegate = self;
    _favoManager.OnImageDown = @selector(OnAddFavoFinish:);
    _favoManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:@"loveTheme" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%d", self.mThemeID] forKey:@"id"];
    [_favoManager PostHttpRequest:urlstr :dict];
}
- (void)OnAddFavoFinish:(ImageDownManager *)sender
{
    NSLog(@"sender.mStr---->%@",sender.mWebStr);
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self StopLoading];
    SAFE_CANCEL_ARC(sender);
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"----->%@",[dict objectForKey:@"msg"]);
        [AutoAlertView ShowAlert:@"提示" message:[dict objectForKey:@"msg"]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/self.view.bounds.size.width;
    _pageControl.currentPage = currentPage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
