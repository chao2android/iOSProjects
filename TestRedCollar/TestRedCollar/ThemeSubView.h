//
//  ThemeSubView.h
//  TestRedCollar
//
//  Created by MC on 14-7-10.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TouchView.h"
#import "ThemeCateListModel.h"
@interface ThemeSubView : TouchView
{
    UILabel *favoriteLabel;
    UILabel *commentLabel;
    UILabel *desLabel;
    UILabel *nameLabel;
    UIImageView *imgView;
}
- (void)loadContent:(ThemeCateListModel *)model;
@end
