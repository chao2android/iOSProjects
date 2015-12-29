//
//  xingbieViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "xingbieViewController.h"

#import "GRAlertView.h"

@interface xingbieViewController ()

@end

@implementation xingbieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"xingbie" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    _arr = [[NSArray alloc]initWithArray:arr];
    
    if (ISIPAD) {
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.89 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底.png"]];
    }
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:backBut];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(0), self.view.frame.size.width-200, 44)];
    titLab.text = @"生男生女";
    titLab.textAlignment = 1;
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [navigation addSubview:titLab];
    [titLab release];
    
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height-44)];
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    int height = 0;
    
    bgView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"001_22.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:40]];
    bgView.userInteractionEnabled = YES;
    bgView.tag = 1000;
    
    //  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    //  [bgView addGestureRecognizer:singleTap];
    //  [singleTap release];
    [_scrollView addSubview:bgView];
    [bgView release];
     
    int iLeft = (self.view.frame.size.width-320)/2;
   
    woButton=[UIButton buttonWithType:UIButtonTypeCustom];
    woButton.frame=CGRectMake(20+iLeft, 10, 25, 25);
    [woButton addTarget:self action:@selector(YuceLeiXingMenth) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:woButton];
    UILabel * woLabel=[[UILabel alloc]initWithFrame:CGRectMake(woButton.frame.origin.x+woButton.frame.size.width+5, 15, 80, 20)];
    woLabel.text=@"帮我测试";
    woLabel.textColor=[UIColor blackColor];
    woLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:woLabel];
    [woLabel release];
    
    haoyouButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [haoyouButton addTarget:self action:@selector(YuceLeiXingMenth) forControlEvents:UIControlEventTouchUpInside];
    haoyouButton.frame=CGRectMake(Screen_Width-20-iLeft-25-90, 10, 25, 25);
    [bgView addSubview:haoyouButton];
    UILabel * haoyouLabel=[[UILabel alloc]initWithFrame:CGRectMake(haoyouButton.frame.origin.x+haoyouButton.frame.size.width+5, 15, 90, 20)];
    haoyouLabel.text=@"帮好友测试";
    haoyouLabel.textColor=[UIColor blackColor];
    haoyouLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:haoyouLabel];
    [haoyouLabel release];
    userDic=[[NSDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"]];
    NSLog(@"%@",userDic);
       UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10+iLeft, 30+15, 290, 40)];
    lab1.textAlignment = 0;
    lab1.text = @"  孕妈的生日：";
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1];
    [bgView addSubview:lab1];
    [lab1 release];
    
    CALayer* l1=[lab1 layer];
    [l1 setMasksToBounds:YES];
    //  [l1 setCornerRadius:6];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
    

    
    tf1=[UIButton buttonWithType:UIButtonTypeCustom];
    tf1.frame=CGRectMake(130+iLeft, 30+15, 140, 40);
    [tf1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tf1 addTarget:self action:@selector(Tf1Menth) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:tf1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10+iLeft, 50+40, 290, 40)];
    lab2.textAlignment = 0;
    lab2.backgroundColor = [UIColor clearColor];
    lab2.text = @"         预产期：";
    lab2.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1];
    [bgView addSubview:lab2];
    [lab2 release];
    
    l1 =[lab2 layer];
    [l1 setMasksToBounds:YES];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor grayColor]CGColor] ];
    
//    tf2 = [[UITextField alloc]initWithFrame:CGRectMake(130+iLeft, 50+40, 140, 40 )];
//    //  tf2.borderStyle = UITextBorderStyleLine;
//    tf2.delegate = self;
//    tf2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    tf2.textColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1];
//    tf2.keyboardType = UIKeyboardTypeNumberPad;
////    tf2.placeholder = @"      1月 ~ 12月";
//    //  tf2.text = @"1月 ~ 12月";
//    tf2.tag = 2001;
//    tf2.clearsOnBeginEditing = YES;
//    [bgView addSubview:tf2];
//    [tf2 release];
    tf2=[UIButton buttonWithType:UIButtonTypeCustom];
    [tf2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tf2.frame=CGRectMake(130+iLeft, 50+40, 140, 40);
    [tf2 addTarget:self action:@selector(Tf2Menth) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:tf2];
    if ([[userDic valueForKey:@"type"] intValue]==2) {
        xingbieBool=NO;
        [woButton setImage:[UIImage imageNamed:@"xingbie1.png"] forState:UIControlStateNormal];
        [haoyouButton setImage:[UIImage imageNamed:@"xingbie2.png"] forState:UIControlStateNormal];
        tf2.userInteractionEnabled=NO;
        [tf2 setTitle:[userDic valueForKey:@"birthday"] forState:UIControlStateNormal];
    }
    else
    {
        xingbieBool=YES;
        [woButton setImage:[UIImage imageNamed:@"xingbie2.png"] forState:UIControlStateNormal];
        [haoyouButton setImage:[UIImage imageNamed:@"xingbie1.png"] forState:UIControlStateNormal];
    }
    

    UIImage *image = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    
    tuisuanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tuisuanBut.frame=CGRectMake(90+iLeft, 100+40, 130, 40);
    [tuisuanBut addTarget:self action:@selector(clicked_tuisuanBut) forControlEvents:UIControlEventTouchUpInside];
    [tuisuanBut setBackgroundImage:image forState:UIControlStateNormal];
    [tuisuanBut setTitle:@"推   算" forState:UIControlStateNormal];
    [tuisuanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tuisuanBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [bgView addSubview:tuisuanBut];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(5+iLeft, 150+40, 300, 1)];
    lineLab. backgroundColor = [UIColor grayColor];
    lineLab.alpha = 0.5f;
    [bgView addSubview:lineLab];
    [lineLab release];
    
    
    UIImage *image2 = [UIImage imageNamed:@"004_10.png"];
    
    jgBut=[UIButton buttonWithType:UIButtonTypeCustom];
    jgBut.frame=CGRectMake(80+iLeft, 160+40, 150, 30);
    [jgBut setBackgroundImage:image2 forState:UIControlStateNormal];
    [jgBut setTitle:@"推算结果" forState:UIControlStateNormal];
    [jgBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jgBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [bgView addSubview:jgBut];
    
    jgLab  = [[UILabel alloc]initWithFrame:CGRectMake(5+iLeft,190+40, 300,30)];
    jgLab.backgroundColor = [UIColor clearColor];
    jgLab.textColor = [UIColor grayColor];
    jgLab.text = @"根据生男生女清宫图，您怀的可能是：";
    [bgView addSubview:jgLab];
    jgLab.numberOfLines = 0;
    [jgLab release];
    
    jgView = [[UIImageView alloc]initWithFrame:CGRectMake(80+iLeft, 220+40, 50, 50)];
    jgView.image = [UIImage imageNamed:@"004_男.png"];
    [bgView addSubview:jgView];
    [jgView release];
    
    jgLabJg = [[UILabel alloc]initWithFrame:CGRectMake(135+iLeft, 220+40, 150, 50)];
    jgLabJg.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background"]];
    jgLabJg.font = [UIFont boldSystemFontOfSize:38];
    jgLabJg.backgroundColor = [UIColor clearColor];
    jgLabJg.text = @"男孩";
    [bgView addSubview:jgLabJg];
    [jgLabJg release];
    
//    jgBut.hidden = YES;
//    jgLab.hidden = YES;
//    jgView.hidden = YES;
//    jgLabJg.hidden = YES;
    
    int iHeight = 1020;
    iLeft = 5;
    if (ISIPAD) {
        iLeft = 20;
        iHeight = 500;
    }
    shuomingLab = [[UILabel alloc]initWithFrame:CGRectMake(iLeft, 158+40, self.view.frame.size.width-10-iLeft*2,iHeight)];
    shuomingLab.numberOfLines = 0;
    shuomingLab.text = @"说明：\n\n　　本预测依照阴阳五行易理所设计的《清宫图》计算。本预测准确率高达50%，结果仅供参考。\n\n　　《清宫图》是清代宫廷的太医们根据经验总结出来的一套预测生育的方法，当时专供清朝皇帝、王爷、后妃所使用，民国后流传到民间。\n\n　　专家表示，所谓“清宫秘笈”充其量只能算是一个统计表，没有任何科学性。概括来说，生男生女都只是机率的问题。\n\n　　人体细胞内共有23对46条染色体。其中22对(44条)染色体男女完全相同，叫做“常染色体”。剩下的一对染色体，男性和女性的组合方式不同，叫做“性染色体”。女性的性染色体由两条X染色体配对而成，男性的性染色体则由一条X染色体和一条Y染色体配对而成。Y染色体的体积很小，大约是X染色体的三分之一。“性染色体”的差异造就了我们的不同性别。\n\n　　新生儿具有来自母亲的23条染色体和来自父亲的23条染色体。由于母亲只提供X染色体，所以，决定孩子性别的不是母亲而是父亲。男性产生的精子半数性染色体是X，半数是Y，在精子和卵子结合的一瞬间决定了将来孩子的性别。理论上男孩和女孩的数量应该是各占50%，但实际上每100个新生儿中大约有51.3个男孩、48.7个女孩，这个比例在各个国家都大体相同。社会中男性的数量总是会略多于女性的数量。对于这个现象，科学家给了一个非常形象的解释，Y染色体的体积较小体重较轻，因此它“跑”得会比较快，从而有机会更快地和卵子结合。\n\n　　所以，两个X染色体结合还是一个X染色体和一个Y染色体结合，无法人为控制!";
    shuomingLab.textColor = [UIColor grayColor];
    shuomingLab.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:shuomingLab];
    
    shuomingLab.tag = 1001;
    [shuomingLab release];
    
    
    height = shuomingLab.frame.origin.y + shuomingLab.frame.size.height +15;
    
    bgView.frame = CGRectMake(5, 5, self.view.frame.size.width-10, height);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height +30);
    myPickerView=[[[UIPickerView alloc]initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 150)] autorelease];
    myPickerView.backgroundColor=[UIColor whiteColor];
    myPickerView.delegate=self;
    myPickerView.dataSource=self;
    myPickerView.showsSelectionIndicator=YES;
    [self.view addSubview:myPickerView];
   
}
- (void)Tf2Menth
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    for (int i=0; i<[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] count]; i++) {
        if (i==0) {
            [myPickerView selectRow:0 inComponent:0 animated:NO];

        }
        else
        {
        [myPickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:i] intValue]-1 inComponent:i animated:NO];
        }
    }

    buttonTag=2;
    CGRect aRect=CGRectMake(0, Screen_Height-150-30, Screen_Width, 150);
    [UIView animateWithDuration:0.5 animations:^{
        myPickerView.frame=aRect;
    }];
    [myPickerView reloadAllComponents];

}
- (void)Tf1Menth
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    for (int i=0; i<[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] count]; i++) {
        if (i) {
            [myPickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:i] intValue]-1 inComponent:i animated:NO];

        }
        else
        {
           [myPickerView selectRow:44 inComponent:i animated:NO];
        }
    }

    buttonTag=1;
   CGRect aRect=CGRectMake(0, Screen_Height-150-30, Screen_Width, 150);
  [UIView animateWithDuration:0.5 animations:^{
    myPickerView.frame=aRect;
}];
    [myPickerView reloadAllComponents];

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        if (buttonTag==2) {
            
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY"];
        NSString* date = [formatter stringFromDate:[NSDate date]];
        NSLog(@"%d",[date intValue]-60);
        [formatter release];
        return [date intValue];
        }
        else
        {
            return 45;
        }
    }
    else if (component==1)
    {
        return 12;
    }
    
    return 31;
}
-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    int fontSize = 25;
    CGRect rect = CGRectMake(0.0, 0.0, 100, 50);
    UILabel *myView = [[[UILabel alloc] initWithFrame:rect] autorelease];
    myView.textAlignment = UITextAlignmentCenter;
    myView.font = [UIFont boldSystemFontOfSize:fontSize];
    myView.backgroundColor = [UIColor clearColor];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];

    
    if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:component] intValue]==row+1) {
        
        myView.textColor=[UIColor blueColor];
        myView.userInteractionEnabled=YES;
    }
    else
    {
        if ([pickerView selectedRowInComponent:1]==1)
        {
            if ((([pickerView selectedRowInComponent:0]+1)%4==0&&([pickerView selectedRowInComponent:0]+1)%100)||([pickerView selectedRowInComponent:0]+1)%400==0)
            {
                if (row==29||row==30)
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
            }
            else
            {
                if (row==28||row==29||row==30)
                {
                    myView.textColor=[UIColor grayColor];
                    myView.userInteractionEnabled=NO;
                }
            }
        }
        else if (([pickerView selectedRowInComponent:1]==3||[pickerView selectedRowInComponent:1]==5||[pickerView selectedRowInComponent:1]==8||[pickerView selectedRowInComponent:1]==10)&&row==30)
        {
            myView.textColor=[UIColor grayColor];
            myView.userInteractionEnabled=NO;
        }
        else
        {
            myView.userInteractionEnabled=YES;
            myView.textColor=[UIColor blackColor];
        }
        
        if (component==1)
        {
            if (component==0&&row+1>[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])
            {
                myView.textColor=[UIColor grayColor];
                myView.userInteractionEnabled=NO;
            }
            
            
        }
        else if(component==2)
        {
            NSDate *newdate = [NSDate dateWithTimeInterval:3600*24*252 sinceDate:[NSDate date]];
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
            NSString * str = [dateFormatter stringFromDate:newdate];
            
            
            
            if ((component==0&&row+1<=[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue])||(component==0&&row+1>[[[[[str componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]))
            {
                myView.textColor=[UIColor grayColor];
                myView.userInteractionEnabled=NO;
            }
            
                       
        }
        
    }
    if (buttonTag==2) {
        
    
    if (!component)
       {
        myView.text = [NSString stringWithFormat:@"%d",row+[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:component] intValue]-1];
        if (row==0) {
            myView.textColor=[UIColor blueColor];

        }
        else
        {
            myView.textColor=[UIColor blackColor];

        }
    }
    else
    {
      myView.text = [NSString stringWithFormat:@"%d",row+1];
    }
    }
    else
    {
        if (!component) {
            [formatter setDateFormat:@"YYYY"];
            NSString* dateString = [formatter stringFromDate:[NSDate date]];
            myView.text = [NSString stringWithFormat:@"%d",[dateString intValue]-59+row];
        }
        else
        {
        myView.text = [NSString stringWithFormat:@"%d",row+1];
        }

    }
    [formatter release];
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSMutableString * butString=[[NSMutableString alloc]initWithCapacity:1];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    
    if ([pickerView selectedRowInComponent:1]==1)
    {
        if ((([pickerView selectedRowInComponent:0]+1)%4==0&&([pickerView selectedRowInComponent:0]+1)%100)||([pickerView selectedRowInComponent:0]+1)%400==0)
        {
            if ([pickerView selectedRowInComponent:2]>28)
            {
                
                [pickerView selectRow:28 inComponent:2 animated:YES];
            }
        }
        else
        {
            if ([pickerView selectedRowInComponent:2]>27)
            {
                
                [pickerView selectRow:27 inComponent:2 animated:YES];
            }
        }
    }
    
    else if (([pickerView selectedRowInComponent:1]==3||[pickerView selectedRowInComponent:1]==5||[pickerView selectedRowInComponent:1]==8||[pickerView selectedRowInComponent:1]==10)&&[pickerView selectedRowInComponent:2]==30) {
        [pickerView selectRow:29 inComponent:2 animated:YES];
    }

    if (buttonTag==2) {
       
        if ([pickerView selectedRowInComponent:0]==0) {
            if ([pickerView selectedRowInComponent:1]<[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]) {
                [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]-1 inComponent:1 animated:YES];
                if ([pickerView selectedRowInComponent:2]<[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]) {
                    
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];

                }
            }
            
        }



        [butString appendFormat:@"%d-",[pickerView selectedRowInComponent:0]+[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]-1];
        [butString appendFormat:@"%d-",[pickerView selectedRowInComponent:1]+1];
        [butString appendFormat:@"%d",[pickerView selectedRowInComponent:2]+1];
        [tf2 setTitle:butString forState:UIControlStateNormal];

    }
    else
    {
        NSLog(@"%d   %d",component,[pickerView selectedRowInComponent:component]);
        if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]<[pickerView selectedRowInComponent:0]+1)
        {
            [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]-1 inComponent:0 animated:YES];
            
        }
        else if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]==[pickerView selectedRowInComponent:0]+1)
        {
            if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]<[pickerView selectedRowInComponent:1]+1)
            {
                
                [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]-1 inComponent:1 animated:YES];
                if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<=[pickerView selectedRowInComponent:2]+1)
                {
                    
                    
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }
                
            }
            else if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]==[pickerView selectedRowInComponent:1]+1)
            {
                if ([[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]<[pickerView selectedRowInComponent:2]+1)
                {
                    [pickerView selectRow:[[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue]-1 inComponent:2 animated:YES];
                }
            }
            
        }
        [formatter setDateFormat:@"YYYY"];
        NSString* dateString = [formatter stringFromDate:[NSDate date]];
        [butString appendFormat:@"%d-",[pickerView selectedRowInComponent:0]+[dateString intValue]-59];
        [butString appendFormat:@"%d-",[pickerView selectedRowInComponent:1]+1];
        [butString appendFormat:@"%d",[pickerView selectedRowInComponent:2]+1];
        [tf1 setTitle:butString forState:UIControlStateNormal];
    }
    [formatter release];
    [butString release];
    
    
}


- (void)YuceLeiXingMenth
{
    tf1.titleLabel.text=nil;
    tf2.titleLabel.text=nil;
    [tf1 setTitle:nil forState:UIControlStateNormal];
    [tf2 setTitle:nil forState:UIControlStateNormal];
    if ([bgView viewWithTag:1000000]) {
        [[bgView viewWithTag:1000000] removeFromSuperview];
    }
        shuomingLab.frame = CGRectMake(shuomingLab.frame.origin.x, 158+40, shuomingLab.frame.size.width,shuomingLab.frame.size.height);
    
      CGFloat height = shuomingLab.frame.origin.y + shuomingLab.frame.size.height +15;
        bgView.frame = CGRectMake(5, 5, self.view.frame.size.width-10, height);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height +30);
      

    if (xingbieBool) {
        [woButton setImage:[UIImage imageNamed:@"xingbie1"] forState:UIControlStateNormal];
        [haoyouButton setImage:[UIImage imageNamed:@"xingbie2"] forState:UIControlStateNormal];
        
        if ([[userDic valueForKey:@"type"] intValue]==2) {
            tf2.userInteractionEnabled=NO;
            [tf2 setTitle:[userDic valueForKey:@"birthday"] forState:UIControlStateNormal];
        }

    }
    else
    {
        tf2.userInteractionEnabled=YES;
        [tf2 setTitle:@"" forState:UIControlStateNormal];

        [woButton setImage:[UIImage imageNamed:@"xingbie2"] forState:UIControlStateNormal];
        [haoyouButton setImage:[UIImage imageNamed:@"xingbie1"] forState:UIControlStateNormal];
    }
    xingbieBool=!xingbieBool;
}

-(void)clicked_tuisuanBut{
    
    CGRect aRect=CGRectMake(0, Screen_Height, Screen_Width, 150);
    [UIView animateWithDuration:0.5 animations:^{
        myPickerView.frame=aRect;
    }];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    if (tf1.titleLabel.text != nil&&tf2 .titleLabel.text != nil&&![tf1.titleLabel.text isEqualToString:@""]&&![tf2.titleLabel.text isEqualToString:@""]) {
        NSLog(@"%@   %@    %@ %@",tf1.titleLabel.text,tf2.titleLabel.text,date,[[tf2.titleLabel.text componentsSeparatedByString:@"-"] objectAtIndex:1]);

        
        int month = [[[tf2.titleLabel.text componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
    
//        if (month>0&& month <13 ) {
//            NSLog(@"%d",month);
//            
            NSDictionary *dic = _arr[month-1];
        NSLog(@"%@",dic);
            int years = [[[[[date componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]-[[[tf1.titleLabel.text componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
        years++;
    if (years<17) {
        years=17;
    }
    else if (years>44)
    {
        years=44;
    }
//            if (years >17&&  years <46) {
                NSString *xbStr = dic[[NSString stringWithFormat:@"%d",years+1]];
        NSLog(@"%@",xbStr);
                NSString *xbImage;
                if ([xbStr isEqualToString:@"男"]) {
                    xbImage = @"004_男.png";
                }else{
                    xbImage = @"004_女.png";
                }
    
                
                jgView.image = [UIImage imageNamed:xbImage];
                jgLabJg.text = [NSString stringWithFormat:@"%@孩",xbStr];
                int iHeight = 850;
                int iLeft = 5;
                if (ISIPAD) {
                    iLeft = 20;
                    iHeight = 450;
                }
                [UIView animateWithDuration:1 animations:^{
                shuomingLab.frame = CGRectMake(shuomingLab.frame.origin.x, 285+40, shuomingLab.frame.size.width,shuomingLab.frame.size.height);

                } completion:^(BOOL  an){
                    CGFloat height = shuomingLab.frame.origin.y + shuomingLab.frame.size.height +15;
                    bgView.frame = CGRectMake(5, 5, self.view.frame.size.width-10, height);
                    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height +30);
                    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 277+40, bgView.frame.size.width-10, 1)];
                    lineLab. backgroundColor = [UIColor grayColor];
                    lineLab.alpha = 0.5f;
                    lineLab.tag=1000000;
                    [bgView addSubview:lineLab];
                    [lineLab release];
                }];
                
                
                
    
            
    
        
        
        
        
    }else{
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"信息还没有输全哦！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
    }

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    tuisuanBut.enabled = YES;
    return  YES;//NO进入不了编辑模式
}

-(void)clicked_backBut{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)UesrClicked:(id)sender{
    [tf2 resignFirstResponder];
    [tf1 resignFirstResponder];
    
}


-(void)dealloc{
    [super dealloc];
    [_arr release];
}
@end
