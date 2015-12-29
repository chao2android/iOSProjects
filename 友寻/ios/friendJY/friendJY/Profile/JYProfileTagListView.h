//
//  JYProfileTagListView.h
//  friendJY
//
//  Created by ouyang on 3/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYProfileTagListView : UIView

@property(nonatomic,strong)  NSMutableDictionary * tagDic;
@property (nonatomic, strong) NSMutableArray *delTagArr;
@property (nonatomic, copy) void (^addTagBlock)();
//@property (nonatomic, strong) NSString *uid;

- (JYProfileTagListView *) initUiView:(NSString *)uid width:(NSInteger) width startPosition:(CGPoint)sp tagList:(NSMutableDictionary *) tagList isAllowDelTag:(BOOL) isAllowDelTag isAllowClickTag:(BOOL) isAllowClickTag isContactsTag:(BOOL) isContactTag;
/**
 *  设置未加入友寻好友资料页的一些属性
 */
- (void)setDefaultAttribute:(NSString*)uid width:(CGFloat)width tagList:(NSDictionary*)tagList oringinal:(CGPoint)sp;

- (void) addOneTagResetList:(NSMutableDictionary *) tagList;

- (void) delTagPostHttp;

- (void) resetAllTagList;

@end
