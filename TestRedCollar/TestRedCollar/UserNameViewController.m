//
//  UserNameViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserNameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"

@interface UserNameViewController ()
{
    UITextField *mTextField;
}

@end

@implementation UserNameViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
        NSNumber *statusCode = [dict objectForKey:@"statusCode"];
        if ([statusCode isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            [self showMsg:@"保存成功"];
            if (delegate && _onSaveClick)
            {
                SafePerformSelector([delegate performSelector:_onSaveClick withObject:mTextField.text]);
            }
            [self GoBack];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)okClick
{
    if (mDownManager)
    {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    if (_type == typeName)
    {
        NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"modifyUserData" forKey:@"act"];
        [dict setObject:mTextField.text forKey:@"newNickName"];
        [dict setObject:kkToken forKey:@"token"];
        [mDownManager PostHttpRequest:urlstr :dict];
    }
    
    else if (_type == typeSignature)
    {
        NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"modifyUserData" forKey:@"act"];
        [dict setObject:mTextField.text forKey:@"newsignature"];
        [dict setObject:kkToken forKey:@"token"];
        [mDownManager PostHttpRequest:urlstr :dict];
    }
}

-(void)loadLineView:(CGRect)aRect inView:(UIView*)aView
{
    UIView *tImageView=[[UIView alloc] initWithFrame:aRect];
    tImageView.backgroundColor=[UIColor colorWithWhite:0.88 alpha:1.0];
    [aView addSubview:tImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.z
    self.title = _theTitleText;
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@"button_check"] target:self action:@selector(okClick)];
    
    
    UIView *tView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    tView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tView];
    
    mTextField=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, tView.frame.size.height)];
    mTextField.backgroundColor=[UIColor clearColor];
    mTextField.textColor=[UIColor blackColor];
    [mTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [mTextField setBorderStyle:UITextBorderStyleNone];
    [mTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [mTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [tView addSubview:mTextField];
    
    mTextField.text = _theContentText;
    NSLog(@"%@",mTextField.text);

    [self loadLineView:CGRectMake(0, 0, 320, 1) inView:tView];
    [self loadLineView:CGRectMake(0, tView.frame.size.height-1, 320, 1) inView:tView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
