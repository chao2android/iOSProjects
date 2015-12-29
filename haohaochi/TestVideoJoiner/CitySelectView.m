//
//  CitySelectView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-20.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CitySelectView.h"
#import "TouchView.h"
#import "JSON.h"

@implementation CitySelectView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mArray = [NSMutableArray arrayWithCapacity:10];
        
        float fTop = IOS_7?65:44;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, fTop)];
        imageView.image = [UIImage imageNamed:@"topbar-w"];
        [self addSubview:imageView];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, fTop-44, frame.size.width, 44)];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.font = [UIFont fontWithName:@"Helvetica-Light" size:19];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.textColor = [UIColor darkGrayColor];
        lbTitle.text = @"选择位置";
        [imageView addSubview:lbTitle];
        
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, fTop, frame.size.width, frame.size.height-fTop)];
        mScrollView.backgroundColor = [UIColor whiteColor];
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:mScrollView];
        
        [self LoadCityList];
    }
    return self;
}

- (void)RefreshView {
    @autoreleasepool {
        for (UIView *view in mScrollView.subviews) {
            if ([view isKindOfClass:[TouchView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    NSLog(@"RefreshView");
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.mArray];
    if (self.mCity) {
        self.mCity = [self.mCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
        for (NSDictionary *dict in self.mArray) {
            NSString *city = [dict objectForKey:@"name"];
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            NSString *cityid = [dict objectForKey:@"id"];
            if ([city isEqualToString:self.mCity]) {
                [array insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"当前位置",@"name",cityid,@"id", nil] atIndex:0];
                break;
            }
        }
    }
    int iTop = 0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = [array objectAtIndex:i];
        
        TouchView *view = [[TouchView alloc] initWithFrame:CGRectMake(0, iTop, mScrollView.frame.size.width, 60)];
        view.delegate = self;
        view.OnViewClick = @selector(OnCityClick:);
        view.tag = i+1000;
        view.userinfo = dict;
        [mScrollView addSubview:view];
        
        if (i%2 == 0) {
            view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
        }
        else {
            view.backgroundColor = [UIColor whiteColor];
        }
        
        iTop += view.frame.size.height;
        
        UILabel *lbName = [[UILabel alloc] initWithFrame:view.bounds];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.textAlignment = NSTextAlignmentCenter;
        lbName.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
        lbName.text = [dict objectForKey:@"name"];
        [view addSubview:lbName];
    }
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, iTop);
}

- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadCityList {
    if (self.mDownManager) {
        return;
    }
    self.mDownManager = [[ImageDownManager alloc] init];
    self.mDownManager.delegate = self;
    self.mDownManager.OnImageDown = @selector(OnLoadFinish:);
    self.mDownManager.OnImageFail = @selector(OnLoadFail:);

    NSString *urlstr = [NSString stringWithFormat:@"%@/mobileapi/city/list", SERVER_URL];
    [self.mDownManager GetImageByUrl:[NSURL URLWithString:urlstr]];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict = [sender.mWebStr JSONValue];
    [self Cancel];
    if (dict) {
        NSLog(@"%@", dict);
        int iStatus = [[dict objectForKey:@"status"] intValue];
        if (iStatus == 1001) {
            NSArray *array = [dict objectForKey:@"lst"];
            if (array && [array isKindOfClass:[NSArray class]]) {
                [self.mArray removeAllObjects];
                [self.mArray addObjectsFromArray:array];
                [self RefreshView];
                if (self.mArray.count>0) {
                    NSDictionary *dict = [self.mArray objectAtIndex:0];
                    if (!kUserInfoManager.mCityID) {
                        kUserInfoManager.mCityID = [dict objectForKey:@"id"];
                        kUserInfoManager.mCityName = [dict objectForKey:@"name"];
                    }
                }
            }
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)OnCityClick:(TouchView *)sender {
    NSDictionary *dict = sender.userinfo;
    kUserInfoManager.mCityID = [dict objectForKey:@"id"];
    NSString *name = [dict objectForKey:@"name"];
    if ([name isEqualToString:@"当前位置"]) {
        kUserInfoManager.mCityName = @"本地";
    }
    else {
        kUserInfoManager.mCityName = name;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ShowCenter object:nil];
}

@end
