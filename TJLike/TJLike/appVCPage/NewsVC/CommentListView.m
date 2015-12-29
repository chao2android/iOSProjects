//
//  CommentListView.m
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "CommentListView.h"
#import "NewsCommentInfo.h"
#import "NewsCommentCell.h"
#import "NewsCommentTitleCell.h"

@interface CommentListView ()
{
    UITableView *_theTable;
    NSMutableArray *hotArray;
    NSMutableArray *simpleArray;
}
@end

@implementation CommentListView
- (id)initWithFrame:(CGRect)frame WithNid:(NewsListInfo *) mlInfo{
    self = [super initWithFrame:frame];
    if (self) {
        self.mlInfo = mlInfo;
        
        hotArray = [[NSMutableArray alloc]init];
        simpleArray = [[NSMutableArray alloc]init];
        
        _theTable = [[UITableView alloc]initWithFrame:self.bounds];
        _theTable.delegate = self;
        _theTable.dataSource = self;
        _theTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _theTable.backgroundColor = COLOR(240, 240, 240, 1);
        _theTable.tableHeaderView = [self GetHeaderView];
        [self addSubview:_theTable];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/ArticleCommentList"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSString stringWithFormat:@"%d",mlInfo.nid] forKey:@"nid"];
        [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
            NSLog(@"评论----------------------%@",info);
            NSDictionary *data = info[@"data"];
            NSArray *hot = data[@"hot"];
            for (int i = 0; i<hot.count; i++) {
                NewsCommentInfo *info = [NewsCommentInfo CreateWithDict:hot[i]];
                [hotArray addObject:info];
            }
            NSArray *simple = data[@"simple"];
            for (int i = 0; i<simple.count; i++) {
                NewsCommentInfo *info = [NewsCommentInfo CreateWithDict:simple[i]];
                [simpleArray addObject:info];
            }
            [_theTable reloadData];
            
        } error:^(NSError *error) {
            HttpClient.failBlock(error);
        }];
    }
    return self;
}

- (UIView *)GetHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 67)];
    title.backgroundColor = [UIColor clearColor];
    title.text = self.mlInfo.title;
    title.numberOfLines = 2;
    title.font = [UIFont systemFontOfSize:20];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    [view addSubview:title];
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 67, SCREEN_WIDTH-24, 18)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.text = [NSString stringWithFormat:@"版权所有  请勿转载    %d评论",self.mlInfo.comment];
    subLabel.font = [UIFont systemFontOfSize:10];
    subLabel.textColor = [UIColor blackColor];
    subLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:subLabel];
    
    return view;
}

#pragma mark -tabview dalegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return hotArray.count+1;
    }else {
        return simpleArray.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"CellIdentifierTitle";
        NewsCommentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsCommentTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSString * title = nil;
        if (indexPath.section==0) {
            title = [NSString stringWithFormat:@"热门评论(%d)",(int)hotArray.count];
        }
        else{
            title = [NSString stringWithFormat:@"热门评论(%d)",(int)simpleArray.count];
        }
        [cell LoadText:title];
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifierSimple";
        NewsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.section==0) {
            NewsCommentInfo *info = [hotArray objectAtIndex:indexPath.row-1];
            [cell LoadContent:info];
            cell.sepeLine.hidden = (indexPath.row == hotArray.count);
        }
        else if (indexPath.section == 1){
            NewsCommentInfo *info = [simpleArray objectAtIndex:indexPath.row-1];
            [cell LoadContent:info];
            cell.sepeLine.hidden = (indexPath.row == simpleArray.count);
        }
        
        return cell;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
