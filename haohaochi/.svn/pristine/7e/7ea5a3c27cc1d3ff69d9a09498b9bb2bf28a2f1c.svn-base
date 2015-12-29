//
//  MergeMediaViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-3.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "MergeMediaViewController.h"
#import "VideoRecordView.h"
#import "ModelSelectViewController.h"
#import "VideoTimelineView.h"
#import "VideoListManager.h"
#import "AddressViewController.h"
#import "SubTimeLineView.h"

@interface MergeMediaViewController () {
    VideoTimelineView *mTimelineView;
}

@property (nonatomic, strong) MediaSelectManager *mMediaManager;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSURL *mAudioUrl;

@end

@implementation MergeMediaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        self.mMediaManager = [[MediaSelectManager alloc] init];
        self.mMediaManager.mRootCtrl = self;
        self.mMediaManager.mbLightOff = YES;
        
    }
    return self;
}

- (void)RotateView:(UIView *)backView {
    NSLog(@"%@", backView);
    
    float fWidth = [UIScreen mainScreen].bounds.size.width;
    float fHeight = [UIScreen mainScreen].bounds.size.height;
    float fNewWidth = MAX(fWidth, fHeight);
    float fNewHeight = MIN(fWidth, fHeight);
    
    backView.center = CGPointMake(fNewHeight/2, fNewWidth/2);
    
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);//先顺时钟旋转90
    backView.transform = at;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowSubTimeLine:) name:kMsg_ShowSubTimeline object:nil];
    
    [self HideStatusBar:YES];

    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];

    mTimelineView = [[VideoTimelineView alloc] initWithFrame:self.view.bounds];
    mTimelineView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTimelineView.delegate = self;
    mTimelineView.OnPageSelect = @selector(OnPageSelect:);
    mTimelineView.OnFinishSelect = @selector(OnFinishClick);
    mTimelineView.OnAddressSelect = @selector(OnAddressSelect);
    mTimelineView.OnGoBack = @selector(GoBack);
    [self.view addSubview:mTimelineView];
}

- (void)GoBack {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[VideoListManager Share] CleanVideos];
    [super GoBack];
}

- (void)OnAddressSelect {
    AddressViewController *ctrl = [[AddressViewController alloc] init];
    //[self.navigationController pushViewController:ctrl animated:YES];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)OnPageSelect:(NSNumber *)value {
    if ([value intValue] == 1 || [value intValue] == 3) {
        if ([self ShowSubTimeLineView:value]) {
            return;
        }
    }
    [self RecordVideo:value];
}

- (void)ShowSubTimeLine:(NSNotification *)noti {
    [self ShowSubTimeLineView:[noti.userInfo objectForKey:@"index"]];
}

- (BOOL)ShowSubTimeLineView:(NSNumber *)value {
    NSArray *array = [[VideoListManager Share] VideosAtIndex:[value intValue]];
    if (array.count>0) {
        SubTimeLineView *subView = (SubTimeLineView *)[self.view viewWithTag:9000];
        if (!subView) {
            subView = [[SubTimeLineView alloc] initWithFrame:self.view.bounds];
            subView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            subView.miIndex = [value intValue];
            subView.mMediaManager = self.mMediaManager;
            subView.mRootCtrl = self;
            subView.tag = 9000;
            [self.view addSubview:subView];
        }
        [subView reloadData];
        return YES;
    }
    return NO;
}

- (void)OnFinishClick {
    ModelSelectViewController *ctrl = [[ModelSelectViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    ctrl.mVideoArray = [[VideoListManager Share] GetAllVideos];
    ctrl.mMediaManager = self.mMediaManager;
    [self presentViewController:navCtrl animated:YES completion:nil];
}

- (void)RecordVideo:(NSNumber *)value {
    float fWidth = [UIScreen mainScreen].bounds.size.width;
    float fHeight = [UIScreen mainScreen].bounds.size.height;
    float fNewWidth = MAX(fWidth, fHeight);
    float fNewHeight = MIN(fWidth, fHeight);
    
    VideoRecordView *recordView = [[VideoRecordView alloc] initWithFrame:CGRectMake(0, 0, fNewWidth, fNewHeight)];
    recordView.mMediaManager = self.mMediaManager;
    recordView.mMediaManager.delegate = recordView;
    
    [self RotateView:recordView];
    [_mMediaManager TakeVideo:YES controlView:recordView animated:YES];
    recordView.mRootCtrl = _mMediaManager.mPicker;
    if (value) {
        int index = [value intValue];
        NSArray *array = [[VideoListManager Share] VideosAtIndex:index];
        [recordView reloadData:array index:index];
        [_mMediaManager ChangeCameraDevice:(index == 0)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (IOS_VER >= 8) {
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.mMediaManager.mRootCtrl = self;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    NSLog(@"preferredInterfaceOrientationForPresentation");
//    return UIInterfaceOrientationLandscapeLeft;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
