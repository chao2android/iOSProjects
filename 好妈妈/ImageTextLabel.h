//
//  ImagesCharacterArrange.h
//  talktalktalk
//
//  Created by zuoxiaolin on 11-8-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTextLabel : UIView {
	NSMutableArray   *mArray;              //存放所有的内容
    CGFloat          m_DrawWidth;         //绘字符的Rect的width
	NSInteger        m_EmoWidth;          //表情图片的大小，不同视图采用不同大小的表情
	NSInteger        m_EmoHeight;          //表情图片的大小，不同视图采用不同大小的表情
	NSInteger        m_RowHeigh;          //行高，不同视同采用不同的行高
	NSInteger        m_FontSize;          //字体大小，不同视图蔡采用不同大小
	UIFont           *m_Font;             //字体格式
	
}
@property (assign,nonatomic) BOOL hangshu;
@property(nonatomic, assign) CGFloat m_DrawWidth;
@property(nonatomic, assign) NSInteger m_EmoWidth;
@property(nonatomic, assign) NSInteger m_EmoHeight;
@property(nonatomic, assign) NSInteger m_RowHeigh;
@property(nonatomic, assign) NSInteger m_FontSize;
@property(nonatomic, retain) UIFont *m_Font;
@property(nonatomic, retain) UIColor *textColor;

//对传入的字符串进行处理，图文混排，得到混排好的视图
- (int)LoadContent:(NSString *)text;
+ (int)HeightOfContent:(NSString *)text :(CGSize)size;

@end
