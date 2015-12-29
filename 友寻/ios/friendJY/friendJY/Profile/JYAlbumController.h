//
//  AZXGroupImagesController.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-11.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYBaseController.h"
#import "JYProfileData.h"
#import "JYLocalImagesController.h"

@interface JYAlbumController : JYBaseController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_selectedImagesArr;
    NSMutableArray *_selectedImageViews;
    NSMutableArray *_tempImagesArrs; //选择上传的图片
    NSMutableArray *_showImagesArrs; //进来时显示已上传的图片
    UICollectionView *_collectionView;
    
    UILabel *_selectImageCountLab;
}

@property (nonatomic, assign) NSInteger canUploadCount;
@property (nonatomic, strong) NSArray *imagesUrlArr;
@property (nonatomic, copy) NSString * show_uid;
@property (nonatomic, assign) BOOL isLimited;

@end
