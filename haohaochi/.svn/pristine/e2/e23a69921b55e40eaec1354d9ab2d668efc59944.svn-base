//
//  ShareViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShareViewController.h"
#import "VideoListManager.h"
#import "VideoUrlInfo.h"
#import "DWUploadViewController.h"
#import "VideoUploadManager.h"

@interface ShareViewController () {
    UIView *mShareView;
    UIButton *mSelectBtn;
    UITextView *mTextView;
    UIImageView *mInputView;
    UIImageView *mImageView;
    UIButton *mInputBtn;
    UIView *mBotView;
    int miProgress;
    UIButton *mUploadBtn;
}

@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableArray *mCutArray;
@property (nonatomic, strong) NSURL *mExportUrl;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    self.mTopImage = [UIImage imageNamed:@"topbar7"];
    [super viewDidLoad];
    
    self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnJoinFinish:) name:kMsg_JoinMediaFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnJoinFinish:) name:kMsg_MixSoundFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnJoinFinish:) name:kMsg_ImgToMovFinish object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"发布";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback"] target:self action:@selector(GoBack)];

    int iTop = 0;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-145)/2, iTop+60, 145, 70)];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
//    imageView.image = [UIImage imageNamed:@"f_logo2"];
//    imageView.layer.cornerRadius = 10;
//    imageView.layer.masksToBounds = YES;
//    [self.view addSubview:imageView];
    
    self.mThumb = [[VideoListManager Share] ThumbAtIndex:0];
    
    int iLeft = (self.view.frame.size.width-160)/2;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(iLeft, iTop+10, 160, 120)];
    backView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:backView];
    
    mImageView = [[UIImageView alloc] initWithFrame:backView.bounds];
    mImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mImageView.image = self.mThumb;
    mImageView.layer.cornerRadius = 10;
    mImageView.layer.masksToBounds = YES;
    [backView addSubview:mImageView];
    
    iTop += backView.frame.size.height;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(backView.frame.size.width-45, iTop-20, 40, 40);
    editBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [editBtn setImage:[UIImage imageNamed:@"f_editbtn"] forState:UIControlStateNormal];
    [backView addSubview:editBtn];

    mInputView = [[UIImageView alloc] initWithFrame:CGRectMake(25, iTop+20, self.view.frame.size.width-50, 86)];
    mInputView.hidden = YES;
    mInputView.userInteractionEnabled = YES;
    mInputView.image = [UIImage imageNamed:@"f_textback"];
    [self.view addSubview:mInputView];
    
    mTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, mInputView.frame.size.width-10, mInputView.frame.size.height-10)];
    mTextView.backgroundColor = [UIColor clearColor];
    mTextView.inputAccessoryView = [self GetInputAccessoryView];
    mTextView.font = [UIFont systemFontOfSize:16];
    [mInputView addSubview:mTextView];
    
    mInputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mInputBtn.frame = CGRectMake((self.view.frame.size.width-200)/2, iTop+20, 200, 50);
    mInputBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [mInputBtn setTitle:@"轻点添加说明..." forState:UIControlStateNormal];
    [mInputBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    mInputBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [mInputBtn addTarget:self action:@selector(OnInputClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mInputBtn];
    
    mShareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-215, self.view.frame.size.width, 110)];
    mShareView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mShareView];
    
    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mShareView.frame.size.width, 25)];
    lbText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    lbText.textAlignment = NSTextAlignmentCenter;
    lbText.textColor = [UIColor grayColor];
    lbText.text = @"分享到：";
    [mShareView addSubview:lbText];
    
    float iWidth = (self.view.frame.size.width-50*3)/4;
    for (int i = 0; i < 3; i ++) {
        NSString *imagename = [NSString stringWithFormat:@"share%02d1", i+1];
        NSString *imagename2 = [NSString stringWithFormat:@"share%02d2", i+1];
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(iWidth+i*(iWidth+50), 40, 50, 50);
        shareBtn.tag = 500+i;
        shareBtn.adjustsImageWhenHighlighted = NO;
        [shareBtn setImage:[UIImage imageNamed:imagename2] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:imagename] forState:UIControlStateSelected];
        [shareBtn addTarget:self action:@selector(OnShareSelect:) forControlEvents:UIControlEventTouchUpInside];
        [mShareView addSubview:shareBtn];
        
        if (i == 1) {
            mSelectBtn = shareBtn;
        }
    }
    [mSelectBtn setSelected:YES];

    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, self.view.frame.size.height-104, self.view.frame.size.width, 104);
    saveBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    saveBtn.backgroundColor = kDefault_Color2;
    [saveBtn setTitle:@"保存到本地" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [saveBtn addTarget:self action:@selector(OnJoinClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    mUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mUploadBtn.frame = saveBtn.frame;
    mUploadBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    mUploadBtn.backgroundColor = kDefault_Color2;
    [mUploadBtn setTitle:@"发布" forState:UIControlStateNormal];
    [mUploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mUploadBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    [mUploadBtn addTarget:self action:@selector(UploadVideo) forControlEvents:UIControlEventTouchUpInside];
    mUploadBtn.hidden = YES;
    [self.view addSubview:mUploadBtn];
    
}

- (void)ShowProgressView {
    [self HideProgressView];
    mBotView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-104, self.view.frame.size.width, 104)];
    mBotView.backgroundColor = [UIColor whiteColor];
    mBotView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mBotView];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mBotView.frame.size.width, 28)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lineView.image = [UIImage imageNamed:@"f_progress01"];
    [mBotView addSubview:lineView];
    
    UIImageView *progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    progressView.image = [UIImage imageNamed:@"f_progress02"];
    [mBotView addSubview:progressView];
    
    UILabel *lbText = [[UILabel alloc] initWithFrame:lineView.frame];
    lbText.backgroundColor = [UIColor clearColor];
    lbText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lbText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    lbText.textAlignment = NSTextAlignmentCenter;
    lbText.textColor = [UIColor grayColor];
    lbText.text = @"视频生成中...";
    [mBotView addSubview:lbText];
    
    miProgress = 0;
    [self AnimateProgress:progressView];
}

- (void)AnimateProgress:(UIView *)progressView {
    float fOffset = mBotView.frame.size.width/100;
    [UIView animateWithDuration:0.1 animations:^{
        float fWidth = miProgress*fOffset;
        miProgress ++;
        progressView.frame = CGRectMake(0, 0, fWidth, 28);
    } completion:^(BOOL finished) {
        if (miProgress < 100) {
            [self AnimateProgress:progressView];
        }
    }];
}

- (void)HideProgressView {
    @autoreleasepool {
        if (mBotView) {
            [mBotView removeFromSuperview];
            mBotView = nil;
        }
    }
}

- (void)OnInputClick {
    mInputBtn.hidden = YES;
    mInputView.hidden = NO;
    [mTextView becomeFirstResponder];
}

- (void)OnHideKeyboard {
    mInputBtn.hidden = NO;
    [mTextView resignFirstResponder];
    if (mTextView.text && mTextView.text.length>0) {
        mInputView.hidden = NO;
        [mInputBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        mInputView.hidden = YES;
        [mInputBtn setTitle:@"轻点添加说明..." forState:UIControlStateNormal];
    }
}

- (void)OnShareSelect:(UIButton *)sender {
    [mSelectBtn setSelected:NO];
    mSelectBtn = sender;
    [mSelectBtn setSelected:YES];
}

- (void)OnJoinClick {
    [self ShowProgressView];
    [self StartLoading];
    [self.mArray removeAllObjects];
    NSArray *array = [[VideoListManager Share] GetAllVideos2];
    if (array) {
        [self.mArray addObjectsFromArray:array];
    }
    NSLog(@"%@, %@, %@", self.mVideoArray, self.mAudioUrl, self.mSelectFont);
    
    [self JoinVideoHeader];
}

- (void)JoinVideoHeader {
    NSLog(@"JoinVideoHeader");
    NSArray *array = [[VideoListManager Share] VideosAtIndex:3];
    if (array.count == 0) {
        NSLog(@"JoinVideoHeader Error");
        return;
    }
    NSString *text = [UserInfoManager Share].mWatermark;
    int iFontSize = 42;
    if (text.length>0) {
        int iCount = [UserInfoManager sinaCountWord:text];
        iFontSize = 280/iCount;
        if (iFontSize > 42) {
            iFontSize = 42;
        }
    }
    
    miStepIndex = 0;
    NSDictionary *dict = [array objectAtIndex:0];
    
    VideoUrlInfo *info = [[VideoUrlInfo alloc] init];
    info.mUrl = [dict objectForKey:@"url"];
    info.mfTime = [[dict objectForKey:@"time"] floatValue];
    info.mfStartTime = [[dict objectForKey:@"starttime"] floatValue];

    _mMediaManager.mWatermarkFont = [UIFont fontWithName:self.mSelectFont size:iFontSize];
    _mMediaManager.mWatermark = [UserInfoManager Share].mWatermark;;
    [_mMediaManager JoinMedia:@[info] :nil];
}

- (void)JoinVideoFooter {
    NSString *path = [kDocumentPath stringByAppendingPathComponent:@"videofooter.mov"];
    [self.mMediaManager ImageToMovie:[UIImage imageNamed:@"f_logo.jpg"] path:path duration:2 size:_mMediaManager.mVideoSize];
}

- (void)JoinTotalVideos {
    NSLog(@"JoinTotalVideos:%@", self.mArray);
    _mMediaManager.mWatermark = nil;
    [_mMediaManager JoinMedia:self.mArray :self.mAudioUrl];
}

- (void)MixAudios {
    NSLog(@"MixAudios:%@", self.mArray);
    _mMediaManager.mWatermark = nil;
    [_mMediaManager MixSound:self.mArray :self.mAudioUrl];
}

- (void)OnJoinFinish:(NSNotification *)noti {
    NSDictionary *userinfo = noti.userInfo;
    VideoUrlInfo *info = [[VideoUrlInfo alloc] init];
    info.mUrl = [userinfo objectForKey:@"url"];
    
    NSLog(@"OnJoinFinish:%@", info.mUrl);
    miStepIndex ++;
    if (miStepIndex == 1) {
        [self.mArray insertObject:info atIndex:0];
        [self JoinVideoFooter];
    }
    else if (miStepIndex == 2) {
        [self.mArray addObject:info];
        [self MixAudios];
    }
    else if (miStepIndex == 3) {
        self.mAudioUrl = info.mUrl;
        [self JoinTotalVideos];
    }
    else if (miStepIndex == 4) {
        [self StopLoading];
        [_mMediaManager SaveToAlbum:info.mUrl block:^{
            [self HideProgressView];
            self.mExportUrl = info.mUrl;
            mUploadBtn.hidden = NO;
        }];
    }
}

- (void)UploadVideo {
    if (!mTextView.text || mTextView.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请填写说明"];
        return;
    }
    DWUploadInfo *info = [[DWUploadInfo alloc] init];
    info.mTitle = kUserInfoManager.mWatermark;
    info.mContent = mTextView.text;
    info.mAddress = kUserInfoManager.mAddInfo.address;
    info.mLatitude = kUserInfoManager.mAddInfo.latitude;
    info.mLongitude = kUserInfoManager.mAddInfo.longitude;
    info.mCityID = @"1";
    
    [[VideoUploadManager Share] AddToVideoList:self.mExportUrl image:self.mThumb :info];
    DWUploadViewController *ctrl = [[DWUploadViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mVideoArray = nil;
    self.mMediaManager = nil;
    self.mArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
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
