//
//  chanjianViewController.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "chanjianViewController.h"
#import "TuiSongTongZhi.h"
@interface UIView (ss)
-(void)removeAllSubviewss;

@end

@implementation UIView (ss)

-(void)removeAllSubviewss{
    for (id cc in [self subviews]) {
        [cc removeFromSuperview];
    }
}
@end


@interface chanjianViewController ()

@end

@implementation chanjianViewController

-(void)dealloc{
    [super dealloc];
    [_smArr release];
    [_yzArr release];
    [_czArr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    panduanBool=NO;
      if (ISIPAD) {
        miFontSize = 20;
        self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.89 alpha:1.0];
    }
    else {
        miFontSize = 15;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底.png"]];
    }
    
    UIImageView * navigation=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, KUIOS_7(44))];
    navigation.backgroundColor=[UIColor blackColor];
    navigation.userInteractionEnabled=YES;
    navigation.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_background" ofType:@"png"]];
    [self.view addSubview:navigation];
    [navigation release];
    
    UIButton * backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame=CGRectMake(5, KUIOS_7(6), 45, 30.5);
    [backBut addTarget:self action:@selector(clicked_backBut) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"001_4" ofType:@"png"]] forState:UIControlStateNormal];
    [navigation addSubview:backBut];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(100, KUIOS_7(0), navigation.frame.size.width-200, 44)];
    titLab.text = @"产检提醒";
    titLab.textAlignment = 1;
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor whiteColor];
    titLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [navigation addSubview:titLab];
    [titLab release];
    
    
    _uitable = [[UITableView alloc]initWithFrame:CGRectMake(0, KUIOS_7(44), Screen_Width, Screen_Height - 44-20) style:UITableViewStylePlain];
    _uitable.delegate = self;
    _uitable.dataSource = self;
    _uitable.backgroundColor = [UIColor clearColor];
    
    _uitable.contentInset = UIEdgeInsetsMake(380.0f, 0.0f, 0, 0.0f);
    
    _uitable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_uitable];
    [_uitable release];
    
    dataBgView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height, self.view.frame.size.width, 260)];
    dataBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wheel_shadow@2x.png"]];
    [self.view addSubview:dataBgView];
    [dataBgView release];
    
    UIButton *dBut = [UIButton buttonWithType:UIButtonTypeCustom];
    dBut .frame = CGRectMake(self.view.frame.size.width-50, 10, 30, 20);
    [dBut addTarget:self action:@selector(clicked_dBut) forControlEvents:UIControlEventTouchUpInside];
    [dBut setImage:[UIImage imageNamed:@"check_selected@2x.png"] forState:UIControlStateNormal];
    [dataBgView addSubview:dBut];
    
    
    dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, dataBgView.frame.size.width, 0)];
    dataPicker.backgroundColor = [UIColor whiteColor];
	dataPicker.datePickerMode = UIDatePickerModeDate;
	[dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	[dataBgView addSubview:dataPicker];
	[dataPicker release];
    
    
//    NSDate *newdate = [NSDate dateWithTimeInterval:3600*24*280 sinceDate: [NSDate date]];
    NSDate *newdate1 = [NSDate dateWithTimeInterval:3600*24 sinceDate: [NSDate date]];

//    NSLog(@"newDate = %@",newdate);
    dataPicker.minimumDate = newdate1;
//    dataPicker.maximumDate =  newdate;
    
    int samiLeft = (self.view.frame.size.width-320)/2;
    
    UILabel *samLab = [[UILabel alloc]initWithFrame:CGRectMake(15+samiLeft, -370, 290, 40)];
    samLab.textAlignment =0;
    samLab.text = @"      您的预产期：";
    samLab.backgroundColor = [UIColor clearColor];
    samLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [_uitable addSubview:samLab];
    [samLab release];
    
    CALayer* l1=[samLab layer];
    [l1 setMasksToBounds:YES];
    //  [l1 setCornerRadius:6];
    [l1 setBorderWidth:1];
    [l1 setBorderColor:[[UIColor grayColor]CGColor]];
    
    
  
    
    dataLab = [[UILabel alloc]initWithFrame:CGRectMake(160+samiLeft, -370, 140, 40 )];
    dataLab.backgroundColor = [UIColor clearColor];
    dataLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [_uitable addSubview:dataLab];
    [dataLab release];
    
    NSDictionary * userDic=[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];
    NSLog(@"%@",userDic);
    UIImage *image = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    
    UIButton *tuisuanBut=[UIButton buttonWithType:UIButtonTypeCustom];
    tuisuanBut.frame=CGRectMake((self.view.frame.size.width-130)/2, -320, 130, 40);
    if ([[userDic valueForKey:@"type"] intValue]==2) {
        tuisuanBut.frame=CGRectMake((self.view.frame.size.width-260)/2/2, -320, 130, 40);
    }
    [tuisuanBut addTarget:self action:@selector(clicked_tuisuanBut) forControlEvents:UIControlEventTouchUpInside];
    [tuisuanBut setBackgroundImage:image forState:UIControlStateNormal];
    [tuisuanBut setTitle:@"计算" forState:UIControlStateNormal];
    [tuisuanBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tuisuanBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_uitable addSubview:tuisuanBut];
    sam_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -280, Screen_Width, 200)];
//    sam_bgView.backgroundColor = [UIColor redColor];
    [_uitable addSubview:sam_bgView];
    [sam_bgView release];

    if ([[userDic valueForKey:@"type"] intValue]==2) {
        tuisuanBut.userInteractionEnabled=NO;
        dataLab.text=[userDic valueForKey:@"birthday"];
        [self clicked_tuisuanBut];
    }
    else
    {
        UIButton * dataBut = [UIButton buttonWithType:UIButtonTypeCustom];
        dataBut.frame = CGRectMake(160+samiLeft, -370, 140, 40 );
        [dataBut addTarget: self action:@selector(clicked_dataBut) forControlEvents:UIControlEventTouchUpInside];
        [_uitable addSubview:dataBut];
        tuisuanBut.userInteractionEnabled=YES;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @" yyyy-MM-dd";
        NSString * daStr = [dateFormatter stringFromDate:dataPicker.date];
        dataLab.text = daStr;
        NSString * tishiString=[[NSString alloc]init];
        if ([[userDic valueForKey:@"type"] intValue]==1) {
            tishiString=@"您设置的是已有宝宝，确定使用产检提醒吗？";
        }
        else
        {
            tishiString=@"您设置的是备孕，确定使用产检提醒吗？";
        }
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:tishiString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=1;
        [alertView show];
        [alertView release];
        [tishiString release];
    }
    xiacichanjianView=[[UIImageView alloc]initWithFrame:CGRectMake(20, Screen_Height, Screen_Width-40, 150)];
    xiacichanjianView.image=[UIImage imageNamed:@"底.png"];
    xiacichanjianView.userInteractionEnabled=YES;
    [self.view addSubview:xiacichanjianView];
    [xiacichanjianView release];
    for (int i=0; i<2; i++) {
        UIButton * pickerBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [pickerBut setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"钮" ofType:@"png"]] forState:UIControlStateNormal];
        if (i==0) {
            [pickerBut setTitle:@"取消" forState:UIControlStateNormal];
        }
        else
        {
            [pickerBut setTitle:@"确定" forState:UIControlStateNormal];
        }
        pickerBut.tag=i;
        pickerBut.titleLabel.font=[UIFont systemFontOfSize:14];
        [pickerBut addTarget:self action:@selector(PickerMenth:) forControlEvents:UIControlEventTouchUpInside];
        pickerBut.frame=CGRectMake(15+i*(xiacichanjianView.frame.size.width-47-25), 5, 47, 30);
        [xiacichanjianView addSubview:pickerBut];
        
    }
    UILabel *xiacichanjianLab = [[UILabel alloc]initWithFrame:CGRectMake(5+samiLeft, 60, 270, 40)];
    xiacichanjianLab.textAlignment =0;
    xiacichanjianLab.text = @" 您的下次产检日期：";
    xiacichanjianLab.backgroundColor = [UIColor clearColor];
    xiacichanjianLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    xiacichanjianLab.font=[UIFont systemFontOfSize:16];
    [xiacichanjianView addSubview:xiacichanjianLab];
    [xiacichanjianLab release];
    CALayer* l2=[xiacichanjianLab layer];
    [l2 setMasksToBounds:YES];
    //  [l1 setCornerRadius:6];
    [l2 setBorderWidth:1];
    [l2 setBorderColor:[[UIColor grayColor]CGColor]];
    xiacichanjianLabel = [[UILabel alloc]initWithFrame:CGRectMake(145+samiLeft, 60, 135, 40 )];
    xiacichanjianLabel.backgroundColor = [UIColor clearColor];
    xiacichanjianLabel.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [xiacichanjianView addSubview:xiacichanjianLabel];
    [xiacichanjianLabel release];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @" yyyy-MM-dd";
    NSString * daStr = [dateFormatter stringFromDate:dataPicker.date];
    xiacichanjianLabel.text = daStr;

}
//- (void)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        
    
    if (!buttonIndex) {
        [self clicked_backBut];
    }
    }
    else
    {
    
        if (buttonIndex) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];

            NSArray *days1=[[NSArray alloc]initWithObjects:@"78",@"85",@"113",@"141",@"169",@"197",@"225",@"246",@"253",@"260",@"267",@"274", nil];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date2 = [dateFormatter dateFromString:dataLab.text];
            NSDate *yDate =[NSDate dateWithTimeInterval:-280*24*3600 sinceDate: date2];
            [dateFormatter release];
            for (int i=0; i<days1.count; i++) {
                [TuiSongTongZhi CteLocalNotification:[TuiSongTongZhi ChanJianTuiSongShiJianMenth1:huaiyunday%7+[[days1 objectAtIndex:i] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:yDate]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，明天该去做【第%d次产检：%@】",i+1,[_czArr objectAtIndex:i]] TuisongName:[NSString stringWithFormat:@"%d==mt-=-=%@",i,[_czArr objectAtIndex:i]]];

                [TuiSongTongZhi CteLocalNotification:[TuiSongTongZhi ChanJianTuiSongShiJianMenth:huaiyunday%7+[[days1 objectAtIndex:i] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:yDate]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",i+1,[_czArr objectAtIndex:i]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",i,[_czArr objectAtIndex:i]]];
            }

        }
    }
}
-(void)initWithSting{
    _czArr=[[NSMutableArray alloc]initWithObjects:@"第1次产检:办理“孕妇健康手册”·各项基本检查",@"第2次产检:唐氏症筛检·羊膜穿刺",@"第3次产检:详细超声波检查",@"第4次产检:妊娠糖尿病筛检",@"第5次产检:乙型肝炎检查·梅毒血清试验",@"第6次产检:下肢水肿检查·子痫前症·预防早产",@"第7次产检:超声波检查·评估胎儿体重",@"第8次产检:为生产事宜做准备",@"第9次检查:注意胎动",@"第10次产检:胎位固定·胎头入盆·准备生产", @"第11次产检:准备生产",@"第12次产检:准备生产",@"第13次产检:准备生产",@"第14次产检:考虑催产",nil];
    _yzArr = [[NSMutableArray alloc]initWithObjects:@"怀孕12周",@"怀孕13—16周",@"怀孕17—20周",@"怀孕21—24周",@"怀孕25—28周",@"怀孕29—32周",@"怀孕33—35周",@"怀孕36周",@"怀孕37周",@"怀孕38周", nil];
    _smArr = [[NSMutableArray alloc]initWithObjects:@"　　准妈妈在孕期第12周时正式开始进行第1次产检。一般医院会给妈妈们办理“孕妇健康手册”。日后医师为每位准妈妈做各项产检时，也会依据手册内记载的检查项目分别进行并做记录。",@"　　准妈妈要做第2次产检。除基本的例行检查外，准妈妈在16周以上，可抽血做唐氏综合征筛检，并看第1次产检的抽血报告。16～20周开始进行羊膜穿刺，主要是看胎儿的染色体异常与否。",@"　　准妈妈要做第3次产检。在孕期20周做超声波检查，主要是看胎儿外观发育上是否有较大问题，医师会仔细量胎儿的头围、腹围、看大腿骨长度及检视脊柱是否有先天性异常。",@"　　准妈妈要做第4次产检。大部分妊娠糖尿病的筛检，是在孕期第24周做。如准妈妈有妊娠糖尿病，在治疗上，要采取饮食调整，如果调整饮食后还不能将餐后血糖控制在理想范围，则需通过注射胰岛素来控制，孕期不能使用口服的降血糖药物来治疗，以免造成胎儿畸形。",@"　　准妈妈要做第5次产检。此阶段最重要的是为准妈妈抽血检查乙型肝炎，目的是要检视准妈妈本身是否携带乙型肝炎病毒，如果准妈妈的乙型肝炎两项检验皆呈阳性反应，一定要在准妈妈生下胎儿24小时内，为新生儿注射疫苗，以免让新生儿遭受感染。此外，要再次确认准妈妈前次所做的梅毒反应，是呈阳性还是阴性反应。如此方能在胎儿未出生前，即为准妈妈彻底治疗梅毒。",@"　　准妈妈要做第6次产检。医师要陆续为准妈妈检查是否有水肿现象。由于大部分的子痫前症，会在孕期28周以后发生，如果测量结果发现准妈妈的血压偏高，又出现蛋白尿、全身水肿等情况时，准妈妈须多加留意，以免有子痫前症的危险。另外，准妈妈在37周前，要特别预防早产的发生，如果阵痛超过 30分钟以上且持续增加，又合并有阴道出血或出水现象时，一定要立即送医院检查。",@"　　准妈妈要做第7次产检。到了孕期34周时，准妈妈要做一次详细的超声波检查，以评估胎儿当时的体重及发育状况，并预估胎儿至足月生产时的重量。一旦发现胎儿体重不足，准妈妈就应多补充一些营养素;若发现胎儿过重，准妈妈在饮食上就要稍加控制，以免日后需要剖宫生产，或在生产过程中出现胎儿难产情形。",@"　　从36周开始，准妈妈愈来愈接近生产日期，此时所做的产检，以每周检查1次为原则，并持续监视胎儿的状态。",@"　　37周进行第9次产检。由于胎动愈来愈频繁，准妈妈宜随时注意胎儿及自身的情况，以免胎儿提前出生。",@"　　从38周开始，胎位开始固定，胎头已经下来，并卡在骨盆腔内，此时准妈妈应有随时准备生产的心理。有的准妈妈到了42周以后，仍没有生产迹象，就应考虑让医师使用催产素。", nil];
//    从33周开始，产检应变为每周一次，每次检查的内容没有明显的变化，如：测量体重、宫高、腹围、心率、血压、胎心，定期测量血尿常规等项目。不同的是，我们要开始做胎心监护了。
    
}

-(void)clicked_tuisuanBut{
    [self clicked_dBut];
    
    [self initWithSting];
    [_uitable reloadData];

    [sam_bgView removeAllSubviewss];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormatter dateFromString:dataLab.text];
    NSDate *yDate =[NSDate dateWithTimeInterval:-280*24*3600 sinceDate: date1];
    [dateFormatter release];
    
    NSArray *arr = [self cjWithDate:yDate];
    NSLog(@"%@",arr[4]);
    UILabel *bLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, self.view.frame.size.width-80, 40)];
    bLab.backgroundColor = [UIColor clearColor];
    bLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    bLab.numberOfLines = 0;
    bLab.font = [UIFont systemFontOfSize:14];
    bLab.text = [NSString stringWithFormat:@"本次产检：\n%@~%@",arr[0],arr[1]];
    [sam_bgView addSubview:bLab ];
    [bLab release];
    UILabel * czLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-80, 40)];
    czLab.backgroundColor = [UIColor clearColor];
    czLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    czLab.numberOfLines = 0;
    czLab.font = [UIFont systemFontOfSize:14];
//    if ([arr[4]intValue]/2>10) {
//        czLab.text = [_czArr objectAtIndex:10];
//    }
//    else
//    {
//        if ([arr[4]intValue]/2) {
    if ([arr[4]intValue]/2>12) {
        czLab.text = [_czArr objectAtIndex:13];

    }
    else
    {
            czLab.text = [_czArr objectAtIndex:[arr[4]intValue]/2];
    }
    
//        }
//        else
//        {
//            czLab.text = [_czArr objectAtIndex:[arr[4]intValue]/2+1];
//            
//        }
//    }
    [sam_bgView addSubview:czLab];
    [czLab release];
    NSDictionary * userDic=[[NSUserDefaults standardUserDefaults]valueForKey:@"logindata"];
    
    if ([[userDic valueForKey:@"type"] intValue]==2) {
   

     tixingbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    tixingbutton.frame=CGRectMake(self.view.frame.size.width-(self.view.frame.size.width-260)/2/2-130, -320, 130, 40);
    [tixingbutton addTarget:self action:@selector(TiXingMenth) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image11 = [[UIImage imageNamed:@"004_钮.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];

    [tixingbutton setBackgroundImage:image11 forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chanjiantixing"]) {
         [tixingbutton setTitle:@"取消提醒" forState:UIControlStateNormal];

        }
        else
        {
    [tixingbutton setTitle:@"提醒我" forState:UIControlStateNormal];
            if (([[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]==41&&[[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:2] intValue])||[[[[userDic valueForKey:@"age"] componentsSeparatedByString:@"-"] objectAtIndex:1] intValue]>41) {
                tixingbutton.enabled=NO;
            }
            NSLog(@"%@",userDic);
        }
    tixingbutton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_uitable addSubview:tixingbutton];
    }
    UILabel *nLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, self.view.frame.size.width-80, 40)];
    nLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    nLab.backgroundColor = [UIColor clearColor];
    nLab.font = [UIFont systemFontOfSize:14];
    nLab.numberOfLines = 0;
    nLab.text = [NSString stringWithFormat:@"下次产检：\n%@~%@",arr[2],arr[3]];
    [sam_bgView addSubview:nLab ];
    [nLab release];
    czLab= [[UILabel alloc]initWithFrame:CGRectMake(10, 150, self.view.frame.size.width-80, 40)];
    czLab.backgroundColor = [UIColor clearColor];
    czLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    czLab.numberOfLines = 0;
    czLab.font = [UIFont systemFontOfSize:14];
    NSLog(@"%d %d",[arr[4]intValue]/2,_czArr.count);
    if ([arr[4]intValue]/2>12) {
        czLab.text = [_czArr objectAtIndex:13];
    }
    else
    {

            czLab.text = [_czArr objectAtIndex:[arr[4]intValue]/2+1];
    }
    
    [sam_bgView addSubview:czLab];
    [czLab release];
    
    
    bgL = [[UIView alloc]initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, 70)];
    [sam_bgView addSubview:bgL];
    [bgL release];
    
    UILabel *tLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 29)];
    tLab.backgroundColor = [UIColor colorWithRed:230/255.0f green:242/255.0f blue:247/255.0f alpha:1];
    tLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    tLab.textAlignment = 1;
    tLab.font = [UIFont systemFontOfSize:miFontSize];
    tLab.text = @"产检时间表";
    [bgL addSubview:tLab];
    [tLab release];
    UILabel * wL = [[UILabel alloc]initWithFrame:CGRectMake(0,29, self.view.frame.size.width, 1)];
    wL.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    wL.alpha = 0.5f;
    [bgL addSubview:wL];
    [wL release ];
    
    int iLeft = self.view.frame.size.width*120/320;
    
    UILabel *L = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, iLeft, 40)];
    L.backgroundColor = [UIColor colorWithRed:230/255.0f green:242/255.0f blue:247/255.0f alpha:1];
    L.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    L.textAlignment = 1;
    L.font = [UIFont systemFontOfSize:miFontSize];
    L.text = @"孕周";
    [bgL addSubview:L];
    [L release];
    
    UILabel *L2 = [[UILabel alloc]initWithFrame:CGRectMake(iLeft+1, 30, self.view.frame.size.width-iLeft-1, 40)];
    L2.backgroundColor = [UIColor colorWithRed:230/255.0f green:242/255.0f blue:247/255.0f alpha:1];
    L2.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    L2.textAlignment = 1;
    L2.font = [UIFont systemFontOfSize:miFontSize];
    L2.text = @"说明";
    [bgL addSubview:L2];
    [L2 release];
    
    
    UILabel * lineL = [[UILabel alloc]initWithFrame:CGRectMake(iLeft, 30, 1, 40)];
    lineL.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];;
    lineL.alpha = 0.5f;
    [bgL addSubview:lineL];
    [lineL release ];
    

}
- (void)TiXingMenth
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"chanjiantixing"]) {
        
    
    [tixingbutton setTitle:@"提醒我" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"chanjiantixing"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }

    panduanBool=YES;
    NSDate *newdate1 = [NSDate dateWithTimeInterval:3600*24 sinceDate: [NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormatter dateFromString:dataLab.text];
    [dateFormatter release];
    dataPicker.minimumDate = newdate1;
    dataPicker.maximumDate =  date1;
    [dataPicker reloadInputViews];
    [UIView animateWithDuration:0.5 animations:^{
        xiacichanjianView.frame=CGRectMake(20, 60, Screen_Width-40, 150);
        dataBgView.frame = CGRectMake(0, Screen_Height-260, self.view.frame.size.width, 260);

    }];
    
//    [TuiSongTongZhi CteLocalNotification:5 TuisongContent:@"您今天需要产检了。" TuisongName:@"第一次"];
}
- (void)PickerMenth:(UIButton *)sender
{
    if (sender.tag) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date1 = [dateFormatter dateFromString:xiacichanjianLabel.text];
        NSDate *date2 = [dateFormatter dateFromString:dataLab.text];
        NSDate *yDate =[NSDate dateWithTimeInterval:-280*24*3600 sinceDate: date2];

        NSLog(@"%@  %@",xiacichanjianLabel.text,dataLab.text);
        [dateFormatter release];
        [self  cjWithDate1:yDate zheci:date1];
    }
//    else
//    {
        [UIView animateWithDuration:0.5 animations:^{
            xiacichanjianView.frame=CGRectMake(20, Screen_Height, Screen_Width-40, 150);
            dataBgView.frame = CGRectMake(0, Screen_Height, self.view.frame.size.width, 260);
            
        }];
//    }
}
- (int)HuaiYuanTianShuMenth:(NSDate *)date1 yuchanqi:(NSDate *)date
{
    NSTimeInterval tianshu = [date1 timeIntervalSinceDate:date];
    int day = tianshu/3600/24;
    return day;
}
-(void)cjWithDate1:(NSDate *)date zheci:(NSDate *)date1{
    
    
    [tixingbutton setTitle:@"取消提醒" forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chanjiantixing"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *days = [[NSArray alloc]initWithObjects:@"78",@"84",@"85",@"112",@"113",@"140",@"141",@"168",@"169",@"196",@"197",@"224",@"225",@"245",@"246",@"252",@"253",@"259",@"260",@"266",@"267",@"273",@"274",@"280",@"281",@"287",@"288",@"294",nil];
    NSArray *days1=[[NSArray alloc]initWithObjects:@"78",@"85",@"113",@"141",@"169",@"197",@"225",@"246",@"253",@"260",@"267",@"274",@"281",@"288", nil];

    //获得当前时间处于孕期多少天
    NSTimeInterval tianshu = [date1 timeIntervalSinceDate:date];
    int day = tianshu/3600/24;
    huaiyunday=day;
    int benchiString=0;
    NSLog(@"day  %d",day);

    if (day<78) {
        
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"您设置的下一次孕检时间在孕12周之前" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
       
        return;
    }
    
    for (int i = 0; i< days.count; i+=2) {
        int tempday2 = [[days objectAtIndex:i+1]intValue];
        
        if (day <= tempday2) {
            //算出本次和下次的产检时间
            benchiString=i;
            break;
        }
    }
    
    for (int j=benchiString/2+1; j<days1.count; j++) {
        if (j==benchiString/2+1) {
            [TuiSongTongZhi CteLocalNotification:[TuiSongTongZhi ChanJianTuiSongShiJianMenth:day-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:date]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",j,[_czArr objectAtIndex:j-1]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",j-1,[_czArr objectAtIndex:j-1]]];
            

        }

        if (benchiString/2==1||benchiString/2==2||benchiString/2==3||benchiString/2==4||benchiString/2==5) {
            if (j==6) {
                if (day-[[days1 objectAtIndex:benchiString/2] intValue]>20) {
                    [TuiSongTongZhi CteLocalNotification: [TuiSongTongZhi ChanJianTuiSongShiJianMenth:day-[[days1 objectAtIndex:benchiString/2] intValue]-7+[[days1 objectAtIndex:j] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:date]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",j+1,[_czArr objectAtIndex:j]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",j,[_czArr objectAtIndex:j]]];

                }
                else
                {
                    [TuiSongTongZhi CteLocalNotification: [TuiSongTongZhi ChanJianTuiSongShiJianMenth:day-[[days1 objectAtIndex:benchiString/2] intValue]+[[days1 objectAtIndex:j] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:date]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",j+1,[_czArr objectAtIndex:j]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",j,[_czArr objectAtIndex:j]]];
                }
            }
            else if(j==1||j==2||j==3||j==4||j==5)
            {
                [TuiSongTongZhi CteLocalNotification: [TuiSongTongZhi ChanJianTuiSongShiJianMenth:day-[[days1 objectAtIndex:benchiString/2] intValue]+[[days1 objectAtIndex:j] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:date]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",j+1,[_czArr objectAtIndex:j]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",j,[_czArr objectAtIndex:j]]];
            }
            else
            {
                [TuiSongTongZhi CteLocalNotification: [TuiSongTongZhi ChanJianTuiSongShiJianMenth:(day-[[days1 objectAtIndex:benchiString/2] intValue])%7+[[days1 objectAtIndex:j] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:date]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",j+1,[_czArr objectAtIndex:j]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",j,[_czArr objectAtIndex:j]]];
            }

        }
        else
        {
            [TuiSongTongZhi CteLocalNotification:  [TuiSongTongZhi ChanJianTuiSongShiJianMenth:(day-[[days1 objectAtIndex:benchiString/2] intValue])%7+[[days1 objectAtIndex:j] intValue]-[self HuaiYuanTianShuMenth:[NSDate date] yuchanqi:date]] TuisongContent:[NSString stringWithFormat:@"亲爱的准妈，该去做【第%d次产检：%@】",j+1,[_czArr objectAtIndex:j]] TuisongName:[NSString stringWithFormat:@"%d==-=-=%@",j,[_czArr objectAtIndex:j]]];
        }

      
    }
    [days release];
    
}
-(NSArray *)cjWithDate:(NSDate *)date{
    
    NSDate *da;
    NSDate *da2 ;
    
    NSDate *nextDa;
    NSDate *nextDa2;
    
    //初始化天数数组，即每个节点的天数
    
    NSArray *days = [[NSArray alloc]initWithObjects:@"78",@"84",@"85",@"112",@"113",@"140",@"141",@"168",@"169",@"196",@"197",@"224",@"225",@"245",@"246",@"252",@"253",@"259",@"260",@"266",@"267",@"273",@"274",@"280",@"281",@"287",@"288",@"294",nil];
    
    //获得当前时间处于孕期多少天
    NSTimeInterval tianshu = [[NSDate date] timeIntervalSinceDate:date];
    NSString * benchiString=@"0";
    int day = tianshu/3600/24;
    NSLog(@"%d",day);
    if (day>293) {
        day=293;
    }
    for (int i = 0; i< days.count; i+=2) {
        int tempday1 = [[days objectAtIndex:i]intValue];
        int tempday2 = [[days objectAtIndex:i+1]intValue];
        int tempday3;
        int tempday4;
        if (days.count - i >=3) {
            tempday3 = [[days objectAtIndex:i+2]intValue];
            tempday4 = [[days objectAtIndex:i+3]intValue];
        }else{
            tempday3 = [[days objectAtIndex:i]intValue];
            tempday4 = [[days objectAtIndex:i+1]intValue];
        }
        
        if (day < tempday2) {
            //算出本次和下次的产检时间
            NSLog(@"本次和下次的产   %d",i);
            benchiString=[NSString stringWithFormat:@"%d",i];
            da = [NSDate dateWithTimeInterval:(tempday1-1)*24*3600 sinceDate: date];
            da2 = [NSDate dateWithTimeInterval:(tempday2-1)*24*3600 sinceDate: date];
            nextDa = [NSDate dateWithTimeInterval:(tempday3-1)*24*3600 sinceDate: date];
            nextDa2 = [NSDate dateWithTimeInterval:(tempday4-1)*24*3600 sinceDate: date];
            break;
        }
    }
    
    [days release];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString * daStr = [dateFormatter stringFromDate:da];
    NSString * daStr2 = [dateFormatter stringFromDate:da2];
    NSString * nextDaStr = [dateFormatter stringFromDate:nextDa];
    NSString * nextDaStr2 = [dateFormatter stringFromDate:nextDa2];
    
    NSArray *arr = [NSArray arrayWithObjects:daStr,daStr2,nextDaStr,nextDaStr2,benchiString, nil];
    return arr;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _smArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self HeightOfText:_smArr[indexPath.row]];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chanjianCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"chanjianCell"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    
    [cell.contentView removeAllSubviewss];
    
    int height = [self HeightOfText:_smArr[indexPath.row]];
    
    int iLeft = self.view.frame.size.width*120/320;
    
    UILabel * hL = [[UILabel alloc]initWithFrame:CGRectMake(iLeft, 0, 1, height)];
    hL.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    hL.alpha = 0.5f;
    [cell.contentView addSubview:hL];
    [hL release ];
    
    
    UILabel *wL = [[UILabel alloc]initWithFrame:CGRectMake(0, height-1, self.view.frame.size.width, 1)];
    wL.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    wL.alpha = 0.5f;
    [cell.contentView addSubview:wL];
    [wL release ];
    
    
    UILabel *smLab = [[UILabel alloc]initWithFrame:CGRectMake(iLeft+2, 2, self.view.frame.size.width-iLeft-4, height-5)];
    smLab.backgroundColor = [UIColor clearColor];
//    smLab.textAlignment = 1;
    smLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    smLab.font = [UIFont systemFontOfSize:miFontSize];
    smLab.tag = 1000;
    smLab.numberOfLines = 0;
    smLab.text = _smArr [indexPath.row];
    [cell.contentView addSubview:smLab];
    [smLab release];
    
    UILabel *yzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,iLeft-1, height-1)];
    yzLab.backgroundColor = [UIColor clearColor];
    yzLab.textAlignment = 1;
    yzLab.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];;
    yzLab.font = [UIFont systemFontOfSize:miFontSize];
    yzLab.text = _yzArr[indexPath.row];
    [cell.contentView addSubview:yzLab];
    [yzLab release];
    
    
    
    return cell;
}

-(void)clicked_dataBut{
    
    panduanBool=NO;
    NSDate *newdate1 = [NSDate dateWithTimeInterval:3600*24 sinceDate: [NSDate date]];
    dataPicker.minimumDate = newdate1;
    dataPicker.maximumDate=nil;
    [dataPicker reloadInputViews];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    dataBgView.frame = CGRectMake(0, Screen_Height-260, self.view.frame.size.width, 260);
    [UIView commitAnimations];
}

-(void)clicked_dBut{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    dataBgView.frame = CGRectMake(0, Screen_Height, self.view.frame.size.width, 260);
    [UIView commitAnimations];
    if (panduanBool) {
        [UIView animateWithDuration:0.5 animations:^{
        xiacichanjianView.frame=CGRectMake(20, Screen_Height, 280, 150);
            
        }];
    }
    
}
- (void)dateChanged:(UIDatePicker *)datePicker {
    
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @" yyyy-MM-dd";
	NSString * str = [dateFormatter stringFromDate:datePicker.date];
	NSLog(@"data === %@", str);
    if (panduanBool) {
        xiacichanjianLabel.text=str;
    }
    else
    {
    dataLab.text = str;
    }
	
	[dateFormatter release];
}

- (int)HeightOfText:(NSString *)content {
    if (!content) {
        return 60;
    }
    int iLeft = self.view.frame.size.width*120/320;
    CGSize size = CGSizeMake(self.view.frame.size.width-iLeft-4, 1000);
    CGSize calcSize = [content sizeWithFont:[UIFont systemFontOfSize:miFontSize] constrainedToSize:size lineBreakMode:0];
    int iHeight = calcSize.height+10;
    
    return iHeight;
}

-(void)clicked_backBut{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
