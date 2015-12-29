//
//  ChineseString.m
//  YZX_ChineseSorting
//
//  Created by Suilongkeji on 13-10-29.
//  Copyright (c) 2013年 Suilongkeji. All rights reserved.
//

#import "ChineseString.h"
#import "JYPhoneContactsModel.h"
#import "JYShareData.h"

@implementation ChineseString
@synthesize string;
@synthesize pinYin;

#pragma mark - 返回tableview右方 indexArray
+ (NSMutableArray*)indexArray:(NSArray *)stringArr
{
    NSMutableArray *tempArray = [self returnSortChineseArrar:stringArr];
    NSMutableArray *A_Result=[NSMutableArray array];
    NSString *tempString ;
    
    for (NSString* object in tempArray)
    {
        if (((ChineseString*)object).pinYin.length < 1) {
            continue;
        }
        NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
           // NSLog(@"IndexArray----->%@",pinyin);
            [A_Result addObject:pinyin];
            tempString = pinyin;
        }
    }
        return A_Result;
}

#pragma mark - 返回联系人
+ (NSMutableArray*)letterSortArray:(NSArray *)stringArr
{
    NSMutableArray *tempArray = [self returnSortChineseArrar:stringArr];
    NSMutableArray *letterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {

         NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
         NSString *string = ((ChineseString*)object).string;
        //不同
        if(![tempString isEqualToString:pinyin]) {
            //分组
            item = [NSMutableArray array];
//            [item addObject:string];
            
            JYPhoneContactsModel *phoneContactsModel = [[JYPhoneContactsModel alloc] init];
            [phoneContactsModel setName:string];
            for (NSDictionary *contactDict in [JYShareData sharedInstance].contactsList)
            {
                NSString *name = [ChineseString RemoveSpecialCharacter:[contactDict objectForKey:@"name"]];
                
                if ([name isEqualToString:string]) {
                    [phoneContactsModel setMobile:[contactDict objectForKey:@"mobile"]];
                }
            }
            
            [item addObject:phoneContactsModel];
            
            [letterResult addObject:item];
            //遍历
            tempString = pinyin;
        } else {
            
            //相同
            JYPhoneContactsModel *phoneContactsModel = [[JYPhoneContactsModel alloc] init];
            [phoneContactsModel setName:string];
            for (NSDictionary *contactDict in [JYShareData sharedInstance].contactsList)
            {
                NSString *name = [ChineseString RemoveSpecialCharacter:[contactDict objectForKey:@"name"]];
                
                if ([name isEqualToString:string]) {
                    [phoneContactsModel setMobile:[contactDict objectForKey:@"mobile"]];
                }
            }
            
            [item addObject:phoneContactsModel];
            
//            [item  addObject:string];
        }
    }
    return letterResult;

}

+ (NSMutableArray*)letterSortContactArray:(NSArray *)stringArr
{//stringArr 里面存的是 字典  key name and mobile
//    NSMutableArray *handledStringArr = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
    for (NSDictionary *dic in stringArr) {
        [nameArr addObject:[dic objectForKey:@"truename"]];
    }
    NSMutableArray *tempArray = [self returnSortChineseArrar:nameArr];
    NSMutableArray *letterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {
        
        NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
        NSString *string = ((ChineseString*)object).string;
        //不同
        if(![tempString isEqualToString:pinyin]) {
            //分组
            item = [NSMutableArray array];
            //            [item addObject:string];
            
            JYPhoneContactsModel *phoneContactsModel = [[JYPhoneContactsModel alloc] init];
            [phoneContactsModel setName:string];
            
            for (NSDictionary *contactDict in stringArr)
            {
                NSString *name = [ChineseString RemoveSpecialCharacter:[contactDict objectForKey:@"truename"]];
                
                if ([name isEqualToString:string]) {
                    [phoneContactsModel setMobile:[contactDict objectForKey:@"mobile"]];
                }
            }
            
            [item addObject:phoneContactsModel];
            
            [letterResult addObject:item];
            //遍历
            tempString = pinyin;
        } else {
            
            //相同
            JYPhoneContactsModel *phoneContactsModel = [[JYPhoneContactsModel alloc] init];
            [phoneContactsModel setName:string];
            for (NSDictionary *contactDict in stringArr)
            {
                NSString *name = [ChineseString RemoveSpecialCharacter:[contactDict objectForKey:@"truename"]];
                
                if ([name isEqualToString:string]) {
                    [phoneContactsModel setMobile:[contactDict objectForKey:@"mobile"]];
                }
            }
            
            [item addObject:phoneContactsModel];
            
            //            [item  addObject:string];
        }
    }
    return letterResult;
    
}



//过滤指定字符串   里面的指定字符根据自己的需要添加
+(NSString*)RemoveSpecialCharacter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+ (NSMutableArray*)returnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++)
    {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[stringArr objectAtIndex:i]];
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        //去除两端空格和回车
//        chineseString.string  = [chineseString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        //此方法存在一些问题 有些字符过滤不了
        //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        //chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:set];
        
        
        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        chineseString.string =[ChineseString RemoveSpecialCharacter:chineseString.string];
       // NSLog(@"string====%@",chineseString.string);
        
        
        //判断首字符是否为字母
//        NSString *regex = @"[a-zA-Z]+";
////        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
//
//        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//        
//        
//        if ([predicate evaluateWithObject:chineseString.string])
        if([self firstCharacterIsALetter:chineseString.string])
        {
            //首字母大写
            chineseString.pinYin = [chineseString.string capitalizedString] ;
        }else{
            if(![chineseString.string isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<chineseString.string.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c", pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin=pinYinResult;
            }else{
                chineseString.pinYin=@"";
            }
        }
//        NSLog(@"%@",chineseString.pinYin);
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];

    return chineseStringsArray;
}

//
//for(int i=0;i<[chineseStringsArray count];i++){
//    // NSLog(@"chineseStringsArray====%@",((ChineseString*)[chineseStringsArray objectAtIndex:i]).pinYin);
//}
//// NSLog(@"-----------------------------");
#pragma mark - 返回一组字母排序数组
+ (NSMutableArray*)sortArray:(NSArray *)stringArr
{
    NSMutableArray *tempArray = [self returnSortChineseArrar:stringArr];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[stringArr count];i++){
        [result addObject:((ChineseString*)[tempArray objectAtIndex:i]).string];
        NSLog(@"SortArray----->%@",((ChineseString*)[tempArray objectAtIndex:i]).string);
    }
    return result;
}

+ (NSMutableArray *)creatGroup_letterSortArray:(NSArray *)stringArr
{
    NSMutableArray *tempArray = [self returnSortChineseArrar:stringArr];
    NSMutableArray *letterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (NSString* object in tempArray) {
        
        NSString *pinyin = [((ChineseString*)object).pinYin substringToIndex:1];
        NSString *string = ((ChineseString*)object).string;
        //不同
        if(![tempString isEqualToString:pinyin]) {
            //分组
            item = [NSMutableArray array];
            //            [item addObject:string];
            
            JYPhoneContactsModel *phoneContactsModel = [[JYPhoneContactsModel alloc] init];
            [phoneContactsModel setName:string];
            for (NSDictionary *contactDict in [JYShareData sharedInstance].contactsList)
            {
                NSString *name = [ChineseString RemoveSpecialCharacter:[contactDict objectForKey:@"name"]];
                
                if ([name isEqualToString:string]) {
                    [phoneContactsModel setMobile:[contactDict objectForKey:@"mobile"]];
                }
            }
            
            [item addObject:phoneContactsModel];
            
            [letterResult addObject:item];
            //遍历
            tempString = pinyin;
        } else {
            
            //相同
            JYPhoneContactsModel *phoneContactsModel = [[JYPhoneContactsModel alloc] init];
            [phoneContactsModel setName:string];
            for (NSDictionary *contactDict in [JYShareData sharedInstance].contactsList)
            {
                NSString *name = [ChineseString RemoveSpecialCharacter:[contactDict objectForKey:@"name"]];
                
                if ([name isEqualToString:string]) {
                    [phoneContactsModel setMobile:[contactDict objectForKey:@"mobile"]];
                }
            }
            
            [item addObject:phoneContactsModel];
            
            //            [item  addObject:string];
        }
    }
    return letterResult;
}

+ (BOOL)firstCharacterIsALetter:(NSString*)nameStr{
    
    NSString *firstCharacater = [nameStr substringToIndex:1];

    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    if ([arr containsObject:firstCharacater]) {
        return YES;
    }else{
        return NO;
    }
}

@end