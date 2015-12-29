//
//  JYChatGetLocalPhoto.m
//  friendJY
//
//  Created by ouyang on 6/11/15.
//  Copyright (c) 2015 友寻. All rights reserved.
//

#import "JYChatGetLocalPhoto.h"

#import <AssetsLibrary/AssetsLibrary.h>
@implementation JYChatGetLocalPhoto{
    NSMutableArray *imagesUrlArr;
    UICollectionView * _collectionView;
    NSInteger _selectImageIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"相册"];
        
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imagesUrlArr        = [NSMutableArray array];
    _selectImageIndex= -1;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight-60) collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[JYGroupImageCell class] forCellWithReuseIdentifier:@"JYGroupImageCell"];
//    [_collectionView registerClass:[JYGroupCameraCell class] forCellWithReuseIdentifier:@"JYGroupCameraCell"];
    [self.view addSubview:_collectionView];

    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(10, _collectionView.bottom + 10, 60, 40)];
    [cancelBtn setBackgroundColor:[UIColor blackColor]];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //[cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    //确认
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setFrame:CGRectMake(kScreenWidth - 70, _collectionView.bottom + 10, 60, 40)];
    [okBtn setBackgroundColor:[UIColor blackColor]];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //[cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound)
            {
                //无法访问相册.请在'设置->定位服务'设置为打开状态.
                [JYHelpers showAlertWithTitle:@"无法访问相册.请在'设置->定位服务'设置为打开状态"];
            } else {
                NSLog(@"相册访问失败.");
                [JYHelpers showAlertWithTitle:@"相册访问失败"];
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result != NULL)
            {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    NSString *urlstr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    NSLog(@"photo:%@",urlstr);
                    [self getThumbnailImageWithUrl:urlstr];
                    //[imagesUrlArr addObject:urlstr];
                }
            }
            
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop) {
            
            if (group == nil)
            {
                
            }
            
            if (group != nil) {
                
                NSString *g = [NSString stringWithFormat:@"%@",group];//获取相簿的组
                //gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                NSString *g1 = [g substringFromIndex:16 ] ;
                NSArray *arr = [[NSArray alloc] init];
                arr = [g1 componentsSeparatedByString:@","];
                NSString *g2 = [[arr objectAtIndex:0] substringFromIndex:5];
                NSLog(@"gg:%@",g2);
                if ([g2 isEqualToString:@"Camera Roll"] || [g2 isEqualToString:@"相机胶卷"]) {
                    g2 = @"相机胶卷";
                } else  {
                    //不显示照片流相册
                    return;
                }
//                NSString *groupName = g2; //组的name
//                //                NSString *imageCount = [[arr objectAtIndex:2] substringFromIndex:14];
//                
//                NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
//                [self setCurrentGroupDict:groupDict];
//                [groupDict setObject:groupName forKey:@"name"];
//                //                [groupDict setObject:imageCount forKeyedSubscript:@"count"];
//                NSMutableArray *imagesArr = [[NSMutableArray alloc] init];
//                [groupDict setObject:imagesArr forKey:@"imagesUrlArr"];
//                [self setCurrentGroupImagesArr:imagesArr];
//                
//                [_imageGroupArr addObject:groupDict];+_)
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//根据图片url取图片
- (void)getThumbnailImageWithUrl:(NSString *)imageUrl
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        //        UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
        UIImage *thumbnailImage = [UIImage imageWithCGImage:asset.thumbnail];
//        UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
        JYLocalImageModel *localImageModel = [[JYLocalImageModel alloc] init];
        [localImageModel setImageUrl:imageUrl];
        [localImageModel setThumbnailImage:thumbnailImage];
//        [localImageModel setFullScreenImage:fullScreenImage];
        [imagesUrlArr addObject:localImageModel];
        [_collectionView reloadData];
       
    } failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imagesUrlArr.count;
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
    
    JYLocalImageModel *localImageModel = (JYLocalImageModel *)[imagesUrlArr objectAtIndex:indexPath.row];
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
    JYLocalImageModel *localImageModel = (JYLocalImageModel *)[imagesUrlArr objectAtIndex:indexPath.row];
    
    if (localImageModel.selected) {
        //取消选中
        [cell.checkmarkBtn setSelected:NO];
        [localImageModel setSelected:NO];
        _selectImageIndex = -1;
    } else {
        //选中
        if (_selectImageIndex>-1) {
            NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:_selectImageIndex inSection:0];
            JYGroupImageCell *prevCell = (JYGroupImageCell *)[collectionView cellForItemAtIndexPath:prevIndexPath];
            JYLocalImageModel *prevLocalImageModel = (JYLocalImageModel *)[imagesUrlArr objectAtIndex:_selectImageIndex];
            [prevCell.checkmarkBtn setSelected:NO];
            [prevLocalImageModel setSelected:NO];
        }
        [cell.checkmarkBtn setSelected:YES];
        [localImageModel setSelected:YES];
        _selectImageIndex = indexPath.row;
       
    }
    
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

- (void)relayoutSelectedImages
{
//    for (int i=0; i<_selectedImageViews.count; i++)
//    {
//        UIImageView *imageView = [_selectedImageViews objectAtIndex:i];
//        
//        if (i<_selectedImagesArr.count) {
//            JYLocalImageModel *localImageModel = (JYLocalImageModel *)[_selectedImagesArr objectAtIndex:i];
//            [imageView setImage:localImageModel.thumbnailImage];
//        } else {
//            [imageView setImage:[UIImage imageNamed:@"fabudongtai_zhaopianxuankuang.png"]];
//        }
////        if (_selectedImagesArr.count>4) {
////            [selectedImagesBg setContentOffset:CGPointMake(12+(50+11.5)*(_selectedImagesArr.count-4),0) animated:YES];
////        }else{
////            [selectedImagesBg setContentOffset:CGPointMake(0,0) animated:YES];
////        }
//        
//    }
}

- (void) cancelBtnClick:(UIButton *)btm{
    NSLog(@"cancelBtnClick");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) okBtnClick:(UIButton *)btm{
    NSLog(@"okBtnClick");
    if ([self.delegate respondsToSelector:@selector(JYChatLocalPhotoSelected:selectedImage:)])
    {
        JYLocalImageModel *imageModel = (JYLocalImageModel *)[imagesUrlArr objectAtIndex:_selectImageIndex];
        
        //取大图
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        NSURL *url = [NSURL URLWithString:imageModel.imageUrl];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
            
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
       
            [imageModel setFullScreenImage:fullScreenImage];
            [self.delegate JYChatLocalPhotoSelected:self selectedImage:imageModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }];
        
    }
}

@end
