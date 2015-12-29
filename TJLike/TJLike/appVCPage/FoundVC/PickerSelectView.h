//
//  PickerSelectView.h
//  TestHebei
//
//  Created by Isaac on 14-6-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerSelectView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> {
    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnPickerSelect;
@property (nonatomic, assign) SEL OnPickerCancel;
@property (nonatomic, strong) NSString *mSelectStr;
@property (nonatomic, strong) NSArray *mPickArray;

- (void)reloadData:(NSArray *)array;

@end
