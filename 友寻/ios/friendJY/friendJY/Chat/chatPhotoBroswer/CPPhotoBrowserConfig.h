//
//  SDPhotoBrowserConfig.h
//  SDPhotoBrowser
//
//  Created by aier on 15-2-9.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


typedef enum {
    CPWaitingViewModeLoopDiagram, // 环形
    CPWaitingViewModePieDiagram // 饼型
} CPWaitingViewMode;

// 图片保存成功提示文字
#define CPPhotoBrowserSaveImageSuccessText @"图片保存成功 ";

// 图片保存失败提示文字
#define CPPhotoBrowserSaveImageFailText @"图片保存失败 ";

// browser背景颜色
#define CPPhotoBrowserBackgrounColor [UIColor colorWithRed:224 green:241 blue:244 alpha:1]

// browser中图片间的margin
#define CPPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define CPPhotoBrowserShowImageAnimationDuration 0.5f

// browser中显示图片动画时长
#define CPPhotoBrowserHideImageAnimationDuration 0.5f

// 图片下载进度指示进度显示样式（SDWaitingViewModeLoopDiagram 环形，SDWaitingViewModePieDiagram 饼型）
#define CPWaitingViewProgressMode CPWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define CPWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0]

// 图片下载进度指示器内部控件间的间距

#define CPWaitingViewItemMargin 10


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com