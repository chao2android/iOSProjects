//
//  JYFeedEditController.m
//  friendJY
//
//  Created by ouyang on 3/31/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//
#import "JYFeedEditController.h"
#import "JYHelpers.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYLocalImagesController.h"
#import "JYNavigationController.h"
#import "JYLocalImageModel.h"
#import "JYFeedPromissionController.h"
#import "JYProfileData.h"
#import "JYShareData.h"
#import "JYGroupImagesController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define  picDistance  5//(picShowDistrict.width - 250)/4;
@interface JYFeedEditController ()

{
    NSString * myuid;
    UIView * enterBg;
    UITextView * textEditView;
    UIButton *dynamicToAlbum;//是否同步到相册
    NSString * isDynamic;//点击按钮时，切换是否同步的值，0-不同步，1同步，默认为同步
    NSString * isSendText;//0-纯文字，1-带图片
    NSMutableArray *_tempImagesArrs; //选择上传的图片
    int _uploadedPhotoCompleteCount; //上传图片的数，最多为9张
    UIView * optionPhotoView;//照像或从相册选择
    BOOL allowSend;//是否允许发送信息，右上角的按钮
    //BOOL btnEnable;//按钮是否能点
    UIButton *navRightBtn;
    UIButton *navLeftBtn;
    NSMutableArray * picViewArr;//存放固定9张图片的，对象
    UIView *authSelectView;
    UIButton *cameraOrAlbum;
    UIImageView *sendText;
    NSDictionary * myPermissionDic;
    UILabel * allFriendTitle;
    UIView *picShowDistrict;
    NSMutableArray *imageArray;
}

@property (nonatomic, strong) JYFeedPromissionController * promissionVC;
//用于存储 上传成功的图片，如果用户选择同步，则修改用户信息中的 photoes
//@property (nonatomic, strong) NSMutableDictionary *uploadPhotoes;

@end

@implementation JYFeedEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"新动态"];
        
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (UIView *)GetInputView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [JYHelpers setFontColorWithString:@"#F2F2F2"];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.8)];
    line.backgroundColor = [JYHelpers setFontColorWithString:@"#cccccc"];
    [view addSubview:line];
    
    UIButton *comitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comitBtn.frame = CGRectMake(kScreenWidth-70, 0, 65, 40);
    [comitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [comitBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [comitBtn addTarget:self action:@selector(HideKeyBodrd) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:comitBtn];
    return view;
}
- (void)HideKeyBodrd{
    [textEditView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmSelectedImages:) name:kConfirmSelectedImagesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localImageGroupToCameraAction:) name:kLocalImageGroupToCameraNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_setPromissionNotification:) name:kFeedSetPromissionNotification object:nil];
    
    _uploadedPhotoCompleteCount = 0;
    isDynamic = @"0";
    isSendText = @"0";
    allowSend = NO;
    picViewArr = [NSMutableArray array];
    _tempImagesArrs = [NSMutableArray array];
//    _uploadPhotoes = [NSMutableDictionary dictionary];
    myuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    //左上角筛选图标
    navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navLeftBtn.backgroundColor = [UIColor clearColor];
    [navLeftBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [navLeftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [navLeftBtn setTitleColor: [JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    [navLeftBtn setTitle:@"取消" forState:UIControlStateNormal];
    //[navLeftBtn setImage:[UIImage imageNamed:@"feedLeftTopBtn"] forState:UIControlStateNormal];
    [navLeftBtn addTarget:self action:@selector(_clickLeftTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navLeftBtn]];
    
    //右上角添加动态
    navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.backgroundColor = [UIColor clearColor];
    [navRightBtn setFrame:CGRectMake(0, 0, 40, 20)];
    [navRightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [navRightBtn setTitleColor: [JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
    [navRightBtn setTitle:@"发布" forState:UIControlStateNormal];
    //[navRightBtn setImage:[UIImage imageNamed:@"feedAddBtn"] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(_clickRightTopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navRightBtn]];
    
    enterBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    enterBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:enterBg];
    
    textEditView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 140)];
    textEditView.backgroundColor = [UIColor clearColor];
    textEditView.inputAccessoryView = [self GetInputView];
    if(self.formId == 1 || self.content == nil){
        textEditView.text = @"说说最近有什么新鲜事？";
    }else{
        textEditView.text = self.content;
        if (self.content.length>0) {
            allowSend = YES;
            [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        }
    }
    textEditView.delegate = self;
    [enterBg addSubview:textEditView];
    
    //九张照片显示的地方
    picShowDistrict = [[UIView alloc] initWithFrame:CGRectMake(textEditView.left, textEditView.bottom + 5, kScreenWidth-30, 60)];
    picShowDistrict.backgroundColor = [UIColor clearColor];
    
    [enterBg addSubview:picShowDistrict];
    
    
//    cameraOrAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(20, enterBg.bottom - 30, 20, 20)];
//    cameraOrAlbum.image     = [UIImage imageNamed:@"feedCameraOrAlbum"];
//    [enterBg addSubview:cameraOrAlbum];
//    cameraOrAlbum.userInteractionEnabled = YES;
//    [cameraOrAlbum addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSendPic)]];
    cameraOrAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraOrAlbum.frame = CGRectMake(20, enterBg.bottom - 30, 20, 20);
    [cameraOrAlbum addTarget:self action:@selector(TextOrPhoto:) forControlEvents:UIControlEventTouchUpInside];
    cameraOrAlbum.selected = NO;
    [cameraOrAlbum setImage:[UIImage imageNamed:@"feedCameraOrAlbum_2"]  forState:UIControlStateNormal];
    [cameraOrAlbum setImage:[UIImage imageNamed:@"msg_keyboard.png"] forState:UIControlStateSelected];
    [enterBg addSubview:cameraOrAlbum];
    
//    sendText   = [[UIImageView alloc] initWithFrame:CGRectMake(cameraOrAlbum.right+15, cameraOrAlbum.top, 20, 20)];
//    sendText.image = [UIImage imageNamed:@"feedSendText"];
//    sendText.userInteractionEnabled = YES;
//    [enterBg addSubview:sendText];
//    [sendText addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSendText)]];
    
    dynamicToAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamicToAlbum.frame = CGRectMake(enterBg.right - 100, enterBg.bottom - 45, 100, 45);
    dynamicToAlbum.backgroundColor = [UIColor clearColor];
    [dynamicToAlbum setImage:[UIImage imageNamed:@"Check-feed-2"] forState:UIControlStateNormal];
    [dynamicToAlbum setImage:[UIImage imageNamed:@"Check-feed"] forState:UIControlStateSelected];
    [dynamicToAlbum setTitle:@"同步到相册" forState:UIControlStateNormal];
    dynamicToAlbum.titleLabel.font = [UIFont systemFontOfSize:13];
    [dynamicToAlbum setTitleColor:[JYHelpers setFontColorWithString:@"#303030"] forState:UIControlStateNormal];
    [dynamicToAlbum addTarget:self action:@selector(_isDynamicToAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [enterBg addSubview:dynamicToAlbum];
    
   
    
    authSelectView = [[UIView alloc] initWithFrame:CGRectMake(-1, enterBg.bottom + 15, kScreenWidth + 2, 40)];
    authSelectView.backgroundColor = [UIColor whiteColor];
    authSelectView.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    authSelectView.layer.borderWidth = 1;
    [self.view addSubview:authSelectView];
    [authSelectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_goToSetPromission)]];
    
    UILabel * authTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 20)];
    authTitle.text = @"查看权限";
    authTitle.textAlignment = NSTextAlignmentLeft;
    authTitle.textColor = [JYHelpers setFontColorWithString:@"#303030"];
    authTitle.font = [UIFont systemFontOfSize:14];
    [authSelectView addSubview:authTitle];
    
    //更多箭头
    UIImageView * cityEditMore = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 23,13, 8, 13)];
    [cityEditMore setImage:[UIImage imageNamed:@"more_gray"]];
    cityEditMore.backgroundColor = [UIColor clearColor];
    [authSelectView addSubview:cityEditMore];
    
    allFriendTitle = [[UILabel alloc] initWithFrame:CGRectMake(authTitle.right, 10, cityEditMore.left -authTitle.right-10, 20)];
    allFriendTitle.text = @"所有朋友";
    allFriendTitle.textAlignment = NSTextAlignmentRight;
    allFriendTitle.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
    allFriendTitle.font = [UIFont systemFontOfSize:14];
    //allFriendTitle.backgroundColor = [UIColor redColor];
    [authSelectView addSubview:allFriendTitle];
    
    optionPhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kStatusBarHeight - kNavigationBarHeight, kScreenWidth, 217)];
    optionPhotoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionPhotoView];
    
    UIImageView *feedCameraImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
    feedCameraImg.image = [UIImage imageNamed:@"feedUseCamera"];
    feedCameraImg.userInteractionEnabled = YES;
    [optionPhotoView addSubview:feedCameraImg];
    [feedCameraImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useCamera)]];
    
    UIImageView *feedAlbumImg = [[UIImageView alloc] initWithFrame:CGRectMake(feedCameraImg.right + 15, 15, 80, 80)];
    feedAlbumImg.image = [UIImage imageNamed:@"feedUseAlbum"];
    feedAlbumImg.userInteractionEnabled = YES;
    [optionPhotoView addSubview:feedAlbumImg];
    [feedAlbumImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useAlbum)]];
    
    
    //从其它来进到发布动态，直接带上图片
    if(self.formId > 1 && self.picImage != nil){
        UIImage *newImg = [self fixOrientation:_picImage];
        JYLocalImageModel *imodel = [[JYLocalImageModel alloc] init];
        imodel.thumbnailImage = _picImage;
        imodel.fullScreenImage = newImg;
        imodel.imageUrl = @"1";
        [_tempImagesArrs addObject:imodel];
        // 上传生活照片请求
        [self _requestUploadImages];
        isSendText = @"1";
    }
}
- (void)TextOrPhoto:(UIButton *)sender{
    if (!sender.selected) {
        [self clickSendPic];
    }
    else{
        [self clickSendText];
    }
    sender.selected = !sender.selected;
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kConfirmSelectedImagesNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocalImageGroupToCameraNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFeedSetPromissionNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//alert代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//删除已上传的图片
- (void) _delDyPic:(UIGestureRecognizer *)gesture{
    NSInteger myTag = gesture.view.tag;
    NSInteger needDelNum = 0;
    for (int i = 0; i<picViewArr.count; i++) {
        UIImageView *temp = (UIImageView *) [picViewArr objectAtIndex:i];
        UIImageView *subtemp = (UIImageView *) [[temp subviews] objectAtIndex:1];
        if (subtemp.tag == myTag) {
            needDelNum = i;
            CGPoint picStartPosition = CGPointMake(0, 0);
            picStartPosition.x = temp.left;
            picStartPosition.y = temp.top;
            if (picViewArr.count > 1) {
                for (int j = i+1; j<picViewArr.count; j++) {
                    
                    
                    if (picStartPosition.x+60+picDistance>picShowDistrict.width ) {
                        picStartPosition.x = 0;
                        picStartPosition.y += 60+ picDistance;
                    }
                    UIImageView *tempxx = (UIImageView *) [picViewArr objectAtIndex:j];
                    tempxx.frame = CGRectMake(picStartPosition.x, picStartPosition.y, temp.width, temp.height);
                    picStartPosition.x += (60+ picDistance);
                }
                
                
                
            }
            [temp removeFromSuperview];
            break;
        }
//        if (needDelNum> 0 && i>needDelNum) {
//            UIImageView *tempxx = (UIImageView *) [picViewArr objectAtIndex:i-2];
//            temp.frame = CGRectMake(tempxx.right+10, tempxx.top, tempxx.width, tempxx.height);
//        }
        
    }
    [picViewArr removeObjectAtIndex:needDelNum];
    [_tempImagesArrs removeObjectAtIndex:needDelNum];
    [self measureLayerPostion];
    
    if (_uploadedPhotoCompleteCount != 0) {
        _uploadedPhotoCompleteCount--;
    }
   
    //当上传的照片小于0时，发送按钮变灰
    if (_uploadedPhotoCompleteCount == 0 && (textEditView.text.length==0 || [textEditView.text isEqualToString:@"说说最近有什么新鲜事？"])) {
        allowSend = NO;
        [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
    }
}



//添加，或删除图片后重新计算位置
- (void) measureLayerPostion{
    if (picViewArr.count > 0) {
        UIImageView *temp = (UIImageView *) [picViewArr lastObject];
        textEditView.height = 100;
        picShowDistrict.height = temp.bottom+10;
        picShowDistrict.frame = CGRectMake(textEditView.left, textEditView.bottom + 5, picShowDistrict.width, temp.bottom+ 10);
    }else{
        textEditView.height = 140;
        picShowDistrict.frame = CGRectMake(textEditView.left, textEditView.bottom + 5, picShowDistrict.width, 0);
    }
    
    cameraOrAlbum.origin = CGPointMake(cameraOrAlbum.left, picShowDistrict.bottom+5);
    sendText.origin = CGPointMake(sendText.left, picShowDistrict.bottom+5);
    dynamicToAlbum.origin = CGPointMake(dynamicToAlbum.left, picShowDistrict.bottom-10);
    enterBg.height = cameraOrAlbum.bottom + 10;
    authSelectView.origin = CGPointMake(authSelectView.left, enterBg.bottom + 10);

}

- (void)_clickLeftTopButton{
    [textEditView resignFirstResponder];
    [self dismissProgressHUDtoView:self.view];
    NSString *mysendText = [textEditView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ((![mysendText isEqualToString:@"说说最近有什么新鲜事？"] && mysendText.length > 0) || picViewArr.count>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"放弃发布动态?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)_clickRightTopButton{
    if (allowSend) {
        [self _lockBtnEnabel:NO];
        [self _sendDynamicToHttp];
    }
}

- (void)_isDynamicToAlbum:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        isDynamic = @"1";
    }
    else{
        sender.selected = NO;
        isDynamic = @"0";
    }
}

- (void)_sendDynamicToHttp{

    NSMutableString *myPids = [NSMutableString string];
    for (int i = 0; i<picViewArr.count; i++) {
        UIImageView *temp = (UIImageView *)[picViewArr objectAtIndex:i];
        UIImageView *tempsub = (UIImageView *) [[temp subviews] objectAtIndex:1];
        if(tempsub.tag  > 0){
            if (i == 0) {
                [myPids appendFormat:@"%ld",(long)tempsub.tag];
            }else{
                [myPids appendFormat:@",%ld",(long)tempsub.tag];
            }
        }
    }
    
    //如果是默认的字符，则为空。
    NSString *mysendText = [textEditView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([mysendText isEqualToString:@"说说最近有什么新鲜事？"]) {
        mysendText = @"";
    }
    
    //当是空串时，默认显示1，所有好友
    NSString * groupID = [myPermissionDic objectForKey:@"groupId"];
    if ([JYHelpers isEmptyOfString:groupID]) {
        groupID = @"1";
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"snsfeed" forKey:@"mod"];
    [parametersDict setObject:@"add_dynamic" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:isSendText forKey:@"type"];
    [postDict setObject:mysendText forKey:@"content"];
    [postDict setObject:myPids forKey:@"pids"];
    [postDict setObject:groupID forKey:@"group_id"];
    [postDict setObject:isDynamic forKey:@"is_photo"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        NSString *feedid = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"][@"feedid"]];
        if (iRetcode == 1) {
            if (isDynamic) {
                //刷新用户数据图片
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
            }
            [self _getDetailUser:feedid];
        }
        else{
            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        
    } failure:^(id error) {
        NSLog(@"%@", error);
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self _lockBtnEnabel:YES];
        
    }];
}
- (void)_getDetailUser:(NSString *)feedid{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"snsfeed" forKey:@"mod"];
    [parametersDict setObject:@"get_one_dynamic_info" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:feedid forKey:@"dy_id"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            JYFeedModel *feedModel  = [[JYFeedModel alloc] initWithDataDic:[responseObject objectForKey:@"data"]];
            
            //刷新feedlist
            if (self.refreshFeedListBlock) {
                self.refreshFeedListBlock(feedModel);
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:[responseObject objectForKey:@"retmean"]];
        }
        
        [self _lockBtnEnabel:YES];
    } failure:^(id error) {
        [self _lockBtnEnabel:YES];
        NSLog(@"%@", error);
    }];
}

- (void) clickSendPic{
    [self _picExpendOrPickUp:YES];
    [textEditView resignFirstResponder];
    if (textEditView.text.length == 0) {
        textEditView.text = @"说说最近有什么新鲜事？";
    }
}

- (void) clickSendText{
    [self _picExpendOrPickUp:NO];
    //要把上传过的图片全部清空
    //[picViewArr removeAllObjects];//为什么要清空
    [textEditView becomeFirstResponder];
}

- (void) useCamera{
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        [JYHelpers showAlertWithTitle:@"无法访问相机.请在'设置->隐私->相机'设置为打开状态"];
        return;
    }
    
    NSInteger imageCount = _picImage ? 8 : 9;
    if (picViewArr.count>=imageCount) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"最多上传9张照片"];
        return;
    }
    // 相机拍摄 2.1
    UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate =self;
    //cameraPicker.allowsEditing =YES;
    cameraPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:cameraPicker animated:YES completion:NULL];
    //[self _picExpendOrPickUp:NO];
}


-(BOOL)isCapturePermissionGranted{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }

    return YES;
}
// 从手机相册选择
- (void) useAlbum{
    
    if (![self isCapturePermissionGranted]) {
        //无法访问相册.请在'设置->定位服务'设置为打开状态.
        [JYHelpers showAlertWithTitle:@"无法访问相册.请在'设置->隐私->照片'设置为打开状态"];
        return;
    }
    
    NSInteger imageCount = _picImage ? 8 : 9;

    if (picViewArr.count>=imageCount) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"最多上传9张照片"];
        return;
    }
    // 3.2
    
    
    
    [self getImages];
    
    //[self _picExpendOrPickUp:NO];
}
- (void)getImages{

    JYGroupImagesController *controller = [[JYGroupImagesController alloc]init];
    controller.canUploadCount = 9-picViewArr.count;
    
    JYNavigationController *naviController = [[JYNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:naviController animated:YES completion:NULL];
    
}


//type 为yes时弹出，type为NO时收起
- (void) _picExpendOrPickUp:(BOOL) type{
    
    if (type) {
        NSInteger imageCount = _picImage ? 8 : 9;
        if (picViewArr.count>=imageCount) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"最多上传9张照片"];
            return;
        }
    }
    
    [UIView beginAnimations:@"toShowPariseAddOneLable" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    CGPoint point = optionPhotoView.origin;
    if (type) {
        
        point.y = kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 217;
        
    }else{
        point.y = kScreenHeight - kStatusBarHeight - kNavigationBarHeight;
    }
    optionPhotoView.origin = point;
    [UIView commitAnimations];
}

//选择完照片，点击确认时接收到的消息通知
- (void)confirmSelectedImages:(NSNotification *)notification
{
    for (JYLocalImageModel *localImageModel in [notification.userInfo objectForKey:@"images"])
    {
        BOOL isExist = NO; //照片是否存在于将要上传的照片中
        for (JYLocalImageModel *model in _tempImagesArrs) {
            if ([localImageModel.imageUrl isEqualToString:model.imageUrl]) {
                isExist = YES;
                break;
            }
        }
        
        if (isExist) {
            //不能上传相同的照片;
            [[JYAppDelegate sharedAppDelegate] showTip:@"不能上传重复的照片"];
        } else {
            if (_tempImagesArrs.count<=9) {
                [_tempImagesArrs addObject:localImageModel];
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:@"最多上传9张照片"];
            }
        }
    }
    
    [self _requestUploadImages];
}

- (void)localImageGroupToCameraAction:(NSNotification *)notification
{
    //    if (_tempImagesArrs.count < 4) {
    //        //[_toolBar.expressionBtn setSelected:YES];
    //
    //        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //        imagePickerController.delegate = self;
    //        [imagePickerController setAllowsEditing:YES];
    //        //弹出时 动画风格
    //        [imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    //        [self presentViewController:imagePickerController animated:YES completion:NULL];
    //    } else {
    //        [[JYAppDelegate sharedAppDelegate] showTip:@"最多只能添加4张图片"];
    //    }
}

#pragma mark - UIImagePickerController delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 3.1
//    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[_tempImagesArrs removeAllObjects];
    
    UIImage *newImg = [self fixOrientation:originalImage];
    JYLocalImageModel *imodel = [[JYLocalImageModel alloc] init];
    imodel.thumbnailImage = originalImage;
    imodel.fullScreenImage = newImg;
    imodel.imageUrl = @"1";
    [_tempImagesArrs addObject:imodel];
    
    // 上传生活照片请求
    [self _requestUploadImages];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)_lockBtnEnabel:(BOOL) enable{
    for (UIView *view in optionPhotoView.subviews) {
        view.userInteractionEnabled = enable;
    }
    navRightBtn.enabled = enable;
    navLeftBtn.enabled = enable;
}
// 上传生活照片
- (void)_requestUploadImages
{
    [self _lockBtnEnabel:NO];
    
    [self showProgressHUD:@"图片上传中..." toView:self.view];
   
    
    UIImage *image = nil;
    if (_uploadedPhotoCompleteCount<_tempImagesArrs.count) {
        image = ((JYLocalImageModel *)[_tempImagesArrs objectAtIndex:(_uploadedPhotoCompleteCount)]).fullScreenImage;
        
    } else {
        [self _lockBtnEnabel:YES];
        [self dismissProgressHUDtoView:self.view];
        return;
    }
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"picture" forKey:@"mod"];
    [parametersDict setObject:@"upload_photo" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:myuid forKey:@"uid"];
    
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData.length>2249) {
        imageData = UIImageJPEGRepresentation(image, 0.8);
    }
    
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:imageData forKey:@"upload"];
    __weak typeof(self) vc = self;
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict dataDict:dataDict formDict:nil success:^(id responseObject) {
        __strong typeof(vc) controller = vc;
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1 && [[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"pid"] isKindOfClass:[NSDictionary class]]) {
                [_tempImagesArrs removeAllObjects];
                [[JYAppDelegate sharedAppDelegate] showTip:@"上传失败"];
                [self _lockBtnEnabel:YES];
            }else{
                [controller addOnePhoto:[[[responseObject objectForKey:@"data"] objectForKey:@"pid"] intValue] picImage:image];
                
                NSLog(@"上传成功");
                [controller _requestUploadImages];
            }
            
            
            
        } else if (iRetcode == -3){
            [_tempImagesArrs removeAllObjects];
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片大小不正确（大小应为2KB-5MB）"];
            [self _lockBtnEnabel:YES];
        }
        else if (iRetcode == -4){
            [_tempImagesArrs removeAllObjects];
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片格式不正确（支持jpg/jpeg/png/gif）"];
            [self _lockBtnEnabel:YES];
        }
        else if (iRetcode == -5){
            [_tempImagesArrs removeAllObjects];
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片宽度尺寸不正确（尺寸应为100-5000px）"];
            [self _lockBtnEnabel:YES];
        }
        else if (iRetcode == -6){
            [_tempImagesArrs removeAllObjects];
            [[JYAppDelegate sharedAppDelegate] showTip:@"图片高度尺寸不正确（尺寸应为100-10000px）"];
            [self _lockBtnEnabel:YES];
        }
        else {
            [_tempImagesArrs removeAllObjects];
            [[JYAppDelegate sharedAppDelegate] showTip:@"上传失败"];
            [self _lockBtnEnabel:YES];
        }
        
        
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        [self _lockBtnEnabel:YES];
        NSLog(@"%@", error);
        [self dismissProgressHUDtoView:self.view];
    }];
}


- (void) addOnePhoto:(int)pid  picImage:(UIImage *) picImage{
    NSUInteger _currentNum = picViewArr.count;
    
    //计算图片之前的间距，
    
    CGPoint picStartPosition = CGPointMake(0, 0);

    if (_currentNum> 0) {
        UIImageView *lastImage = [picViewArr lastObject];
        picStartPosition.x = lastImage.right+ picDistance;
        picStartPosition.y = lastImage.top;
        if (picStartPosition.x+50>picShowDistrict.width ) {
            picStartPosition.x = 0;
            picStartPosition.y += 60+ picDistance;
        }
    }
    
    UIImageView *picShowBg = [[UIImageView alloc] initWithFrame:CGRectMake(picStartPosition.x, picStartPosition.y, 60, 60)];
    picShowBg.backgroundColor = [UIColor clearColor];
    picShowBg.userInteractionEnabled = YES;
    [picShowDistrict addSubview:picShowBg];
    
    UIImageView *picShowOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 50)];
    picShowOne.clipsToBounds = YES;
    picShowOne.contentMode = UIViewContentModeScaleAspectFill;
    picShowOne.image        = picImage;
    [picShowBg addSubview:picShowOne];

    
    UIImageView *picShowDel = [[UIImageView alloc] initWithFrame:CGRectMake(30, 1, 28, 28)];
    picShowDel.tag = pid;
    [picShowBg addSubview:picShowDel];
    picShowDel.userInteractionEnabled = YES;
    
    UIImageView *deleBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 18, 18)];
    deleBtnImage.image        = [UIImage imageNamed:@"feedPicDelBtn"];
    [picShowDel addSubview:deleBtnImage];
    
    [picShowDel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_delDyPic:)]];
    
    [picViewArr addObject:picShowBg];
    
    //只要有上传的成功的图片，右上角发送点亮
    _uploadedPhotoCompleteCount++;
    if (_uploadedPhotoCompleteCount>=8) {
        [self _picExpendOrPickUp:NO];
    }
    allowSend = YES;
    [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
    
    [self measureLayerPostion];
}


// 旋转图片在上传
- (UIImage *)fixOrientation:(UIImage * )imag
{
    // No-op if the orientation is already correct
    if (imag.imageOrientation == UIImageOrientationUp) return imag;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imag.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, imag.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imag.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:break;
    }
    
    switch (imag.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imag.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, imag.size.width, imag.size.height,
                                             CGImageGetBitsPerComponent(imag.CGImage), 0,
                                             CGImageGetColorSpace(imag.CGImage),
                                             CGImageGetBitmapInfo(imag.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imag.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.height,imag.size.width), imag.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imag.size.width,imag.size.height), imag.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self _picExpendOrPickUp:NO];
    if ([textView.text isEqualToString:@"说说最近有什么新鲜事？"]) {
        textView.text = @"";
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}


//只有在内容改变时才触发，而且这个改变内容是手动输入有效，用本例中得按钮增加内容不触发这个操作
- (void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *context = textView.text;
    if (!context) {
        context = @"";
    }
    NSLog(@"----->%@",context);
    if (context.length > 1000) {
        textView.text = [textView.text substringToIndex:1000];
        [[JYAppDelegate sharedAppDelegate] showTipTop:@"最多输入1000字"];
    }
    
    //解决光标bug
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        [textView setContentOffset:offset];
    }
    NSString *str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ((str.length>0 && ![str isEqualToString:@"说说最近有什么新鲜事？"]) || picViewArr.count > 0) {
        [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        allowSend = YES;
    }else{
        [navRightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
        allowSend = NO;
    }
}
//几乎所有操作都会触发textViewDidChangeSelection，包括点击文本框、增加内容删除内容
//可以理解为只要于selectedRange有关都会触发，（位置与长度）
- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"Did Change Selection");
}

//一看是BOOL，不是YES就是NO，就是允许修改内容
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
//        if ([textView.text isEqualToString:@""]) {
//            textView.text = @"说说最近有什么新鲜事？";
//        }
//        //在这里做你响应return键的代码
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//    }
    
    
    
    return YES;
}

- (void)_goToSetPromission{
    if (!self.promissionVC) {
        _promissionVC = [[JYFeedPromissionController alloc] init];
    }
    
    [self.navigationController pushViewController:_promissionVC animated:YES];
}

//
- (void)_setPromissionNotification:(NSNotification *)noti {
    myPermissionDic  = noti.userInfo;
    NSString *titleStr = [myPermissionDic objectForKey:@"title"];
    if ([JYHelpers isEmptyOfString:titleStr]) {
        allFriendTitle.text = @"所有好友";
    }else{
        allFriendTitle.text = titleStr;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
