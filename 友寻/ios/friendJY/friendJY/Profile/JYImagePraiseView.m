//
//  JYImagePraiseView.m
//  friendJY
//
//  Created by aaa on 15/7/2.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYImagePraiseView.h"
#import "JYProfileDownImagePraiseManager.h"
#import "UIImageView+WebCache.h"

#define avaW 30
#define avaGap 10

@implementation JYImagePraiseView
{
    UILabel *praiseNum;
    UIButton *praiseBtn;
    BOOL havePraise;
    NSString *myself_uid;
    JYProfileModel *pmodel;
    UIScrollView *avaScrollView;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
        pmodel = [JYShareData sharedInstance].myself_profile_model;
        myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        
        avaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-150, 45)];
        avaScrollView.showsHorizontalScrollIndicator = NO;
        avaScrollView.showsVerticalScrollIndicator = NO;
        avaScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:avaScrollView];
        
        praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        praiseBtn.backgroundColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        praiseBtn.frame = CGRectMake(0, 45, kScreenWidth, 45);
        praiseBtn.selected = NO;
        [praiseBtn setImage:[UIImage imageNamed:@"pariseImage"] forState:UIControlStateNormal];
        [praiseBtn setImage:[UIImage imageNamed:@"havePariseImage"] forState:UIControlStateSelected];
        //[praiseBtn setTitle:@"取消赞" forState:UIControlStateSelected];
        [praiseBtn addTarget:self action:@selector(PraiseClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:praiseBtn];
        
        praiseNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, 0, 100, 45)];
        praiseNum.textAlignment = NSTextAlignmentCenter;
        praiseNum.textColor = [JYHelpers setFontColorWithString:@"#2695ff"];
        praiseNum.font = [UIFont systemFontOfSize:13];
        [self addSubview:praiseNum];
        
    }
    return self;
}
-(void)PraiseClick{
    praiseBtn.enabled = NO;
    //判断有没有赞过
    if (havePraise) {
        [JYProfileDownImagePraiseManager CanclePraiseImage:myself_uid andFuid:self.fuid andPid:_praiseModel.pid andSucceedBlock:^{
            NSLog(@"取消赞成功");
            havePraise = !havePraise;
            
            if (self.canclePraiseBlock) {
                self.canclePraiseBlock();
            }
            //删除数据
            for (NSString *key in self.praiseModel.list) {
                if ([key isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]]) {
                    [self.praiseModel.list removeObjectForKey:key];
                    break;
                }
            }
            int num = [_praiseModel.count intValue];
            _praiseModel.count = [NSString stringWithFormat:@"%d",num-1];
            [self LoadUi];
           
            praiseBtn.enabled = YES;
        }andFaildBlock:^(id error){
            NSLog(@"取消赞失败");
            praiseBtn.enabled = YES;
        }];
        NSLog(@"取消赞");

    }else{
        [JYProfileDownImagePraiseManager PraiseImage:myself_uid andFuid:self.fuid andPid:_praiseModel.pid andSucceedBlock:^{
            NSLog(@"点赞成功");
            havePraise = !havePraise;
            
            if (self.praiseFinishBlock) {
                self.praiseFinishBlock();
            }
            //增加数据
            NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[pmodel.avatars] forKeys:@[@"avatars"]];
            [self.praiseModel.list setObject:dict forKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
            int num = [_praiseModel.count intValue];
            _praiseModel.count = [NSString stringWithFormat:@"%d",num+1];
            [self LoadUi];
            
            praiseBtn.enabled = YES;
        }andFaildBlock:^(id error){
            NSLog(@"点赞失败");
            praiseBtn.enabled = YES;
        }];
        NSLog(@"点赞");
    }
}

-(void)setPraiseModel:(JYImagePraiseModel *)aModel{
    _praiseModel = aModel;
    //判断有没有赞过
    havePraise = NO;
    for (NSString *key in aModel.list) {
        if ([key isEqualToString:myself_uid]) {
            havePraise = YES;
            break;
        }
    }
    [self LoadUi];
}
- (void)LoadUi{
    praiseNum.text = [NSString stringWithFormat:@"%@人已赞",_praiseModel.count];
    praiseBtn.selected = havePraise;
    [self SetUpAvatars];
}


- (void) SetUpAvatars{
    
    @autoreleasepool {
        for (UIView *view in avaScrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    int left = 0;
    for (NSString *key in self.praiseModel.list) {
        UIImageView *aImage = [[UIImageView alloc]initWithFrame:CGRectMake(left, 7.5, 30, 30)];
        aImage.layer.masksToBounds = YES;
        aImage.userInteractionEnabled = YES;
        aImage.layer.cornerRadius = 15;
        //[aImage sd_setImageWithURL:[NSURL URLWithString:self.praiseModel.list[key][@"avatars"][@"200"]]];
        //[UIImage imageNamed:@"pic_morentouxiang_man"]
        [aImage sd_setImageWithURL:[NSURL URLWithString:self.praiseModel.list[key][@"avatars"][@"200"]] placeholderImage:[UIImage imageNamed:@"pic_morentouxiang_man"]];
        [avaScrollView addSubview:aImage];
        left = left + 30 + avaGap;
        
        aImage.tag = [key integerValue];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AvaClick:)];
        [aImage addGestureRecognizer:tap];
    }
}
- (void)AvaClick:(UITapGestureRecognizer *)sender{
    NSLog(@"%ld",(long)sender.view.tag);
    if (self.avaClickBlock) {
        self.avaClickBlock(sender.view.tag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
