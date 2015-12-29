//
//  AreaListViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AreaListViewController.h"
#import "JSON.h"
#import "AreaList.h"

@interface AreaListViewController ()
{
    NSMutableArray *_theList;
    UITableView *mTableView;
    NSInteger iCurSelect;
    BOOL iSelect;
}
@end

@implementation AreaListViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // Custom initialization
        iSelect = NO;
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
    
    NSString *urlstr = [NSString stringWithFormat:@"%@club.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"getregionlist" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%@",_state] forKey:@"parent_id"];
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        if ([[dict objectForKey:@"statusCode"] integerValue] == 0)
        {
            NSDictionary *allList = [dict objectForKey:@"list"];
            for (NSString *key in allList.allKeys)
            {
                NSDictionary *sonDict = [allList objectForKey:key];
                AreaList *areaList = [[AreaList alloc] init];
                areaList.region_name = [sonDict objectForKey:@"region_name"];
                areaList.region_id = [sonDict objectForKey:@"region_id"];
                
                [_theList addObject:areaList];
            }
        }
    }
    [mTableView reloadData];
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _theList = [[NSMutableArray alloc] init];
    
    self.title = @"地区";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
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

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    
    AreaList *areaList = _theList[indexPath.row];
    cell.textLabel.text = areaList.region_name;
    
    if (!iSelect)
    {
        if ([areaList.region_name isEqualToString:_province])
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
    
    iSelect = YES;
        
    NSIndexPath *tIndexPath = [NSIndexPath indexPathForRow:iCurSelect inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:tIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    iCurSelect = indexPath.row;
    tIndexPath = [NSIndexPath indexPathForRow:iCurSelect inSection:0];
    cell = [tableView cellForRowAtIndexPath:tIndexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (self.index == 1) {
        AreaList *areaList = _theList[indexPath.row];
        self.block(areaList.region_name,areaList.region_id);
        self.CityListViewController.delegate = self;
        self.CityListViewController.onSaveClick = @selector(changeNewValue:);
        self.CityListViewController.areaList = _theList[iCurSelect];
        self.CityListViewController.city = _city;
        [self.navigationController pushViewController:self.CityListViewController animated:YES];
        return;
    }
    
    CityListViewController *cityList = [[CityListViewController alloc] init];
    cityList.delegate = self;
    cityList.onSaveClick = @selector(changeNewValue:);
    cityList.areaList = _theList[iCurSelect];
    cityList.city = _city;
    [self.navigationController pushViewController:cityList animated:YES];
}

- (void)changeNewValue:(id)sender
{
    if (delegate && _onSaveClick)
    {
        SafePerformSelector([delegate performSelector:_onSaveClick withObject:sender]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
