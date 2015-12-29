//
//  DxyCustom.m
//  AirportMerchant
//
//  Created by dxy on 14-7-29.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "DxyCustom.h"

@implementation DxyCustom

//解析html格式的字符串
+ (NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


+ (UITextField *)createTextFieldWithFrame:(CGRect)frame secure:(BOOL)isSecure place:(NSString *)string tag:(NSInteger)tag delegate:(id<UITextFieldDelegate>)delegate{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (isSecure) {
        textField.secureTextEntry = YES;
    }
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = string;
    textField.tag = tag;
    textField.delegate = delegate;
    
    return textField;
}

//创建一个警告框AlertView
+ (UIAlertView *)showAlertViewTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //显示警告框
    [alertView show];
    return alertView;
}

//创建一个只有一个确认按钮的alertView
+ (UIAlertView *)showSureAlertViewTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //显示警告框
    [alertView show];
    return alertView;
}

//动态调节高度
+ (CGSize)boundingRectWithString:(NSString *)textStr width:(CGFloat)width height:(CGFloat)height font:(NSInteger)font{
    CGSize size;
    if (kVersion < 7) {
        size = [textStr sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, height) lineBreakMode:NSLineBreakByCharWrapping];
    }else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil];
        size = [textStr boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    }
    
    return size;
}

//创建label
+ (UILabel *)creatLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       alignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

+ (UILabel *)createDiffFontLabelWithFrame:(CGRect)frame text:(NSString *)text alignment:(NSTextAlignment)textAlignment{
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:[[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]];
    label.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

//创建图片类型的button
+ (UIButton *)creatButtonFrame:(CGRect)frame
                     imageName:(NSString *)imageName
               selectImageNmae:(NSString *)selectImageName
                        target:(id)target
                        action:(SEL)sel
                           tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (imageName.length > 1) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selectImageName.length > 1) {
        [button setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    return button;
}

//创建一个ImageView
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}


+(NSString *) getStateWithInt:(NSString *)state{
    
    switch ([state intValue]) {
        case 0:
        {
            return @"未处理";
        }
            break;
        case 1:
        {
            return @"处理中";
            
        }
            break;
        case 2:
        {
            return @"已关闭";
            
        }
            break;
        case 3:
        {
            return @"已拒绝";
            
        }
            break;
        case 5:
        {
            return @"待评价";
            
        }
            break;
        case 4:
        {
            return @"已关闭";
        
        }
            
        default:
            break;
    }
    return nil;
    
}



+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



+(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger *)value1 Value2:(NSInteger )value2;

{
    
    return [str substringWithRange:NSMakeRange(value1,value2)];
    
}



/**
 
 * 功能:判断是否在地区码内
 
 * 参数:地区码
 
 */

+(BOOL)areaCode:(NSString *)code

{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init] ;
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}

/**
 
 * 功能:验证身份证是否合法
 
 * 参数:输入的身份证号
 
 */

+(BOOL) chk18PaperId:(NSString *) sPaperId

{
    
    //判断位数
    
    
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    
    //加权因子
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            
        {
            
            p += (pid[i]-48) * R[i];
            
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
        
    }
    
    //判断地区码
    
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        
        return NO;
        
    }
    
    //判断年月日是否有效
    
    
    
    //年份
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //月份
    
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    
    if( 18 != strlen(PaperId)) return -1;
    
    
    
    //校验数字
    
    for (int i=0; i<18; i++)
        
    {
        
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            
        {
            
            return NO;
            
        }
        
    }
    
    //验证最末的校验码
    
    for (int i=0; i<=16; i++)
        
    {
        
        lSumQT += (PaperId[i]-48) * R[i];
        
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
        
    {
        
        return NO;
        
    }
    
    return YES;
    
}


//检测文件是否存在
//判断该路径下文件是否存在
+ (BOOL)fileIsExistsWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:path];
    NSLog(@"FileManager判断文件是否存在:%i",isExist);
    return isExist;
}

+ (BOOL)networkclick{
    Reachability*reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL isON = YES;
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            
            break;
        case ReachableViaWWAN:
            NSLog(@"3g网络");
            break;
        case NotReachable:
            
            isON = NO;
            break;
        default:
            break;
    }
    
    return isON;
}

+ (BOOL)isWifi{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    //结果说明：0-无连接   1-wifi    2-3G
    NSInteger stateNet = [reachability currentReachabilityStatus];

    if (stateNet == 2) {
        return YES;
    }else{
        return NO;
    }

}

+ (NSString *)getTimeWithTimeSp:(NSString *)timeSp{
    NSString *str=timeSp;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}


+ (NSString *)getYearMonthDay:(NSString *)timeSp{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setDateStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSInteger l = [timeSp integerValue];
//    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:l];
//    NSString *timeStr = [formatter stringFromDate:nowTime];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    return timeStr;


    NSString *str=timeSp;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;


}

+ (NSString *)isYestedayOrTodayWithTimeSp:(NSString *)timeSp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //[formatter setDateFormat:@"YYYY-MM-dd "];
    NSInteger l = [timeSp integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:l];
    
    
    
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = date;
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        NSTimeInterval late=[date timeIntervalSince1970]*1;
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now=[dat timeIntervalSince1970]*1;
        NSString *timeString=@"";
        
        NSTimeInterval cha=now-late;
        
        
        if (cha/3600<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }
        if (cha/86400>1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@天前", timeString];
            
        }
        
        return timeString;
       //return [NSString stringWithFormat:@"今天%@",[[formatter stringFromDate:date] substringFromIndex:11]];
    } else if ([refDateString isEqualToString:yesterdayString])
    {
        return [NSString stringWithFormat:@"昨天%@",[[formatter stringFromDate:date] substringFromIndex:11]];
    }
    else
    {
        NSString *str=timeSp;//时间戳
        NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        NSLog(@"date:%@",[detaildate description]);
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        return currentDateStr;
    }
}

@end
