//
//  TJSendTopical ViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSendTopicalViewController.h"
#import "TJPictureView.h"
#import "TJTopicViewModel.h"


#define SHEAR_IMAHE_WIDTH   (320)
#define SHEAR_IMAGE_HEIGHT  (320)
@interface TJSendTopicalViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TJPictureViewDelegate>
{
    UIButton *btnCarmer;
    UIButton *btnPhoto;
    UITextView  *topicTextView;
    UITextView  *contentTextView;
    UILabel     *lblHolder;
    UILabel     *lblContent;
    UILabel     *imgNum;
    UIView      *bottomView;
    UIScrollView *scrollView;
    TJPictureView *pictureView;
    BOOL         isUploadImg;
    BOOL         isKeyBoard;
    BOOL         isContext;
    BOOL         isBottom;
    
    
}

@property (nonatomic, strong) TJBBSCateSubModel *cateModel;
@property (nonatomic, strong) TJTopicViewModel *viewModel;
@property (nonatomic, strong) UIImagePickerController *pickerVC;
@property (nonatomic, strong) UIImage         *editedImage;
@property (nonatomic, strong) NSMutableArray  *imagDatas;
@end

@implementation TJSendTopicalViewController

- (instancetype)initWithItem:(TJBBSCateSubModel *)item
{
    self = [super init];
    if (self) {
        self.cateModel = item;
        self.hidesBottomBarWhenPushed = YES;
        isBottom = YES;
        _viewModel = [[TJTopicViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imagDatas = [[NSMutableArray alloc] init];
    [self buildUI];
    [self handleKeyboard];
    [self initImagePicker];
}

- (void)initImagePicker
{
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.allowsEditing = YES;
    _pickerVC.delegate = self;
}

- (void)initialNaviBar
{
    
    [self.naviController setNaviBarTitle:@"发表主题"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    //    UIImage *leftImg = [UIImage imageNamed:@"navi_back"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 40,40)];
    @weakify(self)
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:@"发帖" imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        [self.viewModel postTopicBBSAddTieba:self.cateModel.subID andUserId:UserManager.userInfor.userId withTitle:self->topicTextView.text withFont:self->contentTextView.text withPalce:nil withimageFile:self.imagDatas andFinishBlock:^(NSArray *results) {
            
        } andFaileBlock:^(NSString *error) {
            
        }];
        
        
    }];
    [self.naviController setNaviBarRightBtn:rightBtn];
}

- (void)buildImageUI
{
    if (!pictureView) {
         pictureView = [[TJPictureView alloc] initWithFrame:CGRectMake(0, bottomView.frame.size.height + bottomView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - bottomView.frame.size.height - bottomView.frame.origin.y)];
        pictureView.delegate = self;
        [self.view addSubview:pictureView];
    }
   
    pictureView.hidden = NO;
    [pictureView setBackgroundColor:[UIColor whiteColor]];
}
- (void)clearImageUI
{
    pictureView.hidden = YES;
    [pictureView removeFromSuperview];
    pictureView = nil;
}


- (void)buildUI
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 45, SCREEN_WIDTH, 45)];
    [bottomView setBackgroundColor:COLOR(244, 245, 249, 1)];
    [self.view addSubview:bottomView];
    btnCarmer = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCarmer setFrame:CGRectMake(10, 2, 40, 40)];
    [btnCarmer setImage:[UIImage imageNamed:@"luntan_fatie_zhaoxiang_"] forState:UIControlStateNormal];
    @weakify(self)
    [[btnCarmer rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        self->isUploadImg = YES;
        [self.view endEditing:NO];
        
        [self gainPhotoFromCamera];
        if (isBottom) {
            
            @weakify(self)
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                CGRect bframe = self->bottomView.frame;
                    isBottom = NO;
                    bframe.origin.y = 315 *SCREEN_PHISICAL_SCALE;
                    self->bottomView.frame=bframe;
                    [self buildImageUI];
                    [pictureView refresPictureView:self.imagDatas];
            
                
            } completion:nil];

        }
        
    }];
    [bottomView addSubview:btnCarmer];
    
    btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoto setFrame:CGRectMake(btnCarmer.frame.size.width +btnCarmer.frame.origin.x +10, 2, 40, 40)];
    [btnPhoto setImage:[UIImage imageNamed:@"luntan_fatie_xiangce_"] forState:UIControlStateNormal];
    [[btnPhoto rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self->isUploadImg = YES;
        [self.view endEditing:NO];
        [self gainPhotoFromPhotogallery];
        if (isBottom) {
            
            @weakify(self)
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self)
                CGRect bframe = self->bottomView.frame;
                isBottom = NO;
                bframe.origin.y = 315 *SCREEN_PHISICAL_SCALE;
                self->bottomView.frame=bframe;
                [self buildImageUI];
                [pictureView refresPictureView:self.imagDatas];
                
                
            } completion:nil];
            
        }
        
    }];
    [bottomView addSubview:btnPhoto];
   
    imgNum = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.frame.size.width - 40 -20, 10, 25, 25)];
    [imgNum.layer setMasksToBounds:YES];
    imgNum.layer.cornerRadius = imgNum.frame.size.width/2;
    [imgNum setBackgroundColor:[UIColor redColor]];
    [imgNum setTextColor:[UIColor whiteColor]];
    [imgNum setTextAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:imgNum];
    self->imgNum.hidden = YES;
    
//    [[RACObserve(self, imagDatas) filter:^BOOL(NSArray *value) {
//        
//        return value.count != 0;
//    }] subscribeNext:^(NSArray *value) {
//        @strongify(self)
//       
//    }];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - bottomView.frame.size.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:scrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    topicTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 44)];
    topicTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [topicTextView setFont:[UIFont systemFontOfSize:18]];
    [[topicTextView layoutManager] usedRectForTextContainer:[topicTextView textContainer]];
    topicTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    topicTextView.scrollEnabled = NO;
    topicTextView.returnKeyType = UIReturnKeyNext;
    topicTextView.delegate = self;
    [scrollView addSubview:topicTextView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topicTextView.frame.size.height - 5, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [scrollView addSubview:lineView];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, lineView.frame.size.height +lineView.frame.origin.y, SCREEN_WIDTH - 10, scrollView.frame.size.height - lineView.frame.size.height -lineView.frame.origin.y)];
//    [contentTextView setBackgroundColor:[UIColor redColor]];
    contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [contentTextView setFont:[UIFont systemFontOfSize:18]];
    [[contentTextView layoutManager] usedRectForTextContainer:[contentTextView textContainer]];
    contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    contentTextView.scrollEnabled = NO;
    contentTextView.returnKeyType = UIReturnKeyDefault;
    contentTextView.delegate = self;
    [scrollView addSubview:contentTextView];
    
    lblHolder = [[UILabel alloc] init];
    lblHolder.frame =CGRectMake(10, 0, 60, 36);
    lblHolder.text = @"标题";
    [lblHolder setTextAlignment:NSTextAlignmentLeft];
    [lblHolder setTextColor:[UIColor grayColor]];
    lblHolder.enabled = NO;
    lblHolder.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:lblHolder];
    
    lblContent = [[UILabel alloc] init];
    lblContent.frame =CGRectMake(10, contentTextView.frame.origin.y, 150, 36);
    lblContent.text = @"请输入帖子内容";
    [lblContent setTextAlignment:NSTextAlignmentLeft];
    [lblContent setTextColor:[UIColor grayColor]];
    lblContent.enabled = NO;
    lblContent.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:lblContent];
    
    [self.view addSubview:bottomView];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviController.navigationBarHidden = NO;
    [self initialNaviBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    isKeyBoard = YES;
    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        @strongify(self)
//        if (!isKeyBoard) {
            CGRect sendBtnFrame=self->bottomView.frame;
            sendBtnFrame.origin.y=self.view.bounds.size.height-keyboardHeight-sendBtnFrame.size.height;
            self->bottomView.frame=sendBtnFrame;
//        }
    } completion:nil];
   
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    isKeyBoard = NO;
    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        @strongify(self)
        CGRect bframe = self->bottomView.frame;
        if (self->isUploadImg) {
            isBottom = NO;
            bframe.origin.y = 315 *SCREEN_PHISICAL_SCALE;
            self->bottomView.frame=bframe;
            TLog(@"%@",NSStringFromCGRect(bframe));
            [self buildImageUI];
            [pictureView refresPictureView:self.imagDatas];
        }
        else{
            isBottom = YES;
            bframe.origin.y = SCREEN_HEIGHT  - self->bottomView.frame.size.height;
            self->bottomView.frame=bframe;
            [self clearImageUI];
        }
        
    } completion:nil];
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == topicTextView) {
        if (textView.text.length == 0) {
            lblHolder.hidden = NO;
            lblHolder.text = @"标题";
        }else{
            lblHolder.hidden = YES;
            lblHolder.text = @"";
        }
    }
    else if (textView == contentTextView)
    {
        if (textView.text.length == 0) {
            lblContent.hidden = NO;
            lblContent.text = @"请输入帖子内容";
        }else{
            lblContent.hidden = YES;
            lblContent.text = @"";
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == topicTextView) {
        isContext = NO;
        btnCarmer.enabled = btnPhoto.enabled = NO;
    }
    else if (textView == contentTextView)
    {
        isContext = YES;
        btnCarmer.enabled = btnPhoto.enabled = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView == topicTextView) {
        if ([text isEqualToString:@"\n"]) {
            
            [contentTextView becomeFirstResponder];
            return NO;
        }
        
    }
    
    
    return YES;
}

-(BOOL)textViewShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    isUploadImg = NO;
    //隐藏键盘
    [self.view endEditing:NO];
    
    if (!isKeyBoard) {
        [self clearImageUI];
        isBottom = YES;
        @weakify(self)
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            CGRect bframe = self->bottomView.frame;
            bframe.origin.y =  SCREEN_HEIGHT  - self->bottomView.frame.size.height;
            self->bottomView.frame=bframe;
        } completion:nil];
    }
    
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
- (UIImage *)imageTelescopicToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    
    [self.editedImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
- (NSData *)imageTransformData:(UIImage *)image
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    else{
        data = UIImagePNGRepresentation(image);
    }
    
    return data;
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
        self.editedImage = image;
        
        self.editedImage = [self imageTelescopicToSize:CGSizeMake(SHEAR_IMAHE_WIDTH, SHEAR_IMAGE_HEIGHT)];
    }
    
    @weakify(self);
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        NSData *data = [self imageTransformData:self.editedImage];
        if (![self.imagDatas containsObject:data]) {
            
            [self.imagDatas addObject:data];
            self->imgNum.hidden = NO;
            [self->imgNum setText:[NSString stringWithFormat:@"%ld",(long)self.imagDatas.count]];
        }
        
        [self->pictureView refresPictureView:self.imagDatas];
        
        
    }];
    
}

- (void)setImagDatas:(NSMutableArray *)imagDatas
{
    _imagDatas = imagDatas;
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)removeImageView:(int)index
{
    [self.imagDatas removeObjectAtIndex:index];
    [pictureView refresPictureView:self.imagDatas];
}

@end
