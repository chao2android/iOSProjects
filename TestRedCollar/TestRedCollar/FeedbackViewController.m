//
//  FeedbackViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FeedbackViewController.h"
#import "JSON.h"
#import "AutoAlertView.h"

@interface FeedbackViewController ()
{
    UITextView *_theTextView;
}
@end

@implementation FeedbackViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)connectToServer
{
    if (!_theTextView.text || _theTextView.text.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入您的意见"];
        return;
    }
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"feedback" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:_theTextView.text forKey:@"content"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        if ([[dict objectForKey:@"statusCode"] integerValue] == 0)
        {
            [AutoAlertView ShowAlert:@"提示" message:@"发送成功"];
            [self GoBack];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)onSendClick
{
    [self connectToServer];
    [_theTextView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    self.title = @"意见反馈";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"     发送" target:self action:@selector(onSendClick)];
    
    _theTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height-265)];
    _theTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _theTextView.backgroundColor = [UIColor whiteColor];
//    _theTextView.textColor=[UIColor grayColor];
    _theTextView.font=[UIFont systemFontOfSize:17];
    [_theTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _theTextView.inputAccessoryView = [self GetInputAccessoryView];
    [_theTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.view addSubview:_theTextView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_theTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
