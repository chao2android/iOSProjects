//
//  JYFriendFilterView.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/29.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYFriendFilterView;

/**
 *  JYFriendFilterStatus 筛选视图三个状态
 */
typedef NS_ENUM( NSInteger, JYFriendFilterStatus){
    /**
     *  关闭
     */
    JYFriendFilterStatusClose,
    /**
     *  半打开
     */
    JYFriendFilterStatusHalf,
    /**
     *  全屏
     */
    JYFriendFilterStatusFullScreen
};
/**
 *  筛选视图代理
 */
@protocol JYFriendFilterViewDelegate <NSObject>

@required
/**
 *  筛选完成
 *
 *  @param filterView 当前筛选视图
 *  @param resultDict 筛选结果
 */
- (void)friendFilterView:(JYFriendFilterView*)filterView didFinishedFilterViewFilterResultDict:(NSDictionary*)resultDict;


@end
/**
 *  JYFriendFilterView 筛选视图
 */
@interface JYFriendFilterView : UIScrollView<UITextFieldDelegate>
{
    UIView *_sectionSex;
    UIView *_sectionMarriageStatus;
    UIScrollView *_sectionConstellation;
    UIView *_sectionAge;
    UIScrollView *_sectionHeight;
    UIScrollView *_sectionArea;
    UIScrollView *_sectionTag;
    UIView *_sectionConfirm;//确定 或重置
    
    NSDictionary *_profileOptionDic;//本地plist文件解析
    UITextField *_minAgeTF;//最小年龄
    UITextField *_maxAgeTF;//最大年龄
    
    //    星座多选数组
    NSMutableArray *_starSelectedArr;
    //    标签多选数组
    NSMutableArray *_selectedTidArr;
    
    CGFloat currentBottom ;

    BOOL _isShowHeight;
    //定位城市
    UIButton *_btnLocation;
    
}

@property (nonatomic, assign) id<JYFriendFilterViewDelegate>filterDelegate;

@property (nonatomic, assign) JYFriendFilterStatus status;
//筛选信息
@property (nonatomic, strong) NSMutableDictionary *filteOptionDict;

//存储筛选状态的字典
@property (nonatomic, strong) NSMutableDictionary *siftStatusDic;
//存储标签
@property (nonatomic, strong) NSArray *tagArr;
@property (nonatomic, strong) NSMutableArray *showTagArr;
//tag是否第一次刷新
@property (nonatomic, assign) BOOL isFirstLayout;

/**
 *  当所添加的控制器将要出现的时候调用
 */
- (void)addObserverFoyKeyBoard;
/**
 *  当所添加的控制器将要消失的时候调用
 */
- (void)removeObserverFoyKeyBoard;

@end
