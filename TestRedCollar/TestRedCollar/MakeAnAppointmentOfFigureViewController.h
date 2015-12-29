//
//  MakeAnAppointmentOfFigureViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-29.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
typedef void (^saveMakeData)(NSString *address,NSString *mobile ,NSString * realname,NSString * region_id,NSString * region_name,NSString * retime);

@interface MakeAnAppointmentOfFigureViewController : BaseADViewController<UITextFieldDelegate>


@property (nonatomic, assign) BOOL is_free;
@property (nonatomic, copy)saveMakeData block;



@end
