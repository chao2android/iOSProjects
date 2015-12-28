//
//  VideoCutViewController.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseADViewController.h"

@interface VideoCutViewController : BaseADViewController {

}

@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) int miSubIndex;
@property (nonatomic, strong) NSMutableDictionary *mDict;

@end
