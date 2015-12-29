//
//  AboutViewController.m
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    self.title = @"关于我们";
    [self AddLeftImageBtn:[UIImage imageNamed:@"27"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:nil target:nil action:nil];
    
//    UIImageView *tImageView=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, 20, 250, 61)];
//    tImageView.image=[UIImage imageNamed:@"t_about.jpg"];
//    [self.view addSubview:tImageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.bounces = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    [self.view addSubview:scrollView];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 20, 300, 20);
    title.text = @"启程，一衣一世界，红领铸就经典";
    title.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:title];
    
    UILabel *content1 = [[UILabel alloc] init];
    content1.frame = CGRectMake(10, 40, 300, 80);
    content1.text = @"        从1995年11月1日第一件红领西服的诞生到现在，经验，使红领在各个环节都步向成熟。";
    content1.lineBreakMode = NSLineBreakByCharWrapping;
    content1.numberOfLines = 0;
    content1.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content1];
    
    UILabel *content2 = [[UILabel alloc] init];
    content2.frame = CGRectMake(10, 115, 300, 320);
    content2.text = @"       作为青岛的骄傲、中国的骄傲，18年前，红领稚嫩的起步刻画了父辈难忘的历史华光，一套红领西装承载了父辈们太多的故事，时至今日，西装品牌层出不穷，但是没有哪个品牌可以替代他们心中的那份“红领情结”，在他们心目中，红领不只是一套西装，而是男人自豪的过去，对家庭、事业、社会的一份责任记忆。18年中，红领大步跨越书写了一份青岛品牌、中国企业的腾飞历程，品质名牌、时尚品牌、高端符号……18年后的今天，红领已经活跃在世界舞台上，量身定制MTM 服饰风靡欧美，与世界大牌服饰媲美，跻身世界顶级西装定制序列。";
    content2.lineBreakMode = NSLineBreakByCharWrapping;
    content2.numberOfLines = 0;
    content2.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content2];
    
    UILabel *content3 = [[UILabel alloc] init];
    content3.frame = CGRectMake(10, 435, 300, 50);
    content3.text = @"       此刻开始，红领是在世界舞台上镌刻中国男人的精彩。";
    content3.lineBreakMode = NSLineBreakByCharWrapping;
    content3.numberOfLines = 0;
    content3.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:content3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
