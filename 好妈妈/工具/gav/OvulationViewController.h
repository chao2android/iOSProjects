//
//  OvulationViewController.h
//  好妈妈
//
//  Created by Hepburn Alex on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OvulationViewController : UIViewController {
    int miYear;
    int miMonth;
    int miOffset;
    UIImageView *mImageView;
    UILabel *mlbTitle;
    
    UIImageView *bg;
}

@property (nonatomic, retain) NSDate *mDate;
@property (nonatomic, assign) int miOffset;

@end
