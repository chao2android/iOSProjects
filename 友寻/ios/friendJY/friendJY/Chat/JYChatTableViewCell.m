//
//  JYChatTableViewCell.m
//  friendJY
//
//  Created by 高斌 on 15/3/25.
//  Copyright (c) 2015年 高斌. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "JYChatTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JYShareData.h"
#import "JYChatDataBase.h"

@implementation JYChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarImage setBackgroundColor:[UIColor lightGrayColor]];
        _avatarImage.userInteractionEnabled = YES;
        [_avatarImage setClipsToBounds:YES];
        [_avatarImage.layer setCornerRadius:20.0f];
        [self.contentView addSubview:_avatarImage];
        [_avatarImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_avatarClickGes:)]];
        
        showTime = [[UILabel alloc] initWithFrame:CGRectZero];
        showTime.textColor = kTextColorGray;
        showTime.textAlignment = NSTextAlignmentCenter;
        showTime.font = [UIFont systemFontOfSize:12.0f ];
//        showTime.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:showTime];
        
        _textBg = [[UIView alloc] initWithFrame:CGRectZero];
        [_textBg setBackgroundColor:[UIColor clearColor]];
        [_textBg setHidden:YES];
        [self.contentView addSubview:_textBg];
        textPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [textPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
        [textPressGestureRecognizer setMinimumPressDuration:0.5f];
        [textPressGestureRecognizer setAllowableMovement:1.0];
        [_textBg addGestureRecognizer:textPressGestureRecognizer];
        
        _imageBg = [[UIView alloc] initWithFrame:CGRectZero];
        [_imageBg setBackgroundColor:[UIColor clearColor]];
        [_imageBg setHidden:YES];
        [self.contentView addSubview:_imageBg];
//        imagePressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
//        [imagePressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
//        [imagePressGestureRecognizer setMinimumPressDuration:0.5f];
//        [imagePressGestureRecognizer setAllowableMovement:1.0];
//        [_imageBg addGestureRecognizer:imagePressGestureRecognizer];
        
        _audioBg = [[UIView alloc] initWithFrame:CGRectZero];
        [_audioBg setBackgroundColor:[UIColor clearColor]];
        [_audioBg setHidden:YES];
        [self.contentView addSubview:_audioBg];
        voicePressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [voicePressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
        [voicePressGestureRecognizer setMinimumPressDuration:0.5f];
        [voicePressGestureRecognizer setAllowableMovement:1.0];
        [_audioBg addGestureRecognizer:voicePressGestureRecognizer];
        
        //群组，聊天用户昵称
        _groupUserNick = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupUserNick.clipsToBounds = YES;
        _groupUserNick.textColor = kTextColorGray;
        _groupUserNick.hidden = YES;
        _groupUserNick.font = [UIFont systemFontOfSize:14.f];
        [_textBg addSubview:_groupUserNick];
        
        //文本消息
        _bubbleBgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleBgImage.userInteractionEnabled = YES;
        [_textBg addSubview:_bubbleBgImage];
        
        /*
        _msgLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_msgLab setNumberOfLines:0];
        [_msgLab setBackgroundColor:[UIColor clearColor]];
        [_msgLab setFont:[UIFont systemFontOfSize:14.0f]];
        [_msgLab setTextAlignment:NSTextAlignmentLeft];
        [_msgLab setLineBreakMode:NSLineBreakByWordWrapping];
        [_bubbleBgImage addSubview:_msgLab];
         */
        
        _msgLab = [[UIView alloc] initWithFrame:CGRectZero];
        _msgLab.userInteractionEnabled = YES;
//        [_msgLab setMaxWidth:(kScreenWidth-10-40-10-10-30)];
//        [_msgLab setFontSize:14.0f];
        [_bubbleBgImage addSubview:_msgLab];
        
        _textActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_textActivity setHidden:YES];
//        [_textActivity startAnimating];
        [self.contentView addSubview:_textActivity];
        
        _textSendFailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        [_textSendFailView setImage:[UIImage imageNamed:@"msg_send_failure.png"]];
        [_textSendFailView setHidden:YES];
        _textSendFailView.userInteractionEnabled = YES;
        [self.contentView  addSubview:_textSendFailView];
        [_textSendFailView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_failureButtonClickGes:)]];
        
        _imageBubbleBgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageBg addSubview:_imageBubbleBgImage];
        
        //群组，聊天用户昵称
        _groupImageUserNick = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupImageUserNick.textColor = kTextColorGray;
        _groupImageUserNick.clipsToBounds = YES;
        _groupImageUserNick.hidden = YES;
        _groupImageUserNick.font = [UIFont systemFontOfSize:14.f];
        [_imageBg addSubview:_groupImageUserNick];
        
        //图片消息
        _imageMsgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageMsgImage setBackgroundColor:[UIColor lightGrayColor]];
        [_imageMsgImage setClipsToBounds:YES];
        [_imageMsgImage.layer setCornerRadius:10.0f];
        _imageMsgImage.userInteractionEnabled = YES;
        [_imageBg addSubview:_imageMsgImage];
        [_imageMsgImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(browserThisPhotoClick:)]];
        
//        _imageActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [_imageActivity setHidden:YES];
//        [_imageBg addSubview:_imageActivity];
        
//        _imageSendFailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
//        [_imageSendFailView setImage:[UIImage imageNamed:@"msg_send_failure.png"]];
//        [_imageSendFailView setHidden:YES];
//        [_imageBg addSubview:_imageSendFailView];
        
        //群组，聊天用户昵称
        _groupAudioUserNick = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupAudioUserNick.textColor = kTextColorGray;
        _groupAudioUserNick.clipsToBounds = YES;
        _groupAudioUserNick.hidden = YES;
        _groupAudioUserNick.font = [UIFont systemFontOfSize:14.f];
        [_audioBg addSubview:_groupAudioUserNick];
        
        //语音消息
        _audioBubbleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_audioBubbleImage setUserInteractionEnabled:YES];
        [_audioBubbleImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audioBubbleImageTap:)]];
        [_audioBg addSubview:_audioBubbleImage];
        
        _audioIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 17)];
        [_audioBg addSubview:_audioIcon];
        
        _secondsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        [_secondsLab setBackgroundColor:[UIColor clearColor]];
        [_secondsLab setTextAlignment:NSTextAlignmentCenter];
        [_secondsLab setTextColor:kTextColorWhite];
        [_secondsLab setFont:[UIFont systemFontOfSize:16.0f]];
        [_audioBg addSubview:_secondsLab];
        
//        _audioActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [_audioActivity setHidden:YES];
//        [_audioBg addSubview:_audioActivity];
        
//        _audioSendFailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
//        [_audioSendFailView setImage:[UIImage imageNamed:@"msg_send_failure.png"]];
//        [_audioSendFailView setHidden:YES];
//        [_audioBg addSubview:_audioSendFailView];
        
        _msgVoiceUnread = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        [_msgVoiceUnread setImage:[UIImage imageNamed:@"msgVoiceUnread"]];
        [_msgVoiceUnread setHidden:YES];
        [_audioBg addSubview:_msgVoiceUnread];

        
        _sysTipBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [_sysTipBg setBackgroundColor:[UIColor clearColor]];
        [_sysTipBg setHidden:YES];
        [_sysTipBg setUserInteractionEnabled:NO];
        [self.contentView addSubview:_sysTipBg];
        
        _sysTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.width, 20)];
        _sysTipLabel.backgroundColor = [UIColor clearColor];
        _sysTipLabel.font = [UIFont systemFontOfSize:12.f];
        _sysTipLabel.textColor = kTextColorGray;
        _sysTipLabel.textAlignment = NSTextAlignmentCenter;
        [_sysTipBg addSubview:_sysTipLabel];
        
        
        _voiceStatusTips = [[UILabel alloc] initWithFrame:CGRectZero];
        _voiceStatusTips.textColor = kTextColorGray;
        _voiceStatusTips.textAlignment = NSTextAlignmentCenter;
        _voiceStatusTips.font = [UIFont systemFontOfSize:12.0f ];
        _voiceStatusTips.clipsToBounds = YES;
        //        showTime.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_voiceStatusTips];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutWithModel:(JYChatModel *)model
{
    [self setChatModel:model];
    myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    isShowNick = [[JYShareData sharedInstance].groupChatIsShowNick boolValue];
    
    _groupUserNick.frame = CGRectZero;
    _groupImageUserNick.frame = CGRectZero;
    _groupAudioUserNick.frame = CGRectZero;
    _voiceStatusTips.frame = CGRectZero;
    //判断是否本地系统提示，这个数据只存在本地数据库中
    if ([self.chatModel.is_sys_tip intValue] == 1) {
        _avatarImage.frame = CGRectZero;
        showTime.frame = CGRectZero;
        //文本消息
        [_textBg setHidden:YES];
        [_audioBg setHidden:YES];
        [_imageBg setHidden:YES];
        [_sysTipBg setHidden:NO];
        [self layoutSysTip];
    }else{
    
        //判断如果sendstatus = 1正在发送，且发送时间大于30秒，当没有发送成功处理
        if ([self.chatModel.sendStatus intValue] == 1 && [[NSDate date] timeIntervalSince1970] - [self.chatModel.time integerValue] > 30) {
            self.chatModel.sendStatus = 0;
        }
      
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:self.chatModel.avatar]];
        //如果要显示时间，头像向下加20
        NSInteger avatarTop = 10;
        if(![JYHelpers isEmptyOfString:self.chatModel.showSendTime]){
            showTime.frame = CGRectMake((kScreenWidth - 100)/2, 0, 100, 20);
            showTime.text = self.chatModel.showSendTime;
            avatarTop = 30;
        }else{
            showTime.frame = CGRectZero;
        }
        
        //是否显示底部，播放状态拦,先置位
        _voiceStatusTips.frame = CGRectZero;
        
        _groupUserNick.text = self.chatModel.nick;
        _groupImageUserNick.text = self.chatModel.nick;
        _groupAudioUserNick.text = self.chatModel.nick;
        
        switch ([self.chatModel.sendType integerValue]) {
            case 2:
            {
                //发送的消息
                [_avatarImage setFrame:CGRectMake(kScreenWidth-10-40, avatarTop, 40, 40)];
                _avatarImage.tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] integerValue];
                
            }
                break;
            default:
            {
                //接收的消息
                [_avatarImage setFrame:CGRectMake(10, avatarTop, 40, 40)];
                _avatarImage.tag = [self.chatModel.fromUid integerValue];
            }
                break;
        }
        
        switch ([self.chatModel.msgType integerValue]) {
            case 0:
            case 1:
            {
                //文本消息
                [_textBg setHidden:NO];
                [_audioBg setHidden:YES];
                [_imageBg setHidden:YES];
                [_sysTipBg setHidden:YES];
                [self layoutText];
            }
                break;
            case 2:
            case 4:
            {
                //语音消息
                [_textBg setHidden:YES];
                [_audioBg setHidden:NO];
                [_imageBg setHidden:YES];
                [_sysTipBg setHidden:YES];
                [self layoutAudio];
            }
                break;
            case 3:
            case 5:
            {
                //图片消息
                [_textBg setHidden:YES];
                [_audioBg setHidden:YES];
                [_imageBg setHidden:NO];
                [_sysTipBg setHidden:YES];
                [self layoutImage];
            }
                break;
            default:
                break;
        }
    }
    
}

- (void) activityAndFailureShowOrHide:(UIImageView *)uiiv{
    int sendTimeHeight = 0;
    if (![JYHelpers isEmptyOfString:self.chatModel.showSendTime] ) {
        sendTimeHeight = 20;
    }
    //加载圈和发送失败的感叹号
    if ([self.chatModel.sendStatus integerValue] == 0) {
        
        [_textSendFailView setHidden:NO];
        if ([self.chatModel.sendType integerValue] == 2) {
            
            [_textSendFailView setOrigin:CGPointMake(uiiv.left-5-23/2, sendTimeHeight +15)];
        } else {
            [_textSendFailView setOrigin:CGPointMake(uiiv.right+5+23/2, sendTimeHeight+15)];
        }
        [_textActivity stopAnimating];
        [_textActivity setHidden:YES];
    } else if ([self.chatModel.sendStatus integerValue] == 1) {
        
        [_textActivity setHidden:NO];
        [_textActivity startAnimating];
        if ([self.chatModel.sendType integerValue] == 2) {
            
            [_textActivity setOrigin:CGPointMake(uiiv.left-5-23/2, sendTimeHeight +15)];
        } else {
            
            [_textActivity setOrigin:CGPointMake(uiiv.right+5+23/2, sendTimeHeight +15)];
        }
        
        [_textSendFailView setHidden:YES];
    } else {
       
        [_textActivity stopAnimating];
        [_textActivity setHidden:YES];
        [_textSendFailView setHidden:YES];
    }
}

- (void)layoutText
{
    //消息Lab
//    CGSize chatMsgSize = [self.chatModel.chatMsg sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(kScreenWidth-10-40-10-10-30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [_msgLab.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    JYCoreTextView * _mgsLabCoreText = [[JYCoreTextView alloc] initWithFrame:CGRectZero];
    [_mgsLabCoreText setMaxWidth:(kScreenWidth-10-40-10-10-30)];
    _msgLab.userInteractionEnabled = YES;
    _msgLab.clipsToBounds = YES;
    self.chatModel.chatMsg = [self.chatModel.chatMsg stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    //如果存在链接的情况，要加上链接点击
    NSRange yxrange = [self.chatModel.chatMsg rangeOfString:YX_HOST];
    if (yxrange.length > 0) { //存在友寻链接
        NSMutableArray *IDS = [NSMutableArray array];
        NSMutableArray *IDRanges = [NSMutableArray array];
        NSString *myLink = [self.chatModel.chatMsg substringFromIndex:yxrange.location];
        NSArray * linkArr = [myLink componentsSeparatedByString:@"="];
        [IDS addObject:[linkArr lastObject]];
        [IDRanges addObject:[NSValue valueWithRange:[self.chatModel.chatMsg rangeOfString:myLink]] ];
        _mgsLabCoreText.IDs = IDS;
        _mgsLabCoreText.IDRanges = IDRanges;
    }
    
    if ([self.chatModel.sendType integerValue] == 2) {
        [_mgsLabCoreText setTextColor:kTextColorWhite];
        _mgsLabCoreText.IDColor = kTextColorWhite;
    }else{
        [_mgsLabCoreText setTextColor:kTextColorGray];
    }

    [_mgsLabCoreText layoutWithContent:self.chatModel.chatMsg];
    CGSize nickwh = [JYHelpers getTextWidthAndHeight:self.chatModel.nick fontSize:14];
    switch ([self.chatModel.sendType integerValue]) {
        case 2:
        {
            //发送的消息
            [_msgLab setFrame:CGRectMake(10, 10, _mgsLabCoreText.width, _mgsLabCoreText.height)];
            [_mgsLabCoreText setFrame:CGRectMake(0, 0, _mgsLabCoreText.width, _mgsLabCoreText.height)];
            
        }
            break;
        default:
        {
            
            //接收的消息
            [_msgLab setFrame:CGRectMake(20, 10, _mgsLabCoreText.width, _mgsLabCoreText.height)];
            [_mgsLabCoreText setFrame:CGRectMake(0, 0, _mgsLabCoreText.width, _mgsLabCoreText.height)];
        }
            break;
    }
    [_msgLab addSubview:_mgsLabCoreText];
    _mgsLabCoreText.IDsClickHandler = ^(JYCoreTextView *feedView, NSString *IDs, NSRange IDRange){
        if (![JYHelpers isEmptyOfString:IDs]) {
         
            [[NSNotificationCenter defaultCenter] postNotificationName:kChatCellClickShareNotification object:nil userInfo:@{@"uid":IDs}];
        }
        
    };
//    [_msgLab setText:self.chatModel.chatMsg];
    
    NSInteger bubbleTopPosition = 0;
    _groupUserNick.hidden = YES;
    NSLog(@"%@-----%@",myuid, self.chatModel.fromUid);
    if ([self.chatModel.groupId integerValue] > 0 && !isShowNick && (![JYHelpers isEmptyOfString:self.chatModel.fromUid] && ![myuid isEqualToString:self.chatModel.fromUid])  ) {
        bubbleTopPosition = 20;
        _groupUserNick.hidden = NO;
    }
    //气泡
    switch ([self.chatModel.sendType integerValue]) {
        case 2:
        {
            //发送的消息
            UIImage *sendImage = [[UIImage imageNamed:@"msg_send_bubble.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [_bubbleBgImage setFrame:CGRectMake(kScreenWidth-10-_avatarImage.width-10-_msgLab.width-30-10, bubbleTopPosition, _msgLab.width+30, _msgLab.height+20)];
            [_bubbleBgImage setImage:sendImage];
            [_textBg setFrame:CGRectMake(10, _avatarImage.top, kScreenWidth-10-_avatarImage.width-10-10, _bubbleBgImage.height+bubbleTopPosition)];
            _groupUserNick.frame = CGRectMake(_bubbleBgImage.right - nickwh.width, 0, nickwh.width, 20);

        }
            break;
        default:
        {
            //接收的消息
            UIImage *receiveImage = [[UIImage imageNamed:@"msg_receive_bubble.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [_bubbleBgImage setFrame:CGRectMake(0, bubbleTopPosition, _msgLab.width+30, _msgLab.height+20)];
            [_bubbleBgImage setImage:receiveImage];
            [_textBg setFrame:CGRectMake(_avatarImage.right+10, _avatarImage.top, kScreenWidth-10-_avatarImage.width-10-10, _bubbleBgImage.height+bubbleTopPosition)];
            _groupUserNick.frame = CGRectMake(_bubbleBgImage.left , 0, nickwh.width, 20);
        }
            break;
    }
    
    [self activityAndFailureShowOrHide:_bubbleBgImage];
    
    //如果要显示时间，高加20
    if(![JYHelpers isEmptyOfString:self.chatModel.showSendTime]){
        [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, _textBg.height+40)];
    }else{
        [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, _textBg.height+20)];
    }
    
}

- (void)layoutImage
{
    
    int dHeight = 0;
    int dWidth = 0;
    
    //调整显示的位置
    NSLog(@"fileurl:%@",self.chatModel.fileUrl);
    if (![self.chatModel.fileUrl hasPrefix:@"http://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.chatModel.fileUrl];
        [_imageMsgImage setImage:[[UIImage alloc] initWithContentsOfFile:filePath]];
        UIImage *tImage = [UIImage imageWithData:self.chatModel.fileData];
        NSArray *returnWH = [JYHelpers ratioWidthAndHeight:tImage.size.height sWidth:tImage.size.width dHeight:200 dWidth:200];
        dHeight = [returnWH[0] intValue]/2;
        dWidth = [returnWH[1] intValue]/2;
    } else {
        [_imageMsgImage sd_setImageWithURL:[NSURL URLWithString:self.chatModel.fileUrl]];
        NSArray  * tempArray= [self.chatModel.fileUrl componentsSeparatedByString:@"="];
        if(tempArray.count >= 2){
            NSArray *imgWH = [[tempArray objectAtIndex:tempArray.count -1] componentsSeparatedByString:@"x"];
            NSArray *returnWH = [JYHelpers ratioWidthAndHeight:[imgWH[1] floatValue] sWidth:[imgWH[0] floatValue] dHeight:200 dWidth:200];
            dWidth = [returnWH[1] intValue]/2;
            dHeight = [returnWH[0] intValue]/2;
        }
    }
    
    
    if (dHeight == 0 ) {
        dHeight = 100;
    }
    if (dWidth == 0 ) {
        dWidth = 100;
    }
    CGSize nickwh = [JYHelpers getTextWidthAndHeight:self.chatModel.nick fontSize:14];
    NSInteger bubbleTopPosition = 0;
    _groupImageUserNick.hidden = YES;
    if ([self.chatModel.groupId integerValue] > 0 && !isShowNick && (![JYHelpers isEmptyOfString:self.chatModel.fromUid] && ![myuid isEqualToString:self.chatModel.fromUid])) {
        bubbleTopPosition = 20;
        _groupImageUserNick.hidden = NO;
    }
    switch ([self.chatModel.sendType integerValue]) {
        case 2:
        {
            
            //发送的消息
            [_imageBg setFrame:CGRectMake(10, _avatarImage.top, kScreenWidth-10-_avatarImage.width-10-10, 10+dHeight+bubbleTopPosition)];
            [_imageMsgImage setFrame:CGRectMake(kScreenWidth-10-_avatarImage.width-10-dWidth-22 , 5+bubbleTopPosition, dWidth, dHeight)];
            UIImage *sendImage = [[UIImage imageNamed:@"msg_send_bubble.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [_imageBubbleBgImage setFrame:CGRectMake(_imageMsgImage.left - 5, bubbleTopPosition, _imageMsgImage.width+17, _imageMsgImage.height+10)];
            [_imageBubbleBgImage setImage:sendImage];
            _groupImageUserNick.frame = CGRectMake(_imageBubbleBgImage.right - nickwh.width, 0, nickwh.width, 20);
        }
            break;
        default:
        {
            //接收的消息
            [_imageBg setFrame:CGRectMake(_avatarImage.right+10, _avatarImage.top, kScreenWidth-10-_avatarImage.width-10-10, 10+dHeight+bubbleTopPosition)];
            [_imageMsgImage setFrame:CGRectMake(12, 5+bubbleTopPosition, dWidth, dHeight)];
            UIImage *receiveImage = [[UIImage imageNamed:@"msg_receive_bubble.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [_imageBubbleBgImage setFrame:CGRectMake(0, bubbleTopPosition, _imageMsgImage.width+17, _imageMsgImage.height+10)];
            [_imageBubbleBgImage setImage:receiveImage];
            _groupImageUserNick.frame = CGRectMake(_imageBubbleBgImage.left, 0, nickwh.width, 20);
        }
            break;
    }
    
    [self activityAndFailureShowOrHide:_imageMsgImage];
    
    
    //如果要显示时间，高加20
    if(![JYHelpers isEmptyOfString:self.chatModel.showSendTime]){
        [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, _imageBg.height+40)];
    }else{
        [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, _imageBg.height+20)];
    }

}

- (void)layoutAudio
{
    CGFloat fBaseLength = 80.0f;
    CGFloat fTimes = 4.0f;
    CGFloat fVoiceLength = [self.chatModel.voiceLength doubleValue];
    fVoiceLength = fVoiceLength<40.0f?fVoiceLength:40.0f;
    CGSize nickwh = [JYHelpers getTextWidthAndHeight:self.chatModel.nick fontSize:14];
    NSInteger bubbleTopPosition = 0;
    
    if ([self.chatModel.groupId integerValue] > 0 && !isShowNick && (![JYHelpers isEmptyOfString:self.chatModel.fromUid] && ![myuid isEqualToString:self.chatModel.fromUid])) {
        bubbleTopPosition = 20;
        _groupAudioUserNick.hidden = NO;
    }
    _msgVoiceUnread.hidden = YES;
    switch ([self.chatModel.sendType integerValue]) {
        case 2:
        {
            //发送的消息
            UIImage *sendImage = [[UIImage imageNamed:@"msg_send_bubble.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 20)];
            [_audioBubbleImage setFrame:CGRectMake(0, bubbleTopPosition, fBaseLength+fTimes*fVoiceLength, 36)];
            [_audioBubbleImage setOrigin:CGPointMake(kScreenWidth-10-_avatarImage.width-10-_audioBubbleImage.width-10, bubbleTopPosition)];
            [_audioBubbleImage setImage:sendImage];
            
            
            [_audioIcon setOrigin:CGPointMake(_audioBubbleImage.right-20-_audioIcon.width, 10+bubbleTopPosition)];
            [_audioIcon setImage:[UIImage imageNamed:@"imessge_icn_zhengzaibofang_right3.png"]];
            NSArray *images = @[[UIImage imageNamed:@"imessge_icn_zhengzaibofang_right1"], [UIImage imageNamed:@"imessge_icn_zhengzaibofang_right2"], [UIImage imageNamed:@"imessge_icn_zhengzaibofang_right3"]];
            _audioIcon.animationDuration = 1;
            _audioIcon.animationImages = images;
            _audioIcon.animationRepeatCount = 0;
            
            [_secondsLab setOrigin:CGPointMake(_audioIcon.left-_secondsLab.width, 8+bubbleTopPosition)];
            [_secondsLab setTextColor:kTextColorWhite];
            [_secondsLab setText:[NSString stringWithFormat:@"%@\"", self.chatModel.voiceLength]];
            
            [_audioBg setFrame:CGRectMake(10, _avatarImage.top, kScreenWidth-10-_avatarImage.width-10-10, _audioBubbleImage.height+bubbleTopPosition)];
            _groupAudioUserNick.frame = CGRectMake(_audioBubbleImage.right - nickwh.width, 0, nickwh.width, 20);
        }
            break;
        default:
        {
            //接收的消息
            UIImage *receiveImage = [[UIImage imageNamed:@"msg_receive_bubble.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 20, 12, 12)];
            [_audioBubbleImage setFrame:CGRectMake(0, bubbleTopPosition, fBaseLength+fTimes*fVoiceLength, 36)];
            [_audioBubbleImage setImage:receiveImage];
            
            if ([_chatModel.readStatus  intValue] == 0) {
                _msgVoiceUnread.frame = CGRectMake(_audioBubbleImage.right + 10, _audioBubbleImage.top + 5, 5, 5);
                _msgVoiceUnread.hidden = NO;
            }
            
            
            [_audioIcon setOrigin:CGPointMake(_audioBubbleImage.left+20, 10+bubbleTopPosition)];
            [_audioIcon setImage:[UIImage imageNamed:@"imessge_icn_zhengzaibofang_left3.png"]];
            NSArray *images = @[[UIImage imageNamed:@"imessge_icn_zhengzaibofang_left1"], [UIImage imageNamed:@"imessge_icn_zhengzaibofang_left2"], [UIImage imageNamed:@"imessge_icn_zhengzaibofang_left3"]];
            _audioIcon.animationDuration = 1;
            _audioIcon.animationImages = images;
            _audioIcon.animationRepeatCount = 0;
            
            [_secondsLab setOrigin:CGPointMake(_audioIcon.right, 8+bubbleTopPosition)];
            [_secondsLab setTextColor:kTextColorBlack];
            [_secondsLab setText:[NSString stringWithFormat:@"%@\"", self.chatModel.voiceLength]];
            
            [_audioBg setFrame:CGRectMake(_avatarImage.right+10, _avatarImage.top, kScreenWidth-10-_avatarImage.width-10-10, _audioBubbleImage.height + bubbleTopPosition)];
            _groupAudioUserNick.frame = CGRectMake(_audioBubbleImage.left, 0, nickwh.width, 20);
        }
            break;
    }
    
    //判断是否要显示文字
    
    if (self.chatModel.voiceShowPlayStatus) { //
        
        _voiceStatusTips.frame = CGRectMake(0, _audioBg.bottom + 5, kScreenWidth, 20);
        if ([[JYShareData sharedInstance].voiceSpeakerOrHeadphone intValue] == 0) {
            _voiceStatusTips.text = @"当前是扬声器模式";
        }else{
            _voiceStatusTips.text = @"当前是听筒模式";
        }
        _audioBg.height += 15;
    }
    
    [self activityAndFailureShowOrHide:_audioBubbleImage];
    
  
    //如果要显示时间，高加20
    if(![JYHelpers isEmptyOfString:self.chatModel.showSendTime]){
        [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, _audioBg.height+40)];
    }else{
        [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, _audioBg.height+20)];
    }
}

- (void)layoutSysTip{
    NSLog(@"test content!!!!");
//    _sysTipLabel
    CGSize wh = [JYHelpers getTextWidthAndHeight:self.chatModel.chatMsg fontSize:12 uiWidth:self.width];
    _sysTipLabel.text = self.chatModel.chatMsg;
    _sysTipBg.height = wh.height*2;
    _sysTipLabel.frame = CGRectMake(0, (_sysTipBg.height-wh.height)/2, self.width, wh.height);
     [self setFrame:CGRectMake(self.origin.x, self.origin.y, self.width, wh.height*2)];
}

- (void)audioBubbleImageTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"播放语音");
    if (self.chatModel.isPlayying) { //正在播放，则停止播放
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kStopPlayAudioNotiNotification object:nil userInfo:nil];
    }else{
        self.chatModel.readStatus = @"1";
        if (self.chatModel.isGroup) {
            [[JYChatDataBase sharedInstance] updateGourpVoiceChatMsgReadStatus:self.chatModel.iid readStatus:@"1"];
        }else{
            [[JYChatDataBase sharedInstance] updateVoiceChatMsgReadStatus:self.chatModel.iid readStatus:@"1"];
        }
        _msgVoiceUnread.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kChatAudioTapNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self.chatModel forKey:@"model"]];
    }
    
}

- (void)startPlayAudio
{
    self.chatModel.isPlayying= YES;
    [_audioIcon startAnimating];
}

- (void)stopPlayAudio
{
    self.chatModel.isPlayying = NO;
    [_audioIcon stopAnimating];
}

- (void)_avatarClickGes:(UIGestureRecognizer *)gesture{
    NSString * myuidc = [NSString stringWithFormat:@"%ld",(long)gesture.view.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChatCellClickAvatarNotification object:self userInfo:@{@"uid":myuidc}];
    
}

//长按手势实别
- (void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)recognizer{
    
    //如果键盘被唤起时，没有响应操作
    if ([JYShareData sharedInstance].showOrHiddenKeyboard) {
        return;
    }
    
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.chatModel.iid,@"iid",ToString(self.chatModel.chatMsg),@"content",nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kContentVoiceViewClickedNotification object:nil userInfo:dictionary];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        
        NSLog(@"---%@",self.chatModel.msgType);
        //只有text才有复制
        if([self.chatModel.msgType intValue] == 0 || [self.chatModel.msgType intValue] == 1){
            UIMenuItem *mycopy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(mycopy:)];
            
//            UIMenuItem *del = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(del:)];
            [menu setMenuItems:[NSArray arrayWithObjects:mycopy, nil]];
        }else if([self.chatModel.msgType intValue] == 2 || [self.chatModel.msgType intValue] == 4) {
            if ([[JYShareData sharedInstance].voiceSpeakerOrHeadphone intValue] == 0) {
                UIMenuItem *headphone = [[UIMenuItem alloc] initWithTitle:@"听筒模式"action:@selector(headphone:)];
                [menu setMenuItems:[NSArray arrayWithObjects:headphone, nil]];
            }else{
                UIMenuItem *speaker = [[UIMenuItem alloc] initWithTitle:@"扬声器模式"action:@selector(speaker:)];
                [menu setMenuItems:[NSArray arrayWithObjects:speaker, nil]];
            }
            
        }
        
        //计算要显示的位置,文字，图片及语音要分开计算
        if ([self.chatModel.msgType intValue] <= 1) {
            [menu setTargetRect:CGRectMake((_textBg.left + _bubbleBgImage.left+ _bubbleBgImage.width/2),self.top+_textBg.top+10,0,0) inView:self.superview];
        }else if ([self.chatModel.msgType intValue] ==3 || [self.chatModel.msgType intValue] ==5){
            [menu setTargetRect:CGRectMake((_imageBg.left+ _imageBubbleBgImage.left +_imageBubbleBgImage.width/2),self.top+ _imageBg.top+10,0,0) inView:self.superview];
        }else{
            [menu setTargetRect:CGRectMake((_audioBg.left+ _audioBubbleImage.left +_audioBubbleImage.width/2),self.top+_audioBg.top +10,0,0) inView:self.superview];
        }
        
        
        //[popMenu setTargetRect:CGRectMake(162,195,0,0) inView:self.dialView];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

//"反馈"关心的功能
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
//    if (action == @selector(mycopy:) || action == @selector(del:) ||
//        action == @selector(backlist:) ) {
//        return YES;
//    }
    if (action == @selector(mycopy:) || action == @selector(del:) || action == @selector(speaker:) || action == @selector(headphone:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

//复制当前聊天信息
- (void)mycopy:(id)sender {
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.chatModel.chatMsg;
    
}

//删除自已的一条聊天信息
- (void)del:(id)sender {
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:ToString( self.chatModel.iid),@"iid",ToString(self.chatModel.chatMsg),@"content",self.chatModel.msgType,@"type",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteOneChatLogUpdateLocationData" object:nil userInfo:dictionary];
}

//使用扬声器模式
- (void)speaker:(id)sender {
    [JYShareData sharedInstance].voiceSpeakerOrHeadphone = @"0";
    [self saveVoicePlayStatus:@"0"];
}


//使用听筒模式
- (void)headphone:(id)sender {
    [JYShareData sharedInstance].voiceSpeakerOrHeadphone = @"1";
    [self saveVoicePlayStatus:@"1"];
}


- (void)saveVoicePlayStatus:(NSString *)speakerOrHeadphone{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChatTableViewRefreshUiNotification object:nil];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"profile" forKey:@"mod"];
    [parametersDict setObject:@"set_user_voice_switch" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:speakerOrHeadphone forKey:@"switch"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
    } failure:^(id error) {
    }];
}

//查看照片
- (void) browserThisPhotoClick:(UITapGestureRecognizer *)gesture{
    CPPhotoBrowser *browser = [[CPPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = _imageBg;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.imageCount = 1; // 图片总数
    browser.shareContent = [NSString stringWithFormat:@"来自%@的友寻相册",self.chatModel.nick];
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
    
}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(CPPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return _imageMsgImage.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(CPPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString * urlStr = [self.chatModel.ext objectForKey:@"pic0"] ;
    return [NSURL URLWithString:urlStr];
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(CPPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    
    NSString * urlStr = [self.chatModel.ext objectForKey:@"pid"] ;
    return urlStr;
}

- (void) _failureButtonClickGes:(UIGestureRecognizer *)ges{
    [[NSNotificationCenter defaultCenter] postNotificationName:kChatLogFailureResendNotification object:self.chatModel userInfo:nil];
}
//点击加入黑名单
//- (void)backlist:(id)sender {
//    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:ToString( self.chatModel.oid),@"oid",nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"addOneUserToBlackList" object:nil userInfo:dictionary];
//}

@end
