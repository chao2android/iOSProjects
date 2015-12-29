//
//  SubGoodsView.m
//  TestRedCollar
//
//  Created by MC on 14-7-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SubGoodsView.h"

@implementation SubGoodsView

@synthesize delegate,didSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        btn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [btn addTarget:self action:@selector(DidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)DidClicked
{
    if (delegate && didSelected) {
        [delegate performSelector:didSelected withObject:[NSNumber numberWithInt:self.tag]];
    }
}
- (void)createUI
{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 55, 70)];
    [self addSubview:_imgView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, 235, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, 230, 40)];
    _desLabel.numberOfLines = -1;
    _desLabel.font = [UIFont systemFontOfSize:14];
    _desLabel.textColor = [UIColor grayColor];
//    _desLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_desLabel];
}
- (void)loadContent:(NSDictionary *)dict
{
    self.imgView.image =  [UIImage imageNamed:[dict objectForKey:@"img"]];
    self.nameLabel.text = [dict objectForKey:@"title"];
    self.desLabel.text = [dict objectForKey:@"des"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
