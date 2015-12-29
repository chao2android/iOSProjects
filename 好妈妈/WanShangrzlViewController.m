//
//  WanShangrzlViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "WanShangrzlViewController.h"
#import "GerzxViewController.h"
#import "JSON.h"
@interface WanShangrzlViewController ()

@end

@implementation WanShangrzlViewController
@synthesize temp,titleString;
@synthesize contentTextField;
@synthesize citeArray;

- (void)dealloc
{
    [citeArray release];
    [contentTextField release];
    [temp release];
    [titleString release];
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
    navigationLabel.text=[[titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0];
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    self.contentTextField=[[[UITextField alloc]initWithFrame:CGRectMake(30, (KUIOS_7(44))+30, Screen_Width-60, 37)] autorelease];
    if (![[[titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:1] isEqualToString:@"(null)"]) {
        self.contentTextField.text=[[titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:1];
    }
    self.contentTextField.userInteractionEnabled=YES;
    self.contentTextField.delegate=self;
    self.contentTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentTextField setBackground:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"006_6" ofType:@"png"]]];
    self.contentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.contentTextField];
    if (ISIPAD) {
        self.contentTextField.frame=CGRectMake(30*1.4, 74*1.4, Screen_Width-30*1.4*2, 37*1.4);
        self.contentTextField.font=[UIFont systemFontOfSize:17*1.4];
    }
    if ([[[titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"修改地区"]) {
        UIButton * tapButton=[UIButton buttonWithType:UIButtonTypeCustom];
        tapButton.frame=CGRectMake(self.contentTextField.frame.origin.x, self.contentTextField.frame.origin.y, self.contentTextField.frame.size.width, self.contentTextField.frame.size.height);
        [tapButton addTarget:self action:@selector(TapMenth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tapButton];
        self.contentTextField.enabled=NO;

        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"txt"];
        NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        self.citeArray = [NSMutableArray arrayWithArray:[text JSONValue]];
        
        locatePicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, KUIOS_7(Screen_Height-200), Screen_Width, 180)];
        locatePicker.backgroundColor=[UIColor whiteColor];
        locatePicker.dataSource = self;
        locatePicker.delegate = self;
        locatePicker.showsSelectionIndicator=YES;
        [self.view addSubview:locatePicker];
        [locatePicker release];
        
        pickerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(locatePicker.frame.origin.x, locatePicker.frame.origin.y-35, locatePicker.frame.size.width, 35)];
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
            pickerBut.frame=CGRectMake(15+i*(pickerImageView.frame.size.width-47-30), 2.5, 47, 30);
            [pickerImageView addSubview:pickerBut];
            
        }
        
    }
}
- (void)TapMenth
{
    [UIView animateWithDuration:0.5 animations:^{
        locatePicker.frame=CGRectMake(0, KUIOS_7(Screen_Height-200), Screen_Width, 180);
        pickerImageView.frame=CGRectMake(locatePicker.frame.origin.x, locatePicker.frame.origin.y-35, locatePicker.frame.size.width, 35);
        
    }];
}
- (void)PickerMenth:(UIButton *)sender
{
    if (sender.tag) {
        
        if ([[[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"title"] length]&&[[[[[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"data"] objectAtIndex:[locatePicker selectedRowInComponent:1]] valueForKey:@"title"] length]) {
            
            
            self.contentTextField.text=[NSString stringWithFormat:@"%@ %@", [[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"title"],[[[[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"data"] objectAtIndex:[locatePicker selectedRowInComponent:1]] valueForKey:@"title"]];
        }
        else if ([[[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"title"] length])
        {
            self.contentTextField.text=[NSString stringWithFormat:@"%@", [[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"title"]];
        }
        else if ([[[[[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"data"] objectAtIndex:[locatePicker selectedRowInComponent:1]] valueForKey:@"title"] length])
        {
            self.contentTextField.text=[NSString stringWithFormat:@"%@",[[[[self.citeArray objectAtIndex:[locatePicker selectedRowInComponent:0]] valueForKey:@"data"] objectAtIndex:[locatePicker selectedRowInComponent:1]] valueForKey:@"title"]];
        }
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            locatePicker.frame=CGRectMake(0, Screen_Height+50, Screen_Width, 180);
            pickerImageView.frame=CGRectMake(locatePicker.frame.origin.x, locatePicker.frame.origin.y-35, locatePicker.frame.size.width, 35);
            
        }];
    }
}
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.citeArray count];
            break;
        case 1:
            return [[[self.citeArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"data"] count];
            break;
        default:
            return 0;
            break;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * pickerlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 30)];
    pickerlabel.backgroundColor=[UIColor clearColor];
    [pickerlabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    switch (component) {
        case 0:
            pickerlabel.text=[[self.citeArray objectAtIndex:row] valueForKey:@"title"];
            
            break;
        case 1:
            pickerlabel.text=[[[[self.citeArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"data"] objectAtIndex:row] valueForKey:@"title"];
            break;
        default:
            return [pickerlabel autorelease];
            break;
    }
    return [pickerlabel autorelease];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component)
    {
        case 0:
            [locatePicker reloadComponent:1];
            [locatePicker selectRow:0 inComponent:1 animated:YES];
            
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];
    if (![[[titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"修改地区"]) {
        
        [self.contentTextField becomeFirstResponder];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    (@"%@",self.titleString);
    if ([[[self.titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"个性签名"]) {
        if ([toBeString length] > 100) {
            return NO;
        }
    }
    else
    {
        if ([toBeString length] > 10) {
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GerzxViewController * grezx=(GerzxViewController *)self.temp;
    if ([[[self.titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"个性签名"]) {
        grezx.qianmingLabel.text=self.contentTextField.text;
        [grezx.oldDictionary setValue:self.contentTextField.text forKey:@"sign"];
        
    }
    else if([[[self.titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"修改昵称"])
    {
        grezx.nichengLabel.text=self.contentTextField.text;
        [grezx.oldDictionary setValue:self.contentTextField.text forKey:@"name"];
    }
    else
    {
        grezx.diquLabel.text=self.contentTextField.text;
        [grezx.oldDictionary setValue:self.contentTextField.text forKey:@"city"];
        
    }
    
    return YES;
}
- (void)backup
{
    GerzxViewController * grezx=(GerzxViewController *)self.temp;
    if ([[[self.titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"个性签名"]) {
        grezx.qianmingLabel.text=self.contentTextField.text;
        [grezx.oldDictionary setValue:self.contentTextField.text forKey:@"sign"];
        
    }
    else if([[[self.titleString componentsSeparatedByString:@"*)*)"] objectAtIndex:0] isEqualToString:@"修改昵称"])
    {
        grezx.nichengLabel.text=self.contentTextField.text;
        [grezx.oldDictionary setValue:self.contentTextField.text forKey:@"name"];
    }
    else
    {
        grezx.diquLabel.text=self.contentTextField.text;
        [grezx.oldDictionary setValue:self.contentTextField.text forKey:@"city"];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
