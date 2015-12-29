//
//  InputGrowView.h
//  好妈妈
//
//  Created by Hepburn Alex on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputGrowView : UIView {
    UITextField *mWeight;
    UITextField *mHeight;
}

@property (readonly) UITextField *mWeight;
@property (readonly) UITextField *mHeight;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnInputGrow;

@end
