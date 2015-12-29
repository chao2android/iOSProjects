//
//  ThemeCommentListViewController.m
//  TestRedCollar
//
//  Created by MC on 14-8-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ThemeCommentListViewController.h"
#import "NetImageView.h"
#import "CommentModel.h"
#import "CommentView.h"


@interface ThemeCommentListViewController ()

{
    UITableView *mTableView;
}
@end

@implementation ThemeCommentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        int width = tableView.bounds.size.width-20;
        CommentView *comView = [[CommentView alloc] initWithFrame:CGRectMake(10, 0, width, 41)];
        comView.delegate = self;
        //comView.didSelected = @selector(didClickComment:);
        comView.tag = 3000;
        [cell.contentView addSubview:comView];
    }
    
    CommentModel *model = [self.mArray objectAtIndex:indexPath.row];
    
    CommentView *comView = (CommentView *)[cell.contentView viewWithTag:3000];
    if (comView) {
        [comView loadContent:model];
    }
    return cell;
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
