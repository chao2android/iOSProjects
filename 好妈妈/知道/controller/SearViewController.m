//
//  SearViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-20.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "SearViewController.h"
#import "UIImageView+WebCache.h"

#import "contentViewController.h"
#import "ImageTextLabel.h"

#import "QzcyCell.h"
#import "WoViewController.h"

@interface SearViewController ()

@end

@implementation SearViewController

-(void)dealloc{
    [super dealloc];
    [_muArr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    _muArr= [[NSMutableArray alloc]init];
    
    UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Width-20))];
    backgroundIV.image =[UIImage imageNamed:@"底.png"];
    [self.view addSubview:backgroundIV];
    [backgroundIV release];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    bgView.image = [UIImage imageNamed:@"nav_background"];
    [self.view addSubview:bgView];
    [bgView release];
    
    
    self.sam_type = @"1";
    
    _myTextView = [[UITextField alloc]initWithFrame:CGRectMake(15, KUIOS_7(8), Screen_Width - 80, 28)];
    _myTextView.backgroundColor = [UIColor whiteColor];
    _myTextView.autocorrectionType = UITextAutocorrectionTypeDefault;
    _myTextView.clearsOnBeginEditing = YES;
    _myTextView.placeholder = @"请输入您要搜索的文字";
    _myTextView.delegate = self;
    _myTextView.borderStyle = UITextBorderStyleRoundedRect;
    _myTextView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _myTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _myTextView.returnKeyType = UIReturnKeySearch;
    _myTextView.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"@2x_3.png"]];
    _myTextView.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_myTextView];
    [_myTextView release];
    [_myTextView becomeFirstResponder];
    
    
    removeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    removeBut.frame=CGRectMake(Screen_Width - 55, KUIOS_7(7), 44, 30);
    [removeBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"004_钮" ofType:@"png"]] forState:UIControlStateNormal];
    [removeBut setTitle:@"返回" forState:UIControlStateNormal];
    removeBut.titleLabel.font=[UIFont systemFontOfSize:13];
    [removeBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeBut addTarget:self action:@selector(removeBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeBut];
    
    
    _uitable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(84), Screen_Width, Screen_Height - 84-20) pullingDelegate:(id<PullingRefreshTableViewDelegate>)self];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.backgroundColor = [UIColor clearColor];
    _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    
    
    
    UIButton * tieziBut = [UIButton buttonWithType:UIButtonTypeCustom];
    tieziBut.frame = CGRectMake(0, KUIOS_7(44), Screen_Width/2, 40);
    [tieziBut setTitle:@"帖子" forState:UIControlStateNormal];
    [tieziBut setBackgroundImage:[UIImage imageNamed:@"Search_2.png"] forState:UIControlStateNormal];
    [tieziBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    tieziBut.tag = 1;
    [tieziBut addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    tieziBut.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tieziBut];
    
    
    //    CALayer* l1=[tieziBut layer];
    //    [l1 setMasksToBounds:YES];
    //    [l1 setBorderWidth:1];
    //    [l1 setBorderColor:[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]CGColor] ];
    
    
    UIButton *userBut = [UIButton buttonWithType:UIButtonTypeCustom];
    userBut.frame = CGRectMake(Screen_Width/2-1, KUIOS_7(44), Screen_Width/2+1, 40);
    [userBut setTitle:@"用户" forState:UIControlStateNormal];
    [userBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    userBut.tag = 2;
    [userBut setBackgroundImage:[UIImage imageNamed:@"Search_2.png"] forState:UIControlStateNormal];
    
    [userBut addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    userBut.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userBut];
    
    //    l1=[userBut layer];
    //    [l1 setMasksToBounds:YES];
    //    [l1 setBorderWidth:1];
    //    [l1 setBorderColor:[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]CGColor] ];
    //
    
    typeBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width/2, 40)];
    typeBgView.backgroundColor = [UIColor clearColor];
    typeBgView.image = [UIImage imageNamed:@"Search_1.png"];
    [self.view addSubview:typeBgView];
    [typeBgView release];
    
    UILabel *tLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width/2, 35)];
    tLab.backgroundColor = [UIColor clearColor];
    tLab.textColor = [UIColor whiteColor];
    tLab.textAlignment = 1;
    tLab.tag = 1;
    tLab.text = @"帖子";
    [typeBgView addSubview:tLab];
    [tLab release];
    
    
}
-(void)changeType:(UIButton *)but{
    
    if (but.tag == 1) {
        self.sam_type = @"1";
        UILabel *tLab = (UILabel *)[typeBgView viewWithTag:1];
        tLab.text = @"帖子";
        
        [UIView animateWithDuration:0.1 animations:^{
            typeBgView.frame =CGRectMake(0, typeBgView.frame.origin.y, Screen_Width/2, 40);
        }];
        
    }else{
        self.sam_type = @"2";
        UILabel *tLab = (UILabel *)[typeBgView viewWithTag:1];
        tLab.text = @"用户";
        
        [UIView animateWithDuration:0.1 animations:^{
            typeBgView.frame =CGRectMake(Screen_Width/2, typeBgView.frame.origin.y, Screen_Width/2, 40);
        }];
        
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //  [removeBut setTitle:@"取消" forState:UIControlStateNormal];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //  [removeBut setTitle:@"返回" forState:UIControlStateNormal];
    
    [_myTextView resignFirstResponder];
    page = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    
    return YES;
}

-(void)removeBut{
    if (analysis) {
        [analysis CancelMenthrequst];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)loadData{
    // http://apptest.mum360.com/web/home/index/searchknows?uid=&token=&text=&limit=&page=
    [self makeHUD];
    NSMutableDictionary * userDic=[[NSUserDefaults standardUserDefaults] valueForKey:@"logindata"];
    
    NSMutableDictionary * asiDictiong=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[userDic valueForKey:@"uid"],@"uid",[userDic valueForKey:@"token"],@"token",_myTextView.text,@"text",@"http://apptest.mum360.com/web/home/index/searchknows",@"aUrl",@"search",@"Controller",@"20",@"limit",[NSString stringWithFormat:@"%d",page],@"page", self.sam_type,@"type",nil];
    [self analyUrl:asiDictiong];
    [asiDictiong release];
    
}

- (void)analyUrl:(NSMutableDictionary *)urlString
{
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
    
    NSArray *arr = [array valueForKey:asi.ControllerName];
    if (page == 1) {
        [_muArr removeAllObjects];
    }
    
    for (NSDictionary *dic in arr) {
        [_muArr addObject:dic];
    }
    
    if ([arr count] < 20) {
        _uitable .reachedTheEnd  = YES;
    }else{
        
        _uitable .reachedTheEnd  = NO;
        
    }
    
    [_uitable reloadData];
    [_uitable tableViewDidFinishedLoading];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.sam_type isEqualToString:@"1"]) {
        return 85;
        
    }else{
        
        if (ISIPAD) {
            return 75*1.4;
        }else{
            return 75;

        
        }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.sam_type isEqualToString:@"1"]) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCellID"];
        if ( cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailsCellID"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
        }
        
        [cell.contentView removeAllSubviewss];
        NSDictionary *dic = _muArr[indexPath.row];
        
        
        UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 85)];
        bg.image = [UIImage imageNamed:@"bg-cell666.png"];
        [cell.contentView addSubview:bg];
        [bg release];
        
        
        
        NSString *tiString1 = dic[@"title"];
        if (tiString1.length > 25) {
            tiString1 = [tiString1 substringToIndex:25];
        }
        
        
        ImageTextLabel *titLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
        titLab.backgroundColor = [UIColor clearColor];
        titLab.m_Font = [UIFont systemFontOfSize:16];
        
        [titLab LoadContent:tiString1];
        [cell.contentView addSubview:titLab];
        [titLab release];
        
        
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 30, 30)];
        iconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"30_30.png"]];
        [iconView setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
        [cell.contentView addSubview:iconView];
        [iconView release];
        
        
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(55, 40, 100, 15)];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.textColor = [UIColor colorWithRed:97/255.0f green:196/255.0f blue:218/255.0f alpha:1];
        nameLab.font = [UIFont systemFontOfSize:12];
        nameLab.text = dic[@"name"];
        [cell.contentView addSubview:nameLab];
        [nameLab release];
        
        UILabel *statusLab = [[UILabel alloc]initWithFrame:CGRectMake(55, 55, 100, 15)];
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.textColor = [UIColor grayColor];
        statusLab.font = [UIFont systemFontOfSize:12];
        statusLab.text = dic[@"status"];
        [cell.contentView addSubview:statusLab];
        [statusLab release];
        
        
        
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(150,50, 100, 15)];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textAlignment = 2;
        timeLab.textColor = [UIColor grayColor];
        timeLab.font = [UIFont systemFontOfSize:12];
        timeLab.text = dic[@"time"];
        [cell.contentView addSubview:timeLab];
        [timeLab release];
        
        
        
        
        UIImageView *commentnumView = [[UIImageView alloc]initWithFrame:CGRectMake(270, 40, 30, 20)];
        commentnumView.image = [UIImage imageNamed:@"001_10.png"];
        [cell.contentView addSubview:commentnumView];
        [commentnumView release];
        
        UILabel *commentnumLab = [[UILabel alloc]initWithFrame:CGRectMake(270, 60, 30, 20)];
        commentnumLab.backgroundColor = [UIColor clearColor];
        commentnumLab.textAlignment = 1;
        commentnumLab.textColor = [UIColor blackColor];
        commentnumLab.font = [UIFont systemFontOfSize:12];
        commentnumLab.text = dic[@"commentnum"];
        [cell.contentView addSubview:commentnumLab];
        [commentnumLab release];
        
        
        
        if (ISIPAD) {
            bg.frame = CGRectMake(0, 0, Screen_Width,85);
            timeLab.frame =CGRectMake(550,50, 100, 15);
            commentnumView.frame = CGRectMake(680, 40, 30, 20);
            commentnumLab.frame = CGRectMake(680, 60, 30, 20);
            
        }
        
        return cell;
        
    }else{
        
        static NSString * cellId=@"ID123";
        QzcyCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[QzcyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        }
        NSDictionary *dic = _muArr[indexPath.row];
        
        cell.mainImageView.urlString=[dic valueForKey:@"icon"];
        cell.mainImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认" ofType:@"png"]]];
        cell.titleLabel.text=[dic valueForKey:@"name"];
        //          int titleLengh=cell.titleLabel.text.length*16>160?160:cell.titleLabel.text.length*16;
        cell.titleLabel.frame=CGRectMake(72.5, 6, 120, 20);
        cell.timeLabel.frame=CGRectMake(190, cell.titleLabel.frame.origin.y+5, 130, 13);
        
        if (ISIPAD) {
            cell.titleLabel.frame=CGRectMake(102.5, 6, 190, 20);
            cell.timeLabel.frame=CGRectMake(300, cell.titleLabel.frame.origin.y+5, 130, 13);
        }
        
        cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        cell.titleLabel.minimumFontSize = 1.0f;
        cell.timeLabel.adjustsFontSizeToFitWidth = YES;
        cell.timeLabel.minimumFontSize = 1.0f;
        
        cell.timeLabel.textAlignment = 0;
        cell.timeLabel.text=[dic valueForKey:@"status"];
        cell.subLabel.text=[dic valueForKey:@"sign"];
        cell.qzLabel.text=[dic valueForKey:@"approvalnum"];
        cell.gzLabel.text=[dic valueForKey:@"attentions"];
        cell.fsLabel.text=[dic valueForKey:@"fans"];
        cell.scLabel.text=[dic valueForKey:@"collection"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.cellButton.tag=indexPath.row;
        [cell.cellButton addTarget:self action:@selector(CellButtonMenth:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.guanzhuButton.hidden = YES;
        //          if ([[dic valueForKey:@"flag"] intValue]) {
        //
        //              [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已关注" ofType:@"png"]] forState:UIControlStateNormal];
        //              cell.guanzhuButton.opaque=NO;
        //          }
        //          else
        //          {
        //              [cell.guanzhuButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关注" ofType:@"png"]] forState:UIControlStateNormal];
        //              cell.guanzhuButton.opaque=YES;
        //          }
        //
        //          cell.guanzhuButton.tag=indexPath.row;
        //          [cell.guanzhuButton addTarget:self action:@selector(GuanZhuMenth:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
        
        return cell;
        
    }
    
    
    
    
}

- (void)CellButtonMenth:(UIButton *)sender
{
    NSMutableDictionary * diction=[[NSMutableDictionary alloc]initWithCapacity:1];
    [diction addEntriesFromDictionary:[_muArr objectAtIndex:sender.tag]];
    [diction setObject:@"YES" forKey:@"bool"];
    [diction setValue:@"0" forKey:@"type"];
    WoViewController * woview=[[WoViewController alloc]init];
    woview.oldDictionary=diction;
    [diction release];
    [self.navigationController pushViewController:woview animated:YES];
    [woview release];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _muArr[indexPath.row];
    
    if ([self.sam_type isEqualToString:@"1"]) {
        contentViewController *ctrl = [[contentViewController alloc]init];
        ctrl.contentID = dic[@"id"];
        [self.navigationController pushViewController:ctrl animated:YES];
        [ctrl release];
    }else{
        
        
    }
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_uitable tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_uitable tableViewDidScroll:scrollView];
    
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    page = 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}



- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    page++;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
    
}

-(void)makeHUD{
    myHUD= [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:myHUD];
    //  myHUD.dimBackground = YES;
    
    myHUD.labelText = @"加载中..";
    [myHUD show:YES];
    
}
-(void)remHUD{
    [myHUD removeFromSuperview];
    [myHUD release];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
}


@end
