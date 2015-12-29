//
//  JYOpenRegisterController.h
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYSegmentedControl.h"
#import "JYPickEmotionStatusController.h"

@interface JYOpenRegisterController : JYBaseController<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, JYPickEmotionStatusDelegate>
{
    UIImageView *_avatarImage;
    JYBaseTextField *_nickTextField;
    JYSegmentedControl *_segmentedControl;
    UILabel *_emotionStatusLab;
    UITextField *_phoneNumberTextField;

    UITextField *_verCodeTextField;
    UIButton *_getCodeBtn;
    UILabel *_getCodeLab;
//    UIButton *_completeBtn;
    
    UIButton *_maleBtn;
    UIButton *_femaleBtn;
    
    NSInteger _emotionStatusIndex;
    NSInteger _currentGenderIndex;
    
    NSInteger _seconds;

}
@property (nonatomic, strong) NSDictionary *sourceDic;
@property (nonatomic, assign) LOGIN_TYPE loginType;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *token;


@end
