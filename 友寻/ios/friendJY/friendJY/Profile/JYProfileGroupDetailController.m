//
//  JYProfileGroupDetailController.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYProfileGroupDetailController.h"
#import "JYGroupModel.h"
#import "JYShareData.h"
#import "JYHttpServeice.h"
#import "JYGroupMembersCollectionView.h"
#import "JYGroupMemberModel.h"
#import "JYAppDelegate.h"
#import "JYOtherProfileController.h"
#import "JYProfileController.h"

@interface JYProfileGroupDetailController ()<JYMemberCollectionViewDelegate>
{
    //用户权限
    UILabel *contentAccessLab;
    //y用户权限选项
    NSArray *privilegeOptionArr;
    //显示全部成员按钮
    UIButton *showAllBtn;
    //群组成员视图
    JYGroupMembersCollectionView *memberView;
    //加入群组按钮
    UIButton *joinBtn;
    //群组成员父视图
    UIView *sectionFour;
    //背景容器视图
    UIScrollView *myScrollView;
//    NSMutable *memberList;
}
//群组成员
@property (nonatomic, strong) NSArray *memberList;

@end

@implementation JYProfileGroupDetailController
@synthesize memberList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"TA的群组"];
    [self layoutSUbviews];
    [self getData];
    // Do any additional setup after loading the view.
}
#pragma mark - Data Hanlder
- (void)getData{
    privilegeOptionArr = [[[JYShareData sharedInstance] profile_dict] objectForKey:@"group_privilege"];
//    [self loadGroupDetailInfo];
    memberList = [NSArray array];
    [self loadGroupMembers];
}
#pragma mark - Layout Subviews
- (void)layoutSUbviews{
    
     myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setShowsVerticalScrollIndicator:NO];
    [myScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:myScrollView];
    
    //群组名
    UIView *sectionOne = [[UIView alloc] initWithFrame:CGRectMake(-1, 20, kScreenWidth+2, 44*self.autoSizeScaleY)];
    [sectionOne setBackgroundColor:[UIColor whiteColor]];
    [sectionOne.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [sectionOne.layer setBorderWidth:1];
    [myScrollView addSubview:sectionOne];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 30, 44*self.autoSizeScaleY)];
    [name setFont:[UIFont systemFontOfSize:15]];
    [name setText:@"名称"];
    [name setTextColor:kTextColorBlack];
    [sectionOne addSubview:name];
    
    UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(name.right+15, 0, sectionOne.width - name.right - 17, 44*self.autoSizeScaleY)];
    [groupName setTextColor:kTextColorBlue];
    [groupName setText:_group.title];
    [groupName setFont:[UIFont systemFontOfSize:15]];
    [sectionOne addSubview:groupName];
    
    //群组简介
    NSString *contentOfIntro = @"";
    if (_group.intro.length < 1) {
        contentOfIntro = @"没有群组简介";
    }else{
        contentOfIntro = _group.intro;
    }
    
    CGFloat height = [contentOfIntro sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(groupName.width, MAXFLOAT)].height;
    if (height < 44) {
        height = 44;
    }else{
        height += 30;
    }
    UIView *sectionTwo = [[UIView alloc] initWithFrame:CGRectMake(-1, sectionOne.bottom+5, kScreenWidth+2, height)];
    [sectionTwo setBackgroundColor:[UIColor whiteColor]];
    [sectionTwo.layer setBorderWidth:1];
    [sectionTwo.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [myScrollView addSubview:sectionTwo];
    
    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(name.left, 0, name.width, height)];
    [intro setFont:[UIFont systemFontOfSize:15]];
    [intro setText:@"简介"];
    [intro setTextColor:kTextColorBlack];
    [sectionTwo addSubview:intro];
    
    UILabel *introLab = [[UILabel alloc] initWithFrame:CGRectMake(groupName.left, 0, groupName.width, height)];
    [introLab setNumberOfLines:0];
    [introLab setTextColor:kTextColorGray];
    [introLab setFont:[UIFont systemFontOfSize:15]];
    [introLab setText:contentOfIntro];
    [sectionTwo addSubview:introLab];
    
    //权限
    UIView *sectionThree = [[UIView alloc] initWithFrame:CGRectMake(-1, sectionTwo.bottom+5, kScreenWidth+2, sectionOne.height)];
    [sectionThree setBackgroundColor:[UIColor whiteColor]];
    [sectionThree.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [sectionThree.layer setBorderWidth:1];
    [myScrollView addSubview:sectionThree];
    
    UILabel *accessLab = [[UILabel alloc] initWithFrame:name.frame];
    [accessLab setFont:[UIFont systemFontOfSize:15]];
    [accessLab setText:@"权限"];
    [accessLab setTextColor:kTextColorBlack];
    [sectionThree addSubview:accessLab];
    
    contentAccessLab = [[UILabel alloc] initWithFrame:groupName.frame];
    [contentAccessLab setFont:[UIFont systemFontOfSize:15]];
    [contentAccessLab setTextColor:kTextColorGray];
    [sectionThree addSubview:contentAccessLab];
    
    height = (kScreenWidth - 30)/4;
    NSLog(@"item height--->%lf",height);
    
    sectionFour = [[UIView alloc] initWithFrame:CGRectMake(-1, sectionThree.bottom+5, kScreenWidth+2, 44+height*3 + 10)];
    [sectionFour setBackgroundColor:[UIColor whiteColor]];
    [sectionFour.layer setBorderColor:[[JYHelpers setFontColorWithString:@"#cccccc"] CGColor]];
    [sectionFour.layer setBorderWidth:1];
    [myScrollView addSubview:sectionFour];
    
    UILabel *memberLab = [[UILabel alloc] initWithFrame:name.frame];
    [memberLab setFont:[UIFont systemFontOfSize:15]];
    [memberLab setTextColor:kTextColorBlack];
    [memberLab setText:@"成员"];
    [sectionFour addSubview:memberLab];
    
    showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [showAllBtn setTitle:@"收起" forState:UIControlStateSelected];
    [showAllBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
    [showAllBtn setFrame:CGRectMake(memberLab.right + 15, 0, 60, memberLab.height)];
    [showAllBtn setBackgroundColor:[UIColor whiteColor]];
    [showAllBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [showAllBtn addTarget:self action:@selector(showAllMemberAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectionFour addSubview:showAllBtn];
    
    //群组成员
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(height-20, height)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    memberView = [[JYGroupMembersCollectionView alloc] initWithFrame:CGRectMake(15, memberLab.bottom, kScreenWidth - 30, height*3) collectionViewLayout:layout];
    [memberView setMemberDelegate:self];
    [sectionFour addSubview:memberView];
    //没有加入显示
    CGFloat lastBottom = sectionFour.bottom;
    if ([_group.join isEqualToString:@"0"]) {
        joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [joinBtn setFrame:CGRectMake(15, sectionFour.bottom + 25, kScreenWidth - 30, 40)];
        [joinBtn setTitle:@"加入群组" forState:UIControlStateNormal];
        [joinBtn setBackgroundImage:[UIImage imageNamed:@"login_confirm_btn_available"] forState:UIControlStateNormal];
        [joinBtn setBackgroundImage:[UIImage imageNamed:@"login_confirm_btn_unavailable"] forState:UIControlStateDisabled];
        [joinBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [joinBtn addTarget:self action:@selector(joinGroup) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:joinBtn];
        lastBottom = joinBtn.bottom;
    }
    
    [myScrollView setContentSize:CGSizeMake(kScreenWidth, lastBottom + 25)];
}
//下载成功刷新视图
- (void)relayoutUIWithRow:(NSInteger)row{
    NSLog(@"一共 %ld 行",(long)row);
    CGFloat height = (kScreenWidth - 30)/4;
//    NSInteger row = memberList.count/5;
    CGRect frame = sectionFour.frame;
    
    if (row > 3) {
        [memberView setFrame:CGRectMake(15, 44*self.autoSizeScaleY, kScreenWidth-30, height*3)];
    }else{
        [showAllBtn setHidden:YES];
        [memberView setFrame:CGRectMake(15, 44*self.autoSizeScaleY, kScreenWidth-30, height*row)];
    }
    [sectionFour setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,memberView.bottom + 10)];
    [joinBtn setFrame:CGRectMake(15, sectionFour.bottom+25, kScreenWidth - 30, 40)];
    if (joinBtn.bottom+25 < myScrollView.bottom) {
        [myScrollView setContentSize:CGSizeMake(kScreenWidth, myScrollView.bottom)];
    }else
        [myScrollView setContentSize:CGSizeMake(kScreenWidth, joinBtn.bottom+25)];
}
#pragma mark - Request

- (void)loadGroupMembers{
    [self showProgressHUD:@"加载中..." toView:self.view];
    NSDictionary *paraDic = @{@"mod":@"chat",
                              @"func":@"group_user_list"
                              };
    NSDictionary *postDic = @{
                              @"group_id":_group.group_id
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        [self dismissProgressHUDtoView:self.view];
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
// privilege - 0-所有人可以直接加入 1-所有人需要申请加入 2-只允许一度好友和二度好友直接加入 3-只允许一度好友和二度好友申请加入 4-禁止任何人加入
                NSInteger privilege = [[[responseObject objectForKey:@"data"] objectForKey:@"privilege"] integerValue];
                [contentAccessLab setText:[privilegeOptionArr objectAtIndex:privilege]];
                if (privilege == 4) {
                    //不允许加入则让加入按钮不可点击
                    [myScrollView setContentSize:CGSizeMake(kScreenWidth, myScrollView.contentSize.height - joinBtn.height - 25)];
                    [joinBtn removeFromSuperview];
                    joinBtn = nil;

                }
                NSString *owner_id = [[responseObject objectForKey:@"data"] objectForKey:@"uid"];
                NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:10];
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"userlist"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dataDic in [[responseObject objectForKey:@"data"] objectForKey:@"userlist"]) {
                        
                        JYGroupMemberModel *member = [[JYGroupMemberModel alloc] initWithDataDic:dataDic];
                        [member setAvatar:[[dataDic objectForKey:@"avatars"] objectForKey:@"200"]];
                        if ([JYHelpers isEmptyOfString:member.nick]) {
                            member.nick = @"没有昵称";
                        }
                        //如果是创建者
                        if ([[dataDic objectForKey:@"uid"] isEqualToString:owner_id]) {
                            [member setIsOwner:YES];
                            [dataList insertObject:member atIndex:0];
                        }else{
                            [member setIsOwner:NO];
                            [dataList addObject:member];
                        }
                    }
                    //让成员视图 重载
                    [memberView setMemberList:dataList];
                    [self setMemberList:dataList];
                    [memberView reloadData];
                    
                    NSInteger row = memberList.count/5;
                    if (memberList.count%5 > 0) {
                        row++;
                    }
                    [self relayoutUIWithRow:row];
                    
                }
            }
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:@"加载失败，请检查网络连接"];
    }];
}
#pragma mark - Action Handler

- (void)showAllMemberAction:(UIButton*)button{
    button.selected = !button.selected;
    CGFloat height = (kScreenWidth - 30)/4;
    CGRect frame = sectionFour.frame;
    NSInteger row = memberList.count/5;
    if (memberList.count%5 > 0) {
        row++;
    }
    if (!button.selected) {//收起
        [memberView setFrame:CGRectMake(15, 44*self.autoSizeScaleY, kScreenWidth-30, height*3)];
    }else{
//        [showAllBtn setHidden:YES];
        [memberView setFrame:CGRectMake(15, 44*self.autoSizeScaleY, kScreenWidth-30, height*row)];
    }
    [sectionFour setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,memberView.bottom + 10)];
    CGFloat lastBottom;
    if (joinBtn) {
        [joinBtn setFrame:CGRectMake(15, sectionFour.bottom+25, kScreenWidth - 30, 40)];
        lastBottom = joinBtn.bottom;
    }else{
        lastBottom = sectionFour.bottom;
    }
    if (lastBottom+25 < myScrollView.bottom) {
        [myScrollView setContentSize:CGSizeMake(kScreenWidth, myScrollView.bottom)];
    }else
        [myScrollView setContentSize:CGSizeMake(kScreenWidth, lastBottom+25)];
}

- (void)joinGroup{
    
    [joinBtn setEnabled:NO];
    
    NSDictionary *paraDic = @{@"mod":@"chat",
                              @"func":@"add_group"
                              };
    NSDictionary *postDic = @{@"touid":ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]),
                              @"group_id":_group.group_id
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
//                    'result' -1 禁止加入 1-加入成功 2-等待群主审核 3 申请过

            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSInteger result = [[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue];
                if (result == 1) {
                    [[JYAppDelegate sharedAppDelegate] showTip:@"恭喜,加入成功"];
                    [myScrollView setContentSize:CGSizeMake(kScreenWidth, myScrollView.contentSize.height - joinBtn.height - 25)];
                    [joinBtn removeFromSuperview];
                    joinBtn = nil;
                    [self loadGroupMembers];
                    if (self.HadJoinedGroup) {
                        self.HadJoinedGroup(_group.group_id);
                    }
                }else if (result == 2){
                    [[JYAppDelegate sharedAppDelegate] showTip:@"申请成功,等待群主审核"];
                }else if (result == -1){
                    [[JYAppDelegate sharedAppDelegate] showTip:@"该群组禁止加入"];
                }else if (result == 3){
                    [[JYAppDelegate sharedAppDelegate] showTip:@"申请已经提交，请耐心等待"];
                }
            }
        }else{
            [[JYAppDelegate sharedAppDelegate] showTip:@"申请失败"];
        }
    } failure:^(id error) {
        [self dismissProgressHUDtoView:self.view];
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - JYMemberViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JYGroupMemberModel *model = (JYGroupMemberModel*)[memberList objectAtIndex:indexPath.row];
    if ([ToString([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]) isEqualToString:model.uid]) {
        JYProfileController *profileVC = [[JYProfileController alloc] init];
//        profileVC setShow_uid:<#(NSString *)#>
        [self.navigationController pushViewController:profileVC animated:YES];
    }else{
        JYOtherProfileController *profileVC = [[JYOtherProfileController alloc] init];
        [profileVC setShow_uid:model.uid];
        [self.navigationController pushViewController:profileVC animated:YES];
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
