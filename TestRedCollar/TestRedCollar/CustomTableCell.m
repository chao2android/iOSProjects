//
//  CustomTableCell.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CustomTableCell.h"
#import "TouchView.h"

@implementation CustomTableCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        backView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, 170)];
        backView.userInteractionEnabled = YES;
        //backView.image = [[UIImage imageNamed:@"f_customback"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
        [self.contentView addSubview:backView];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 1, 1, backView.frame.size.height-2)];
//        lineView.backgroundColor = [UIColor colorWithWhite:0.83 alpha:1.0];
//        [backView addSubview:lineView];
//        
//        lineView = [[UIView alloc] initWithFrame:CGRectMake(180, 1, 1, backView.frame.size.height-2)];
//        lineView.backgroundColor = [UIColor colorWithWhite:0.83 alpha:1.0];
//        [backView addSubview:lineView];
//        
//        lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 145, 90, 1)];
//        lineView.backgroundColor = [UIColor colorWithWhite:0.83 alpha:1.0];
//        [backView addSubview:lineView];
//        
//        lineView = [[UIView alloc] initWithFrame:CGRectMake(180, 115, 131, 1)];
//        lineView.backgroundColor = [UIColor colorWithWhite:0.83 alpha:1.0];
//        [backView addSubview:lineView];
//        
        TouchView *titleView = [[TouchView alloc] initWithFrame:CGRectMake(0, 0, 125, 45)];
        titleView.delegate = self;
        titleView.OnViewClick = @selector(OnTitleClick);
        titleView.image = [UIImage imageNamed:@"9.png"];
        [backView addSubview:titleView];
        
        mlbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, titleView.frame.size.width-15, 24)];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.font = [UIFont boldSystemFontOfSize:19];
        mlbTitle.textAlignment = UITextAlignmentCenter;
        mlbTitle.textColor = [UIColor whiteColor];
        mlbTitle.text = @"西装定制";
        [backView addSubview:mlbTitle];

//        UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, titleView.frame.size.width, 24)];
//        lbDesc.backgroundColor = [UIColor clearColor];
//        lbDesc.font = [UIFont boldSystemFontOfSize:11];
//        lbDesc.textAlignment = UITextAlignmentCenter;
//        lbDesc.textColor = [UIColor whiteColor];
//        lbDesc.text = @"查看全部";
//        [backView addSubview:lbDesc];
        
        for (int i = 0; i < 4; i ++) {
            CGRect rect = CGRectMake(0, 47, 125, 123);
            if (i == 1) {
                rect = CGRectMake(128, 0, 90, 170);
            }
            else if (i == 2) {
                rect = CGRectMake(220, 0, 90, 85);
            }
            else if (i == 3) {
                rect = CGRectMake(220, 85, 90, 85);
            }
            TouchView *imageView = [[TouchView alloc] initWithFrame:rect];
            imageView.delegate = self;
            imageView.OnViewClick = @selector(OnImageClick:);
            imageView.tag = i+1000;
            [backView addSubview:imageView];
            
            UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height-14, imageView.frame.size.width, 14)];
            grayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            [imageView addSubview:grayView];
            
            UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, grayView.frame.size.width-10, grayView.frame.size.height)];
            lbName.backgroundColor = [UIColor clearColor];
            lbName.textColor = [UIColor whiteColor];
            lbName.font = [UIFont systemFontOfSize:10];
            lbName.text = @"基本款W12";
            [grayView addSubview:lbName];
        }
    }
    return self;
}

- (void)OnTitleClick {
    if (delegate && [delegate respondsToSelector:@selector(OnCustomListSelect:)]) {
        [delegate OnCustomListSelect:self];
    }
}

- (void)OnImageClick:(TouchView *)sender {
    int index = sender.tag-1000;
    if (delegate && [delegate respondsToSelector:@selector(OnCustomImageSelect::)]) {
        [delegate OnCustomImageSelect:self :index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)LoadContent:(NSDictionary *)dict {
    mlbTitle.text = [dict objectForKey:@"name"];
    for (int i = 0; i < 5; i ++) {
        NSString *key = [NSString stringWithFormat:@"image%d", i+1];
        NSString *imagename = [NSString stringWithFormat:@"%@.png", [dict objectForKey:key]];
        UIImageView *imageView = (UIImageView *)[backView viewWithTag:1000+i];
        imageView.image = [UIImage imageNamed:imagename];
    }
}

@end
