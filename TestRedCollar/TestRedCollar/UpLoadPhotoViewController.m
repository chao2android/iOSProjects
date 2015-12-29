//
//  UpLoadPhotoViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UpLoadPhotoViewController.h"
#import "JSON.h"
#import "ImageDownManager.h"
#import "AutoAlertView.h"

@interface UpLoadPhotoViewController ()

@end

@implementation UpLoadPhotoViewController
{
    NSData *dataPhoto;
    UITextView *mProjectView;
    UITextView *mDescView;
    UIScrollView *mScrollView;
    UIButton *mSelectBtn1;
    UIButton *mSelectBtn2;
    UIButton *mSelectBtn3;
    int miIndex;
}

@synthesize mDownManager;
@synthesize mPhotoManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [self Cancel];
    self.mFilePath1 = nil;
    self.mFilePath2 = nil;
    self.mFilePath3 = nil;
}

- (void)Cancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ASIDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    NSLog(@"OnLoadFinish：%@", sender.mWebStr);
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *msg = [dict objectForKey:@"msg"];
        int iStatus = [[dict objectForKey:@"statusCode"] intValue];
        if (iStatus == 0) {
            [AutoAlertView ShowAlert:@"提示" message:@"上传成功"];
            [self GoBack];
            if (delegate && _onSaveClick) {
                SafePerformSelector([delegate performSelector:_onSaveClick]);
            }
        }else {
            [AutoAlertView ShowAlert:@"提示" message:msg];
        }
    }
}

- (void)OnLoadFail:(ASIDownManager *)sender
{
    NSLog(@"OnLoadFail");
    [self Cancel];
}

- (void)upLoadClick
{
    if (!mProjectView.text || mProjectView.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入设计说明"];
        return;
    }
//    if (!mDescView.text || mDescView.text.length == 0) {
//        [AutoAlertView ShowAlert:@"提示" message:@"请输入描述"];
//        return;
//    }
    
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    int iCount = 0;
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"addPhoto" forKey:@"act"];
    [dict setObject:mProjectView.text forKey:@"title"];
    [dict setObject:mDescView.text forKey:@"desc"];
    [dict setObject:kkToken forKey:@"token"];
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:10];
    if (self.mFilePath1) {
        [files addObject:self.mFilePath1];
        iCount ++;
    }
    if (self.mFilePath2) {
        [files addObject:self.mFilePath2];
        iCount ++;
    }
    if (self.mFilePath3) {
        [files addObject:self.mFilePath3];
        iCount ++;
    }
    [dict setObject:[NSString stringWithFormat:@"%d", iCount] forKey:@"total"];
        
    [mDownManager PostHttpRequest:urlstr :dict files:files :@"imgCode[]"];
}

- (void)OnPhotoSelect:(PhotoSelectManager *)sender
{
    if (miIndex == 0) {
        self.mFilePath1 = sender.mLocalPath;
        UIImage *image = [UIImage imageWithContentsOfFile:sender.mLocalPath];
        [mSelectBtn1 setImage:image forState:UIControlStateNormal];
    }
    else if (miIndex == 1) {
        self.mFilePath2 = sender.mLocalPath;
        UIImage *image = [UIImage imageWithContentsOfFile:sender.mLocalPath];
        [mSelectBtn2 setImage:image forState:UIControlStateNormal];
    }
    else if (miIndex == 2) {
        self.mFilePath3 = sender.mLocalPath;
        UIImage *image = [UIImage imageWithContentsOfFile:sender.mLocalPath];
        [mSelectBtn3 setImage:image forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    mPhotoManager = [[PhotoSelectManager alloc] init];
    mPhotoManager.mRootCtrl = self;
    mPhotoManager.delegate = self;
    mPhotoManager.mbEdit = NO;
    mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
    
    self.title = _theTitleText;
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    mScrollView.scrollEnabled = NO;
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    [self.view addSubview:mScrollView];
    
    int iTop = 10;
    int leftSide = 15;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSide, iTop, self.view.frame.size.width-leftSide*2, 50)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = @"选择一张图片后，你可以继续选择下一张图片，这样就可以一次上传多张图片了。";
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor lightGrayColor];
    [mScrollView addSubview:textLabel];
    
    int iHeight = textLabel.frame.origin.y+textLabel.frame.size.height;
    UILabel *photoInfo = [[UILabel alloc] initWithFrame:CGRectMake(leftSide, iHeight, 150, 30)];
    photoInfo.text = @"图片信息";
    photoInfo.backgroundColor = [UIColor clearColor];
    photoInfo.font = [UIFont systemFontOfSize:16];
    [mScrollView addSubview:photoInfo];
    
    iHeight = photoInfo.frame.origin.y+photoInfo.frame.size.height;
    UIImageView *infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, iHeight, self.view.frame.size.width, 100)];
    infoImage.backgroundColor = [UIColor clearColor];
    infoImage.image = [UIImage imageNamed:@"3_14"];
    [mScrollView addSubview:infoImage];
    for (int i = 0; i < 2; i++)
    {
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 99*i, self.view.frame.size.width, 1)];
        lineImage.backgroundColor = [UIColor clearColor];
        lineImage.image = [UIImage imageNamed:@"51"];
        [infoImage addSubview:lineImage];
    }
    for (int i = 0; i < 3; i ++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(20+100*i, iHeight+10, 80, 80);
        [selectBtn setImage:[UIImage imageNamed:@"my_46.png"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = i+2500;
        [mScrollView addSubview:selectBtn];
        if (i == 0) {
            mSelectBtn1 = selectBtn;
        }
        else if (i == 1) {
            mSelectBtn2 = selectBtn;
        }
        else if (i == 2) {
            mSelectBtn3 = selectBtn;
        }
    }
    
    iHeight = infoImage.frame.origin.y+infoImage.frame.size.height;
    UILabel *projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSide, iHeight, 150, 30)];
    projectLabel.backgroundColor = [UIColor clearColor];
    projectLabel.text = @"街拍说明：";
    projectLabel.font = [UIFont systemFontOfSize:16];
    [mScrollView addSubview:projectLabel];
    
    iHeight = projectLabel.frame.origin.y+projectLabel.frame.size.height+3;
    mProjectView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, iHeight, self.view.frame.size.width, 80)];
    mProjectView.inputAccessoryView = [self GetInputAccessoryView];
    mProjectView.font = [UIFont systemFontOfSize:14];
    mProjectView.delegate = self;
    mProjectView.tag = 0;
    [mScrollView addSubview:mProjectView];
    
    for (int i = 0; i < 2; i++)
    {
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 79*i, self.view.frame.size.width, 1)];
        lineImage.backgroundColor = [UIColor clearColor];
        lineImage.image = [UIImage imageNamed:@"g_10 (2)"];
        [mProjectView addSubview:lineImage];
    }
    
    iHeight = mProjectView.frame.origin.y+mProjectView.frame.size.height+3;
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSide, iHeight, 150, 30)];
    descLabel.text = @"描述：";
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:16];
    [mScrollView addSubview:descLabel];
    
    iHeight = descLabel.frame.origin.y+descLabel.frame.size.height+3;
    mDescView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, iHeight, self.view.frame.size.width, 80)];
    mDescView.inputAccessoryView = [self GetInputAccessoryView];
    mDescView.font = [UIFont systemFontOfSize:14];
    mDescView.delegate = self;
    mDescView.tag = 1;
    [mScrollView addSubview:mDescView];
    
    for (int i = 0; i < 2; i++)
    {
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 79*i, self.view.frame.size.width, 1)];
        lineImage.backgroundColor = [UIColor clearColor];
        lineImage.image = [UIImage imageNamed:@"g_10 (2)"];
        [mDescView addSubview:lineImage];
    }
    
    iHeight = mDescView.frame.origin.y+mDescView.frame.size.height+15;

    UIButton *upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upLoadBtn.frame = CGRectMake(leftSide+5, iHeight, self.view.frame.size.width-(leftSide+5)*2, 44);
    [upLoadBtn setImage:[UIImage imageNamed:@"my_47.png"] forState:UIControlStateNormal];
    [upLoadBtn addTarget:self action:@selector(upLoadClick) forControlEvents:UIControlEventTouchUpInside];
    [mScrollView addSubview:upLoadBtn];
    
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, iHeight+60);
}

- (void)selectClick:(UIButton *)sender
{
    miIndex = sender.tag-2500;
    UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    mPhotoManager.mDefaultName = [NSString stringWithFormat:@"uploadpic%d.jpg", miIndex+1];
    if (buttonIndex == 0) {
        [mPhotoManager TakePhoto:YES];
    }
    else if (buttonIndex == 1) {
        [mPhotoManager TakePhoto:NO];
    }
}

- (void)textViewKeyboardWillShow:(NSNotification *)aNotification
{
    
}

- (void)textViewKeyboardWillHide:(NSNotification *)aNotification
{
    mScrollView.contentOffset = CGPointMake(0, 0);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    int iOffset = 0;
    if (IsRetina) {
        if (textView == mProjectView) {
            iOffset = 190;
        }
        else if (textView == mDescView) {
            iOffset = 300;
        }
    }else if (IsiPhone5) {
        if (textView == mProjectView) {
            iOffset = 130;
        }
        else if (textView == mDescView) {
            iOffset = 190;
        }
    }
    mScrollView.contentOffset = CGPointMake(0, iOffset);
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
