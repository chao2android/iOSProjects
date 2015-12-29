//
//  AZXLocalImagesController.m
//  imAZXiPhone
//
//  Created by 高 斌 on 14-8-11.
//  Copyright (c) 2014年 高 斌. All rights reserved.
//

#import "JYLocalImagesController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JYGroupImagesController.h"

@interface JYLocalImagesController ()
{
    UIImageView *navBaseView;
}

@end

@implementation JYLocalImagesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _imageGroupArr = [[NSMutableArray alloc] init];
//        _postImagesArr = [[NSMutableArray alloc] init];
        [self setTitle:@"手机相册"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initPublishSubview];
    
    [self getImages];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, navBaseView.bottom, kScreenWidth, kScreenHeight-kStatusBarHeight-kNavigationBarHeight)];
    [_table setBounces:NO];
    [_table setRowHeight:70.0f];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [self.view addSubview:_table];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)_initPublishSubview
{
//    // 导航栏背景视图
//    if (SYSTEM_VERSION >= 7.0f) {
//        navBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight + 20)];
//    } else {
//        navBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
//    }
//    
//    //    navBaseView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:0];
//    //navBaseView.image = [UIImage imageNamed:@"nav_bg.png"];
//    navBaseView.userInteractionEnabled = YES;
//    [self.view addSubview:navBaseView];
    
    //返回
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (SYSTEM_VERSION >= 7.0f) {
//        backBtn.frame = CGRectMake(0, 20, 60, 44);
//    } else {
//        backBtn.frame = CGRectMake(0, 0, 60, 44);
//    }
////    [backBtn setFrame:CGRectMake(0, 0, 60, 44)];
//    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
//    [backBtn setTitleColor:[JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navBaseView addSubview:backBtn];
    
    //左上角筛选图标
    UIButton *navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navLeftBtn.backgroundColor = [UIColor clearColor];
    [navLeftBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [navLeftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [navLeftBtn setTitleColor: [JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [navLeftBtn setTitle:@"取消" forState:UIControlStateNormal];
    //[navLeftBtn setImage:[UIImage imageNamed:@"feedLeftTopBtn"] forState:UIControlStateNormal];
    [navLeftBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navLeftBtn]];
    
    self.title = @"手机相册";
    
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    if (SYSTEM_VERSION >= 7.0f) {
//        titleLabel.frame = CGRectMake(60, 33, kScreenWidth-120, 17);
//    } else {
//        titleLabel.frame = CGRectMake(60, 13, kScreenWidth-120, 17);
//    }
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
//    titleLabel.text = @"手机相册";
//    [navBaseView addSubview:titleLabel];
    
//    //拍照
//    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (SYSTEM_VERSION >= 7.0f) {
//        cameraBtn.frame = CGRectMake(kScreenWidth-60, 20, 60, 44);
//    } else {
//        
//        [cameraBtn setFrame:CGRectMake(kScreenWidth-60, 0, 60, 44)];
//    }
////    [cameraBtn setFrame:CGRectMake(0, 0, 60, 44)];
//    [cameraBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
//    [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
//    [cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [navBaseView addSubview:cameraBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        //nothing
    }];
}

- (void)cameraBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocalImageGroupToCameraNotification object:nil userInfo:nil];
    }];
}

//获取所有本地图片
- (void)getImages
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound)
            {
                //无法访问相册.请在'设置->定位服务'设置为打开状态.
                [JYHelpers showAlertWithTitle:@"无法访问相册.请在'设置->定位服务'设置为打开状态"];
            } else {
                NSLog(@"相册访问失败.");
                [JYHelpers showAlertWithTitle:@"相册访问失败"];
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result != NULL)
            {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    NSString *urlstr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    
                    if ([_currentGroupDict objectForKey:@"thumbnailImage"] == nil) {
                        //取显示图片post图
                        [self getThumbnailImageWithUrl:urlstr groupDict:_currentGroupDict];
                    }
                    //                    [self getImageWithUrl:urlstr];
                    NSMutableArray *imagesUrlArr = [_currentGroupDict objectForKey:@"imagesUrlArr"];
                    [imagesUrlArr addObject:urlstr];
                }
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop) {
            
            if (group == nil)
            {
                
            }
            
            if (group != nil) {
                NSString *g = [NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                NSString *g1 = [g substringFromIndex:16 ] ;
                NSArray *arr = [[NSArray alloc] init];
                arr = [g1 componentsSeparatedByString:@","];
                NSString *g2 = [[arr objectAtIndex:0] substringFromIndex:5];
//                if ([g2 isEqualToString:@"Camera Roll"]) {
//                    g2 = @"相机胶卷";
//                } else if ([g2 isEqualToString:@"My Photo Stream"]) {
//                    //不显示照片流相册
//                    return;
//                }
                NSString *groupName = g2; //组的name
//                NSString *imageCount = [[arr objectAtIndex:2] substringFromIndex:14];
                
                NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
                [self setCurrentGroupDict:groupDict];
                [groupDict setObject:groupName forKey:@"name"];
//                [groupDict setObject:imageCount forKeyedSubscript:@"count"];
                NSMutableArray *imagesArr = [[NSMutableArray alloc] init];
                [groupDict setObject:imagesArr forKey:@"imagesUrlArr"];
                [self setCurrentGroupImagesArr:imagesArr];
                
                [_imageGroupArr addObject:groupDict];
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
}


//根据图片url取图片
- (void)getThumbnailImageWithUrl:(NSString *)imageUrl
              groupDict:(NSMutableDictionary *)groupDict;
{
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        NSLog(@"---->%@",asset);
        UIImage *thumbnailImage = [UIImage imageWithCGImage:asset.thumbnail];
        
        if (thumbnailImage) {
            [groupDict setObject:thumbnailImage forKey:@"thumbnailImage"];
            [_table reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = (NSDictionary *)[_imageGroupArr objectAtIndex:indexPath.row];
    JYGroupImagesController *controller = [[JYGroupImagesController alloc] init];
    controller.canUploadCount = self.canUploadCount;
//    [controller setImagesUrlArr:[dict objectForKey:@"imagesUrlArr"]];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imageGroupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setTag:100];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
        
        UILabel *groupNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [groupNameLab setTag:101];
        [groupNameLab setTextColor:[JYHelpers setFontColorWithString:@"444444"]];
        [groupNameLab setFont:[UIFont systemFontOfSize:17.0f]];
        [cell.contentView addSubview:groupNameLab];
        
        UILabel *imageCountLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [imageCountLab setTag:102];
        [imageCountLab setTextColor:[JYHelpers setFontColorWithString:@"A1A1A1"]];
        [imageCountLab setFont:[UIFont systemFontOfSize:17.0f]];
        [cell.contentView addSubview:imageCountLab];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *groupNameLab = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *imageCountLab = (UILabel *)[cell.contentView viewWithTag:102];
    
    [imageView setFrame:CGRectMake(20, 5, 60, 60)];
    NSDictionary *groupDict = (NSDictionary *)[_imageGroupArr objectAtIndex:indexPath.row];
    UIImage *thumbnailImage = (UIImage *)[groupDict objectForKey:@"thumbnailImage"];
    [imageView setImage:thumbnailImage];
//    if (indexPath.row < _postImagesArr.count) {
//        postImage = [_postImagesArr objectAtIndex:indexPath.row];
//        [imageView setImage:postImage];
//    } else {
//        [imageView setImage:nil];
//    }
    
    
    
    NSString *groupName = [groupDict objectForKey:@"name"];
    CGSize groupNameSize = [groupName sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [groupNameLab setFrame:CGRectMake(imageView.right+15, 25, groupNameSize.width, groupNameSize.height)];
    [groupNameLab setText:groupName];
    
//    NSString *imageCount = [NSString stringWithFormat:@"(%@)", [groupDict objectForKey:@"count"]];
    NSMutableArray *imagesUrlArr = (NSMutableArray *)[groupDict objectForKey:@"imagesUrlArr"];
    NSString *imageCount = [NSString stringWithFormat:@"(%d)", imagesUrlArr.count];
    CGSize imageCountSize = [imageCount sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [imageCountLab setFrame:CGRectMake(groupNameLab.right+15, 25, imageCountSize.width, imageCountSize.height)];
    [imageCountLab setText:imageCount];
    
    return cell;
}

@end
