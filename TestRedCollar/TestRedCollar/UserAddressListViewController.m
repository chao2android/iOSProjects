//
//  UserAddressListViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserAddressListViewController.h"
#import "UserAddressListCell.h"
#import "UserAddressInfoViewController.h"
#import "AddNewAddressViewController.h"
#import "JSON.h"
#import "ConsigneeList.h"

@interface UserAddressListViewController ()
{
    NSMutableArray *_theList;
    UITableView *mTableView;
    NSInteger iSel;
    NSString *addr_idStr;
    NSInteger iCurSelect;
}

@end

@implementation UserAddressListViewController

@synthesize mDownManager;

- (void)connectToServer
{
    if (mDownManager) {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@flow.php", SERVER_URL];;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (iSel == 0) {
        [dict setObject:@"getConsigneeList" forKey:@"act"];
    }else if (iSel == 1) {
        [dict setObject:@"delAddress" forKey:@"act"];
        [dict setObject:addr_idStr forKey:@"addr_id"];
    }else if (iSel == 2) {
        [dict setObject:@"setDefAddr" forKey:@"act"];
        if (iCurSelect == -1) {
            iCurSelect = 0;
        }
        [dict setObject:[NSString stringWithFormat:@"%@",((ConsigneeList *)_theList[iCurSelect]).addr_id] forKey:@"id"];
        _addrID = ((ConsigneeList *)_theList[iCurSelect]).addr_id;
    }
    [dict setObject:kkToken forKey:@"token"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]){
        if (iSel == 0){
            
            for (NSString *key in dict.allKeys){
                NSDictionary *sonDict = [dict objectForKey:key];
                ConsigneeList *list = [ConsigneeList CreateWithDict:sonDict];
                if (list){
                    [_theList addObject:list];
                }
            }
            [self initTableView];
        }else if (iSel == 2) {
            if ([[dict objectForKey:@"statusCode"] intValue] == 0){
                [self showMsg:@"保存成功"];
                if (delegate && _onSaveClick){
                    SafePerformSelector([delegate performSelector:_onSaveClick withObject:((ConsigneeList *)_theList[iCurSelect]).addr_id]);
                }
            }
            [mTableView reloadData];
        }else if (iSel == 1) {
            [mTableView reloadData];
        }
    }
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        iSel = 0;
        addr_idStr = [[NSString alloc] init];
        iCurSelect = -1;
        _theList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)okClick
{
    if (_theList.count != 0){
        iSel = 2;
        [self connectToServer];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收货地址";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    if (_type == 0) {
        [self AddRightImageBtn:[UIImage imageNamed:@"button_check"] target:self action:@selector(okClick)];
    }else {
        [self AddRightImageBtn:nil target:nil action:nil];
    }
    
    [self initTableView];
    [self connectToServer];
}

- (void)initTableView
{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_theList count]+1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _theList.count) {
        return 45;
    }
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _theList.count){
        static NSString *CellIdentifier = @"Cell00";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            UIImageView *tImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
            tImageView.image=[UIImage imageNamed:@"add_red"];
            [cell addSubview:tImageView];
            
            UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 44)];
            tLabel.backgroundColor=[UIColor clearColor];
            tLabel.font = [UIFont systemFontOfSize:17];
            tLabel.text = @"新增收货地址";
            [cell addSubview:tLabel];
        }
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        backgroundImage.backgroundColor = [UIColor clearColor];
        backgroundImage.image = [UIImage imageNamed:@"f_whiteback"];
        [cell.contentView addSubview:backgroundImage];
        
        UIImageView *nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 17, 6, 11)];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.image = [UIImage imageNamed:@"my_08"];
        [backgroundImage addSubview:nextImage];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        static NSString *CellIdentifier = @"Cell01";
        UserAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UserAddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.onButtonClick = @selector(btnClick:);
            
            ConsigneeList *list = _theList[indexPath.row];
            cell.userName.text = list.consignee;
            cell.userAddress.text = list.address;
            CGSize size = [cell.userName.text sizeWithFont:[UIFont systemFontOfSize:18]];
            if (size.width < 120) {
                [cell.userName sizeToFit];
            }
            UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.userName.frame.origin.x+cell.userName.frame.size.width, cell.userName.frame.origin.y, 100, cell.userName.frame.size.height)];
            mobileLabel.backgroundColor = [UIColor clearColor];
            mobileLabel.text = list.phone_mob;
            mobileLabel.font = [UIFont systemFontOfSize:15];
            mobileLabel.textColor = [UIColor lightGrayColor];
            mobileLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:mobileLabel];
            
            if ([_addrID isEqualToString:list.addr_id]) {
                iCurSelect = indexPath.row;
                cell.checkImage.hidden = NO;
            }else {
                cell.checkImage.hidden = YES;
            }
        }
        
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.tag = indexPath.row;
            }
        }
        return cell;
    }
}

- (void)btnClick:(id)sender
{
    UserAddressInfoViewController *infoAddress = [[UserAddressInfoViewController alloc] init];
    infoAddress.theTitleText = @"修改用户地址信息";
    infoAddress.delegate = self;
    infoAddress.onSaveClick = @selector(refreshInfo);
    [infoAddress receiveConsignee:[_theList objectAtIndex:[sender intValue]]];
    [self.navigationController pushViewController:infoAddress animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_theList count]) {
        return UITableViewCellEditingStyleNone;
    }else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)refreshInfo
{
    iSel = 0;
    [mTableView removeFromSuperview];
    _theList = [[NSMutableArray alloc] init];
    [self connectToServer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _theList.count) {
        AddNewAddressViewController *newAddress = [[AddNewAddressViewController alloc] init];
        newAddress.delegate = self;
        newAddress.onSaveClick = @selector(refreshInfo);
        newAddress.theTitleText = @"新增收货地址";
        [self.navigationController pushViewController:newAddress animated:YES];
        
    }else {
        NSIndexPath *tIndexPath = [NSIndexPath indexPathForRow:iCurSelect inSection:0];
        UserAddressListCell *cell = (UserAddressListCell *)[tableView cellForRowAtIndexPath:tIndexPath];
        cell.checkImage.hidden = YES;
        
        iCurSelect = indexPath.row;
        tIndexPath = [NSIndexPath indexPathForRow:iCurSelect inSection:0];
        cell = (UserAddressListCell *)[tableView cellForRowAtIndexPath:tIndexPath];
        cell.checkImage.hidden = NO;
        
        if (_type == 0) {
            
        }else if (_type == typeBack) {
            ConsigneeList *model = _theList[indexPath.row];
            if (self.blocksAd) {
                self.blocksAd(model);
            }
            [self okClick];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        iSel = 1;
        ConsigneeList *con = [_theList objectAtIndex:indexPath.row];
        addr_idStr = con.addr_id;
        [self connectToServer];
        
        [_theList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
