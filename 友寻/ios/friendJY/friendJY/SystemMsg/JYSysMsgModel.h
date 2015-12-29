//
//  JYSysMsgModel.h
//  friendJY
//
//  Created by ouyang on 5/5/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYSysMsgModel : JYBaseModel
/*
 avatars = "http://p.friendly.dev/16/58/e5eba4ac4ebcff40a9d84943bd057cd6/161550100a.jpg?wh=100x100";
 city = 9932;
 friendnick = "";
 "group_id" = 13650;
 iid = 2859050;
 logo = "http://p.friendly.dev/09/08/fa75cfc3dec2753c75b0c2bf303429d9/_100i.jpg?wh=0x0";
 nick = 12345678997889;
 privonce = 99;
 relation = 2;
 sendtime = 1430720393;
 title = "\U9ed1bai";
 status = 2;
 type = 11;
 uid = 2165850;
 */

@property (nonatomic,strong) NSString *avatars;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *friendnick;
@property (nonatomic,strong) NSString *group_id;
@property (nonatomic,strong) NSString *iid;
@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSString *nick;
@property (nonatomic,strong) NSString *privonce;
@property (nonatomic,strong) NSString *relation;
@property (nonatomic,strong) NSString *sendtime;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *pid;
@property (nonatomic,strong) NSDictionary * photolists;
@property (nonatomic,strong) NSString *friendlists;
@property (nonatomic,strong) NSString *acceptType;
@property (nonatomic,strong) NSString *name; //标签名
@property (nonatomic,strong) NSString *uname; //好友数

@end
