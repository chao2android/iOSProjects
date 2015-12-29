//
//  CustomListViewController.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CustomListViewController.h"
#import "CustomDetailViewController.h"

@interface CustomListViewController ()

@end

@implementation CustomListViewController

@synthesize mArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i = 29; i <= 34; i ++) {
            [mArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    self.title = @"西装列表";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@"28"] target:self action:@selector(OnShareClick)];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
}

- (void)OnShareClick
{
    
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int iCount = mArray.count/2;
    if (mArray.count%2) {
        iCount ++;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 225;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    CustomListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    int index = indexPath.row*2;
    NSString *leftimage = [mArray objectAtIndex:index];
    NSString *rightimage = nil;
    if (index+1<mArray.count) {
        rightimage =  [mArray objectAtIndex:index+1];
    }
    [cell LoadContent:leftimage :rightimage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)OnCustomListSelect:(NSString *)name
{
    CustomDetailViewController *ctrl = [[CustomDetailViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
