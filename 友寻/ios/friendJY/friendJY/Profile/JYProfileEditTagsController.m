//
//  JYProfileEditTagsController.m
//  friendJY
//
//  Created by ouyang on 3/19/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileEditTagsController.h"
#import "JYShareData.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYProfileAddTagController.h"
#import "JYProfileTagListView.h"
#import "Toast+UIView.h"
#import "JYProfileTagModel.h"
//#import "friendJY-swift.h"

@interface JYProfileEditTagsController (){
    NSMutableDictionary *myTagListDic;
    JYProfileTagListView *tagListView;
    JYRecommendTagView *recommendTagView;
    
    UIView *sectionSeven;
    UIView *anotherSection;
    
    UILabel *giveHimTagLabel;
//    UILabel *tagBottomRightLabel;
    
    UILabel *tagCountLabel;
    UILabel *deleteTagCountLabel;
    UIScrollView *tagScrollView;
    
    JYRecommendTagButton *recommendButton;
    UIView *line;
    //所有的推荐标签
    NSMutableArray *sourceRecommendTagArr;
    //自己已添加的标签title
    NSMutableArray *sourceTagTitleArr;
    //当前显示的推荐标签
    NSMutableArray *showRecommendTagTitles;
}

@end

@implementation JYProfileEditTagsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"标签"];
    // Do any additional setup after loading the view.
    myTagListDic = [NSMutableDictionary dictionary];
    sourceRecommendTagArr = [NSMutableArray array];
    
    //判断self.tagdici不是可变dictionary，退出
    if(![self.tagDic  isKindOfClass:[NSMutableDictionary class]]){
        [[JYAppDelegate sharedAppDelegate] showTip:@"标签字典类型不正确"];
        return;
    }
   
    for (NSString * temp  in self.tagDic) {
        [myTagListDic setObject:[[NSMutableDictionary alloc] initWithDictionary:[self.tagDic objectForKey:temp]] forKey:[[self.tagDic objectForKey:temp] objectForKey:@"tid"]];
    }
    
    [self setTagTitles];
    
    tagScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [tagScrollView setShowsHorizontalScrollIndicator:NO];
    [tagScrollView setShowsVerticalScrollIndicator:NO];
//    [tagScrollView setScrollEnabled:YES];
    [self.view addSubview:tagScrollView];
    
    sectionSeven = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 200)];
    sectionSeven.backgroundColor = [UIColor whiteColor];
    sectionSeven.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    sectionSeven.layer.borderWidth = 1;
    [tagScrollView addSubview:sectionSeven];
    
    //标签
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 20)];
    tagLabel.textAlignment = NSTextAlignmentLeft;
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    tagLabel.font = [UIFont systemFontOfSize:15];
    tagLabel.text = @"我的标签";
    [sectionSeven addSubview:tagLabel];
    
    
    //加载标签
    CGPoint startPostion = CGPointMake(tagLabel.left, tagLabel.bottom+20);
    tagListView = [[JYProfileTagListView alloc] initUiView:_show_uid width:kScreenWidth-30 startPosition:startPostion tagList:myTagListDic isAllowDelTag:YES isAllowClickTag:NO isContactsTag:NO];
    [tagScrollView addSubview:tagListView];
//    [tagListView setUid:_show_uid];
    NSLog(@"%f",tagListView.height);

    tagCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, tagLabel.bottom+20+tagListView.height, 130, 20)];
//    tagCountLabel.textAlignment = NSTextAlignmentLeft;
    tagCountLabel.backgroundColor = [UIColor clearColor];
    tagCountLabel.textColor = [JYHelpers setFontColorWithString:@"#848484"];
    tagCountLabel.font = [UIFont systemFontOfSize:15];
    [sectionSeven addSubview:tagCountLabel];
    [self tagCountStr:myTagListDic];
    
    
    deleteTagCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(tagCountLabel.right + 30, tagCountLabel.top, tagCountLabel.width, 20)];
    [deleteTagCountLabel setBackgroundColor:[UIColor clearColor]];
    [deleteTagCountLabel setTextColor:[UIColor redColor]];
    [deleteTagCountLabel setText:@"已删除 0 个标签"];
    [deleteTagCountLabel setFont:[UIFont systemFontOfSize:15]];
    [sectionSeven addSubview:deleteTagCountLabel];
    
    sectionSeven.size = CGSizeMake(kScreenWidth, tagCountLabel.bottom+10);
    
    
    anotherSection = [[UIView alloc] initWithFrame:CGRectMake(0, sectionSeven.bottom + 44, kScreenWidth, 200)];
    [anotherSection setBackgroundColor:[UIColor whiteColor]];
    anotherSection.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    anotherSection.layer.borderWidth = 1;
    [tagScrollView addSubview:anotherSection];
    
    
    UILabel *recommendTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 20)];
    [recommendTagLabel setText:@"推荐标签"];
    [recommendTagLabel setTextColor:kTextColorGray];
    [recommendTagLabel setFont:[UIFont systemFontOfSize:15]];
    [anotherSection addSubview:recommendTagLabel];
    
    UIButton *changeRecommendTagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeRecommendTagBtn setFrame:CGRectMake(kScreenWidth - 15 - 60, recommendTagLabel.top, 60, recommendTagLabel.height)];
    [changeRecommendTagBtn setTitle:@"换一批" forState:UIControlStateNormal];
    [changeRecommendTagBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [changeRecommendTagBtn setShowsTouchWhenHighlighted:YES];
    [changeRecommendTagBtn setTag:54321];
    [changeRecommendTagBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [changeRecommendTagBtn setBackgroundColor:[UIColor clearColor]];
    [changeRecommendTagBtn addTarget:self action:@selector(relayoutRecommendTagView) forControlEvents:UIControlEventTouchUpInside];
    [anotherSection addSubview:changeRecommendTagBtn];
    
    recommendTagView = [[JYRecommendTagView alloc] initWithFrame:CGRectMake(10, recommendTagLabel.bottom, kScreenWidth-20, anotherSection.height-recommendTagLabel.bottom-30-5)];
    [recommendTagView myLayoutSubviews:[NSArray array]];
    __weak typeof(self) weakSelf = self;
    [recommendTagView setClickHandler:^(NSString * __nonnull str) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addRecommendTag:str];
        
    }];
    [self requestGetRecommendTags];
    
    recommendTagView.showsHorizontalScrollIndicator = NO;
    recommendTagView.showsVerticalScrollIndicator = NO;
    [anotherSection addSubview:recommendTagView];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(15.0, recommendTagView.bottom+20, kScreenWidth-15.0, 1)];
    line.layer.borderWidth = 1;
    line.layer.borderColor = [kTextColorLightGray CGColor];
    [anotherSection addSubview:line];
    
    recommendButton = [[JYRecommendTagButton alloc] initWithFrame:CGRectMake(15, line.bottom + 20, 90, 30) aTitle:@"手动添加"];
    
    [anotherSection addSubview:recommendButton];
    [anotherSection setHeight:recommendButton.bottom+20];
    
    [recommendButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagLabelGesture)]];
    
    [tagScrollView setContentSize:CGSizeMake(kScreenWidth, anotherSection.bottom + 20)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileEditTagNotification:) name:kProfileEditTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileDelTagNotification:) name:kProfileDelLocalTagDicNotification object:nil];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileEditTagsNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProfileDelLocalTagDicNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重新配置显示的推荐标签
- (void)relayoutRecommendTagView{
   //清空当前显示标签
    [showRecommendTagTitles removeAllObjects];
    if (showRecommendTagTitles == nil) {
        showRecommendTagTitles = [NSMutableArray array];
    }
    
    //清除推荐标签中和用户已添加标签重复的标签
    [sourceRecommendTagArr removeObjectsInArray:sourceTagTitleArr];

    //如果本身给的推荐标签数目小于6 直接全显示了。
    if (sourceRecommendTagArr.count <= 6) {
        [showRecommendTagTitles addObjectsFromArray:sourceRecommendTagArr];
        //清除换一批按钮
        UIView *btnView = [anotherSection viewWithTag:54321];
        if (btnView) {
            [btnView removeFromSuperview];
        }
    }else{
        //推荐标签大于6个  随机抽取6个
        while (showRecommendTagTitles.count < 6) {
            
            NSInteger i = arc4random()%sourceRecommendTagArr.count;
            NSString *tagTitle = sourceRecommendTagArr[i];
            
            if (![showRecommendTagTitles containsObject:tagTitle]) {
                [showRecommendTagTitles addObject:tagTitle];
            }
        }
    
    }
    //刷新
    [recommendTagView myLayoutSubviews:showRecommendTagTitles];
    [self adjustFrameOfSubviews];
}

//推荐标签刷新以后调整self.view的子视图
- (void)adjustFrameOfSubviews{
    
    [line setFrame:CGRectMake(15.0, recommendTagView.bottom+20, kScreenWidth-15.0, 1)];
    [recommendButton setOrigin:CGPointMake(15, line.bottom+20)];
    [anotherSection setHeight:recommendButton.bottom+20];
    [tagScrollView setContentSize:CGSizeMake(kScreenWidth, anotherSection.bottom + 20)];
    

}
#pragma mark - Request
- (void)requestGetRecommendTags{
//    public array() alternative_tag_list(int sex)
//    获取备选标签列表
//Parameters:
//    sex - 1 男 0 女
    [self showProgressHUD:@"获取中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"tags",
                              @"func":@"alternative_tag_list"
                              };
    NSDictionary *postDic = @{
                              @"sex":[JYShareData sharedInstance].myself_profile_model.sex
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        [self dismissProgressHUDtoView:self.view];
        if (iRetcode == 1) {
            //do any addtion here...
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
                NSMutableArray *arr = [NSMutableArray array];
                [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    NSString *tagTitle = [obj objectForKey:@"title"];
                    BOOL isAdded = NO;
                    for (NSString *key in myTagListDic.allKeys) {
                        if ([[[myTagListDic objectForKey:key] objectForKey:@"title"] isEqualToString:tagTitle]) {
                            isAdded = YES;
                            break;
                        }
                    }
                    if (!isAdded && ![JYHelpers isEmptyOfString:tagTitle]) {
                        [arr addObject:tagTitle];
                    }
                }];
                [sourceRecommendTagArr addObjectsFromArray:arr];
                [self relayoutRecommendTagView];
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"获取失败"];
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
- (void)requestAddTag:(NSString*)tagTitle{
    
    for (NSString *key in myTagListDic.allKeys) {
        if ([[[myTagListDic objectForKey:key] objectForKey:@"title"] isEqualToString:tagTitle]) {
            [[JYAppDelegate sharedAppDelegate] showTip:[NSString stringWithFormat:@"%@标签已添加",tagTitle]];
            return;
        }
    }
    [self showProgressHUD:@"添加中..." toView:self.view];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"tags" forKey:@"mod"];
    [parametersDict setObject:@"add_tag" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:_show_uid forKey:@"uid"];
    [postDict setObject:tagTitle forKey:@"add_tag"];
    
    NSLog(@"tagTitle --》 %@",tagTitle);
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //[[JYAppDelegate sharedAppDelegate] showTip:@"添加成功"];
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *aTagDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                [aTagDic setObject:@"0" forKey:@"bind"];
                [aTagDic setObject:@"0" forKey:@"oper"];
                NSTimeInterval ctime = [[NSDate date] timeIntervalSince1970];
                [aTagDic setObject:[NSString stringWithFormat:@"%ld",(long)ctime] forKey:@"ctime"];
                JYProfileTagModel *tagModel = [[JYProfileTagModel alloc] initWithDataDic:aTagDic];
                [myTagListDic setObject:tagModel.modelToDictionary forKey:tagModel.tid];

                [tagListView addOneTagResetList:myTagListDic];
                [self tagCountStr:myTagListDic];
                [self setTagTitles];
                [self replaceTagTitle:tagTitle];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshProfileInfoNotification object:nil];
                //添加成功发出一个首页刷新的通知， 刷新出添加标签的动态
                [[NSNotificationCenter defaultCenter] postNotificationName:kDynamicListRefreshTableNotify object:nil userInfo:nil];
                
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"添加失败"];
            }
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"添加失败"];
        }
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
#pragma mark - Click Handler
- (void)addTagLabelGesture{
    //JYProfileAddTagController * _albumVC = [[JYProfileAddTagController alloc] init];
    //[self.navigationController pushViewController:_albumVC animated:YES];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"添加标签"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定",nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[av textFieldAtIndex:0] addTarget:self action:@selector(TextFidChangedAction:) forControlEvents:UIControlEventEditingChanged];
    [av show];
    
}
//点击推荐标签
- (void)addRecommendTag:(NSString*)str{
    NSLog(@"recommend tag is %@",str);
    
    [self requestAddTag:str];
}

- (void)backAction
{
    //    [super backAction];
    if (tagListView.delTagArr.count == 0) {
        [super backAction];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"本次将删除%ld个标签，是否继续？",(long)tagListView.delTagArr.count] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:4321];
        [alertView show];
    }
    //tagListView = nil;
}

#pragma mark - Delegate
//点击添加时，弹出可输入的alert
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 4321) {
        if (buttonIndex == 1) {
            [tagListView delTagPostHttp];
            [super backAction];
        }
        
        return;
    }
    //点击确定才有的操作
    if (buttonIndex == 1) {
        UITextField *myField =  [alertView textFieldAtIndex:0];
//        if (myField.text.length == 0) {
//            [[JYAppDelegate sharedAppDelegate] showTip:@"标签内容为空"];
//            return;
//        }
        NSMutableString *mutStr = [NSMutableString stringWithString:myField.text];
//        NSString *text = myField.text;
        NSRange range = [mutStr rangeOfString:@" "];
        while (range.location != NSNotFound) {
            [mutStr deleteCharactersInRange:range];
            range = [mutStr rangeOfString:@" "];
        }
        if (mutStr.length == 0) {
            [[JYAppDelegate sharedAppDelegate] showTip:@"请输入标签内容"];
            return;
        }
        
        [self requestAddTag:myField.text];
    }
}


- (void)tagCountStr:(NSMutableDictionary *)myDic{
    //计算数字长度，最多999个标签
    int tagStartLen = 1;
    if(myDic.count>9 && myDic.count < 100){
        tagStartLen =2 ;
    }
    if(myDic.count>99 ){
        tagStartLen =3 ;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共 %ld 个标签",(long)myDic.count]];
    [str addAttribute:NSForegroundColorAttributeName value:[JYHelpers setFontColorWithString:@"#2695ff"] range:NSMakeRange(2, tagStartLen)];
    tagCountLabel.attributedText = str;
}

- (void) _tagCountString:(NSArray *)aArray{
    
    [deleteTagCountLabel setText:[NSString stringWithFormat:@"已删除 %ld 个标签",(long)aArray.count]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//
- (void)TextFidChangedAction:(UITextField*)textField{
    
    bool isChinese;//判断当前输入法是否是中文
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    [textField setClipsToBounds:NO];
//    CGPoint prompPoint = CGPointMake(textField.width/2, textField.height/2);
//    NSValue *pointValue = [NSValue valueWithCGPoint:prompPoint];
    NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSLog(@"汉字");
            if ( str.length>=11) {
//                [textField makeToast:@"最多输入10个汉字" duration:1.0 position:pointValue];
                [textField makeToast:@"最多输入10个汉字" duration:1 position:[NSValue valueWithCGPoint:CGPointMake(textField.width/2, 14)]];

                NSString *strNew = [NSString stringWithString:str];
                [textField setText:[strNew substringToIndex:10]];
            }
        }
        else
        {
            NSLog(@"输入的英文还没有转化为汉字的状态");
            
        }
    }else{
        NSLog(@"str=%@; 本次长度=%ld",str,(long)[str length]);
        if ([str length]>=11) {
            [textField makeToast:@"最多输入10个汉字" duration:1 position:[NSValue valueWithCGPoint:CGPointMake(textField.width/2, 14)]];
            NSString *strNew = [NSString stringWithString:str];
            [textField setText:[strNew substringToIndex:10]];
        }
    }
}
//对标签进行了，计数加1的点击操作
- (void)profileEditTagNotification:(NSNotification*)note
{
    myTagListDic = (NSMutableDictionary *)note.userInfo;
    
    [tagCountLabel setOrigin:CGPointMake(15, tagListView.bottom)];
    [deleteTagCountLabel setOrigin:CGPointMake(tagCountLabel.right + 30, tagCountLabel.top)];
    sectionSeven.size = CGSizeMake(kScreenWidth, tagCountLabel.bottom+10);
    [anotherSection setTop:sectionSeven.bottom+44];
    [tagScrollView setContentSize:CGSizeMake(kScreenWidth, anotherSection.bottom+20)];
    //[self _getProfileInfo];
}

//对标签进行了，删除操作
- (void)profileDelTagNotification:(NSNotification*)note
{
    [self _tagCountString:(NSArray *)note.object];
    
}
#pragma mark - set && get
//设置已添加标签的标签title数组，用于判断推荐标签和添加的标签是否已经添加
- (void)setTagTitles{
    
    [sourceTagTitleArr removeAllObjects];
    if (sourceTagTitleArr == nil) {
        sourceTagTitleArr = [NSMutableArray array];
    }
    
    for (NSDictionary *dic in myTagListDic.allValues) {
        [sourceTagTitleArr addObject:[dic objectForKey:@"title"]];
    }
}

//成功添加标签后调用，用于清除当前显示推荐标签中的和添加标签相同的标签并替换。
- (void)replaceTagTitle:(NSString*)tagTitle{
    //不在显示的推荐标签中不做任何操作
    if (![showRecommendTagTitles containsObject:tagTitle]) {
        return;
    }
    
    //如果源推荐标签小于6个，找不到新的来替换，直接删除
    if (sourceRecommendTagArr.count <= 6) {
        
        [showRecommendTagTitles removeObject:tagTitle];
        [recommendTagView myLayoutSubviews:showRecommendTagTitles];
        [self adjustFrameOfSubviews];
        //清除换一批按钮
        UIView *btnView = [anotherSection viewWithTag:54321];
        if (btnView) {
            [btnView removeFromSuperview];
        }
        
    }else{
        //源推荐标签大于6个 则找一个新的来替换已经添加的标签
        if ([showRecommendTagTitles containsObject:tagTitle]) {
            while (1) {//找到新标签后break
                NSString *aTagTitle = [sourceRecommendTagArr objectAtIndex:arc4random()%sourceRecommendTagArr.count];
                if (![showRecommendTagTitles containsObject:aTagTitle]) {
                    NSInteger index = [showRecommendTagTitles indexOfObject:tagTitle];
                    [showRecommendTagTitles replaceObjectAtIndex:index withObject:aTagTitle];
                    break;
                }
            }
            //刷新recommendTagView
            [recommendTagView myLayoutSubviews:showRecommendTagTitles];
            //调整控制器中的视图
            [self adjustFrameOfSubviews];
        }
    }
    
}
@end
