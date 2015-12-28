//
//  TJNoticeViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJNoticeViewController.h"
#import "TJTopicViewModel.h"


@interface TJNoticeViewController ()

@property (nonatomic, strong) UILabel   *lblNotice;
@property (nonatomic, strong) TJTopicViewModel *viewModel;
@property (nonatomic, strong) NSString      *strID;

@end

@implementation TJNoticeViewController

- (instancetype)initWIthID:(NSString *)subID
{
    self = [super init];
    if (self) {
        _viewModel = [[TJTopicViewModel alloc] init];
        self.strID = subID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self BuildUI];
    [self requestData];
}

- (void)initialNaviBar
{
    [self.naviController setNaviBarTitle:@"本吧公告"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 40,40)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
}

- (void)BuildUI
{
    _lblNotice = [[UILabel alloc] initWithFrame:CGRectMake(10, STATUSBAR_HEIGHT + NAVIBAR_HEIGHT + 20, SCREEN_WIDTH- 20, SCREEN_HEIGHT)];
    [_lblNotice setTintColor:[UIColor blackColor]];
//    [_lblNotice setBackgroundColor:[UIColor redColor]];
    [_lblNotice setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_lblNotice];
    
}

- (void)requestData
{
    @weakify(self)
    [_viewModel postTopicBBSNotice:self.strID andFinishBlock:^(NSArray *results) {
        @strongify(self)
        TLog(@"%@",results);
        NSString *strMsg;
        if (results.count != 0) {
            strMsg = [results lastObject];
        }
        else{
            strMsg = @"暂无公告";
        }
       CGSize size = [UIUtil textToSize:strMsg fontSize:15];
        [self.lblNotice setText:strMsg];
        [self.lblNotice setFrame:CGRectMake(self.lblNotice.frame.origin.x, self.lblNotice.frame.origin.y, SCREEN_WIDTH, size.height)];
        
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
       CGSize size  = [UIUtil textToSize:@"暂无公告" fontSize:15];
        [self.lblNotice setText:@"暂无公告"];
        [self.lblNotice setFrame:CGRectMake(_lblNotice.frame.origin.x, self.lblNotice.frame.origin.y, SCREEN_WIDTH, size.height)];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialNaviBar];
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
