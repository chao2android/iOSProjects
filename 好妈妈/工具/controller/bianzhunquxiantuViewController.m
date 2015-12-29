//
//  bianzhunquxiantuViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-11-12.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "bianzhunquxiantuViewController.h"

@interface bianzhunquxiantuViewController ()

@end

@implementation bianzhunquxiantuViewController

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
  self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.89 alpha:1.0];

  UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
  navigation.backgroundColor=[UIColor blackColor];
  navigation.userInteractionEnabled=YES;
  navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
  [self.view addSubview:navigation];
  [navigation release];
  
  UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
  backBut.frame=CGRectMake(5, 6, 45, 30.5);
  [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
  [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
  [navigation addSubview:backBut];
  
  UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, Screen_Width-100, 44)];
  titLab.text = @"标准生长曲线图";
  titLab.textAlignment = 1;
  titLab.backgroundColor = [UIColor clearColor];
  titLab.textColor = [UIColor whiteColor];
  titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
  [navigation addSubview:titLab];
  [titLab release];
  
  
  _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, Screen_Width, Screen_Height-44)];
  [self.view addSubview:_scrollView];
  [_scrollView release];
  
  bgView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"001_22.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:40]];
  bgView.userInteractionEnabled = YES;
  bgView.tag = 1000;
  
    [_scrollView addSubview:bgView];
  [bgView release];

  int iHeight = 2050;
  int iLeft = 5;
  if (ISIPAD) {
    iLeft = 20;
    iHeight = 1320;
  }
  UILabel *shuomingLab = [[UILabel alloc]initWithFrame:CGRectMake(iLeft, 10, self.view.frame.size.width-10-iLeft*2,iHeight)];
  shuomingLab.numberOfLines = 0;
  shuomingLab.text = @"　　2006年4月27日世界卫生组织公布了一套新的《儿童发育标准》(Child Growth Standards)，为国际社会衡量婴幼儿是否健康成长提供了最新的依据。这套新标准显示，在6岁之前，婴幼儿成长的最重要决定因素不是遗传和种族，而是营养、哺育方式、环境和医疗保健。\n\n　　无论一个婴儿出生在世界上什么地方，只要得到适当营养和关照，其成年后的身高和体重就可和世界上其他地方的人媲美。\n\n　　世界卫生组织说，这次研究挑选了巴西、加纳、印度、挪威、阿曼和美国的8000多名婴幼儿作为观察对象。这些婴幼儿都生活在最佳的哺育环境中，例如，他们都是母乳喂养的，而且他们的母亲都不吸烟。\n\n　　“世界卫生组织的《儿童发育标准》为确保儿童们在关键时期的成长提供了一个新的手段。这种工具将有助于降低婴幼儿死亡率和患病率。”例如，用这些标准进行衡量，就很容易知道一个婴幼儿到底是否有营养不良或肥胖超重的情况。\n\n\n\n\n\n\n\n\n\n\n\n\n　　用生长曲线检测孩子的身高、体重的发育，比起简单用一个数字断定孩子是高是胖要更科学。使用方法如下：\n\n　　1、做顺时记录。\n\n　　每个月为孩子测量一次身高、体重，把测量结果描绘在生长曲线图上，连成一条曲线。如果孩子的生长曲线一直在正常值范围内（3号线到-3号线之间）匀速顺时增长就是正常的。有些孩子的生长速度比较快，生长曲线呈斜线，只要一直在正常值范围内就不用担心。\n\n　　误区：追求最高值，认为平均值以下就是不正常。\n\n　　孩子的生长发育与遗传、饮食习惯等多种因素有关，每个孩子的生长发育曲线都不同。平均值曲线不是判断发育正常与否的标准。即使孩子的生长曲线一直在平均曲线之下，最低值曲线之上，只要一直在匀速顺时增长就是正常的。\n\n　　2、做动态观察。\n\n　　每2-3个月对生长曲线增长速度进行一次横向比较，如果出现突然增（减）速，就要提起注意，定期体检时可向医生讲述情况，听取医生的建议。\n\n　　误区：生长曲线突破正常值才引起注意。\n\n　　很多父母都是在孩子的身高、体重超出或低出正常值勤后才发现问题，似乎有点亡羊补牢。生长曲线总是超过2号线，或低于-2号线时，就应提起注意，是不是你的喂养方式有问题，或者孩子的健康是不是出现异常。此时你可以咨询医生，是否需要进行干涉。\n\n　　3、BMI曲线观测。\n\n　　计算出孩子的BMI值，描绘在BMI曲线上，曲线匀速顺时增长为正常。\n\n　　误区：忽视BMI曲线。\n\n　　BMI指数也是肥胖指数标准，不能被忽视。它的曲线图增长速度比身高、体重要慢，最好能保持在2号线到-2号线之间，平稳地前进。一旦超出正常值（3号线到-3号线之间）或递增（减）速度过快，就要带宝宝到医院检查。";
  shuomingLab.textColor = [UIColor grayColor];
  shuomingLab.backgroundColor = [UIColor clearColor];
  shuomingLab.userInteractionEnabled = YES;
  [bgView addSubview:shuomingLab];
  
  shuomingLab.tag = 1001;
  [shuomingLab release];
  
  
  int height = shuomingLab.frame.origin.y + shuomingLab.frame.size.height +15;
  
  bgView.frame = CGRectMake(5, 5, self.view.frame.size.width-10, height);
  _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height +30);
  
  
  UIScrollView  *myscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 610,  self.view.frame.size.width-10-iLeft*2, 200)];
  myscrollView.backgroundColor = [UIColor clearColor];
  myscrollView.pagingEnabled = YES;
  [shuomingLab addSubview:myscrollView];
  [myscrollView release];
  
  for (int i = 0; i < 6; i ++) {
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-10-iLeft*2)*i, 0, self.view.frame.size.width-10-iLeft*2, 200)];
    if (ISIPAD) {
      iv.frame =CGRectMake((self.view.frame.size.width-10-iLeft*2-300)*i, 0, self.view.frame.size.width-10-iLeft*2-300, 220);
    }
    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"quxian%d.jpg",i]];
    [myscrollView addSubview:iv];
    [iv release];
  }
  
  myscrollView.contentSize = CGSizeMake((self.view.frame.size.width-10-iLeft*2) *6, 200);
  if (ISIPAD) {
    myscrollView.frame = CGRectMake(150, 320,  self.view.frame.size.width-10-iLeft*2-300, 220);
    myscrollView.contentSize = CGSizeMake((self.view.frame.size.width-10-iLeft*2-300) *6, 220);
  }

}

- (void)clicked_backBut{
  
  [self.navigationController popViewControllerAnimated:YES];

}

@end
