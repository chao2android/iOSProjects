//
//  UserAddressInfoViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserAddressInfoViewController.h"
#import "JSON.h"
#import "AutoAlertView.h"
#import "AreaList.h"
#import "CityList.h"

@interface UserAddressInfoViewController ()

@end

@implementation UserAddressInfoViewController
{
    NSString *consigneeStr;
    NSString *area;
    NSString *province;
    NSString *city;
    NSString *address;
    NSString *zipCode;
    NSString *phone_tel;
    NSString *phone_mob;
    NSString *email;
    
    UITextField *text;
    NSMutableArray *addrInfoArr;
    NSString *addr_id;
    
    NSMutableArray *provinceArr;
    NSMutableArray *cityArr;
    UIPickerView *PickerView;
    NSString *ID;
    
    UIView *grayView;
    
    UILabel *areaLabel;
    UILabel *provinceLabel;
    UILabel *cityLabel;
    NSString *areaID;
    NSString *provinceID;
    NSString *cityID;
}

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        addr_id = [[NSString alloc] init];
        
        provinceArr = [NSMutableArray arrayWithCapacity:0];
        cityArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)receiveConsignee:(ConsigneeList *)conlist
{
    addrInfoArr = [[NSMutableArray alloc] init];
    
    addr_id = conlist.addr_id;
    NSArray *arr = @[@"consignee",@"area",@"address",@"zipCode",@"phone_tel",@"phone_mob",@"email"];
    for (int i = 0; i < arr.count; i++) {
        if ([conlist valueForKey:[arr objectAtIndex:i]] == nil) {
            [conlist setValue:@"" forKey:[arr objectAtIndex:i]];
        }
    }
    
    NSArray *region_id = [conlist.region_id componentsSeparatedByString:@","];
    areaID = [region_id objectAtIndex:0];
    provinceID = [region_id objectAtIndex:1];
    cityID = [region_id objectAtIndex:2];
    
    NSString *addrStr = [[NSString alloc] init];
    for (int i = 0; i < conlist.city.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *str = [conlist.city substringWithRange:range];
        if ([str isEqualToString:@" "]) {
            str = @" ";
        }
        if ([str isEqualToString:@"　"]) {
            str = @" ";
        }
        addrStr = [addrStr stringByAppendingString:str];
    }
    
    NSArray *region_name = [addrStr componentsSeparatedByString:@" "];
    area = [region_name objectAtIndex:0];
    province = [region_name objectAtIndex:1];
    city = [region_name objectAtIndex:2];
    
    consigneeStr = conlist.consignee;
    address = conlist.address;
    zipCode = conlist.zipCode;
    phone_tel = conlist.phone_tel;
    phone_mob = conlist.phone_mob;
    email = conlist.email;
    
    [addrInfoArr addObject:consigneeStr];
    [addrInfoArr addObject:@""];
    [addrInfoArr addObject:@""];
    [addrInfoArr addObject:@""];
    [addrInfoArr addObject:zipCode];
    [addrInfoArr addObject:phone_tel];
    [addrInfoArr addObject:phone_mob];
    [addrInfoArr addObject:email];
}

- (void)connectToServer
{
    if (!consigneeStr || consigneeStr.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入收货人姓名"];
        return;
    }
    if (!provinceLabel.text || [provinceLabel.text isEqualToString:@". . ."]) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入所在省"];
        return;
    }
    if (!cityLabel.text || [cityLabel.text isEqualToString:@". . ."]) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入所在市"];
        return;
    }
    if (!address || address.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入详细地址"];
        return;
    }
    if (!zipCode || zipCode.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入邮政编码"];
        return;
    }
    if (!phone_tel || phone_tel.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入电话号码"];
        return;
    }
    if (!phone_mob || phone_mob.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入手机电话"];
        return;
    }
    if (!email || email.length == 0) {
        [AutoAlertView ShowAlert:@"提示" message:@"请输入电子邮件"];
        return;
    }
    
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"editAddress" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    [dict setObject:addr_id forKey:@"addr_id"];
    
    NSString *region_name = [NSString stringWithFormat:@"%@ %@ %@",areaLabel.text,provinceLabel.text,cityLabel.text];
    [dict setObject:region_name forKey:@"region_name"];
    NSString *region_id = [NSString stringWithFormat:@"%d,%d,%d",[areaID intValue],[provinceID intValue],[cityID intValue]];
    [dict setObject:region_id forKey:@"region_id"];
    
    [dict setObject:consigneeStr forKey:@"consignee"];
    [dict setObject:address forKey:@"address"];
    [dict setObject:zipCode forKey:@"zipcode"];
    [dict setObject:phone_mob forKey:@"phone_mob"];
    [dict setObject:phone_tel forKey:@"phone_tel"];
    [dict setObject:email forKey:@"email"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSString *msg = [dict objectForKey:@"msg"];
        NSNumber *statusCode = [dict objectForKey:@"statusCode"];
        
        if ([statusCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [self showMsg:[NSString stringWithFormat:@"%@",msg]];
            SafePerformSelector([delegate performSelector:_onSaveClick]);
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)saveAddClick
{
    [self connectToServer];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        return 80;
    }
    return 44;
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIImage *image = [UIImage imageNamed:@"f_whiteback"];
    UIImage *frameImage = [UIImage imageNamed:@"my40"];
    if (indexPath.row == 1) {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = image;
        [cell.contentView addSubview:backgroundImage];
        
        cell.textLabel.text = @"选择地区";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 4, 60, 36)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = frameImage;
        [cell addSubview:imageView];
        
        areaLabel = [[UILabel alloc] init];
        areaLabel.frame = imageView.bounds;
        areaLabel.textAlignment = NSTextAlignmentCenter;
        areaLabel.backgroundColor = [UIColor clearColor];
        areaLabel.text = area;
        [imageView addSubview:areaLabel];
        
    }else if (indexPath.row == 2) {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = image;
        [cell.contentView addSubview:backgroundImage];
        
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
                provinceLabel.text = province;
                [btn addSubview:provinceLabel];
            }else if (i == 1) {
                cityLabel = [[UILabel alloc] init];
                cityLabel.frame = btn.bounds;
                cityLabel.textAlignment = NSTextAlignmentCenter;
                cityLabel.backgroundColor = [UIColor clearColor];
                cityLabel.text = city;
                [btn addSubview:cityLabel];
            }
        }
    }else if (indexPath.row == 3) {
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
        label.frame = CGRectMake(15, 2, 80, 36);
        label.text = @"详细地址";
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        [cell addSubview:label];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(113, 4, 195, 72);
        textView.backgroundColor = [UIColor clearColor];
        if ([address isEqualToString:@""]) {
            textView.text = @"输入地址信息";
        }else {
            textView.text = address;
        }
        textView.font = [UIFont boldSystemFontOfSize:18];
        textView.delegate = self;
        textView.inputAccessoryView = [self GetInputAccessoryView];
        textView.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:textView];
    }else {
        
        NSArray *labelArray = @[@"收货人姓名",@"",@"",@"",@"邮政编码",@"电话号码",@"手机电话",@"电子邮件"];
        NSArray *textArray = @[@"输入姓名",@"",@"",@"",@"输入邮政编码",@"输入电话号码",@"输入手机电话",@"输入电子邮件"];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 46)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = image;
        [cell.contentView addSubview:backgroundImage];
        
        cell.textLabel.text = [labelArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        text = [[UITextField alloc] init];
        text.frame = CGRectMake(120, 4, 190, 36);
        text.backgroundColor = [UIColor clearColor];
        if ([[addrInfoArr objectAtIndex:indexPath.row] isEqualToString:@""]) {
            text.placeholder = [textArray objectAtIndex:indexPath.row];
        }else {
            text.text = [addrInfoArr objectAtIndex:indexPath.row];
        }
        text.tag = indexPath.row;
        text.delegate = self;
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.font = [UIFont boldSystemFontOfSize:18];
        text.inputAccessoryView = [self GetInputAccessoryView];
        [cell addSubview:text];
    }
    return cell;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height-63;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        myTableView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        myTableView.transform = CGAffineTransformIdentity;
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 4 || textField.tag == 5 || textField.tag == 6 || textField.tag == 7)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        consigneeStr = textField.text;
    }else if (textField.tag == 4) {
        zipCode = textField.text;
        NSLog(@"%d",zipCode.length);
        BOOL value = [UserInfoManager isValidateNumber:zipCode length:6];
        if (!value) {
            [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
        }
    }else if (textField.tag == 5) {
        phone_tel = textField.text;
        if (phone_tel.length < 10) {
            [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
        }
    }else if (textField.tag == 6) {
        phone_mob = textField.text;
        BOOL value = [UserInfoManager isValidateMobile:phone_mob];
        if (!value) {
            [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
        }
    }else if (textField.tag == 7) {
        email = textField.text;
        BOOL value = [UserInfoManager isValidateEmail:email];
        if (!value) {
            [AutoAlertView ShowAlert:@"提示" message:@"输入错误"];
        }
    }
}

- (void)textViewKeyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardRect = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height-150;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        myTableView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)textViewKeyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        myTableView.transform = CGAffineTransformIdentity;
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    address = textView.text;
}

- (void)btnClick
{
    [self hideKeyBoard];
    ID = areaID;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
