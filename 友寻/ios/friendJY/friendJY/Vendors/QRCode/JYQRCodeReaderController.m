//
//  JYQRCodeReaderController.m
//  QRcodeTest
//
//  Created by chenxiangjing on 15/6/9.
//  Copyright (c) 2015年 chenxiangjing. All rights reserved.
//

#import "JYQRCodeReaderController.h"
#import <AVFoundation/AVFoundation.h>
#import "JYMyQRCodeController.h"

@interface JYQRCodeReaderController()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    //定时器，负责扫描绿条的规律上下移动
    NSTimer *_timer;
    //扫描边框
    UIImageView *_imageView;
    //绿条
    UIImageView *_lineImageView;
}

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@property (nonatomic, strong) AVCaptureMetadataOutput *output;

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation JYQRCodeReaderController

- (void)viewDidLoad{

    [super viewDidLoad];
    [self.view setBackgroundColor:kTextColorBlack];
    
    [self layoutSubviews];
    [self performSelectorInBackground:@selector(setupCamera) withObject:nil];
//    [self setupCamera];
    
}
- (void)dealloc{
    
    NSLog(@"dealloc");
    
    _preview = nil;
    _timer = nil;
    _session = nil;
    _preview = nil;
    _device = nil;
    _delegate = nil;
    _input = nil;
    _output = nil;
    
}

- (void)layoutSubviews{

    [self setTitle:@"扫描二维码"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)]];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(kScreenWidth - 80, 44, 60, 20)];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button setTitleColor:kTextColorBlue forState:UIControlStateNormal];
//    [button setBackgroundColor:kTextColorWhite];
//    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg"]];
//    _imageView.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 140, self.view.bounds.size.height * 0.5 - 140, 280, 280);
    [_imageView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_imageView];
    
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220*kScreenWidth/320.0, 2)];
    [_lineImageView setCenter:CGPointMake(kScreenWidth/2, 285.0/2.0*kScreenHeight/568.0)];
    _lineImageView.image = [UIImage imageNamed:@"line"];
    [_imageView addSubview:_lineImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    [label setCenter:CGPointMake(kScreenWidth/2, (285.0/2.0 - 20)*kScreenHeight/568.0)];
    [label setText:@"将好友的友寻二维码放入框内，即可自动扫描"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(50, (285.0 + 440.0)/2.0*kScreenHeight/568.0 + 20, kScreenWidth - 100, 20)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"我的二维码" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [button addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
- (void)myQRCode{
    NSLog(@"myQRCode")
    JYMyQRCodeController *myQRCodeController = [[JYMyQRCodeController alloc] init];
    [self.navigationController pushViewController:myQRCodeController animated:YES];
}
- (void)setupCamera
{
//    NSLog(@"===timer-%@=========\n========device-%@=========\npreviewLayer-%@==========",_timer,_device,_preview);
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    

    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    
    // 条码类型 AVMetadataObjectTypeQRCode
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode] ;
//    
    
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    [self performSelectorOnMainThread:@selector(sessionStart) withObject:nil waitUntilDone:NO];
    
    
}
- (void)sessionStart{
    // Start
    [_session startRunning];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [_timer fire];
}
#pragma mark - Click handler
- (void)cancel{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    [_session stopRunning];
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if ([self.delegate respondsToSelector:@selector(qrCodeReaderDidReadContent:)]) {
            [self.delegate qrCodeReaderDidReadContent:stringValue];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能识别的二维码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新扫描",nil];
        [alertView show];
    }
    [_timer invalidate];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [_session startRunning];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }

}

- (void)animation
{
    

    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [_lineImageView setCenter:CGPointMake(kScreenWidth/2, (285.0 + 440)/2.0*kScreenHeight/568.0)];
//        _lineImageView.frame = CGRectMake(30, 260, 220, 2);
        
    } completion:^(BOOL finished) {
//        _lineImageView.frame = CGRectMake(30, 10, 220, 2);
        [_lineImageView setCenter:CGPointMake(kScreenWidth/2, 285.0/2.0*kScreenHeight/568.0)];

    }];
}

@end
