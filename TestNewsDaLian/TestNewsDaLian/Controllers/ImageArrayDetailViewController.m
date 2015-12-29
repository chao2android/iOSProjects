//
//  ImageArrayDetailViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/24.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "ImageArrayDetailViewController.h"
#import "WriteViewController.h"
#import "ImageModel.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
@interface ImageArrayDetailViewController ()
{
    UIButton *loveButton;
    UIButton *writeButton;
    UIButton *shareButton;
    UIView * fenView;
    UILabel * _loveNum;
    UIView * _shareView;

}
@end

@implementation ImageArrayDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [UMSocialWechatHandler setWXAppId:@"wx976f0ba15f6097c9" appSecret:@"500955c401d8655926cf57f352a3746e" url:[NSString stringWithFormat:@"%@%@",kShareUrl,self.model.source_id]];

}

- (void)viewDidLoad {
    NSMutableArray * imageArray = [[NSMutableArray alloc] init];
    
    [self getData];
    
    NSArray * picturesArray = (NSArray *)self.model.pictures;
    for (NSDictionary * dict in picturesArray) {
        
        NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"note"], @"pictxt",[dict objectForKey:@"image"],@"picurl",nil];
        [imageArray addObject:dictionary];
        
        
    }


    if(imageArray.count)
    {
        self.page = 0;
        self.mPhotoArray=[NSMutableArray new];
        self.mThumbArray=[NSMutableArray new];
        self.mTextArray=[NSMutableArray new];
        self.mMainTextArray=[NSMutableArray new];
        for(int i=0 ;i<imageArray.count;i++)
        {
            NSDictionary *dic=imageArray[i];
            NSString *imageurl=[dic objectForKey:@"picurl"];
            NSString *imagetxt= [dic objectForKey:@"pictxt"];
            NSString *mainText=@"";
            [self.mPhotoArray addObject:imageurl];
            [self.mThumbArray addObject:imageurl];
            [self.mMainTextArray addObject:mainText];
            [self.mTextArray addObject:imagetxt];
            
        }
    }
    
    [super viewDidLoad];
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(23, 30, 11, 20);
    // [btnClose setBackgroundImage:[UIImage imageNamed:@"f_btnback"] forState:UIControlStateNormal];
    [btnClose setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    //[ btnClose  setImageEdgeInsets:UIEdgeInsetsMake(17,13,11,20)];
    [btnClose addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //backView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    [backView addGestureRecognizer:tap];
    
    [self.view addSubview:backView];
    
    

    
    
    [backView addSubview:btnClose];
//    btnClose.backgroundColor=[UIColor clearColor];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, MainScreenWidth, 18)];
    label.text = _titleName;

    //label.font = [UIFont boldSystemFontOfSize:20];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    
    
    [self uiThreeButton];
    [self createShareButton];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];


    // Do any additional setup after loading the view.
}


#pragma mark - 获取数据
- (void)getData{
    if (_mDownManager) {
        return;
    }
    //[self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=pictureDetail";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"12345",@"SeqNo",
                          @"1C2CE69AE467696B76517F2F8D25E461",@"Source",
                          kUUID,@"TerminalSN",
                          kTimeSp,@"TimeStamp",
                          _source_id,@"source_id",
                          @"1",@"limit",
                          nil];
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
    
}
- (void)OnLoadFinish:(ImageDownManager *)sender {

    NSDictionary *dict = [sender.mWebStr JSONValue];
    
    NSDictionary * dataDict = [dict objectForKey:@"data"];
    
    _loveNum.text = [dataDict objectForKey:@"pv"];
}

- (void)OnLoadFail:(ImageDownManager *)sender {
   // [self Cancel];
}


- (void)createShareButton{
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0,MainScreenHeight - 230 , MainScreenWidth, 230)];
    _shareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_shareView];
    _shareView.hidden = YES;
    
    NSArray * array = @[@"朋友圈.png",@"QQ好友.png",@"微信好友.png",@"新浪微博.png"];
    
    NSArray * titleArray  = @[@"微信朋友圈",@"QQ好友",@"微信好友",@"新浪微博"];
    
    for (int i = 0; i < array.count - 1 ; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button setTag:100 + i];
        [button addTarget:self action:@selector(UMShare:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake((MainScreenWidth - 45*3)/4 + i *( (MainScreenWidth - 45 *3)/4 + 45),20, 45, 45)];
        [_shareView addSubview:button];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 65*3)/4 + i *( (MainScreenWidth - 65 *3)/4 + 65), 75, 65, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [_shareView addSubview:titleLabel];
        
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:array[3]] forState:UIControlStateNormal];
    [button setTag:103];
    [button addTarget:self action:@selector(UMShare:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake((MainScreenWidth - 45 * 3)/4 ,105, 45, 45)];
    [_shareView addSubview:button];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 65*3)/4 , 165, 65, 20)];
    titleLabel.text = titleArray[3];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [_shareView addSubview:titleLabel];
    
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, _shareView.frame.size.height - 38, MainScreenWidth, 38)];
    [cancelButton setTitle:@"取消分享" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:46/255.0 green:140/255.0 blue:192/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(whenClickBlackView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [_shareView addSubview:cancelButton];
}


#pragma mark - 友盟分享  add by dxy
- (void)UMShare:(UIButton *)button{
    switch (button.tag) {
        case 100://微信朋友圈
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.model.title image:@"" location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",kShareUrl,self.model.source_id]] presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    _shareView.hidden= NO;
                    //                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    //                    [alertView show];
                    [DxyCustom showSureAlertViewTitle:@"分享成功" message:@"确定" delegate:nil];
                    
                }
            }];
        }
            break;
        case 101://qq好友
        {
            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%@",kShareUrl,self.model.source_id];
            [UMSocialData defaultData].extConfig.qqData.title = self.model.title;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.model.title image:nil location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",kShareUrl,self.model.source_id]] presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
            
        }
            break;
        case 102://微信好友
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.model.title image:@"" location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",kShareUrl,self.model.source_id]]  presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    _shareView.hidden= NO;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
            
        }
            break;
        case 103://新浪微博
        {
            
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                self.model.thumb];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@%@",self.model.title,kShareUrl,self.model.source_id] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                    NSLog(@"分享成功！");
                }
            }];
            
            
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - 点击灰色的背景  隐藏 add by dxy
- (void)whenClickBlackView{
    
    _shareView.hidden = YES;
}

- (void)shareButtonOnClick{

    _shareView.hidden = NO;
}

- (void)uiThreeButton{

    fenView=[UIView new];
    [self.view addSubview:fenView];
    fenView.backgroundColor=[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
    fenView.frame=CGRectMake(0, MainScreenHeight-50, MainScreenWidth, 50);
    
    loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loveButton setImage:[UIImage imageNamed:@"weidianji.png"] forState:UIControlStateNormal];
    [loveButton setImage:[UIImage imageNamed:@"love.png"] forState:UIControlStateSelected];
    [loveButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/4, 2, 30, 30)];
    [loveButton addTarget:self action:@selector(loveButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [fenView addSubview:loveButton];
    
    
    writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeButton setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(writeOnClick) forControlEvents:UIControlEventTouchUpInside];
    [writeButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/2  + 30, 2, 30, 30)];
    [fenView addSubview:writeButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/4*3+ 60, 2, 30, 30)];
    [fenView addSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];

    
    NSArray * array = @[@"评论",@"分享"];
    UILabel * lovelabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 30* 3)/2  + 30, 28, 30, 15)];
    lovelabel.font = [UIFont systemFontOfSize:10];
    lovelabel.textColor = [UIColor whiteColor];
    lovelabel.textAlignment = NSTextAlignmentCenter;
    lovelabel.text = array[0];
    [fenView addSubview:lovelabel];
    
    UILabel * sharelable = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 30* 3)/4*3+ 60, 28, 30, 15)];
    sharelable.font = [UIFont systemFontOfSize:10];
    sharelable.textColor = [UIColor whiteColor];
    sharelable.textAlignment = NSTextAlignmentCenter;
    sharelable.text = array[1];
    [fenView addSubview:sharelable];
    
    
    _loveNum = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 30* 3)/4, 28, 30, 15)];
    _loveNum.font = [UIFont systemFontOfSize:10];
    _loveNum.text =self.model.pv;
    _loveNum.textColor = [UIColor whiteColor];
    _loveNum.textAlignment = NSTextAlignmentCenter;
    
    [fenView addSubview:_loveNum];

    
}


#pragma mark - 点赞按钮
- (void)loveButtonOnClick{
    
    loveButton.selected = YES;
    _loveNum.text = [NSString stringWithFormat:@"%ld",[_loveNum.text integerValue] + 1];
    loveButton.userInteractionEnabled = NO;
    
}

#pragma mark - 点击评论框
- (void)writeOnClick{

    WriteViewController * write = [[WriteViewController alloc] init];
    write.model = self.model;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:write animated:YES];
}

#pragma mark - 父类方法 隐藏
-(BOOL)hideTextView:(UIButton *)sender
{
    BOOL hidden= [super hideTextView:sender];

    fenView.hidden = hidden;
    return hidden;
}


- (void)closeWindow{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
