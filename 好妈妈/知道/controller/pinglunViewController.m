//
//  pinglunViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-16.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "pinglunViewController.h"
#import "AppDelegate.h"

#import "PhotoSelectManager.h"
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
#import "Share.h"
@interface pinglunViewController ()

@end

@implementation pinglunViewController
@synthesize shareArray;
-(void)dealloc{
  [super dealloc];
//  [_tsView release];
  [asiDictiong release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.shareArray=[[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    _shareTypeArray = [[NSMutableArray alloc] initWithObjects:
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
                        nil],
                       nil];
  NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
  asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",@"http://apptest.mum360.com/web/home/index/createcomment",@"aUrl",@"pinglun",@"Controller", self.commentID,@"tid",nil];
  

  
  UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
  backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
  [self.view addSubview:backImageView];
  [backImageView release];
  
  UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
  navigation.backgroundColor=[UIColor blackColor];
  navigation.userInteractionEnabled=YES;
  navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
  [self.view addSubview:navigation];
  [navigation release];
  
  UIButton * leftBut=[UIButton buttonWithType:UIButtonTypeCustom];
  leftBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
  [leftBut addTarget:self action:@selector(clicked_leftBut) forControlEvents:UIControlEventTouchUpInside];
  [leftBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
  [navigation addSubview:leftBut];
  UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
  navigationLabel.backgroundColor=[UIColor clearColor];
  //    navigationLabel.font=[UIFont systemFontOfSize:22];
  navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
  navigationLabel.textAlignment=NSTextAlignmentCenter;
  navigationLabel.textColor=[UIColor whiteColor];
  navigationLabel.text=@"评论";
  [navigation addSubview:navigationLabel];
  [navigationLabel release];
  
  
  UIButton *rightBut=[UIButton buttonWithType:UIButtonTypeCustom];
  rightBut.frame=CGRectMake(Screen_Width-57, KUIOS_7(6), 52, 30.5);
  [rightBut addTarget:self action:@selector(RightMenth:) forControlEvents:UIControlEventTouchUpInside];
  [rightBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"004_钮" ofType:@"png"]] forState:UIControlStateNormal];
  [rightBut setTitle:@"发送" forState:UIControlStateNormal];
  [rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  rightBut.titleLabel.font = [UIFont boldSystemFontOfSize:11];
  
  [navigation addSubview:rightBut];

  
  
  imagebgView = [[[UIImageView alloc]initWithFrame:CGRectMake(5, KUIOS_7(50), Screen_Width-10, Screen_Height-70)] autorelease ];
  imagebgView.image = [UIImage imageNamed:@"001_22.png"];
  [self.view addSubview:imagebgView];
  
  sendIV = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_Width-70, Screen_Height-385, 50, 50)];
  [imagebgView addSubview:sendIV];
  [sendIV release];
  
  self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(5, KUIOS_7(50), Screen_Width-10, Screen_Height -350)] autorelease]; //初始化大小并自动释放
  self.textView.delegate = self;
  self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
  self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
  self.textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
  self.textView.scrollEnabled = YES;//是否可以拖动
  self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
  [self.textView becomeFirstResponder];
  [self.view addSubview: self.textView];//加入到整个页面中
  
  
  inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 220)];
  inputView.backgroundColor=[UIColor grayColor];
  emokeyView = [[EmoKeyboardView alloc]initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, inputView.frame.size.height)button:YES];
  emokeyView.delegate = self;
  emokeyView.OnEmoSelect = @selector(OnEmoSelect:);
  [inputView addSubview:emokeyView];
  [emokeyView release];
  
  
  _uitable = [[UITableView alloc]initWithFrame:emokeyView.frame style:UITableViewStylePlain];
  _uitable.dataSource = self;
  _uitable.delegate = self;
//  _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
  [inputView addSubview:_uitable];
  [_uitable release];

  
  UIView * AccessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
  AccessoryView.backgroundColor=[UIColor clearColor];
  [self.textView setInputAccessoryView:AccessoryView];
  [AccessoryView release];
  UIImageView * AccessoryImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
  AccessoryImageview.userInteractionEnabled=YES;
  AccessoryImageview.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jianpan8" ofType:@"png"]];
  [AccessoryView addSubview:AccessoryImageview];
  [AccessoryImageview release];
  for (int i=0; i<5; i++) {
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"fabiao%d",i] ofType:@"png"]] forState:UIControlStateNormal];
    if (ISIPAD) {
      button.frame=CGRectMake(150*i+50, 8, 60, 55);

    }else{
      button.frame=CGRectMake(64*i+15, 4, 25, 23);

    }
    button.tag=i;
    [button addTarget:self action:@selector(ButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
    [AccessoryView addSubview:button];
  }
  if (ISIPAD) {
    sendIV.frame = CGRectMake(Screen_Width-120, Screen_Height-585, 100, 120);
    AccessoryView.frame = CGRectMake(0, 0, Screen_Width, 70);
  }
  

  
  
//  _tsView = [TishiView tishiViewMenth];
//  [self.view addSubview:_tsView];
//  
  NSLog(@"cid   ==  %@",self.cID);

}

-(void)ButtonMenth:(UIButton*)but{

  if (but.tag<2) {
    PhotoSelectManager * mPhotoManager = [[PhotoSelectManager alloc] init];
    mPhotoManager.mRootCtrl = self;
    mPhotoManager.delegate = self;
      mPhotoManager.popoverController = self.uiPopoverController;
    mPhotoManager.mbEdit = NO;
    mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
    if (but.tag) {
      [mPhotoManager TakePhoto:NO];
    }
    else{
      [mPhotoManager TakePhoto:YES];
    }
  }else if (but.tag==2) {
    
    [UIView animateWithDuration:0.3 animations:^{
      imagebgView.frame = CGRectMake(5, imagebgView.frame.origin.y, Screen_Width-10, Screen_Height-70);
    }];
    _uitable.hidden = YES;
    emokeyView.hidden = NO;
    
    
    if (jianpanBool == NO) {
      jianpanBool = YES;
      [but setImage:[UIImage imageNamed:@"chattextback@2x.png"] forState:UIControlStateNormal];
      [self.textView resignFirstResponder];
      self.textView.inputView=inputView;
      [self.textView becomeFirstResponder];
    }else{
      [but setImage:[UIImage imageNamed:@"fabiao2.png"] forState:UIControlStateNormal];

      jianpanBool = NO;
      [self.textView resignFirstResponder];
      self.textView.inputView=nil;
      [self.textView becomeFirstResponder];
    }
  }else if(but.tag == 3){
    
    MBProgressHUD * plHUD = [[MBProgressHUD alloc] initWithView:_textView];
    [_textView addSubview:plHUD];
    
    plHUD.mode = MBProgressHUDModeCustomView;
    plHUD.labelText = @"评论无法使用标签";
    [plHUD showAnimated:YES whileExecutingBlock:^{
      sleep(1);
    } completionBlock:^{
      [plHUD removeFromSuperview];
      [plHUD release];
    }];

  
  }else{
    _uitable.hidden = NO;
    emokeyView.hidden = YES;

    
    if (shareBool == NO) {
      shareBool = YES;
//      [but setImage:[UIImage imageNamed:@"chattextback@2x.png"] forState:UIControlStateNormal];
      [self.textView resignFirstResponder];
      self.textView.inputView=inputView;
      [self.textView becomeFirstResponder];
    }else{
//      [but setImage:[UIImage imageNamed:@"fabiao2.png"] forState:UIControlStateNormal];
      shareBool = NO;
      [self.textView resignFirstResponder];
      self.textView.inputView=nil;
      [self.textView becomeFirstResponder];
    }

  
  }


}
- (void)ShareMenth
{
    for (int i=0; i<self.shareArray.count; i++) {
        int fenxiangType=1;
        if ([[self.shareArray objectAtIndex:i] intValue]==2) {
            fenxiangType=6;
        }
        else
        {
            fenxiangType=[[self.shareArray objectAtIndex:i] intValue]+1;
        }
        [Share SharecontentMenth:self.textView.text shareImagePath:[asiDictiong valueForKey:@"file"] biaoti:nil fenxiangleixing:fenxiangType];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryView) {
        cell.accessoryView=nil;
        [self.shareArray removeObject:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    else
    {
        
        
        NSInteger index = indexPath.row;
        if (index < [_shareTypeArray count])
        {
            NSMutableDictionary *item = [_shareTypeArray objectAtIndex:index];
            
            
            if (![ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]])
            {
                //用户用户信息
                ShareType type = [[item objectForKey:@"type"] integerValue];
                AGViewDelegate * _viewDelegate = [[AGViewDelegate alloc] init];
                
                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                     allowCallback:YES
                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                      viewDelegate:nil
                                                           authManagerViewDelegate:_viewDelegate];
                
                [ShareSDK getUserInfoWithType:type
                                  authOptions:authOptions
                                       result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                           if (result)
                                           {
                                               NSLog(@"fsdfsd");
                                               [item setObject:[userInfo nickname] forKey:@"username"];
                                               [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
                                           }
                                           NSLog(@"%d:%@",[error errorCode], [error errorDescription]);
                                           if ([ShareSDK hasAuthorizedWithType:[[item objectForKey:@"type"] integerValue]]) {
                                               
                                               
                                               [self.shareArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
                                               UIImageView * accessimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                                               accessimage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"]];
                                               cell.accessoryView=accessimage;
                                               [accessimage release];
                                           }
                                       }];
                [_viewDelegate release];
            }
            else
            {
                [self.shareArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
                UIImageView * accessimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                accessimage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"]];
                cell.accessoryView=accessimage;
                [accessimage release];
            }
        }
        
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pinglunCell"];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pinglunCell"] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  NSString *imageName = [NSString stringWithFormat:@"002_%d.png",indexPath.row +45];
  cell.imageView.image = [UIImage imageNamed:imageName];
  cell.textLabel.font = [UIFont systemFontOfSize:16];
  if (indexPath.row == 0) {
    cell.textLabel.text = @"新浪微博";

  }else if (indexPath.row == 1){
    cell.textLabel.text = @"腾讯微博";

  }else{
    cell.textLabel.text = @"QQ空间";

  }
  return cell;
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 17.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIImageView * headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 17.5)];
  headerImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"9" ofType:@"png"]];
  
  return [headerImageView autorelease];
}

- (void)OnEmoSelect:(NSString *)text {
  if (!_textView.text) {
    _textView.text = @"";
  }
  self.textView.text = [self.textView.text stringByAppendingString:text];
}

- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
  [asiDictiong setValue:[sender mLocalPath] forKey:@"file"];
  
  NSLog(@"dic  == %@",asiDictiong);
  sendIV.image=[UIImage imageWithContentsOfFile:[sender mLocalPath]];
}

-(void)RightMenth:(UIButton *)but{
  if ([self.textView.text isEqualToString:@""]) {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"内容不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
  }else{
    [self.textView resignFirstResponder];
    [self makeHUD];
      [self ShareMenth];
    if (self.cID == nil) {
      [asiDictiong setValue:self.textView.text forKey:@"text"];
      [asiDictiong setValue:@"1" forKey:@"type"];

      NSLog(@"dic  == %@",asiDictiong);
      [self analyUrl:asiDictiong];

    }else{
//    http://apptest.mum360.com/web/home/index/createcomment?uid=61&token=b5b00bec3f0871c719eaa8315a966ceb&tid=91&text=nidayea&type=1
      
      [asiDictiong setValue:self.textView.text forKey:@"text"];
      [asiDictiong setValue:@"2" forKey:@"type"];
      [asiDictiong setValue:self.cID forKey:@"cid"];
      
      NSLog(@"dic  == %@",asiDictiong);

      [self analyUrl:asiDictiong];

    }
    
  }
  
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
//  [_tsView StartMenth];
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[urlString valueForKey:@"Controller"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
  [self remHUD];
//  [_tsView StopMenth];
    NSDictionary * userDic = [array valueForKey:asi.ControllerName];
    
    NSString *msg=[NSString stringWithFormat:@"%@",userDic[@"code"]];
    NSLog(@"%@",userDic);
    
    if ([msg isEqualToString:@"1"]) {
      
        [self clicked_leftBut];
        
        [self.delegate sendComment:nil];
    }else {
      MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self.view];
      [self.view addSubview:eorrHUD];
      eorrHUD.mode = MBProgressHUDModeCustomView;
      eorrHUD.labelText = @"发送失败";
      [eorrHUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
      } completionBlock:^{
        [eorrHUD removeFromSuperview];
        [eorrHUD release];
      }];

    }

}


-(void)clicked_leftBut{
  if (analysis) {
    [analysis CancelMenthrequst];
  }
  [self.navigationController popViewControllerAnimated:YES];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self.textView resignFirstResponder];

}

- (void)textViewDidBeginEditing:(UITextView *)textView{

  
  
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  
  
  [UIView animateWithDuration:0.3 animations:^{
    
  }];
  return YES;
}

-(void)makeHUD{
  HUD= [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  HUD.dimBackground = YES;

  HUD.labelText = @"发送中..";
  [HUD show:YES];

}
-(void)remHUD{
  [HUD removeFromSuperview];
  [HUD release];
}

-(NSString*) urlEncode:(NSString*) unencodeString
{
  NSString *encodedString=[unencodeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  return encodedString;
  
}

@end
