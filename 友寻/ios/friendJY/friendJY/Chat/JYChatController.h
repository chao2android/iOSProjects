//
//  JYChatController.h
//  friendJY
//
//  Created by 高斌 on 15/3/20.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYBaseHeaderTableView.h"
#import "JYChatTableView.h"
#import "SpeechController.h"
#import "JYMessageModel.h"
#import "JYMyGroupModel.h"
#import "JYChatGetLocalPhoto.h"


@interface JYChatController : JYBaseController<HeaderTableViewDelegate, UITextViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SpeechControllerDelegate,JYChatGetLocalPhotoDelegate>
{
    NSDictionary *_currentUserInfoDict;
    
    JYChatTableView *_tableView;
    UIImageView *_inputBgImage;
    UIImageView *_inputTextViewBgImage;
    UITextView *_inputTextView;
    UIButton *_speakBtn;
    UILabel *_speakLab;
    UIButton *_faceBtn;
    UIButton *_sendImageBtn;
    UIButton *_mikeBtn;
    UIScrollView *_emojiBg;
    UIView *_sendImageBg;
//    NSInteger _pageIndex;
    UIImageView *_recordingBg;
    UILabel *_recordingSecondsLab;
    NSInteger _recordingSeconds;
    NSTimer *_recordingTimer;
    BOOL _isCancelSendRecord;
    CGFloat _tagPosition;
    UIPageControl *pageControl;
    UIView *_emojiView;
    UILabel *_inputTextViewLable;//这个label放在textview里面，只是为了实现texfeild中的placeholder功能
    UIButton * _faceSendBtn;
}
@property (nonatomic, strong) NSString *fromUid;
@property (nonatomic, assign) BOOL isGroupChat;
@property (nonatomic, strong) JYMyGroupModel *fromGroupModel;
@property (nonatomic, strong) JYMessageModel *fromMsgModel;
@property (nonatomic, strong) SpeechController *speech; //录音
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) NSMutableArray *globalShowData;
@property (nonatomic, strong) NSString * from ;//进入聊天的来源 2-从群组进入，3-从profile进入

@end
