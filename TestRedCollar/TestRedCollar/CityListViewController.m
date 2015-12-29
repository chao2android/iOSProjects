//
//  CityListViewController.m
//  TestRedCollar
//
//  Created by miracle on 14-7-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CityListViewController.h"
#import "JSON.h"
#import "CityList.h"
#import "MakeAnAppointmentOfFigureViewController.h"
@interface CityListViewController ()
{
    NSMutableArray *_theList;
    UITableView *mTableView;
    NSInteger iCurSelect;
    BOOL iSelect;
    BOOL iSel;
}
@end

@implementation CityListViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        iSelect = NO;
        iSel = NO;
    }
    return self;
}

- (void)Cancel
{
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)connectToServer
{
    if (mDownManager)
    {
        return;
    }
    [self StartLoading];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!iSelect)
    {
        urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
        [dict setObject:@"getregionlist" forKey:@"act"];
        [dict setObject:[NSString stringWithFormat:@"%@",_areaList.region_id] forKey:@"parent_id"];
    }
    else
    {
        urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
        [dict setObject:@"modifyUserData" forKey:@"act"];
        [dict setObject:kkToken forKey:@"token"];
        [dict setObject:[NSString stringWithFormat:@"%@",_areaList.region_id] forKey:@"newprovince"];
        ;
        [dict setObject:[NSString stringWithFormat:@"%@",((CityList *)_theList[iCurSelect]).region_id] forKey:@"newcity"];
    }
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        if (!iSelect)
        {
            if ([[dict objectForKey:@"statusCode"] integerValue] == 0)
            {
                NSDictionary *allList = [dict objectForKey:@"list"];
                for (NSString *key in allList.allKeys)
                {
                    NSDictionary *sonDict = [allList objectForKey:key];
                    CityList *cityList = [[CityList alloc] init];
                    cityList.region_name = [sonDict objectForKey:@"region_name"];
                    cityList.region_id = [sonDict objectForKey:@"region_id"];
                    
                    [_theList addObject:cityList];
                }
            }
            [mTableView reloadData];
        }
        else
        {
            if ([[dict objectForKey:@"statusCode"] integerValue] == 0)
            {
                [self showMsg:[NSString stringWithFormat:@"%@",[dict objectForKey:@"msg"]]];
                NSArray *viewControllers = self.navigationController.viewControllers;
                [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
                
                NSArray *array = [[NSArray alloc] initWithObjects:_areaList.region_name, ((CityList *)_theList[iCurSelect]).region_name, nil];
                
                if (delegate && _onSaveClick)
                {
                    SafePerformSelector([delegate performSelector:_onSaveClick withObject:array]);
                }
            }
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

-(void)okClick
{
    if (iCurSelect != -1)
    {
        iSelect = YES;
        [self connectToServer];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    iSelect = NO;
    iSel = NO;
    _theList = [[NSMutableArray alloc] init];
    
    self.title = @"地区";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@"button_check"] target:self action:@selector(okClick)];
    [self connectToServer];
    iCurSelect = -1;
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    //mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mTableView.showsVerticalScrollIndicator = NO;
    mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _theList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行高
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    
    CityList *cityList = _theList[indexPath.row];
    cell.textLabel.text = cityList.region_name;
    
    if (!iSel)
    {
        if ([cityList.region_name isEqualToString:_city])
        {
            iCurSelect = indexPath.row;
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else
    {
        if (iCurSelect == indexPath.row)
        {
            iCurSelect=indexPath.row;
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.index == 1) {
        CityList *model = _theList[indexPath.row];
        self.block(model.region_name,model.region_id);
        
        for (UIViewController *con in self.navigationController.viewControllers) {
            if (con && [con isKindOfClass:[MakeAnAppointmentOfFigureViewController class]]) {
                [self.navigationController popToViewController:con animated:YES];
                return;
            }
        }
    }
    
    
    if (indexPath.row == iCurSelect) {
        return;
    }
    
    iSel = YES;
    
    NSIndexPath *tIndexPath=[NSIndexPath indexPathForRow:iCurSelect inSection:0];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:tIndexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    iCurSelect=indexPath.row;
    tIndexPath=[NSIndexPath indexPathForRow:iCurSelect inSection:0];
    cell=[tableView cellForRowAtIndexPath:tIndexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
