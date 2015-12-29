//
//  GerzxViewController.m
//  好妈妈
//
//  Created by iHope on 13-9-29.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "GerzxViewController.h"
#import "WanShangrzlViewController.h"
#import "TishiView.h"
#import "PhotoSelectManager.h"
#import "XiuGaibaobaoViewController.h"
@interface GerzxViewController ()

@end

@implementation GerzxViewController
@synthesize touxiangImageView;
@synthesize nichengLabel,qianmingLabel,diquLabel;
@synthesize xingbieLabel,xinxiLabel;
@synthesize oldDictionary,tishiView;
@synthesize shengriLabel;
- (void)dealloc
{
    [shengriLabel release];
    [tishiView release];
    [oldDictionary release];
    [nichengLabel release];
    [qianmingLabel release];
    [diquLabel release];
    [xinxiLabel release];
    [xingbieLabel release];
    [touxiangImageView release];
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
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",self.oldDictionary);
    [tableview reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.oldDictionary);
    
	// Do any additional setup after loading the view.
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
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"个人资料";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    
    rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    rightBut.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBut setTitle:@"编辑" forState:UIControlStateNormal];
    [navigation addSubview:rightBut];
    self.oldDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];
    [self.oldDictionary addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"]];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44-20)style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.backgroundView=nil;
    tableview.userInteractionEnabled=NO;
    tableview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableview];
    [tableview release];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    self.tishiView.titlelabel.text=@"加载中...";
}
- (void)RightMenth
{
    if ([rightBut.titleLabel.text isEqualToString:@"编辑"]) {
        tableview.userInteractionEnabled=YES;
        bianjiBool=YES;
        [rightBut setTitle:@"确定" forState:UIControlStateNormal];
    }
    else
    {
        bianjiBool=NO;
        tableview.userInteractionEnabled=NO;
        [rightBut setTitle:@"编辑" forState:UIControlStateNormal];
        [self.oldDictionary setValue:self.qianmingLabel.text forKey:@"sign"];
        [self.oldDictionary setValue:self.nichengLabel.text forKey:@"name"];
        [self.oldDictionary setValue:self.diquLabel.text forKey:@"city"];
        [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/updateuserinfo" forKey:@"aUrl"];
        [self.oldDictionary setValue:@"xiugaigeren" forKey:@"controllername"];
        [self QdMenth];
    }
    [tableview reloadData];
}


- (void)QdMenth
{
    
    //    for (int i=0; i<self.oldDictionary.allKeys.count; i++)
    //    {
    //        if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"birthday"])
    //        {
    //            [self.oldDictionary removeObjectForKey:@"birthday"];
    //            break;
    //        }
    //    }
    
    NSURL * aUrl=[[NSURL alloc]initWithString:[self.oldDictionary valueForKey:@"aUrl"]];
    [self.tishiView StartMenth];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:nil ControllerName:[self.oldDictionary valueForKey:@"controllername"] delegate:self];
    [aUrl release];
    [analysis PostMenth:self.oldDictionary];
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{
    NSLog(@"%@",[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]);
    if ([asi.ControllerName isEqualToString:@"xiugaigeren"]) {
        
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue])
        {
            [self.tishiView StopMenth];
            
            int tagg=0;
            for (int i=0; i<self.oldDictionary.allKeys.count; i++) {
                if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"mobile"]) {
                    tagg=1;
                }
            }
            if (tagg) {
                
                
                [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/login" forKey:@"aUrl"];
            }
            else
            {
                [self.oldDictionary setValue:@"http://apptest.mum360.com/web/home/index/openplatlogin" forKey:@"aUrl"];
                
            }
            [self.oldDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"TokenString"] forKey:@"devicetoken"];
            [self.oldDictionary setValue:@"denglu" forKey:@"controllername"];
            [self QdMenth];
        }
        else
        {
            [self.oldDictionary removeAllObjects];
            [self.oldDictionary addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"]];
            
            [tableview reloadData];
            self.tishiView.titlelabel.text=@"修改失败";
            [self performSelector:@selector(TuichuMenth) withObject:self afterDelay:2];
            
        }
    }
    else
    {
        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue]) {
            self.tishiView.titlelabel.text=@"修改成功";
            NSLog(@"%@",[array valueForKey:asi.ControllerName]);
            NSMutableDictionary * asiDiction=[[NSMutableDictionary alloc]initWithCapacity:1];
            NSMutableDictionary * dic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
            [asiDiction addEntriesFromDictionary:[array valueForKey:asi.ControllerName]];
            int tagg=0;
            for (int i=0; i<self.oldDictionary.allKeys.count; i++) {
                if ([[[self.oldDictionary allKeys] objectAtIndex:i] isEqualToString:@"mobile"]) {
                    tagg=1;
                }
            }
            if (tagg) {
                [asiDiction setValue:[dic valueForKey:@"mobile"] forKey:@"mobile"];
                [asiDiction setValue:[dic valueForKey:@"password"] forKey:@"password"];
            }
            else
            {
                [asiDiction setValue:[dic valueForKey:@"id"] forKey:@"id"];
                [asiDiction setValue:[dic valueForKey:@"type1"] forKey:@"type1"];
            }
            [asiDiction setValue:[dic valueForKey:@"lat"] forKey:@"lat"];
            [asiDiction setValue:[dic valueForKey:@"lng"] forKey:@"lng"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logindata"];
            [[NSUserDefaults standardUserDefaults] setValue:asiDiction forKey:@"logindata"];
            [asiDiction release];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            self.tishiView.titlelabel.text=@"修改失败";
        }
        [self performSelector:@selector(TuichuMenth) withObject:self afterDelay:2];
        
    }
    [asi release];
    analysis=nil;
}
- (void)TuichuMenth
{
    [self.tishiView StopMenth];
    [self backup];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        if (ISIPAD) {
            return 80*1.4;
        }
        return 85;
    }
    if (ISIPAD) {
        return 44*1.4;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"1"]) {
            return 3;
        }
        else if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"2"])
        {
            return 2;
        }
        return 1;
    }
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section)
    {
        if (indexPath.row==1)
        {
            if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"1"]) {
                
                cell.textLabel.text=@"宝宝性别";
                if (self.xingbieLabel)
                {
                    [self.xingbieLabel removeFromSuperview];
                    self.xingbieLabel=nil;
                }
                self.xingbieLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
                if ([[self.oldDictionary valueForKey:@"babysex"] intValue]==1)
                {
                    self.xingbieLabel.text=@"男宝宝";
                }
                else if ([[self.oldDictionary valueForKey:@"babysex"] intValue]==0)
                {
                    self.xingbieLabel.text=@"女宝宝";
                }
                else
                {
                    self.xingbieLabel.text=@"";
                }
                self.xingbieLabel.font=[UIFont systemFontOfSize:15];
                //                if (ISIPAD) {
                //                    self.xingbieLabel.font=[UIFont systemFontOfSize:15*1.5];
                //
                //                }
                self.xingbieLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:self.xingbieLabel];
            }
            else
            {
                if (self.xingbieLabel) {
                    [self.xingbieLabel removeFromSuperview];
                    self.xingbieLabel=nil;
                }
                self.xingbieLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
                
                cell.textLabel.text=@"预产期";
                self.xingbieLabel.text=[self.oldDictionary valueForKey:@"birthday"];
                self.xingbieLabel.font=[UIFont systemFontOfSize:15];
                self.xingbieLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:self.xingbieLabel];
            }
        }
        else if (indexPath.row==2)
        {
            
            NSLog(@"%@",self.oldDictionary);
            if (self.shengriLabel) {
                [self.shengriLabel removeFromSuperview];
                self.shengriLabel=nil;
            }
            self.shengriLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
            
            cell.textLabel.text=@"宝宝生日";
            
            self.shengriLabel.text=[self.oldDictionary valueForKey:@"birthday"];
            self.shengriLabel.font=[UIFont systemFontOfSize:15];
            self.shengriLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:self.shengriLabel];
            
        }
        else
        {
            if (self.xinxiLabel)
            {
                [self.xinxiLabel removeFromSuperview];
                self.xinxiLabel=nil;
            }
            cell.textLabel.text=@"宝宝信息";
            self.xinxiLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
            if ([[self.oldDictionary valueForKey:@"type"] intValue]==1) {
                self.xinxiLabel.text=@"已有宝宝";
            }
            else if ([[self.oldDictionary valueForKey:@"type"] intValue]==2) {
                self.xinxiLabel.text=@"准妈妈";
            }
            else
            {
                self.xinxiLabel.text=@"备孕中";
                
            }
            self.xinxiLabel.font=[UIFont systemFontOfSize:15];
            self.xinxiLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:self.xinxiLabel];
        }
    }
    else
    {
        if (indexPath.row==1) {
            cell.textLabel.text=@"昵称";
            if (self.nichengLabel) {
                [self.nichengLabel removeFromSuperview];
                self.nichengLabel=nil;
            }
            self.nichengLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
            self.nichengLabel.text=[self.oldDictionary valueForKey:@"name"];
            self.nichengLabel.font=[UIFont systemFontOfSize:15];
            self.nichengLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:self.nichengLabel];
        }
        else if (indexPath.row==2)
        {
            cell.textLabel.text=@"签名";
            if (self.qianmingLabel ) {
                [self.qianmingLabel removeFromSuperview];
                self.qianmingLabel=nil;
            }
            self.qianmingLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
            self.qianmingLabel.text=[self.oldDictionary valueForKey:@"sign"];
            
            self.qianmingLabel.font=[UIFont systemFontOfSize:15];
            self.qianmingLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:self.qianmingLabel];
        }
        else if (indexPath.row==3)
        {
            cell.textLabel.text=@"地区";
            if (self.diquLabel) {
                [self.diquLabel removeFromSuperview];
                self.diquLabel=nil;
            }
            self.diquLabel=[[[UILabel alloc]initWithFrame:CGRectMake(95, 11, Screen_Width-130, 20)] autorelease];
            self.diquLabel.text=[self.oldDictionary valueForKey:@"city"];
            self.diquLabel.font=[UIFont systemFontOfSize:15];
            self.diquLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:self.diquLabel];
        }
        else
        {
            cell.textLabel.text=@"头像";
            if (self.touxiangImageView) {
                [self.touxiangImageView removeFromSuperview];
                self.touxiangImageView=nil;
            }
            self.touxiangImageView=[[[AsyncImageView alloc]initWithFrame:CGRectMake(Screen_Width-110, 5, 75, 75)] autorelease];
            self.touxiangImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"聊天_3" ofType:@"png"]]];
            
            [self.touxiangImageView addTarget:self action:@selector(PictureMenth) forControlEvents:UIControlEventTouchUpInside];
            if ([[self.oldDictionary valueForKey:@"file"] length]) {
                self.touxiangImageView.image=[UIImage imageWithContentsOfFile:[self.oldDictionary valueForKey:@"file"]];
                
            }
            else
            {
                
                self.touxiangImageView.urlString=[self.oldDictionary valueForKey:@"icon"];
            }
            [cell.contentView addSubview:self.touxiangImageView];
        }
    }
    if (bianjiBool) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    if (ISIPAD) {
        
        cell.textLabel.font=[UIFont systemFontOfSize:18*1.4];
        self.touxiangImageView.frame=CGRectMake(Screen_Width-140*1.4, 5*1.4, 70*1.4, 70*1.4);
        self.touxiangImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"默认105" ofType:@"png"]]];
        
        self.nichengLabel.frame=CGRectMake(95*1.4, 11*1.4, Screen_Width-180*1.4, 20*1.4);
        self.qianmingLabel.frame=CGRectMake(95*1.4, 11*1.4, Screen_Width-180*1.4, 20*1.4);
        self.diquLabel.frame=CGRectMake(95*1.4, 11*1.4, Screen_Width-180*1.4, 20*1.4);
        self.nichengLabel.font=[UIFont systemFontOfSize:15*1.4];
        self.qianmingLabel.font=[UIFont systemFontOfSize:15*1.4];
        self.diquLabel.font=[UIFont systemFontOfSize:15*1.4];
        
        self.xinxiLabel.frame=CGRectMake(95*1.4, 11*1.4, Screen_Width-180*1.4, 20*1.4);
        self.xinxiLabel.font=[UIFont systemFontOfSize:15*1.4];
        self.xingbieLabel.frame=CGRectMake(95*1.4, 11*1.4, Screen_Width-180*1.4, 20*1.4);
        self.xingbieLabel.font=[UIFont systemFontOfSize:15*1.4];
        self.shengriLabel.frame=CGRectMake(95*1.4, 11*1.4, Screen_Width-180*1.4, 20*1.4);
        self.shengriLabel.font=[UIFont systemFontOfSize:15*1.4];
        
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        if (indexPath.section==0) {
            WanShangrzlViewController * wsgrzl=[[WanShangrzlViewController alloc]init];
            wsgrzl.temp=self;
            if (indexPath.row==1) {
                wsgrzl.titleString=[NSString stringWithFormat:@"修改昵称*)*)%@",self.nichengLabel.text];
            }else if (indexPath.row==2)
            {
                wsgrzl.titleString=[NSString stringWithFormat:@"个性签名*)*)%@",self.qianmingLabel.text];
                
            }
            else
            {
                wsgrzl.titleString=[NSString stringWithFormat:@"修改地区*)*)%@",self.diquLabel.text];
            }
            [self.navigationController pushViewController:wsgrzl animated:YES];
            [wsgrzl release];
        }
        else
        {
            XiuGaibaobaoViewController * xiugai=[[XiuGaibaobaoViewController alloc]init];
            xiugai.oldDictionary=self.oldDictionary;
            xiugai.temp=self;
            [self.navigationController pushViewController:xiugai animated:YES];
            [xiugai release];
        }
    }
    else
    {
        if (indexPath.section) {
            XiuGaibaobaoViewController * xiugai=[[XiuGaibaobaoViewController alloc]init];
            xiugai.oldDictionary=self.oldDictionary;
            xiugai.temp=self;
            [self.navigationController pushViewController:xiugai animated:YES];
            [xiugai release];
        }
        else
        {
            [self PictureMenth];
        }
        
    }
}
- (void)PictureMenth
{
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:@"请选择照相来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选取", nil];
    actionSheet.tag=3;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    [self.oldDictionary setValue:[sender mLocalPath] forKey:@"file"];
    self.touxiangImageView.image=[UIImage imageWithContentsOfFile:[sender mLocalPath]];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=2) {
        PhotoSelectManager * mPhotoManager = [[PhotoSelectManager alloc] init];
        mPhotoManager.mRootCtrl = self;
        mPhotoManager.delegate = self;
        mPhotoManager.mbEdit = YES;
        mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
        if (buttonIndex) {
            [mPhotoManager TakePhoto:NO];
        }
        else
        {
            [mPhotoManager TakePhoto:YES];
        }
        
    }
    
    
    [tableview reloadData];
}


- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
