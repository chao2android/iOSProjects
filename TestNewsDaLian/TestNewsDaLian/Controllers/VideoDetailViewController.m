//
//  VideoDetailViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/26.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "DxyCustom.h"
#import "ALMoviePlayerController.h"
#import "TFHpple.h"
#import "SoapHelper.h"
#import "UMSocial.h"
#import "CommintModel.h"
#import "WriteTableViewCell.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
@interface VideoDetailViewController ()
{
    UIView *_threeButtonBgView;
    UIButton *loveButton;
    UIButton *writeButton;
    UIButton *shareButton;
    
    UILabel * _titleLabel;//标题
    UILabel * _timeLabel;//时间
    UILabel * _writeLabel;//评论数
    
    UITableView * _tableView;
    
    NSInteger _rowsNum;//有多少个tableviewcell
    NSMutableArray * _dataArray;//评论的数组
    NSString * _descriptionString;
    
    ALMoviePlayerController * moviePlayer;
    
    NSDictionary * dataDict;
    
    UIView * _shareView;
    
    
    UIImageView * grayImageView;
    UIImageView * whiteImageView;
    UITextView * _textView;
    
    UILabel * _loveNum;
    
    NSInteger keyboardhight;//键盘的高度
    
    NSString * thumbString;
    
    
    UIView * blackView ;//视频播放的背景  一个黑色的背景有一个开始的按钮    把视频播放控件放在上面   可以滑动
    
}
@end

@implementation VideoDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = self.titleNameString;
    [UMSocialWechatHandler setWXAppId:@"wx976f0ba15f6097c9" appSecret:@"500955c401d8655926cf57f352a3746e" url:[NSString stringWithFormat:@"%@%@",kShareUrl,[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceId"]]];
    //[UMSocialSinaHandler openSSOWithRedirectURL:[NSString stringWithFormat:@"%@%@",kShareUrl,[[NSUserDefaults standardUserDefaults]objectForKey:@"sourceId"]]];


    [self AddLeftImageBtn:[UIImage imageNamed:@"goBack.png"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    [self registerForKeyboardNotifications];//注册通知  观察键盘的变化
}

-(void)viewWillDisappear:(BOOL)animated
{
    [moviePlayer stop];
    if (moviePlayer) {
        moviePlayer.delegate = nil;
        moviePlayer =nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//观察键盘变化的方法
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    if(kbSize.height == 216)
    {
        keyboardhight = 0;

    }
    else
    {
        keyboardhight = 36;   //252 - 216 系统键盘的两个不同高度
    }
    
    if (kbSize.height==252) {
        
        [UIView animateWithDuration:0.26 animations:^{
            [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-252-150, MainScreenWidth, 150)];
        }];

    }
    //输入框位置动画加载
    //[self begainMoveUpAnimation:keyboardhight];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    if (kVersion>7.0) {
        
    }else {
        [UIView animateWithDuration:0.26 animations:^{
            [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-216-150, MainScreenWidth, 150)];
        }];
    }
}

//输入结束时调用动画（把按键。背景。输入框都移下去）
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"tabtabtab");
    //[self endEditAnimation];
    
    //释放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:_source_id forKey:@"sourceId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self getData];
    [self uiConfig];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 分享的四个按钮
- (void)createShareButton{
    
    mBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    mBlackView.hidden = YES;
    [mBlackView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whenClickBlackView)];
    [mBlackView addGestureRecognizer:singleTap];
    
    [self.view addSubview:mBlackView];
    
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0,MainScreenHeight - 230 - 64 , MainScreenWidth, 230)];
    _shareView.backgroundColor = [UIColor whiteColor];
    [mBlackView addSubview:_shareView];
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

#pragma mark - 収键盘
- (void)hiddenKeyBoard{
    grayImageView.hidden = YES;
    [_textView resignFirstResponder];
}


#pragma mark - 点击灰色的背景  隐藏 add by dxy
- (void)whenClickBlackView{
    
    mBlackView.hidden = YES;
}


#pragma mark - 友盟分享  add by dxy
- (void)UMShare:(UIButton *)button{
    switch (button.tag) {
        case 100://微信朋友圈
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_titleLabel.text image:@"" location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",kShareUrl,_source_id]] presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    mBlackView.hidden= NO;
                    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    //[alertView show];
                    [DxyCustom showSureAlertViewTitle:@"分享成功" message:@"确定" delegate:nil];
                }
            }];
        }
            break;
        case 101://qq好友
        {
            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%@",kShareUrl,_source_id];
            [UMSocialData defaultData].extConfig.qqData.title = _titleLabel.text;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_titleLabel.text image:nil location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",kShareUrl,_source_id]] presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];

        }
            break;
        case 102://微信好友
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_titleLabel.text image:@"" location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",kShareUrl,_source_id]]  presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    mBlackView.hidden= NO;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
            
        }
            break;
        case 103://新浪微博
        {

            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                thumbString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@%@",_titleLabel.text,kShareUrl,_source_id] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
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



#pragma mark - UI布局
- (void)uiConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    [self createThreeButton];
}

- (void)createTitle{
    _titleLabel = [DxyCustom creatLabelWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 20) text:@"" alignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:_titleLabel];
    
    
    //文章标题   时间    浏览数
    _titleLabel.text = [dataDict objectForKey:@"title"];
    CGSize size =  [DxyCustom boundingRectWithString:[dataDict objectForKey:@"title"] width:MainScreenWidth - 20 height:18000 font:19];
    [_titleLabel setFrame:CGRectMake(10, 5, MainScreenWidth - 20, size.height)];
    

    
    
    UIImageView * timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 10, 9, 9)];
    timeImageView.image = [UIImage imageNamed:@"55.png"];
    [self.view addSubview:timeImageView];
    
    _timeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(22, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 10, 90, 10) text:@"" alignment:NSTextAlignmentLeft];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_timeLabel];
    
    UIImageView * writeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 10, 9,9)];
    writeImageView.image = [UIImage imageNamed:@"56.png"];
    [self.view addSubview:writeImageView];
    
    _writeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(122, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 10, 90, 10) text:@"0" alignment:NSTextAlignmentLeft];
    _writeLabel.font = [UIFont systemFontOfSize:10];
    _writeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_writeLabel];
    _timeLabel.text = [[DxyCustom getTimeWithTimeSp:[dataDict objectForKey:@"ctime"]] substringToIndex:16];
    _loveNum.text = [dataDict objectForKey:@"pv"];
    

    
    //评论的输入框
    grayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    grayImageView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.5];
    grayImageView.hidden = YES;
    grayImageView.userInteractionEnabled = YES;
    //[self.view addSubview:grayImageView];
    
    if (kVersion >= 8.0) {
        whiteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 64-253-150, MainScreenWidth, 150)];
    }else {
        whiteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 64-216-150, MainScreenWidth, 150)];
    }
    
    
    whiteImageView.backgroundColor = [UIColor redColor];
    whiteImageView.userInteractionEnabled = YES;
    whiteImageView.image = [UIImage imageNamed:@"kuagn.png"];
    [grayImageView addSubview:whiteImageView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    [grayImageView addGestureRecognizer:tap];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, MainScreenWidth - 40, 99)];
    _textView.font = [UIFont systemFontOfSize:17];
    [whiteImageView addSubview:_textView];
    
    
    UIButton * fabiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [fabiao setBackgroundImage:[UIImage imageNamed:@"fabiao"] forState:UIControlStateNormal];
    [fabiao setFrame:CGRectMake(MainScreenWidth - 70 , 150-30, 54, 23)];
    [fabiao addTarget:self action:@selector(ifTextViewNull) forControlEvents:UIControlEventTouchUpInside];
    [whiteImageView addSubview:fabiao];
    
}

#pragma mark - 判断是否可以发送空的评论
- (void)ifTextViewNull{

    if (_textView.text.length>0) {
        [self writeOnClick];
    }else{
        [DxyCustom showAlertViewTitle:@"提示" message:@"请输入评论内容" delegate:nil];
    }

}


#pragma mark - 评论分享点赞
- (void)createThreeButton{
    _threeButtonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50-64, MainScreenWidth, 50)];
    _threeButtonBgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_threeButtonBgView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    label.backgroundColor = [UIColor grayColor];
    [_threeButtonBgView addSubview:label];
    
    loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loveButton setImage:[UIImage imageNamed:@"blueUnSelect.png"] forState:UIControlStateNormal];
    [loveButton addTarget:self action:@selector(loveButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [loveButton setImage:[UIImage imageNamed:@"blueLove.png"] forState:UIControlStateSelected];
    [loveButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/4, 1, 30, 30)];
    [_threeButtonBgView addSubview:loveButton];
    
    
    writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeButton setImage:[UIImage imageNamed:@"blueWrite.png"] forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(grayImageViewHidden) forControlEvents:UIControlEventTouchUpInside];
    [writeButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/2  + 30, 1, 30, 30)];
    [_threeButtonBgView addSubview:writeButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"blueShare.png"] forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/4*3+ 60, 1, 30, 30)];
    [shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_threeButtonBgView addSubview:shareButton];
    
    NSArray * array = @[@"评论",@"分享"];
    UILabel * lovelabel = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 30* 3)/2  + 30, 26, 30, 15)];
    lovelabel.font = [UIFont systemFontOfSize:10];
    lovelabel.textAlignment = NSTextAlignmentCenter;
    lovelabel.text = array[0];
    [_threeButtonBgView addSubview:lovelabel];
    
    UILabel * sharelable = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 30* 3)/4*3+ 60, 26, 30, 15)];
    sharelable.font = [UIFont systemFontOfSize:10];
    sharelable.textAlignment = NSTextAlignmentCenter;
    sharelable.text = array[1];
    [_threeButtonBgView addSubview:sharelable];

    
    _loveNum = [[UILabel alloc] initWithFrame:CGRectMake((MainScreenWidth - 30* 3)/4, 26, 30, 15)];
    _loveNum.font = [UIFont systemFontOfSize:10];
    _loveNum.text = @"0";
    _loveNum.textAlignment = NSTextAlignmentCenter;
    
    [_threeButtonBgView addSubview:_loveNum];
    
}

#pragma mark - 点赞按钮
- (void)loveButtonOnClick{

    loveButton.selected = YES;
    _loveNum.text = [NSString stringWithFormat:@"%ld",[_loveNum.text integerValue] + 1];
    loveButton.userInteractionEnabled = NO;

}

#pragma mark - 点击评论按钮
- (void)grayImageViewHidden{
    [moviePlayer pause];
    [self.view addSubview:grayImageView];
    [_textView becomeFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{
            grayImageView.hidden = NO;
    }];

}

- (void)shareButtonOnClick{
    [moviePlayer pause];
    mBlackView.hidden = NO;
}


#pragma mark - 点击评论按钮
- (void)writeOnClick{
    
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(wirteOnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://42.202.146.236:8080/comment/services/rs/comments/add";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          _source_id,@"resourceID",
                          _textView.text,@"commentInfo",
                          nil];
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
}

- (void)wirteOnLoadFinish:(ImageDownManager *)sender {
    
    if ([sender.mWebStr isEqualToString:@"true"]) {
        NSLog(@"评论成功");
        [grayImageView setHidden:YES];
        
        CommintModel * model = [[CommintModel alloc] init];
        [model setCommentInfo:_textView.text];
        [_dataArray addObject:model];
        _rowsNum++;
        [_tableView reloadData];
        [_tableView scrollRectToVisible:CGRectMake(0, _tableView.contentSize.height-_tableView.frame.size.height, MainScreenWidth,_tableView.frame.size.height) animated:YES];
        
        if (kVersion>=8.0) {
            
        }else{
            [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-216-150, MainScreenWidth, 150)];
        }

        _textView.text = @"";
        _writeLabel.text = [NSString stringWithFormat:@"%d",[_writeLabel.text integerValue] + 1];
        [_textView resignFirstResponder];
    }

    [self Cancel];
    
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 30, MainScreenWidth, MainScreenHeight -(_titleLabel.frame.origin.y + _titleLabel.frame.size.height + 30)-64-50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    [self createShareButton];
    
}

#pragma mark - UITableView Delegate & UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _rowsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 182;
    }else
    if (indexPath.row==1) {
        CGSize size =  [DxyCustom boundingRectWithString:_descriptionString width:300 height:18000 font:[[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]];
        
        return size.height + 40;
        
    }else if(indexPath.row == 2){
        
        return 30;
        
    }else{
        CommintModel * model = [_dataArray objectAtIndex:indexPath.row-3];
        CGSize size =  [DxyCustom boundingRectWithString:model.commentInfo width:MainScreenWidth - 66 height:800 font:14];
        return size.height +50;

    }
}


#pragma mark - 播放视频
- (void)playerOnClick{
    moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth-20, 182)];
    moviePlayer.delegate = self;
    
    ALMoviePlayerControls * movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:moviePlayer style:ALMoviePlayerControlsStyleDefault];
    [moviePlayer setControls:movieControls];
    [blackView addSubview:moviePlayer.view];
    
    [moviePlayer setContentURL:[NSURL URLWithString:[dataDict objectForKey:@"video"]]];
    NSLog(@"视频%@",[dataDict objectForKey:@"video"]);
    
    
}
//IMPORTANT!
- (void)moviePlayerWillMoveFromWindow {
    //movie player must be readded to this view upon exiting fullscreen mode.
    if (![self.view.subviews containsObject:moviePlayer.view])
        [blackView addSubview:moviePlayer.view];
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    [moviePlayer setFrame:CGRectMake(0, 0, MainScreenWidth - 20, 182)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * cellIde = @"video";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            
            //黑色的背景  播放视频的
            blackView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, MainScreenWidth-20, 182)];
            blackView.backgroundColor = [UIColor blackColor];
            [cell addSubview:blackView];
            
            if ([DxyCustom isWifi]) {//wifi情况
                
                NSString * wifi = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"];
                if ([wifi isEqualToString:@"1"]) {//打开的 就是wifi下自动播放视频
                    [self playerOnClick];
                    
                }else{//wifi下不会自动播放视频  而且2g  3g   也都不是自动播放视频的
                    UIButton * playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [playerButton setFrame:CGRectMake((MainScreenWidth-60)/2-10, (182-60)/2, 60, 60)];
                    [playerButton setBackgroundImage:[UIImage imageNamed:@"videoplaybutton"] forState:UIControlStateNormal];
                    [playerButton addTarget:self action:@selector(playerOnClick) forControlEvents:UIControlEventTouchUpInside];
                    [blackView addSubview:playerButton];
                    
                }

                
            }else{
            
                UIButton * playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [playerButton setFrame:CGRectMake((MainScreenWidth-60)/2-10, (182-60)/2, 60, 60)];
                [playerButton setBackgroundImage:[UIImage imageNamed:@"videoplaybutton"] forState:UIControlStateNormal];
                [playerButton addTarget:self action:@selector(playerOnClick) forControlEvents:UIControlEventTouchUpInside];
                [blackView addSubview:playerButton];

            }
            
            
           
        }
        return cell;
    }
    if (indexPath.row ==1) {
        static NSString * cellIde = @"write";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            CGSize size =  [DxyCustom boundingRectWithString:_descriptionString width:300 height:18000 font:[[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]];
            UILabel * label = [DxyCustom createDiffFontLabelWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, size.height) text:@"" alignment:NSTextAlignmentLeft];
            label.numberOfLines = 0;
            label.text = _descriptionString;
            [cell.contentView addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        return cell;
    }else if(indexPath.row==2) {
        
        static NSString * cellIde = @"pinglun";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            UILabel * writeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(0, 5, MainScreenWidth, 20) text:@"评论" alignment:NSTextAlignmentCenter];
            writeLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/255.0 blue:224/255.0 alpha:1];
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            [cell.contentView addSubview:writeLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        
        static NSString * cellIde = @"commint";
        WriteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil) {
            cell = [[WriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        CommintModel * model = [_dataArray objectAtIndex:indexPath.row - 3];
        [cell setUIConfigWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 获取数据
- (void)getData{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://vnews.cdv.com/app/?app=newsapp&controller=iosapi&action=videoDetail";
    
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
    [self Cancel];
    dataDict= [dict objectForKey:@"data"];
    thumbString = [dataDict objectForKey:@"thumb"];
    NSString * str = [dataDict objectForKey:@"description"];
    NSData *htmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *nodeString = @"//p";
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:nodeString];
    NSMutableArray * strArray = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in elements) {
        //_descriptionString =[element content];
        [strArray addObject:[element content]];
        // _descriptionString = [_descriptionString stringByAppendingString:[element content]];
    }
    _descriptionString = @"";
    for (int i = 0; i<strArray.count; i++) {
        
        _descriptionString = [_descriptionString stringByAppendingString:[NSString stringWithFormat:@"%@",strArray[i]]];
        _descriptionString = [_descriptionString stringByAppendingString:@"\n\n"];
        
    }
    
    
    [self getCommintListData];
    [self createTitle];
    [self createTableView];
    
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}


- (void)getCommintListData{
    
    
    if (_iDownManager) {
        return;
    }
    [self StartLoading];
    _iDownManager = [[ImageDownManager alloc] init];
    _iDownManager.delegate = self;
    _iDownManager.OnImageDown = @selector(getCommintOnLoadFinish:);
    _iDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"http://42.202.146.236:8080/comment/services/rs/comments/commentinfo?resourceID=%@",_source_id];
    
    [_iDownManager GetImageByStr:urlstr];
    
}

- (void)getCommintOnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict =[ sender.mWebStr JSONValue];
    [self Cancel];
    
    NSArray * array = [dict objectForKey:@"tcomment"];
    for (NSDictionary * tcommentDict in array) {
        CommintModel * model = [[CommintModel alloc] init];
        [model setValuesForKeysWithDictionary:tcommentDict];
        [_dataArray addObject:model];
    }
    _writeLabel.text = [NSString stringWithFormat:@"%d",array.count];
    _rowsNum = 3 + _dataArray.count;
    [_tableView reloadData];
}


- (void)dealloc {
    [moviePlayer stop];
    if (moviePlayer) {
        moviePlayer.delegate = nil;
        moviePlayer=nil;
    }

    [self Cancel];
    

}

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
    SAFE_CANCEL_ARC(self.iDownManager);
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
