//
//  JYQRCodeReaderController.h
//  QRcodeTest
//
//  Created by chenxiangjing on 15/6/9.
//  Copyright (c) 2015年 chenxiangjing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JYQRCodeReaderControllerDelegate <NSObject>
/**
 *  二维码扫描成功的回调方法
 *
 *  @param content 扫描结果
 */
- (void)qrCodeReaderDidReadContent:(NSString*)content;

@end

@interface JYQRCodeReaderController : UIViewController
/**
 *  扫描代理
 */
@property (nonatomic, assign) id<JYQRCodeReaderControllerDelegate>delegate;

@end
