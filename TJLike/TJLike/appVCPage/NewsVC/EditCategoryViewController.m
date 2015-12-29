//
//  EditCategoryViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "CategoryManager.h"

@interface EditCategoryViewController ()
{
    UITableView *mTableView;
}
@end

@implementation EditCategoryViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"内容定制"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"-------->%@",_dataSource);
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [mTableView setEditing:YES];
    [self.view addSubview:mTableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mBlock();
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row][@"name"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [_dataSource exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [CategoryManager Share].mcArray = _dataSource;
    NSLog(@"---->%@",[CategoryManager Share].mcArray);
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
