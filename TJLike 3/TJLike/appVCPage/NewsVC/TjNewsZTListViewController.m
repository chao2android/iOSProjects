//
//  TjNewsZTListViewController.m
//  TJLike
//
//  Created by MC on 15/4/9.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TjNewsZTListViewController.h"
#import "UIImageView+WebCache.h"
#import "NewsListInfo.h"
#import "ZTListVIew.h"
#import "TJNewsZTDetailViewController.h"

@interface TjNewsZTListViewController ()
{
    UIScrollView *mScrollView;
    UIImageView *topImageView;
    UITextView *briefTextView;
    NSMutableArray *listArray;
}
@end

@implementation TjNewsZTListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"资讯专题"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mScrollView];
    
    topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    [mScrollView addSubview:topImageView];
    
    UIImageView *textBackView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, SCREEN_WIDTH-20, 173)];
    textBackView.backgroundColor = [UIColor colorWithRed:230.f/250.f green:230.f/250.f blue:230.f/250.f alpha:1];
    [mScrollView addSubview:textBackView];
    
    //摘要
    UIImageView *blueBack = [[UIImageView alloc]initWithFrame:CGRectMake(17, 10, 42, 20)];
    blueBack.backgroundColor = [UIColor blueColor];
    [textBackView addSubview:blueBack];
    
    UILabel *briefLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 42, 20)];
    briefLabel.backgroundColor = [UIColor clearColor];
    briefLabel.font = [UIFont systemFontOfSize:16];
    briefLabel.textColor = [UIColor whiteColor];
    briefLabel.textAlignment = NSTextAlignmentCenter;
    briefLabel.text = @"摘要";
    [blueBack addSubview:briefLabel];
    
    briefTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20-20, 155)];
    briefTextView.editable = NO;
    briefTextView.backgroundColor = [UIColor clearColor];
    briefTextView.font = [UIFont systemFontOfSize:14.5];
    [textBackView addSubview:briefTextView];
    
    //最新进展
    UIImageView *mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80+173+20, SCREEN_WIDTH, 25)];
    mImageView.backgroundColor = [UIColor colorWithRed:230.f/250.f green:230.f/250.f blue:230.f/250.f alpha:1];
    [mScrollView addSubview:mImageView];
    
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 25)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.text = @"最新进展";
    mLabel.font = [UIFont systemFontOfSize:13.5];
    mLabel.textColor = [UIColor redColor];
    [mImageView addSubview:mLabel];
    
    [self requestRegionsInfo];
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/ZtList"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",self.mlInfo.ztid] forKey:@"ztid"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        NSLog(@"--------->%@",info);
        [topImageView sd_setImageWithURL:[NSURL URLWithString:info[@"data"][@"infopic"]]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 20;// 字体的行间距
        paragraphStyle.firstLineHeadIndent = 46.f;//首行缩进
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
        briefTextView.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",info[@"data"][@"info"]] attributes:attributes];
        
        NSArray *mArray = info[@"data"][@"content"];
        for (int i = 0; i<mArray.count; i++) {
            NewsListInfo *info = [NewsListInfo CreateWithDict:mArray[i]];
            ZTListVIew *listView = [[ZTListVIew alloc]initWithFrame:CGRectMake(0, 80+173+45+i*84, SCREEN_WIDTH, 84)];
            listView.mDelegate = self;
            listView.onClick = @selector(ListViewClick:);
            [listView LoadContent:info];
            [mScrollView addSubview:listView];
        }
        mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 80+173+45+mArray.count*84);
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
        //[self executeStateBlock];
    }];
    
}
- (void)ListViewClick:(NewsListInfo *)info{
    TJNewsZTDetailViewController *ctrl = [[TJNewsZTDetailViewController alloc]init];
    ctrl.mlInfo = info;
    [self.naviController pushViewController:ctrl animated:YES];
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
