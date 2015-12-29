//
//  paoluanViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "paoluanViewController.h"
#import "OvulationViewController.h"

@interface paoluanViewController ()

@end

@implementation paoluanViewController

@synthesize mDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    self.mDate = nil;
    [super dealloc];
}

- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.91 alpha:1.0];
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KUIOS_7(44))];
    topView.backgroundColor = [UIColor blackColor];
    topView.userInteractionEnabled = YES;
    topView.image = [UIImage imageNamed:@"nav_background.png"];
    [self.view addSubview:topView];
    [topView release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"001_4.png"] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(0), topView.frame.size.width-200, 44)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = @"排卵期计算";
    lbTitle.textAlignment = UITextAlignmentCenter;
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [topView addSubview:lbTitle];
    [lbTitle release];
    
    int iLeft = (self.view.frame.size.width-320)/2;
    
    int iTop = KUIOS_7(54);
    if (ISIPAD) {
        iTop = KUIOS_7(100);
    }
    
    NSArray *array = [NSArray arrayWithObjects:@"上次月经时间", @"月经周期天数", nil];
    for (int i = 0; i < 2; i ++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(iLeft+10, iTop+60*i, 300, 48)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
        [self.view addSubview:backView];
        [backView release];
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, backView.frame.size.height)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.font = [UIFont systemFontOfSize:16];
        lbName.textColor = [UIColor grayColor];
        lbName.text = [NSString stringWithFormat:@"%@：", [array objectAtIndex:i]];
        [backView addSubview:lbName];
        [lbName release];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 0, backView.frame.size.width-130, backView.frame.size.height)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [UIColor grayColor];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [backView addSubview:textField];
        [textField release];
        if (i == 0) {
            mMensesDate = textField;
            mMensesDate.userInteractionEnabled = NO;
            mMensesDate.text = [self GetCurDate];
            self.mDate = [NSDate date];
            
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame = textField.frame;
            [backBtn addTarget:self action:@selector(SelectDateTime) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:backBtn];
        }
        else {
            mMensesLength = textField;
            mMensesLength.text = @"28";
        }
    }
    
    UIImage *image = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake((self.view.frame.size.width-130)/2, iTop+120, 130, 40);
    [commitBtn setBackgroundImage:image forState:UIControlStateNormal];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [commitBtn addTarget:self action:@selector(OnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (NSString *)GetCurDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self RemoveDateView];
}

- (void)RemoveDateView {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (mDateView) {
        [mDateView removeFromSuperview];
        mDateView = nil;
    }
    [pool release];
}

- (void)SelectDateTime {
    [self RemoveDateView];
    [mMensesLength resignFirstResponder];
    mDateView = [[DatePickerSelectView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 260)];
    mDateView.delegate = self;
    mDateView.OnDateSelect = @selector(OnSelectDateTime:);
    mDateView.OnDateCancel = @selector(OnCancelDateTime:);
    mDateView.mDateView.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:mDateView];
    [mDateView release];
}

- (void)OnSelectDateTime:(DatePickerSelectView *)sender {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    mMensesDate.text = [formatter stringFromDate:sender.mDate];
    self.mDate = sender.mDate;
    [self RemoveDateView];
}

- (void)OnCancelDateTime:(DatePickerSelectView *)sender {
    
    [self RemoveDateView];
}

- (void)OnButtonClick {
    if (!self.mDate) {
        [self AutoAlert:@"提示" msg:@"请选择上次月经时间"];
        return;
    }
    if (!mMensesLength.text || mMensesLength.text.length == 0) {
        [self AutoAlert:@"提示" msg:@"请选择月经周期"];
        return;
    }
    
    int tmp = [mMensesLength.text intValue];
    if (tmp < 24 || tmp > 35) {
        [self AutoAlert:@"提示" msg:@"月经周期在24天到35天之间"];
        return;

    }
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *datestr = [formatter stringFromDate:self.mDate];
    self.mDate = [formatter dateFromString:datestr];
    
    OvulationViewController *ctrl = [[OvulationViewController alloc] init];
    ctrl.mDate = self.mDate;
    ctrl.miOffset = [mMensesLength.text intValue];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)AutoAlert:(NSString *)title msg:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

@end
