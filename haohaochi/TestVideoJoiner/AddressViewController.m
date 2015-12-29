//
//  AddressViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AddressViewController.h"
#import "MergeMediaViewController.h"
#import "TouchView.h"
#import "JSON.h"
#import "ImageDownManager.h"
#import "LocationManager.h"
#import "AddressInfo.h"

@interface AddressViewController () {
    UITextField *mTextField;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSMutableArray *mNameArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self HideStatusBar:YES];
    
    self.mNameArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    topView.image = [UIImage imageNamed:@"f_topbar"];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:topView];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, topView.frame.size.width, 1)];
    shadowView.image = [UIImage imageNamed:@"f_shadow"];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [topView addSubview:shadowView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 67, 30);
    [backBtn setImage:[UIImage imageNamed:@"p_cancelbtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-100, 30)];
    lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:lbTitle];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width-67, 0, 67, 30);
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [btn setBackgroundImage:[UIImage imageNamed:@"p_commitbtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(OnStartClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    float fWidth = MAX(KscreenHeigh, KscreenWidth);
    
    UIImageView *searchView = [[UIImageView alloc] initWithFrame:CGRectMake((fWidth-330)/2, 54, 330, 40)];
    searchView.image = [UIImage imageNamed:@"p_searchback"];
    searchView.userInteractionEnabled = YES;
    [self.view addSubview:searchView];
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 13, 15, 15)];
    flagView.image = [UIImage imageNamed:@"f_searchflag"];
    [searchView addSubview:flagView];
    
    mTextField = [[UITextField alloc] initWithFrame:CGRectMake(36, 6, 260, 30)];
    mTextField.backgroundColor = [UIColor clearColor];
    mTextField.inputAccessoryView = [self GetInputAccessoryView];
    mTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    mTextField.placeholder = @"根据餐馆名称搜索";
    mTextField.textColor = [UIColor blackColor];
    [searchView addSubview:mTextField];
    
    [self LoadShopList];
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (void)AddAnimationToView:(UIView *)view {
    view.hidden = NO;
    CGRect rect = view.frame;
    rect.origin.y -= rect.size.height/2;
    view.frame = rect;
    view.layer.anchorPoint = CGPointMake(view.layer.anchorPoint.x, 0);
    CATransform3D rotate = CATransform3DMakeRotation(-M_PI/2, 1, 0, 0);
    view.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 200);
    [UIView animateWithDuration:0.3 animations:^{
        CATransform3D rotate = CATransform3DMakeRotation(0, 1, 0, 0);
        view.layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 200);
    }];
}

- (void)OnViewClick:(TouchView *)sender {
    int index = (int)sender.tag-1000;
    kUserInfoManager.mAddInfo = [self.mNameArray objectAtIndex:index];
    mTextField.text = kUserInfoManager.mAddInfo.name;
}

- (void)OnStartClick {
    if (!mTextField.text || mTextField.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请先选择餐厅"];
        return;
    }
    [UserInfoManager Share].mWatermark = mTextField.text;
    
    NSDictionary *userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"index"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefreshTimeline object:nil userInfo:userinfo];
    [self GoBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self Cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
}

- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
    [self StopLoading];
}

- (void)LoadShopList {
    if (self.mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/user/Poilist", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%f", [LocationManager Share].mLatitude] forKey:@"x"];
    [dict setObject:[NSString stringWithFormat:@"%f", [LocationManager Share].mLongitude] forKey:@"y"];
    [self.mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            NSArray *array = [dict objectForKey:@"lst"];
            if (array && [array isKindOfClass:[NSArray class]]) {
                [self.mNameArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    AddressInfo *info = [AddressInfo CreateWithDict:dict];
                    [self.mNameArray addObject:info];
                }
                [self RefreshView];
            }
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)RefreshView {
    
    float fWidth = MAX(KscreenHeigh, KscreenWidth);
    
    UIImageView *addressView = [[UIImageView alloc] initWithFrame:CGRectMake((fWidth-318)/2, 96, 318, 200)];
    addressView.userInteractionEnabled = YES;
    addressView.image = [[UIImage imageNamed:@"p_addressback"] stretchableImageWithLeftCapWidth:80 topCapHeight:10];
    [self.view addSubview:addressView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, addressView.frame.size.width-10, addressView.frame.size.height-5)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [addressView addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, self.mNameArray.count*38);
    
    for (int i = 0; i < self.mNameArray.count; i ++) {
        AddressInfo *info = [self.mNameArray objectAtIndex:i];
        TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(0, i*38, scrollView.frame.size.width, 36)];
        touchView.tag = i+1000;
        touchView.delegate = self;
        touchView.OnViewClick = @selector(OnViewClick:);
        [scrollView addSubview:touchView];
        
        UILabel *lbNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 36)];
        lbNum.backgroundColor = [UIColor clearColor];
        lbNum.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
        lbNum.textColor = [UIColor grayColor];
        lbNum.text = [NSString stringWithFormat:@"0%d", i+1];
        [touchView addSubview:lbNum];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 25)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        lbName.textColor = [UIColor darkGrayColor];
        lbName.text = info.name;
        [touchView addSubview:lbName];
        
        CGSize calcSize = [lbName.text sizeWithFont:lbName.font forWidth:200 lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *lbAddr = [[UILabel alloc] initWithFrame:CGRectMake(40+calcSize.width+10, 10, 150, 25)];
        lbAddr.backgroundColor = [UIColor clearColor];
        lbAddr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        lbAddr.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        lbAddr.text = info.address;
        [touchView addSubview:lbAddr];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, touchView.frame.size.height-1, touchView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        lineView.transform = CGAffineTransformMakeScale(1.0, 0.5);
        [touchView addSubview:lineView];
    }
    addressView.hidden = YES;
    [self performSelector:@selector(AddAnimationToView:) withObject:addressView afterDelay:0.3];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
