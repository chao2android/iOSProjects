//
//  JYProfileEditDetailController.m
//  friendJY
//
//  Created by chenxiangjing on 15/4/7.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileEditDetailController.h"
#import "JYAppDelegate.h"
#import "JYShareData.h"
@interface JYProfileEditDetailController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *mypickerView;
    UIDatePicker *mydatePicker;
    UIView *pickerViewBg;
    NSInteger pickerSelectRowInZeroComponent;
    NSInteger pickerSelectRowInOneComponent;
    NSDictionary *profileOptionDic;
    UILabel *contentLab;
    NSDate *birthday;
    NSInteger selectedIndex;
    UIImageView *chooseImgV;
 
}
@end

@implementation JYProfileEditDetailController

//- (void)setProfileDataDic:(NSMutableDictionary *)profileDataDic{
//    [_profileDataDic removeAllObjects];
//    _profileDataDic = nil;
//    _profileDataDic = [NSMutableDictionary dictionaryWithDictionary:profileDataDic];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    birthday = [NSDate date];
//    _profileDataDic = [NSMutableDictionary dictionaryWithDictionary:[JYShareData sharedInstance].myself_profile_dict];
    profileOptionDic = [JYShareData sharedInstance].profile_dict;

    if (_editType == 2) {
        NSString *provinceStr = [[JYShareData sharedInstance].province_code_dict objectForKey:[_profileDataDic objectForKey:@"live_location"]];
        
        pickerSelectRowInZeroComponent = [[JYShareData sharedInstance].province_array indexOfObject:provinceStr];
        if (pickerSelectRowInZeroComponent >= 36) {
            pickerSelectRowInZeroComponent = 0;
        }
    }
    [self initSubViews];
    // Do any additional setup after loading the view.
}
- (void)initSubViews{
//    UIButton *createGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [createGroupBtn setFrame:CGRectMake(0, 0, 65, 44)];
//    [createGroupBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [createGroupBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
//    [createGroupBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
//    [createGroupBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
//    [createGroupBtn addTarget:self action:@selector(completeSelectAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:createGroupBtn]];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(completeSelectAction)];
    //如果是情感状态编辑 初始化情感编辑视图并返回
    if (_editType == 1) {
        selectedIndex = 1;
        [self initMarriageView];
        return;
    }
    
    UIView *editBg = [[UIView alloc] initWithFrame:CGRectMake(-1, 33, kScreenWidth+2, 50)];
    editBg.backgroundColor = [UIColor whiteColor];
    editBg.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    editBg.layer.borderWidth = 1;
    [self.view addSubview:editBg];
    
    //栏目标题
    CGFloat width = _editType == 1 ? 80 : 40;
    UILabel * districtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, width, 20)];
    districtLabel.textAlignment = NSTextAlignmentLeft;
    districtLabel.backgroundColor = [UIColor clearColor];
    districtLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    districtLabel.font = [UIFont systemFontOfSize:15];
    
    NSString *columText;
    switch (_editType) {
//        case 1:
//            columText = @"情感状态";
//            break;
        case 2:
            columText = @"地区";
            break;
        case 3:
            columText = @"生日";
            break;
        case 4:
            columText = @"身高";
            break;
        case 5:
            columText = @"体重";
            break;
        case 6:
            columText = @"职业";
            break;
        default:
            break;
    }
    if (columText == nil) {
        columText = @"请点击选择";
    }
    districtLabel.text = columText;
    [editBg addSubview:districtLabel];
    //当前栏目对应的内容
    contentLab = [[UILabel alloc] initWithFrame:CGRectMake( districtLabel.right,  districtLabel.top, 200, 20)];
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    contentLab.font = [UIFont systemFontOfSize:15];
    contentLab.text = _contentText;
    contentLab.userInteractionEnabled = YES;
    [editBg addSubview:contentLab];
    [editBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intoSetModel)]];
    
    //更多箭头
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMore setUserInteractionEnabled:YES];
    [btnMore setFrame:CGRectMake(kScreenWidth-20, contentLab.top+3, 8, 13)];
    [btnMore setBackgroundImage:[UIImage imageNamed:@"more_gray"] forState:UIControlStateNormal];
    [btnMore setBackgroundImage:[UIImage imageNamed:@"more_blue"] forState:UIControlStateHighlighted];
    [btnMore addTarget:self action:@selector(intoSetModel) forControlEvents:UIControlEventTouchUpInside];
    [editBg addSubview:btnMore];
    
    //以下是滚轮显示
    pickerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [pickerViewBg setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    [pickerViewBg setBackgroundColor:[UIColor clearColor]];
    [pickerViewBg setUserInteractionEnabled:YES];
    
    [pickerViewBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDone)]];
  
    mydatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight-217, kScreenWidth, 217)];
    [mydatePicker setBackgroundColor:[UIColor whiteColor]];
    [mydatePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [mydatePicker setMaximumDate:[NSDate date]];
    [components setYear:-50];
    [mydatePicker setMinimumDate:[gregorian dateByAddingComponents:components toDate:currentDate options:0]];
    if ([[_profileDataDic objectForKey:@"birthday"] isEqualToString:@"0000-00-00"]) {
        [mydatePicker setDate:[NSDate date]];
    }else{
        NSString *dateString = [_profileDataDic objectForKey:@"birthday"];
        NSString *curStr = [dateString substringWithRange:NSMakeRange(0, 4)];
        NSInteger yeardigit = [curStr integerValue];
        curStr = [dateString substringWithRange:NSMakeRange(5, 2)];
        NSInteger monthdigit = [curStr integerValue];
        curStr = [dateString substringWithRange:NSMakeRange(8, 2)];
        NSInteger daydigit = [curStr integerValue];
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        [dateComps setYear:yeardigit];
        [dateComps setMonth:monthdigit];
        [dateComps setDay:daydigit];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *mydate = [calendar dateFromComponents:dateComps];
        [mydatePicker setDate:mydate];
    }
    
    [mydatePicker addTarget:self action:@selector(datePickerChangeAction:) forControlEvents:UIControlEventValueChanged];
    [pickerViewBg addSubview:mydatePicker];
    
    mypickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-217, kScreenWidth, 217)];
    [mypickerView setBackgroundColor:[UIColor whiteColor]];
    [mypickerView setDelegate:self];
    [mypickerView setDataSource:self];
    [pickerViewBg addSubview:mypickerView];
    
//    UIView *pickerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, mypickerView.top - 20, kScreenWidth, 20)];
//    [pickerTopView setBackgroundColor:[UIColor whiteColor]];
//    
//    UIButton *selectDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [selectDoneBtn setFrame:CGRectMake(kScreenWidth - 15 - 30, 5, 30, pickerTopView.height - 5)];
//    [selectDoneBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [selectDoneBtn addTarget:self action:@selector(selectDone) forControlEvents:UIControlEventTouchUpInside];
//    [selectDoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [selectDoneBtn setTitleColor:kTextColorBlack forState:UIControlStateNormal];
//    [pickerTopView addSubview:selectDoneBtn];
//    [pickerViewBg addSubview:pickerTopView];

}

//只有情感状态编辑才会初始化这个界面
- (void)initMarriageView{
    //背景视图
    UIView *sectionBg = [[UIView alloc] initWithFrame:CGRectMake(-1, 34, kScreenWidth+2, 50*4)];
    [sectionBg setBackgroundColor:[UIColor whiteColor]];
    sectionBg.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionBg.layer.borderWidth = 1;
    [self.view addSubview:sectionBg];
    
    //循环创建4个选项
    NSDictionary *dataDic = [profileOptionDic objectForKey:@"marriage"];
    for ( int i = 1; i <= dataDic.count; i++) {
        UIView *editBg = [[UIView alloc] initWithFrame:CGRectMake(0, 50*(i - 1), kScreenWidth, 50)];
        UILabel *marriageStatus = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
        [editBg setTag:1000+i];
        [editBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marriageStatusChanged:)]];
        
        marriageStatus.textAlignment = NSTextAlignmentLeft;
        marriageStatus.backgroundColor = [UIColor clearColor];
        marriageStatus.textColor = [JYHelpers setFontColorWithString:@"#303030"];
        marriageStatus.font = [UIFont systemFontOfSize:15];
        marriageStatus.text = [[profileOptionDic objectForKey:@"marriage"] objectForKey:[NSString stringWithFormat:@"%d",i]];
        marriageStatus.userInteractionEnabled = YES;
        [editBg addSubview:marriageStatus];
        //用户情感状态对应的选中状态的 对勾
        if (i == [[_profileDataDic objectForKey:@"marriage"] intValue]) {
            chooseImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 14, 34 + 19.5 + (i - 1)*50, 14, 11)];
            [chooseImgV setImage:[UIImage imageNamed:@"set_choose"]];
            [chooseImgV setUserInteractionEnabled:YES];
            [chooseImgV setTag:1234];
            [self.view addSubview:chooseImgV];
            selectedIndex = i;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
        line.layer.borderWidth = 1;
        line.layer.borderColor = [[JYHelpers setFontColorWithString:@"#edf1f4"] CGColor];
        [editBg addSubview:line];
        [sectionBg addSubview:editBg];
    }
    
}
//进入pickerView设置界面
- (void)intoSetModel{
    
    switch (_editType) {
//        case 1:
//        {
//            [mydatePicker setHidden:YES];
//            [mypickerView setHidden:NO];
//        
//            [self showPicker:YES];
//            if ([[_profileDataDic objectForKey:@"marriage"] intValue] >0) {
//                [mypickerView selectRow:[[_profileDataDic objectForKey:@"marriage"] intValue]-1 inComponent:0 animated:YES];
//                [self pickerView:mypickerView didSelectRow:[[_profileDataDic objectForKey:@"marriage"] intValue]-1 inComponent:0];
//            }
//        }
//            break;
        case 2:
        {
            NSString *provinceStr = [[JYShareData sharedInstance].province_code_dict objectForKey:[_profileDataDic objectForKey:@"live_location"]];
            NSString *cityStr = [[JYShareData sharedInstance].city_code_dict objectForKey:[_profileDataDic objectForKey:@"live_sublocation"]];
        
            [mydatePicker setHidden:YES];
            [mypickerView setHidden:NO];
            [self showPicker:YES];
            if ([[_profileDataDic objectForKey:@"live_location"] intValue] >0) {
        
                for (int i = 0; i<[JYShareData sharedInstance].province_array.count; i++) {
                    if ([provinceStr isEqualToString:[[JYShareData sharedInstance].province_array objectAtIndex:i]]) {
                        pickerSelectRowInZeroComponent = i;
                        [mypickerView selectRow:i inComponent:0 animated:YES];
                        break;
                    }
                }
        
            }else{
                [self pickerView:mypickerView didSelectRow:0 inComponent:0];
            }
        
            if ([[_profileDataDic objectForKey:@"live_sublocation"] intValue] >0) {
                NSInteger cityNum = ((NSArray *)[[JYShareData sharedInstance].city_array objectAtIndex:pickerSelectRowInZeroComponent]).count;
                for (int i = 0; i<cityNum; i++) {
                    if ([cityStr isEqualToString:[[[JYShareData sharedInstance].city_array objectAtIndex:pickerSelectRowInZeroComponent] objectAtIndex:i]] ) {
                        pickerSelectRowInOneComponent = i;
                        break;
                    }
                }
            }else{
                [mypickerView selectRow:0 inComponent:1 animated:YES];
            }
        }
            break;
        case 3:
        {
            [mydatePicker setHidden:NO];
            [mypickerView setHidden:YES];
            [self datePickerChangeAction:mydatePicker];
            [self showPicker:YES];
        }
            break;
        case 4:
        {
            [mydatePicker setHidden:YES];
            [mypickerView setHidden:NO];
            [self showPicker:YES];
            if ([[_profileDataDic objectForKey:@"height"] intValue] >0) {
                [mypickerView selectRow:[[_profileDataDic objectForKey:@"height"] intValue]-1 inComponent:0 animated:YES];
                
            }else{
                [self pickerView:mypickerView didSelectRow:0 inComponent:0];
            }
        }
            break;
        case 5:
        {
            [mydatePicker setHidden:YES];
            [mypickerView setHidden:NO];
            [self showPicker:YES];
            if ([[_profileDataDic objectForKey:@"weight"] intValue] >0) {
                [mypickerView selectRow:[[_profileDataDic objectForKey:@"weight"] intValue]-1 inComponent:0 animated:YES];
            }else{
                [self pickerView:mypickerView didSelectRow:0 inComponent:0];
            }
        }
            break;
        case 6:
        {
            [mydatePicker setHidden:YES];
            [mypickerView setHidden:NO];
            [self showPicker:YES];
            if ([[_profileDataDic objectForKey:@"career"] intValue] >0) {
                [mypickerView selectRow:[[_profileDataDic objectForKey:@"career"] intValue]-1 inComponent:0 animated:YES];
                
            }else{
                [self pickerView:mypickerView didSelectRow:0 inComponent:0];
            }
        }
            break;
        default:
            break;
    }
    
}
//pickerView完成选择
- (void)selectDone{
    
    [self showPicker:NO];
}
- (void)backAction{
    [self completeSelectAction];
}
//保存并返回
- (void)completeSelectAction{

    //   当前选中内容
    NSString *text = nil;
    if (_editType == 1) {
        text = [[profileOptionDic objectForKey:@"marriage"] objectForKey:[NSString stringWithFormat:@"%ld",(long)selectedIndex]];
        [_profileDataDic setObject:[NSString stringWithFormat:@"%ld",(long)selectedIndex] forKey:@"marriage"];
    }else
        text = contentLab.text;
    if ([_contentText isEqualToString:text]) {//没有改动选择保存直接返回
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //如果是职业编辑则需判断是否为学生
    if (_editType == 6) {
        BOOL isStu = NO;
        if ([contentLab.text isEqualToString:@"学生"]) {
            isStu = YES;
        }
        if ([self.delegate respondsToSelector:@selector(careerDidSelectedStudent:)]) {
            [self.delegate careerDidSelectedStudent:isStu];
        }
    }
    
//  通过代理通知上一级刷新UI
    if ([self.delegate respondsToSelector:@selector(modifyContentTextWithEditType:content:andNewProfileDic:)]) {
        [self.delegate modifyContentTextWithEditType:_editType content:text andNewProfileDic:_profileDataDic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//选择情感状态时修改 对勾  frame
- (void)marriageStatusChanged:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 1000;
    if (index != selectedIndex) {
        selectedIndex = index;
        UIImageView *imgV = (UIImageView*)[self.view viewWithTag:1234];
        [imgV setFrame:CGRectMake(kScreenWidth - 15 - 14, 34 + 19.5 + (index - 1)*50, 14, 11)];
    }
}

- (void)showPicker:(BOOL)isShow
{
    if (isShow) {
        [mypickerView reloadAllComponents];
        [[JYAppDelegate sharedAppDelegate].window addSubview:pickerViewBg];
    } else {
        [pickerViewBg removeFromSuperview];
    }
}
- (void)datePickerChangeAction:(UIDatePicker *)datePicker
{
    birthday = datePicker.date;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *comp1 = [calendar components:units fromDate:birthday];
    NSInteger month = [comp1 month];
    NSInteger year = [comp1 year];
    NSInteger day = [comp1 day];
    NSString * animal  = [JYHelpers computeBirthpet:year];
    NSString * mystar = [JYHelpers computeStar:month day:day];
    for (NSString *tempAniamlKey in [profileOptionDic objectForKey:@"animal"]) {
        if ([animal isEqualToString:[[profileOptionDic objectForKey:@"animal"] objectForKey:tempAniamlKey]]) {
            [_profileDataDic setValue:tempAniamlKey forKey:@"animal"];
            //                    subCodeStr = [NSString stringWithString:tempAniamlKey];
        }
    }
    for (NSString *tempStarKey in [profileOptionDic objectForKey:@"star"]) {
        if ([mystar isEqualToString:[[profileOptionDic objectForKey:@"star"] objectForKey:tempStarKey]]) {
            [_profileDataDic setValue:tempStarKey forKey:@"star"];
            //                    subCodeStr = [subCodeStr stringByAppendingString:[NSString stringWithFormat:@" %@",tempStarKey]];
        }
    }
    NSString *monthStr = month < 10 ? [NSString stringWithFormat:@"0%lu",(long)month] : [NSString stringWithFormat:@"%lu",(long)month];
    NSString *dayStr = day < 10 ? [NSString stringWithFormat:@"0%lu",(long)day] : [NSString stringWithFormat:@"%lu",(long)day];
    NSString *dateStr = [NSString stringWithFormat:@"%lu-%@-%@",(long)year,monthStr,dayStr];
    [_profileDataDic setValue:dateStr forKey:@"birthday"];
    //            subCodeStr = [NSString stringWithFormat:@"%@ %@",]
    //            codeStr = [NSString stringWithString:dateStr];
    //            NSLog(@"codeStr --> %@ subCodeStr --> %@",codeStr,subCodeStr);
    NSString *birth = [JYHelpers birthdayTransformToCentery:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day]];

    contentLab.text = [NSString stringWithFormat:@"%@ %@",birth,mystar];
}
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger num = 1;
    switch (_editType) {
        case 2:
            //现居地
            num= 2;
            break;
        case 3:
            //生日
            num= 3;
            break;
    }
    return num;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    switch (_editType) {
        case 1:
            //情感状态
            num = ((NSDictionary *)[profileOptionDic objectForKey:@"marriage"]).count;
            break;
        case 2:
        {
            if (component == 0) {
                num = [JYShareData sharedInstance].province_array.count;
            } else if (component == 1) {
                
//                pickerSelectRowInZeroComponent = [JYShareData sharedInstance].province_array indexOfObject:[pr]
                num = ((NSArray *)[[JYShareData sharedInstance].city_array objectAtIndex:pickerSelectRowInZeroComponent]).count;
            }
        }
            break;
        case 4:
        {
            num = ((NSDictionary *)[profileOptionDic objectForKey:@"height"]).count;
        }
            break;
        case 5:
        {
            num = ((NSDictionary *)[profileOptionDic objectForKey:@"weight"]).count;
        }
            break;
        case 6:
        {
            num = ((NSDictionary *)[profileOptionDic objectForKey:@"career"]).count;
        }
            break;
    }
    
    return num;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = @"?";
    switch (_editType) {
        case 1:
            //情感状态
            str =  [[profileOptionDic objectForKey:@"marriage"] objectForKey:[NSString stringWithFormat:@"%ld",(long)row+1]];
            break;
        case 2:
        {
            if (component == 0) {
                str  = [[JYShareData sharedInstance].province_array objectAtIndex:row];
                
            } else if (component == 1) {
                str = [[[JYShareData sharedInstance].city_array objectAtIndex:pickerSelectRowInZeroComponent] objectAtIndex:row];
                
            }
        }
            break;
        case 4:
        {
            str =  [[profileOptionDic objectForKey:@"height"] objectForKey:[NSString stringWithFormat:@"%ld",(long)row+1]];
        }
            break;
        case 5:
        {
            str =  [[profileOptionDic objectForKey:@"weight"] objectForKey:[NSString stringWithFormat:@"%ld",(long)row+1]];
        }
            break;
        case 6:
        {
            str =  [[profileOptionDic objectForKey:@"career"] objectForKey:[NSString stringWithFormat:@"%ld",(long)row+1]];
        }
            break;
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        pickerSelectRowInZeroComponent = row;
        switch (_editType) {
            case 1:
            {
                [contentLab setText:[[profileOptionDic objectForKey:@"marriage"] objectForKey: [NSString stringWithFormat:@"%lu",(long)pickerSelectRowInZeroComponent+1]]];
           
                [_profileDataDic setObject:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent+1] forKey:@"marriage"];
            }
                break;
            case 2:
            {
                [pickerView reloadComponent:1];
                pickerSelectRowInOneComponent = 0;
                NSString * selectedProvince = [[JYShareData sharedInstance].province_array objectAtIndex:pickerSelectRowInZeroComponent];
                NSString * selectedCity = [[[JYShareData sharedInstance].city_array objectAtIndex:pickerSelectRowInZeroComponent] objectAtIndex:pickerSelectRowInOneComponent];
                contentLab.text = [NSString stringWithFormat:@"%@, %@",selectedProvince,selectedCity];
                
                for (NSString *temp in [JYShareData sharedInstance].city_code_dict) {
                    if ([temp isEqualToString:@"0"]) {
                        //相当于不限 但是 进入编辑以后没有不限选择项，忽略
                    }else{
                        NSString *provinceKey = [temp substringWithRange:NSMakeRange(0, 2)];
                        NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:provinceKey];
                        NSString *city = [[JYShareData sharedInstance].city_code_dict objectForKey:temp];
                        if ([city isEqualToString:selectedCity] && [province isEqualToString:selectedProvince]) {
                            
                            [_profileDataDic setValue:temp forKey:@"live_sublocation"];
                            [_profileDataDic setValue:provinceKey forKey:@"live_location"];
                            
                        }
                    }
                }


            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                contentLab.text = [[profileOptionDic objectForKey:@"height"] objectForKey:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent+1]];
                
                //            codeStr = [NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent];
                //            NSLog(@"codeStr --> %@",codeStr);
                
                [_profileDataDic setValue:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent + 1] forKey:@"height"];
            }
                break;
            case 5:
            {
                contentLab.text = [[profileOptionDic objectForKey:@"weight"] objectForKey:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent+1]];
                
                //            codeStr = [NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent];
                //            NSLog(@"codeStr --> %@",codeStr);
                [_profileDataDic setValue:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent+1] forKey:@"weight"];
            }
                break;
            case 6:
            {
                contentLab.text = [[profileOptionDic objectForKey:@"career"] objectForKey:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent+1]];
                
                //            codeStr = [NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent];
                //            NSLog(@"codeStr --> %@",codeStr);
                
                [_profileDataDic setValue:[NSString stringWithFormat:@"%ld",(long)pickerSelectRowInZeroComponent+1] forKey:@"career"];
            }
                break;
        }

//        if (_editType == 2) {
//            [mypickerView reloadComponent:1];
//        }else{
//
//        }
    } else if (component == 1) {
        pickerSelectRowInOneComponent = row;
        NSString * selectedProvince = [[JYShareData sharedInstance].province_array objectAtIndex:pickerSelectRowInZeroComponent];
        NSString * selectedCity = [[[JYShareData sharedInstance].city_array objectAtIndex:pickerSelectRowInZeroComponent] objectAtIndex:pickerSelectRowInOneComponent];
        contentLab.text = [NSString stringWithFormat:@"%@, %@",selectedProvince,selectedCity];
        
        for (NSString *temp in [JYShareData sharedInstance].city_code_dict) {
            if ([temp isEqualToString:@"0"]) {
                
            }else{
                NSString *provinceKey = [temp substringWithRange:NSMakeRange(0, 2)];
                NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:provinceKey];
                NSString *city = [[JYShareData sharedInstance].city_code_dict objectForKey:temp];
                if ([city isEqualToString:selectedCity] && [province isEqualToString:selectedProvince]) {
                    
                    //                        codeStr = [NSString stringWithString:provinceKey];
                    //                        subCodeStr = [NSString stringWithString:temp];
                    //                        NSLog(@"codeStr --> %@ subCodeStr --> %@",codeStr,subCodeStr);
                    [_profileDataDic setValue:temp forKey:@"live_sublocation"];
                    [_profileDataDic setValue:provinceKey forKey:@"live_location"];
                    
                }
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
