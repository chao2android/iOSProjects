//
//  TJBbsCatagoryModel.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLikeBaseDataModel.h"
#import "TJBBSCateSubModel.h"

@interface TJBbsCatagoryModel : TJLikeBaseDataModel

@property (nonatomic, strong) NSString  *CataId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *word;
//@property (nonatomic, strong) NSArray   *subclass;
@property (nonatomic, strong) NSMutableArray *subclassList;

//@property (nonatomic, strong) TJBbsCatagoryModel *subClass;



@end
