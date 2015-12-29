//
//  SendPhotoViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SendPhotoViewController.h"
#import "AutoAlertView.h"

@interface SendPhotoViewController ()

@end

@implementation SendPhotoViewController

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
    self.title = @"照片编辑";
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"发送" target:self action:@selector(OnSubmitBtnClick)];
    
    
    UIImageView *textbackView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, self.view.frame.size.width-20, 103)];
    textbackView.image = [UIImage imageNamed:@"f_textback.png"];
    textbackView.userInteractionEnabled = YES;
    [self.view addSubview:textbackView];
    
    mTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, textbackView.frame.size.width-10, textbackView.frame.size.height-10)];
    mTextView.delegate = self;
    mTextView.backgroundColor = [UIColor clearColor];
    mTextView.font = [UIFont systemFontOfSize:16];
    [textbackView addSubview:mTextView];
    
    mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(8, 7, 100, 20)];
    mlbDesc.backgroundColor = [UIColor clearColor];
    mlbDesc.font = [UIFont systemFontOfSize:16];
    mlbDesc.textColor = [UIColor grayColor];
    mlbDesc.text = @"说点什么..";
    [textbackView addSubview:mlbDesc];
    
    mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 115, 40, 40)];
    mImageView.image = self.mImage;
    [self.view addSubview:mImageView];

    [mTextView becomeFirstResponder];
}

- (void)dealloc {
    self.mImage = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    mlbDesc.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    mlbDesc.hidden = (textView.text && textView.text.length>0);
}

- (void)OnSubmitBtnClick {
    [self GoHome];
    [AutoAlertView ShowAlert:@"提示" message:@"发送成功"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
