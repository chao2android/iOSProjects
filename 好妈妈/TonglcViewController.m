//
//  TonglcViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "TonglcViewController.h"
#import "QzcyCell.h"
#import "WoViewController.h"

@interface TonglcViewController ()

@end

@implementation TonglcViewController
@synthesize oldDictionary;
@synthesize dataArray;
@synthesize tishiView;
@synthesize dataDictionary;
@synthesize myPickerView;
- (void)dealloc
{
    [myPickerView release];
    [dataDictionary release];
    [dataArray release];
    [tishiView release];
    [oldDictionary release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataDictionary=[[[NSMutableDictionary alloc]initWithCapacity:1] autorelease];

        // Custom initialization
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation

{
    [manager stopUpdatingLocation];
    // 取得经纬度
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CLLocationDegrees latitude = coordinate.latitude;
    CLLocationDegrees longitude = coordinate.longitude;
    // 取得精度
    //    CLLocationAccuracy horizontal = newLocation.horizontalAccuracy;
    //    CLLocationAccuracy vertical = newLocation.verticalAccuracy;
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%lf",latitude] forKey:@"lat"];
    [self.oldDictionary setValue:[NSString stringWithFormat:@"%lf",longitude] forKey:@"lng"];
    [self RequstMenth];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error domain] == kCLErrorDomain)
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，不知道您的位置，无法提供服务。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag=1;
        [alertView show];
        [alertView release];
//        [AutoAlertView ShowAlert:@"温馨提示" message:@"亲，不知道您的位置，无法提供服务。"];
    }
}
- (void)RequstMenth
{
    [self.dataArray removeAllObjects];
    self.tishiView=[TishiView tishiViewMenth];
    [self.view addSubview:self.tishiView];
    page=1;
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    [self.dataDictionary setValue:[userDic valueForKey:@"uid"] forKey:@"uid"];
    [self.dataDictionary setValue:[userDic valueForKey:@"token"] forKey:@"token"];
    [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"type"] forKey:@"type"];
    [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"lat"] forKey:@"lat"];
    [self.dataDictionary setValue:[self.oldDictionary valueForKey:@"lng"] forKey:@"lng"];
    [self.dataDictionary setValue:@"15" forKey:@"limit"];
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/babyage" forKey:@"aUrl1"];
    [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/babyage" forKey:@"aUrl"];
    [self.dataDictionary setValue:@"tongbabyage" forKey:@"contreName"];
    if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"1"])
    {
        [self.dataDictionary setValue:@"1" forKey:@"style"];
        [self analyUrl:self.dataDictionary];
        
    }
    else
    {
        [self.dataDictionary setValue:@"20000" forKey:@"distance"];
        [self.dataDictionary setValue:@"4" forKey:@"age"];
        [self analyUrl:self.dataDictionary];
        
    }
}
- (void)LocationMenth
{

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    // 接收事件的实例
    locationManager.delegate = self;
    // 发生事件的的最小距离间隔（缺省是不指定）
    locationManager.distanceFilter = kCLDistanceFilterNone;
    // 精度 (缺省是Best)
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 开始测量
    [locationManager startUpdatingLocation];

}
- (void)viewWillAppear:(BOOL)animated
{
    if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"2"]) {
        [self LocationMenth];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
  

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page=1;
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
    navigationLabel.text=[self.oldDictionary valueForKey:@"Title"];
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
    rightBut.titleLabel.font=[UIFont systemFontOfSize:14];
    [navigation addSubview:rightBut];
    self.dataArray=[[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-20-44) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable .reachedTheEnd  = NO;
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    _uitable.rowHeight=71.5;
    if (ISIPAD) {
        _uitable.rowHeight=71.5*1.4;
    }
    if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"1"])
    {
        [self RequstMenth];
        butBool=NO;
        [rightBut setTitle:@"按远近" forState:UIControlStateNormal];
        [rightBut addTarget:self action:@selector(RightMenth:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        
        [rightBut setTitle:@"找朋友" forState:UIControlStateNormal];
        [rightBut addTarget:self action:@selector(RightMenth1) forControlEvents:UIControlEventTouchUpInside];
    }

    self.myPickerView=[[[UIPickerView alloc]initWithFrame:CGRectMake(30, Screen_Height+50, Screen_Width-60, 100)] autorelease];
    self.myPickerView.backgroundColor=[UIColor whiteColor];
    self.myPickerView.delegate=self;
    self.myPickerView.dataSource=self;
    self.myPickerView.showsSelectionIndicator=YES;
    self.myPickerView.userInteractionEnabled=YES;
    [self.view addSubview:self.myPickerView];
    
    pickerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.myPickerView.frame.origin.x, self.myPickerView.frame.origin.y-35, self.myPickerView.frame.size.width, 35)];
    pickerImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"弹出 条" ofType:@"png"]];
    pickerImageView.userInteractionEnabled=YES;
    [self.view addSubview:pickerImageView];
    [pickerImageView release];
    for (int i=0; i<2; i++) {
        UIButton * pickerBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [pickerBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
        if (i==0) {
            [pickerBut setTitle:@"取消" forState:UIControlStateNormal];
        }
        else
        {
            [pickerBut setTitle:@"确定" forState:UIControlStateNormal];
        }
        pickerBut.tag=i;
        pickerBut.titleLabel.font=[UIFont systemFontOfSize:14];
        [pickerBut addTarget:self action:@selector(PickerMenth:) forControlEvents:UIControlEventTouchUpInside];
        pickerBut.frame=CGRectMake(15+i*(pickerImageView.frame.size.width-47-25), 2.5, 47, 30);
        [pickerImageView addSubview:pickerBut];

    }
    
}
- (void)PickerMenth:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myPickerView.frame=CGRectMake(30, Screen_Height+50, Screen_Width-60, 100);
        pickerImageView.frame=CGRectMake(self.myPickerView.frame.origin.x, self.myPickerView.frame.origin.y-35, self.myPickerView.frame.size.width, 35);

    }];
    _uitable.userInteractionEnabled=YES;

    if (sender.tag) {
        [_uitable setContentOffset:CGPointMake(0, 0)];
        [self.dataArray removeAllObjects];
        page=1;
        [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        _uitable .reachedTheEnd  = NO;
        [self analyUrl:self.dataDictionary];

    }
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.myPickerView reloadAllComponents];
    NSString * rowString=nil;
    if ([self.myPickerView selectedRowInComponent:0]==0) {
        rowString=@"100";
    }
    else if ([self.myPickerView selectedRowInComponent:0]==1)
    {
        rowString=@"500";
    }else if ([self.myPickerView selectedRowInComponent:0]==2)
    {
        rowString=@"1000";
    }else if ([self.myPickerView selectedRowInComponent:0]==3)
    {
        rowString=@"3000";
    }else
    {
        rowString=@"5000";
    }

    [self.dataDictionary setValue:rowString forKey:@"distance"];
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",[self.myPickerView selectedRowInComponent:1]] forKey:@"age"];
}
-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    int fontSize = 20;
    CGRect rect = CGRectMake(0.0, 0.0, 100, 30);
    UILabel *myView = [[[UILabel alloc] initWithFrame:rect] autorelease];
    myView.textAlignment = UITextAlignmentCenter;
    myView.font = [UIFont boldSystemFontOfSize:fontSize];
    if (component==0&&row==[pickerView selectedRowInComponent:0]) {
        myView.textColor = [UIColor redColor];
    }
    else if (component==1&&row==[pickerView selectedRowInComponent:1])
    {
        myView.textColor=[UIColor redColor];
    }
    
    myView.backgroundColor = [UIColor clearColor];
    if (component==0) {
        NSString * rowStrig=nil;
        if (row==0) {
            rowStrig=@"100m";
        }
        else if (row==1)
        {
            rowStrig=@"500m";
        }else if (row==2)
        {
            rowStrig=@"1km";
        }else if (row==3)
        {
            rowStrig=@"3km";
        }else
        {
            rowStrig=@"5km";
        }
        myView.text=rowStrig;
//        myView.text=[NSString stringWithFormat:@"     %@",rowStrig];
    }
    else
    {
        NSString * rowStrig=nil;

        if (row==0) {
            rowStrig=@"同龄";
        }
        else if (row==1)
        {
            rowStrig=@"差1岁";
        }else if (row==2)
        {
            rowStrig=@"差2岁";
        }else if (row==3)
        {
            rowStrig=@"差3岁";
        }else
        {
            rowStrig=@"不限";
        }
        myView.text=rowStrig;
//      myView.text=[NSString stringWithFormat:@"     %@",rowStrig];

    }
    return myView;
}
- (void)RightMenth1
{
    if (self.myPickerView.frame.origin.y==Screen_Height+50) {
        [UIView animateWithDuration:0.5 animations:^{
            self.myPickerView.frame=CGRectMake(30, Screen_Height-250, Screen_Width-60, 100);
            pickerImageView.frame=CGRectMake(self.myPickerView.frame.origin.x, self.myPickerView.frame.origin.y-35, self.myPickerView.frame.size.width, 35);

        }];
        _uitable.userInteractionEnabled=NO;
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.myPickerView.frame=CGRectMake(30, Screen_Height+50, Screen_Width-60, 100);
            pickerImageView.frame=CGRectMake(self.myPickerView.frame.origin.x, self.myPickerView.frame.origin.y-35, self.myPickerView.frame.size.width, 35);

        }];
        _uitable.userInteractionEnabled=YES;

    }

    
}
- (void)analyUrl:(NSMutableDictionary *)urlString
{
    _uitable.userInteractionEnabled=NO;

    [self.tishiView StartMenth];
    
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    NSURL * aUrl=[[NSURL alloc]initWithString:[urlString valueForKey:@"aUrl"]];
    analysis=[[AnalysisClass alloc]initWithIdentifier:aUrl DataName:Nil ControllerName:[urlString valueForKey:@"contreName"] delegate:self];
    [aUrl release];
    [analysis PostMenth:urlString];
    
}
- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array
{

    [self.tishiView StopMenth];
    _uitable.userInteractionEnabled=YES;
    (@"%@",array);
    if ([asi.ControllerName isEqualToString:@"tongbabyage"]) {
        
    
    if ([[array valueForKey:asi.ControllerName] count])
    {
        
        if ([[array valueForKey:asi.ControllerName] count])
        {
            
            if ([[[array valueForKey:asi.ControllerName] valueForKey:@"msg"] objectAtIndex:0]==nil)
            {
//                (@"fsdfsd");
            }
            else
            {
                if (butBool) {
                    
                
                if ([rightBut.titleLabel.text isEqualToString:@"按活跃"]) {
                    [rightBut setTitle:@"按远近" forState:UIControlStateNormal];
                    
                    
                }
                else if([rightBut.titleLabel.text isEqualToString:@"按远近"])
                {
                    [rightBut setTitle:@"按活跃" forState:UIControlStateNormal];
                   
                }
                    butBool=NO;
                }
                [self.dataArray addObjectsFromArray:[array valueForKey:asi.ControllerName]];
            }
    }
    }
    else
    {
        [_uitable tableViewDidFinishedLoading];
        _uitable .reachedTheEnd  = YES;
    }
    }
    else
    {
//        (@"ControllerName  %@",[[array valueForKey:asi.ControllerName] valueForKey:@"msg"]);

        if ([[[array valueForKey:asi.ControllerName] valueForKey:@"code"] intValue])
        {
            if ([asi.ControllerName isEqualToString:@"guanzhu"]) {
                
                [[self.dataArray objectAtIndex:selectcNum] setValue:@"1" forKey:@"flag"];
                
            }
            else
            {
                [[self.dataArray objectAtIndex:selectcNum] setValue:@"0" forKey:@"flag"];
            }

            
        }
    }
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
    
    [asi release];
    analysis=nil;
    
}
- (void)RightMenth:(UIButton *)sender
{
    butBool=YES;
    [_uitable setContentOffset:CGPointMake(0, 0)];
    [self.dataArray removeAllObjects];
    page=1;
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    _uitable .reachedTheEnd  = NO;
    
    if ([rightBut.titleLabel.text isEqualToString:@"按活跃"]) {
        [self.dataDictionary setObject:@"1" forKey:@"style"];
        [self analyUrl:self.dataDictionary];
        
    }
    else
    {
        [self.dataDictionary setObject:@"2" forKey:@"style"];
        [self analyUrl:self.dataDictionary];

//        [self LocationMenth];
    }

}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid=@"ID123";
    QzcyCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[QzcyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
    }
    if (self.dataArray.count>indexPath.row) {
//        (@"%@  %@",self.dataDictionary,[self.dataArray objectAtIndex:indexPath.row]);
    cell.mainImageView.urlString=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"icon"];
    cell.titleLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
//        cell.titleLabel.backgroundColor=[UIColor redColor];
        if ([[self.dataDictionary valueForKey:@"style"] intValue]==1) {
            cell.tiaojianLabel.text = [NSString stringWithFormat:@"LV.%@(%@)",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"level"],[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"scorenum"]];
        }
        else
        {
            if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"distance"] intValue]>1000) {
                cell.tiaojianLabel.text = [NSString stringWithFormat:@"%0.1fkm",[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"distance"] floatValue]/1000.0];

            }
            else
            {
            cell.tiaojianLabel.text = [NSString stringWithFormat:@"%@m",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"distance"]];
            }

        }
//        cell.tiaojianLabel.backgroundColor=[UIColor redColor];
    cell.timeLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"status"];
//        cell.timeLabel.backgroundColor=[UIColor redColor];

    cell.subLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sign"];
    cell.qzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"approvalnum"];
    cell.gzLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"attentions"];
    cell.fsLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"fans"];
    cell.scLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"collection"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.cellButton.tag=indexPath.row;
    [cell.cellButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        if ([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"flag"] intValue]) {
            
            [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
           cell.guanzhuButton.opaque=NO;
        }
        else
        {
            [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
            cell.guanzhuButton.opaque=YES;
        }

    cell.guanzhuButton.tag=indexPath.row;
    [cell.guanzhuButton addTarget:self action:@selector(GuanZhuMenth:) forControlEvents:UIControlEventTouchUpInside];
        if ([[self.dataDictionary valueForKey:@"uid"] intValue]==[[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"id"] intValue]) {
            cell.guanzhuButton.hidden=YES;
        }
        else
        {
            cell.guanzhuButton.hidden=NO;
        }
    }
    return cell;
}
- (void)GuanZhuMenth:(UIButton *)sender
{
//    (@"%@",[self .dataArray objectAtIndex:sender.tag]);
    [self.dataDictionary setValue:[[self.dataArray objectAtIndex:sender.tag] valueForKey:@"id"] forKey:@"targetid"];
    selectcNum=sender.tag;
    if (sender.opaque) {
        [self.dataDictionary setValue:@"guanzhu" forKey:@"contreName"];
        
        [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/addfriend" forKey:@"aUrl"];
        [self analyUrl:self.dataDictionary];

        
       }
    else
    {
        UIAlertView * alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"取消关注将扣除5个积分，您确定吗？" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确定", nil];
        alertview.tag=0;
        [alertview show];
        [alertview release];
   
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag) {
        if ([[self.oldDictionary valueForKey:@"type"] isEqualToString:@"2"]) {

        [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if (buttonIndex) {
        
        [self.dataDictionary setValue:@"quxiaoguanzhu" forKey:@"contreName"];
        
        [self.dataDictionary setValue:@"http://apptest.mum360.com/web/home/index/deletefriend" forKey:@"aUrl"];
        [self analyUrl:self.dataDictionary];
        
    }
}
- (void)CellButtonMenth:(UIButton *)sender
{
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction addEntriesFromDictionary:[self.dataArray objectAtIndex:sender.tag]];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (analysis) {
        [analysis CancelMenthrequst];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction addEntriesFromDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_uitable tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_uitable tableViewDidScroll:scrollView];
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self.dataArray removeAllObjects];
    page=1;
    [self.dataDictionary setValue:[self.dataDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.dataDictionary setValue:@"tongbabyage" forKey:@"contreName"];
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    _uitable .reachedTheEnd  = NO;
    [self analyUrl:self.dataDictionary];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self.dataDictionary setValue:[self.dataDictionary valueForKey:@"aUrl1"] forKey:@"aUrl"];
    [self.dataDictionary setValue:@"tongbabyage" forKey:@"contreName"];
    [self.dataDictionary setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self analyUrl:self.dataDictionary];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
