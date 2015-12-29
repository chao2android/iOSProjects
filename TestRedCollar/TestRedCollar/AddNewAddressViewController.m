//
//  AddNewAddressViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AddNewAddressViewController.h"
#import "JSON.h"
#import "AutoAlertView.h"
#import "AreaList.h"
#import "CityList.h"

@interface AddNewAddressViewController ()

@end

@implementation AddNewAddressViewController
{
    NSString *consignee;
    NSString *area;
    NSString *city;
    NSString *address;
    NSString *zipCode;
    NSString *phone_tel;
    NSString *phone_mob;
    NSString *email;
    UITextField *text;
    
    NSMutableArray *provinceArr;
    NSMutableArray *cityArr;
    UIPickerView *PickerView;
    NSString *ID;
    UILabel *provinceLabel;
    NSString *provinceID;
    UILabel *cityLabel;
    NSString *cityID;
    UIView *grayView;
}

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        consignee = [[NSString alloc] init];
        area = [[NSString alloc] init];
        city = [[NSString alloc] init];
        address = [[NSString alloc] init];
        zipCode = [[NSString alloc] init];
        phone_tel = [[NSString alloc] init];
        phone_mob = [[NSString alloc] init];
        email = [[NSString alloc] init];
        
        provinceArr = [NSMutableArray arrayWithCapacity:0];
        cityArr = [NSMutableArray arrayWithCapacity:0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = _theTitleText;
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    [self.view addSubview:scrollView];
    
    myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:myTableView];
    
    int iHeight = 430;
    UIButton *saveAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddBtn.frame = CGRectMake(30, iHeight, myTableView.frame.size.width - 60, 40);
    [saveAddBtn setImage:[UIImage imageNamed:@"my_41.png"] forState:UIControlStateNormal];
    [saveAddBtn addTarget:self action:@selector(saveAddClick) forControlEvents:UIControlEventTouchUpInside];
    [myTableView addSubview:saveAddBtn];
}

- (void)connectToServer
{
    if (!consignee || consignee.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入收货人姓名"];
        return;
    }
    if (!provinceLabel.text || [provinceLabel.text isEqualToString:@". . ."]){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入所在省"];
        return;
    }
    if (!cityLabel.text || [cityLabel.text isEqualToString:@". . ."]){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入所在市"];
        return;
    }
    if (!address || address.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入详细地址"];
        return;
    }
    if (!zipCode || zipCode.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入邮政编码"];
        return;
    }
    if (!phone_tel || phone_tel.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入电话号码"];
        return;
    }
    if (!phone_mob || phone_mob.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入手机电话"];
        return;
    }
    if (!email || email.length == 0){
        [AutoAlertView ShowAlert:@"提示" message:@"请输入电子邮件"];
        return;
    }
    
    if (mDownManager){
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"addAddress" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:consignee forKey:@"consignee"];
    [dict setObject:address forKey:@"address"];
    NSString *region_name = [NSString stringWithFormat:@"%@ %@ %@",@"中国",provinceLabel.text,cityLabel.text];
    [dict setObject:region_name forKey:@"region_name"];
    NSString *region_id = [NSString stringWithFormat:@"%d,%d,%d",2,[provinceID intValue],[cityID intValue]];
    [dict setObject:region_id forKey:@"region_id"];
    
    [dict setObject:zipCode forKey:@"zipcode"];
    [dict setObject:phone_mob forKey:@"phone_mob"];
    [dict setObject:phone_tel forKey:@"phone_tel"];
    [dict setObject:email forKey:@"email"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        NSString *msg = [dict objectForKey:@"msg"];
        NSNumber *statusCode = [dict objectForKey:@"statusCode"];
        
        if ([statusCode isEqualToNumber:[NSNumber numberWithInt:0]]){
            [self showMsg:[NSString stringWithFormat:@"保存%@",msg]];
            [self GoBack];
        }
    }
}
- (void)dealloc {
    [self Cancel];
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)GoBack
{
    if (delegate && _onSaveClick) {
        SafePerformSelector([delegate performSelector:_onSaveClick]
        );
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAddClick
{
    [self connectToServer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3) {
        return 80;
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *labelArray = @[@"收货人姓名",@"选择地区",@"",@"详细地址",@"邮政编码",@"电话号码",@"手机电话",@"电子邮件"];
    
    NSArray *textArray = @[@"输入姓名",@"",@"",@"输入地址信息",@"输入邮政编码",@"输入电话号码",@"输入手机电话",@"输入电子邮件"];
    
    if (indexPath.row != 3){
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"f_whiteback"];
        [cell.contentView addSubview:backgroundImage];
        
        cell.textLabel.text = [labelArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        text = [[UITextField alloc] init];
        text.frame = CGRectMake(120, 4, 190, 36);
        text.backgroundColor = [UIColor clearColor];
        text.placeholder = [textArray objectAtIndex:indexPath.row];
        text.tag = indexPath.row;
        text.delegate = self;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.font = [UIFont boldSystemFontOfSize:18];
        text.inputAccessoryView = [self GetInputAccessoryView];
        [cell addSubview:text];
        
        UIImage *frameImage = [UIImage imageNamed:@"my40"];
        if (indexPath.row == 1) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 4, 60, 36)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = frameImage;
            [cell addSubview:imageView];
            text.text = @"  中国";
            text.enabled = NO;
        }
        
        if (indexPath.row == 2) {
            text.enabled = NO;
            for (int i = 0; i < 2; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(120+100*i, 4, 90, 36);
                btn.backgroundColor = [UIColor clearColor];
                [btn setImage:frameImage forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                
                if (i == 0) {
                    provinceLabel = [[UILabel alloc] init];
                    provinceLabel.frame = btn.bounds;
                    provinceLabel.textAlignment = NSTextAlignmentCenter;
                    provinceLabel.backgroundColor = [UIColor clearColor];
                    provinceLabel.text = @". . .";
                    [btn addSubview:provinceLabel];
                }else if (i == 1) {
                    cityLabel = [[UILabel alloc] init];
                    cityLabel.frame = btn.bounds;
                    cityLabel.textAlignment = NSTextAlignmentCenter;
                    cityLabel.text = @". . .";
                    cityLabel.backgroundColor = [UIColor clearColor];
                    [btn addSubview:cityLabel];
                }
            }
        }
    }else if (indexPath.row == 3){
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"3_14"];
        [cell.contentView addSubview:backgroundImage];
        
        UIImageView *lineImage = [[UIImageView alloc] init];
        lineImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        lineImage.backgroundColor = [UIColor clearColor];
        lineImage.image = [UIImage imageNamed:@"51"];
        [backgroundImage addSubview:lineImage];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, 2, 80, 36);
        label.text = [labelArray objectAtIndex:indexPath.row];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:18];
        [cell addSubview:label];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(113, 4, 195, 72);
        textView.backgroundColor = [UIColor clearColor];
        textView.text = [textArray objectAtIndex:indexPath.row];
        textView.font = [UIFont boldSystemFontOfSize:18];
        textView.delegate = self;
        textView.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.inputAccessoryView = [self GetInputAccessoryView];
        [cell addSubview:textView];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)btnClick
{
    [self hideKeyBoard];
    ID = [NSString stringWithFormat:@"2"];
    [self getAll];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return provinceArr.count;
    }else {
        return cityArr.count;
    }
}

//返回title
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        AreaList *areaList = [provinceArr objectAtIndex:row];
        return areaList.region_name;
    }else {
        CityList *cityList = [cityArr objectAtIndex:row];
        return cityList.region_name;
    }
}

//设置列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 173;
    }else {
        return self.view.frame.size.width-173;
    }
}

//选择行的事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        AreaList *areaList = [provinceArr objectAtIndex:row];
        ID = areaList.region_id;
        [self getAll];
        [PickerView selectRow:0 inComponent:1 animated:YES];
        provinceLabel.text = areaList.region_name;
        provinceID = areaList.region_id;
        cityLabel.text = @". . .";
    }else if (component == 1) {
        CityList *cityList = [cityArr objectAtIndex:row];
        cityLabel.text = cityList.region_name;
        cityID = cityList.region_id;
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height-63;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        scrollView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        scrollView.transform = CGAffineTransformIdentity;
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 4 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        consignee = textField.text;
    }else if (textField.tag == 1) {
        area = textField.text;
    }else if (textField.tag == 2) {
        city = textField.text;
    }else if (textField.tag == 4) {
        if (![textField.text isEqualToString:@""]) {
            BOOL value = [UserInfoManager isValidateNumber:textField.text length:6];
            if (!value) {
                [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
                textField.text = nil;
            }
            zipCode = textField.text;
        }
    }else if (textField.tag == 5) {
        if (![textField.text isEqualToString:@""]) {
            if (textField.text.length < 10) {
                [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
                textField.text = nil;
            }
            phone_tel = textField.text;
        }
    }else if (textField.tag == 6) {
        if (![textField.text isEqualToString:@""]) {
            BOOL value = [UserInfoManager isValidateMobile:textField.text];
            if (!value) {
                [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
                textField.text = nil;
            }
            phone_mob = textField.text;
        }
    }else if (textField.tag == 7) {
        if (![textField.text isEqualToString:@""]){
            BOOL value = [UserInfoManager isValidateEmail:textField.text];
            if (!value) {
                [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
                textField.text = nil;
            }
            email = textField.text;
        }
    }
}

- (void)textViewKeyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height-150;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        scrollView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)textViewKeyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        scrollView.transform = CGAffineTransformIdentity;
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    address = textView.text;
}

- (void)getAll
{
    if (mDownManager)
    {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinishAll:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getregionlist" forKey:@"act"];
    [dict setObject:ID forKey:@"parent_id"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinishAll:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        if ([ID isEqualToString:@"2"]) {
            if ([[dict objectForKey:@"statusCode"] integerValue] == 0)
            {
                NSDictionary *allList = [dict objectForKey:@"list"];
                for (NSString *key in allList.allKeys)
                {
                    NSDictionary *sonDict = [allList objectForKey:key];
                    AreaList *areaList = [[AreaList alloc] init];
                    areaList.region_name = [sonDict objectForKey:@"region_name"];
                    areaList.region_id = [sonDict objectForKey:@"region_id"];
                    [provinceArr addObject:areaList];
                }
            }
            
            grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            [self.view addSubview:grayView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
            tapGesture.numberOfTapsRequired  = 1;
            [grayView addGestureRecognizer:tapGesture];
            
            PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, 0, 0)];
            PickerView.delegate = self;
            PickerView.dataSource = self;
            if (IOS_7) {
                PickerView.backgroundColor = [UIColor whiteColor];
            }
            PickerView.showsSelectionIndicator = YES;
            [grayView addSubview:PickerView];
            
            [self pickerView:PickerView didSelectRow:0 inComponent:0];
        }else {
            if ([[dict objectForKey:@"statusCode"] integerValue] == 0)
            {
                cityArr = [[NSMutableArray alloc] init];
                
                NSDictionary *allList = [dict objectForKey:@"list"];
                for (NSString *key in allList.allKeys)
                {
                    NSDictionary *sonDict = [allList objectForKey:key];
                    CityList *cityList = [[CityList alloc] init];
                    cityList.region_name = [sonDict objectForKey:@"region_name"];
                    cityList.region_id = [sonDict objectForKey:@"region_id"];
                    
                    [cityArr addObject:cityList];
                    
                    if (cityArr.count == 1) {
                        cityLabel.text = cityList.region_name;
                    }
                }
            }
            [PickerView reloadComponent:1];
        }
    }
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.5 animations:^{
        grayView.alpha = 0;
    } completion:^(BOOL finished) {
        [grayView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
