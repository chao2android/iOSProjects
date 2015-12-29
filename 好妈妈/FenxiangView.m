//
//  FenxiangView.m
//  好妈妈
//
//  Created by iHope on 13-9-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "FenxiangView.h"
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import "AGViewDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "FenxiangView.h"
#import "ASIHTTPRequest.h"
@implementation FenxiangView
@synthesize shareTypeArray;
- (void)dealloc
{
    [shareTypeArray release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame cont:(id)controllerView
{
    self = [super initWithFrame:frame];
    if (self) {
        longinView=(LoginViewController *)controllerView;
        UIImageView * qtImageView=[[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width-304)/2, 15, 304, 13)];
        qtImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"000_qt2" ofType:@"png"]];
        [self addSubview:qtImageView];
        [qtImageView release];
        if (ISIPAD) {
            qtImageView.frame=CGRectMake((Screen_Width-304*1.4)/2, 15*1.4, 304*1.4, 13*1.4);
        }
        for (int i=0; i<3; i++) {
            UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"006_%d",i+14] ofType:@"png"]] forState:UIControlStateNormal];
            button.tag=i;
            [button addTarget:self action:@selector(OtherLoginMenth:) forControlEvents:UIControlEventTouchUpInside];
            button.frame=CGRectMake((Screen_Width-150)/2+50*i,frame.size.height-55, 35, 35);
            if (ISIPAD) {
                button.frame=CGRectMake((Screen_Width-150*1.4)/2+50*1.4*i,(frame.size.height-55)*1.4, 35*1.4, 35*1.4);
            }
            [self addSubview:button];
            self.shareTypeArray = [[[NSMutableArray alloc] initWithObjects:
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"新浪微博",
                                     @"title",
                                     [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                                     @"type",
                                     nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"QQ",
                                     @"title",
                                     [NSNumber numberWithInteger:ShareTypeQQSpace],
                                     @"type",
                                     nil],
                                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"腾讯微博",
                                     @"title",
                                     [NSNumber numberWithInteger:ShareTypeTencentWeibo],
                                     @"type",
                                     nil],nil] autorelease];
            
            
        }
        
        // Initialization code
    }
    return self;
}
- (void)OtherLoginMenth:(UIButton *)sender
{
    
    NSMutableDictionary *item = [self.shareTypeArray objectAtIndex:sender.tag];
    
    ShareType type = [[item objectForKey:@"type"] integerValue];
    
    if (ISIPAD&&type==2)
    {
        
        id<ISSAuthController> controller=[ShareSDK authorizeController:ShareTypeTencentWeibo];
        
        [controller  start:NO result:^(SSAuthState state ,CMErrorInfo *error){
            NSLog(@"state  %d",state);
            if (state)
            {
                
                [[controller view]removeFromSuperview];
                [ShareSDK getUserInfoWithType:type
                                  authOptions:nil
                                       result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                           if (result)
                                           {
                                               NSLog(@"%@  %d",[userInfo icon],[userInfo type]);
                                               NSString * typeString=nil;
                                               if ([userInfo type]==1) {
                                                   typeString=@"1";
                                               }
                                               else if ([userInfo type]==2)
                                               {
                                                   typeString=@"2";
                                               }
                                               else
                                               {
                                                   typeString=@"3";
                                               }
                                               NSURL *url=nil;
                                               if ([typeString isEqualToString:@"3"]) {
                                                   
                                               
                                               url = [NSURL URLWithString:[[userInfo sourceData] valueForKey:@"figureurl_qq_2"]];
                                               }
                                               else
                                               {
                                                   url = [NSURL URLWithString:[userInfo icon]];
 
                                               }
                                               
                                                   UIImage * image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                                                   NSLog(@"image  %@",image);
                                                   int iWidth = image.size.width;
                                                   int iHeight = image.size.height;
                                                   if (iWidth>400) {
                                                       iWidth = 400;
                                                       iHeight = image.size.height*iWidth/image.size.width;
                                                       if (iHeight>550) {
                                                           iHeight = 550;
                                                           iWidth = image.size.width*iHeight/image.size.height;
                                                       }
                                                   }
                                                   NSString *imagename = [self mLocalPath];
                                                   image = [self scaleToSize:image :CGSizeMake(iWidth, iHeight)];
                                                   NSData *data = UIImageJPEGRepresentation(image, 0.95);
                                                   NSLog(@"%@",data);
                                                   [data writeToFile:imagename atomically:YES];
                                                   NSLog(@"%@",[self mLocalPath]);
                                                   NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userInfo uid],@"otherID",typeString,@"othertype",[userInfo nickname],@"nickname", nil];
                                               if (data) {
                                                   [diction setValue:[self mLocalPath] forKey:@"feil"];
                                               }
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"pushController" object:diction];
                                                   [diction release];
                                                   
                                                   
//                                               }];
//                                               
//                                               [request setFailedBlock:^{
//                                                   
//                                                   NSError *error = [request error];
//                                                   NSLog(@"%@",error);
//                                               }];
//                                               
//                                               [request startAsynchronous];                                               [item setObject:[userInfo nickname] forKey:@"username"];
                                               [self.shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                           }
                                           if ([[error errorDescription] length]) {
                                               
                                               
                                               UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[error errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                               [alertView show];
                                               [alertView release];
                                               NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                                           }
                                       }];
                
            }
        }];
        if (![controller isSSOLogin]) {
            aView=[controller view];
            aView.frame=CGRectMake(0, 0, Screen_Width, Screen_Height);
            [longinView.view addSubview:aView];
            UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
            navigation.userInteractionEnabled=YES;
            navigation.backgroundColor=[UIColor blackColor];
            navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
            [aView addSubview:navigation];
            [navigation release];
            UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 11, (Screen_Width-160), 22)];
            navigationLabel.backgroundColor=[UIColor clearColor];
            navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
            navigationLabel.textAlignment=NSTextAlignmentCenter;
            navigationLabel.textColor=[UIColor whiteColor];
            navigationLabel.text=@"腾讯微博授权";
            [navigation addSubview:navigationLabel];
            [navigationLabel release];
            UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
            back.frame = CGRectMake(5, 7, 51, 33);
            [back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
            [back setTitle:@"取 消" forState:UIControlStateNormal];
            [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
            [navigation addSubview:back];
        }
    }
    else
    {
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
                                       NSLog(@"%@  %d  %@ %@",[userInfo uid],[userInfo type],[userInfo localUser],[[userInfo sourceData] valueForKey:@"figureurl_qq_2"]);
                                       NSString * typeString=nil;
                                       if ([userInfo type]==1) {
                                           typeString=@"1";
                                       }
                                       else if ([userInfo type]==2)
                                       {
                                           typeString=@"2";
                                       }
                                       else
                                       {
                                           typeString=@"3";
                                       }
                                       
                                       
                                       NSURL *url=nil;
                                       if ([typeString isEqualToString:@"3"]) {
                                           
                                           
                                           url = [NSURL URLWithString:[[userInfo sourceData] valueForKey:@"figureurl_qq_2"]];
                                       }
                                       else
                                       {
                                           url = [NSURL URLWithString:[userInfo icon]];
                                           
                                       }
                                       
                                       NSLog(@"%@",url);

                                       UIImage * image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                                       NSLog(@"%@",image);
                                           int iWidth = image.size.width;
                                           int iHeight = image.size.height;
                                           if (iWidth>400) {
                                               iWidth = 400;
                                               iHeight = image.size.height*iWidth/image.size.width;
                                               if (iHeight>550) {
                                                   iHeight = 550;
                                                   iWidth = image.size.width*iHeight/image.size.height;
                                               }
                                           }
                                           NSString *imagename = [self mLocalPath];
                                           image = [self scaleToSize:image :CGSizeMake(iWidth, iHeight)];
                                           NSData *data = UIImageJPEGRepresentation(image, 0.95);
                                           NSLog(@"%@",data);
                                           [data writeToFile:imagename atomically:YES];
                                           NSLog(@"%@",[self mLocalPath]);
                                           NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userInfo uid],@"otherID",typeString,@"othertype",[userInfo nickname],@"nickname", nil];
                                       if (data) {
                                           [diction setValue:[self mLocalPath] forKey:@"feil"];
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"pushController" object:diction];
                                           [diction release];

                                           
//                                       }];
//                                    
//                                       [request setFailedBlock:^{
//                                           
//                                           NSError *error = [request error];
//                                           NSLog(@"%@",error);
//                                       }];
//                                       
//                                       [request startAsynchronous];
                                        [item setObject:[userInfo nickname] forKey:@"username"];
                                       [self.shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                   }
                                   if ([[error errorDescription] length]) {
                                       
                                       
                                       //                               UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[error errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                       //                               [alertView show];
                                       //                               [alertView release];
                                   }
                               }];
    }
    
}
- (UIImage *)scaleToSize:(UIImage *)image :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (NSString *)mLocalPath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"touxiang.jpg"];
}

- (void)backup
{
    [aView removeFromSuperview];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
