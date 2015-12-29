//
//  ThemeCateListModel.h
//  TestRedCollar
//
//  Created by MC on 14-7-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeCateListModel : NSObject

@property int add_time;
@property int comment;
@property int end_time;
@property int id;
@property int is_hot;
@property int is_like;
@property int likes;
@property int praise_num;
@property int sort_order;
@property int start_time;

@property (copy,nonatomic) NSString *brief;
@property (copy,nonatomic) NSString *cat;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *design;
@property (copy,nonatomic) NSString *middle_img;
@property (copy,nonatomic) NSString *small_img;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *out_url;
@property (copy,nonatomic) NSArray *comment_list;

@end


