//
//  GGCoreTextView.h
//  TextCoreText
//
//  Created by 高斌 on 15/3/27.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@class JYFeedTextView;

typedef void (^JYFeedTextViewIDHandler)(JYFeedTextView *view, NSString *ids,NSRange touchingIDRange);

@interface JYFeedTextView : UIView

@property (nonatomic, copy) JYFeedTextViewIDHandler IDsClickHandler;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray *drawImagesArray;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) CTFrameRef cTFrame;
@property (nonatomic, strong) UIColor * fontColor;
@property (nonatomic, assign) CGSize  imgBoundSize;
@property (nonatomic, assign) NSInteger showWidth;
@property (nonatomic, strong) NSMutableArray *IDs;
@property (nonatomic, strong) NSMutableArray *IDRanges;
@property (nonatomic, strong) NSDictionary *otherDic;
@property (nonatomic, assign) BOOL isSuperResponse;
@property (nonatomic, assign) int totalLineNumber;

- (void)layoutWithContent:(NSString *)content;


@end
