//
//  ZYQAssetPickerController.m
//  ZYQAssetPickerControllerDemo
//
//  Created by Zhao Yiqi on 13-12-25.
//  Copyright (c) 2013年 heroims. All rights reserved.
//

#import "ZYQAssetPickerController.h"
#import "ZYQAssetViewController.h"
#import "ZYQGlobal.h"

@interface ZYQAssetPickerController ()

@end

@implementation ZYQAssetPickerController

- (id)init
{
    ZYQAssetViewController *groupViewController = [[ZYQAssetViewController alloc] init];
    self = [super initWithRootViewController:groupViewController];
    if (self) {
        self.navigationBarHidden = YES;
        _maximumNumberOfSelection      = 10;
        _minimumNumberOfSelection      = 0;
        _assetsFilter                  = [ALAssetsFilter allAssets];
        _showCancelButton              = YES;
        _showEmptyGroups               = NO;
        _selectionFilter               = [NSPredicate predicateWithValue:YES];
        _isFinishDismissViewController = YES;
        
        
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize=kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return YES;
}

@end
