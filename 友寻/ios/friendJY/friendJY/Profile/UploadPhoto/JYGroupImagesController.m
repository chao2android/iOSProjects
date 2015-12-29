//
//  AZXGroupImagesController.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-11.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYGroupImagesController.h"
#import "JYGroupImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JYLocalImageModel.h"
#import "JYAppDelegate.h"
#import "JYGroupCameraCell.h"
#import "JYLocalImagesController.h"

@interface JYGroupImagesController ()
{
    UIScrollView *selectedImagesBg;
    NSMutableArray *imageArray;
}

@end

@implementation JYGroupImagesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"手机相册"];
        imageArray = [NSMutableArray array];
//        _imagesUrlArr = [NSMutableArray array];
        _selectedImagesArr = [[NSMutableArray alloc] init];
        _selectedImageViews = [[NSMutableArray alloc] init];
        _imagesArr = [[NSMutableArray alloc] init];//[[NSMutableArray alloc] initWithObjects:@"拍照", nil];
    }
    return self;
}

- (void)_clickRightTopButton{
    JYLocalImagesController *controller = [[JYLocalImagesController alloc] init];
    controller.canUploadCount = self.canUploadCount;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //右上角
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [navRightBtn setTitleColor: [JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [navRightBtn setTitle:@"相册" forState:UIControlStateNormal];
    //[navRightBtn setImage:[UIImage imageNamed:@"feedAddBtn"] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //[cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor: [JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [self.navigationItem setLeftBarButtonItem:cancelBarButton];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-68) collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[JYGroupImageCell class] forCellWithReuseIdentifier:@"JYGroupImageCell"];
    [_collectionView registerClass:[JYGroupCameraCell class] forCellWithReuseIdentifier:@"JYGroupCameraCell"];
    [self.view addSubview:_collectionView];
    
    //选中的图片
//    selectedImagesBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kScreenHeight-kStatusBarHeight-kNavigationBarHeight-68, 12+(50+11.5)*4, 68)];
    selectedImagesBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kScreenHeight-kStatusBarHeight-kNavigationBarHeight-68, kScreenWidth - 60, 68)];
    selectedImagesBg.delegate = self;
    [selectedImagesBg setBackgroundColor:[JYHelpers setFontColorWithString:@"#F2F2F2"]];
    //[selectedImagesBg setUserInteractionEnabled:YES];
    [selectedImagesBg setContentSize:CGSizeMake(12+(50+11.5)*_canUploadCount, 68)];
    //[selectedImagesBg setPagingEnabled:YES];
    selectedImagesBg.directionalLockEnabled = YES;
    [selectedImagesBg setShowsHorizontalScrollIndicator:NO];
    [selectedImagesBg setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:selectedImagesBg];
//    UIView *selectedImagesBg = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-68, kScreenWidth, 68)];
//    [selectedImagesBg setUserInteractionEnabled:YES];
//    [selectedImagesBg setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.8f]];
//    [self.view addSubview:selectedImagesBg];
    
    for (int i = 0; i<_canUploadCount; i++)
    {
        UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12+(50+11.5)*i, 9, 50, 50)];
        [selectedImageView setImage:[UIImage imageNamed:@"fabudongtai_zhaopianxuankuang.png"]];
        [selectedImagesBg addSubview:selectedImageView];
        [_selectedImageViews addObject:selectedImageView];
    }
    
    //确认
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmBtn setBackgroundColor:[AZXHelpers setFontColorWithString:@"#3588F0"]];
//    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"fabudongtai_btn_querenanniu.png"] forState:UIControlStateNormal];
    [confirmBtn setFrame:CGRectMake(selectedImagesBg.right, selectedImagesBg.top+9, 50, 50)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    //已选照片数
    _selectImageCountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, confirmBtn.width, 15)];
    [_selectImageCountLab setBackgroundColor:[UIColor clearColor]];
    [_selectImageCountLab setTextColor:[UIColor whiteColor]];
    [_selectImageCountLab setFont:[UIFont systemFontOfSize:13.0f]];
    [_selectImageCountLab setTextAlignment:NSTextAlignmentCenter];
    [_selectImageCountLab setText:[NSString stringWithFormat:@"0/%ld", _canUploadCount]];
    [confirmBtn addSubview:_selectImageCountLab];
    
    [[JYShareData sharedInstance] getLocalImageInfoWithFinishBlcok:^{
        [self reloadData];
    }];
}
- (void)reloadData{
    
    imageArray = [JYShareData sharedInstance].localImageArr;
    
    for (NSString *imageUrl in imageArray) {
        //        [self getImageWithUrl:imageUrl];
        [self getThumbnailImageWithUrl:imageUrl];
    }
    
    [self performSelector:@selector(ScrollViewToBottom) withObject:nil afterDelay:0.5];

}
- (void)ScrollViewToBottom{
    NSLog(@"----->%f",_collectionView.contentSize.height);
    if (_collectionView.contentSize.height>kScreenHeight-kStatusBarHeight-kNavigationBarHeight-68) {
        [_collectionView setContentOffset:CGPointMake(0, _collectionView.contentSize.height- (kScreenHeight-kStatusBarHeight-kNavigationBarHeight-68))];
    }
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

- (void)cancelBtnClick:(UIButton *)btn
{
    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmBtnClick:(UIButton *)btn
{
    if (_selectedImagesArr.count>0)
    {
        for (JYLocalImageModel *localImageModel in _selectedImagesArr)
        {
            [self getFullScreenImageWithLocalImageModel:localImageModel];
        }
    }
    
}

- (void)relayoutSelectedImages
{
    for (int i=0; i<_selectedImageViews.count; i++)
    {
        UIImageView *imageView = [_selectedImageViews objectAtIndex:i];
        
        if (i<_selectedImagesArr.count) {
            JYLocalImageModel *localImageModel = (JYLocalImageModel *)[_selectedImagesArr objectAtIndex:i];
            [imageView setImage:localImageModel.thumbnailImage];
        } else {
            [imageView setImage:[UIImage imageNamed:@"fabudongtai_zhaopianxuankuang.png"]];
        }
        if (_selectedImagesArr.count>4) {
            [selectedImagesBg setContentOffset:CGPointMake(12+(50+11.5)*(_selectedImagesArr.count-4),0) animated:YES];
        }else{
            [selectedImagesBg setContentOffset:CGPointMake(0,0) animated:YES];
        }
        
    }
}

- (void)getThumbnailImageWithUrl:(NSString *)imageUrl
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
//        UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
        UIImage *thumbnailImage = [UIImage imageWithCGImage:asset.thumbnail];
        JYLocalImageModel *localImageModel = [[JYLocalImageModel alloc] init];
        [localImageModel setImageUrl:imageUrl];
        [localImageModel setThumbnailImage:thumbnailImage];
        [_imagesArr addObject:localImageModel];
        [_collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}

//- (void)getFullScreenImageWithUrl:(NSString *)imageUrl
- (void)getFullScreenImageWithLocalImageModel:(JYLocalImageModel *)localImageModel
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *url = [NSURL URLWithString:localImageModel.imageUrl];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage]];
//        UIImage *thumbnailImage = [UIImage imageWithCGImage:asset.thumbnail];
        [localImageModel setFullScreenImage:fullScreenImage];
        
        for (JYLocalImageModel *imageModel in _selectedImagesArr)
        {
            if (imageModel.fullScreenImage == nil) {
                return;
            }
        }

        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:_selectedImagesArr forKey:@"images"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kConfirmSelectedImagesNotification object:nil userInfo:userInfoDict];
        [self dismissViewControllerAnimated:YES completion:^{
            //nothing
        }];
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        JYGroupCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYGroupCameraCell" forIndexPath:indexPath];
//        
//        [cell layoutWithModel];
//        return cell;
//        
//    } else {
        JYGroupImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYGroupImageCell" forIndexPath:indexPath];
        if (cell == nil) {
            /*
             再也不用对cell进行空值判断，以做额外的初始化操作。
             Cell的一切初始化工作都由系统为我们做好了。
             我们只需要对cell进行一些赋值等操作即可
             */
        }
        
        JYLocalImageModel *localImageModel = (JYLocalImageModel *)[_imagesArr objectAtIndex:indexPath.row];
        [cell layoutWithModel:localImageModel];
        return cell;
//    }
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLocalImageGroupToCameraNotification object:nil userInfo:nil];
//        }];
//    } else {
        JYGroupImageCell *cell = (JYGroupImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        JYLocalImageModel *localImageModel = (JYLocalImageModel *)[_imagesArr objectAtIndex:indexPath.row];
        
        if (localImageModel.selected) {
            //取消选中
            [cell.checkmarkBtn setSelected:NO];
            [localImageModel setSelected:NO];
            [_selectedImagesArr removeObject:localImageModel];
        } else {
            //选中
            if (_selectedImagesArr.count<_canUploadCount) {
                [cell.checkmarkBtn setSelected:YES];
                [localImageModel setSelected:YES];
                [_selectedImagesArr addObject:localImageModel];
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:[NSString stringWithFormat:@"最多可以选择%ld张",_canUploadCount]];
            }
        }
        
        [_selectImageCountLab setText:[NSString stringWithFormat:@"%lu/%ld", (unsigned long)_selectedImagesArr.count, _canUploadCount]];
        [self relayoutSelectedImages];
//    }
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


@end
