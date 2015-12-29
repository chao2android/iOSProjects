//
//  PopSearchView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSearchView : UIView<UITextFieldDelegate> {
    UITextField *mTextField;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnSearchText;

@end
