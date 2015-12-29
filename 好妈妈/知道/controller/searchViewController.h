//
//  searchViewController.h
//  taobaoapp
//
//  Created by bycc on 13-1-5.
//  Copyright (c) 2013年 aozi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mySearchDelegate <NSObject>

-(void)schLoadData:(NSString *)keyWord title:(NSString *)title;
-(void)remvoeSearchView;
@end




@interface searchViewController : UIViewController
<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isJP;
    UISearchBar * search;
    UIButton * removeBut;
    UIImageView *bgImage;
    
    UITableView * _tableView;
    NSMutableArray * _array;
    
}
@property (nonatomic,retain) UISearchBar * search;
@property(nonatomic ,assign)id<mySearchDelegate>delegate;
@property (nonatomic,retain) NSString * searchWord;

@end
