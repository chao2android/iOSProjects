//
//  JYChatTableViewCell.h
//  friendJY
//
//  Created by 高斌 on 15/3/25.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYChatModel.h"
#import "JYCoreTextView.h"
#import "CPPhotoBrowser.h"

@interface JYChatTableViewCell : UITableViewCell<CPPhotoBrowserDelegate>
{
    UIImageView *_avatarImage;
    UIView *_textBg;
    UIView *_imageBg;
    UIView *_audioBg;
    UIView *_sysTipBg;
    
    UILabel * _sysTipLabel;
    UIImageView *_bubbleBgImage; //气泡
//    UILabel *_msgLab;
    UIView *_msgLab;
    UIActivityIndicatorView *_textActivity;
    UIImageView *_textSendFailView;
    UILabel * _groupUserNick; //显示群组用户昵称
    
    UIImageView *_imageMsgImage;
    UIActivityIndicatorView *_imageActivity;
    UIImageView *_imageSendFailView;
    UILabel * _groupImageUserNick; //显示群组图片用户昵称
    
    UIImageView *_audioBubbleImage; //语音气泡
    UIImageView *_audioIcon;
    UILabel *_secondsLab;
    UILabel * _groupAudioUserNick; //显示群组图片用户昵称
    
    UIActivityIndicatorView *_audioActivity;
    UIImageView *_audioSendFailView;
    UIImageView *_msgVoiceUnread;
    UIImageView *_imageBubbleBgImage; //图片气泡
    
    UILabel * _voiceStatusTips; //语音状态提示语
    
    UILabel * showTime ;
    
    UILongPressGestureRecognizer * textPressGestureRecognizer; //文本长按手势
    UILongPressGestureRecognizer * imagePressGestureRecognizer;//图片长按手势
    UILongPressGestureRecognizer * voicePressGestureRecognizer;//语音长按手势
    
    BOOL isShowNick;//是否显示群组聊天时昵称
    NSString * myuid; //我自已的uid
    
}

@property (nonatomic, strong) JYChatModel *chatModel;

- (void)layoutWithModel:(JYChatModel *)model;

- (void)startPlayAudio;

- (void)stopPlayAudio;

@end
