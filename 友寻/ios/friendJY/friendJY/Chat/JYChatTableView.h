//
//  JYChatTableView.h
//  friendJY
//
//  Created by 高斌 on 15/3/24.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseHeaderTableView.h"

@interface JYChatTableView : JYBaseHeaderTableView
{
    NSCache *_cellCache;
}
@end
