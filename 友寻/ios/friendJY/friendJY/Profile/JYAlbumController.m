//
//  AZXGroupImagesController.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-11.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYHttpServeice.h"
#import "JYAlbumController.h"
#import "JYAlbumCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JYAppDelegate.h"
#import "JYNavigationController.h"
#import "JYLocalImageModel.h"
#import "JYProfileData.h"
#import "JYPhotoController.h"
#import "UIView+ViewController.h"
#import "SDPhotoBrowser.h"
#import "JYShareData.h"

@interface JYAlbumController ()<SDPhotoBrowserDelegate>
//{
//    int _uploadedPhotoCompleteCount; //上传图片的数，最多为4张
//}
{
    NSString *lastPid;
    NSString *pid;
    BOOL isEdit;
    UILabel *noPhotoedLabel;
    BOOL collectionViewReachEnd;
}
@end

@implementation JYAlbumController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"相册"];
        _showImagesArrs = [NSMutableArray array];
        pid = @"0";
        lastPid = @"0";
        isEdit = NO;
        collectionViewReachEnd = NO;
    }
    return self;
}
- (void)backAction{
    if (isEdit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
    }
    [super backAction];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([_show_uid intValue] <1) {
        [JYHelpers showAlertWithTitle:@"用户uid不正确"];
        return;
    }
    //上传
//    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [uploadBtn setFrame:CGRectMake(0, 0, 60, 44)];
//    [uploadBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
//    [uploadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
//    [uploadBtn addTarget:self action:@selector(uploadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *uploadBarButton = [[UIBarButtonItem alloc] initWithCustomView:uploadBtn];
//    [self.navigationItem setRightBarButtonItem:uploadBarButton];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight) collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[JYAlbumCell class] forCellWithReuseIdentifier:@"JYAlbumCell"];
    [self.view addSubview:_collectionView];
    
    [self layoutNoPhotoedBackground];
    [self requestLoadPhotosWithPid:pid];

}
- (void)layoutNoPhotoedBackground{
    
    noPhotoedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight - kNavigationBarHeight - kStatusBarHeight -kTabBarViewHeight - 20)/2, kScreenWidth , 20)];
    [noPhotoedLabel setText:@"暂无照片"];
    [noPhotoedLabel setTextColor:kTextColorGray];
    [noPhotoedLabel setFont:[UIFont systemFontOfSize:14]];
    [noPhotoedLabel setTextAlignment:NSTextAlignmentCenter];
    [noPhotoedLabel setHidden:YES];
    [self.view addSubview:noPhotoedLabel];

}
- (void)requestLoadPhotosWithPid:(NSString*)loadPid{
//http://c.friendly.dev/cmiajax/?mod=photo&func=get_photo_list&pageSize=32&uid=2166450&pid=340350
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"photo",
                              @"func":@"get_photo_list"
                              };
    NSMutableDictionary *postDic = [NSMutableDictionary dictionaryWithDictionary:@{
                              @"pageSize":@"32",
                              @"pid":loadPid,
                              @"uid":_show_uid
                              }];
    if (_isLimited) {//限制的话只显示5张
        [postDic setObject:@"5" forKey:@"pageSize"];
    }
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            //do any addtion here...
            NSArray *tempShowImagesArrs = [responseObject objectForKey:@"data"];
            if([tempShowImagesArrs isKindOfClass:[NSArray class]]){
                if (tempShowImagesArrs.count > 0) { //将返回的数据，转为model的存储格式
                    for (NSDictionary *t_model in tempShowImagesArrs) {
            
                        [_showImagesArrs  addObject:[[JYAlbumModel alloc] initWithDataDic:t_model]];
                    }
                    JYAlbumModel *album = (JYAlbumModel*)[_showImagesArrs lastObject];
                    if (album) {
                        lastPid = pid;
                        pid = album.pid;
                    }
//                    if (_isLimited && _showImagesArrs.count > 5) {
//                        //限制的话只显示5张
//                        [_showImagesArrs removeObjectsInRange:NSMakeRange(5, _showImagesArrs.count - 5)];
//                    }
                    [_collectionView reloadData];
                }else{
                    if ([pid isEqualToString:@"0"]) {
                        [noPhotoedLabel setHidden:false];
                        [_collectionView setBackgroundColor:[UIColor clearColor]];
                    }else{
                        [[JYAppDelegate sharedAppDelegate] showTip:@"没有更多数据了"];
                    }
                }
            
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)uploadBtnClick:(UIButton *)btn
//{
//    NSLog(@"上传");
//    [self _initActionSheetView];
//    _uploadedPhotoCompleteCount = 0;
//    _tempImagesArrs = nil;
//    _tempImagesArrs = [NSMutableArray array];
//}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _showImagesArrs.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

  
    JYAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYAlbumCell" forIndexPath:indexPath];
    if (cell == nil) {
        /*
         再也不用对cell进行空值判断，以做额外的初始化操作。
         Cell的一切初始化工作都由系统为我们做好了。
         我们只需要对cell进行一些赋值等操作即可
         */
    }
    
    JYAlbumModel *localImageModel = (JYAlbumModel *)[_showImagesArrs objectAtIndex:indexPath.row];
    [cell layoutWithModel:localImageModel];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [self clickSmallPicOnIndex:indexPath.row];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
   
    if(_isLimited){//如果限制了 不刷新
        return;
    }
    //首先每次取的是 32张图片，如果取到的图片有32张，说明图片可能还有。
    //然后是 总内容的高度 - scrollView的高度 = 当scrollView滑到最末尾时的偏移量
    //如果当前偏移量 > 当scrollView滑到最末尾时的偏移量 说明有下拉操作，执行刷新
    static NSInteger refreshCount = 0;
    if (_showImagesArrs.count >= 32 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.height)
    {
        NSLog(@"\n====================第%ld次刷新 pid=%@ =====================\n",(long)++refreshCount,pid);
        [self requestLoadPhotosWithPid:pid];
    
    }
}
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    //最后一张图片已经显示并且图片可能不止32张
//    NSLog(@"%ld",(long)indexPath.row);
//    if (indexPath.row == _showImagesArrs.count - 1 && _showImagesArrs.count >= 32) {
//        [self requestLoadPhotosWithPid:pid];
//    }
//}

//// 初始化
//- (void)_initActionSheetView
//{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
//    [sheet showInView:self.view];
//}


//#pragma mark - UIActionSheetDelegate
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//        {
//            // 相机拍摄 2.1
//            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
//            cameraPicker.delegate =self;
//            cameraPicker.allowsEditing =YES;
//            cameraPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:cameraPicker animated:YES completion:NULL];
//        }
//            break;
//        case 1:
//        {
//            // 从手机相册选择
//            [self _getLocalImages];
//            
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - UIImagePickerController delegate
//- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    // 3.1
////    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];
//    UIImage *originalImage= [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    //[_tempImagesArrs removeAllObjects];
//    
//    UIImage *newImg = [self fixOrientation:originalImage];
//    
//    [_tempImagesArrs addObject:newImg];
//        
//    // 上传生活照片请求
//    [self _requestUploadImages];
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

//// 上传生活照片
//- (void)_requestUploadImages
//{
//    
//    UIImage *image = nil;
//    if (_uploadedPhotoCompleteCount<_tempImagesArrs.count) {
//        image = ((JYLocalImageModel *)[_tempImagesArrs objectAtIndex:(_uploadedPhotoCompleteCount)]).fullScreenImage;
//        _uploadedPhotoCompleteCount++;
//    } else {
//        return;
//    }
//    
////    NSLog(@"fuck you!!!");
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"photo" forKey:@"mod"];
//    [parametersDict setObject:@"upload_photo" forKey:@"func"];
//    
//    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
//    [postDict setObject:_show_uid forKey:@"uid"];
//    
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:imageData forKey:@"upload"];
//    
//    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
//        
//        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//        
//        if (iRetcode == 1) {
//            
//            NSLog(@"上传成功");
//            [self _requestUploadImages];
//            //刷新ui ,待做
//            
//        } else {
//            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//        }
//        
//    } failure:^(id error) {
//        
//        NSLog(@"%@", error);
//        
//    }];
//}


//// 获取上传的照片
//- (void)_getLocalImages
//{
//    // 3.2
//    JYLocalImagesController *controller = [[JYLocalImagesController alloc] init];
//
//    controller.canUploadCount = 4;
//    JYNavigationController *naviController = [[JYNavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:naviController animated:YES completion:NULL];
//}

//// 旋转图片在上传
//- (UIImage *)fixOrientation:(UIImage * )imag
//{
//    // No-op if the orientation is already correct
//    if (imag.imageOrientation == UIImageOrientationUp) return imag;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (imag.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, imag.size.width, imag.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, imag.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:break;
//    }
//    
//    switch (imag.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, imag.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:break;
//    }
//    
//    CGContextRef ctx = CGBitmapContextCreate(NULL, imag.size.width, imag.size.height,
//                                             CGImageGetBitsPerComponent(imag.CGImage), 0,
//                                             CGImageGetColorSpace(imag.CGImage),
//                                             CGImageGetBitmapInfo(imag.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (imag.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.height,imag.size.width), imag.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.width,imag.size.height), imag.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}
//
//

- (void) clickSmallPicOnIndex:(NSInteger)index{
    
//    NSDictionary  *photoes = [profileDataDic objectForKey:@"photoes"];
//    NSInteger photoCount = photoes.count;
//    if (photoes.count>=4) { //不是自已看自已显示4张
//        photoCount = 4;
//    }
    
//    NSInteger imgIndex = gesture.view.tag -3000;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = _collectionView;// [self viewWithTag:gesture.view.tag]; // 原图的父控件
    browser.imageCount = _showImagesArrs.count; // 图片总数
    browser.currentImageIndex = (int)index;
    NSString *nick = [[[JYShareData sharedInstance] myself_profile_dict] objectForKey:@"nick"];
    [browser setShareContent:[NSString stringWithFormat:@"来自%@的友寻相册",nick]];
    
    if ([_show_uid isEqualToString:ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"])]) {
        [browser setFromSelf:YES];
    }else{
        [browser setFromSelf:NO];
    }
    browser.delegate = self;
    [browser show];
    
}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return ((JYAlbumCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]]).imageView.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
//    NSDictionary  *photoes = [profileDataDic objectForKey:@"photoes"];
//    NSArray *photoesValue = [photoes allValues];
    return [NSURL URLWithString:((JYAlbumModel*)[_showImagesArrs objectAtIndex:index]).pic800]; // 图片路径
}

//返回当前图片的pid
- (NSString *)photoBrowserId:(SDPhotoBrowser *)browser pidForIndex:(NSInteger)index{
    
//    NSDictionary  *photoes = [profileDataDic objectForKey:@"photoes"];
//    NSArray *photoesKey = [photoes allKeys];
    return ((JYAlbumModel*)[_showImagesArrs objectAtIndex:index]).pid;
}

- (void)photoBrowser:(SDPhotoBrowser *)browser didDeleteImage:(NSInteger)index{
    [browser setHidden:YES];
    isEdit = YES;
    [_showImagesArrs removeObjectAtIndex:index];
    [_collectionView reloadData];
    if (_showImagesArrs.count == 0) {
        [noPhotoedLabel setHidden:false];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
}
@end
