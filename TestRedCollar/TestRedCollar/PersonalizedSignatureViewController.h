//
//  PersonalizedSignatureViewController.h
//  TestRedCollar
//
//  Created by MC on 14-7-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADViewController.h"

typedef void (^saveData)(NSString *emb,int a,int b,int c);
@interface PersonalizedSignatureViewController : BaseADViewController<UITextViewDelegate>

@property (copy,nonatomic)saveData block;
@property (copy,nonatomic)NSMutableArray *fontArray;
@property (copy,nonatomic)NSMutableArray *locationArray;
@property (copy,nonatomic)NSMutableArray *colorArray;
@property (assign,nonatomic)int a;
@property (assign,nonatomic)int b;
@property (assign,nonatomic)int c;
@property (copy,nonatomic)NSString *emb;
@end
