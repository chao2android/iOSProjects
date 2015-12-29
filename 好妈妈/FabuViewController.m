//
//  FabuViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-25.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "FabuViewController.h"
#import "AsyncImageView.h"
#import "TishiView.h"
#import "NetImageView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoSelectManager.h"
#import "AutoAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
#import "Share.h"
#import "ShareView.h"
@interface FabuViewController ()

@end

@implementation FabuViewController
@synthesize biaotiTextField;
@synthesize contentTextView;
@synthesize oldDictionary;
@synthesize playImageView,tishiView;
@synthesize touxiangImageView,tableviewDic;
@synthesize shareArray;
- (void)dealloc
{
    [shareArray release];
//    [tableviewDic release];
    [touxiangImageView release];
    [tishiView release];
    [playImageView release];
    [oldDictionary release];
    [contentTextView release];
    [biaotiTextField release];
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
//    jianpanBool=NO;
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
	// Do any additional setup after loading the view.
    self.tableviewDic=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    [self.oldDictionary setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
    [self.oldDictionary setValue:[userDic valueForKey:@"token"] forKey:@"token"];
    NSLog(@"Screen_Width  %f  %f  %@",Screen_Width,Screen_Height,self.oldDictionary);
    backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.userInteractionEnabled=YES;
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(40))];
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
    navigationLabel.text=@"新话题";
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
    
    UILabel * biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (KUIOS_7(44))+15, 48, 18)];
    biaotiLabel.text=@"标题";
    biaotiLabel.textAlignment=UITextAlignmentRight;
    biaotiLabel.backgroundColor=[UIColor clearColor];
    [backImageView addSubview:biaotiLabel];
    [biaotiLabel release];
    UIImageView * textImageView=[[UIImageView alloc]initWithFrame:CGRectMake(biaotiLabel.frame.size.width+biaotiLabel.frame.origin.x+8, (KUIOS_7(44))+5, Screen_Width-biaotiLabel.frame.size.width-biaotiLabel.frame.origin.x-15, 35)];
    textImageView.userInteractionEnabled=YES;
    textImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
    [backImageView addSubview:textImageView];
    [textImageView release];
    self.biaotiTextField=[[[UITextField alloc]initWithFrame:CGRectMake(biaotiLabel.frame.size.width+biaotiLabel.frame.origin.x+13, (KUIOS_7(44))+5, Screen_Width-biaotiLabel.frame.size.width-biaotiLabel.frame.origin.x-21, 35)] autorelease];
    self.biaotiTextField.placeholder=@"请输入标题";
//    self.biaotiTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.biaotiTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.biaotiTextField.backgroundColor=[UIColor clearColor];
    [backImageView addSubview:self.biaotiTextField];
    
    self.touxiangImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 25+textImageView.frame.origin.y+textImageView.frame.size.height, 50, 50)] autorelease];
    if ([[userDic valueForKey:@"icon"] length]) {
        self.touxiangImageView.urlString=[userDic valueForKey:@"icon"];
    }
    else
    {
        self.touxiangImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认" ofType:@"png"]];

    }
    [backImageView addSubview:self.touxiangImageView];
    
    
    UIImageView * contentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(13+self.touxiangImageView.frame.size.width,20+textImageView.frame.origin.y+textImageView.frame.size.height, textImageView.frame.size.width,120)];
    contentImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"输入框" ofType:@"png"]];
    contentImageView.userInteractionEnabled=YES;
    [backImageView addSubview:contentImageView];
    [contentImageView release];
    
    self.contentTextView=[[[UITextView alloc]initWithFrame:CGRectMake(10, 5, contentImageView.frame.size.width-10, contentImageView.frame.size.height-10)] autorelease];
    self.contentTextView.backgroundColor=[UIColor clearColor];
    self.contentTextView.userInteractionEnabled=YES;
    self.contentTextView.delegate=self;
    self.contentTextView.font = [UIFont systemFontOfSize:18];
    [contentImageView addSubview:self.contentTextView];
    self.playImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(self.contentTextView.frame.size.width-35, self.contentTextView.frame.size.height-35, 35, 35)] autorelease];
    [self.contentTextView addSubview:self.playImageView];
    inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    inputView.backgroundColor=LIGHTBACK_COLOR;
    
//    emokeyView.OnSendClick = @selector(OnSendClick);
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UITextViewTextDidEndEditingNotification object:nil];
   
    UIView * AccessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    AccessoryView.backgroundColor=[UIColor clearColor];
    if (ISIPAD) {
        AccessoryView.frame=CGRectMake(0, 0, Screen_Width, 70);
    }
    [self.contentTextView setInputAccessoryView:AccessoryView];
    
    [AccessoryView release];
    UIImageView * AccessoryImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, -1, Screen_Width, 1)];
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
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
//    [[self.oldDictionary valueForKey:@"tag"] removeObjectAtIndex:0];
    [self.tableviewDic setValue:[self.oldDictionary valueForKey:@"tag"] forKey:@"tag"];
    NSMutableArray *tableviewArray=[[NSMutableArray alloc]initWithCapacity:1];
    for (int i=0; i<2; i++) {
        
        NSMutableDictionary * dic=[[NSMutableDictionary alloc]initWithCapacity:1];
        [dic setObject:[NSString stringWithFormat:@"002_%d",i+45] forKey:@"image"];
        if (i==0) {
            [dic setObject:@"新浪微博" forKey:@"title"];
            
        }
        else if (i==1)
        {
            [dic setObject:@"腾讯微博" forKey:@"title"];
            
        }
        else
        {
            [dic setObject:@"QQ空间" forKey:@"title"];
            
        }
       [tableviewArray addObject:dic];
        [dic release];
    }
    [self.tableviewDic setValue:tableviewArray forKey:@"share"];
    [tableviewArray release];
}

- (void)OnEmoSelect:(NSString *)text {
//    jianpanBool=NO;
    if (!contentTextView.text) {
        contentTextView.text = @"";
    }
    
    self.contentTextView.text = [self.contentTextView.text stringByAppendingString:text];
}
- (void)ButtonMenth:(UIButton *)sender
{
    if (sender.tag<2) {
        PhotoSelectManager * mPhotoManager = [[PhotoSelectManager alloc] init];
        mPhotoManager.mRootCtrl = self;
        mPhotoManager.delegate = self;
        mPhotoManager.mbEdit = NO;
        mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
        if (sender.tag) {
            [mPhotoManager TakePhoto:NO];
        }
        else
        {
            [mPhotoManager TakePhoto:YES];
        }
    }
    else
    {
//        jianpanBool=YES;
        NSLog(@"%@",inputView.subviews);
        if (inputView.subviews.count) {
            for (int i=0; i<inputView.subviews.count; i++) {
                [[inputView.subviews objectAtIndex:i] removeFromSuperview];
            }
        }
        if (sender.tag==2) {
            if (jianpanBool == NO) {
                jianpanBool = YES;
                [sender setImage:[UIImage imageNamed:@"chattextback@2x.png"] forState:UIControlStateNormal];
                emokeyView = [[EmoKeyboardView alloc]initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, inputView.frame.size.height)button:YES];
                emokeyView.delegate = self;
                emokeyView.OnEmoSelect = @selector(OnEmoSelect:);
                [inputView addSubview:emokeyView];
                [emokeyView release];
                
                [self.contentTextView resignFirstResponder];
                self.contentTextView.inputView=inputView;
                [self.contentTextView becomeFirstResponder];
            }else{
                [sender setImage:[UIImage imageNamed:@"fabiao2.png"] forState:UIControlStateNormal];
                jianpanBool = NO;
                [self.contentTextView resignFirstResponder];
                self.contentTextView.inputView=nil;
                [self.contentTextView becomeFirstResponder];
                
            }
        }
        else
        {
            tableviewselecell=0;
            tableviewBool=4-sender.tag;
            myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, inputView.frame.size.height)];
            myTableView.delegate=self;
            myTableView.dataSource=self;
            [inputView addSubview:myTableView];
            [myTableView release];
            myTableView.rowHeight=44;
            [self.contentTextView resignFirstResponder];
            self.contentTextView.inputView=inputView;
            [self.contentTextView becomeFirstResponder];
        }
       
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableviewBool) {
        
       UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryView)
        {
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
                    
                    if (ISIPAD&&type==2) {
                        [self.contentTextView resignFirstResponder];
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
                                                              
                                                               [self.contentTextView becomeFirstResponder];

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
                                
                            }
                        }];
                        if (![controller isSSOLogin]) {
                            aView=[controller view];
                            aView.frame=CGRectMake(0, 0, Screen_Width, Screen_Height);
                            [self.view addSubview:aView];
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
                            [back addTarget:self action:@selector(backup1) forControlEvents:UIControlEventTouchUpInside];
                            [navigation addSubview:back];
                        }

                    }
                    else
                    {
                    AGViewDelegate * _viewDelegate = [[AGViewDelegate alloc] init];
                    
                    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                         allowCallback:NO
                                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                          viewDelegate:nil
                                                               authManagerViewDelegate:_viewDelegate];
                    [authOptions setPowerByHidden:YES];
                    
                                    [ShareSDK getUserInfoWithType:type
                                      authOptions:authOptions
                                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                               if (result)
                                               {
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
    else
    {
    tableviewselecell=indexPath.row;
        [tableView reloadData];

    }
}
- (void)backup1
{
    [self.contentTextView becomeFirstResponder];
    [aView removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",self.tableviewDic);
    if (tableviewBool) {
        return [[self.tableviewDic valueForKey:@"tag"] count];
    }
    return [[self.tableviewDic valueForKey:@"share"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    
    if (tableviewBool) {
        
        if (indexPath.row==tableviewselecell) {
            UIImageView * accessimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            accessimage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"]];
            cell.accessoryView=accessimage;
            [accessimage release];
        }
        else
        {
            cell.accessoryView=nil;
        }
     
        cell.textLabel.text=[[self.tableviewDic valueForKey:@"tag"] objectAtIndex:indexPath.row];
        
    }
    else
    {
        for (int i=0; i<self.shareArray.count; i++) {
            if ([[self.shareArray objectAtIndex:i]intValue]==indexPath.row) {
                UIImageView * accessimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                accessimage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"]];
                cell.accessoryView=accessimage;
                [accessimage release];
            }
        }
        
        cell.imageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[[self.tableviewDic valueForKey:@"share"] objectAtIndex:indexPath.row] valueForKey:@"image"] ofType:@"png"]];
        cell.textLabel.text=[[[self.tableviewDic valueForKey:@"share"] objectAtIndex:indexPath.row] valueForKey:@"title"];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (ISIPAD) {
        return 30;
    }
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 17.5)];
    if (tableviewBool) {
        headerImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"6" ofType:@"png"]];
    }
    else
    {
        headerImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"9" ofType:@"png"]];
    }
    return [headerImageView autorelease];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
   
    [UIView animateWithDuration:0.3 animations:^{
        backImageView.frame=CGRectMake(0, -55, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
    return YES;
}
- (void)keyboardDidHide:(NSNotification*)notification {
//    self.contentTextView.inputView = inputView;
//    [self.contentTextView becomeFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
//    jianpanBool=YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
//    if (jianpanBool) {
//    [self.contentTextView resignFirstResponder];
//    [self.contentTextView becomeFirstResponder];
//    }

    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.contentTextView.inputView=nil;
}

- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    [self.oldDictionary setValue:[sender mLocalPath] forKey:@"file"];
    self.playImageView.image=[UIImage imageWithContentsOfFile:[sender mLocalPath]];
}

- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RightMenth
{
    if (!self.biaotiTextField.text.length)
    {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入标题"];
        return;
    }
    if (!self.contentTextView.text.length) {
        [AutoAlertView ShowAlert:@"温馨提示" message:@"请输入发布内容"];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        backImageView.frame=CGRectMake(0, 0, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
    
    [self ShareMenth];
//    jianpanBool=NO;
    [self.biaotiTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    
    [self.tishiView StartMenth];
    [self.oldDictionary setObject:self.biaotiTextField.text  forKey:@"title"];
    [self.oldDictionary setObject:self.contentTextView.text  forKey:@"text"];
    if ([[self.tableviewDic objectForKey:@"tag"]count]) {
        
    
    [self.oldDictionary setValue:[[self.tableviewDic objectForKey:@"tag"] objectAtIndex:tableviewselecell] forKey:@"tag"];

    }
   
    NSURL * aUrl=[[NSURL alloc]initWithString:@"http://apptest.mum360.com/web/home/index/createtheme"];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:@"fabuxinxiaoxi" delegate:self];
    [aUrl release];
    NSLog(@"%@",self.oldDictionary);
    [analysis PostMenth:self.oldDictionary];
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
       
        [Share SharecontentMenth:self.contentTextView.text shareImagePath:[self.oldDictionary valueForKey:@"file"] biaoti:self.biaotiTextField.text fenxiangleixing:fenxiangType];
        
    }
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [self.tishiView StopMenth];
    if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"zuixinAsihttpMenth" object:nil];
    }
    else
    {
        [AutoAlertView ShowAlert:@"温馨提示" message:[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]];
    }
    [asi release];
    analysis=nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [analysis CancelMenthrequst];
}
- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.3 animations:^{
        backImageView.frame=CGRectMake(0, 0, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        backImageView.frame=CGRectMake(0, 0, backImageView.frame.size.width, backImageView.frame.size.height);
    }];
//    jianpanBool=NO;
    [self.biaotiTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
