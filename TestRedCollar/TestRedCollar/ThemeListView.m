//
//  ThemeListView.m
//  TestRedCollar
//
//  Created by MC on 14-7-9.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ThemeListView.h"
#import "ThemeCatgoryViewController.h"
#import "MyCustomDetailViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "CycleModel.h"
#import "ThemeModel.h"
#import "NetImageView.h"
#import "TouchView.h"
@implementation ThemeListView
{
    ImageDownManager *_mDownManager;
    NSMutableArray *_cycleArray;
    NSMutableArray *_themeArray;
    int _index;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        _cycleArray = [[NSMutableArray alloc] init];
        _themeArray = [[NSMutableArray alloc] init];
        _index = 0;
        //主滚动视图
        mScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        mScrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mScrollview.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        mScrollview.showsVerticalScrollIndicator = NO;
        [self addSubview:mScrollview];
        
        headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        [mScrollview addSubview:headScrollView];
        [self StartDownload];
        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 210, 150, 20)];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.text = @"主题系列";
//        titleLabel.font = [UIFont systemFontOfSize:20];
//        [mScrollview addSubview:titleLabel];
        
    }
    return self;
}
- (void)dealloc {
    [self Cancel];
}
#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
}
- (void)StartDownload
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    //http://rctailor.ec51.com.cn/soaapi/soap/base.php?act=indexInfo
    NSString *urlstr = [NSString stringWithFormat:@"%@base.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"indexInfo" forKey:@"act"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        NSArray *cycleArr = [[dict objectForKey:@"_widget_590"] objectForKey:@"options"];
        for (NSDictionary *cycleDict in cycleArr) {
            CycleModel *model = [[CycleModel alloc]init];
            for (NSString *key in cycleDict) {
                [model setValue:cycleDict[key] forKey:key];
            }
            [_cycleArray addObject:model];
        }
        
        NSArray *themeArr = [[dict objectForKey:@"_widget_493"] objectForKey:@"options"];
        for (NSDictionary *themeDict in themeArr) {
            NSLog(@"ad_link_url----->%@",themeDict[@"ad_link_url"]);
            NSString *idStr = themeDict[@"ad_link_url"];
            char c = [idStr characterAtIndex:30];
            NSString *typeID = [NSString stringWithFormat:@"%c",c];
            ThemeModel *model = [[ThemeModel alloc]init];
            for (NSString *key in themeDict) {
                [model setValue:themeDict[key] forKey:key];
            }
            [model setValue:typeID forKey:@"typeID"];
            NSLog(@"model--->%@",model.typeID);
            [_themeArray addObject:model];
        }
        [self reloadImg];
        [self reloadThemeImg];
    }
}

- (void)reloadThemeImg
{
    [self createThemeSeriesView];
}

- (void)createThemeSeriesView
{
    ThemeModel *model = _themeArray[0];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
    TouchView *imageView = [[TouchView alloc]initWithFrame:CGRectMake(5, 220, 205,205 )];
    NetImageView *netImage = [[NetImageView alloc]initWithFrame:imageView.bounds];
    netImage.mImageType = TImageType_CutFill;
    [imageView addSubview:netImage];
    [netImage GetImageByStr:urlStr];
    imageView.tag = 200 + [model.typeID intValue];
    imageView.delegate=self;
    imageView.OnViewClick = @selector(ClickedTheme:);
    [mScrollview addSubview:imageView];
    
    UIImageView *tiniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height-30, imageView.frame.size.width, 30)];
    tiniView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [imageView addSubview:tiniView];
    
//    UILabel *themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height-40, imageView.frame.size.width, 20)];
//    themeLabel.text = model.adname;
//    themeLabel.font = [UIFont systemFontOfSize:14];
//    themeLabel.textColor = [UIColor whiteColor];
//    themeLabel.textAlignment = 1;
//    [imageView addSubview:themeLabel];
    
    UILabel *themeBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height-30, imageView.frame.size.width, 30)];
    themeBottomLabel.text = [NSString stringWithFormat:@"- %@ -",model.series];
    themeBottomLabel.backgroundColor = [UIColor clearColor];
    themeBottomLabel.font = [UIFont systemFontOfSize:14];
    themeBottomLabel.textColor = [UIColor whiteColor];
    themeBottomLabel.textAlignment = UITextAlignmentCenter;
    [imageView addSubview:themeBottomLabel];
    
    model = _themeArray[1];
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
    TouchView *imageView1 = [[TouchView alloc]initWithFrame:CGRectMake(215, 220, 100,100 )];
    //[imageView1 setImageWithURL:[NSURL URLWithString:urlStr]];
    NetImageView *netImage1 = [[NetImageView alloc]initWithFrame:imageView1.bounds];
    netImage1.mImageType = TImageType_CutFill;
    [imageView1 addSubview:netImage1];
    [netImage1 GetImageByStr:urlStr];
    imageView1.tag = 200 + [model.typeID intValue];
    imageView1.delegate=self;
    imageView1.OnViewClick = @selector(ClickedTheme:);
    [mScrollview addSubview:imageView1];
    
    tiniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    tiniView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [imageView1 addSubview:tiniView];
    
//    UILabel *themeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-30, imageView1.frame.size.width, 15)];
//    themeLabel1.text = model.adname;
//    themeLabel1.font = [UIFont systemFontOfSize:12];
//    themeLabel1.textColor = [UIColor whiteColor];
//    themeLabel1.textAlignment = 1;
//    [imageView1 addSubview:themeLabel1];
    
    themeBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    themeBottomLabel.text = [NSString stringWithFormat:@"- %@ -",model.series];
    themeBottomLabel.backgroundColor = [UIColor clearColor];
    themeBottomLabel.font = [UIFont systemFontOfSize:10];
    themeBottomLabel.textColor = [UIColor whiteColor];
    themeBottomLabel.textAlignment = UITextAlignmentCenter;
    [imageView1 addSubview:themeBottomLabel];
    
    
    model = _themeArray[2];
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
    TouchView *imageView2 = [[TouchView alloc]initWithFrame:CGRectMake(215, 325, 100,100)];
    //[imageView2 setImageWithURL:[NSURL URLWithString:urlStr]];
    NetImageView *netImage2 = [[NetImageView alloc]initWithFrame:imageView2.bounds];
    netImage2.mImageType = TImageType_CutFill;
    [imageView2 addSubview:netImage2];
    [netImage2 GetImageByStr:urlStr];
    imageView2.tag = 200 + [model.typeID intValue];
    imageView2.delegate=self;
    imageView2.OnViewClick = @selector(ClickedTheme:);
    [mScrollview addSubview:imageView2];
    
    tiniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    tiniView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [imageView2 addSubview:tiniView];
    
//    UILabel *themeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView2.frame.size.height-30, imageView2.frame.size.width, 15)];
//    themeLabel2.text = model.adname;
//    themeLabel2.font = [UIFont systemFontOfSize:12];
//    themeLabel2.textColor = [UIColor whiteColor];
//    themeLabel2.textAlignment = 1;
//    [imageView2 addSubview:themeLabel2];
    
    themeBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    themeBottomLabel.text = [NSString stringWithFormat:@"- %@ -",model.series];
    themeBottomLabel.backgroundColor = [UIColor clearColor];
    themeBottomLabel.font = [UIFont systemFontOfSize:10];
    themeBottomLabel.textColor = [UIColor whiteColor];
    themeBottomLabel.textAlignment = UITextAlignmentCenter;
    [imageView2 addSubview:themeBottomLabel];
    
    model = _themeArray[3];
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
    TouchView *imageView3 = [[TouchView alloc]initWithFrame:CGRectMake(5, 430, 100,100)];
    NetImageView *netImage3 = [[NetImageView alloc]initWithFrame:imageView3.bounds];
    netImage3.mImageType = TImageType_CutFill;
    [imageView3 addSubview:netImage3];
    [netImage3 GetImageByStr:urlStr];
    imageView3.tag = 200 + [model.typeID intValue];
    imageView3.delegate=self;
    imageView3.OnViewClick = @selector(ClickedTheme:);
    [mScrollview addSubview:imageView3];
    
    tiniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    tiniView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [imageView3 addSubview:tiniView];
//    
//    UILabel *themeLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView3.frame.size.height-40, imageView3.frame.size.width, 20)];
//    themeLabel3.text = model.adname;
//    themeLabel3.font = [UIFont systemFontOfSize:14];
//    themeLabel3.textColor = [UIColor whiteColor];
//    themeLabel3.textAlignment = 1;
//    [imageView3 addSubview:themeLabel3];
    
    themeBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    themeBottomLabel.text = [NSString stringWithFormat:@"- %@ -",model.series];
    themeBottomLabel.backgroundColor = [UIColor clearColor];
    themeBottomLabel.font = [UIFont systemFontOfSize:10];
    themeBottomLabel.textColor = [UIColor whiteColor];
    themeBottomLabel.textAlignment = UITextAlignmentCenter;
    [imageView3 addSubview:themeBottomLabel];
    
    model = _themeArray[4];
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
    TouchView *imageView4 = [[TouchView alloc]initWithFrame:CGRectMake(110, 430, 100,100)];
    NetImageView *netImage4 = [[NetImageView alloc]initWithFrame:imageView4.bounds];
    netImage4.mImageType = TImageType_CutFill;
    [imageView4 addSubview:netImage4];
    [netImage4 GetImageByStr:urlStr];
    imageView4.tag = 200 + [model.typeID intValue];
    imageView4.delegate=self;
    imageView4.OnViewClick = @selector(ClickedTheme:);
    [mScrollview addSubview:imageView4];
    
    tiniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    tiniView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [imageView4 addSubview:tiniView];
    
//    UILabel *themeLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView4.frame.size.height-40, imageView4.frame.size.width, 20)];
//    themeLabel4.text = model.adname;
//    themeLabel4.font = [UIFont systemFontOfSize:14];
//    themeLabel4.textColor = [UIColor whiteColor];
//    themeLabel4.textAlignment = 1;
//    [imageView4 addSubview:themeLabel4];
    
    themeBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    themeBottomLabel.text = [NSString stringWithFormat:@"- %@ -",model.series];
    themeBottomLabel.backgroundColor = [UIColor clearColor];
    themeBottomLabel.font = [UIFont systemFontOfSize:10];
    themeBottomLabel.textColor = [UIColor whiteColor];
    themeBottomLabel.textAlignment = UITextAlignmentCenter;
    [imageView4 addSubview:themeBottomLabel];
    
    
    model = _themeArray[5];
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
    TouchView *imageView5 = [[TouchView alloc]initWithFrame:CGRectMake(215, 430, 100,100)];
    NetImageView *netImage5 = [[NetImageView alloc]initWithFrame:imageView5.bounds];
    netImage5.mImageType = TImageType_CutFill;
    [imageView5 addSubview:netImage5];
    [netImage5 GetImageByStr:urlStr];
    imageView5.tag = 200 + [model.typeID intValue];
    imageView5.delegate=self;
    imageView5.OnViewClick = @selector(ClickedTheme:);
    [mScrollview addSubview:imageView5];
    
    tiniView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    tiniView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [imageView5 addSubview:tiniView];
    
//    UILabel *themeLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView5.frame.size.height-40, imageView5.frame.size.width, 20)];
//    themeLabel5.text = model.adname;
//    themeLabel5.font = [UIFont systemFontOfSize:14];
//    themeLabel5.textColor = [UIColor whiteColor];
//    themeLabel5.textAlignment = 1;
//    [imageView5 addSubview:themeLabel5];
    
    themeBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView1.frame.size.height-15, imageView1.frame.size.width, 15)];
    themeBottomLabel.text = [NSString stringWithFormat:@"- %@ -",model.series];
    themeBottomLabel.backgroundColor = [UIColor clearColor];
    themeBottomLabel.font = [UIFont systemFontOfSize:10];
    themeBottomLabel.textColor = [UIColor whiteColor];
    themeBottomLabel.textAlignment = UITextAlignmentCenter;
    [imageView5 addSubview:themeBottomLabel];
    
    mScrollview.contentSize = CGSizeMake(self.bounds.size.width,240+210+110);
}

- (void)reloadImg
{
    [self createHeadScrollView];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)createHeadScrollView
{
    headScrollView.contentSize = CGSizeMake(self.frame.size.width*_cycleArray.count, headScrollView.frame.size.height);
    headScrollView.pagingEnabled = YES;
    headScrollView.showsHorizontalScrollIndicator = NO;
    headScrollView.bounces = NO;
    for (int i = 0; i<_cycleArray.count; i++) {
        TouchView *imgView = [[TouchView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, headScrollView.frame.size.height)];
        if (_cycleArray.count>0) {
            CycleModel *model = [[CycleModel alloc]init];
            model = _cycleArray[i];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_HEADER,model.ad_image_url];
            NetImageView *img = [[NetImageView alloc]initWithFrame:imgView.bounds];
            img.mImageType = TImageType_CutFill;
            [imgView addSubview:img];
            [img GetImageByStr:urlStr];
        }
        imgView.tag = i+100;
        imgView.delegate = self;
        imgView.OnViewClick = @selector(clickedPic:);
        [headScrollView addSubview:imgView];
        
        UIPageControl* pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        pageControl.center = CGPointMake(self.frame.size.width/2, imgView.frame.size.height-20);
        pageControl.numberOfPages = _cycleArray.count;
        pageControl.currentPage = i;
        [imgView addSubview:pageControl];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrollView) userInfo:nil repeats:YES];
}
- (void)autoScrollView{
    
    if (_index == 0) {
        [headScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:YES];
        _index = 1;
    }
    else if (_index == 1){
        [headScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _index = 0;
    }
}
- (void)ClickedTheme:(TouchView *)sender
{
    NSLog(@"点击了第%d个主题",sender.tag-200);
    ThemeCatgoryViewController *tvc = [[ThemeCatgoryViewController alloc]init];
    if (sender.tag-200 == 6) {
        tvc.didSelectedNumber = 5;
    }else if (sender.tag-200 == 5){
        tvc.didSelectedNumber = 6;
    }else{
        tvc.didSelectedNumber = sender.tag-200;
    }
    tvc.typeID = sender.tag - 200;
    [self.mRootCtrl.navigationController pushViewController:tvc animated:YES];
}
- (void)clickedPic:(TouchView *)sender
{
    NSLog(@"点击了第%d个图片",sender.tag-100);
    int count = sender.tag-100;
    CycleModel *model = _cycleArray[count];
    if (count == 0) {
        MyCustomDetailViewController *mcdvc = [[MyCustomDetailViewController alloc] init];
        mcdvc.IDStr = model.ad_link_url;
        [mcdvc StartDownload];
        [self.mRootCtrl.navigationController pushViewController:mcdvc animated:YES];
    }
    else if (count == 1){
        ThemeCatgoryViewController *tvc = [[ThemeCatgoryViewController alloc]init];
        tvc.didSelectedNumber = 5;
        tvc.typeID = [model.ad_link_url intValue];
        [self.mRootCtrl.navigationController pushViewController:tvc animated:YES];
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
