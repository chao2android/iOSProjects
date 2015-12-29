//
//  JYRegisterInfoController.h
//  friendJY
//
//  Created by 高斌 on 15/3/3.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYSegmentedControl.h"
#import "JYPickEmotionStatusController.h"

@interface JYRegisterInfoController : JYBaseController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, JYPickEmotionStatusDelegate,UINavigationControllerDelegate>
{
    UIImageView *_avatarImage;
    UITextField *_nickTextField;
//    JYSegmentedControl *_segmentedControl;
    UILabel *_emotionStatusLab;
    NSInteger _emotionStatusIndex;
    NSInteger _currentGenderIndex;
    NSData *_avatarData;
    
    UIButton *_completeBtn;
    UIButton *_maleBtn;
    UIButton *_femaleBtn;
}

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *verificationCode;

@end
