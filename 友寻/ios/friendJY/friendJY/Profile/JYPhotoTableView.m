//
//  AZXPhotoTableView.m
//  imAZXiPhone
//
//  Created by coder_zhang on 14-9-10.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYPhotoTableView.h"
//#import "UIImageView+WebCache.h"
#import "JYPhotoScrollView.h"
#import "JYAlbumModel.h"


@implementation JYPhotoTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.pagingEnabled = YES;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"pictureCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //将cell.contentView顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.contentView.backgroundColor = [UIColor blackColor];
        
        
        JYPhotoScrollView *photoSV = [[JYPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        photoSV.tag = 100;
        [cell.contentView addSubview:photoSV];
        
        photoSV.tableView = self;
    }
    
    JYPhotoScrollView *photoSV = (JYPhotoScrollView *)[cell.contentView viewWithTag:100];
    JYAlbumModel *model = [self.data objectAtIndex:indexPath.row];
    photoSV.url = [NSURL URLWithString:model.pic800];
    photoSV.row = indexPath.row;
    
    return cell;
}

@end
