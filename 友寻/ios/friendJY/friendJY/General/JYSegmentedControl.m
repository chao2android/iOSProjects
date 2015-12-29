//
//  AZXSegmentedControl.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-7-10.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYSegmentedControl.h"

@implementation JYSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self){
    }
    
    return self;
}

- (id)initWithItems:(NSArray *)array
{
    self = [super initWithItems:array];
    if (self) {
        _titles = [[NSMutableArray alloc] initWithArray:array];
        
        [self addTarget:self action:@selector(segmentedControlChanged:)forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
    [super setImage:image forSegmentAtIndex:segment];
    
    if(segment >= [_buttons count])
        return;
    
    UIButton *btn =[_buttons objectAtIndex:segment];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
    if(segment >= [_buttons count])
        return;
    
    UIButton *btn =[_buttons objectAtIndex:segment];
    [btn setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)insertSegmentWithImage:(UIImage *)image  atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithImage:image atIndex:segment animated:animated];
    
    while ([_titles count] < [_buttons count]) {
        [_titles addObject:@""];
    }
    
    [self layoutButtons];
}

- (void)layoutButtons
{
    if([_titles count] == 0)
        return;
    
    CGRect newFrame = self.bounds;
    newFrame.size.width = newFrame.size.width/ [_titles count];
    
    if(_buttons == nil){
        _buttons = [[NSMutableArray alloc] init];
    }
    
    for (int i= 0; i<[_titles count]; i++) {
        UIButton *btn = nil;
        if([_buttons count] <[_titles count]){
            btn = [[UIButton alloc] init];
            [_buttons addObject:btn];
        }
        else{
            btn = [_buttons objectAtIndex:i];
        }
        [btn setFrame:newFrame];
        btn.tag = i;
        newFrame.origin.x += newFrame.size.width;
        [btn setTitle:[_titles objectAtIndex:i] forState:UIControlStateNormal];
        //#warning 给字体设置颜色
        //        [btn setTitleColor:[UIColor colorWithHex:0xff5a00] forState:UIControlStateSelected];
        //        [btn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        //        NSLog(@"segment set title:%@", [_titles objectAtIndex:i]);
        
        [btn removeFromSuperview];
        [self addSubview:btn];
    }
    
    for (UIView *sub in [self subviews]) {
        if(![sub isKindOfClass:[UIButton class]]){
            sub.hidden = YES;
        }
    }
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [super addTarget:target action:action forControlEvents:controlEvents];
    
    for (UIButton *item in _buttons) {
        [item addTarget:target action:action forControlEvents:controlEvents];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    //    NSLog(@"[setFrame] (%f %f) width:%f height:%f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    [self layoutButtons];
}

- (void) setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    [super setSelectedSegmentIndex:selectedSegmentIndex];
    
    if(selectedSegmentIndex >= [_buttons count]){
        return;
    }
    
    for (UIButton *item in _buttons) {
        item.selected = NO;
    }
    UIButton *targetBtn = [_buttons objectAtIndex:selectedSegmentIndex];
    targetBtn.selected = YES;
}

- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
    NSUInteger selectedIndex = sender.selectedSegmentIndex;
    
    if(selectedIndex >= [_buttons count])
        return;
    
    for (UIButton *item in _buttons) {
        item.selected = NO;
    }
    
    UIButton *targetBtn = [_buttons objectAtIndex:selectedIndex];
    targetBtn.selected = YES;
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment{
    [super setTitle:title forSegmentAtIndex:segment];
    
    if(segment < [_buttons count]){
        UIButton * btn =[_buttons objectAtIndex:segment];
        [btn setTitle:title forState:UIControlStateNormal];
        
        [_titles replaceObjectAtIndex:segment withObject:title];
    }
}

@end
