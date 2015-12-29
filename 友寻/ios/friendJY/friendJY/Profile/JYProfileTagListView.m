//
//  JYProfileTagListView.m
//  friendJY
//
//  Created by ouyang on 3/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileTagListView.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYProfileData.h"
#import "JYProfileTagModel.h"
#import "friendJY-swift.h"

@implementation JYProfileTagListView{
    CGPoint startPosition;
    NSString * show_uid;
   
    NSInteger mywidth;
    CGPoint originalPosition;
    
    BOOL allowDelTag;
    BOOL allowClickTag;
    BOOL _isContactTag;
    
    NSString *numLableColor; //标签数字要显示的背景色
    NSString *textLableColor;//标签内容要显示的背景色
    UIColor *deleteBgViewColor;
}
@synthesize delTagArr;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDefaultAttribute:(NSString*)uid width:(CGFloat)width tagList:(NSDictionary*)tagList oringinal:(CGPoint)sp{
    self.clipsToBounds = YES;
    delTagArr = [NSMutableArray array];
    _isContactTag = YES;
    // Initialization code
    show_uid = uid;
    mywidth  = width;
    allowDelTag = NO;
    allowClickTag = YES;
    
    self.tagDic   = [NSMutableDictionary dictionary];
    for (NSString * temp  in tagList.allKeys) {
        [self.tagDic setObject:[[NSMutableDictionary alloc] initWithDictionary:[tagList objectForKey:temp]] forKey:[[tagList objectForKey:temp] objectForKey:@"tid"]];
    }
    originalPosition = sp;
    
    [self resetAllTagList];
}


- (JYProfileTagListView *) initUiView:uid width:(NSInteger) width startPosition:(CGPoint)sp tagList:(NSMutableDictionary *) tagList isAllowDelTag:(BOOL) isAllowDelTag isAllowClickTag:(BOOL) isAllowClickTag isContactsTag:(BOOL)isContactTag{
    
    self     = [super init];
    self.clipsToBounds = YES;
    _isContactTag = isContactTag;
    //判断taglist如果不是可变字典，则退出
    if(![tagList isKindOfClass:[NSMutableDictionary class]]){
//        [[JYAppDelegate sharedAppDelegate] showTip:@"标签字典类型不正确"];
        return self;
    }
    
    show_uid = uid;
    mywidth  = width;
    allowDelTag = isAllowDelTag;
    allowClickTag = isAllowClickTag;
    
    delTagArr = [NSMutableArray array];
    self.tagDic   = [NSMutableDictionary dictionary];
    for (NSString * temp  in tagList) {
        [self.tagDic setObject:[[NSMutableDictionary alloc] initWithDictionary:[tagList objectForKey:temp]] forKey:[[tagList objectForKey:temp] objectForKey:@"tid"]];
    }
    originalPosition = sp;
    
    [self resetAllTagList];
    
    return  self;
}

//看别人的profile时，点击标签操作
- (void) clickTagLabelGesture:(UITapGestureRecognizer *) gesture{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"tags" forKey:@"mod"];
    [parametersDict setObject:@"tag_click" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:show_uid forKey:@"uid"];
    [postDict setObject:[NSString stringWithFormat:@"%ld",(long)gesture.view.tag] forKey:@"tid"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //[[JYAppDelegate sharedAppDelegate] showTip:@"点击成功"];
            //重排所有的tag
//            NSDictionary * xx =  [self.tagDic objectForKey:[NSString stringWithFormat:@"%ld", (long)gesture.view.tag]] ;
//            //NSMutableDictionary * x2 = [[NSMutableDictionary alloc] initWithDictionary:xx];
//            [xx setValue:[[responseObject objectForKey:@"data"] objectForKey:@"bind"] forKey:@"bind"];
             if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                 NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
                 JYProfileTagModel *tagModel = [[JYProfileTagModel alloc] initWithDataDic:dic];
                 
                 NSDictionary * xx =  [self.tagDic objectForKey:tagModel.tid] ;
                 if (xx) {
                     [tagModel setCtime:[xx objectForKey:@"ctime"]];
//                     [dic setObject:[xx objectForKey:@"ctime"] forKey:@"ctime"];
                 }else{
            
                     NSString *dateStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
//                     [dic setObject:dateStr forKey:@"ctime"];
                     [tagModel setCtime:dateStr];
                 }
                 [self.tagDic setObject:tagModel.modelToDictionary forKey:tagModel.tid];
                
                 [self resetAllTagList];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kProfileClickTagsNotification object:nil userInfo:self.tagDic];
             }
        } else {
            [[JYAppDelegate sharedAppDelegate] showTip:@"点击失败"];
        }
    } failure:^(id error) {
        
        NSLog(@"%@", error);
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}

//每次操作后，需对标签重排
- (void) resetAllTagList{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    startPosition = CGPointMake(0, 10);
    
    if (self.tagDic.count == 0 && !_isContactTag) {
        CGFloat width = [JYHelpers getTextWidthAndHeight:@"暂无标签" fontSize:15].width;
        UILabel *tagListContentTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 30)];
        tagListContentTagLabel.textAlignment = NSTextAlignmentLeft;
        //        tagListContentTagLabel.backgroundColor = kTextColorGray;
        tagListContentTagLabel.textColor = [JYHelpers setFontColorWithString:@"#b9b9b9"];
        tagListContentTagLabel.font = [UIFont systemFontOfSize:15];
        tagListContentTagLabel.text = @"暂无标签";
        [self addSubview:tagListContentTagLabel];
        self.frame = CGRectMake(originalPosition.x , originalPosition.y, mywidth, startPosition.y+40);
        return;
    }
    
    NSMutableArray *tagArr = [NSMutableArray array];
    
    for (NSString *key in self.tagDic.allKeys) {
        [tagArr addObject:[self.tagDic objectForKey:key]];
    }
    [self updateLocalDBTagList:tagArr];
    
   tagArr = [JYHelpers sortTagArr:tagArr];
    
    if (_isContactTag) {
        JYRecommendTagButton *button = [[JYRecommendTagButton alloc] initWithFrame:CGRectMake(startPosition.x, startPosition.y, 10, 30) aTitle:@"写标签"];
        [button addTapGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagGesture:)]];
        [self addSubview:button];
        startPosition = CGPointMake(button.right+5, startPosition.y);
    }
    for (NSDictionary *tempDic in tagArr) {
//        NSString *deleteBgImgStr = @"profile_normaltag_delbg";
        deleteBgViewColor = [UIColor blueColor];
        //判断要显示的颜色,具体要参考文档
        if ([JYHelpers integerValueOfAString:[tempDic objectForKey:@"oper"]] == 1 && allowClickTag) {
            numLableColor = @"#b9b9b9";
            textLableColor = @"#848484";
//            deleteBgImgStr = @"1";
        }else if ([[tempDic objectForKey:@"bind"] integerValue] >=5) { //红色
            numLableColor = @"#ff7f74";
            textLableColor = @"#fa544f";
            deleteBgViewColor = [UIColor redColor];
//            deleteBgImgStr = @"profile_hottag_delbg";
        }else{ //蓝色
            numLableColor = @"#6bbcff";
            textLableColor = @"#2695ff";
        }
        
        //如果是用户点击删除了的，则显示灰色
        for (NSString * tArr in delTagArr) {
            if ([[tempDic objectForKey:@"tid"] integerValue] == [tArr integerValue]) {
                numLableColor = @"#b9b9b9";
                textLableColor = @"#848484";
            }
        }
        CGSize textLabSize = [[tempDic objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
        //标签开始时计算位置
        if ((allowClickTag && startPosition.x+40+textLabSize.width+10 > mywidth-10) || (allowDelTag && startPosition.x+40+textLabSize.width+10+30> mywidth-10)) {
            startPosition = CGPointMake(0, startPosition.y+35);
        }
        
        UILabel *tagListNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPosition.x, startPosition.y, 0, 0)];
        tagListNumLabel.textAlignment = NSTextAlignmentCenter;
        tagListNumLabel.backgroundColor = [JYHelpers setFontColorWithString:numLableColor];
        tagListNumLabel.textColor = [JYHelpers setFontColorWithString:@"#ffffff"];
        tagListNumLabel.font = [UIFont systemFontOfSize:15];
        tagListNumLabel.tag = [[NSString stringWithFormat:@"9%@", [tempDic objectForKey:@"tid"]] integerValue];
        [self addSubview:tagListNumLabel];
        
        //当有点击数，才显示前面的数字
        if([[tempDic objectForKey:@"bind"] integerValue]>0){
            tagListNumLabel.size = CGSizeMake(40, 30);
            tagListNumLabel.text = [NSString stringWithFormat:@"%@" ,[tempDic objectForKey:@"bind"]];
        }
        
        UILabel *tagListContentTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(tagListNumLabel.right, tagListNumLabel.top, textLabSize.width+20, 30)];
        tagListContentTagLabel.textAlignment = NSTextAlignmentCenter;
        tagListContentTagLabel.backgroundColor = [JYHelpers setFontColorWithString:textLableColor];
        tagListContentTagLabel.textColor = [JYHelpers setFontColorWithString:@"#ffffff"];
        tagListContentTagLabel.font = [UIFont systemFontOfSize:15];
        tagListContentTagLabel.text = [tempDic objectForKey:@"title"];
        tagListContentTagLabel.userInteractionEnabled = YES;
        [self addSubview:tagListContentTagLabel];
        if (allowClickTag) {

            tagListContentTagLabel.tag = [[tempDic objectForKey:@"tid"] integerValue];

            UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTagLabelGesture:)];
            gr.view.tag = [[tempDic objectForKey:@"tid"] integerValue];
            [tagListContentTagLabel addGestureRecognizer:gr];
            
            //结束时计算下一个标签的起始位置
            startPosition = CGPointMake(tagListContentTagLabel.right+5, startPosition.y);
        }
        if (allowDelTag) {
            
            tagListContentTagLabel.tag = [[NSString stringWithFormat:@"8%@", [tempDic objectForKey:@"tid"]] integerValue];

            UIView *deleteBgImgView = [[UIView alloc] initWithFrame:CGRectMake(tagListContentTagLabel.right, tagListContentTagLabel.top, tagListContentTagLabel.height, tagListContentTagLabel.height)];
            [deleteBgImgView setUserInteractionEnabled:YES];
            if ([JYHelpers integerValueOfAString:[tempDic objectForKey:@"bind"]] > 5) {
                [deleteBgImgView setBackgroundColor:[UIColor redColor]];

            }else{
                [deleteBgImgView setBackgroundColor:[UIColor blueColor]];
            }
            
            [deleteBgImgView setTag:[[tempDic objectForKey:@"tid"] integerValue]];
            [self addSubview:deleteBgImgView];
            
            
            UIImageView *delete = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
            [delete setImage:[UIImage imageNamed:@"profile_deltag"]];
            [delete setUserInteractionEnabled:YES];
            [deleteBgImgView addSubview:delete];
            
            UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delOneTag:)];
//            gr.view.tag = [[tempDic objectForKey:@"tid"] integerValue];
            [deleteBgImgView addGestureRecognizer:gr];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contenLabelDelOneTagGesture:)];
            [tagListContentTagLabel addGestureRecognizer:tap];
            //结束时计算下一个标签的起始位置
            startPosition = CGPointMake(deleteBgImgView.right+5, startPosition.y);
            
        }
        
    }
    self.frame = CGRectMake(originalPosition.x, originalPosition.y, mywidth, startPosition.y+40);
    
}

//添加一个新的标签 ，并重排所有
- (void) addOneTagResetList:(NSMutableDictionary *) tagList{
    self.tagDic = tagList;
    
    [self resetAllTagList];
    self.frame = CGRectMake(originalPosition.x , originalPosition.y, mywidth, startPosition.y+40);
    [[NSNotificationCenter defaultCenter] postNotificationName:kProfileEditTagsNotification object:self userInfo:self.tagDic];
}
- (void)contenLabelDelOneTagGesture:(UITapGestureRecognizer*)gesture{
    NSString *tidStr = [NSString stringWithFormat:@"%ld",(long)gesture.view.tag];
    NSInteger tid = [JYHelpers integerValueOfAString:[tidStr substringFromIndex:1]];
    [self deletaTagWithTid:tid];
}

//删除一个标签
- (void) delOneTag:(UITapGestureRecognizer *) gesture{
   
    [self deletaTagWithTid:gesture.view.tag];
    
}
- (void)deletaTagWithTid:(NSInteger)tid{
    BOOL isAddDelTag = YES; //false删除标签，true--添加标签
    for (int i = 0 ; i<delTagArr.count; i++) {
        
        if ([[delTagArr objectAtIndex:i] integerValue] == tid) {
            [delTagArr removeObjectAtIndex:i];
            isAddDelTag = false;
            
            //当取消前选 中的标签，需要修改背景色
            UIView * tempView = (UIView *)[self viewWithTag:[[NSString stringWithFormat:@"8%ld",(long)tid] integerValue]]; //标签内容
            UIView * tempView2 = (UIView *)[self viewWithTag:[[NSString stringWithFormat:@"9%ld", (long)tid] integerValue]]; //标签前的计数
            UIView * deleteView = [self viewWithTag:tid];
            
            [deleteView setBackgroundColor:deleteBgViewColor];
            tempView.backgroundColor = [JYHelpers setFontColorWithString:textLableColor];
            tempView2.backgroundColor = [JYHelpers setFontColorWithString:numLableColor];
            
            break;
        }
    }
    if (isAddDelTag) {
        [delTagArr addObject:[NSString stringWithFormat:@"%ld", (long)tid]];
        //当前选 中的标签，需要修改背景色
        UIView * tempViewTitle = (UIView *)[self viewWithTag:[[NSString stringWithFormat:@"8%ld",tid] integerValue]]; //标签内容
        UIView * tempViewNum = (UIView *)[self viewWithTag:[[NSString stringWithFormat:@"9%ld", (long)tid] integerValue]]; //标签前的计数
        UIView * deleteView = [self viewWithTag:tid];

        [deleteView setBackgroundColor:[UIColor darkGrayColor]];
        tempViewTitle.backgroundColor = [JYHelpers setFontColorWithString:@"#848484"];  //灰色
        tempViewNum.backgroundColor = [JYHelpers setFontColorWithString:@"#b9b9b9"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProfileDelLocalTagDicNotification object:delTagArr];
}
//当删除后，点击左上角返回时，将数据提交给Web
- (void) delTagPostHttp{
    if (delTagArr.count > 0) {
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"tags" forKey:@"mod"];
        [parametersDict setObject:@"del_tag" forKey:@"func"];
        NSLog(@"%@",[delTagArr componentsJoinedByString:@","]);
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:[delTagArr componentsJoinedByString:@","]  forKey:@"tids"];

        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1) {
                
                //删除成功后最后发一个通知，告诉要重绘页面的controller
                NSMutableDictionary *myTempTagDic = [self.tagDic mutableCopy];
                for (NSString * arrTemp in delTagArr) {
                    for (NSString * dicTemp in self.tagDic) {
                        if ([dicTemp integerValue] == [arrTemp integerValue]) {
                            [myTempTagDic removeObjectForKey:dicTemp];
                            break;
                        }
                    }
                }
                
                [[JYProfileData sharedInstance] updateTagListWithNewTagList:[myTempTagDic allValues] uid:show_uid];
                //此通知没必要 调用的时候 editTagController 正在执行 backAction
                [[NSNotificationCenter defaultCenter] postNotificationName:kProfileDelTagsNotification object:self userInfo:myTempTagDic];
                
            } else {
                [[JYAppDelegate sharedAppDelegate] showTip:@"点击失败"];
            }
        } failure:^(id error) {
            [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
            NSLog(@"%@", error);
            
        }];
    }

}
//同步到本地数据库
- (void)updateLocalDBTagList:(NSArray*)tagList{

    [[JYProfileData sharedInstance] updateTagListWithNewTagList:tagList uid:show_uid];
}
//点击添加标签
- (void)addTagGesture:(UITapGestureRecognizer*)aTap{
    if (self.addTagBlock) {
        self.addTagBlock();
    }
}
- (void) dealloc {
    NSLog(@"taglistview dealloc");
}
@end
