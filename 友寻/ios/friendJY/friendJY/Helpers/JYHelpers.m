//
//  JYHelpers.m
//  friendJY
//
//  Created by 高斌 on 15/2/28.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYHelpers.h"
#import <AddressBook/AddressBook.h>
#import <SDWebImage/SDImageCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation JYHelpers

//设置颜色
+ (UIColor *)setFontColorWithString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 字符串个数必须大于等于6
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 根据16进制来区分
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 分为r,g,b 子字符串
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // 扫描r,g,b值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return RgbHex2UIColor(r, g, b);
}

+ (BOOL)isPhoneNumber:(NSString *)phoneNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|7[0-9]|8[025-9])\\d{8}$"; //新增14 17号段
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,181
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[561])\\d{8}$";
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
    
    if (([regextestmobile evaluateWithObject:phoneNumber] == YES)
        || ([regextestcm evaluateWithObject:phoneNumber] == YES)
        || ([regextestct evaluateWithObject:phoneNumber] == YES)
        || ([regextestcu evaluateWithObject:phoneNumber] == YES))
    {
        return YES;
    } else {
        return NO;
    }
}



//读取手机联系人
+ (NSArray *)readAllPeoples
{
  
    NSMutableArray *contactsList = [[NSMutableArray alloc] init];
    
    //取得本地通信录名柄
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool greanted, CFErrorRef error) {
        
        dispatch_semaphore_signal(sema);
        
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //        dispatch_release(sema);
    
    
    //取得本地所有联系人记录
    if (addressBooks == nil) {
        return contactsList;
    };
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            
            nameString = (__bridge NSString *)abFullName;
        } else {
            
            if ((__bridge id)abLastName != nil)
            {
//                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                nameString = [NSString stringWithFormat:@"%@%@", lastNameString, nameString];

            }
        }
        
//        NSString *recordID = [NSString stringWithFormat:@"%d", (int)ABRecordGetRecordID(person)];
        
        //        [contactDict setObject:nameString forKey:@"recordID"];
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        if ([JYHelpers isEmptyOfString:nameString]) {
                            break;
                        }
                        //新建一个联系人Dict
                        NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
                        [contactDict setObject:nameString forKey:@"name"];
                        NSString *mobile = [(__bridge NSString *)value stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        NSLog(@"name %@ : %@",nameString,mobile);
                        
                        if ([JYHelpers isEmptyOfString:mobile]) {
                            break;
                        }
                        [contactDict setObject:mobile forKey:@"mobile"];
                        [contactsList addObject:contactDict];
                        break;
                    }
                    default:{
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        //        [addressBookTemp addObject:contactDict];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    //NSLog(@"%@", contactsList);
    return contactsList;
//    [self writeFileWith:_contactsList];
    
    //释放内存&nbsp;
    //    [tmpPeoples release];
    //    CFRelease(tmpAddressBook);
    
}

+ (void)showAlertWithTitle:(NSString *)title
{
    [JYHelpers showAlertWithTitle:title
                              msg:nil
                      buttonTitle:NSLocalizedString(@"OK", @"ok")];
}

+ (void)showAlertWithTitle:(NSString *)title
                       msg:(NSString *)msg
               buttonTitle:(NSString *)btnTitle
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:btnTitle
                                       otherButtonTitles:nil];
    [av show];
}

+ (BOOL)isEmptyOfString:(NSString *)string
{
    if(string == nil || string == NULL || [string isKindOfClass:[NSNull class]]){
        
        return YES;
    }else if ([string isKindOfClass:[NSString class]]) {
        
        if (string.length ==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
            return YES;
        }
    
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:string];
    NSRange range = [mutStr rangeOfString:@" "];
    while (range.location != NSNotFound) {
        [mutStr deleteCharactersInRange:range];
        range = [mutStr rangeOfString:@" "];
    }
    
    if (mutStr.length == 0) {
        return YES;
    }

    return NO;
}

+ (CGSize) getTextWidthAndHeight:(NSString *)str fontSize:(int) fontSize{
    // 测试字串
    NSString *text = str;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //设置一个行高上限
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    labelsize.height = labelsize.height+5;
    labelsize.width = labelsize.width+5;
    return labelsize;
}

+ (CGSize)GetTextSize:(NSString *)str UI:(UITextView *)textView uiWidth:(float) uiWidth{
    CGSize maximumSize =CGSizeMake(uiWidth,MAXFLOAT);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [str boundingRectWithSize:maximumSize options:options attributes:@{NSFontAttributeName : textView.font} context:nil];
    return rect.size;
}

+ (CGSize) getTextWidthAndHeight:(NSString *)str fontSize:(int) fontSize uiWidth:(int) uiWidth{
    // 测试字串
    NSString *text = str;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //设置一个行高上限
    CGSize size = CGSizeMake(uiWidth,MAXFLOAT);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
     labelsize.height = labelsize.height+3;
    return labelsize;
}
                            

    /**
 * 计算星座
 *
 * @Title: star
 * @return String 返回类型
 * @param @param month
 * @param @param day
 * @param @return 参数类型
 * @author likai
 * @throws
 */
+ (NSString *) computeStar:(NSInteger) month day :(NSInteger) day {
    NSString * strValue;
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
        strValue = @"水瓶座";
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
        strValue = @"双鱼座";
    } else if ((month == 3 && day > 20) || (month == 4 && day <= 19)) {
        strValue = @"白羊座";
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
        strValue = @"金牛座";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 21)) {
        strValue = @"双子座";
    } else if ((month == 6 && day > 21) || (month == 7 && day <= 22)) {
        strValue = @"巨蟹座";
    } else if ((month == 7 && day > 22) || (month == 8 && day <= 22)) {
        strValue = @"狮子座";
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
        strValue = @"处女座";
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 23)) {
        strValue = @"天秤座";
    } else if ((month == 10 && day > 23) || (month == 11 && day <= 22)) {
        strValue = @"天蝎座";
    } else if ((month == 11 && day > 22) || (month == 12 && day <= 21)) {
        strValue = @"射手座";
    } else if ((month == 12 && day > 21) || (month == 1 && day <= 19)) {
        strValue = @"魔羯座";
    }
    
    return strValue;
}

/**
 * 计算生肖
 *
 * @Title: sxiao
 * @return String 返回类型
 * @param @param year
 * @param @return 参数类型
 * @author likai
 * @throws
 */
+ (NSString *) computeBirthpet:(NSInteger) year {
    NSArray * sSX = [[NSArray alloc] initWithObjects: @"猪", @"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗",nil ];
    int end = 3;
    int x = (year - end) % 12;
    
    NSString * retValue =  sSX[x];
    
    return retValue;
}

+ (long)stringDateToIntTimestamp:(NSString *)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* datenow = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    return  (long)[datenow timeIntervalSince1970];
}

//时间戳转时间的方法
+ (NSString *)unixToDate:(NSInteger)myUnix{
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
   
        
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:myUnix];
    
    NSTimeInterval timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSString *formatString;
    if (timeInterval / 60 /60 > 24) {
        formatString = @"MM-dd";
    }else{
        formatString = @"HH:mm";
    }
   
    
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = formatString;
    NSString* dateString = [fmt stringFromDate:confromTimesp];
    //    NSLog(@"dateString ： %@", dateString);
    
    return dateString;
}

+ (NSString *) unxiToDate2:(NSInteger)unix{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:unix];
    
    NSTimeInterval timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSString *formatString;
    if (timeInterval / 60 /60 > 24) {
        formatString = @"MM-dd HH:mm";
    }else{
        formatString = @"HH:mm";
    }
    
    
    //    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = formatString;
    NSString* dateString = [fmt stringFromDate:confromTimesp];
    //    NSLog(@"dateString ： %@", dateString);
    
    return dateString;
}


#pragma mark - 获取当前时间的时间戳
+ (NSString *)currentDateTimeInterval
{
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
}

+ (NSString *)stringValueWithObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        id value;
        if ([object isKindOfClass:[NSNull class]]) {
            value = @"";
        }else{
            value = [object stringValue];
        }
        return value;
    }
}

// 计算指定时间与当前的时间差
/*（1）	发布时间为1小时以内，显示X分钟前；
   (2）	1h≤发布时间≤24h，显示XX小时前
  （3）	1day≤发布时间≤4day，显示X天前
  （4）	发布时间4天以上，显示格式：月-日 时：分，按24小时制显示
 */
+ (NSString *)compareCurrentTime:(NSDate *)compareDate
{
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <4){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    } else {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *confromTimespStr = [formatter stringFromDate:compareDate];
        
        result = [NSString stringWithFormat:@"%@", confromTimespStr];
        
        //        result = [NSString stringWithFormat:@"%@",compareDate];
    }
    
    //    else if((temp = temp/30) <12){
    //        result = [NSString stringWithFormat:@"%ld月前",temp];
    //    }
    //    else{
    //        temp = temp/12;
    //        result = [NSString stringWithFormat:@"%ld年前",temp];
    //    }
    
    return  result;
}

//等比计算高宽
+ (NSArray *)ratioWidthAndHeight:(float)sHeight
                          sWidth:(float)sWidth
                         dHeight:(float)dHeight
                          dWidth:(float)dWidth
{
    float mHieght = dHeight;
    float mWidth = dWidth;
    if (sHeight>sWidth) {
        mWidth = sWidth * (dHeight/sHeight);
    }else{
        mHieght = sHeight * (dWidth/sWidth);
    }
    return @[[NSNumber numberWithInteger:mHieght],[NSNumber numberWithInteger:mWidth]];
}

#pragma mark - 获取目录，目录不存时会被创建
+ (NSString *)getCurrentUserStoreageSubDirectory:(NSString*)dir
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];
    NSString* cacheSubDir = [cachesPath stringByAppendingPathComponent:dir];
    [JYHelpers createPathIfNecessary:cacheSubDir];
    return cacheSubDir;
}

+ (BOOL)createPathIfNecessary:(NSString*)path
{
    BOOL succeeded = YES;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    return succeeded;
}

#pragma mark - 从沙盒中读取文件
+ (NSData *)fromLocationPahtGetFileContent:(NSString *)path
{
    //创建文件管理器
    /*NSFileManager可以用来查询单词库目录，创建，重命名，删除目录以及获取／设置文件属性的方法*/
    NSFileManager * fm;
    fm = [NSFileManager defaultManager];
    //创建缓冲区，利用NSFileManager对象来获取文件中的内容，也就是这个文件的属性可修改
    NSData * fileData;
    if ([fm fileExistsAtPath:path]){
        fileData = [fm contentsAtPath:path];
    } else {
        fileData = nil;
    }
    return fileData;
}
#pragma mark --沙盒缓存读取
//单个文件缓存大小
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
//缓存目录大小
+(float)folderSizeAtCaches{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    path = [path stringByAppendingPathComponent:@"Caches"];

    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
//清除缓存
+(void)clearCache{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    path = [path stringByAppendingPathComponent:@"Caches"];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
//    [[SDImageCache sharedImageCache] cleanDisk];
}

+ (UIImage *)imageWithName:(NSString *)imageName{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

+ (NSString *)dictionaryToJSONString:(NSDictionary *)dic{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    return [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&err];
    return responseObject;
}

+ (NSInteger)integerValueOfAString:(NSString *)aStr{
    NSInteger aInt = 0;
    if ([aStr isKindOfClass:[NSNumber class]]) {
        aInt = [aStr integerValue];
    }else if (![JYHelpers isEmptyOfString:aStr]) {
        aInt = [aStr integerValue];
    }
    return aInt;
}

#pragma mark - 获取相机当前使用权限
+ (BOOL)canUseCamera{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        
        return NO;
        
    }else{
    
        return YES;
    }
    
}
+ (void)showCameraAuthDeniedAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相机访问受限" message:@"请在iPhone的“设置-隐私-相机”选项中，允许友寻访问。" delegate:[JYAppDelegate sharedAppDelegate] cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

+ (BOOL)canUsePhotoLibrary{
    
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        
        NSLog(@"相册权限受限");
        
        return NO;
        
    }else{
        
        return YES;
    }
}
+ (void)showPhotoLibraryDeniedAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相册访问受限" message:@"请在iPhone的“设置-隐私-照片”选项中，允许友寻访问。" delegate:[JYAppDelegate sharedAppDelegate] cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

+ (NSString *)birthdayTransformToCentery:(NSString *)birthday{

//    NSString * birthdayFomatter = @"^(19|20)[0-9][0-9]//d{6}$";
//    NSPredicate *regextestBirthday = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", birthdayFomatter];
//    BOOL isBirthday = [regextestBirthday evaluateWithObject:birthday];
//    
//    NSAssert(isBirthday, @"不是正确的生日格式");
    NSString *decades = [birthday substringToIndex:4];
    
    decades = [decades substringFromIndex:2];
    NSLog(@"---->%@",decades);
    
    NSInteger intDecades = [decades integerValue];
    
    NSInteger count = intDecades / 5;
    if (count < 2) {
        return [NSString stringWithFormat:@"0%ld后",(long)count*5];
    }else
        return [NSString stringWithFormat:@"%ld后",(long)count*5];

}

+ (NSString *)filterEmojiString:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return  modifiedString;
}

//tag排序
+ (NSMutableArray*)sortTagArr:(NSArray*)tagArr{
    
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:tagArr];
    
    [resultArr sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        NSInteger bindObj1 = [JYHelpers integerValueOfAString:[obj1 objectForKey:@"bind"]];
        NSInteger operObj1 = [JYHelpers integerValueOfAString:[obj1 objectForKey:@"oper"]];
        NSInteger ctimeObj1 = [JYHelpers integerValueOfAString:[obj1 objectForKey:@"ctime"]];
        
        NSInteger bindObj2 = [JYHelpers integerValueOfAString:[obj2 objectForKey:@"bind"]];
        NSInteger operObj2 = [JYHelpers integerValueOfAString:[obj2 objectForKey:@"oper"]];
        NSInteger ctimeObj2 = [JYHelpers integerValueOfAString:[obj2 objectForKey:@"ctime"]];
        
        //总体排序方式 为点赞的排在前面 点赞过的 根据点赞数量排序 多的在前， 点赞数量相同则比较创建时间 晚的在前
        if (operObj1 == 1) {//obj1已经点赞
            if (operObj2 == 1) {//obj2也点赞
                if (bindObj1 > bindObj2) {//比较 bind
                    return NO;//前者bind大  不交换
                }else if(bindObj1 == bindObj2){
                    if (ctimeObj1 < ctimeObj2) {//比较ctime
                        return NO;//前者time 晚（小）不交换
                    }else{
                        return YES;
                    }
                }else{
                    return YES;
                }
                
            }else{
                return NO;
            }
        }else{//obj1没有点赞
            if (operObj2 == 1) {
                return YES;
            }else{
                if (bindObj1 > bindObj2) {
                    return NO;
                }else if(bindObj1 == bindObj2){
                    if (ctimeObj1 > ctimeObj2) {
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    return YES;
                }
            }
        }
        //        return 1;
    }];
    return resultArr;
}

@end
