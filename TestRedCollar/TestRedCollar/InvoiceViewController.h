//
//  InvoiceViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"
typedef void (^typeSelect)(int index,NSString *typeStr,NSString *title);
@interface InvoiceViewController : BaseADViewController<UITextFieldDelegate>
    
@property (copy,nonatomic) typeSelect blocks;
@property (assign,nonatomic) int index;
@end
