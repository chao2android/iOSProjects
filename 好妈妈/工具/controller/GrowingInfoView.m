//
//  GrowingInfoView.m
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-16.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "GrowingInfoView.h"

@implementation GrowingInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
        backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
        [self addSubview:backImageView];
        [backImageView release];
        
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    _sam_age = 0;
    _sam_month = 0;
    _sam_date = 1;
    
    _sam_zhou = 4;
    _sam_tian = 1;

    [self loadData];
}

- (void)loadData {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    if ([[userDic valueForKey:@"dayday"] intValue]<=3&&![[[[[NSUserDefaults standardUserDefaults] valueForKey:@"tixingshoufei"] componentsSeparatedByString:@"-"] objectAtIndex:2] isEqualToString:[[date componentsSeparatedByString:@"-"] objectAtIndex:2]]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tixingshoufei"];
        [[NSUserDefaults standardUserDefaults] setValue:date forKey:@"tixingshoufei"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString * string=[NSString stringWithFormat:@"您的Vip会员将于%@天后到期",[userDic valueForKey:@"dayday"]];
        
        if (![[userDic valueForKey:@"dayday"] intValue]) {
            
            string=[NSString stringWithFormat:@"您的Vip会员已到期"];
        }
    }
    
    NSLog(@"userDic == %@",userDic);
    
    NSString *type = [NSString stringWithFormat:@"%@",userDic[@"type"]];
    self.sam_type = [NSString stringWithString:type];
    if ([type isEqualToString:@"1"]) {
        NSString *age  = userDic[@"age"];
        
        NSLog(@"age  %@",age);
        
        int yStr = [[age substringWithRange:NSMakeRange(0, 2)] intValue];
        if (yStr < 6) {
            NSString *yStr = [age substringWithRange:NSMakeRange(0, 2)];
            NSString *mStr = [age substringWithRange:NSMakeRange(3, 2)];
            NSString *dStr = [age substringWithRange:NSMakeRange(6, 2)];
            int y = [yStr intValue];
            int m = [mStr intValue];
            int d = [dStr intValue];
            
            NSLog(@"年--%d月--%d--日%d",y,m,d);
            
            if (d == 0) {
                d = 31;
                m -= 1;
                if (m < 0) {
                    m = 11;
                    y -= 1;
                }
            }
            
            self.sam_day = [NSString stringWithFormat:@"%02d-%02d-%02d",y,m,d];
        }else{
            self.sam_day = @"";
            leftBut.hidden = YES;
            rightBut.hidden = YES;
            goBut.hidden = YES;
        }
        NSLog(@"samday  %@",self.sam_day);
    }else if([type isEqualToString:@"2"]){
        
        self.sam_day = userDic[@"age"];;
        
        NSLog(@"samday  %@",self.sam_day);
        
        
    }else{
        self.sam_day = @"";
        leftBut.hidden = YES;
        rightBut.hidden = YES;
        goBut.hidden = YES;
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@todaynew?uid=%@&token=%@&type=%@",SERVER_URL,[userDic valueForKey:@"uid"],[userDic valueForKey:@"token"],self.sam_type];
    NSLog(@"==============mmmd======%@",str);
    
    int iOffset = 5;
    if (ISIPAD) {
        iOffset = 20;
    }
    
    int iTop = ISIPAD?20:10;
    int iHeight = ISIPAD?90:50;

    webBgView = [[UIImageView alloc]initWithFrame:CGRectMake(iOffset, iTop, self.frame.size.width-iOffset*2, self.frame.size.height-iTop*2)];
    webBgView.image = [UIImage imageNamed:@"001_22.png"];
    [self addSubview:webBgView];
    [webBgView release];

    myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(iOffset*2, iTop+5, self.frame.size.width-iOffset*4, webBgView.frame.size.height-iHeight)];
    if ([self.sam_type isEqualToString:@"3"]) {
        myWebView.frame=CGRectMake(iOffset*2, iTop+5, self.frame.size.width-iOffset*4, webBgView.frame.size.height-iTop-5);
    }
    else if ([self.sam_type isEqualToString:@"1"]) {
        if ([[[userDic[@"age"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]>=6) {
            NSLog(@"ageageage  %@",userDic[@"age"]);
            myWebView.frame=CGRectMake(iOffset*2, 15, self.frame.size.width-iOffset*4, webBgView.frame.size.height-iTop-5);
        }
    }
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    myWebView.backgroundColor = [UIColor whiteColor];
    myWebView.delegate = self;
    myWebView.scrollView.delegate = self;
    [myWebView loadRequest:request];
    myWebView.scalesPageToFit = YES;
    [self addSubview:myWebView];

    int iLeft = (self.frame.size.width-320)/2;

    dingBgView = [[UIImageView alloc] initWithFrame:CGRectMake(50+iLeft, myWebView.scrollView.contentSize.height, 220, 60)];
    dingBgView.backgroundColor = [UIColor clearColor];
    dingBgView.userInteractionEnabled = YES;
    [myWebView.scrollView  addSubview:dingBgView];
    [dingBgView release];
    
    if (ISIPAD) {
        dingBgView.frame = CGRectMake(iLeft, myWebView.scrollView.contentSize.height, 220, 60);
    }
    UIButton *cBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cBut.frame = CGRectMake(10, 0, 200, 30);
    [cBut setBackgroundImage:[UIImage imageNamed:@"004_11.png"] forState:UIControlStateNormal];
    cBut.showsTouchWhenHighlighted = YES;
    [cBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cBut setTitle:@"定制个性化养育信息服务" forState:UIControlStateNormal];
    cBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [dingBgView addSubview:cBut];
    
    UIButton *dBut = [UIButton buttonWithType:UIButtonTypeCustom];
    dBut.frame = CGRectMake(10, 30, 200, 25);
    [dBut setBackgroundImage:[UIImage imageNamed:@"004_10.png"] forState:UIControlStateNormal];
    [dBut addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [dBut setTitle:@"加入好妈妈会员" forState:UIControlStateNormal];
    dBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [dingBgView addSubview:dBut];
    
    NSString *buyS = [NSString stringWithFormat:@"%@",userDic[@"badge"]];
    NSLog(@"sam_type=================================%@, %@",self.sam_type, buyS);
    
    if ([buyS isEqualToString:@"1"]||[self.sam_type isEqualToString:@"3"]||[[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]>=6) {
        dingBgView.hidden = YES;
    }
    else{
        dingBgView.hidden = NO;
    }
    
    int iBtnWidth = ISIPAD?100:60;
    int iBtnHeight = ISIPAD?50:30;
    
    int iBtnTop = self.frame.size.height-iHeight;
    
    leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBut.frame = CGRectMake(ISIPAD?80:20+iLeft, iBtnTop, iBtnWidth, iBtnHeight);
    [leftBut setTitle:@"前一天" forState:UIControlStateNormal];
    [leftBut addTarget:self action:@selector(clicked_leftBut) forControlEvents:UIControlEventTouchUpInside];
    leftBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBut setBackgroundImage:[UIImage imageNamed:@"004_换页1.png"] forState:UIControlStateNormal];
    [self addSubview:leftBut];
    
    rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(ISIPAD?220:100+iLeft, iBtnTop, iBtnWidth, iBtnHeight);
    rightBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBut setTitle:@"后一天" forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(clicked_rightBut) forControlEvents:UIControlEventTouchUpInside];
    [rightBut setBackgroundImage:[UIImage imageNamed:@"004_换页1.png"] forState:UIControlStateNormal];
    [self addSubview:rightBut];
    
    goBut = [UIButton buttonWithType:UIButtonTypeCustom];
    goBut.frame = CGRectMake(ISIPAD?520:240+iLeft, iBtnTop, iBtnWidth, iBtnHeight);
    goBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [goBut setTitle:@"查看" forState:UIControlStateNormal];
    [goBut addTarget:self action:@selector(clicked_goBut) forControlEvents:UIControlEventTouchUpInside];
    [goBut setBackgroundImage:[UIImage imageNamed:@"004_换页1.png"] forState:UIControlStateNormal];
    [self addSubview:goBut];

    topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, Screen_Height, self.frame.size.width, 44)];
    topBar.barStyle = UIBarStyleBlackTranslucent;
    [self addSubview:topBar];
    [topBar release];
    
    UIBarButtonItem *cancelItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(OnCancelClick)] autorelease];
    UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *closeItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(OnSelectClick)] autorelease];
    topBar.items = [NSArray arrayWithObjects:cancelItem, spaceItem, closeItem, nil];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Screen_Height+44, self.frame.size.width, 0)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [self addSubview:pickerView];
    [pickerView release];
    
    
    if ([type isEqualToString:@"1"]) {
        NSString *age  = userDic[@"age"];
        int yStr = [[age substringWithRange:NSMakeRange(0, 2)] intValue];
        if (yStr <6) {
            
        }else{
            leftBut.hidden = YES;
            rightBut.hidden = YES;
            goBut.hidden = YES;
        }
        NSLog(@"samday  %@",self.sam_day);
    }
    else if([type isEqualToString:@"2"]){
        NSLog(@"samday  %@",self.sam_day);
    }
    else{
        leftBut.hidden = YES;
        rightBut.hidden = YES;
        goBut.hidden = YES;
        
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self makeHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self remHUD];
    NSLog(@"%@",[webView subviews]);
    
    [self performSelector:@selector(Abcd) withObject:self afterDelay:0.3];
    NSLog(@"成功");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"错误");
    [self remHUD];
}

- (void)Abcd
{
    myWebView.scrollView.contentSize=CGSizeMake(myWebView.scrollView.frame.size.width, myWebView.scrollView.contentSize.height+50);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int iLeft = (self.frame.size.width-320)/2;
    
    if (dingBgView) {
        dingBgView.frame = CGRectMake(50+iLeft, scrollView.contentSize.height-65, 220, 60);
        if (ISIPAD) {
            dingBgView.frame = CGRectMake(iLeft, scrollView.contentSize.height-65, 220, 60);
            
        }
    }
}

-(void)relodWebView{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    
    NSString *buyS = [NSString stringWithFormat:@"%@",userDic[@"badge"]];
    NSLog(@"buy == %@",buyS);
    if ([buyS isEqualToString:@"1"]) {
        dingBgView.hidden = YES;
    }else{
        dingBgView.hidden = NO;
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%@todaynew?uid=%@&token=%@&day=%@&type=%@",SERVER_URL,[userDic valueForKey:@"uid"],[userDic valueForKey:@"token"],self.sam_day,self.sam_type ];
    NSURL *url=[NSURL URLWithString:str];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [myWebView loadRequest:request];
    NSLog(@"samday = %@",self.sam_day);
    
}

-(void)clicked_goBut{
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.frame =CGRectMake(0, self.frame.size.height-200, self.frame.size.width, 0);
        topBar.frame =CGRectMake(0, pickerView.frame.origin.y-44, self.frame.size.width, 44);
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if ([self.sam_type isEqualToString:@"1"]) {
        return 3;
    }else if([self.sam_type isEqualToString:@"2"]){
        return 2;
    }else{
        return 0;
    }
    
}

//指定有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView1 numberOfRowsInComponent:(NSInteger)component {
    
    if ([self.sam_type isEqualToString:@"1"]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
        
        if (component == 0) {
            return [[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]+1;
            //            return 6;
        }else if (component == 1) {
            if ([pickerView selectedRowInComponent:0]>=[[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]) {
                return [[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]+1;
            }
            return 12;
            
        }else{
            if ([pickerView selectedRowInComponent:0]>=3&&[pickerView selectedRowInComponent:0]<6) {
                return 4;
            }
            return 31;
        }
    }else if([self.sam_type isEqualToString:@"2"]){
        
        if (component == 0) {
            
            return 36;
        }else{
            
            return 7;
            
        }
    }else{
        return 0;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView1 titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    if ([self.sam_type isEqualToString:@"1"]) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%d岁",row];
        }else if(component == 1){
            return [NSString stringWithFormat:@"%d月",row];
        }else{
            if ([pickerView selectedRowInComponent:0]>=3&&[pickerView selectedRowInComponent:0]<6) {
                return [NSString stringWithFormat:@"%d周",row+1];
                
            }
            return [NSString stringWithFormat:@"%d天",row+1];
        }
        
    }else if([self.sam_type isEqualToString:@"2"]){
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%d周",row+4];
        }else{
            return [NSString stringWithFormat:@"%d天",row+1];
        }
        
    }else{
        return nil;
    }
    
    
}
- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if ([self.sam_type isEqualToString:@"1"]) {
        if (component == 0) {
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
            self.sam_age = row;
        }else if(component == 1){
            [pickerView reloadComponent:2];
            self.sam_month = row;
        }else{
            self.sam_date = row+1;
        }
        NSLog(@"age = %d month = %d date = %d",self.sam_age,self.sam_month,self.sam_date);
        
    }else if([self.sam_type isEqualToString:@"2"]){
        if (component == 0) {
            self.sam_zhou = row+4;
        }else{
            self.sam_tian = row+1;
        }
        NSLog(@"zhou = %d tian = %d ",self.sam_zhou,self.sam_tian);
        
    }else{
        
    }
    
    
    
}

-(void)OnCancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        topBar.frame =CGRectMake(0, Screen_Height, self.frame.size.width, 44);
        pickerView.frame =CGRectMake(0, Screen_Height+44, self.frame.size.width, 0);
    }];
    
    
}
-(void)OnSelectClick{
    [UIView animateWithDuration:0.3 animations:^{
        topBar.frame =CGRectMake(0, Screen_Height, self.frame.size.width, 44);
        pickerView.frame =CGRectMake(0, Screen_Height+44, self.frame.size.width, 0);
    }];
    
    
    
    if ([self.sam_type isEqualToString:@"1"]) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
        NSString  *time = userDic[@"age"] ;
        NSString *yStr = [time substringWithRange:NSMakeRange(0, 2)];
        NSString *mStr = [time substringWithRange:NSMakeRange(3, 2)];
        NSString *dStr = [time substringWithRange:NSMakeRange(6, 2)];
        int y = [yStr intValue];
        int m = [mStr intValue];
        int d = [dStr intValue];
        int t = y*365 + m*31 +d +1;
        int day = self.sam_age *365 + self.sam_month *31 +self.sam_date+1;
        
        if (m == 0&& d==0) {
            t = y*372+1;
            day = self.sam_age *372 + self.sam_month *31 +self.sam_date+1;
            
        }
        NSLog(@"%d  %d",day,t);
        if (day <= t) {
            NSLog(@"%d  %d  %d",self.sam_age,self.sam_month,self.sam_date);
            
            self.sam_day = [NSString stringWithFormat:@"%02d-%02d-%02d",self.sam_age,self.sam_month,self.sam_date];
            [self relodWebView];
            
        }else{
            MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:eorrHUD];
            eorrHUD.mode = MBProgressHUDModeCustomView;
            eorrHUD.labelText = @"不能超过宝宝的年龄";
            [eorrHUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [eorrHUD removeFromSuperview];
                [eorrHUD release];
            }];
            
        }
        
    }else if([self.sam_type isEqualToString:@"2"]){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
        NSString  *time = userDic[@"age"] ;
        
        NSString *yStr = [time substringWithRange:NSMakeRange(0, 2)];
        NSString *mStr = [time substringWithRange:NSMakeRange(3, 2)];
        NSString *dStr = [time substringWithRange:NSMakeRange(6, 2)];
        int y = [yStr intValue];
        int m = [mStr intValue];
        int d = [dStr intValue];
        
        int t = y*365 + m*7 +d +1;
        
        int day = self.sam_zhou *7 +self.sam_tian +1;
        
        NSLog(@"ttt  == %d day == %d",t,day);
        NSLog(@"%d",self.sam_zhou);
        if (day <= t) {
            if (self.sam_tian > 6) {
                self.sam_tian = 0;
                self.sam_zhou +=1;
            }
            NSLog(@"%ld",(long)self.sam_zhou);
            self.sam_day = [NSString stringWithFormat:@"00-%02d-%02d",self.sam_zhou,self.sam_tian];
            [self relodWebView];
            
            [pickerView selectRow:self.sam_tian-1 inComponent:1 animated:NO];
            [pickerView selectRow:self.sam_zhou-4 inComponent:0 animated:NO];
            
            self.sam_tian = 1;
            
            
            
        }else{
            MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:eorrHUD];
            eorrHUD.mode = MBProgressHUDModeCustomView;
            eorrHUD.labelText = @"已经到最后一天";
            [eorrHUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [eorrHUD removeFromSuperview];
                [eorrHUD release];
            }];
            
        }
        
        
    }else{
    }
    
    
    
    
}
-(void)clicked_leftBut{
    
    
    NSString *yStr = [self.sam_day substringWithRange:NSMakeRange(0, 2)];
    NSString *mStr = [self.sam_day substringWithRange:NSMakeRange(3, 2)];
    NSString *dStr = [self.sam_day substringWithRange:NSMakeRange(6, 2)];
    
    NSLog(@"yesrs = %@ y = %@ m = %@ d = %@",self.sam_day,yStr,mStr,dStr);
    
    
    
    
    int y = [yStr intValue];
    int m = [mStr intValue];
    int d = [dStr intValue];
    if ([self.sam_type isEqualToString:@"1"]) {
        if (d == 1 && m == 0 && y == 0 ) {
            MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:eorrHUD];
            eorrHUD.mode = MBProgressHUDModeCustomView;
            eorrHUD.labelText = @"已经到第一天";
            [eorrHUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [eorrHUD removeFromSuperview];
                [eorrHUD release];
            }];
            
        }else{
            
            
            d--;
            
            if (d <= 0 ) {
                if ([yStr intValue]>=3&&[yStr intValue]<6) {
                    if ([mStr intValue]==0&&[dStr intValue]==1&&[yStr intValue]==3) {
                        d=31;
                    }
                    else
                    {
                        d=4;
                    }
                }
                else
                {
                    d = 31 ;
                }
                
                m = m - 1;
                if (m < 0 ) {
                    m = 11;
                    y -= 1;
                }
            }
            
            
            
            self.sam_day = [NSString stringWithFormat:@"%02d-%02d-%02d",y,m,d];
            [self relodWebView];
            
        }
        
    }else{
        if (d == 1 && m == 4 && y == 0 ) {
            MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:eorrHUD];
            eorrHUD.mode = MBProgressHUDModeCustomView;
            eorrHUD.labelText = @"已经到第一天";
            [eorrHUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [eorrHUD removeFromSuperview];
                [eorrHUD release];
            }];
            
        }else{
            
            d--;
            
            if (d < 0 ) {
                
                d = 6 ;
                
                m = m - 1;
            }
            
            
            NSLog(@"%02d-%02d-%02d",y,m,d);
            self.sam_day = [NSString stringWithFormat:@"%02d-%02d-%02d",y,m,d];
            [self relodWebView];
            
        }
        
        
    }
    
    
    
}
-(void)clicked_rightBut{
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    NSString *years = userDic[@"age"];
    NSString *yStrT = [years substringWithRange:NSMakeRange(0, 2)];
    NSString *mStrT = [years substringWithRange:NSMakeRange(3, 2)];
    NSString *dStrT = [years substringWithRange:NSMakeRange(6, 2)];
    
    int yT = [yStrT intValue];
    int mT = [mStrT intValue];
    int dT = [dStrT intValue];
    
    if ([self.sam_type isEqualToString:@"1"]) {
        
        if (dT == 0) {
            dT = 31;
            mT -= 1;
            if (mT < 0) {
                mT = 11;
                yT -= 1;
            }
        }
        
    }
    
    NSString *yStr = [self.sam_day substringWithRange:NSMakeRange(0, 2)];
    NSString *mStr = [self.sam_day substringWithRange:NSMakeRange(3, 2)];
    NSString *dStr = [self.sam_day substringWithRange:NSMakeRange(6, 2)];
    NSLog(@"%d   %d   %d",yT,mT,dT);
    NSLog(@"yesrs = %@ y = %@ m = %@ d = %@",self.sam_day,yStr,mStr,dStr);
    int y = [yStr intValue];
    int m = [mStr intValue];
    int d = [dStr intValue];
    
    NSLog(@"dt=== %d d== %d",dT,d);
    //    if (dT == 0) {
    //        dT = 31;
    //        d = 31;
    //    }
    if ([self.sam_type isEqualToString:@"1"]) {
        if (yT == y &&mT == m && dT == d) {
            MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:eorrHUD];
            eorrHUD.mode = MBProgressHUDModeCustomView;
            eorrHUD.labelText = @"已经到最后一天";
            [eorrHUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [eorrHUD removeFromSuperview];
                [eorrHUD release];
            }];
            
        }else{
            
            d = d +1;
            if ([yStr intValue]>=3&&[yStr intValue]<6) {
                if (d > 4) {
                    d = 1;
                    m = m +1;
                    if (m > 11) {
                        m = 0;
                        y +=1;
                    }
                }
            }
            else
            {
                if (d > 31) {
                    d = 1;
                    m = m +1;
                    if (m > 11) {
                        m = 0;
                        y +=1;
                    }
                }
            }
            self.sam_day = [NSString stringWithFormat:@"%02d-%02d-%02d",y,m,d];
            [self relodWebView];
            
            
        }
        
        
        
    }else{
        
        if (yT == y &&mT == m && dT == d) {
            MBProgressHUD * eorrHUD = [[MBProgressHUD alloc] initWithView:self];
            [self addSubview:eorrHUD];
            eorrHUD.mode = MBProgressHUDModeCustomView;
            eorrHUD.labelText = @"已经到最后一天";
            [eorrHUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [eorrHUD removeFromSuperview];
                [eorrHUD release];
            }];
            
        }else{
            
            d = d +1;
            
            if (d > 6) {
                d = 0 ;
                m = m +1;
            }
            self.sam_day = [NSString stringWithFormat:@"%02d-%02d-%02d",y,m,d];
            [self relodWebView];
        }
    }
}

- (void)makeHUD {
    [self remHUD];
    myHUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:myHUD];
    myHUD.labelText = @"加载中..";
    [myHUD show:YES];
}

- (void)remHUD {
    if (myHUD) {
        [myHUD removeFromSuperview];
        [myHUD release];
        myHUD=nil;
    }
}

- (void)makView {

    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self addSubview:navigation];
    [navigation release];
    
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(11), (Screen_Width-200), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"成长足迹";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton * rightBut11=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBut11.frame = CGRectMake(Screen_Width-52, KUIOS_7(7), 47, 30);
    [rightBut11 setTitle:@"会员" forState:UIControlStateNormal];
    rightBut11.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBut11 setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]]forState:UIControlStateNormal];
    [rightBut11 addTarget:self action:@selector(RightMenth) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:rightBut11];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    NSString *age = [NSString stringWithFormat:@"%@", [userDic valueForKey:@"age"]];
    if (age) {
        NSArray *ages = [age componentsSeparatedByString:@"-"];
        if (ages.count>=1) {
            if ([[ages objectAtIndex:0] intValue]>=6) {
                rightBut11.hidden=YES;
            }
        }
    }
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
