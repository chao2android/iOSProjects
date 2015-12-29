//
//  AZXGroupImagesController.h
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-11.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYBaseController.h"

@interface JYGroupImagesController : JYBaseController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_selectedImagesArr;
    NSMutableArray *_selectedImageViews;
    NSMutableArray *_imagesArr;
    UICollectionView *_collectionView;
    
    UILabel *_selectImageCountLab;
}

@property (nonatomic, assign) NSInteger canUploadCount;
//@property (nonatomic, strong) NSArray *imagesUrlArr;

@end
