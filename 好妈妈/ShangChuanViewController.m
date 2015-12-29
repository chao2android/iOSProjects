//
//  ShangChuanViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-18.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ShangChuanViewController.h"
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import "AGViewDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "FenxiangView.h"
#import "PhotoSelectManager.h"
#import "TishiView.h"
#import "AutoAlertView.h"
#import "Share.h"
@interface ShangChuanViewController ()

@end

@implementation ShangChuanViewController
@synthesize oldDictionary;
@synthesize shareTypeArray;
@synthesize shareArray;
- (void)dealloc
{
    [shareArray release];
    [shareTypeArray release];
    [oldDictionary release];
    [super dealloc];
}
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
    self.shareArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    self.shareTypeArray = [[[NSMutableArray alloc] initWithObjects:
                            [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @"新浪微博",
                             @"title",
                             [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                             @"type",
                             nil],
                            
                            [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @"腾讯微博",
                             @"title",
                             [NSNumber numberWithInteger:ShareTypeTencentWeibo],
                             @"type",
                             nil],
                            [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"QQ空间",
                                   @"title",
                                   [NSNumber numberWithInteger:ShareTypeQQSpace],
                                   @"type",
                                   nil],nil] autorelease];
    gongkai=0;
    backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.userInteractionEnabled=YES;
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=[self.oldDictionary valueForKey:@"title"];
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fanhui" ofType:@"png"]] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_39" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut];
    UIImageView * textImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, (KUIOS_7(44))+5,Screen_Width-10, 100)];
    textImageView.userInteractionEnabled=YES;
    textImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shuru" ofType:@"png"]];
    [backImageView addSubview:textImageView];
    [textImageView release];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];

    smTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, KUIOS_7(5),textImageView.frame.size.width-10, 90)];
    smTextView.tag=0;
    if ([[self.oldDictionary valueForKey:@"text"] length]) {
        
    
    smTextView.text=[self.oldDictionary valueForKey:@"text"];
    }
    else
    {
        smTextView.text=date;

    }
    if ([[self.oldDictionary valueForKey:@"title"] isEqualToString:@"发表图片"]) {
        
    
    UILabel * tjtpLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, (KUIOS_7(44))+15, 80, 18)];
    tjtpLabel.textColor=[UIColor blackColor];
    [tjtpLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    tjtpLabel.text=@"添加图片:";
    tjtpLabel.backgroundColor=[UIColor clearColor];
    tjtpLabel.textAlignment=UITextAlignmentRight;
    [backImageView addSubview:tjtpLabel];
    [tjtpLabel release];
    touxiangImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(90, tjtpLabel.frame.origin.y-2, 160, 170)];
    [touxiangImageView addTarget:self action:@selector(TouXiangMenth) forControlEvents:UIControlEventTouchUpInside];
        if ([[self.oldDictionary valueForKey:@"file"] length]) {
            touxiangImageView.image=[UIImage imageWithContentsOfFile:[self.oldDictionary valueForKey:@"file"]];
        }
        else
        {
            touxiangImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_44" ofType:@"png"]];

        }
    [backImageView addSubview:touxiangImageView];
    [touxiangImageView release];
    
    UILabel * tjsmLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, touxiangImageView.frame.size.height+touxiangImageView.frame.origin.y+20, 80, 18)];
    tjsmLabel.textColor=[UIColor blackColor];
    [tjsmLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    tjsmLabel.text=@"添加说明:";
    tjsmLabel.backgroundColor=[UIColor clearColor];
    tjsmLabel.textAlignment=UITextAlignmentRight;
    [backImageView addSubview:tjsmLabel];
    [tjsmLabel release];
        textImageView.frame=CGRectMake(touxiangImageView.frame.origin.x, tjsmLabel.frame.origin.y-5, Screen_Width-touxiangImageView.frame.origin.x-10, 80);
        smTextView.frame=CGRectMake(5, 5,textImageView.frame.size.width-10, 70);
        smTextView.tag=1;

    }
    smTextView.delegate=self;
    
    [textImageView addSubview:smTextView];
    [smTextView release];

    
    
    tiaojianView=[[UIView alloc]initWithFrame:CGRectMake(0, textImageView.frame.size.height+textImageView.frame.origin.y+15, Screen_Width, 80)];
    tiaojianView.backgroundColor=[UIColor clearColor];
    [backImageView addSubview:tiaojianView];
    [tiaojianView release];
    UILabel * sfgkLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 18)];
    sfgkLabel.textColor=[UIColor blackColor];
    [sfgkLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    sfgkLabel.text=@"是否公开:";
    sfgkLabel.backgroundColor=[UIColor clearColor];
    sfgkLabel.textAlignment=UITextAlignmentRight;
    [tiaojianView addSubview:sfgkLabel];
    [sfgkLabel release];
    
    for (int i=0; i<2; i++) {
        UIButton * gongkaiBut=[UIButton buttonWithType:UIButtonTypeCustom];
        gongkaiBut.tag=i;
        gongkaiBut.frame=CGRectMake(120+80*i, 2, 20, 20);
        [tiaojianView addSubview:gongkaiBut];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(gongkaiBut.frame.origin.x+30, 2, 20, 20)];
        label.backgroundColor=[UIColor clearColor];
        [gongkaiBut addTarget:self action:@selector(GongKaiMenth:) forControlEvents:UIControlEventTouchUpInside];
        [tiaojianView addSubview:label];
        [label release];
        if ([[oldDictionary valueForKey:@"private"] intValue]) {
            if (i==0) {
                label.text=@"是";
                [gongkaiBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fou" ofType:@"png"]] forState:UIControlStateNormal];
            }
            else
            {
                label.text=@"否";
                [gongkaiBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shi" ofType:@"png"]] forState:UIControlStateNormal];
                
            }
            
        }
        else
        {
            if (i==0) {
                label.text=@"是";
                [gongkaiBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shi" ofType:@"png"]] forState:UIControlStateNormal];
            }
            else
            {
                label.text=@"否";
                [gongkaiBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fou" ofType:@"png"]] forState:UIControlStateNormal];
                
            }
            
        }
        
    }    UILabel * fenxianglabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 50, 100, 18)];
    fenxianglabel.backgroundColor=[UIColor clearColor];
    fenxianglabel.text=@"同步分享到:";
    fenxianglabel.textAlignment=UITextAlignmentRight;
    [fenxianglabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [tiaojianView addSubview:fenxianglabel];
    [fenxianglabel release];
    for (int i=0; i<2; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_",i*2+14] ofType:@"png"]] forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(OtherLoginMenth:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(120+50*i,45, 25, 25);
        [tiaojianView addSubview:button];
    }
    tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:tishiView];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [smTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        backImageView.frame=CGRectMake(backImageView.frame.origin.x, 0, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
    [tishiView StartMenth];
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"fabuweiriji" delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    
    
    if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]==1) {
        tishiView.titlelabel.text=@"发表成功";
        [self performSelector:@selector(backup) withObject:self afterDelay:0.5];
    }
    else
    {
        tishiView.titlelabel.text=@"发表失败";
        [self performSelector:@selector(ReMoveTishiMenth) withObject:self afterDelay:0.5];

    }
    [asi release];
    analysis=nil;
}
- (void)ReMoveTishiMenth
{
    [tishiView StopMenth];
}
- (void)TouXiangMenth
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSTimeInterval sTime=[[formatter dateFromString:[self.oldDictionary valueForKey:@"date"]] timeIntervalSince1970];
    NSTimeInterval time = [[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] timeIntervalSince1970];

    [formatter release];
    if (time>sTime) {
        UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择照相来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选取", nil];
        actionSheet.tag=1;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else
    {
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择照相来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取", nil];
        actionSheet.tag=0;
    [actionSheet showInView:self.view];
    [actionSheet release];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=2) {
        PhotoSelectManager * mPhotoManager = [[PhotoSelectManager alloc] init];
        mPhotoManager.mRootCtrl = self;
        mPhotoManager.delegate = self;
        mPhotoManager.mbEdit = NO;
        mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
        if (actionSheet.tag) {
            [mPhotoManager TakePhoto:NO];

        }
        else
        {
        if (buttonIndex) {
            [mPhotoManager TakePhoto:NO];
        }
        else
        {
            [mPhotoManager TakePhoto:YES];
        }
        }

    }
}
- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    [self.oldDictionary setValue:[sender mLocalPath] forKey:@"file"];
    touxiangImageView.image=[UIImage imageWithContentsOfFile:[sender mLocalPath]];
}
- (void)GongKaiMenth:(UIButton *)sender
{
    gongkai=sender.tag;
    for (int i=1; i<4; i+=2) {
        if (sender.tag) {
            if (i==1) {
                [[tiaojianView.subviews objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fou" ofType:@"png"]] forState:UIControlStateNormal];
            }
            else
            {
                [[tiaojianView.subviews objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shi" ofType:@"png"]] forState:UIControlStateNormal];
            }

                    }
        else
        {
            if (i==1) {
                [[tiaojianView.subviews objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shi" ofType:@"png"]] forState:UIControlStateNormal];
            }
            else
            {
                [[tiaojianView.subviews objectAtIndex:i] setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fou" ofType:@"png"]] forState:UIControlStateNormal];
            }


        }


    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag) {
    [UIView animateWithDuration:0.2 animations:^{
        backImageView.frame=CGRectMake(backImageView.frame.origin.x, -100, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
    }
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if (te ) {
//        <#statements#>
//    }
//    if (smTextView.text.length>12) {
//        return NO;
//    }
    return YES;
}
- (void)backup
{
    if (analysis) {
        [analysis CancelMenthrequst];
        analysis=nil;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"rilianalyUrl" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"analyUrl" object:nil];
    [tishiView StopMenth];
    [self dismissModalViewControllerAnimated:NO];
}

- (void)RightMenth
{
    
    if (!smTextView.text.length) {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入内容"];
        return;
    }
    if ([[self.oldDictionary valueForKey:@"title"] isEqualToString:@"发表图片"]) {
        if (![[self.oldDictionary valueForKey:@"file"] length]) {
            [AutoAlertView ShowAlert:@"温馨提示" message:@"请添加图片"];
            return;
        }
    }
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    NSMutableDictionary * Dictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",nil];
    [Dictionary addEntriesFromDictionary:self.oldDictionary];
    [Dictionary setValue:smTextView.text forKey:@"text"];
    

    if (gongkai) {
        [Dictionary setObject:@"1" forKey:@"privates"];
    }
    else
    {
        [Dictionary setObject:@"0" forKey:@"privates"];

    }
    [self ShareMenth];
    
    [self analyUrl:Dictionary];
    [Dictionary release];
}
- (void)ShareMenth
{
    for (int i=0; i<self.shareArray.count; i++)
    {
        [Share SharecontentMenth:smTextView.text shareImagePath:[self.oldDictionary valueForKey:@"file"] biaoti:nil fenxiangleixing:[[self.shareArray objectAtIndex:i] intValue]];
    }
}

- (void)OtherLoginMenth:(UIButton *)sender
{    sender.opaque=!sender.opaque;

    if (!sender.opaque) {
        
    
    [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d_",14+sender.tag*2] ofType:@"png"]] forState:UIControlStateNormal];
    
    if (sender.tag==0) {
        [self.shareArray removeObject:[NSString stringWithFormat:@"%d",1]];
        
    }
    else if (sender.tag==1)
    {        [self.shareArray removeObject:[NSString stringWithFormat:@"%d",2]];

    
    }else
    {
        [self.shareArray removeObject:[NSString stringWithFormat:@"%d",6]];

    }
        return;
    }
    
    NSMutableDictionary *item = [self.shareTypeArray objectAtIndex:sender.tag];
       //用户用户信息
    ShareType type = [[item objectForKey:@"type"] integerValue];
    AGViewDelegate * _viewDelegate1 = [[AGViewDelegate alloc] init];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:_viewDelegate1];
    [authOptions setPowerByHidden:YES];

    [_viewDelegate1 release];
    
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   if ([userInfo type]==1) {
                                       [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_14" ofType:@"png"]] forState:UIControlStateNormal];
                                   }
                                   else if ([userInfo type]==2)
                                   {
                                       [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_16" ofType:@"png"]] forState:UIControlStateNormal];

                                   }
                                   else
                                   {
                                        [sender setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_181" ofType:@"png"]] forState:UIControlStateNormal];
                                   }
                                   [self.shareArray addObject:[NSString stringWithFormat:@"%d",[userInfo type]]];
                                
                                   [item setObject:[userInfo nickname] forKey:@"username"];
                                   [self.shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                               }
                               if ([[error errorDescription] length]) {
                                   
                                  NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                               }
                           }];


}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [smTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        backImageView.frame=CGRectMake(backImageView.frame.origin.x, 0, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
