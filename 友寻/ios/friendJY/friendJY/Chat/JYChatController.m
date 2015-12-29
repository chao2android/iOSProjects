//
//  JYChatController.m
//  friendJY
//
//  Created by 高斌 on 15/3/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYChatController.h"
#import "JYChatService.h"
#import "JYChatModel.h"
#import "JYChatDataBase.h"
#import "JYShareData.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYProfileData.h"
#import "JYGroupSettingController.h"
#import "AFNetworking.h"
#import "JYOtherProfileController.h"
#import "JYMessageController.h"
#import "JYChatTableViewCell.h"
#import "JYMsgUpdate.h"

#define CHAT_TABLE_HEIGHT kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight

@interface JYChatController (){
    int keyboardHeight; //键盘起来的高度
    float lastTableViewOffsetTop;//记录最后一次offsetTop的值，主要是用于判断是向上还向下滚动。来收起键盘
    int faceCount;//表情输入，记数，一条聊天记录最多可以输入20个
}

@end

@implementation JYChatController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSLog(@"%@", [JYProfileData sharedInstance].profile_dict);
        _currentUserInfoDict  = [JYShareData sharedInstance].myself_profile_dict;
//        _selfAvatarUrl = [JYp]
        _globalShowData = [[NSMutableArray alloc] init];
        [JYShareData sharedInstance].currentChatLog = _globalShowData;
        //初始化录音模块
        _speech = [[SpeechController alloc] init];
        _speech.delegate  = self;
        _recordingSeconds = 61;
        _tagPosition = 0.0f;
    }
    return self;
}

- (void)dealloc
{
    _fromUid = nil;
    _fromGroupModel = nil;
    _fromMsgModel = nil;
    _speech = nil;
    _globalShowData = nil;
    _from = nil;
    NSLog(@"fuck dealloc");
//    [_faceBtn removeObserver:self forKeyPath:@"selected" context:KVO_EMOJI_BTN_SELECTED_CHANGED];
//    [_sendImageBtn removeObserver:self forKeyPath:@"selected" context:KVO_SEND_IMAGE_BTN_SELECTED_CHANGED];
}
- (void)backAction{
    [_speech stopPlay];
    _speech.delegate  = nil;
    _speech = nil;
    if (_isGroupChat && [self.fromGroupModel.from intValue] == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        [super backAction];
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[JYChatService sharedInstance] startWork];
    
    if (_isGroupChat) {
        [self setTitle:_fromGroupModel.title];
    } else {
        [self setTitle:_fromMsgModel.nick];
    }
    faceCount = 0;
    lastTableViewOffsetTop = 0;
//[self withTheUserCanChat]; //先看这个用户是否可以聊天
    [self.view setBackgroundColor:[JYHelpers setFontColorWithString:@"#EDF1F4"]];
//[self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [[JYChatService sharedInstance] isSocketConnected];
    
    UIButton *rightSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSettingBtn setFrame:CGRectMake(0, 0, 65, 44)];
    [rightSettingBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [rightSettingBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightSettingBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    if (self.isGroupChat) { //群组聊天，右上角出现群组设置
        [rightSettingBtn setTitle:@"群组设置" forState:UIControlStateNormal];
        
        [rightSettingBtn addTarget:self action:@selector(groupSettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{//个人聊天，出现进个人主页
        rightSettingBtn.width = 70;
        [rightSettingBtn setTitle:@"TA的主页" forState:UIControlStateNormal];
        [rightSettingBtn addTarget:self action:@selector(rightProfileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightSettingBtn]];
    
    [self layoutViews];
    
    if (self.isGroupChat) {
        [self requestGetHistoryGroupChatList];
        //置为已读
        [self readTheUserMessage:_fromGroupModel.group_id type:1];
        
        [self requestGetGroupUserList];
    } else {
        [self requestGetHistoryUserChatList];
        //置为已读
        [self readTheUserMessage:_fromMsgModel.oid type:0];
    }
    
    //获取播放语音的状态
    [self getVoicePlayStatus];
    
    if (_globalShowData.count > 0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_globalShowData.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewUi) name:kChatTableViewRefreshUiNotification object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isGroupChat) {
        [self setTitle:_fromGroupModel.title];
        //更新群组信息
        [self updateGroupInfo];
    } else {
        [self setTitle:_fromMsgModel.nick];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"currentViewControllerIsChat"]; //存储当前是否在聊天页:0-表示不在，1-表示在
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatAudioTap:) name:kChatAudioTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReceiveChatMsg:) name:kSocketReceiveChatMsgNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClickAvatar:) name:kChatCellClickAvatarNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayAudioNoti:) name:kStopPlayAudioNotiNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatLogFailureResendNoti:) name:kChatLogFailureResendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClickShare:) name:kChatCellClickShareNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"currentViewControllerIsChat"]; //存储当前是否在聊天页:1-表示不在，0-表示在
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChatCellClickShareNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChatLogFailureResendNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStopPlayAudioNotiNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChatAudioTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSocketReceiveChatMsgNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChatCellClickAvatarNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 布局子视图

- (void)layoutViews
{
//    CGFloat inputBgHeight = 49.0f;
    
    
    
    _tableView = [[JYChatTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CHAT_TABLE_HEIGHT) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.refreshHeaderDelegate = self;
    [_tableView setRowHeight:60.0f];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap:)];
//    [_tableView addGestureRecognizer:tap];
    [_tableView setUserInteractionEnabled:YES];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
//    UIView * screenMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    screenMask.backgroundColor = [UIColor yellowColor];
//    screenMask.alpha = 0.5f;
//    [self.view addSubview:screenMask];
    
    _inputBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight, kScreenWidth, kTabBarViewHeight)];
    [_inputBgImage setUserInteractionEnabled:YES];
    [_inputBgImage setBackgroundColor:kTextColorWhite];
    [self.view addSubview:_inputBgImage];
    
    //线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [line setBackgroundColor:kBorderColorGray];
    [_inputBgImage addSubview:line];
    
    //图片
    _sendImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_sendImageBtn setBackgroundImage:[UIImage imageNamed:@"msg_more.png"] forState:UIControlStateNormal];
    [_sendImageBtn setImage:[UIImage imageNamed:@"msg_more.png"] forState:UIControlStateNormal];
    [_sendImageBtn setFrame:CGRectMake(-5, 0, 50, 50)];
    [_sendImageBtn addTarget:self action:@selector(sendImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [_sendImageBtn addObserver:self forKeyPath:@"selected" options:0 context:KVO_SEND_IMAGE_BTN_SELECTED_CHANGED];
    [_inputBgImage addSubview:_sendImageBtn];
    
    //表情
    _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_faceBtn setBackgroundImage:[UIImage imageNamed:@"msg_emoji.png"] forState:UIControlStateNormal];
//    [_faceBtn setBackgroundImage:[UIImage imageNamed:@"msg_keyboard.png"] forState:UIControlStateSelected];
    [_faceBtn setImage:[UIImage imageNamed:@"msg_emoji.png"] forState:UIControlStateNormal];
    [_faceBtn setImage:[UIImage imageNamed:@"msg_keyboard.png"] forState:UIControlStateSelected];
    [_faceBtn setFrame:CGRectMake(_sendImageBtn.right-5, 0, 40, 50)];
    [_faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBgImage addSubview:_faceBtn];
    
    //输入框背景
    _inputTextViewBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(_faceBtn.right+5, 10, kScreenWidth-10-25-15-25-10-11-25-11, 29)];
    _inputTextViewBgImage.backgroundColor = [UIColor clearColor];
    [_inputTextViewBgImage setImage:[[UIImage imageNamed:@"msg_input_bg_image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    [_inputTextViewBgImage setUserInteractionEnabled:YES];
    [_inputBgImage addSubview:_inputTextViewBgImage];
    
    _inputTextViewLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, _inputTextViewBgImage.width, 20)];
    _inputTextViewLable.text = @"说点什么吧...";
    _inputTextViewLable.enabled = NO;//lable必须设置为不可用
    _inputTextViewLable.backgroundColor = [UIColor clearColor];
    [_inputTextViewBgImage addSubview:_inputTextViewLable];
    
    //输入框
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _inputTextViewBgImage.width, _inputTextViewBgImage.height)];
    _inputTextView.layoutManager.allowsNonContiguousLayout = NO;
    [_inputTextView setBackgroundColor:[UIColor clearColor]];
    [_inputTextView setFont:[UIFont systemFontOfSize:14.0f]];
    [_inputTextView setShowsVerticalScrollIndicator:NO];
    [_inputTextView setDelegate:self];
    [_inputTextView setEnablesReturnKeyAutomatically:YES];
    [_inputTextView setReturnKeyType:UIReturnKeySend];
    [_inputTextViewBgImage addSubview:_inputTextView];
    
    //按住说话
    _speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_speakBtn setFrame:_inputTextViewBgImage.frame];
    [_speakBtn setBackgroundImage:[[UIImage imageNamed:@"msg_input_bg_image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [_speakBtn setBackgroundImage:[[UIImage imageNamed:@"msg_input_bg_image.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [_speakBtn addTarget:self action:@selector(speakBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_speakBtn addTarget:self action:@selector(speakBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_speakBtn addTarget:self action:@selector(speakBtnTouchUpOutsideOrCancel:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_speakBtn addTarget:self action:@selector(speakBtnTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_speakBtn setHidden:YES];
    [_inputBgImage addSubview:_speakBtn];
    
    _speakLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _speakBtn.width, _speakBtn.height)];
    [_speakLab setFont:[UIFont systemFontOfSize:14.0f]];
    [_speakLab setTextAlignment:NSTextAlignmentCenter];
    [_speakLab setBackgroundColor:[UIColor clearColor]];
    [_speakLab setText:kHoldPressAndSpeak];
    [_speakBtn addSubview:_speakLab];
    
    //麦克按钮
    _mikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _mikeBtn.backgroundColor = [UIColor orangeColor];
    [_mikeBtn setImage:[UIImage imageNamed:@"msg_mike_btn.png"] forState:UIControlStateNormal];
    [_mikeBtn setImage:[UIImage imageNamed:@"msg_keyboard.png"] forState:UIControlStateSelected];
//    [_mikeBtn setBackgroundImage:[UIImage imageNamed:@"msg_mike_btn.png"] forState:UIControlStateNormal];
//    [_mikeBtn setBackgroundImage:[UIImage imageNamed:@"msg_keyboard.png"] forState:UIControlStateSelected];
    [_mikeBtn setFrame:CGRectMake(_inputTextViewBgImage.right, 0, 50, 50)];
    [_mikeBtn addTarget:self action:@selector(mikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_inputBgImage addSubview:_mikeBtn];
    
    //表情键盘
    _emojiView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-kStatusBarHeight-kNavigationBarHeight, kScreenWidth, kEmojiKeyboardHeight)];
    [self.view addSubview:_emojiView];
    
    _emojiBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kEmojiKeyboardHeight)];
    _emojiBg.delegate = self;
    [_emojiBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#F2F2F2"]];
    [_emojiBg setUserInteractionEnabled:YES];
    [_emojiBg setContentSize:CGSizeMake(4*kScreenWidth, kEmojiKeyboardHeight)];
    [_emojiBg setPagingEnabled:YES];
    [_emojiBg setShowsHorizontalScrollIndicator:NO];
    [_emojiBg setShowsVerticalScrollIndicator:NO];
    [_emojiView addSubview:_emojiBg];
    
    [self layoutEmoji];
    
    //发送图片视图
    _sendImageBg = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight, kScreenWidth, kSendImageBgHeight)];
    [_sendImageBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#F2F2F2"]];
    [self.view addSubview:_sendImageBg];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setFrame:CGRectMake(15, 15, 80, 80)];
    [cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"msg_camera.png"] forState:UIControlStateNormal];
    [_sendImageBg addSubview:cameraBtn];
    
    UIButton *albumsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumsBtn setFrame:CGRectMake(cameraBtn.right+25, 15, 80, 80)];
    [albumsBtn addTarget:self action:@selector(albumsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [albumsBtn setBackgroundImage:[UIImage imageNamed:@"msg_albums.png"] forState:UIControlStateNormal];
    [_sendImageBg addSubview:albumsBtn];
    
    _recordingBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight)];
    [_recordingBg setBackgroundColor:kTextColorBlack];
    [_recordingBg setAlpha:0.8f];
    [_recordingBg setHidden:YES];
    [self.view addSubview:_recordingBg];
    
    UIImageView *recordingLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 142, 142)];
    [recordingLogo setImage:[UIImage imageNamed:@"msg_voice_btn.png"]];
    [recordingLogo setCenter:CGPointMake(_recordingBg.width/2, _recordingBg.height/2)];
    [_recordingBg addSubview:recordingLogo];
    
    _recordingSecondsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [_recordingSecondsLab setCenter:CGPointMake(_recordingBg.width/2, _recordingBg.height/2+50)];
    [_recordingSecondsLab setBackgroundColor:[UIColor clearColor]];
    [_recordingSecondsLab setTextAlignment:NSTextAlignmentCenter];
    [_recordingSecondsLab setTextColor:kTextColorWhite];
    [_recordingSecondsLab setFont:[UIFont systemFontOfSize:16.0f]];
    [_recordingBg addSubview:_recordingSecondsLab];
    
    UILabel *cancelSendRecordLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    [cancelSendRecordLab setCenter:CGPointMake(_recordingBg.width/2, _recordingBg.height/2+100)];
    [cancelSendRecordLab setText:@"手指上划，取消发送"];
    [cancelSendRecordLab setBackgroundColor:[UIColor clearColor]];
    [cancelSendRecordLab setTextAlignment:NSTextAlignmentCenter];
    [cancelSendRecordLab setTextColor:kTextColorWhite];
    [cancelSendRecordLab setFont:[UIFont systemFontOfSize:16.0f]];
    [_recordingBg addSubview:cancelSendRecordLab];
}

- (void)layoutEmoji
{
    CGFloat horizontalPadding = (kScreenWidth-24*7)/8.0f;
    CGFloat verticalPadding = (kEmojiKeyboardHeight-24*3)/6.0f;
    
    for (int i=0; i<4; i++) {
        
        UIImageView *pageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kEmojiKeyboardHeight)];
        [pageView setUserInteractionEnabled:YES];
        [_emojiBg addSubview:pageView];
        
        for (int j=0; j<3; j++) {
            for (int k=0; k<7; k++)
            {
                
                if (j*7+k == 20)
                {
                    //删除按钮
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deleteBtn setFrame:CGRectMake(horizontalPadding+6*(24+horizontalPadding), verticalPadding+2*(24+verticalPadding)-10, 36, 44)];
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_delete_normal.png"] forState:UIControlStateNormal];
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"chat_btn_delete_pressed.png"] forState:UIControlStateHighlighted];
                    [deleteBtn addTarget:self action:@selector(deleteFaceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [pageView addSubview:deleteBtn];
                }
                else
                {
                    if (i*20+j*7+k < 80)
                    {
                        //表情
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalPadding+k*(24+horizontalPadding), verticalPadding+j*(24+verticalPadding), 24, 24)];
                        [imageView setUserInteractionEnabled:YES];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emojiTap:)];
                        [imageView addGestureRecognizer:tap];
                        NSString *imageName = [[JYShareData sharedInstance].emoji_array objectAtIndex:i*20+j*7+k];
                        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageName]]];
                        [imageView setTag:1000+i*20+j*7+k];
                        [pageView addSubview:imageView];
                    }
                    
                }
            }
        }
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, _emojiBg.bottom-40, 120, 15)];
    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor = RGBACOLOR(195, 179, 163, 1);
    pageControl.currentPageIndicatorTintColor = RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 4;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    //    pageControl.hidden = YES;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [_emojiView addSubview:pageControl];
    
    _faceSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceSendBtn.backgroundColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    [_faceSendBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_faceSendBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_faceSendBtn setTitle:@"发  送" forState:UIControlStateNormal];
    [_faceSendBtn setFrame:CGRectMake(_emojiBg.right - 100, _emojiBg.bottom-40, 100, 40)];
    [_faceSendBtn addTarget:self action:@selector(faceSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_emojiView addSubview:_faceSendBtn];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //通过滚动的偏移量来判断目前页面所对应的小白点
    int page = sender.contentOffset.x/kScreenWidth;
    //pagecontroll响应值的变化
    pageControl.currentPage = page;
}

//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSLog(@"%ld", (long)pageControl.currentPage);
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_emojiBg setContentOffset:CGPointMake(kScreenWidth * page, 0)];
    
}

- (void)withTheUserCanChat{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"is_can_chat" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromMsgModel.oid forKey:@"touid"];
    
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
           
            
        } else {
          
        }
        
    } failure:^(id error) {
        
    }];
}
#pragma mark - 表情右下角的发送按钮
- (void) faceSendBtnClick:(UIButton *)btn{
    [self sendTextContentToHttp:_inputTextView.text];
}

#pragma mark - tableView单击


//点击屏幕时，收起
- (void)tableViewTap:(UIGestureRecognizer *)swipe
{
    NSLog(@"tableViewTap");
    
    [_inputTextView resignFirstResponder];
    [_faceBtn setSelected:NO];
    [_sendImageBtn setSelected:NO];
    [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
        [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
        [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
        [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-_inputBgImage.height)];
        [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
    } completion:^(BOOL finished) {
        
        
    }];
    
//    if ([_inputTextView isFirstResponder]) {
//    }
}


#pragma mark - 群组设置响应

- (void)groupSettingBtnClick:(UIButton *)btn
{
    NSLog(@"群组设置");
    
    JYGroupSettingController *groupSettingController = [[JYGroupSettingController alloc] init];
    [groupSettingController setGroupModel:self.fromGroupModel];
    [self.navigationController pushViewController:groupSettingController animated:YES];
}

#pragma mark - 表情按钮响应

- (void)faceBtnClick:(UIButton *)btn
{
    
    
    if (btn.selected) {
        //显示键盘
        
        [btn setSelected:NO];
        [_mikeBtn setSelected:NO];
        [_inputTextViewBgImage setHidden:NO];
        [_speakBtn setHidden:YES];
        [_faceBtn setSelected:NO];
        [_sendImageBtn setSelected:NO];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
//            [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight)];
            
//            [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
        } completion:^(BOOL finished) {
            //nothing
        }];
        [_inputTextView becomeFirstResponder];
    } else {
        //显示表情键盘
        [btn setSelected:YES];
        [_inputTextView resignFirstResponder];
        [_inputTextViewBgImage setHidden:NO];
        [_speakBtn setHidden:YES];
        [_mikeBtn setSelected:NO];
        [_sendImageBtn setSelected:NO];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kEmojiKeyboardHeight)];
            [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kEmojiKeyboardHeight-_inputBgImage.height)];
            [self adjustTableViewPostion];
            
        } completion:^(BOOL finished) {
            
            //nothing
        }];
        
        
        
    }
    
    
}

#pragma mark - 发送图片按钮响应

- (void)sendImageBtnClick:(UIButton *)btn
{
    
    if (btn.selected) {
        [btn setSelected:NO];
        [_mikeBtn setSelected:NO];
        [_inputTextViewBgImage setHidden:NO];
        [_speakBtn setHidden:YES];
        [_faceBtn setSelected:NO];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight)];
            
            [_tableView setOrigin:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            //nothing
        }];
        
    } else {
        [_inputTextView resignFirstResponder];
        [btn setSelected:YES];
        [_inputTextViewBgImage setHidden:NO];
        [_speakBtn setHidden:YES];
        [_mikeBtn setSelected:NO];
        [_faceBtn setSelected:NO];
        //发送图片视图显示
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kSendImageBgHeight)];
            [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-_sendImageBg.height-_inputBgImage.height)];
//            [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
            if (_tableView.contentSize.height > _tableView.height-_sendImageBg.height) { //只有当table的内容大于可显示区域，才向上移动
                if (_tableView.contentSize.height >_tableView.height) {
                    [_tableView setOrigin:CGPointMake(0, -( _sendImageBg.height ))];
                }else{
                    [_tableView setOrigin:CGPointMake(0, -(_tableView.contentSize.height-_tableView.height + _sendImageBg.height ))];
                }
                
            }
        } completion:^(BOOL finished) {
            //nothing
        }];
        
        
    }
}

#pragma mark - 点击表情

- (void)emojiTap:(UITapGestureRecognizer *)tap
{
    if (faceCount > 20) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"最多可以输入20个表情"];
        return;
    }
    NSInteger tag = tap.view.tag-1000;
    NSString *emojiStr = [[JYShareData sharedInstance].emoji_array objectAtIndex:tag];
    [_inputTextView setText:[NSString stringWithFormat:@"%@%@", _inputTextView.text, emojiStr]];
    
    _inputTextViewLable.text = @"";
    //
    [self textViewTextDidChange:nil];
    
    faceCount ++;
    //_inputTextView显示最后
//    [_inputTextView scrollRectToVisible:CGRectMake(0, _inputTextView.contentSize.height-15, _inputTextView.contentSize.width, 10) animated:YES];

}

#pragma mark - 点击删除

- (void)deleteFaceBtnClick
{
    NSString *text = _inputTextView.text;
    NSLog(@"%ld",text.length);
    [self deleteBtnClick:_inputTextView.text.length-1];
}

- (BOOL)deleteBtnClick:(NSUInteger)location
{
    if (_inputTextView.text.length > 0 ) {
        NSString *text ;
        //如果最后一个字符为]，就可能是一个表情。查找最后一个[位置，从字典比对是为表情标记，如果是整体删除这一个表情，而不是一个单一字符。
        if([[_inputTextView.text substringWithRange:NSMakeRange(location, 1)] isEqualToString:@"]"]){
//            BOOL isMatchSccuss = NO;
            for (NSInteger i = location-3; i>=0; i--) {
                NSString *temp = [_inputTextView.text substringWithRange:NSMakeRange(i, 1)];
                if([temp isEqualToString:@"["]){
                    
                    NSString *emotionText = [_inputTextView.text substringWithRange:NSMakeRange(i, location-i+1)];
                    
                    
                    NSInteger index = [[JYShareData sharedInstance].emoji_array indexOfObject:emotionText];
                    
                    if (index>=0 && index<=79) {
                        text = [_inputTextView.text stringByReplacingCharactersInRange:NSMakeRange(i, location-i+1) withString:@""];
                        [_inputTextView setText:text];
                        _inputTextView.selectedRange=NSMakeRange(i,0);
                        return NO;
//                        isMatchSccuss = YES;
                    }
                    
//                    if(isMatchSccuss) break;
                }
            }
//            //没有找到对应的表情，则删除单个字符
//            if(!isMatchSccuss){
//                text = [_inputTextView.text stringByReplacingCharactersInRange:NSMakeRange(location, 0) withString:@""];
//                [_inputTextView setText:text];
//            }
        } else {
//            text = [_inputTextView.text stringByReplacingCharactersInRange:NSMakeRange(location, 0) withString:@""];
//            [_inputTextView setText:text];
            //_inputTextView.selectedRange=NSMakeRange(location,0);
            
        }
        
    }
    return  YES;
}

#pragma mark - 点击麦克

- (void)mikeBtnClick
{
    
    if (_mikeBtn.selected) {
        
        [_mikeBtn setSelected:NO];
        [_inputTextViewBgImage setHidden:NO];
        [_speakBtn setHidden:YES];
        [_sendImageBtn setSelected:NO];
        [_faceBtn setSelected:NO];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            //            [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight)];
           
            //            [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
        } completion:^(BOOL finished) {
            //nothing
        }];
        [_inputTextView becomeFirstResponder];
        
    } else {
        
        [_mikeBtn setSelected:YES];
        [_inputTextViewBgImage setHidden:YES];
        [_speakBtn setHidden:NO];
        [_faceBtn setSelected:NO];
        [_sendImageBtn setSelected:NO];
        [_inputTextView resignFirstResponder];
        [UIView animateWithDuration:kKeyboardAnimationDuration animations:^{
            [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
            [_inputBgImage setFrame:CGRectMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight, kScreenWidth, kTabBarViewHeight)];
            [_inputTextViewBgImage setFrame:CGRectMake(_faceBtn.right+10, 10, _inputTextViewBgImage.width, 29)];
            [_inputTextView setText:@""];
            //[_inputTextView setFrame:CGRectMake(0, 0, _inputTextViewBgImage.width, _inputTextViewBgImage.height)];
            [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
            [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
        } completion:^(BOOL finished) {
            //nothing
        }];
        
    }
}

#pragma mark - 相机点击事件

- (void)cameraBtnClick:(UIButton *)btn
{
    if (![JYHelpers canUseCamera]) {
        [JYHelpers showCameraAuthDeniedAlertView];
        return;
    }
    NSLog(@"相机");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [imagePickerController setAllowsEditing:NO];
    //弹出时 动画风格
    [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePickerController animated:YES completion:NULL];
    
}

- (void)albumsBtnClick:(UIButton *)btn
{
    if (![JYHelpers canUsePhotoLibrary]) {
        [JYHelpers showPhotoLibraryDeniedAlertView];
        return;
    }
    NSLog(@"相册");
    JYChatGetLocalPhoto *mc = [[JYChatGetLocalPhoto alloc] init];
    mc.delegate = self;
    [self.navigationController pushViewController:mc animated:YES];
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    [imagePickerController setAllowsEditing:NO];
//    
//    //弹出时 动画风格
//    [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    //手机相册选取
//    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
}

#pragma mark - timer 事件
- (void)timerFire:(NSTimer *)timer
{
    _recordingSeconds -= 1;
    if (_recordingSeconds<0) {
        [_speech stopRecord];
        [_recordingBg setHidden:YES];
        _recordingSeconds = 61;
        [_recordingTimer invalidate];
    } else {
        [_recordingSecondsLab setText:[NSString stringWithFormat:@"%ld\"", (long)_recordingSeconds]];
    }
}

#pragma mark - 网络请求聊天记录 更新本地数据库后 从本地取聊天记录

- (void)requestAndUpdateGetListFromDB
{
    if (_isGroupChat) {
        //群聊
        JYChatModel *chatModel = [[JYChatModel alloc] init];
        chatModel.groupId = self.fromGroupModel.group_id;
        chatModel.time = [JYHelpers currentDateTimeInterval];
        if (_globalShowData.count>0) {
            chatModel = (JYChatModel *)_globalShowData[0];
        }
        NSMutableArray *tempList = [[JYChatDataBase sharedInstance] getChatMsgListFromGroupChatLogWithModel:chatModel];
        for (JYChatModel *chatModel in tempList) {
            [_globalShowData insertObject:chatModel atIndex:0];
        }
        
    } else {
        //单聊
        JYChatModel *chatModel = [[JYChatModel alloc] init];
        chatModel.fromUid = self.fromMsgModel.oid;
        chatModel.time = [JYHelpers currentDateTimeInterval];
        if (_globalShowData.count>0) {
            chatModel = (JYChatModel *)_globalShowData[0];
        }
        NSMutableArray *tempList = [[JYChatDataBase sharedInstance] getChatMsgListFromChatLogWithModel:chatModel];
        for (JYChatModel *chatModel in tempList) {
            [_globalShowData insertObject:chatModel atIndex:0];
        }
    }
    [self messageListWithSendTime];
    [self checkArrayIsShowVoiceStatusTips];
    [_tableView setData:_globalShowData];
    [_tableView reloadData];
    
    if (_tagPosition == 0) {
        if (_tableView.contentSize.height>_tableView.height) {
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height-_tableView.height)];
        } else {
            [_tableView setContentOffset:CGPointMake(0, 0)];
        }
    } else {
        [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height-_tagPosition)];
    }
    

    
    [[JYMsgUpdate sharedInstance] getSysMsgCount];
}


#pragma mark - 语音按钮点击事件

- (void)speakBtnTouchDown:(UIButton *)btn
{
    //开始录音
    NSLog(@"speakBtnTouchDown");
    [_speakLab setText:kReleaseAndOver];
    [_recordingBg setHidden:NO];
    _recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    [_speech startRecord];
}

- (void)speakBtnTouchUpInside:(UIButton *)btn
{
    //录音完毕
    NSLog(@"speakBtnTouchUpInside");
    [_speakLab setText:kHoldPressAndSpeak];
    _isCancelSendRecord = NO;
    [_recordingBg setHidden:YES];
    _recordingSeconds = 61;
    [_recordingTimer invalidate];
    [_recordingSecondsLab setText:@""];
    [_speech stopRecord];
    
}


- (void)speakBtnTouchUpOutsideOrCancel:(UIButton *)btn
{
    //取消录音
    NSLog(@"speakBtnTouchUpOutsideOrCancel");
    [_speakLab setText:kHoldPressAndSpeak];
    _isCancelSendRecord = YES;
    [_recordingBg setHidden:YES];
    _recordingSeconds = 61;
    [_recordingTimer invalidate];
    [_recordingSecondsLab setText:@""];
    [_speech stopRecord];
}

- (void)speakBtnTouchDragExit:(UIButton *)btn
{
    NSLog(@"speakBtnTouchDragExit");
    [_speakLab setText:kHoldPressAndSpeak];
}

#pragma mark - notification
- (void)socketReceiveChatMsg:(NSNotification *)notification
{
    JYChatModel *chatModel = [notification.userInfo objectForKey:@"model"];
    if ([chatModel.fromUid integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] integerValue]) {
        return;
    }
    if (_isGroupChat) {
        if ([chatModel.groupId isEqualToString:ToString( self.fromGroupModel.group_id)]) {
            
            if ([chatModel.fromUid isEqualToString:[_currentUserInfoDict objectForKey:@"uid"]]) {
                //nothing
            } else {
                [_globalShowData addObject:chatModel];
                [self messageListWithSendTime];
                [_tableView reloadData];
            }
        }else{
            return;
        }
        
    } else {
    
        if ([chatModel.fromUid isEqualToString:ToString(self.fromMsgModel.oid)]) {
            
            [_globalShowData addObject:chatModel];
            [self messageListWithSendTime];
            [_tableView reloadData];
        }else{
            return;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_globalShowData.count-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    if (self.isGroupChat) {
        //置为已读
        [self readTheUserMessage:_fromGroupModel.group_id type:1];
        
    } else {
        //置为已读
        [self readTheUserMessage:_fromMsgModel.oid type:0];
    }
//    if(_tableView.contentSize.height > _tableView.height-_inputBgImage.origin.y){
//        if (_tableView.contentSize.height < _tableView.height) { //只有当table的内容小于可显示区域，把新增内容向上移动
//            
//            [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.contentSize.height)];
//            
//            
//        }else {
//            [_tableView setContentOffset:CGPointMake( 0, _tableView.contentSize.height-_tableView.height) animated:YES];
//        }
//    }
   
//    [self getNewMsgFromLocation];
//    [self getChatLogFromLocation];
}

- (void)chatAudioTap:(NSNotification *)notification
{
    
    JYChatModel *chatModel = [notification.userInfo objectForKey:@"model"];
    
    //返回id为空，先放本地的
    if ([chatModel.voiceId integerValue] >0 && ![chatModel.fileUrl hasPrefix:@"http://"]) {
//        NSDictionary *chatMsgDict = [NSJSONSerialization JSONObjectWithData:[chatModel.chatMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSString *audioUrl = [NSString stringWithFormat:@"%@" ,chatModel.fileUrl];
//        NSArray *urlArray = [audioUrl componentsSeparatedByString:@"/"];
//        NSString *fileName = [urlArray[urlArray.count-1] stringByReplacingOccurrencesOfString:@".amr" withString:@""];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kChatStartPlayAudioNotification object:nil userInfo:[NSDictionary dictionaryWithObject:chatModel forKey:@"model"]];
        for (int i = 0;i<_globalShowData.count ;i++) {
            JYChatModel * temp  = _globalShowData[i];
            if ([chatModel isEqual:temp]) {
                JYChatTableViewCell * cellObj = (JYChatTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cellObj startPlayAudio];
                break;
            }
        }
        [_speech startPlay:audioUrl];
    } else {
        [self requestDownloadAudioWithModel:chatModel];
    }
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    NSLog(@"keyboardDidChangeFrame");
    
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSLog(@"%f",keyboardRect.size.height);
    if (keyboardRect.origin.y != kScreenHeight) {
        
//        [_inputBgImage setOrigin:CGPointMake(0, keyboardRect.origin.y-kStatusBarHeight-kNavigationBarHeight-_inputBgImage.height)];
//        [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
    }
    
    /*
    if (keyboardRect.origin.y == kScreenHeight) {
        
        [_inputBgImage setOrigin:CGPointMake(0, keyboardRect.origin.y-kStatusBarHeight-kNavigationBarHeight-_inputBgImage.height)];
        [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];


    } else {
        
        [_inputBgImage setOrigin:CGPointMake(0, keyboardRect.origin.y-kStatusBarHeight-kNavigationBarHeight-_inputBgImage.height)];
        [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
    }
    */
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //这方法会执行多次 但是动画block只执行一次
    
    NSLog(@"keyboardWillShow");
    [JYShareData sharedInstance].showOrHiddenKeyboard = YES;
    
//    [_sendImageBtn setSelected:NO];
    
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardHeight = keyboardRect.size.height;
  
//    [UIView animateWithDuration:animationDuration animations:^{
    
        [_inputBgImage setOrigin:CGPointMake(0,  kScreenHeight - kStatusBarHeight - kNavigationBarHeight - keyboardHeight  - _inputBgImage.height)];
       
    [self adjustTableViewPostion];
    
        
//    } completion:^(BOOL finished) {
    
        [_faceBtn setSelected:NO];
        [_mikeBtn setSelected:NO];
        [_speakBtn setHidden:YES];
        [_sendImageBtn setSelected:NO];
        [_emojiView setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
        [_sendImageBg setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
//    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [JYShareData sharedInstance].showOrHiddenKeyboard = NO;
    keyboardHeight = 0;
//    [_inputBgImage setOrigin:CGPointMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-_inputBgImage.height)];
//    [_tableView setOrigin:CGPointMake(0, 0)];
    
    NSLog(@"keyboardWillHide");
    /*
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_faceBtn.selected && !_sendImageBtn.selected) {
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [_inputBgImage setFrame:CGRectMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-_inputBgImage.height, _inputBgImage.width, _inputBgImage.height)];
            [_tableView setOrigin:CGPointMake(0, _inputBgImage.origin.y-_tableView.height)];
        } completion:^(BOOL finished) {
            
            
        }];
    }
    */
}


-(void)textViewDidChange:(UITextView *)textView {
    NSLog(@"testdidchange");
    if(textView.text.length >0 || textView.text.length > 0){
        _inputTextViewLable.text = @"";
    }else{
        _inputTextViewLable.text = @"说点什么吧...";
    }
    
    textView.text = [JYHelpers filterEmojiString:textView.text];

}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    if (notification != nil) {
        CGRect line = [_inputTextView caretRectForPosition:_inputTextView.selectedTextRange.start];
        CGFloat overflow = line.origin.y + line.size.height- ( _inputTextView.contentOffset.y + _inputTextView.bounds.size.height - _inputTextView.contentInset.bottom - _inputTextView.contentInset.top );
        if ( overflow > 0 ) {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            CGPoint offset = _inputTextView.contentOffset;
            offset.y += overflow + 7; // leave 7 pixels margin
            // Cannot animate with setContentOffset:animated: or caret will not appear
            [UIView animateWithDuration:.2 animations:^{
                [_inputTextView setContentOffset:offset];
            }];
        }
    }
    CGSize contentSize = [_inputTextView.text sizeWithFont:_inputTextView.font constrainedToSize:CGSizeMake(_inputTextView.width-12, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat inputBgHeight = 0.0f;
    if ((contentSize.height>0) && (contentSize.height<18.0f)) {
        //一行
        inputBgHeight = 49.0f;
    } else if ((contentSize.height>=18.0f) && (contentSize.height<35.0f)) {
        //2行
        inputBgHeight = 66.0f;
    } else if ( contentSize.height>=35.0f ) {
        //多行
        inputBgHeight = 84.0f;
    } else {}
    

    [_inputTextView scrollRangeToVisible:NSMakeRange(_inputTextView.text.length-5, 5)];
    
    [self adjustTableViewPostion];
    
//    if (contentSize.height >= 64.0f) {
//        
//        //大于三行
//        inputBgHeight = 50.0f+15.f;
//        
//    } else if ((contentSize.height<50.0f) && (contentSize.height>=22.0f)) {
//        
//        //2或3行
//        inputBgHeight = contentSize.height+15.0f;
//        
//    } else if ((contentSize.height<22.0f) && (contentSize.height>0)) {
//        //行
//        
//        inputBgHeight = 44.0f;
//    }
    
    [_inputBgImage setFrame:CGRectMake(0, _inputBgImage.origin.y+_inputBgImage.height-inputBgHeight, _inputBgImage.width, inputBgHeight)];
    [_inputTextViewBgImage setFrame:CGRectMake(_faceBtn.right+10, 10, _inputTextViewBgImage.width, inputBgHeight-20)];
    [_inputTextView setFrame:CGRectMake(0, 0, _inputTextViewBgImage.width, _inputTextViewBgImage.height)];
    
    
    
}

#pragma mark - request
//发送新消息成功后，更新message列表
- (void) updateMessageListTableView :(JYChatModel *)chatModel{
    //更新消息列表的数据
    NSArray *msgList = [JYShareData sharedInstance].messageUserList;
    
    BOOL isNoExist = YES; //如果不存在数据，插入一条新的
    if (chatModel.isGroup) {
        for (int i = 0; i<msgList.count; i++) {
            JYMessageModel *msgModel = (JYMessageModel *)[msgList objectAtIndex:i];
            if ([msgModel.group_id isEqualToString:chatModel.groupId]) {
                isNoExist = NO;
                msgModel.content  = chatModel.chatMsg;
                msgModel.sendtime = chatModel.time;
                msgModel.msgtype = chatModel.msgType;
                [[JYChatDataBase sharedInstance] updateGroupChatFriendLastTimer:chatModel.time group_id:chatModel.groupId content:chatModel.chatMsg msgType:chatModel.msgType];
                break;
            }
        }
        
        if(isNoExist){
            JYMessageModel *msgModel = [[JYMessageModel alloc] init];
            msgModel.oid = @"0";
            msgModel.avatar = @"";
            msgModel.content = chatModel.chatMsg;
            msgModel.hint = @"";
            msgModel.logo = self.fromGroupModel.logo;
            msgModel.iid = @"";
            msgModel.group_id = ToString( self.fromGroupModel.group_id);
            msgModel.msgtype = chatModel.msgType;
            msgModel.newcount = @"0";
            msgModel.nick = @"";
            msgModel.sendtime = [JYHelpers currentDateTimeInterval];
            msgModel.sex = @"";
            msgModel.status = @"";
            msgModel.title = self.fromGroupModel.title;
            [[JYChatDataBase sharedInstance] insertOneUser:msgModel]; //插入本地数据库
            [[JYShareData sharedInstance].messageUserList addObject:msgModel]; //更新共享数据列表
        }
        
    }else{
        for (int i = 0; i<msgList.count; i++) {
            JYMessageModel *msgModel = (JYMessageModel *)[msgList objectAtIndex:i];
            if ([msgModel.oid isEqualToString:chatModel.fromUid]) {
                isNoExist = NO;
                msgModel.content  = chatModel.chatMsg;
                msgModel.sendtime = chatModel.time;
                msgModel.msgtype  = chatModel.msgType;
                [[JYChatDataBase sharedInstance] updateChatFriendLastTimer:chatModel.time oid:chatModel.fromUid content:chatModel.chatMsg msgType:chatModel.msgType];
                break;
            }
        }
        
        if(isNoExist){
            JYMessageModel *msgModel = [[JYMessageModel alloc] init];
            msgModel.oid = self.fromMsgModel.oid;
            msgModel.avatar = self.fromMsgModel.avatar;
            msgModel.content = chatModel.chatMsg;
            msgModel.hint = @"";
            msgModel.logo = self.fromMsgModel.avatar;
            msgModel.iid = @"";
            msgModel.group_id = @"";
            msgModel.msgtype = chatModel.msgType;
            msgModel.newcount = @"0";
            msgModel.nick = self.fromMsgModel.nick;
            msgModel.sendtime = [JYHelpers currentDateTimeInterval];
            msgModel.sex = @"";
            msgModel.status = @"";
            msgModel.title = self.fromMsgModel.nick;
            [[JYChatDataBase sharedInstance] insertOneUser:msgModel]; //插入本地数据库
            [[JYShareData sharedInstance].messageUserList addObject:msgModel]; //更新共享数据列表
        }
    }

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshMessageTableViewNotification object:nil userInfo:nil];
}
//获取历史消息
- (void)requestGetHistoryUserChatList
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"get_history_user_chat_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromMsgModel.oid forKey:@"oid"];
    if (_globalShowData.count>0) {
        JYChatModel *firstChatModel = (JYChatModel *)_globalShowData[0];
        [postDict setObject:firstChatModel.iid forKey:@"iid"];
    }else{
        [postDict setObject:@"0" forKey:@"iid"];
    }
    [postDict setObject:@"1" forKey:@"page"];
    [postDict setObject:@"20" forKey:@"pageSize"];
    //    [postDict setObject:@"0" forKey:@"type"];
    //    [postDict setObject:@"1" forKey:@"autostatus"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        [_tableView doneLoadingTableViewData];
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSArray *dataList = [responseObject objectForKey:@"data"];
            for (int i=0; i<dataList.count; i++) {
                
                NSDictionary *infoDict = [dataList objectAtIndex:i];
                
                JYChatModel *chatModel = [self chatModelWithDict:infoDict];
                if (_isGroupChat) {
                    [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
                }else{
                    [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
                }
            }
            
            [self requestAndUpdateGetListFromDB];
            
        } else {
            [self requestAndUpdateGetListFromDB];
        }
        
    } failure:^(id error) {
        
        [_tableView doneLoadingTableViewData];
        [self requestAndUpdateGetListFromDB];
    }];
}

- (void)requestGetHistoryGroupChatList
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"get_history_group_chat_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromGroupModel.group_id forKey:@"group_id"];
    [postDict setObject:@"200" forKey:@"avatarSize"];
    
    if (_globalShowData.count>0) {
        
        for(int i = 0;i<_globalShowData.count ;i++){
            JYChatModel *firstChatModel = (JYChatModel *)_globalShowData[i];
            NSLog(@"%@----",firstChatModel.iid);
            if (firstChatModel.iid != nil) {
                [postDict setObject:firstChatModel.iid forKey:@"iid"];
                break;
            }
        }
        
    }else{
        NSLog(@"%@===",self.fromGroupModel.group_id);
        NSString * lastMsgIid = [[JYChatDataBase sharedInstance] getGroupChatLogLastIid:self.fromGroupModel.group_id];
        if(lastMsgIid == nil){
            lastMsgIid = @"0";
        }
        [postDict setObject:lastMsgIid forKey:@"iid"];
    }
    [postDict setObject:@"1" forKey:@"page"];
    [postDict setObject:@"20" forKey:@"pageSize"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        [_tableView doneLoadingTableViewData];
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSArray *dataList = [responseObject objectForKey:@"data"];
            NSLog(@"%lu", (unsigned long)dataList.count);
            
            for (int i=0; i<dataList.count; i++) {
                
                NSDictionary *infoDict = [dataList objectAtIndex:i];
                
                JYChatModel *chatModel = [self chatModelWithDict:infoDict];
                [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
                
            }
            
            [self requestAndUpdateGetListFromDB];
            
        } else {
            [self requestAndUpdateGetListFromDB];
        }
        
    } failure:^(id error) {
        
        [_tableView doneLoadingTableViewData];
        [self requestAndUpdateGetListFromDB];
    }];
}

//发送失败后显示的提示信息
- (void)sendFailureShowTips:(NSString *) type{
    NSString * msg;
    switch ([type intValue]) {
        case 2:
            msg = @"该账号已经被管理员加黑";
            break;
        case 5:
            msg = @"您已将对方加入黑名单，请取消加黑后发送";
            break;
        case 6:
            msg = @"内容含有敏感词";
            break;
    }
     [[JYAppDelegate sharedAppDelegate] showTip:msg];
}
//发送一条文本消息
- (void)requestSendTextMsgWithModel:(JYChatModel *)chatModel
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_text_msg" forKey:@"func"];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:self.fromMsgModel.oid forKey:@"touid"];
    [formDict setObject:chatModel.chatMsg forKey:@"content"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    NSString *oldIid = [NSString stringWithFormat:@"%@", chatModel.iid];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            
            if ([dataDict[@"status"] intValue] == 1) {
                NSString *iid = [JYHelpers stringValueWithObject:[dataDict objectForKey:@"iid"]];
               
                [chatModel setIid:iid];
                [chatModel setTime:[[dataDict objectForKey:@"time"] stringValue]];
                [chatModel setSendStatus:@"2"];
                
                //更新原来的id
                [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:oldIid];
                
                //更新消息列表的数据
                [self updateMessageListTableView:chatModel];
            }else{
                [chatModel setSendStatus:@"0"];
                [self sendFailureShowTips:dataDict[@"status"]];
                //更新原来的id
                [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:oldIid];
            }
            
        } else {
        
            [chatModel setSendStatus:@"0"];
            //更新原来的id
            [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:oldIid];
        }
        [_tableView reloadData];
    } failure:^(id error) {
        
        [chatModel setSendStatus:@"0"];
        [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:oldIid];
        [_tableView reloadData];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

//群组发送一条文本消息
- (void)requestSendGroupMsgWithModel:(JYChatModel *)chatModel
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_group_msg" forKey:@"func"];
    
    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    [formDict setObject:self.fromGroupModel.group_id forKey:@"group_id"];
    [formDict setObject:chatModel.chatMsg forKey:@"content"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    NSString *oldIid = [NSString stringWithFormat:@"%@", chatModel.iid];
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict formDict:formDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            if ([dataDict[@"status"] intValue] == 1) {
                NSString *iid = [JYHelpers stringValueWithObject:[dataDict objectForKey:@"iid"]];
                
                [chatModel setIid:iid];
                [chatModel setGroupId:[JYHelpers stringValueWithObject:[dataDict objectForKey:@"group_id"]]];
                [chatModel setTime:[JYHelpers stringValueWithObject:[dataDict objectForKey:@"time"]]];
                [chatModel setSendStatus:@"2"];
                
                [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:oldIid];
                
                
                //更新消息列表的数据
                [self updateMessageListTableView:chatModel];
            }else{
                [chatModel setSendStatus:@"0"];
                [self sendFailureShowTips:dataDict[@"status"]];
                [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:oldIid];
            }
           
            
        } else {
            
            [chatModel setSendStatus:@"0"];
            [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:oldIid];
        }
        [_tableView reloadData];
        
    } failure:^(id error) {
        
        [chatModel setSendStatus:@"0"];
        [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:oldIid];
        [_tableView reloadData];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
    }];
    
}

//发送一条图片信息
- (void)requestSendPicMsgWithModel:(JYChatModel *)chatModel
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_pic_msg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromMsgModel.oid forKey:@"touid"];

    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:chatModel.fileData forKey:@"upload"];
    NSString *old_iid = [NSString stringWithFormat:@"%@", chatModel.iid];
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            
            if ([dataDict[@"status"] intValue] == 1) {
                if ([dataDict[@"ext"] isKindOfClass:[NSDictionary class]]) {
                    chatModel.iid = dataDict[@"iid"];
                    chatModel.fileUrl = dataDict[@"ext"][@"pic200"]; //如果更换显示地址，会闪一下
                    chatModel.time = dataDict[@"time"];
                    chatModel.msgType = dataDict[@"msgtype"];
                    chatModel.ext = dataDict[@"ext"];
                }
                
                [chatModel setSendStatus:@"2"];
                [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
                
                //更新消息列表的数据
                [self updateMessageListTableView:chatModel];
            }else{
                [chatModel setSendStatus:@"0"];
                [self sendFailureShowTips:dataDict[@"status"]];
                [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
            }

        } else {
            [chatModel setSendStatus:@"0"];
            [self sendFailureShowTips:dataDict[@"status"]];
            [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        }
        [_tableView reloadData];
    } failure:^(id error) {
        [chatModel setSendStatus:@"0"];
        [self sendFailureShowTips:dataDict[@"status"]];
        [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [_tableView reloadData];
    }];
}

//群组发送一条聊天消息
- (void)requestSendPicGroupMsgWithModel:(JYChatModel *)chatModel
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_pic_group_msg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromGroupModel.group_id forKey:@"group_id"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:chatModel.fileData forKey:@"upload"];
    
    NSString *old_iid = [NSString stringWithFormat:@"%@", chatModel.iid];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            if ([dataDict[@"status"] intValue] == 1) {
                
                chatModel.iid = dataDict[@"iid"];
                chatModel.fileUrl = dataDict[@"ext"][@"pic200"];//如果更换显示地址，会闪一下
                chatModel.time = dataDict[@"time"];
                chatModel.msgType = dataDict[@"msgtype"];
                chatModel.ext = dataDict[@"ext"];
                [chatModel setSendStatus:@"2"];
                
                [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
                
                //            [_tableView reloadData];
                
                //更新消息列表的数据
                [self updateMessageListTableView:chatModel];
            }else{
                [chatModel setSendStatus:@"0"];
                [self sendFailureShowTips:dataDict[@"status"]];
                [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
            }
        } else {
            [chatModel setSendStatus:@"0"];
            [self sendFailureShowTips:dataDict[@"status"]];
            [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        }
        [_tableView reloadData];
    } failure:^(id error) {
        [chatModel setSendStatus:@"0"];
        [self sendFailureShowTips:dataDict[@"status"]];
        [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [_tableView reloadData];
    }];
}

- (void)requestSendVoiceMsgWithModel:(JYChatModel *)chatModel
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_voice_msg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromMsgModel.oid forKey:@"touid"];
    [postDict setObject:chatModel.voiceLength forKey:@"dur"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:chatModel.fileData forKey:@"upload"];
    
    NSString *old_iid = [NSString stringWithFormat:@"%@", chatModel.iid];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            if ([dataDict[@"status"] intValue] == 1) {
                if ([dataDict[@"ext"] isKindOfClass:[NSDictionary class]]) {
                    chatModel.iid = [JYHelpers stringValueWithObject:[dataDict objectForKey:@"iid"]];
                    chatModel.msgType = [dataDict objectForKey:@"msgtype"];
                    chatModel.time = [JYHelpers stringValueWithObject:[dataDict objectForKey:@"time"]];
                    chatModel.fileUrl = dataDict[@"ext"][@"voice"];
                    chatModel.voiceLength = dataDict[@"ext"][@"dur"];
                    chatModel.ext = dataDict[@"ext"];
                }
                [chatModel setSendStatus:@"2"];
                [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
                
                //            [_tableView reloadData];
                
                //更新消息列表的数据
                [self updateMessageListTableView:chatModel];
            }else{
                [chatModel setSendStatus:@"0"];
                [self sendFailureShowTips:dataDict[@"status"]];
                [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
            }

        } else {
            [chatModel setSendStatus:@"0"];
            [self sendFailureShowTips:dataDict[@"status"]];
            [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        }
        [_tableView reloadData];
    } failure:^(id error) {
        [chatModel setSendStatus:@"0"];
        [self sendFailureShowTips:dataDict[@"status"]];
        [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [_tableView reloadData];
    }];
}

- (void)requestSendGroupVoiceMsgWithModel:(JYChatModel *)chatModel
{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"send_group_voice_msg" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromGroupModel.group_id forKey:@"group_id"];
    [postDict setObject:chatModel.voiceLength forKey:@"dur"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:chatModel.fileData forKey:@"upload"];
    
    NSString *old_iid = [NSString stringWithFormat:@"%@", chatModel.iid];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            
            if ([dataDict[@"status"] intValue] == 1) {
                chatModel.iid = [JYHelpers stringValueWithObject:[dataDict objectForKey:@"iid"]];
                chatModel.msgType = [dataDict objectForKey:@"msgtype"];
                chatModel.time = [JYHelpers stringValueWithObject:[dataDict objectForKey:@"time"]];
                chatModel.fileUrl = dataDict[@"ext"][@"voice"];
                chatModel.voiceLength = dataDict[@"ext"][@"dur"];
                [chatModel setSendStatus:@"2"];
                
                [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
                
                //            [_tableView reloadData];
                
                //更新消息列表的数据
                [self updateMessageListTableView:chatModel];
            }else{
                [chatModel setSendStatus:@"0"];
                [self sendFailureShowTips:dataDict[@"status"]];
                [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
            }
        } else {
            [chatModel setSendStatus:@"0"];
            [self sendFailureShowTips:dataDict[@"status"]];
            [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        }
        [_tableView reloadData];
    } failure:^(id error) {
        [chatModel setSendStatus:@"0"];
        [self sendFailureShowTips:dataDict[@"status"]];
        [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:chatModel iid:old_iid];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [_tableView reloadData];
    }];
}

- (void)requestDownloadAudioWithModel:(JYChatModel *)chatModel
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:chatModel.fileUrl]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        NSString *p = [[JYHelpers getCurrentUserStoreageSubDirectory:@"voice"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", chatModel.iid]];
        NSString *path = [NSString stringWithFormat:@"file://%@", p];
        return [NSURL URLWithString:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        for (int i = 0;i<_globalShowData.count ;i++) {
            JYChatModel * temp  = _globalShowData[i];
            if ([chatModel isEqual:temp]) {
                JYChatTableViewCell * cellObj = (JYChatTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cellObj startPlayAudio];
                break;
            }
        }
        [_speech startPlay:chatModel.iid];
    }];
    
    [downloadTask resume];
}

#pragma mark - 从本地sqlite数据库，获取聊天记录

- (void)getChatLogFromLocation
{
    NSString * iid = @"0";
    if (_globalShowData.count > 0) {
        JYChatModel *firstChatModel = _globalShowData[0];
        iid = ToString(firstChatModel.iid);
//        self.isFirstLoad = NO;//标志是否第一次加载
    }
    
    NSMutableArray *chatLogList = [[JYChatDataBase sharedInstance] getListChatLogWithFromUid:self.fromMsgModel.oid iid:iid pageSize:10];
    if (chatLogList.count>0) {
        
        NSArray *tempList = [[chatLogList reverseObjectEnumerator] allObjects];
        chatLogList = [[NSMutableArray alloc] initWithArray:tempList];
        for (int i=(int)chatLogList.count-1; i>=0; i--) {
            JYChatModel *chatModel =  [self chatModelWithDict:chatLogList[i]];//[[JYChatModel alloc] initWithDataDic:chatLogList[i]];
            BOOL isExistMsgId = NO;
            for (int j=0; j<_globalShowData.count; j++) {
                
                JYChatModel *model = _globalShowData[j];
                if ([chatModel.iid longLongValue] == [model.iid longLongValue]) {
                    
                    isExistMsgId = YES;
                    break;
                }
            }
            
            //原有数组不存在当前消息iid,才添加
            if (!isExistMsgId) {
                [self.globalShowData insertObject:chatModel atIndex:0];
            }
            
            
        }
        
        //可能顺序会乱，重排
//        [self resortChatLogData];
        [self messageListWithSendTime];
        [_tableView setData:_globalShowData];
        [_tableView reloadData];
        
    } else {
        
    }
}

#pragma mark - 获取新消息

- (void)getNewMsgFromLocation
{
    NSString *lastTime = [NSString stringWithFormat:@"0"];
    JYChatModel *lastChatModel = (JYChatModel *)[_globalShowData lastObject];
    if (lastChatModel) {
        lastTime = [NSString stringWithFormat:@"%@", lastChatModel.time];
    }
    NSArray *newChatlogList = [[JYChatDataBase sharedInstance] getNewMsgWithFromUid:self.fromMsgModel.oid sendTime:lastTime];
    if (newChatlogList.count>0) {
        
        for (int i=0; i<newChatlogList.count; i++) {
            
            JYChatModel *chatModel = [[JYChatModel alloc] initWithDataDic:newChatlogList[i]];
            BOOL isExistMsgId = NO;
            for (int j=0; j<self.globalShowData.count; j++) {
                
                JYChatModel *model = [_globalShowData objectAtIndex:j];
                if ([chatModel.iid longLongValue] == [model.iid longLongValue]) {
                    
                    isExistMsgId = YES;
                    break;
                }
            }
            
            //原有数组不存在当前消息iid,才添加
            if (!isExistMsgId) {
                [self.globalShowData insertObject:chatModel atIndex:self.globalShowData.count];
            }
            
            
        }
        
        //可能顺序会乱，重排
//        [self resortChatLogData];
        
        [_tableView setData:_globalShowData];
        [_tableView reloadData];
        
    } else {
        
        
        
    }
}

#pragma mark - 获取历史消息

- (void)getHistoryMsgFromLocation
{
    //获取当前本地时间 转成时间戳
    NSDate *date = [NSDate date];
    NSString *firstSendTime = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    
    if (_globalShowData.count > 0) {
        JYChatModel *firstChatModel = (JYChatModel *)[_globalShowData objectAtIndex:0];
        firstSendTime = [NSString stringWithFormat:@"%@", firstChatModel.time];
    }
    
    NSArray *historyChatlogList = [[JYChatDataBase sharedInstance] getHistoryMsgWithFromUid:self.fromMsgModel.oid sendTime:firstSendTime];
    if (historyChatlogList.count > 0) {
        
        for (NSInteger i=0; i<historyChatlogList.count; i++) {
            
            JYChatModel *chatModel = [[JYChatModel alloc] initWithDataDic:historyChatlogList[i]];
            BOOL isExistMsgId = NO;
            for (int j=0; j<self.globalShowData.count; j++) {
                
                JYChatModel *model = [_globalShowData objectAtIndex:j];
                if ([chatModel.iid longLongValue] == [model.iid longLongValue]) {
                    
                    isExistMsgId = YES;
                    break;
                }
            }
            
            //原有数组不存在当前消息iid,才添加
            if (!isExistMsgId) {
                [self.globalShowData insertObject:chatModel atIndex:0];
            }
            
            
        }
        
        //可能顺序会乱，重排
        //        [self resortChatLogData];
        
        
        
    } else {
        
        
        
    }
    
    [_tableView setData:_globalShowData];
    [_tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - 重新排序数组
- (void)resortChatLogData{
    
    /*
    NSMutableArray * tempList = [[NSMutableArray alloc] init];
    for (JYChatModel * model in _globalShowData) {
        [tempList addObject:model];
    }
    //排序
    for (int i= 0; i<tempList.count-1; i++) {
        
        for (int j = i+1; j<tempList.count; j++) {
            
            JYChatModel *iModel = (JYChatModel *)tempList[i];
            JYChatModel *jModel = (JYChatModel *)tempList[j];
            
            if ([iModel.sendTime integerValue] > [jModel.sendTime integerValue]) {
                
                JYChatModel *tempModel = iModel;
                [tempList replaceObjectAtIndex:i withObject:jModel];
                [tempList replaceObjectAtIndex:j withObject:tempModel];
            }
        }
    }
    [_globalShowData removeAllObjects];
    [_globalShowData addObjectsFromArray:tempList];
    */
    
    //排序
    for (int i= 0; i<_globalShowData.count-1; i++) {
        
        for (int j = i+1; j<_globalShowData.count; j++) {
            
            JYChatModel *iModel = (JYChatModel *)_globalShowData[i];
            JYChatModel *jModel = (JYChatModel *)_globalShowData[j];
            
            if ([iModel.time integerValue] > [jModel.time integerValue]) {
                
                JYChatModel *tempModel = iModel;
                [_globalShowData replaceObjectAtIndex:i withObject:jModel];
                [_globalShowData replaceObjectAtIndex:j withObject:tempModel];
            }
        }
    }
}

#pragma mark - 用Dict构建ChatModel
- (JYChatModel *)chatModelWithDict:(NSDictionary *)dict
{
    NSLog(@"%@", _currentUserInfoDict)
    
    JYChatModel *chatModel = [[JYChatModel alloc] init];
    chatModel.groupId = [dict objectForKey:@"group_id"];
    chatModel.ext = [dict objectForKey:@"ext"];
    if (chatModel.groupId) {
        chatModel.isGroup = YES;
        
        NSString *selfUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        if ([selfUid isEqualToString:[dict objectForKey:@"uid"]]) {
            chatModel.sendType = @"2";

        } else {
            chatModel.sendType = @"1";
        }

    } else {
        chatModel.isGroup = NO;
        chatModel.sendType = [dict objectForKey:@"type"];
    }
    chatModel.iid = [dict objectForKey:@"iid"];
    chatModel.msgType = [dict objectForKey:@"msgtype"];
    chatModel.chatMsg = [dict objectForKey:@"content"];
    chatModel.msgFrom = [dict objectForKey:@"msgFrom"];
    chatModel.time = [[dict objectForKey:@"sendtime"] stringValue];
    chatModel.sendStatus = [NSString stringWithFormat:@"2"];
    chatModel.is_sys_tip = [dict objectForKey:@"is_sys_tip"];
    
    if (_isGroupChat) {
        chatModel.readStatus = @"1";
    } else {
        chatModel.readStatus = [dict objectForKey:@"status"];
    }
    chatModel.imgWidth = [NSString stringWithFormat:@""];
    chatModel.imgHeight = [NSString stringWithFormat:@""];
    chatModel.fileData = [dict objectForKey:@"fileData"];
    
    if (chatModel.isGroup) {
        chatModel.fromUid = [dict objectForKey:@"uid"];
    } else {
        chatModel.fromUid = [dict objectForKey:@"oid"];
    }
    
    if (chatModel.msgFrom) {
        //nothing
    } else {
        chatModel.msgFrom = @"";
    }
    
    //昵称 性别
    if ([chatModel.sendType integerValue] == 2) {
        //发出的信息
        chatModel.nick = [_currentUserInfoDict objectForKey:@"nick"];
        chatModel.sex = [_currentUserInfoDict objectForKey:@"sex"];
    } else {
        //接收的信息
        if (_isGroupChat) {
            //群聊
            chatModel.nick = [dict objectForKey:@"nick"];
            chatModel.sex = [dict objectForKey:@"sex"];
        } else {
            //单聊
            chatModel.nick = self.fromMsgModel.nick;
            chatModel.sex = self.fromMsgModel.sex;
        }
    }
    
    switch ([chatModel.msgType integerValue]) {
        case 0:
        {
            //文本信息
            chatModel.fileUrl = [NSString stringWithFormat:@""];
            chatModel.voiceLength = [NSString stringWithFormat:@""];
        }
            break;
        case 1:
        {
            //文本信息
            chatModel.fileUrl = [NSString stringWithFormat:@""];
            chatModel.voiceLength = [NSString stringWithFormat:@""];
        }
            break;
        case 2:
        {
            //语音信息
            chatModel.fileUrl = dict[@"ext"][@"voice"];
            chatModel.voiceLength = [NSString stringWithFormat:@"%ld", (long)[dict[@"ext"][@"dur"] integerValue]];
        }
            break;
        case 3:
        {
            //图片信息
            chatModel.fileUrl = [[dict objectForKey:@"ext"] objectForKey:@"pic200"];
            chatModel.voiceLength = [NSString stringWithFormat:@""];
        }
            break;
        case 4:
        {
            //语音信息
            chatModel.fileUrl = dict[@"ext"][@"voice"];
            chatModel.voiceLength = [NSString stringWithFormat:@"%ld", (long)[dict[@"ext"][@"dur"] integerValue]];
        }
            break;
        case 5:
        {
            //图片信息
            chatModel.fileUrl = [[dict objectForKey:@"ext"] objectForKey:@"pic200"];
            chatModel.voiceLength = [NSString stringWithFormat:@""];
        }
            break;
        default:
            break;
    }
    
    //头像
    switch ([chatModel.sendType integerValue]) {
        case 1:
        {
            //接收的消息
            if (_isGroupChat) {
                chatModel.avatar = [dict objectForKey:@"avatar"];
            } else {
                chatModel.avatar = self.fromMsgModel.avatar;
            }
            
        }
            break;
        case 2:
        {
            //发送的消息
            [chatModel setAvatar:_currentUserInfoDict[@"avatars"][@"100"]];
        }
            break;
            
        default:
            break;
    }
    
    return chatModel;
}

- (JYChatModel *)chatModelWithGroupDict:(NSDictionary *)dict
{
    /*
     @property (nonatomic, copy) NSString *iid;          //消息id
     @property (nonatomic, copy) NSString *msgType;      //消息类型 0:文本消息 2:语音消息 3:图片消息
     @property (nonatomic, copy) NSString *avatar;       //头像
     @property (nonatomic, copy) NSString *chatMsg;      //消息内容
     @property (nonatomic, copy) NSString *fromUid;      //消息来自于哪个人
     @property (nonatomic, copy) NSString *nick;         //昵称
     @property (nonatomic, copy) NSString *msgFrom;      //消息来自于哪种设备
     @property (nonatomic, copy) NSString *sex;          //0:女 1:男
     @property (nonatomic, copy) NSString *time;         //时间
     @property (nonatomic, copy) NSString *sendStatus;   //发送状态 0发送失败 1发送中 2发送成功
     @property (nonatomic, copy) NSString *readStatus;   //阅读状态 0未读 1已读
     @property (nonatomic, copy) NSString *fileUrl;      //图片 或者语音链接
     @property (nonatomic, strong) NSDate *fileData;     //文件数据
     @property (nonatomic, copy) NSString *voiceLength;  //语音消息长度
     @property (nonatomic, copy) NSString *imgWidth;     //图片宽
     @property (nonatomic, copy) NSString *imgHeight;    //图片高
     @property (nonatomic, copy) NSString *sendType;     //0全部 1收件 2发件
     */
    JYChatModel *chatModel = [[JYChatModel alloc] init];
    chatModel.iid = [dict objectForKey:@"iid"];
    chatModel.msgType = [dict objectForKey:@"msgtype"];
    chatModel.chatMsg = [dict objectForKey:@"content"];
    chatModel.fromUid = [dict objectForKey:@"uid"];
    chatModel.msgFrom = [dict objectForKey:@"msgFrom"];
    chatModel.sendType = [dict objectForKey:@"type"];
    chatModel.time = [[dict objectForKey:@"sendtime"] stringValue];
    chatModel.sendStatus = [NSString stringWithFormat:@"2"];
    chatModel.readStatus = [dict objectForKey:@"status"];
    chatModel.imgWidth = [NSString stringWithFormat:@""];
    chatModel.imgHeight = [NSString stringWithFormat:@""];
    chatModel.fileData = [dict objectForKey:@"fileData"];
    chatModel.is_sys_tip = [dict objectForKey:@"is_sys_tip"];
    
    NSString *selfUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    if ([chatModel.fromUid isEqualToString:selfUid]) {
        chatModel.sendType = @"2";
    } else {
        chatModel.sendType = @"1";
    }
    
    if (chatModel.msgFrom) {
        //nothing
    } else {
        chatModel.msgFrom = @"";
    }
    
    //昵称 性别
    if ([chatModel.sendType integerValue] == 2) {
        //发出的信息
        chatModel.nick = [_currentUserInfoDict objectForKey:@"nick"];
        chatModel.sex = [_currentUserInfoDict objectForKey:@"sex"];
    } else {
        //接收的信息
        if (_isGroupChat) {
            //群聊
            chatModel.nick = [dict objectForKey:@"nick"];
            chatModel.sex = [dict objectForKey:@"sec"];
        } else {
            //单聊
            chatModel.nick = self.fromMsgModel.nick;
            chatModel.sex = self.fromMsgModel.sex;
        }
    }
    
    switch ([chatModel.msgType integerValue]) {
        case 0:
        {
            //文本信息
            chatModel.fileUrl = [NSString stringWithFormat:@""];
            chatModel.voiceLength = [NSString stringWithFormat:@""];
        }
            break;
        case 2:
        {
            //语音信息
            chatModel.fileUrl = dict[@"ext"][@"voice"];
            chatModel.voiceLength = [NSString stringWithFormat:@"%ld", (long)[dict[@"ext"][@"dur"] integerValue]];
        }
            break;
        case 3:
        {
            //图片信息
            chatModel.fileUrl = [[dict objectForKey:@"ext"] objectForKey:@"pic200"];
            chatModel.voiceLength = [NSString stringWithFormat:@""];
        }
            break;
        default:
            break;
    }
    
    //头像
    switch ([chatModel.sendType integerValue]) {
        case 1:
        {
            //接收的消息
            chatModel.avatar = self.fromMsgModel.avatar;
        }
            break;
        case 2:
        {
            //发送的消息
            [chatModel setAvatar:_currentUserInfoDict[@"avatars"][@"100"]];
        }
            break;
            
        default:
            break;
    }
    
    return chatModel;
}

#pragma mark - HeaderTableViewDelegate

- (void)pullDown:(JYBaseHeaderTableView *)tableView {
    
    NSLog(@"%f", _tableView.contentSize.height);
    _tagPosition = _tableView.contentSize.height;
    
    if (_isGroupChat) {
        [self requestGetHistoryGroupChatList];
    } else {
        [self requestGetHistoryUserChatList];
    }
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _sendImageBtn.selected = NO;
    _faceBtn.selected = NO;
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@""]){
        
        return [self deleteBtnClick:range.location];
    }
    
    if (text.length > 1000) { //最多输入1000个字。
        [[JYAppDelegate sharedAppDelegate] showTip:@"输入的字符已达上限"];
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按
        [self sendTextContentToHttp:textView.text];
        return NO;
    }
    
    return YES;
}

#pragma mark - 向网络发送文本数据
- (void)sendTextContentToHttp:(NSString *)text{

    NSString * str = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([JYHelpers isEmptyOfString:str]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"内容不能为空"];
        return;
    }
    
    faceCount = 0 ;//发送后，表情计数要清0;
    
    NSLog(@"发送");
    //构建一个消息字典 存在本地数据库
    JYChatModel *chatModel = [[JYChatModel alloc] init];
    chatModel.isGroup = self.isGroupChat;
    if (_isGroupChat) {
        chatModel.iid = [[JYChatDataBase sharedInstance] getGroupChatLogId];
    } else {
        chatModel.iid = [[JYChatDataBase sharedInstance] getChatLogId];
    }
    
    if (_isGroupChat) {
        chatModel.groupId = self.fromGroupModel.group_id;
        chatModel.msgType = @"1";
    } else {
        chatModel.msgType = @"0";
    }
    chatModel.avatar = _currentUserInfoDict[@"avatars"][@"100"];
    chatModel.chatMsg = str;
    chatModel.fromUid = self.fromUid;
    chatModel.nick = _currentUserInfoDict[@"nick"];
    chatModel.msgFrom = @"";
    chatModel.sex = _currentUserInfoDict[@"sex"];
    chatModel.time = [JYHelpers currentDateTimeInterval];
    chatModel.sendStatus = @"1";
    chatModel.readStatus = @"1";
    chatModel.fileUrl = @"";
    chatModel.fileData = nil;
    chatModel.voiceLength = @"";
    chatModel.imgHeight = @"";
    chatModel.imgWidth = @"";
    chatModel.sendType = @"2";
    
    if (_isGroupChat) {
        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
    } else {
        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
    }
    
    [_globalShowData addObject:chatModel];
    [self messageListWithSendTime];
    [_tableView setData:_globalShowData];
    [_tableView reloadData];
    
    //清空输入框
    [_inputTextView setText:@""];
    CGFloat inputBgHeight = 49.0f;
    [_inputBgImage setFrame:CGRectMake(0, _inputBgImage.origin.y+_inputBgImage.height-inputBgHeight, _inputBgImage.width, inputBgHeight)];
    [_inputTextViewBgImage setFrame:CGRectMake(_faceBtn.right+10, 10, _inputTextViewBgImage.width, inputBgHeight-20)];
    [_inputTextView setFrame:CGRectMake(0, 0, _inputTextViewBgImage.width, _inputTextViewBgImage.height)];
    
    if (_isGroupChat) {
        [self requestSendGroupMsgWithModel:chatModel];
    } else {
        [self requestSendTextMsgWithModel:chatModel];
    }
    
    [self adjustTableViewPostion];
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [self fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];//[info objectForKey:UIImagePickerControllerEditedImage];
    NSString *imageUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@", imageUrl);
    
    [self handleCallBackImage:image];
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)handleCallBackImage:(UIImage *)image{
    if(image.size.width > 5000 || image.size.height > 10000){
        [[JYAppDelegate sharedAppDelegate] showTip:@"图片尺寸不正确（尺寸应为100-10000px）"];
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //将图片存入沙盒中
    int randNum = arc4random()%100000;
    NSString *fileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"%d.png", randNum]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    NSDictionary * ext =             @{
                                       @"pic0" :[NSString stringWithFormat:@"%@?wh=%fx%f", filePath,image.size.width,image.size.height],
                                       @"pic150":[NSString stringWithFormat:@"%@?wh=%fx%f", filePath,image.size.width,image.size.height],
                                       @"pic200" : [NSString stringWithFormat:@"%@?wh=%fx%f", filePath,image.size.width,image.size.height],
                                       @"pid" : @"0",
                                       @"uid" : fileName
                                       };
    
    JYChatModel *chatModel = [[JYChatModel alloc] init];
    chatModel.isGroup = self.isGroupChat;
    if (self.isGroupChat) {
        chatModel.groupId = self.fromGroupModel.group_id;
        chatModel.iid = [[JYChatDataBase sharedInstance] getGroupChatLogId];
        chatModel.msgType = @"5";
    } else {
        chatModel.iid = [[JYChatDataBase sharedInstance] getChatLogId];
        chatModel.msgType = @"3";
    }
    chatModel.chatMsg = @"[图片消息]";
    chatModel.avatar = _currentUserInfoDict[@"avatars"][@"100"];
    chatModel.fromUid = self.fromUid;
    chatModel.nick = _currentUserInfoDict[@"nick"];
    chatModel.msgFrom = @"";
    chatModel.sex = _currentUserInfoDict[@"sex"];
    chatModel.time = [JYHelpers currentDateTimeInterval];
    chatModel.sendStatus = @"1";
    chatModel.readStatus = @"1";
    chatModel.fileUrl = fileName;
    chatModel.fileData = imageData;
    chatModel.sendType = @"2";
    chatModel.ext = ext;
    
    if (_isGroupChat) {
        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
        [self requestSendPicGroupMsgWithModel:chatModel];
    } else {
        [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
        [self requestSendPicMsgWithModel:chatModel];
    }
    
    [_globalShowData addObject:chatModel];
    [self messageListWithSendTime];
    [_tableView setData:_globalShowData];
    [_tableView reloadData];
    
    [self adjustTableViewPostion];
}

#pragma mark - SpeechControllerDelegate

- (void)speechRecordBegan:(SpeechController *)speechController msgId:(NSString *)msgId
{
    NSLog(@"speechRecordBegan");
    
}

- (void)speechRecordFinished:(SpeechController *)speechController msgId:(NSString *)msgId speechLength:(NSInteger)speechLength
{
    if (_isCancelSendRecord  || speechLength == 0) {
        //取消发送
        
    } else {
        
        NSLog(@"speechRecordFinished %@   %ld", msgId, (long)speechLength);
        //将录音存入沙盒中
        NSString *paths = [JYHelpers getCurrentUserStoreageSubDirectory:@"voice"];
        NSString *amrPath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", msgId]];
        NSData *amrData = [JYHelpers fromLocationPahtGetFileContent:amrPath];
        NSString *newDur = [NSString stringWithFormat:@"%lf", round(speechLength/1000)];
        //刷新ui
//        NSString *tempContent = [NSString stringWithFormat: @"{\"type\":\"voice\",\"url\":\"%@\",\"dur\":\"%d\"}", amrPath, newDur];
        
//        NSDictionary *extDict = [NSDictionary dictionaryWithObjects:@[newDur, amrPath]
//                                                           forKeys:@[@"dur", @"voice"]];
        
//        JYChatModel *chatModel = [self chatModelWithDict:msgDict];
        JYChatModel *chatModel = [[JYChatModel alloc] init];
        chatModel.isGroup = self.isGroupChat;
        chatModel.groupId = self.fromGroupModel.group_id;
        if (_isGroupChat) {
            chatModel.iid = [[JYChatDataBase sharedInstance] getGroupChatLogId];
        } else {
            chatModel.iid = [[JYChatDataBase sharedInstance] getChatLogId];
        }
//        chatModel.iid = msgId;
        if (_isGroupChat) {
            chatModel.msgType = @"4";
        } else {
            chatModel.msgType = @"2";
        }
        chatModel.chatMsg = @"[语音消息]";
        chatModel.avatar = _currentUserInfoDict[@"avatars"][@"100"];
        chatModel.chatMsg = @"";
        chatModel.fromUid = self.fromUid;
        chatModel.nick = _currentUserInfoDict[@"nick"];
        chatModel.msgFrom = @"";
        chatModel.sex = _currentUserInfoDict[@"sex"];
        chatModel.time = [JYHelpers currentDateTimeInterval];
        chatModel.sendStatus = @"1";
        chatModel.readStatus = @"1";
        chatModel.voiceLength = [NSString stringWithFormat:@"%ld", (long)[newDur integerValue]];
        chatModel.fileUrl = msgId;
        chatModel.fileData = amrData;
        chatModel.sendType = @"2";
        chatModel.voiceId = msgId;
        
        if (_isGroupChat) {
            [[JYChatDataBase sharedInstance] insertOneChatMsgIntoGroupChatLogWithModel:chatModel];
            [self requestSendGroupVoiceMsgWithModel:chatModel];
        } else {
            [[JYChatDataBase sharedInstance] insertOneChatMsgIntoChatLogWithModel:chatModel];
            [self requestSendVoiceMsgWithModel:chatModel];
        }

        [_globalShowData addObject:chatModel];
        [self messageListWithSendTime];
        [self checkArrayIsShowVoiceStatusTips];
        [_tableView setData:_globalShowData];
        [_tableView reloadData];
        
        if (_tagPosition == 0) {
            [self adjustTableViewPostion];
        } else {
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height-_tagPosition)];
        }
    }
    
    
}

- (void)speechRecordError:(SpeechController *)speechController msgId:(NSString *)msgId
{

}

-(void)speechPlayBegan:(SpeechController *)speechController msgId:(NSString *)msgId
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([[JYShareData sharedInstance].voiceSpeakerOrHeadphone intValue] == 1) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }else{
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
}

-(void)speechPlayFinished:(SpeechController *)speechController msgId:(NSString *)msgId
{
    NSLog(@"播放完成");
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kChatStopPlayAudioNotification object:nil userInfo:nil];
    for (int i = 0;i<_globalShowData.count ;i++) {
        JYChatModel * temp  = _globalShowData[i];
        if ([msgId isEqualToString:temp.iid] || [msgId isEqualToString:temp.voiceId]) {
            JYChatTableViewCell * cellObj = (JYChatTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cellObj stopPlayAudio];
            break;
        }
    }
}

-(void)speechPlayError:(SpeechController *)speechController msgId:(NSString *)msgId
{

}

//右向上点击进入profile
-(void)rightProfileBtnClick:(UIButton *)btn{
    if ([self.from intValue] == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        JYOtherProfileController * _profileVC = [[JYOtherProfileController alloc] init];
        _profileVC.show_uid =  ToString(_fromMsgModel.oid);
        _profileVC.isFromChat = YES;
        [self.navigationController pushViewController:_profileVC animated:YES];
    }
    
}

//头像点击进入profile
-(void)cellClickAvatar:(NSNotification *)noti{
    NSDictionary * userinfo = noti.userInfo;
    if(![JYHelpers isEmptyOfString:userinfo[@"uid"]]){
        JYOtherProfileController * _profileVC = [[JYOtherProfileController alloc] init];
        _profileVC.isFromChat = YES;
        _profileVC.show_uid =  userinfo[@"uid"];
        [self.navigationController pushViewController:_profileVC animated:YES];
    }
}

- (void)cellClickShare:(NSNotification *)noti{
    NSDictionary * userinfo = noti.userInfo;
    if(![JYHelpers isEmptyOfString:userinfo[@"uid"]]){
        JYOtherProfileController * _profileVC = [[JYOtherProfileController alloc] init];
        _profileVC.show_uid =  userinfo[@"uid"];
        [self.navigationController pushViewController:_profileVC animated:YES];
    }
}

- (void) stopPlayAudioNoti:(NSNotification *)noti{
    [_speech stopPlay];
}
// 选中事件
//- (void)didSelectRowAtIndexPath:(JYBaseHeaderTableView *)tabelView indexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark 为消息列表中插入发送时间
//为消息列表中插入发送时间
- (void)messageListWithSendTime
{
    if (_globalShowData.count == 0) {
        return ;
    }
    
    JYChatModel *firstModel = (JYChatModel *)[_globalShowData objectAtIndex:0];
    firstModel.showSendTime = @"";
    NSInteger  lastTime = [firstModel.time integerValue];
    
    BOOL isShowTime = NO;
    //因为index:0是SendTimeModel所以从index:1开始循环
    for (int i=1; i<_globalShowData.count; i++) {
        JYChatModel *model = (JYChatModel *)[_globalShowData objectAtIndex:i];
        model.showSendTime = @"";
        NSInteger sendTime = [model.time integerValue] ;
        
        //发送时间和现在相差10分钟以上 和上次显示的时间相差10分钟以上就显示
        //        if ((nowTimeInterval-sendTimeInterval>10*60) && (sendTimeInterval-lastTimeInterval>10*60)) {
        
        if (sendTime-lastTime>10*60) {
            
            isShowTime = YES;
            
            model.showSendTime = [JYHelpers unxiToDate2:[model.time integerValue]];
            
            lastTime = sendTime;
            
        }
    }
    
    if (!isShowTime) {
        
        firstModel.showSendTime = [JYHelpers unxiToDate2:[firstModel.time integerValue]];
    }
    
    //    NSLog(@"%@", messageList);
    
    
    //return messageList;
}

//发送的失败的记录，重新发送
- (void)chatLogFailureResendNoti:(NSNotification *)noti{
    
    JYChatModel * resendModel =  (JYChatModel *)noti.object;
    resendModel.sendStatus = @"1";
    resendModel.time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    //判断是否为最后一条信息，如果最后一条，不用删除
    JYChatModel * lastChatModel = [_globalShowData lastObject];
    if([resendModel.iid integerValue] != [lastChatModel.iid integerValue]){
        for (int i = 0; i<_globalShowData.count; i++) {
            JYChatModel *temp = _globalShowData[i];
            if ([resendModel.iid integerValue] == [temp.iid integerValue]) {
                [_globalShowData removeObjectAtIndex:i];
                [_globalShowData addObject:resendModel];
                
                break;
            }
        }
    }
    [self checkArrayIsShowVoiceStatusTips];
    [_tableView reloadData];
    
    if (resendModel.isGroup) {
        [[JYChatDataBase sharedInstance] updateGroupChatLogOneChatMsgWithModel:resendModel iid:resendModel.iid];
        switch ([resendModel.msgType intValue]) {
            case 1:
                [self requestSendGroupMsgWithModel:resendModel];
                break;
            case 5:
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:resendModel.fileUrl];
                UIImage *tImage = [UIImage imageWithContentsOfFile:filePath];
                NSData *data = UIImagePNGRepresentation(tImage);
                resendModel.fileData = data;
                [self requestSendPicMsgWithModel:resendModel];
                [self requestSendPicGroupMsgWithModel:resendModel];
            }
                break;
            case 4:{
                //将录音存入沙盒中
                NSString *paths = [JYHelpers getCurrentUserStoreageSubDirectory:@"voice"];
                NSString *amrPath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", resendModel.fileUrl]];
                NSData *amrData = [JYHelpers fromLocationPahtGetFileContent:amrPath];
                resendModel.fileData = amrData;
                [self requestSendGroupVoiceMsgWithModel:resendModel];
            }
                
                break;
        }
    }else{
        [[JYChatDataBase sharedInstance] updateChatLogOneChatMsgWithModel:resendModel iid:resendModel.iid];
        
        switch ([resendModel.msgType intValue]) {
            case 0:
                [self requestSendTextMsgWithModel:resendModel];
                break;
            case 3:
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:resendModel.fileUrl];
                UIImage *tImage = [UIImage imageWithContentsOfFile:filePath];
                NSData *data = UIImagePNGRepresentation(tImage);
                resendModel.fileData = data;
                [self requestSendPicMsgWithModel:resendModel];
            }
                break;
            case 2:{
                //将录音存入沙盒中
                NSString *paths = [JYHelpers getCurrentUserStoreageSubDirectory:@"voice"];
                NSString *amrPath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr", resendModel.fileUrl]];
                NSData *amrData = [JYHelpers fromLocationPahtGetFileContent:amrPath];
                resendModel.fileData = amrData;
                [self requestSendVoiceMsgWithModel:resendModel];
            }
                break;
        }
    }
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self tableViewTap:nil];
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
//    int x = point.x;
//    int y = point.y;
//    NSLog(@"touch (x, y) is (%d, %d)", x, y);
//}

- (void)didScrollViewDidScroll:(JYBaseHeaderTableView *)scrollView{

    if (_inputBgImage.top <  kScreenHeight-kStatusBarHeight-kNavigationBarHeight-kTabBarViewHeight-5 && (lastTableViewOffsetTop > scrollView.contentOffset.y || scrollView.contentOffset.y< 0)) {
        
        
        [self tableViewTap:nil];
    }
    lastTableViewOffsetTop = scrollView.contentOffset.y;
}

#pragma mark - 发送新消息，后改变table的位置
- (void) adjustTableViewPostion{
    int tempHeight =0;
    if (_faceBtn.selected) {
        tempHeight = _emojiView.height;
    }else if(_sendImageBtn.selected){
        tempHeight = _sendImageBg.height;
    }else{
        tempHeight = keyboardHeight;
    }
    
    if (_tableView.contentSize.height > _tableView.height-tempHeight- _inputBgImage.height) { //只有当table的内容大于可显示区域，才向上移动
        if (_tableView.contentSize.height >_tableView.height) {
            [_tableView setOrigin:CGPointMake(0, -( tempHeight+_inputBgImage.height - kTabBarViewHeight ))];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_globalShowData.count-1 inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            [_tableView setOrigin:CGPointMake(0, -(_tableView.contentSize.height-_tableView.height + tempHeight +(_inputBgImage.height - kTabBarViewHeight)))];
        }
        
    }
}

//更新群组信息
-(void)updateGroupInfo{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"get_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromGroupModel.group_id forKey:@"group_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [JYShareData sharedInstance].groupChatIsShowNick = [data objectForKey:@"shownick"];
            
            JYMessageModel *retMsgModel = [[JYMessageModel alloc] initWithDataDic:data];
            NSArray *msgList = [JYShareData sharedInstance].messageUserList;
            
            if (_isGroupChat) {
                for (int i = 0; i<msgList.count; i++) {
                    JYMessageModel *msgModel = (JYMessageModel *)[msgList objectAtIndex:i];
                    if ([msgModel.group_id isEqualToString:self.fromGroupModel.group_id]) {
                        msgModel.logo = retMsgModel.logo;
                        msgModel.title = retMsgModel.title;
                        msgModel.hint = retMsgModel.hint;
                        [[JYChatDataBase sharedInstance] insertOneUser:msgModel];
                        break;
                    }
                }
            }
            [_tableView reloadData];
        } else {
        }
        
    } failure:^(id error) {
    }];
}

//置已读的接口， type为0-普通用户 1-群组用户
- (void) readTheUserMessage:(NSString *)uid type:(int)type{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    
    if(type == 0){
        [parametersDict setObject:@"set_onread_by_oid" forKey:@"func"];
        [postDict setObject:uid forKey:@"oid"];
    }else{
        [parametersDict setObject:@"set_onread_group_by_oid" forKey:@"func"];
        [postDict setObject:uid forKey:@"group_id"];
    }
    
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
    } failure:^(id error) {
    }];
}

//实际没有什么作用，只是为点击后，收起键盘
- (void)didSelectRowAtIndexPath:(JYBaseFooterTableView *)tabelView indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"test select ");
    [self tableViewTap:nil];
}

//距离感应
-(void)sensorStateChange:(NSNotificationCenter *)notification;

{
    if ([[JYShareData sharedInstance].voiceSpeakerOrHeadphone intValue] == 0) {
    
        if ([[UIDevice currentDevice] proximityState] == YES) {
            NSLog(@"Device is close to user");
            //在此写接近时，要做的操作逻辑代码
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        }else{
            NSLog(@"Device is not close to user");
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        }
    }
}

#pragma mark - JYChatGetLocalPhotoDelegate
//相片选择回调
- (void) JYChatLocalPhotoSelected:(JYChatGetLocalPhoto *)chatLocalPhoto selectedImage:(JYLocalImageModel *)imageModel{
    NSLog(@"123123");
    UIImage * bigImage = imageModel.fullScreenImage;
    [self handleCallBackImage:bigImage];
}


//请求网络获取语音播放时，是扬声器还是听筒,0-扬声器，1-听筒
- (void) getVoicePlayStatus{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"profile" forKey:@"mod"];
    [parametersDict setObject:@"get_user_voice_switch" forKey:@"func"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            [JYShareData sharedInstance].voiceSpeakerOrHeadphone = [responseObject objectForKey:@"data"];
        } else {
        }
        
    } failure:^(id error) {
    }];
}


//循环数组，是否有需要显示当前语音状态
- (void) checkArrayIsShowVoiceStatusTips{
    if (_globalShowData.count == 0) {
        return ;
    }
    
//    NSString * lastVoiceTime = [JYShareData sharedInstance].lastVoiceMsgTime;
    NSInteger voiceIndex = -1;
    for (NSInteger i=0; i<_globalShowData.count; i++) {
        JYChatModel *model = (JYChatModel *)[_globalShowData objectAtIndex:i];
        model.voiceShowPlayStatus = NO; //语音消息显示状态,全部为不显示状态
        if ([model.msgType intValue] == 2 || [model.msgType intValue] == 4) {
            voiceIndex = i;
        }
    }
    

    if (voiceIndex > -1) {
        JYChatModel *model = (JYChatModel *)[_globalShowData objectAtIndex:voiceIndex];
        model.voiceShowPlayStatus = YES;
//        if ([lastVoiceTime integerValue] > 0) {
//            if ([model.time integerValue]- [lastVoiceTime integerValue] > 60*30) {
//                model.voiceShowPlayStatus = YES;
//                [JYShareData sharedInstance].lastVoiceMsgTime = model.time;
//            }else if([model.time integerValue] == [lastVoiceTime integerValue]){
//                model.voiceShowPlayStatus = YES;
//                [JYShareData sharedInstance].lastVoiceMsgTime = model.time;
//            }
//            
//        }else{
//            model.voiceShowPlayStatus = YES;
//            [JYShareData sharedInstance].lastVoiceMsgTime = model.time;
//        }
    }
    
}

//刷新tableView
- (void) refreshTableViewUi{
    [_tableView reloadData];
}

//获取群组成员，去判断当前用户是否
- (void)requestGetGroupUserList{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"group_user_list" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.fromGroupModel.group_id forKey:@"group_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            BOOL myUidExist = NO;
            NSString * myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            NSArray * userList = [[responseObject objectForKey:@"data"] objectForKey:@"userlist"];
            //循环判断是否存在当前用户。
            for (NSDictionary * temp in userList) {
                if ([myuid isEqualToString:[temp objectForKey:@"uid"]]) {
                    myUidExist = YES;
                    break;
                }
            }
            
            //移除当前msg列表的群组消息
            if(!myUidExist){
                [[JYAppDelegate sharedAppDelegate] showTip:@"您已退出该群组"];
                NSMutableArray * myList = [JYShareData sharedInstance].messageUserList;
                for (int i = 0; i<myList.count; i++) {
                    JYMessageModel * msgModel = myList[i];
                    if ([msgModel.group_id isEqualToString:self.fromGroupModel.group_id]) {
                        [myList removeObjectAtIndex:i];
                        break;
                    }
                }
                [[JYChatDataBase sharedInstance] deleteOneGroupUser:self.fromGroupModel.group_id];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

// 旋转图片在上传
- (UIImage *)fixOrientation:(UIImage * )imag
{
    // No-op if the orientation is already correct
    if (imag.imageOrientation == UIImageOrientationUp) return imag;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imag.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, imag.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imag.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:break;
    }
    
    switch (imag.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, imag.size.width, imag.size.height,
                                             CGImageGetBitsPerComponent(imag.CGImage), 0,
                                             CGImageGetColorSpace(imag.CGImage),
                                             CGImageGetBitmapInfo(imag.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imag.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.height,imag.size.width), imag.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.width,imag.size.height), imag.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
