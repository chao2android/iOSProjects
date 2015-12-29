//
//  HuiYuanZhiFuViewController.m
//  好妈妈
//
//  Created by iHope on 14-2-17.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "HuiYuanZhiFuViewController.h"
#import "AsyncImageView.h"
#import "TiaoKuanViewController.h"
#import "JSON.h"

@interface HuiYuanZhiFuViewController ()
{
    NSTimer * tqTimer;
    UIImageView * imageView1;
}
@end

@implementation HuiYuanZhiFuViewController

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
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:backBut];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(80, KUIOS_7(0), navigation.frame.size.width-160, 44)];
    titLab.text = @"会员支付中心";
    titLab.textAlignment = 1;
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [navigation addSubview:titLab];
    [titLab release];
    [self ShowMenth];
    
//    if ([[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]>=6) {
//        goumaiBut.hidden=YES;
//    }
}
- (void)ShowMenth{
    if (imageView1) {
        [imageView1 removeFromSuperview];
        imageView1=nil;
    }
    imageView1=[[UIImageView alloc] initWithFrame:CGRectMake((Screen_Width-303)/2, 15+(KUIOS_7(44)), 303, 392)];
    imageView1.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huiyuan4" ofType:@"png"]];
    imageView1.userInteractionEnabled=YES;
    [self.view addSubview:imageView1];
    [imageView1 release];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userDic=[ud valueForKey:@"logindata"];
    NSLog(@"%@",userDic);
    AsyncImageView * imageV = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 8, 75, 75)];
    imageV.urlString=[userDic valueForKey:@"icon"];
    imageV.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"聊天_3" ofType:@"png"]]];
    [imageView1 addSubview:imageV];
    UILabel* label1  = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.size.width+imageV.frame.origin.x+10, imageV.frame.origin.y+3, 200, 20)];
    
    label1.font=[UIFont systemFontOfSize:18];
    label1.text = [userDic valueForKey:@"name"];
    label1.backgroundColor = [UIColor clearColor];
    [imageView1 addSubview:label1];
    [label1 release];
    
    
    UILabel * label2=[[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, 55, 110, 20)];
    if ([[userDic valueForKey:@"badge"] intValue]==1) {
        label2.text=@"付费会员";
    }else
    {
        
        label2.text=@"非付费会员";
    }
    label2.font=[UIFont systemFontOfSize:15];
    label2.textColor=[UIColor grayColor];
    label2.backgroundColor=[UIColor clearColor];
    [imageView1 addSubview:label2];
    [label2 release];
    if ([[userDic valueForKey:@"badge"] intValue]==1) {
        return;
    }
    UILabel * label4=[[UILabel alloc] initWithFrame:CGRectMake(10, 95, 105, 20)];
    label4.text=@"您的会员特权";
    //    label5.font=[UIFont systemFontOfSize:16];
    label4.textColor=[UIColor blackColor];
    label4.backgroundColor=[UIColor clearColor];
    label4.hidden = YES;
    [imageView1 addSubview:label4];
    [label4 release];
    
    UIButton * tequanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tequanBut.frame=CGRectMake(label4.frame.origin.x+label4.frame.size.width, label4.frame.origin.y, 20, 20);
    [tequanBut addTarget:self action:@selector(TeQuanMenth) forControlEvents:UIControlEventTouchUpInside];
    [tequanBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huiyuan1" ofType:@"png"]] forState:UIControlStateNormal];
    tequanBut.hidden = YES;
    [imageView1 addSubview:tequanBut];
    
    UILabel * label3=[[UILabel alloc] initWithFrame:CGRectMake(tequanBut.frame.size.width+tequanBut.frame.origin.x+5, 93, 100, 20)];
    label3.backgroundColor=[UIColor clearColor];
    label3.hidden = YES;
    [imageView1 addSubview:label3];
    [label3 release];
    
    if ([[userDic valueForKey:@"badge"] intValue]==0) {
        label3.textColor=[UIColor colorWithRed:164/255.0 green:81/255.0 blue:105/255.0 alpha:1];
        label3.text=@"已到期";
        
    }else{
        label3.textColor=[UIColor blackColor];
        label3.text=@"还剩          天";
        UILabel * label9=[[UILabel alloc] initWithFrame:CGRectMake(35, 0, 45, label3.frame.size.height)];
        label9.textColor=[UIColor colorWithRed:164/255.0 green:81/255.0 blue:105/255.0 alpha:1];
        label9.backgroundColor=[UIColor clearColor];
        [label3 addSubview:label9];
        label9.textAlignment=UITextAlignmentCenter;
        label9.text=[NSString stringWithFormat:@"%@",[userDic valueForKey:@"dayday"]];
    }
    
    
    tequanImageView=[[UIImageView alloc] initWithFrame:CGRectMake(tequanBut.frame.origin.x+tequanBut.frame.size.width, tequanBut.frame.origin.y+tequanBut.frame.size.height-5, 135, 40)];
    tequanImageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huiyuan3" ofType:@"png"]];
    [imageView1 addSubview:tequanImageView];
    tequanImageView.hidden=YES;
    
    UILabel * label5=[[UILabel alloc] initWithFrame:CGRectMake(10, 125, 160, 20)];
    label5.text=@"开通付费会员";
    label5.font=[UIFont systemFontOfSize:16];
    label5.textColor=[UIColor blackColor];
    label5.backgroundColor=[UIColor clearColor];
    [imageView1 addSubview:label5];
    [label5 release];
    
    //    UILabel * label6=[[UILabel alloc] initWithFrame:CGRectMake(10, 165, 160, 20)];
    //    label6.text=@"时长： 1年(365天)";
    //    label6.textColor=[UIColor blackColor];
    //    label6.backgroundColor=[UIColor clearColor];
    //    [imageView1 addSubview:label6];
    //    [label6 release];
    
    mlbOldPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 100, 20)];
    mlbOldPrice.text = @"原价：98元";
    mlbOldPrice.textColor = [UIColor grayColor];
    mlbOldPrice.backgroundColor = [UIColor clearColor];
    [imageView1 addSubview:mlbOldPrice];
    [mlbOldPrice release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(-3, 10, mlbOldPrice.frame.size.width+6, 1)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lineView.backgroundColor = [UIColor grayColor];
    [mlbOldPrice addSubview:lineView];
    [lineView release];
    
    mlbNewPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 100, 20)];
    mlbNewPrice.text = @"现价：98元";
    mlbNewPrice.textColor = [UIColor blackColor];
    mlbNewPrice.backgroundColor = [UIColor clearColor];
    [imageView1 addSubview:mlbNewPrice];
    [mlbNewPrice release];
    
    UIImageView * imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(15, 250, 20, 20)];
    imageView2.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shi" ofType:@"png"]];
    [imageView1 addSubview:imageView2];
    [imageView2 release];
    UILabel * label8=[[UILabel alloc]initWithFrame:CGRectMake(imageView2.frame.size.width+imageView2.frame.origin.x+5, imageView2.frame.origin.y, 250, 20)];
    label8.backgroundColor=[UIColor clearColor];
    label8.font=[UIFont systemFontOfSize:(IOS_7?15:16)];
    label8.text=@"接受并同意                                  。";
    [imageView1 addSubview:label8];
    [label8 release];
    label8.userInteractionEnabled=YES;
    
    UIButton * tiaokuanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tiaokuanBut.frame=CGRectMake(80, -5, 150, 30);
    [tiaokuanBut setTitleColor:[UIColor colorWithRed:242/255.0 green:99/255.0 blue:115/255.0 alpha:1] forState:UIControlStateNormal];
    tiaokuanBut.titleLabel.font=[UIFont systemFontOfSize:(IOS_7?15:16)];
    [tiaokuanBut addTarget:self action:@selector(TiaoKuanMenth) forControlEvents:UIControlEventTouchUpInside];
    [tiaokuanBut setTitle:@"好妈妈会员服务条款" forState:UIControlStateNormal];
    [label8 addSubview:tiaokuanBut];
    
    
    UIButton * goumaiBut=[UIButton buttonWithType:UIButtonTypeCustom];
    goumaiBut.frame=CGRectMake((imageView1.frame.size.width-240)/2, imageView1.frame.size.height-95, 240, 34);
    
    [goumaiBut addTarget:self action:@selector(clickdBut) forControlEvents:UIControlEventTouchUpInside];
    [goumaiBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"huiyuan2" ofType:@"png"]] forState:UIControlStateNormal];
    [imageView1 addSubview:goumaiBut];
    
    UIButton * restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    restoreBtn.frame=CGRectMake((imageView1.frame.size.width-240)/2, imageView1.frame.size.height-45, 240, 34);
    [restoreBtn addTarget:self action:@selector(OnRestorePay) forControlEvents:UIControlEventTouchUpInside];
    [restoreBtn setTitle:@"恢复购买" forState:UIControlStateNormal];
    [restoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    restoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [restoreBtn setBackgroundImage:[UIImage imageNamed:@"restorebtn"] forState:UIControlStateNormal];
    [imageView1 addSubview:restoreBtn];
    
    [self GetPriceInfo];

}
- (void)TiaoKuanMenth
{
    TiaoKuanViewController * tiao=[[TiaoKuanViewController alloc]init];
    [self.navigationController pushViewController:tiao animated:YES];
    [tiao release];
}
- (void)TeQuanMenth
{
//    if (tequanImageView.hidden)
//    {
//        if (tqTimer) {
//            [tqTimer invalidate];
//            tqTimer=nil;
//        }
//        if (tqTimer==nil)
//        {
//        tqTimer=[NSTimer timerWithTimeInterval:3 target:self selector:@selector(TQHImageMenth) userInfo:nil repeats:NO];
//        }
//        
//    }else{
//        if (tqTimer) {
////            [tqTimer invalidate];
//            tqTimer=nil;
//        }
//    }
    
    tequanImageView.hidden=!tequanImageView.hidden;
}

- (void)dealloc {
    [self Cancel];
    [super dealloc];
}

- (void)GetPriceInfo {
    if (mDownManager) {
        return;
    }
    mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnLoadFinish:);
    mDownManager.OnImageFail = @selector(OnLoadFail:);
    NSString *urlstr = [NSString stringWithFormat:@"%@todaynewmoney?type=2", SERVER_URL];
    [mDownManager GetImageByStr:urlstr];
}

- (void)Cancel {
    SAFE_CANCEL(mDownManager);
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        float fNewPrice = [[dict objectForKey:@"new"] floatValue];
        float fOldPrice = [[dict objectForKey:@"old"] floatValue];
        
        mlbOldPrice.text = [NSString stringWithFormat:@"原价：%.0f元", fOldPrice];
        [mlbOldPrice sizeToFit];
        mlbNewPrice.text = [NSString stringWithFormat:@"现价：%.0f元", fNewPrice];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)TQHImageMenth
{
    tqTimer=nil;
    tequanImageView.hidden=YES;
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self StopLoading];
    NSLog(@"error %@",[error localizedDescription]);
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
-(void)requestDidFinish:(SKRequest *)request{
    [request release];
    NSLog(@" 请求完成");
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *product = [[response products] lastObject];
    if (!product) {
        NSLog(@"error 没用找到商品");
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
                NSLog(@"恢复成功");
                break;
            case SKPaymentTransactionStateFailed:
                
                [self StopLoading];
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
    
    
    NSString * s=[NSString stringWithFormat:@"http://apptest.mum360.com/web/home/index/pay?uid=%@&token=%@",userDic[@"uid"],userDic[@"token"]];
    
    NSMutableURLRequest * req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:s]];
    [req setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:req delegate:self];
    
    [self StopLoading];
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                  message:@"您已成功开通好好妈妈付费会员服务"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self ShowMenth];

}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction");
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)clickdBut{
    [self StartLoading];
    
    SKProductsRequest *preq = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.mum360.iMama.VIP"]];
    preq.delegate = self;
    [preq start];
}

- (void)OnRestorePay {
    NSLog(@"OnRestorePay");
    [self StartLoading];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Restore
//
//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
//    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished:%@", queue);
//    [self buySuccess];
//}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"queue.transactions:%@",queue.transactions);
    if (!queue.transactions || [queue.transactions count] == 0) {
        [self clickdBut];
    }
    else {
        [self buySuccess];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    //取消
    [self StopLoading];
    NSLog(@"==============paymentQueue   restore=========================");
    NSLog(@"%@, %@", [queue transactions], error);
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"恢复购买失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)clicked_backBut
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)StartLoading
{
    if (mLoadView) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
//    mLoadView.mode = MBProgressHUDModeCustomView;
//    mLoadView.labelText = @"加载中";
    [self.view addSubview:mLoadView];
    [mLoadView release];
    
    [mLoadView show:YES];
}

- (void)StopLoading
{
    [mLoadView hide:YES];
    mLoadView = nil;
}

@end
