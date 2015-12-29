//
//  CustomListCell.h
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchView.h"

@protocol CustomListCellDelegate <NSObject>

- (void)OnCustomListSelect:(NSString *)name;

@end

@interface CustomListCell : UITableViewCell {
    TouchView *mLeftView;
    TouchView *mRightView;
}

@property (nonatomic, assign) id<CustomListCellDelegate> delegate;
@property (nonatomic, strong) NSString *mLeftName;
@property (nonatomic, strong) NSString *mRightName;

- (void)LoadContent:(NSString *)leftname :(NSString *)rightname;

@end
