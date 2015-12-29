//
//  AZXViewPhotoController.m
//  imAZXiPhone
//  查看他人相册的照片
//  Created by coder_zhang on 14-9-10.
//  Copyright (c) 2014年 coder_zhang. All rights reserved.
//

#import "JYPhotoController.h"
#import "JYPhotoTableView.h"
//#import "AZXUserPhotoModel.h"
//#import "AZXOthersUserPhotoModel.h"

@interface JYPhotoController ()
{
    UILabel *_indexLabel;
    UIButton *_praiseBtn;
    UILabel *_praiselab;
    JYPhotoTableView *_tableView;
//    __weak ASIFormDataRequest *_requestPraisePhoto;
}

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation JYPhotoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //导航栏透明
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.translucent = YES;
    
    _tableView = [[JYPhotoTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (SYSTEM_VERSION >= 7.0f) {
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } else {
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-20);
    }
    _tableView.rowHeight = kScreenWidth;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //将所有的图片url赋给tableView显示
    _tableView.data = self.photoModels;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

- (void)setIndex:(int)index
{
    if (_index != index) {
        _index = index;
    }
    
    if (_data.count > 1) {
        
        _currentIndex = index;
        _indexLabel.text = [NSString stringWithFormat:@"%d/%lu", index + 1, self.data.count];
    }
    
//    if (index == 0) {
//        
//    }
    [self _getLikeStatus:index];
    
    //滚动到指定的单元格
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)setData:(NSArray *)data
{
    if (_data != data) {
        _data = data;
    }
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 35)];
    toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:toolView];

    if (_data.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = CGRectMake(105, 10, 110, 20);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [toolView addSubview:_indexLabel];
    }
    
    // 赞按钮的底视图
//    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-110, 0, 75, 35)];
    UIButton *baseView = [UIButton buttonWithType:UIButtonTypeCustom];
    baseView.frame = CGRectMake(kScreenWidth-90, 0, 75, 35);
    baseView.backgroundColor = [JYHelpers setFontColorWithString:@"#373737"];
    baseView.layer.cornerRadius = 3;
    baseView.userInteractionEnabled = YES;
    [baseView addTarget:self action:@selector(priseImage) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:baseView];
    
    // 赞图片按钮
    CGFloat btnWidth = 35;//self.bounds.size.height;
    _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _praiseBtn.frame = CGRectMake(0, 0, 75, btnWidth);
    _praiseBtn.backgroundColor = [UIColor clearColor];
    _praiseBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_praiseBtn setImage:[UIImage imageNamed:@"btn_chakandatu_dianzan.png"] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"btn_chakandatu_yizan.png"] forState:UIControlStateSelected];
    [_praiseBtn addTarget:self action:@selector(priseImage) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:_praiseBtn];
    
    // 赞的数量
    _praiselab = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 33, 17)];
    _praiselab.backgroundColor = [UIColor clearColor];
    _praiselab.textAlignment = NSTextAlignmentCenter;
    _praiselab.textColor = [JYHelpers setFontColorWithString:@"#ffffff"];
    _praiselab.text = @"0";
    [baseView addSubview:_praiselab];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)priseImage
{
    NSLog(@"index %lu", _currentIndex);
    //
    /**
	 * @Title: add_focus
	 * @Description: 赞
     * @URL: http: //client.izhenxin.dev/cmiajax/?mod=snsfeed_ios&func=like_user_photo&oid=20442800&photoid=24842661
	 * @date 2014-9-10
	 */
    
//    AZXOthersUserPhotoModel *userPhotoModel = (AZXOthersUserPhotoModel *)self.photoModels[_currentIndex];
//    NSString *is_likeStr = [NSString stringWithFormat:@"%@", userPhotoModel.islike];
//    NSInteger is_like = [is_likeStr integerValue];
//    if (is_like) {
////        [[AZXAppDelegate sharedAppDelegate] showTip:@"你已经点过赞了"];
//        return;
//    }
//    
//    NSString *photoId = self.photoIdArr[_currentIndex];
//    
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    [parametersDict setObject:@"snsfeed_ios" forKey:@"mod"];
//    [parametersDict setObject:@"like_user_photo" forKey:@"func"];
//    [parametersDict setObject:self.u_id forKey:@"oid"];
//    [parametersDict setObject:photoId forKey:@"photoid"];
////    [_requestPraisePhoto clearDelegatesAndCancel];
//    __weak ASIFormDataRequest *_requestPraisePhoto;
//    _requestPraisePhoto = [ASIFormDataRequest requestWithURL:[AZXHttpServeice urlWithParametersDict:parametersDict]];
//    
//    _requestPraisePhoto = [AZXHttpServeice processWithRequest:_requestPraisePhoto formDict:nil];
//    [_requestPraisePhoto setCompletionBlock:^{
//        
//        id result = [NSJSONSerialization JSONObjectWithData:_requestPraisePhoto.responseData options:NSJSONReadingMutableContainers error:nil];
//        int retCodeValue = [[result objectForKey:@"retcode"] intValue];
//        if (retCodeValue == 1) {
////            [self dismissProgressHUDtoView:self.view];
////            [[AZXAppDelegate sharedAppDelegate] showTip:@"点赞成功"];
//
//            AZXOthersUserPhotoModel *userPhotoModel = (AZXOthersUserPhotoModel *)self.photoModels[_currentIndex];
//            userPhotoModel.islike = @"1";
//            userPhotoModel.likecount = [NSString stringWithFormat:@"%d", [userPhotoModel.likecount integerValue] + 1];
//            [self _getLikeStatus:_currentIndex];
//            
//            
//        } else if (retCodeValue == 0) {
////            [self dismissProgressHUDtoView:self.view];
//            [[AZXAppDelegate sharedAppDelegate] showTip:@"您的注册资料正在审核中"];
//        }
//        else {
////            [self dismissProgressHUDtoView:self.view];
////            [[AZXAppDelegate sharedAppDelegate] showTip:@"请求失败"];
//            NSString *retmeanStr = result[@"retmean"];
//            [[AZXAppDelegate sharedAppDelegate] showTip:retmeanStr];
//        }
//    }];
//    
//    [_requestPraisePhoto setFailedBlock:^{
////        [self dismissProgressHUDtoView:self.view];
//        [[AZXAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
//    }];
////    [self showProgressHUD:kRequestWaiting toView:self.view];
//    [_requestPraisePhoto startAsynchronous];

}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_data.count > 1) {
        NSInteger currentIndex = _tableView.contentOffset.y / _tableView.frame.size.width;
        _currentIndex = currentIndex;
        _indexLabel.text = [NSString stringWithFormat:@"%ld/%lu", currentIndex + 1, self.data.count];
    }
    
    [self _getLikeStatus:_currentIndex];
}

- (void)_getLikeStatus:(NSInteger)index
{
//    AZXOthersUserPhotoModel *userPhotoModel = (AZXOthersUserPhotoModel *)self.photoModels[index];
//    NSString *is_likeStr = [NSString stringWithFormat:@"%@", userPhotoModel.islike];
//    NSString *likeStr = [NSString stringWithFormat:@"%@", userPhotoModel.likecount];
//    NSInteger is_like = [is_likeStr integerValue];
//    if (is_like) { // 已赞
//        _praiseBtn.selected = YES;
//        _praiselab.textColor = [AZXHelpers setFontColorWithString:@"#e14f64"];
//    } else {
//        _praiseBtn.selected = NO;
//        _praiselab.textColor = [AZXHelpers setFontColorWithString:@"#ffffff"];
//    }
//    _praiselab.text = likeStr;
}

@end
