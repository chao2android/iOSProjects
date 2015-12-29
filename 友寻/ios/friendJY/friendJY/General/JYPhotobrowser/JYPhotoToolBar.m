//
//  AZXPhotoToolBar.m
//  imAZXiPhone
//
//  Created by coder_zhang on 14-8-4.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYPhotoToolBar.h"
#import "JYPhoto.h"
#import "MBProgressHUD+Add.h"
//#import "AZXUserPhotoModel.h"
//#import "AZXOthersUserPhotoModel.h"

#import "JYAppDelegate.h"
#import "JYHelpers.h"

@interface JYPhotoToolBar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
//    __weak ASIFormDataRequest *_requestPraisePhoto;
}
@end

@implementation JYPhotoToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praisePhotoSuccessNotify:) name:kProfilePraisePhotoSuccess object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praisePhotoSuccessNotify:) name:kRecommendProfilePraisePhotoSuccess object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praisePhotoSuccessNotify:) name:kNewsPraisePhotoSuccess object:nil];
    }
    return self;
}
- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfilePraisePhotoSuccess object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRecommendProfilePraisePhotoSuccess object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewsPraisePhotoSuccess object:nil];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(105, 10, 110, 20);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    //   赞按钮的底视图
//    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 0, 75, 35)];
    UIButton *baseView = [UIButton buttonWithType:UIButtonTypeCustom];
    baseView.frame = CGRectMake(kScreenWidth-100, 0, 75, 35);
    baseView.backgroundColor = [JYHelpers setFontColorWithString:@"#373737"];
    baseView.layer.cornerRadius = 3;
    [baseView addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    baseView.userInteractionEnabled = YES;
    [self addSubview:baseView];
    
    // 赞图片按钮
    CGFloat btnWidth = 35;//self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(0, 0, 75, btnWidth);
    _saveImageBtn.backgroundColor = [UIColor clearColor];
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"btn_chakandatu_dianzan.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"btn_chakandatu_yizan.png"] forState:UIControlStateSelected];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saveImageBtn];
    [baseView addSubview:_saveImageBtn];
    
    //   赞的数量
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 33, 17)];
    label.backgroundColor = [UIColor clearColor];
    label.tag = 501;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [JYHelpers setFontColorWithString:@"#ffffff"];
    label.text = @"0";
    [baseView addSubview:label];
    
    NSString *praseNumStr = [NSString stringWithFormat:@"%@", self.praseNumber];
    NSInteger praseValue = [praseNumStr integerValue];
    if (praseValue > 99) {
        label.text = @"99+";
    } else {
        label.text = praseNumStr;
    }
    
    // zhang
    NSString *praseStr = [NSString stringWithFormat:@"%@", self.is_prase];
    NSInteger prase = [praseStr integerValue];
    if (prase == 1) {
        _saveImageBtn.selected = YES;
        label.textColor = [JYHelpers setFontColorWithString:@"#e14f64"];
    } else {
        _saveImageBtn.selected = NO;
        label.textColor = [JYHelpers setFontColorWithString:@"#a1a1a1"];
    }

}

- (void)saveImage
{

    if (_isViewPhoto) {
        
        [self priseImage];
        
    } else {
        NSString *praseStr = [NSString stringWithFormat:@"%@", self.is_prase];
        NSInteger prase = [praseStr integerValue];
        if (prase == 1) {
            //        [[AZXAppDelegate sharedAppDelegate] showTip:@"你已经点过赞了哦"];
            
            return;
        } else {
            _saveImageBtn.enabled = NO;
            // 发送点赞的通知
            if (_is_profile) { // 是从别人的主页查看照片
                
                if (_is_recomendProfile) {
                   // [[NSNotificationCenter defaultCenter] postNotificationName:kRecommendPraiseDynamicNotify object:nil userInfo:_infoDic];
                } else {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"priseDynamicNotify" object:nil userInfo:_infoDic];
                }
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicPriseNotify" object:nil userInfo:_infoDic];
            }
        }
        
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        AZXPhoto *photo = _photos[_currentPhotoIndex];
//        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    if (error) {
//        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
//    } else {
//        AZXPhoto *photo = _photos[_currentPhotoIndex];
//        photo.save = YES;
//        _saveImageBtn.enabled = NO;
//        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
//    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    
//    AZXPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
    
    _saveImageBtn.selected = NO;
    _saveImageBtn.selected = NO;
    
   
}

#pragma mark - nsnotification
// 点赞成功
- (void)praisePhotoSuccessNotify:(NSNotification *)notify
{
    _saveImageBtn.enabled = YES;
    NSDictionary *params = notify.userInfo;
    NSInteger success = [params[@"praiseSuccess"] integerValue];
    if (success) {
        _saveImageBtn.selected = YES;
        
        self.is_prase = @"1";
        UILabel *label = (UILabel *)[self viewWithTag:501];
        label.textColor = [JYHelpers setFontColorWithString:@"#e14f64"];
        NSString *praseNumStr = [NSString stringWithFormat:@"%@", self.praseNumber];
        NSInteger praseValue = [praseNumStr integerValue];
        if (praseValue > 99) {
            label.text = @"99+";
            
        } else {
            label.text = [NSString stringWithFormat:@"%ld", praseValue + 1];
        }
    } else {
        
    }
}

- (void)priseImage
{
    NSLog(@"index %lu", _currentPhotoIndex);
    //
    /**
	 * @Title: add_focus
	 * @Description: 赞
     * @URL: http: //client.izhenxin.dev/cmiajax/?mod=snsfeed_ios&func=like_user_photo&oid=20442800&photoid=24842661
	 * @date 2014-9-10
	 */
    
//    AZXOthersUserPhotoModel *userPhotoModel = (AZXOthersUserPhotoModel *)self.imgModels[_currentPhotoIndex];
//    NSString *is_likeStr = [NSString stringWithFormat:@"%@", userPhotoModel.islike];
//    NSInteger is_like = [is_likeStr integerValue];
//    if (is_like) {
//        return;
//    }
    
//    NSString *photoId = self.photoIdArr[_currentPhotoIndex];
//    
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"snsfeed_ios" forKey:@"mod"];
//    [parametersDict setObject:@"like_user_photo" forKey:@"func"];
//    [parametersDict setObject:self.u_id forKey:@"oid"];
//    [parametersDict setObject:photoId forKey:@"photoid"];
//    __weak ASIFormDataRequest *_requestPraisePhoto;
//    _requestPraisePhoto = [ASIFormDataRequest requestWithURL:[AZXHttpServeice urlWithParametersDict:parametersDict]];
//    
//    _requestPraisePhoto = [AZXHttpServeice processWithRequest:_requestPraisePhoto formDict:nil];
//    [_requestPraisePhoto setCompletionBlock:^{
//        
//        id result = [NSJSONSerialization JSONObjectWithData:_requestPraisePhoto.responseData options:NSJSONReadingMutableContainers error:nil];
//        int retCodeValue = [[result objectForKey:@"retcode"] intValue];
//        if (retCodeValue == 1) {
//            
//            AZXOthersUserPhotoModel *userPhotoModel = (AZXOthersUserPhotoModel *)self.imgModels[_currentPhotoIndex];
//            userPhotoModel.islike = @"1";
//            userPhotoModel.likecount = [NSString stringWithFormat:@"%d", [userPhotoModel.likecount integerValue] + 1];
//            [self setCurrentPhotoIndex:_currentPhotoIndex];
//            
//            
//        } else if (retCodeValue == 0) {
//            [[AZXAppDelegate sharedAppDelegate] showTip:@"您的注册资料正在审核中"];
//        }
//        else {
//            NSString *retmeanStr = result[@"retmean"];
////            NSLog(@"retmeanStr :%@", retmeanStr);
//            [[AZXAppDelegate sharedAppDelegate] showTip:retmeanStr];
//        }
//    }];
//    
//    [_requestPraisePhoto setFailedBlock:^{
//        [[AZXAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//    }];
//    [_requestPraisePhoto startAsynchronous];
    
}

@end
