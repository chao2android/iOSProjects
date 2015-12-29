//
//  UserSexViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserSexViewController.h"
#import "JSON.h"

@interface UserSexViewController ()
{
    NSMutableArray *_theList;
    UITableView *mTableView;
    NSInteger iCurSelect;
}
@end

@implementation UserSexViewController

@synthesize mDownManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        NSNumber *statusCode = [dict objectForKey:@"statusCode"];
        if ([statusCode isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            [self showMsg:@"保存成功"];
            if (delegate && _onSaveClick)
            {
                SafePerformSelector([delegate performSelector:_onSaveClick withObject:_theList[iCurSelect]]);
            }
            [self GoBack];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}

-(void)okClick
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
    
    NSString *urlstr = [NSString stringWithFormat:@"%@user.php", SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"modifyUserData" forKey:@"act"];
    [dict setObject:[NSString stringWithFormat:@"%d",iCurSelect+1] forKey:@"newSex"];
    [dict setObject:kkToken forKey:@"token"];
    
    [mDownManager PostHttpRequest:urlstr :dict];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.title = @"性别";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@"button_check"] target:self action:@selector(okClick)];
    
    _theList = [[NSMutableArray alloc] initWithObjects:@"男",@"女", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.bounces = NO;
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
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    backgroundImage.backgroundColor = [UIColor clearColor];
    backgroundImage.image = [UIImage imageNamed:@"f_whiteback"];
    [cell.contentView addSubview:backgroundImage];
    
    cell.textLabel.text = _theList[indexPath.row];
    if ([_theList[indexPath.row] isEqualToString:_theSex]) {
        iCurSelect=indexPath.row;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == iCurSelect) {
        return;
    }
    
    NSIndexPath *tIndexPath=[NSIndexPath indexPathForRow:iCurSelect inSection:0];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:tIndexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    iCurSelect = indexPath.row;
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
