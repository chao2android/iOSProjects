//
//  JYSysMsgCell.m
//  friendJY
//
//  Created by ouyang on 5/5/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYSysMsgCell.h"
#import "UIImageView+WebCache.h"
#import "JYShareData.h"
#import "JYHelpers.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYMsgUpdate.h"
#import "JYOtherProfileController.h"

@implementation JYSysMsgCell{
    UIButton *_exitBtn;
    UIImageView *_avatarView;
    UILabel *_nickLab;
    UILabel *_areaLab;
    UILabel *_intro3Lab;
    UILabel *_intro4Lab;
    UILabel *_showTimeLab;
    UIButton *_enjoinBtn;
    UIButton *_refuseBtn;
    UIImageView *line;
    UILabel *statusLabel;
    UIImageView * _likePicView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [self setBackgroundColor:[UIColor yellowColor]];
//        [self setBackgroundColor:[UIColor whiteColor]];
//        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setUserInteractionEnabled:YES];
        //头像
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarView setBackgroundColor:[UIColor lightGrayColor]];
        [_avatarView setClipsToBounds:YES];
        [_avatarView.layer setCornerRadius:25.0f];
        _avatarView.userInteractionEnabled = YES;
        [_avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_gotoParentOtherProfile)]];
        [self addSubview:_avatarView];
        
        //昵称
        _nickLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nickLab setBackgroundColor:[UIColor clearColor]];
        [_nickLab setClipsToBounds:YES];
        [_nickLab setTextColor:kTextColorBlack];
        [_nickLab setFont:[UIFont systemFontOfSize:16.0f]];
        [_nickLab setTextAlignment:NSTextAlignmentLeft];
        _nickLab.userInteractionEnabled = YES;
        [_nickLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_gotoParentOtherProfile)]];
        [self addSubview:_nickLab];
        
        //地区
        _areaLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_areaLab setClipsToBounds:YES];
        [_areaLab setBackgroundColor:[UIColor clearColor]];
        [_areaLab setTextColor:kTextColorGray];
        [_areaLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_areaLab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_areaLab];
        
        //共同好友
        _intro3Lab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_intro3Lab setClipsToBounds:YES];
        [_intro3Lab setBackgroundColor:[UIColor clearColor]];
        [_intro3Lab setTextColor:kTextColorGray];
        [_intro3Lab setFont:[UIFont systemFontOfSize:12.0f]];
        [_intro3Lab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_intro3Lab];
//        _intro3Lab.backgroundColor = [UIColor yellowColor];
        
        //介绍
        _intro4Lab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_intro4Lab setClipsToBounds:YES];
        [_intro4Lab setBackgroundColor:[UIColor clearColor]];
        [_intro4Lab setTextColor:kTextColorGray];
        [_intro4Lab setFont:[UIFont systemFontOfSize:12.0f]];
        [_intro4Lab setTextAlignment:NSTextAlignmentLeft];
        [_intro4Lab setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_intro4Lab];
//        _intro4Lab.backgroundColor = [UIColor brownColor];
        
        _showTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_showTimeLab setClipsToBounds:YES];
        [_showTimeLab setBackgroundColor:[UIColor clearColor]];
        [_showTimeLab setTextColor:kTextColorGray];
        [_showTimeLab setFont:[UIFont systemFontOfSize:12.0f]];
        [_showTimeLab setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_showTimeLab];
        
        _enjoinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enjoinBtn.frame = CGRectMake(kScreenWidth-45, 30, 40, 30);
        _enjoinBtn.clipsToBounds = YES;
        _enjoinBtn.backgroundColor = [UIColor clearColor];
        [_enjoinBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_enjoinBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
        _enjoinBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [_enjoinBtn addTarget:self action:@selector(enjoinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_enjoinBtn];
        
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.clipsToBounds = YES;
        _refuseBtn.frame = CGRectMake(_enjoinBtn.left - 40, 30, 40, 30);
        _refuseBtn.backgroundColor = [UIColor clearColor];
        _refuseBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:[JYHelpers setFontColorWithString:@"#fa544f"] forState:UIControlStateNormal];
        [_refuseBtn addTarget:self action:@selector(refuseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refuseBtn];
        
        _likePicView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_likePicView setBackgroundColor:[UIColor lightGrayColor]];
        [_likePicView setClipsToBounds:YES];
//        [_likePicView.layer setCornerRadius:25.0f];
        [self addSubview:_likePicView];
        
        statusLabel = [[UILabel alloc]init];
        statusLabel.hidden = YES;
        statusLabel.font = [UIFont systemFontOfSize: 14.0];
        statusLabel.textColor = kTextColorGray;
        [self addSubview:statusLabel];
        
//        [_enjoinBtn setBackgroundColor:[UIColor orangeColor]];
//        [_refuseBtn setBackgroundColor:[UIColor orangeColor]];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 70, kScreenWidth-15.0f, 1.0f)];
        [line setBackgroundColor:kBorderColorGray];
        [self addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    
    _enjoinBtn.frame = CGRectMake(kScreenWidth-45, self.frame.size.height - 30, 40, 30);
    _refuseBtn.frame = CGRectMake(_enjoinBtn.left - 40, self.frame.size.height - 30, 40, 30);
//    [_refuseBtn setBackgroundColor:[UIColor orangeColor]];
    statusLabel.frame = CGRectMake(kScreenWidth-51, self.frame.size.height - 30, 50, 30);
    
    if ([JYHelpers isEmptyOfString:self.sysmsgModel.avatars]) {
        [_avatarView setFrame:CGRectMake(15, 8, 0, 0)];
    }else{
        [_avatarView setFrame:CGRectMake(15, 8, 50, 50)];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:self.sysmsgModel.avatars]];
    }
    
    if ([JYHelpers isEmptyOfString:self.sysmsgModel.nick]) {
        [_nickLab setFrame:CGRectMake(_avatarView.right+13, _avatarView.top, 0, 0)];
    }else{
        [_nickLab setFrame:CGRectMake(_avatarView.right+13, _avatarView.top, 200, 20)];
        [_nickLab setText:self.sysmsgModel.nick];
    }
    
    
    if ([self.sysmsgModel.privonce intValue] > 0 && [self.sysmsgModel.city intValue] > 0) {
        NSString *province = [[JYShareData sharedInstance].province_code_dict objectForKey:self.sysmsgModel.privonce];
        NSString *city = [[JYShareData sharedInstance].city_code_dict  objectForKey:self.sysmsgModel.city];
        NSString *province_city;
        if ([JYHelpers isEmptyOfString:province]) {
            province_city = @"国外";
        }else{
            province_city = [NSString stringWithFormat:@"%@ %@", province, city];
        }
        
        [_areaLab setFrame:CGRectMake(_avatarView.right+13, _nickLab.bottom, 100, 20)];
        [_areaLab setText:province_city];
    }else{
        [_areaLab setFrame:CGRectMake(_avatarView.right+13, _nickLab.bottom, 100, 0)];
    }
    
    [_showTimeLab setFrame:CGRectMake(kScreenWidth-110, _nickLab.top, 100, 20)];
    _showTimeLab.text = [JYHelpers unixToDate:[self.sysmsgModel.sendtime integerValue]];
    
    _enjoinBtn.hidden = YES;
    _refuseBtn.hidden = YES;
    statusLabel.hidden = YES;
    
    _intro3Lab.height = 0;
    _intro4Lab.height = 0;
    _likePicView.hidden = YES;
    
    switch ([self.sysmsgModel.type intValue]) {
        case 11:// 申请加入群消息
            [_enjoinBtn setTitle:@"添加" forState:UIControlStateNormal];
            [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            [_intro4Lab setFrame:CGRectMake(_avatarView.right+13, _intro3Lab.bottom, kScreenWidth-45, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"%@申请加入 %@" ,self.sysmsgModel.nick , self.sysmsgModel.title];
            if ([self.sysmsgModel.relation intValue] == 1) {
                [_intro4Lab setText:@"你的一度好友"];
            } else if ([self.sysmsgModel.relation intValue] == 2) {
                [_intro4Lab setText:@"你的二度好友"];
            } else if (![JYHelpers isEmptyOfString:self.sysmsgModel.friendnick]) {
                [_intro4Lab setText:[NSString stringWithFormat:@"与%@是好友",self.sysmsgModel.friendnick]];
            } else {
                [_intro4Lab setText:@"TA不是群组成员的好友"];
            }
//            if ([self.sysmsgModel.acceptType isEqualToString:@"-1"]) {
//                _enjoinBtn.hidden = NO;
//                _refuseBtn.hidden = NO;
//                _refuseBtn.enabled = YES;
//                [_enjoinBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
//                [_refuseBtn setTitleColor:[JYHelpers setFontColorWithString:@"#fa544f"] forState:UIControlStateNormal];
//            } else if ([self.sysmsgModel.acceptType isEqualToString:@"1"]) {
//                _enjoinBtn.hidden = NO;
//                _refuseBtn.hidden = YES;
//                _refuseBtn.enabled = NO;
//                _enjoinBtn.width = 60;
//                _enjoinBtn.left = _enjoinBtn.left-20;
//                _enjoinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//                [_enjoinBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
//                [_enjoinBtn setTitle:@"已添加" forState:UIControlStateNormal];
//            } else if ([self.sysmsgModel.acceptType isEqualToString:@"2"]) {
//                _enjoinBtn.hidden = YES;
//                _refuseBtn.hidden = NO;
//                _refuseBtn.enabled = NO;
//                _refuseBtn.width = 60;
//                _refuseBtn.left = _enjoinBtn.left-20;
//                _refuseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//                [_refuseBtn setTitleColor:kTextColorGray forState:UIControlStateNormal];
//                [_refuseBtn setTitle:@"已谢绝" forState:UIControlStateNormal];
//            }
            
            //0未读，1已读，2已操作，3接受，4拒绝
            if ([self.sysmsgModel.status intValue] == 1 || [self.sysmsgModel.status intValue] == 0) {
                _refuseBtn.hidden = NO;
                _enjoinBtn.hidden = NO;
                statusLabel.hidden = YES;
            }else if ([self.sysmsgModel.status intValue] == 2){
                
            }else if ([self.sysmsgModel.status intValue] == 3){
                _refuseBtn.hidden = YES;
                _enjoinBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已接受";
            }else if ([self.sysmsgModel.status intValue] == 4){
                _refuseBtn.hidden = YES;
                _enjoinBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已拒绝";
            }
            break;
        case 12:// 退群消息
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"%@已退出 %@"  ,self.sysmsgModel.nick , self.sysmsgModel.title];            break;
        case 13:// 接受加入群
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"同意你加入 %@"  , self.sysmsgModel.title];
            break;
        case 14:// 拒绝好友加入群
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"谢绝你加入 %@"  , self.sysmsgModel.title];
            break;
        case 15:// 群主踢人
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"你已被请出 %@"  , self.sysmsgModel.title];
            break;
        case 22:// 别人给我打标签
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"%@给你打了新的标签 \"%@\""  ,self.sysmsgModel.nick , self.sysmsgModel.name];
            break;
        case 23:// 好友申请
            [_enjoinBtn setTitle:@"添加" forState:UIControlStateNormal];
            [_refuseBtn setTitle:@"忽略" forState:UIControlStateNormal];
            
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            [_intro4Lab setFrame:CGRectMake(_avatarView.right+13, _intro3Lab.bottom, kScreenWidth-45, 20)];
            
            if ([JYHelpers isEmptyOfString: self.sysmsgModel.friendlists] ) {
                _intro3Lab.text = @"0个共同好友";
            }else{
                _intro3Lab.text = [NSString stringWithFormat:@"共同好友:%@"  , self.sysmsgModel.friendlists];
            }
            _intro4Lab.text = @"申请成为你的好友";//[NSString stringWithFormat:@"%@申请成为你的好友"  , self.sysmsgModel.nick];

            //0未读，1已读，2已操作，3接受，4拒绝
            if ([self.sysmsgModel.status intValue] == 1 || [self.sysmsgModel.status intValue] == 0) {
                _refuseBtn.hidden = NO;
                _enjoinBtn.hidden = NO;
                statusLabel.hidden = YES;
            }else if ([self.sysmsgModel.status intValue] == 2){
                
            }else if ([self.sysmsgModel.status intValue] == 3){
                _refuseBtn.hidden = YES;
                _enjoinBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已接受";
            }else if ([self.sysmsgModel.status intValue] == 4){
                _refuseBtn.hidden = YES;
                _enjoinBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已拒绝";
            }
            
            break;
        case 24:// 新好友加入
            _nickLab.text =@"新好友加入";
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = [NSString stringWithFormat:@"%@( 通讯录好友： %@ )加入了，去个他贴个标签吧"  ,self.sysmsgModel.nick , self.sysmsgModel.uname];
            break;
        case 25:// 相册中点了赞照片
            [_intro3Lab setFrame:CGRectMake(_avatarView.right+13, _areaLab.bottom, kScreenWidth-100, 20)];
            
            _intro3Lab.text = @"赞了你的照片";
            
            
            //显示被 点赞的照片
            if ([self.sysmsgModel.photolists isKindOfClass:[NSDictionary class]]) {
                _likePicView.hidden = NO;
                NSString * picUrl = [[self.sysmsgModel.photolists objectForKey:self.sysmsgModel.pid] objectForKey:@"100"];
                
                _likePicView.frame = CGRectMake(_showTimeLab.right - 35, _showTimeLab.bottom+2, 35, 35);
                
                [_likePicView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
            }
            
            
            break;
        default:
            break;
    }
    
    
    
    if([self.sysmsgModel.privonce intValue]> 0 && [self.sysmsgModel.city intValue] > 0){
        line.frame =  CGRectMake(15.0f, 89, kScreenWidth-15.0f, 1.0f);
    }else if([JYHelpers isEmptyOfString:self.sysmsgModel.avatars]){
        line.frame =  CGRectMake(15.0f, 39, kScreenWidth-15.0f, 1.0f);
    }else{
        line.frame =  CGRectMake(15.0f, 69, kScreenWidth-15.0f, 1.0f);
    }
    
    _refuseBtn.top = _enjoinBtn.top = line.top - 25;

    
}


- (void)enjoinBtnClick:(UIButton *)btn{
    
    //[[JYAppDelegate sharedAppDelegate] showTip:@"发送中"];
    //11是加入群，23是好友申请
    if ([self.sysmsgModel.type intValue] == 11) {
        [self agreeAndRefuseJoinGroup:@"1"];
    }else{
        [self agreeAndRefuseJoinToFriend:@"1"];
    }
}

- (void)refuseBtnClick:(UIButton *)btn{
    //[[JYAppDelegate sharedAppDelegate] showTip:@"发送中"];
    //11是加入群，23是好友申请
    if ([self.sysmsgModel.type intValue] == 11) {
        [self agreeAndRefuseJoinGroup:@"2"];
    }else{
        [self agreeAndRefuseJoinToFriend:@"2"];
    }
}

- (void) agreeAndRefuseJoinGroup:(NSString *)type{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"chat" forKey:@"mod"];
    [parametersDict setObject:@"accept_friend_join_group" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:self.sysmsgModel.uid forKey:@"touid"];
    [postDict setObject:self.sysmsgModel.group_id forKey:@"group_id"];
    [postDict setObject:type forKey:@"type"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 ) {
            if ([type intValue] == 1) {
                self.sysmsgModel.acceptType = @"1";
                _enjoinBtn.hidden = YES;
                _refuseBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已添加";
                [self SetHandle:@"3"];
            }else{
                self.sysmsgModel.acceptType = @"2";
                _enjoinBtn.hidden = YES;
                _refuseBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已拒绝";
                [self SetHandle:@"4"];
            }
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
    
    //单条操作的消息，设为已读
    NSMutableDictionary *parametersDict2 = [NSMutableDictionary dictionary];
    [parametersDict2 setObject:@"msg" forKey:@"mod"];
    [parametersDict2 setObject:@"set_onread" forKey:@"func"];
    
    NSMutableDictionary *postDict2 = [NSMutableDictionary dictionary];
    [postDict2 setObject:@"addgroup" forKey:@"type"];
    [postDict2 setObject:self.sysmsgModel.iid forKey:@"iid"];
    
    [JYHttpServeice requestWithParameters:parametersDict2 postDict:postDict2 httpMethod:@"POST" success:^(id responseObject) {
        NSDictionary *msgDic = [[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount] mutableCopy];
        [msgDic setValue:[NSString stringWithFormat:@"%d",[msgDic[@"sys_change"] intValue]-1 ] forKey:@"sys_change"];
        [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
        //刷新tabbar的数字
        [[JYMsgUpdate sharedInstance] getSysMsgCount];
//         NSLog(@"%@",responseObject);
    } failure:^(id error) {
        
        
    }];

}

- (void)SetHandle:(NSString *)type{
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"msg" forKey:@"mod"];
    [parametersDict setObject:@"set_handled" forKey:@"func"];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    [postDict setObject:type forKey:@"operate"];
    [postDict setObject:self.sysmsgModel.iid forKey:@"iid"];
    [postDict setObject:UUID forKey:@"reg_meid"];
    [postDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"reg_version"];
    [postDict setObject:@"100" forKey:@"reg_channel_id"];
    [postDict setObject:@"ios" forKey:@"reg_mtype"];
    
    [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1 ) {
            
            self.sysmsgModel.status = type;
            
        } else {
            
        }
        
    } failure:^(id error) {
        
        
    }];
}

- (void) agreeAndRefuseJoinToFriend:(NSString *)type{
    if ([type intValue] == 1) {
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"friends" forKey:@"mod"];
        [parametersDict setObject:@"friends_accept_req" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"uid"];
        [postDict setObject:self.sysmsgModel.uid forKey:@"fuid"];
        
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1 ) {
                
                _enjoinBtn.hidden = YES;
                _refuseBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已接受";
                
                self.sysmsgModel.acceptType = @"1";
                [self SetHandle:@"3"];
                
            } else {
                
            }
            
        } failure:^(id error) {
            
            
        }];
    }else{
        NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
        [parametersDict setObject:@"friends" forKey:@"mod"];
        [parametersDict setObject:@"friends_rem_req" forKey:@"func"];
        
        NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
        [postDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] forKey:@"fuid"];
        [postDict setObject:self.sysmsgModel.uid forKey:@"uid"];
        [JYHttpServeice requestWithParameters:parametersDict postDict:postDict httpMethod:@"POST" success:^(id responseObject) {
            
            NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
            if (iRetcode == 1 ) {
                self.sysmsgModel.acceptType = @"2";
                _enjoinBtn.hidden = YES;
                _refuseBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已忽略";
                [self SetHandle:@"4"];
            } else {
                
            }
            
        } failure:^(id error) {
            
            
        }];
    }
    
    
    //单条操作的消息，设为已读
    NSMutableDictionary *parametersDict2 = [NSMutableDictionary dictionary];
    [parametersDict2 setObject:@"msg" forKey:@"mod"];
    [parametersDict2 setObject:@"set_onread" forKey:@"func"];
    
    NSMutableDictionary *postDict2 = [NSMutableDictionary dictionary];
    [postDict2 setObject:@"addfriend" forKey:@"type"];
    [postDict2 setObject:self.sysmsgModel.iid forKey:@"iid"];
    
    [JYHttpServeice requestWithParameters:parametersDict2 postDict:postDict2 httpMethod:@"POST" success:^(id responseObject) {
        NSDictionary *msgDic = [[[NSUserDefaults standardUserDefaults] objectForKey:kRefreshNewUnreadMessageCount] mutableCopy];
        [msgDic setValue:[NSString stringWithFormat:@"%d",[msgDic[@"sys_change"] intValue]-1 ] forKey:@"sys_change"];
        [[NSUserDefaults standardUserDefaults] setObject:msgDic forKey:kRefreshNewUnreadMessageCount];
        //刷新tabbar的数字
        [[JYMsgUpdate sharedInstance] getSysMsgCount];
//        NSLog(@"%@",responseObject);
    } failure:^(id error) {
        
        
    }];
}

//去到别人的profile
- (void)_gotoParentOtherProfile{
    JYOtherProfileController *otherVC = [[JYOtherProfileController alloc] init];
    [otherVC setShow_uid:self.sysmsgModel.uid];
    UITabBarController * mytab = (UITabBarController *)[JYAppDelegate sharedAppDelegate].window.rootViewController;
    [((UINavigationController *)[mytab selectedViewController]) pushViewController:otherVC animated:YES ];
    
}

@end
