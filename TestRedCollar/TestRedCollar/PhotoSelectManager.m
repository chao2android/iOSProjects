//
//  PhotoSelectManager.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-5-30.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "PhotoSelectManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AutoAlertView.h"

@implementation PhotoSelectManager

@synthesize mRootCtrl, mDefaultName, delegate, OnPhotoSelect, mLocalPath, miWidth, miHeight, mbEdit,popoverController;

- (id)init {
    self = [super init];
    if (self) {
        mbEdit = YES;
        miWidth = 400;
        miHeight = 550;
        self.mDefaultName = @"fabuhuati.jpg";
    }
    return self;
}

- (void)dealloc {
    self.mRootCtrl = nil;
    self.mDefaultName = nil;
    [super dealloc];
}

- (BOOL)TakePhoto:(BOOL)bCamera
{
    if (!mRootCtrl) {
        return NO;
    }
    if (!bCamera && [UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        [AutoAlertView ShowAlert:@"提示" message:@"找不到相册"];
        return NO;
    }
    if (bCamera && [UIImagePickerController isSourceTypeAvailable:
                    UIImagePickerControllerSourceTypeCamera] == NO) {
        [AutoAlertView ShowAlert:@"提示" message:@"找不到摄像头"];
        return NO;
    }
    
    UIImagePickerController *imageCtrl = [[[UIImagePickerController alloc] init] autorelease];
    if (bCamera) {
		imageCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imageCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imageCtrl.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    imageCtrl.allowsEditing = mbEdit;
    imageCtrl.delegate = self;
    
    
    if (IsiPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imageCtrl];
         self.popoverController = popover;
        [self.popoverController presentPopoverFromRect:CGRectMake(200, 700, 60, 200) inView:mRootCtrl.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else{
        [mRootCtrl presentModalViewController:imageCtrl animated: YES];
    }
    
    return YES;
}

//图片缩放
- (UIImage *)scaleToSize:(UIImage *)image :(CGSize)newsize {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (NSString *)mLocalPath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:self.mDefaultName];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *) info {
    // 图片类型
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage* image = nil;
        if (mbEdit) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        int iWidth = image.size.width;
        int iHeight = image.size.height;
        if (iWidth>miWidth) {
            iWidth = miWidth;
            iHeight = image.size.height*iWidth/image.size.width;
            if (iHeight>miHeight) {
                iHeight = miHeight;
                iWidth = image.size.width*iHeight/image.size.height;
            }
        }
        
        NSString *imagename = self.mLocalPath;
        NSLog(@"%@",imagename);
        image = [self scaleToSize:image :CGSizeMake(iWidth, iHeight)];
        NSLog(@"%f, %f", image.size.width, image.size.height);
        NSData *data = UIImageJPEGRepresentation(image, 0.95);
        [data writeToFile:imagename atomically:YES];
        if (delegate && OnPhotoSelect) {
            [delegate performSelector:OnPhotoSelect withObject:self];
        }
    }
    [picker dismissModalViewControllerAnimated:YES];
    if (IsiPad) {
        [popoverController dismissPopoverAnimated:YES];
    }
}

@end
