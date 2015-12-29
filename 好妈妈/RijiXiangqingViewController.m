//
//  RijiXiangqingViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-23.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "RijiXiangqingViewController.h"
#import "TishiView.h"
#import "ShangChuanViewController.h"
#import "PinglunbiaoViewController.h"
@interface RijiXiangqingViewController ()

@end

@implementation RijiXiangqingViewController
@synthesize oldDictionary;
@synthesize dataArray;
@synthesize viewArray;
- (void)dealloc
{
    [viewArray release];
    [dataArray release];
    [oldDictionary release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tishiView=[TishiView tishiViewMenth];
        [self.view addSubview:_tishiView];
        self.viewArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];

               self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
   
    [self.viewArray removeAllObjects];
    [dataArray removeAllObjects];
    [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.oldDictionary setValue:@"weirijixiangqing" forKey:@"name"];
    [self analyUrl:self.oldDictionary];

}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
         analysis=nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    UIButton* rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 45, 30.5);
    
    [rightBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"003_1" ofType:@"png"]] forState:UIControlStateNormal];
        [navigation addSubview:rightBut];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"微日记";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UILongPressGestureRecognizer * longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(TapGestureMenth)];
    [rightBut addGestureRecognizer:longpress];
    [longpress release];
    
    UITapGestureRecognizer * tapges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressGestureMenth)];
    [rightBut addGestureRecognizer:tapges];
    [tapges release];
  
    
	// Do any additional setup after loading the view.
}
- (void)backup
{
    [self dismissModalViewControllerAnimated:NO];
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    [_tishiView StartMenth];
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:[urlString valueForKey:@"name"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    [_tishiView StopMenth];
    if ([asi.ControllerName isEqualToString:@"weirijixiangqing"])
    {
        if ([[array valueForKey:asi.ControllerName] count])
        {
            
        
    [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
        }
        
    if (mainScrollView) {
        [mainScrollView removeFromSuperview];
        mainScrollView=nil;
    }
    if (mainScrollView==nil) {
        mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44)];
        mainScrollView.pagingEnabled=YES;
        mainScrollView.showsHorizontalScrollIndicator=YES;
        mainScrollView.backgroundColor=[UIColor clearColor];
        [mainScrollView setContentSize:CGSizeMake(self.dataArray.count*mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
        mainScrollView.userInteractionEnabled=YES;
        [self.view addSubview:mainScrollView];
        _tishiView=[TishiView tishiViewMenth];
        [self.view addSubview:_tishiView];
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];

        for (int i=0; i<self.dataArray.count; i++)
        {
            UIView * jieshaoView=[[UIView alloc]initWithFrame:CGRectMake(mainScrollView.frame.size.width*i+5, 300, Screen_Width, 25)];
            jieshaoView.backgroundColor=[UIColor clearColor];
            
            for (int j=0; j<4; j++) {
                AsyncImageView * butImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(60*j, 5, 20, 18)];
                butImageView.tag=j;
                [butImageView addTarget:self action:@selector(ButImageViewMenth:) forControlEvents:UIControlEventTouchUpInside];
                butImageView.userInteractionEnabled=YES;
                if (j==0) {
                    if ([[[self.dataArray objectAtIndex:i] valueForKey:@"flag"] intValue])
                    {
                        butImageView.opaque=YES;
                        butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_27_" ofType:@"png"]];

                    }
                    else
                    {
                        butImageView.opaque=NO;
                    butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_27" ofType:@"png"]];
                    }
                    UILabel * zhanLabel=[[UILabel alloc]initWithFrame:CGRectMake(butImageView.frame.size.width+butImageView.frame.origin.x+2, butImageView.frame.origin.y, 41,15)];
                    zhanLabel.font=[UIFont systemFontOfSize:9];
                    zhanLabel.text=[[self.dataArray objectAtIndex:i] valueForKey:@"approvalnum"];
                    zhanLabel.backgroundColor=[UIColor clearColor];
                    [jieshaoView addSubview:zhanLabel];
                    [zhanLabel release];
                }
                else if (j==1)
                {
                    butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_20" ofType:@"png"]];
                    UILabel * zhanLabel=[[UILabel alloc]initWithFrame:CGRectMake(butImageView.frame.size.width+butImageView.frame.origin.x+2, butImageView.frame.origin.y, 41,15)];
                    zhanLabel.font=[UIFont systemFontOfSize:9];
                    zhanLabel.text=[[self.dataArray objectAtIndex:i] valueForKey:@"commentnum"];
                    zhanLabel.backgroundColor=[UIColor clearColor];
                    [jieshaoView addSubview:zhanLabel];
                    [zhanLabel release];

                }
                else if (j==2)
                {
                    if ([[userDic valueForKey:@"uid"] isEqualToString:[[self.dataArray objectAtIndex:i] valueForKey:@"uid"]]) {
                        butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"编辑" ofType:@"png"]];
                    }
                    else
                    {
                        butImageView.hidden=YES;
                    }
                    

                }
                else
                {
                    if ([[userDic valueForKey:@"uid"] isEqualToString:[[self.dataArray objectAtIndex:i] valueForKey:@"uid"]]) {
                        butImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"23" ofType:@"png"]];
                    }
                    else
                    {
                        butImageView.hidden=YES;
                    }


                }
                [jieshaoView addSubview:butImageView];
                [butImageView release];

            }
            [mainScrollView addSubview:jieshaoView];
            [self.viewArray addObject:jieshaoView];
            [jieshaoView release];
         AsyncImageView *   touxiangIamgeView=[[AsyncImageView alloc]initWithFrame:CGRectMake(mainScrollView.frame.size.width*i+5, 5, 60, 60)];
            if ([[[self.dataArray objectAtIndex:i] valueForKey:@"icon"] length])
            {
                touxiangIamgeView.urlString=[[self.dataArray objectAtIndex:i] valueForKey:@"icon"];
            }
            else
            {
            touxiangIamgeView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认" ofType:@"png"]];
            }
            [mainScrollView addSubview:touxiangIamgeView];
            [touxiangIamgeView release];
           UILabel  * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(mainScrollView.frame.size.width*i+80, 15, Screen_Width-100, 20)];
            titleLabel.text=[[self.dataArray objectAtIndex:i] valueForKey:@"name"];
            titleLabel.backgroundColor=[UIColor clearColor];
            [mainScrollView addSubview:titleLabel];
            [titleLabel release];
            if ([[[self.dataArray objectAtIndex:i] valueForKey:@"image"] length]) {
                
                UIImageView * backIm=[[UIImageView alloc]initWithFrame:CGRectMake(i*mainScrollView.frame.size.width+20, touxiangIamgeView.frame.size.height+touxiangIamgeView.frame.origin.y+15, Screen_Width-40, Screen_Height-180)];
                backIm.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"110@2x" ofType:@"png"]];
                [mainScrollView addSubview:backIm];
                [backIm release];
                
                CGFloat wid = [[[self.dataArray objectAtIndex:i] valueForKey:@"width"] intValue];;
                CGFloat hei = [[[self.dataArray objectAtIndex:i] valueForKey:@"height"] intValue];
                
                if (hei >backIm.frame.size.height-105) {
                    wid = (backIm.frame.size.height-105) *wid/hei;
                    hei = backIm.frame.size.height-105;
                }
                
                if (wid > backIm.frame.size.width-30) {
                    hei = (backIm.frame.size.width-30)*hei/wid;
                    wid = backIm.frame.size.width-30;
                }
                
                if (hei<backIm.frame.size.height-105&&wid < backIm.frame.size.width-30) {
                    if (wid>hei) {
                        hei = (backIm.frame.size.width-30)*hei/wid;
                        wid = backIm.frame.size.width-30;
                    }
                    else
                    {
                    wid = (backIm.frame.size.height-105) *wid/hei;
                    hei = backIm.frame.size.height-105;
                    }
                }




                AsyncImageView * backImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake((backIm.frame.size.width-wid)/2,15, wid, hei)];
                backImageView.urlString=[[self.dataArray objectAtIndex:i] valueForKey:@"image"];
                [backIm addSubview:backImageView];
                [backImageView release];
                UITextView * contentView=[[UITextView alloc]initWithFrame:CGRectMake(backImageView.frame.origin.x, backImageView.frame.size.height+backImageView.frame.origin.y+5,backImageView.frame.size.width, backIm.frame.size.height-backImageView.frame.size.height-backImageView.frame.origin.y-10)];
                contentView.backgroundColor=[UIColor clearColor];
                contentView.text=[[self.dataArray objectAtIndex:i] valueForKey:@"text"];
                contentView.userInteractionEnabled=NO;
                [backIm addSubview:contentView];
                [contentView release];
                jieshaoView.frame=CGRectMake(mainScrollView.frame.size.width*i+10, backIm.frame.size.height+backIm.frame.origin.y+5, jieshaoView.frame.size.width, 20);
                
            }
            else
            {
                
                UIImageView * textImageView=[[UIImageView alloc]initWithFrame:CGRectMake(mainScrollView.frame.size.width*i+15, touxiangIamgeView.frame.size.height+touxiangIamgeView.frame.origin.y+15, Screen_Width-30, 280)];
                
                textImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]];
                textImageView.userInteractionEnabled=YES;
                [mainScrollView addSubview:textImageView];
                [textImageView release];
                
                UITextView * shoujihaoTextfield=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, Screen_Width-40, textImageView.frame.size.height-10)];
                [textImageView addSubview:shoujihaoTextfield];
                [shoujihaoTextfield release];
                shoujihaoTextfield.text=[[self.dataArray objectAtIndex:i] valueForKey:@"text"];
                shoujihaoTextfield.backgroundColor=[UIColor clearColor];
                shoujihaoTextfield.editable=NO;
                shoujihaoTextfield.userInteractionEnabled=NO;
                jieshaoView.frame=CGRectMake(mainScrollView.frame.size.width*i+10, textImageView.frame.size.height+textImageView.frame.origin.y+10, jieshaoView.frame.size.width, 20);

            }
           
        }
    }
        if (![[array valueForKey:asi.ControllerName] count])
        {
            [self backup];
        }
    }
    else if ([asi.ControllerName isEqualToString:@"shanchuweirijixiangqing"])
    {
        [self.dataArray removeAllObjects];
        [self.oldDictionary setValue:[self.oldDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
        [self.oldDictionary setValue:@"weirijixiangqing" forKey:@"name"];
        [self analyUrl:self.oldDictionary];

    }
    else
    {
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
            int countNnm=mainScrollView.contentOffset.x/mainScrollView.frame.size.width;

            AsyncImageView * asyImage=[[[viewArray  objectAtIndex:countNnm] subviews] objectAtIndex:1];
            UILabel * label=[[[viewArray  objectAtIndex:countNnm] subviews] objectAtIndex:0];
            if ([asi.ControllerName isEqualToString:@"zan"]) {
                asyImage.opaque=YES;
                asyImage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_27_" ofType:@"png"]];
                label.text=[NSString stringWithFormat:@"%d",[label.text intValue]+1];
            }
            else
            {
                asyImage.opaque=NO;
                asyImage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"002_27" ofType:@"png"]];
                label.text=[NSString stringWithFormat:@"%d",[label.text intValue]-1];

            }
        }

    }
    [asi release];
    analysis=nil;
}
- (void)ButImageViewMenth:(AsyncImageView *)sender
{
    int countNnm=mainScrollView.contentOffset.x/mainScrollView.frame.size.width;

    if (sender.tag==2) {
        if ([[[self.dataArray objectAtIndex:countNnm] valueForKey:@"image"] length]) {
            NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表图片",@"title", nil];
            [asiDiction setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"text"] forKey:@"text"];
            
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            AsyncImageView * backImageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(30, 10, 60,60)];
            backImageView.urlString=[[self.dataArray objectAtIndex:countNnm] valueForKey:@"image"];
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/test123.png",docDir];
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(backImageView.image)];
            [backImageView release];

            [data1 writeToFile:pngFilePath atomically:YES];
            [asiDiction setValue:pngFilePath forKey:@"file"];
            [asiDiction setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"id"] forKey:@"id"];
            [asiDiction setValue:@"http://apptest.mum360.com/web/home/index/updatetopic" forKey:@"aUrl"];
            [asiDiction setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"private"] forKey:@"private"];


            [self ShangChuanMenth:asiDiction];
            [asiDiction release];
        }
        else
        {
            NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表文字",@"title", nil];
            [asiDiction setValue:@"http://apptest.mum360.com/web/home/index/updatetopic" forKey:@"aUrl"];
            [asiDiction setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"text"] forKey:@"text"];
            [asiDiction setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"id"] forKey:@"id"];
            [asiDiction setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"private"] forKey:@"private"];

            [self ShangChuanMenth:asiDiction];
            [asiDiction release];
        }

    }
    else if (sender.tag==3)
    {
        [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletetopic" forKey:@"aUrl"];
        [self.oldDictionary setValue:@"shanchuweirijixiangqing" forKey:@"name"];
        [self.oldDictionary setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"id"] forKey:@"id"];
        
        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"删除微日记将扣除5个积分，您确定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertview show];
        [alertview release];

    }
    else if (sender.tag==0)
    {
        if (sender.opaque) {
            [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/deleteapproval" forKey:@"aUrl"];
            [self.oldDictionary setValue:@"quxiaozan" forKey:@"name"];
        }
        else
        {
            [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/createapproval" forKey:@"aUrl"];
            [self.oldDictionary setValue:@"zan" forKey:@"name"];
        }
        
        [self.oldDictionary setValue:@"5" forKey:@"type"];
        [self.oldDictionary setValue:[[self.dataArray objectAtIndex:countNnm] valueForKey:@"id"] forKey:@"tid"];
        [self analyUrl:self.oldDictionary];
    }
    else
    {
       
        NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];

        NSMutableDictionary * asiDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid", [userDic valueForKey:@"token"],@"token",[[self.dataArray objectAtIndex:countNnm] valueForKey:@"id"],@"id", @"15",@"limit",nil];
        PinglunbiaoViewController * pinglunbiao=[[PinglunbiaoViewController alloc]init];

        UINavigationController * naviagtion=[[UINavigationController alloc]initWithRootViewController:pinglunbiao];
        pinglunbiao.oldDictionary=asiDic;
        [asiDic release];
        [self presentModalViewController:naviagtion animated:YES];
        [pinglunbiao release];
        [naviagtion release];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self analyUrl:self.oldDictionary];

    }
}
- (void)ShangChuanMenth:(NSMutableDictionary *)sender
{
    ShangChuanViewController * shangchuan=[[ShangChuanViewController alloc]init];
    shangchuan.oldDictionary=sender;
    [self presentModalViewController:shangchuan animated:NO];
    [shangchuan release];
}
- (void)LongPressGestureMenth
{

    NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表图片",@"title", nil];
    [asiDiction setObject:[self.oldDictionary valueForKey:@"date"] forKey:@"date"];

    [asiDiction setValue:@"http://apptest.mum360.com/web/home/index/createtopic" forKey:@"aUrl"];

    [self ShangChuanMenth:asiDiction];
    [asiDiction release];
}
- (void)TapGestureMenth
{
    
    NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"发表文字",@"title", nil];
    [asiDiction setObject:[self.oldDictionary valueForKey:@"date"] forKey:@"date"];
    [asiDiction setValue:@"http://apptest.mum360.com/web/home/index/createtopic" forKey:@"aUrl"];
    [self ShangChuanMenth:asiDiction];
    [asiDiction release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
