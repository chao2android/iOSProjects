//
//  ReplyViewController.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ReplyViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"

@interface ReplyViewController () {
    UITextView *mTextView;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    self.mTitleColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.title = @"反馈";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"p_backbtn3"] target:self action:@selector(GoBack) scale:1.0];
    [self AddRightTextBtn:@"提交" target:self action:@selector(StartDownload)];
    
    int iHeight = KscreenWidth*3/5;
    
    mTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, iHeight)];
    mTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mTextView.backgroundColor = [UIColor whiteColor];
    mTextView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:mTextView];
    
    [mTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self Cancel];
}

#pragma mark - ImageDownManager

- (void)Cancel{
    [self StopLoading];
    SAFE_CANCEL_ARC(_mDownManager);
}

- (void)StartDownload{
    if (!mTextView.text || mTextView.text.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入反馈内容"];
        return;
    }
    if(_mDownManager){
        return;
    }
    [self StartLoading];
    
    _mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/user/user_reply", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:kkUserID forKey:@"user_id"];
    [dict setObject:mTextView.text forKey:@"content"];
    [_mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            [AutoAlertView ShowAlert:@"提示" message:@"反馈成功"];
        }
        else {
            [AutoAlertView ShowAlert:@"提示" message:@"反馈失败"];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mTopImage = [UIImage imageNamed:@"Image-2"];
    [self RefreshNavColor];
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
