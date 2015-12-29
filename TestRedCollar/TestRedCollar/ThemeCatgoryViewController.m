//
//  ThemeCatgoryViewController.m
//  TestRedCollar
//
//  Created by MC on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ThemeCatgoryViewController.h"
#import "ThemeSubView.h"
#import "ThemeDetialViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "ThemeCateListModel.h"
#import "TypeSelectView.h"

@interface ThemeCatgoryViewController ()
{
    ImageDownManager *_mDownManager;
    NSMutableArray *_dataArray;
}
@end

@implementation ThemeCatgoryViewController

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
    _dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"主题列表";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mScrollView];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 41)];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"82.png"];
    [self.view addSubview:topView];
    
    
    NSArray *typeArray = [[NSArray alloc]initWithObjects:@"婚庆系列",@"校园系列",@"职场系列",@"休闲系列",@"明星同款",@"本期爆款", nil];
    TypeSelectView *selectView = [[TypeSelectView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 41)];
    selectView.mArray = typeArray;
    selectView.delegate = self;
    selectView.OnTypeSelect = @selector(OnTypeSelect:);
    [selectView reloadData];
    selectView.miIndex = _didSelectedNumber-1;
    [selectView SelectType:_didSelectedNumber-1];
    if (selectView.miIndex == 5) {
        selectView.contentOffset = CGPointMake(self.view.bounds.size.width/5, 0);
    }
    [self.view addSubview:selectView];
}
- (void)OnTypeSelect:(TypeSelectView *)sender
{
    NSLog(@"%d",sender.miIndex);
    
    if (_didSelectedNumber != sender.miIndex) {
        _didSelectedNumber = sender.miIndex;
        _typeID = sender.miIndex+1;
        if (sender.miIndex==4) {
            _typeID = 6;
        }
        if (sender.miIndex==5){
            _typeID = 5;
        }
        NSLog(@"下载刷新数据");
        if (_dataArray.count > 0) {
            [_dataArray removeAllObjects];
            [self LoadThemeList];
        }
        [self StartDownload];
    }
}

- (void)dealloc {
    [self Cancel];
}
#pragma mark - 下载
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
    NSString *urlstr = [NSString stringWithFormat:@"%@goods.php",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *didSeleckedStr = [NSString stringWithFormat:@"%d",_typeID];
    [dict setObject:@"getThemeList" forKey:@"act"];
    [dict setObject:didSeleckedStr  forKey:@"type"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    NSLog(@"dict---->%@",dict);
    //http://www.rctailor.com/soaapi/soap/goods.php?act=getThemeList&type=4
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        //NSLog(@"goodslist---->%@", dict);
        for (NSString *key in dict) {
            NSDictionary *themeDict = dict[key];
            ThemeCateListModel *model = [[ThemeCateListModel alloc]init];
            for (NSString *themeKey in themeDict) {
                [model setValue:themeDict[themeKey] forKey:themeKey];
            }
            NSLog(@"model---->%@",model.title);
            [_dataArray addObject:model];
        }
        [self LoadThemeList];
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}


//- (void)OnTabSelect:(UIButton *)btn
//{
//    if (mSelectBtn == btn) {
//        return;
//    }
//    _didSelectedNumber = btn.tag-1400;
//    if (_dataArray.count>0) {
//        [_dataArray removeAllObjects];
//    }
//    [mSelectBtn setSelected:NO];
//    mSelectBtn = btn;
//    [mSelectBtn setSelected:YES];
//    [self StartDownload];
//}
- (void)LoadThemeList
{
    @autoreleasepool {
        for (UIView *view in mScrollView.subviews) {
            if ([view isKindOfClass:[ThemeSubView class]] || [view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    if (_dataArray.count > 0) {
        int iHeight1 = 5;
        int iHeight2 = 5;
        for (int i = 0; i < _dataArray.count; i ++) {
            int iXPos = i%2;
            //int iHeight = [ThemeSubView HeightOfContent:dict];
            int iHeight = 280;
            int iTop = 0;
            if (iXPos == 0) {
                iTop = iHeight1;
                iHeight1 += (iHeight+5);
            }
            else {
                iTop = iHeight2;
                iHeight2 += (iHeight+5);
            }
            ThemeCateListModel *model = _dataArray[i];
            ThemeSubView *subView = [[ThemeSubView alloc] initWithFrame:CGRectMake(iXPos*158+5, iTop, 153, iHeight)];
            subView.delegate = self;
            subView.OnViewClick = @selector(OnDetailClick:);
            subView.tag = i+1300;
            [subView loadContent:model];
            [mScrollView addSubview:subView];
        }
        mScrollView.contentOffset = CGPointMake(0, 0);
        mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, MAX(iHeight1, iHeight2));
        [self refreshAnimation];
    }
    
}
- (void)OnDetailClick:(ThemeSubView *) view
{
    ThemeCateListModel *model = _dataArray[view.tag - 1300];
    ThemeDetialViewController *tdvc = [[ThemeDetialViewController alloc]init];
    tdvc.mThemeID = model.id;
    [self.navigationController pushViewController:tdvc animated:YES];
}
- (void)refreshAnimation {
    for (int i = 0; i<11; i++) {
        ThemeSubView *subView = (ThemeSubView*)[mScrollView viewWithTag:1300+i];
        
        //根据i算时间
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2+i*0.1;         /* 间隔时间*/
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; /* 动画的开始与结束的快慢*/
        transition.type = @"moveIn"; /* 各种动画效果*/
        transition.subtype = kCATransitionFromTop;
        
        //        transition.delegate = self;
        /* 在想添加CA动画的VIEW的层上添加此代码*/
        [subView.layer addAnimation:transition forKey:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
