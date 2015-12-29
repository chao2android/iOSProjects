//
//  WTVHomePosterView.m
//  WiseTV
//
//  Created by littlezl on 14-9-25.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "WTVHomePosterView.h"
#import "TJBBSPosterModel.h"
#import "UIImageView+WebCache.h"

#define poster_autoswitch_time_interval 5.0

#define posterView_Background_color                     [UIColor whiteColor]
#define posterView_backline_imageName                   @"posterBackLine.png"
#define posterView_backline_height                      25.0f

#define posterView_nameLabel_font                       [UIFont systemFontOfSize:12.0]
#define posterView_nameLabel_text_color                 [UIColor whiteColor]
#define posterView_nameLabel_oriX                       15.0f
#define posterView_nameLabel_height                     25.0f
#define posterView_nameLabel_width                      SCREEN_WIDTH*2/3

#define pageControl_PageIndicatorTintColor              [UIColor whiteColor]
#define pageControl_currentPageIndicatorTintColor       [UIColor colorWithRed:0 green:122.0/255.0 blue:252.0/255.0 alpha:1.0]
#define pageControl_height                              20.0f
#define pageControl_perIndicator_width                  10.0f

@interface WTVHomePosterView ()<UIScrollViewDelegate>
{
    /**
     *  海报视图
     */
    UIView *posterView;
    /**
     *  滚动视图
     */
    UIScrollView *posterScrollView;
    /**
     *  标题栏背景图
     */
    UIImageView *backLineImageView;
    /**
     *  当前显示的图
     */
    UIImageView *curImageView;
    /**
     *  page control
     */
    UIPageControl *posterPageControl;
    /**
     *  标题
     */
    UILabel *posterNameLabel;
    
    /**
     *  <#Description#>
     */
    NSInteger totalPage;
    /**
     *  <#Description#>
     */
    NSInteger curPage;
    CGRect scrollFrame;
    
    /**
     *  所有图片
     */
    NSArray *posterInfoArr;
    /**
     *  存放当前滚动需要的三张图
     */
    NSMutableArray *curImagesArr;
}

@end

@implementation WTVHomePosterView
-(id)init
{
    if (self = [super init]) {
        posterView = [[UIView alloc] init];
        [posterView setBackgroundColor:posterView_Background_color];

        posterScrollView = [[UIScrollView alloc] init];
        [posterScrollView setBackgroundColor:[UIColor whiteColor]];
        posterScrollView.delegate = self;
        posterScrollView.showsHorizontalScrollIndicator = NO;
        posterScrollView.pagingEnabled = YES;
        posterScrollView.bounces = NO;
        
        posterPageControl = [[UIPageControl alloc] init];
        posterPageControl.pageIndicatorTintColor = pageControl_PageIndicatorTintColor;
        posterPageControl.currentPageIndicatorTintColor = pageControl_currentPageIndicatorTintColor;
        posterPageControl.userInteractionEnabled = NO;
        
        backLineImageView = [[UIImageView alloc] init];
        backLineImageView.image = [UIImage imageNamed:posterView_backline_imageName];
        
        posterNameLabel = [[UILabel alloc] init];
        posterNameLabel.backgroundColor = [UIColor clearColor];
        posterNameLabel.font = posterView_nameLabel_font;
        posterNameLabel.textColor = posterView_nameLabel_text_color;
        
        [posterView addSubview:posterScrollView];
        [posterView addSubview:backLineImageView];
        [posterView addSubview:posterPageControl];
        [posterView addSubview:posterNameLabel];
        
        posterInfoArr = [[NSArray alloc] init];
        curImagesArr = [[NSMutableArray alloc] init];
    

    }
    return self;
}

-(UIView *)posterViewWithInfo:(NSArray *)posterArr withFrame:(CGRect)frame
{
    posterInfoArr = posterArr;

    if (posterInfoArr.count == 1) {
        posterPageControl.hidden = YES;
    }
    
    
    totalPage = [posterInfoArr count];
    curPage = 0;

    scrollFrame = frame;
    
    posterView.frame = scrollFrame;
    backLineImageView.frame = CGRectMake(0, posterView.frame.size.height - posterView_backline_height, SCREEN_WIDTH, posterView_backline_height);
    posterNameLabel.frame = CGRectMake(posterView_nameLabel_oriX, posterView.frame.size.height - posterView_nameLabel_height, posterView_nameLabel_width, posterView_nameLabel_height);

    posterScrollView.frame = scrollFrame;
    posterScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * posterInfoArr.count, scrollFrame.size.height);
    
    posterPageControl.numberOfPages = totalPage;
    CGFloat wei = totalPage * pageControl_perIndicator_width;
    posterPageControl.frame = CGRectMake(SCREEN_WIDTH - wei - 20, scrollFrame.size.height - pageControl_height, wei, pageControl_height);

    if (totalPage >= 1) {
        [self refreshScrollView];
        [self timerStart];
    }
   
    return posterView;
}

-(void)refreshScrollView
{
    NSArray *subViews=[posterScrollView subviews];
    if([subViews count]!=0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    if (curImagesArr.count==0) {
        return;
    }
    TJBBSPosterModel *preInfo = curImagesArr[0];
    TJBBSPosterModel *curInfo = curImagesArr[1];
    TJBBSPosterModel *nextInfo = curImagesArr[2];

    UIView *preView=[self viewWithInfo:preInfo];
    UIView *curView=[self viewWithInfo:curInfo];
    UIView *lastView=[self viewWithInfo:nextInfo];

    [posterScrollView addSubview:preView];
    [posterScrollView addSubview:curView];
    [posterScrollView addSubview:lastView];

    preView.frame=CGRectOffset(preView.frame, 0, 0);
    curView.frame=CGRectOffset(curView.frame, SCREEN_WIDTH, 0);
    lastView.frame=CGRectOffset(lastView.frame, SCREEN_WIDTH*2, 0);
    [posterScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    posterScrollView.scrollsToTop = NO;
//
//    if (curInfo.contentName) {
//        posterNameLabel.text = curInfo.contentName;
//    }
    posterPageControl.currentPage = curPage;
}

- (NSArray*) getDisplayImagesWithCurpage:(NSInteger)page
{
    NSInteger pre=[self validPageValue:curPage-1];
    NSInteger last=[self validPageValue:curPage+1];
    if([curImagesArr count]!=0)    [curImagesArr removeAllObjects];
    if (posterInfoArr.count==0)    return curImagesArr;
    [curImagesArr addObject:[posterInfoArr objectAtIndex:pre]];
    [curImagesArr addObject:[posterInfoArr objectAtIndex:curPage]];
    [curImagesArr addObject:[posterInfoArr objectAtIndex:last]];
    return curImagesArr;
}

- (NSInteger)validPageValue:(NSInteger)value
{
    if(value==-1)    value=totalPage - 1;
    if(value==totalPage)  value=0;
    if (value<0) {
        value = 0;
    }
    return value;
}

-(UIView *)viewWithInfo:(TJBBSPosterModel *)info
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, scrollFrame.size.height)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    if (info.pic) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.pic] placeholderImage:[UIImage imageNamed:@"news_list_default"]];
    }
    [contentView addSubview:imageView];
    
    UIButton *selectBut = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBut.frame = CGRectMake(0, 0, contentView.frame.size.width,contentView.frame.size.height);
    [contentView addSubview:selectBut];
    @weakify(self)
    [[selectBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.showPosterDetailCommand) {
            [self.showPosterDetailCommand execute:info];
        }
    }];
    return contentView;
}

-(void)timerStart
{
    [self performSelector:@selector(TIMER) withObject:nil afterDelay:poster_autoswitch_time_interval];
}

-(void)timerStop
{
    curPage = 0;
    [self refreshScrollView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TIMER) object:nil];
}

-(void)TIMER{//定时自动滚动_ScrollView
    
    [posterScrollView setContentOffset:CGPointMake(2*scrollFrame.size.width, 0) animated:YES];
    [self performSelector:@selector(TIMER) withObject:nil afterDelay:poster_autoswitch_time_interval];

}

#pragma mark PageController绑定ScrollAdvertisement
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TIMER) object:nil];
    
    float x=scrollView.contentOffset.x;
    
    if(x>=2*scrollFrame.size.width) //往下翻一张
    {
        curPage=[self validPageValue:curPage+1];
        [self refreshScrollView];
    }
    
    if(x<=0)
    {
        curPage=[self validPageValue:curPage-1];
        [self refreshScrollView];
    }
    
    [self performSelector:@selector(TIMER) withObject:nil afterDelay:poster_autoswitch_time_interval];
}

@end
