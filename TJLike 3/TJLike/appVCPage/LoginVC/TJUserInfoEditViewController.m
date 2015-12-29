//
//  TJUserInfoEditViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/5.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJUserInfoEditViewController.h"
#import "TJMyVillageViewController.h"
#import "UIImageView+WebCache.h"
#import "WTVEnlargeView.h"
#import "WTVAlertView.h"
#import "MBProgressHUD.h"
#import "TJUserInfoEditViewModel.h"

#define SHEAR_IMAHE_WIDTH   (320)
#define SHEAR_IMAGE_HEIGHT  (320)
@interface TJUserInfoEditViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,WTVAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *iconImageView;
    NSString    *nickName;
    NSString    *sexual;
    NSString    *birthday;
    NSString    *signature;

}

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) TJUserInfoEditViewModel *viewModel;


/**
 *  相册，图库选择器
 */
@property (nonatomic, strong) UIImagePickerController *pickerVC;
/**
 *  获取的头像 image
 */
@property (nonatomic, strong) UIImage         *editedImage;

@end

#define kUserInfoArray @[@"我头像",@"昵称",@"性别",@"生日",@"个性签名",@"绑定微博"]

@implementation TJUserInfoEditViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[TJUserInfoEditViewModel alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    [self initImagePicker];
}

/**
 *  初始化图片选择器
 */
- (void)initImagePicker
{
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.allowsEditing = YES;
    _pickerVC.delegate = self;
}

- (void)instalNavBar
{
    [self.naviController setNaviBarTitle:@"完善个人资料"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIImage *leftImg = [UIImage imageNamed:@"appui_fanhui_"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"appui_fanhui_" imgHighlight:nil withFrame:CGRectMake(0, 0, leftImg.size.width/2,leftImg.size.height/2)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:@"下一步" imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 100, 40)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TJMyVillageViewController *myVillage = [[TJMyVillageViewController alloc] init];
        [self.naviController pushViewController:myVillage animated:YES];
        
    }];
    [self.naviController setNaviBarRightBtn:rightBtn];
}

- (void)buildUI
{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoveryTableView)];
    //    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
    
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = YES;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 10);
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

-(void)recoveryTableView
{
//    [self.view endEditing:YES];
//    [_tableView setContentOffset:CGPointMake(0,-64) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self instalNavBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80;
            break;
            
        default:
            return 44;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 6) {
        return [[UIView alloc] init];
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:strCell];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLOR(242, 244, 248, 1);
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        
        
        
    }
    cell.textLabel.text = [kUserInfoArray objectAtIndex:indexPath.section];
    
    for (UIView *vi in cell.contentView.subviews) {
        if ([vi isKindOfClass:[UIImageView class]]) {
            [vi removeFromSuperview];
        }
    }
    
    UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 13)];
    accessView.image = [UIImage imageNamed:@"appui"];
    cell.accessoryView = accessView;
    
    switch (indexPath.section) {
        case 0:
        {
            iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 98.0, (88.0 - 58.0)/2, 58.0, 58.0)];
            iconImageView.layer.cornerRadius = iconImageView.bounds.size.width/2;
            iconImageView.clipsToBounds = YES;
//            iconImageView.image = ImageCache(_viewModel.userInfo.userImageName);
//            [NSURL URLWithString:_viewModel.userInfo.userImageUrl]]
//            @weakify(self)
//            if (!StringEqual(_viewModel.userInfo.userImageUrl, @"")) {
                [iconImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
//            }
            
            
            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserIconDetail:)];
            [iconImageView addGestureRecognizer:tap];
            iconImageView.userInteractionEnabled = YES;
            [cell.contentView addSubview:iconImageView];
        }
            break;
        case 1:
        {
            
            NSString *str;
            if (nickName) {
                str = nickName;
            }
            else{
                str = @"暂无";
            }
            cell.detailTextLabel.text = str;
            
        }
            break;
        case 2:
        {
            NSString *str;
            if (sexual) {
                str = sexual;
            }
            else{
                str =  @"保密";
            }
            
            cell.detailTextLabel.text = str;
            
        }
            break;
        case 3:
        {
            
            NSString *str;
            if (birthday) {
                str = @"暂无";
            }
            else{
                str = birthday;
            }
            cell.detailTextLabel.text = str;
            
        }
            break;
        case 4:
        {
            NSString *str;
            if (signature) {
                str = signature;
            }
            else{
                 str = @"暂无";
            }
            cell.detailTextLabel.text = str;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            [self showIconEditAlert];
        }
            break;
        case 1:
        {
            [self showNickNameEditAlert];
            
        }
            break;
        case 2:
        {
            [self showGenderEditAlert];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            [self showSignatureEditAlert];
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 图片放大
-(void)showUserIconDetail:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    point.y = point.y + NAVIBAR_HEIGHT + STATUSBAR_HEIGHT;
    WTVEnlargeView *largeView = [[WTVEnlargeView alloc] initLargeImageWithStartPoint:point largeImageUrl:nil andPlaceholderImage:iconImageView.image];
    [largeView showLargeView];
}
#pragma mark - alert show
-(void)showIconEditAlert
{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"设置您的头像" message:nil delegate:self buttonTitles:@[@"照相",@"从图库选择"] buttonImageNames:@[@"systemCamera",@"systemPhotoAlbum"]];
    alert.tag = AlertViewTag_Icon;
    [alert show];
}

-(void)showNickNameEditAlert
{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"修改您的昵称" message:nil delegate:self textFieldPlaceholders:@[@"输入昵称"] specialLine:nil limits:@[[NSNumber numberWithInt:11]] cancelButton:@"取消" otherButton:@"确认"];
    alert.tag = AlertViewTag_NickName;
    [alert show];
}
-(void)showGenderEditAlert
{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"您的性别" message:nil delegate:self buttonTitles:@[@"帅哥",@"美女"] buttonImageNames:@[@"userGenderBoy",@"userGenderGirl"]];
    alert.tag = AlertViewTag_Gender;
    [alert show];
}

-(void)showSignatureEditAlert
{
    WTVAlertView *alert = [[WTVAlertView alloc] initWithTitle:@"修改您的个性签名" message:nil delegate:self textFieldPlaceholders:@[@"输入个性签名"] specialLine:nil limits:@[[NSNumber numberWithInt:50]] cancelButton:@"取消" otherButton:@"确认"];
    alert.tag = AlertViewTag_Signature;
    [alert show];
}

#pragma mark - AlertView delegate
-(void)wtvAlertView:(WTVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case AlertViewTag_Gender:
        {
            if (buttonIndex == 0) {
                sexual = @"男";
            }
            else if (buttonIndex == 1)
            {
                sexual = @"女";
            }
            [self.tableView reloadData];
        }
            break;
        case AlertViewTag_Icon:
        {
            switch (buttonIndex) {
                case 0:
                {
                    //相机
                    [self gainPhotoFromCamera];
                    
                    
                }
                    break;
                case 1:
                {
                    //系统相册
                    [self gainPhotoFromPhotogallery];
                    
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}

-(void)wtvAlertView:(WTVAlertView *)alertView textFieldArray:(NSArray *)textArray
{
    switch (alertView.tag) {
        case AlertViewTag_NickName:
        {
            if ([[textArray objectAtIndex:0] length]>12) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"昵称请小于12个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
                [alert setTag:AlertViewTag_NickName];
                [alert show];
            } else {
                nickName = [textArray objectAtIndex:0];
                [self.tableView reloadData];
            }
        }
            break;
        case AlertViewTag_Signature:
        {
            if ([[textArray objectAtIndex:0] length]>50) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"个性签名请小于50个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
                [alert setTag:AlertViewTag_Signature];
                [alert show];
            } else {
                signature = [textArray objectAtIndex:0];
                [self.tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
- (void)wtvAlertViewCancel:(WTVAlertView *)alertView
{
    
}


#pragma mark - choose carmer ,image library

- (void)gainPhotoFromPhotogallery
{
    _pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_pickerVC animated:YES completion:^{
        
    }];
}

- (void)gainPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.mediaTypes = @[@"public.image"];
        
        [self presentViewController:_pickerVC animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"设备不支持相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if([type isEqualToString:@"public.image"]){
        UIImage *image = nil;
        
        if (_pickerVC.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }
        else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        self.editedImage = [image wtv_imageTelescopicToSize:CGSizeMake(SHEAR_IMAHE_WIDTH, SHEAR_IMAGE_HEIGHT)];
    }
    
    @weakify(self);
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        [self->iconImageView setImage:self.editedImage];
//        [self showLoadingHUD];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [_viewModel changeHeaderImage:[self.editedImage wtv_imageTransformData] withFinish:^{
//                
//                [self.loadingManager showLoadingProgressHUD:SHARE_WINDOW withTitle:@"头像上传成功" withLoading:NO];
//                
//            } failed:^{
//                @strongify(self);
//                [self.view makeToast:@"头像上传失败" duration:1.0f position:CSToastPositionCenter];
//                [self hideLoadingHUD];
//            }];
//        });
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
