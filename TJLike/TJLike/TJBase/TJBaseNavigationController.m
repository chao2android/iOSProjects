//
//  TJBaseNavigationController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBaseNavigationController.h"

@interface TJBaseNavigationController ()

@property (nonatomic, readonly) TJBaseNaviBarView *viewNaviBar;

@end

@implementation TJBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if ( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if ( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置navigation不隐藏
    [self setNavigationBarHidden:NO];
    //设置navigation半透明
    self.navigationBar.translucent =YES;
    //设置navigation支持左划手势
    //    self.interactivePopGestureRecognizer.enabled = YES;
    //设置navigation上控件颜色为透明，避免出现back按键时与自定义view上的控件重叠
    [self.navigationBar setTintColor:[UIColor clearColor]];
    //初始化自定义navigationView，并添加到navigationBar上
    _viewNaviBar = [[TJBaseNaviBarView alloc] initWithFrame:CGRectMake(0.0f, 0, SCREEN_WIDTH, NAVIBAR_HEIGHT)];
    [self.navigationBar addSubview:_viewNaviBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- navi build view

-(void)setNaviBarDefaultLeftBut_Back
{
    UIButton *leftNaviBut = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:Navi_LeftBut_Back_Image imgHighlight:nil withFrame:Navi_But_Normal_Frame];
    [[leftNaviBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self popViewControllerAnimated:YES];
    }];
    [self setNaviBarLeftBtn:leftNaviBut];
}

- (void)setNaviBarTitle:(NSString *)strTitle
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setTitle:strTitle];
    }else{}
}

- (void)setNaviBarTitleStyle:(NSDictionary *)styleDict
{
    if (_viewNaviBar) {
        [_viewNaviBar setTitleStyle:styleDict];
    }
}

-(void)setNaviBarTitleView:(UIView *)view
{
    if (_viewNaviBar) {
        [_viewNaviBar setTitleView:view];
    }
}

- (void)setNaviBarLeftBtn:(id )leftItem
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setLeftBtn:leftItem];
    }else{}
}

- (void)setNaviBarRightBtn:(id )rightItem
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setRightBtn:rightItem];
    }else{}
}

- (void)setNaviBarLeftBtnsWithButtonArray:(NSArray *)leftItemArr
{
    if (_viewNaviBar) {
        [_viewNaviBar setLeftBtnsWithButtonArray:leftItemArr];
    }else{}
}
- (void)setNaviBarRightBtnsWithButtonArray:(NSArray *)rightItemArr
{
    if (_viewNaviBar) {
        [_viewNaviBar setRightBtnsWithButtonArray:rightItemArr];
    }else{}
}

- (void)setNaviBarCenterBtnsWithButtonArray:(NSArray *)centerItemArr
{
    if (_viewNaviBar) {
        [_viewNaviBar setCenterBtn:centerItemArr];
    }else{
        
    }
}

-(void)setNaviBarBackGroundImage:(UIImageView *)imgView
{
    if (_viewNaviBar) {
        [_viewNaviBar setBackgroundImageView:imgView];
    }else{}
}

- (void)hideOriginalBarItems
{
    if (_viewNaviBar) {
        [_viewNaviBar hideOriginalBarItem:YES];
    }else{}
}


#ifdef __IPHONE_6_0

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#endif
- (BOOL) shouldAutorotate {
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
