//
//  BaobaoJintianViewController.m
//  好妈妈
//
//  Created by iHope on 13-10-29.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "BaobaoJintianViewController.h"
#import "HuiYuanZhiFuViewController.h"
@interface BaobaoJintianViewController ()

@end

@implementation BaobaoJintianViewController
@synthesize webViewString;
- (void)dealloc
{
    [webViewString release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidesTabBar" object:nil];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayTabBar" object:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(Screen_Height-20))];
    backImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"底" ofType:@"png"]];
    [self.view addSubview:backImageView];
    [backImageView release];
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.userInteractionEnabled=YES;
    navigation.backgroundColor=[UIColor blackColor];
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    UILabel * navigationLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(11), (Screen_Width-160), 22)];
    navigationLabel.backgroundColor=[UIColor clearColor];
    //    navigationLabel.font=[UIFont systemFontOfSize:22];
    navigationLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    navigationLabel.textAlignment=NSTextAlignmentCenter;
    navigationLabel.textColor=[UIColor whiteColor];
    navigationLabel.text=@"宝宝今天";
    [navigation addSubview:navigationLabel];
    [navigationLabel release];
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, KUIOS_7(7), 51, 33);
    [back setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backup) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:back];
    int iLeft = (self.view.frame.size.width-320)/2;
    int iOffset = 2.5;
//    if (ISIPAD) {
//        iOffset = 20;
//    }
//    
    myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(iOffset*2, KUIOS_7(44), self.view.frame.size.width-iOffset*4, Screen_Height-44-20-20)];
    
    NSURL *url=[NSURL URLWithString:self.webViewString];
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    myWebView.backgroundColor = [UIColor whiteColor];
    myWebView.delegate = self;
    myWebView.scrollView.delegate = self;
    [myWebView loadRequest:request];
    myWebView.scalesPageToFit =YES;
    //  [myWebView setUserInteractionEnabled:YES];
    [self.view addSubview:myWebView];
    [myWebView release];
    
    dingBgView = [[UIImageView alloc]initWithFrame:CGRectMake(50+iLeft, myWebView.scrollView.contentSize.height, 220, 60)];
    dingBgView.backgroundColor = [UIColor clearColor];
    dingBgView.userInteractionEnabled = YES;
    [myWebView.scrollView  addSubview:dingBgView];
    [dingBgView release];
    
    UIButton *cBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cBut.frame = CGRectMake(10, 0, 200, 30);
    [cBut setBackgroundImage:[UIImage imageNamed:@"004_11.png"] forState:UIControlStateNormal];
    cBut.showsTouchWhenHighlighted = YES;
    [cBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [cBut setTitle:@"查看更多个性化养育信息" forState:UIControlStateNormal];
    [cBut setTitle:@"定制个性化养育信息服务" forState:UIControlStateNormal];
    cBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [dingBgView addSubview:cBut];
    
    UIButton *dBut = [UIButton buttonWithType:UIButtonTypeCustom];
    dBut.frame = CGRectMake(10, 30, 200, 25);
    [dBut setBackgroundImage:[UIImage imageNamed:@"004_10.png"] forState:UIControlStateNormal];
    [dBut addTarget:self action:@selector(clickdBut) forControlEvents:UIControlEventTouchUpInside];
    [dBut setTitle:@"加入好妈妈会员" forState:UIControlStateNormal];
    dBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [dingBgView addSubview:dBut];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    if ([[userDic valueForKey:@"dayday"] intValue]<=3&&![[[[[NSUserDefaults standardUserDefaults] valueForKey:@"tixingshoufei"] componentsSeparatedByString:@"-"] objectAtIndex:2] isEqualToString:[[date componentsSeparatedByString:@"-"] objectAtIndex:2]]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tixingshoufei"];
        [[NSUserDefaults standardUserDefaults] setValue:date forKey:@"tixingshoufei"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * string=[NSString stringWithFormat:@"您的Vip会员将于%@天后到期",[userDic valueForKey:@"dayday"]];

        if (![[userDic valueForKey:@"dayday"] intValue]) {
            
        string=[NSString stringWithFormat:@"您的Vip会员已到期"];
        }
#ifndef HideVipMsg
//        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
//                                                      message:string
//                                                     delegate:self
//                                            cancelButtonTitle:@"确定"
//                                            otherButtonTitles:@"续费",nil];
//        [alert show];
//        [alert release];
#endif
    }
   
    NSString *buyS = [NSString stringWithFormat:@"%@",userDic[@"badge"]];
    if ([buyS isEqualToString:@"1"]||[[userDic valueForKey:@"type"] intValue]==3||[[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]>=6) {
        dingBgView.hidden = YES;
    }else{
        dingBgView.hidden = NO;
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self clickdBut];
    }
}
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"error %@",[error localizedDescription]);
}
-(void)requestDidFinish:(SKRequest *)request{
    [request release];
    NSLog(@" 请求完成，，，");
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *product = [[response products] lastObject];
    if (!product) {
        NSLog(@"error 没用找到商品");
        [self remHUD];
        
        return;
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.locale = product.priceLocale;
    NSString * formattedString = [numberFormatter stringFromNumber:product.price];
    [numberFormatter release];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    NSLog(@"title  %@",product.localizedTitle);
    NSLog(@"tion   %@",product.localizedDescription);
    NSLog(@"Price  %@",formattedString);
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self buySuccess];
                NSLog(@"购买成功");
            case SKPaymentTransactionStateRestored:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                
                [self completeTransaction:transaction];
                break;
                //      case SKPaymentTransactionStatePurchasing:
                //        break;
            default:
                break;
        }
    }
}

-(void)buySuccess{
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userDic];
    [dic setObject:@"1" forKey:@"badge"];
    
    [ud setObject:dic forKey:@"logindata"];
    
    for (id d in self.view.subviews) {
        [d removeFromSuperview];
    }
    [self remHUD];
    
    NSString * s=[NSString stringWithFormat:@"http://apptest.mum360.com/web/home/index/pay?uid=%@&token=%@",userDic[@"uid"],userDic[@"token"]];
    
    NSMutableURLRequest * req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:s]];
    [req setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:req delegate:self];
    
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                  message:@"订阅成功！"
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)clickdBut{
    
    HuiYuanZhiFuViewController * huiyuanzhifu=[[HuiYuanZhiFuViewController alloc] init];
    [self.navigationController pushViewController:huiyuanzhifu animated:YES];
    [huiyuanzhifu release];
//    [self makeHUD];
//    SKProductsRequest *preq = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:@"com.mum.iMama.BabyToday"]];
//    preq.delegate = self;
//    [preq start];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self makeHUD];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self remHUD];
    NSLog(@"%@",[webView subviews]);
    
    [self performSelector:@selector(Abcd) withObject:self afterDelay:0.3];
    NSLog(@"成功");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"错误");
    [self remHUD];
    
}
- (void)Abcd
{
    myWebView.scrollView.contentSize=CGSizeMake(myWebView.scrollView.frame.size.width, myWebView.scrollView.contentSize.height+50);
}

-(void)makeHUD{
    [self remHUD];
    
    myHUD= [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:myHUD];
    //  myHUD.dimBackground = YES;
    myHUD.labelText = @"加载中..";
    [myHUD show:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int iLeft = (self.view.frame.size.width-320)/2;
    if (dingBgView) {
        dingBgView.frame = CGRectMake(50+iLeft, scrollView.contentSize.height-65, 220, 60);
        if (ISIPAD) {
            dingBgView.frame = CGRectMake(iLeft, scrollView.contentSize.height-65, 220, 60);
            
        }
    }
    
    
}

-(void)remHUD{
    if (myHUD) {
        [myHUD removeFromSuperview];
        [myHUD release];
        myHUD=nil;
    }
}
- (void)backup
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
