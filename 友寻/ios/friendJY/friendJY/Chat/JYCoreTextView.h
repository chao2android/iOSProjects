//
//  GGCoreTextView.h
//  TextCoreText
//
//  Created by 高斌 on 15/3/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@class JYCoreTextView;

typedef void (^JYCoreTextViewIDHandler)(JYCoreTextView *view, NSString *ids,NSRange touchingIDRange);

@interface JYCoreTextView : UIView

@property (nonatomic, copy) JYCoreTextViewIDHandler IDsClickHandler;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray *drawImagesArray;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) CTFrameRef cTFrame;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) NSMutableArray *IDs;
@property (nonatomic, strong) NSMutableArray *IDRanges;
@property (nonatomic, strong) UIColor * IDColor;

- (void)layoutWithContent:(NSString *)content;


@end
