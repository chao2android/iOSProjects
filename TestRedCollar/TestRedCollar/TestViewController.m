//
//  TestViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-7-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self shareView];
    // Do any additional setup after loading the view.
}
- (void)shareView {
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"53cb574b56240bbd9006e87f"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:self.screenshotsImage
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                       delegate:self];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];

}
//-(BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}
//-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response{
//
//
//}
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSString *str = [[response.data allKeys] objectAtIndex:0];
//        _alertView = [[UIAlertView alloc]initWithTitle:@"告知" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//        [_alertView show];
//        [self performSelector:@selector(alertClick) withObject:nil afterDelay:3];
//        
//        
//    }
//}
- (void)alertClick {
 [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)dealloc{
    self.screenshotsImage = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"53cb574b56240bbd9006e87f"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:self.screenshotsImage
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                       delegate:nil];
//
//}
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
