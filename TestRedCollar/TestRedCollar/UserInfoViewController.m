//
//  UserInfoViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserInfoViewController.h"
#import "QRCodeViewController.h"
#import "UserNameViewController.h"
#import "UserSexViewController.h"
#import "AreaListViewController.h"
#import "UserAddressListViewController.h"
#import "JSON.h"
#import "NetImageView.h"
#import "UserInfoCell.h"

@interface UserInfoViewController ()
{
    UILabel *_theNameLabel;
    UILabel *_theSexLabel;
    UILabel *_theSignLabel;
    UILabel *areaLabel;
    NSInteger iSection;
    NSInteger iRow;
    NetImageView *net;
    UIImageView *headIamge;
    
    NSString *province;
    NSString *city;
    NSMutableDictionary *userInfo;
    NSString *addressID;
}
@end

@implementation UserInfoViewController

@synthesize mPhotoManager;
@synthesize mDownManager;
@synthesize downManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        province = [[NSString alloc] init];
        city = [[NSString alloc] init];
        areaLabel = [[UILabel alloc] init];
        addressID = [[NSString alloc] init];
    }
    return self;
}

-(void)connectToServer
{
    if (mDownManager){
        return;
    }
    [self StartLoading];
    
    self.downManager = [[ImageDownManager alloc] init];
    downManager.delegate = self;
    downManager.OnImageDown = @selector(OnDownFinish:);
    downManager.OnImageFail = @selector(OnDownFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getregionlist" forKey:@"act"];
    [dict setObject:@"-1" forKey:@"parent_id"];
    [downManager PostHttpRequest:urlstr :dict];
}

- (void)OnDownFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        if ([[dict objectForKey:@"statusCode"] integerValue] == 0){
            BOOL iProvince = NO;
            BOOL iCity = NO;
            NSDictionary *list = [dict objectForKey:@"list"];
            
            for (NSString *key in list.allKeys){
                if ([key isEqualToString:_userList.province] && !iProvince) {
                    province = [[list objectForKey:key] objectForKey:@"region_name"];
                    iProvince = YES;
                }
                if ([key isEqualToString:_userList.city] && !iCity) {
                    city = [[list objectForKey:key] objectForKey:@"region_name"];
                    iCity = YES;
                }
                if (iProvince == YES && iCity == YES) {
                    break;
                }
            }
        }
    }
    [mTableView reloadData];
}

- (void)OnDownFail:(ImageDownManager *)sender
{
    [self downCancel];
}

- (void)downCancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.downManager);
}

- (void)GoBack
{
    if (delegate && _onSaveClick){
        SafePerformSelector([delegate performSelector:_onSaveClick]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mTableView];
    
    mPhotoManager = [[PhotoSelectManager alloc] init];
    mPhotoManager.mRootCtrl = self;
    mPhotoManager.delegate = self;
    mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
    
    [self connectToServer];
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)OnLoadFinish:(ASIDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        NSString *msg = [dict objectForKey:@"msg"];
        if ([[dict objectForKey:@"statusCode"] intValue] == 0){
            [self showMsg:[NSString stringWithFormat:@"%@",msg]];
        }
    }
}

- (void)OnLoadFail:(ASIDownManager *)sender
{
    [self Cancel];
}

- (void)OnPhotoSelect:(PhotoSelectManager *)sender
{
    headIamge = [[UIImageView alloc] initWithFrame:net.bounds];
    headIamge.image = [UIImage imageWithContentsOfFile:sender.mLocalPath];
    headIamge.layer.masksToBounds = YES;
    headIamge.layer.cornerRadius = net.bounds.size.width/2;
    [net addSubview:headIamge];
    
    if (mDownManager){
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ASIDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"modifyUserData" forKey:@"act"];
    [dict setObject:kkToken forKey:@"token"];
    NSMutableDictionary *filesDict = [NSMutableDictionary dictionary];
    [filesDict setObject:sender.mLocalPath forKey:@"newheadImg"];
    
    [mDownManager PostHttpRequest:urlstr :dict files:filesDict];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 5;
    }
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 80;
    }
	return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%02d%02d", indexPath.section, indexPath.row];
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier tag:0];
        }
        else
        {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-190, 10, 160, 24)];
        lbDesc.font = [UIFont systemFontOfSize:14];
        lbDesc.backgroundColor = [UIColor clearColor];
        lbDesc.textColor = [UIColor grayColor];
        lbDesc.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lbDesc];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0){
                net = [[NetImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 10, 60, 60)];
                net.mDefaultImage = [UIImage imageNamed:@"default_avatar.png"];
                [net GetImageByStr:_userList.portrait];
                net.layer.masksToBounds = YES;
                net.layer.cornerRadius = net.bounds.size.width/2;
                net.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:net];
            }else if (indexPath.row == 1) {
                _theNameLabel = lbDesc;
                _theNameLabel.text = _userList.nickname;
            }else if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                lbDesc.text = kkUserID;
                cell.nextImage.hidden = YES;
            }else if (indexPath.row == 3) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-54, 10, 24, 24)];
                imageView.image = [UIImage imageNamed:@"erweima"];
                [cell.contentView addSubview:imageView];
            }else if (indexPath.row == 4){
                addressID = _userList.def_addr;
            }
        }else{
            if (indexPath.row == 0) {
                _theSexLabel = lbDesc;
                if ([_userList.gender integerValue] == 1){
                    _theSexLabel.text = @"男";
                }else if ([_userList.gender integerValue] == 2){
                    _theSexLabel.text = @"女";
                }
            }
            else if (indexPath.row == 2){
                _theSignLabel = lbDesc;
                _theSignLabel.text = _userList.signature;
            }
        }
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            areaLabel.frame = CGRectMake(self.view.frame.size.width-190, 10, 160, 24);
            areaLabel.font = [UIFont systemFontOfSize:14];
            areaLabel.backgroundColor = [UIColor clearColor];
            areaLabel.textColor = [UIColor grayColor];
            areaLabel.text = [NSString stringWithFormat:@"%@%@",province,city];
            areaLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:areaLabel];
        }
    }
    
    if (indexPath.section == 0) {
        NSArray *array = @[@"头像", @"名字", @"酷客号", @"我的二维码",@"我的收货地址"];
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }else {
        NSArray *array = @[@"性别", @"地区", @"个性签名"];
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    iSection=indexPath.section;
    iRow=indexPath.row;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            UIActionSheet *actView = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
            [actView showInView:self.view];
        }
        else if (indexPath.row == 1) {
            //名字
            UserNameViewController *tViewCtr=[[UserNameViewController alloc] init];
            tViewCtr.delegate = self;
            tViewCtr.type = typeName;
            tViewCtr.onSaveClick = @selector(refreshName:);
            tViewCtr.theTitleText = @"名字";
            tViewCtr.theContentText = _theNameLabel.text;
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }else if (indexPath.row == 3) {
            QRCodeViewController *ctrl = [[QRCodeViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }else if (indexPath.row == 4){
            UserAddressListViewController *tViewCtr=[[UserAddressListViewController alloc] init];
            tViewCtr.addrID = addressID;
            tViewCtr.delegate = self;
            tViewCtr.onSaveClick = @selector(refreshAddress:);
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            //性别
            UserSexViewController *tViewCtr=[[UserSexViewController alloc] init];
            tViewCtr.delegate=self;
            tViewCtr.onSaveClick=@selector(refreshSex:);
            tViewCtr.theSex = _theSexLabel.text;
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }else if (indexPath.row == 1) {
            //地区
            AreaListViewController *tViewCtr=[[AreaListViewController alloc] init];
            tViewCtr.delegate=self;
            tViewCtr.state = @"2";
            tViewCtr.province = province;
            tViewCtr.city = city;
            tViewCtr.onSaveClick = @selector(refreshArea:);
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }else if (indexPath.row == 2) {
            //签名
            UserNameViewController *tViewCtr=[[UserNameViewController alloc] init];
            tViewCtr.delegate = self;
            tViewCtr.type = typeSignature;
            tViewCtr.onSaveClick = @selector(refreshName:);
            tViewCtr.theTitleText = @"个性签名";
            tViewCtr.theContentText = _theSignLabel.text;
            [self.navigationController pushViewController:tViewCtr animated:YES];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    mPhotoManager.mDefaultName = @"newheadImg.jpg";
    if (buttonIndex == 0) {
        [mPhotoManager TakePhoto:YES];
    }
    else if (buttonIndex == 1) {
        [mPhotoManager TakePhoto:NO];
    }
}

//更改名字/签名
- (void)refreshName:(NSString*)aText
{
    if (iSection == 0)
    {
        if (iRow == 1)
        {
            _theNameLabel.text = aText;
        }
    }
    else if(iSection == 1)
    {
        if (iRow == 2)
        {
            _theSignLabel.text = aText;
        }
    }
}

//性别
- (void)refreshSex:(NSString*)aText
{
    _theSexLabel.text = aText;
}

//地区
- (void)refreshArea:(id)sender
{
    areaLabel.text = [NSString stringWithFormat:@"%@%@",[((NSArray *)sender) objectAtIndex:0],[((NSArray *)sender) objectAtIndex:1]];
    province = [((NSArray *)sender) objectAtIndex:0];
    city = [((NSArray *)sender) objectAtIndex:1];
}

- (void)refreshAddress:(id)sender
{
    addressID = sender;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
