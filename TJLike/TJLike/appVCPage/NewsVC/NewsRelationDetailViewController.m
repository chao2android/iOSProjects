//
//  NewsRelationDetailViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsRelationDetailViewController.h"

@interface NewsRelationDetailViewController ()
{
    UIWebView *mWebView;
}

@end

@implementation NewsRelationDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"资讯新闻"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    mWebView.scalesPageToFit =NO;
    //mWebView.delegate =self;
    mWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:mWebView];
    
    [self requestRegionsInfo];
}

- (void)requestRegionsInfo {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/Aview"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%@",self.nid] forKey:@"nid"];
    [[HttpClient postRequestWithPath:urlStr para:dict] subscribeNext:^(NSDictionary *info) {
        NSLog(@"info--------%@",info);
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",info[@"data"][@"description"]];
        NSString *cutStr = @"alt=";
        //NSString *centerStr = @"<img";
        NSRange  rang = [str rangeOfString:cutStr];
        //NSRange  rangC = [str rangeOfString:centerStr];
        if (rang.location != NSNotFound) {
            int location = rang.location;
            NSString *strFrame = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\" margin=\"%f\" style=\"text-align: center\" ", SCREEN_WIDTH - 20,SCREEN_WIDTH/2,20.0];
            //NSString *strCFrame = [NSString stringWithFormat:@"<p style=\"text-align:center\">"];
            [str insertString:strFrame atIndex:location];
            
            //int locationCenter = rangC.location;
            //[str insertString:strCFrame atIndex:locationCenter];
            
        }
        
        [mWebView loadHTMLString:str baseURL:nil];
        
    } error:^(NSError *error) {
        HttpClient.failBlock(error);
        //[self executeStateBlock];
    }];
    
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
