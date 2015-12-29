//
//  JYShareData.m
//  friendJY
//
//  Created by 高斌 on 15/3/5.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYShareData.h"
#import "JYHelpers.h"
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"
#import "JYProfileModel.h"
#import <AddressBook/AddressBook.h>
#import "JYManageFriendData.h"
#import "ProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation JYShareData
@synthesize myself_profile_dict = _myself_profile_dict;
@synthesize myself_profile_model = _myself_profile_model;
#pragma mark - Singleton Methods

static JYShareData *_instance;
+ (JYShareData *)sharedInstance;
{
    @synchronized(self) {
        
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            // Allocate/initialize any member variables of the singleton class here
            // example
            //_instance.member = @"";
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [super allocWithZone:zone];
            return _instance;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)upListAndShowProgress:(BOOL)isShow
{
    ABAuthorizationStatus authrizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authrizationStatus != kABAuthorizationStatusAuthorized) {
        if (isShow) {
            [JYHelpers showAlertWithTitle:@"提醒" msg:@"通讯录权限未打开，请到\"设置\"->\"隐私\"->\"通讯录\"打开通讯录权限。" buttonTitle:@"确认"];
        }
//        [[JYAppDelegate sharedAppDelegate] showTip:@"通讯录权限未打开，请到\"设置\"->\"隐私\"->\"通讯录\"打开通讯录权限。"];
        return;
    }
    if (isShow) {
        [self showProgressHUD:@"加载中..."];
    }
    [self setContactsList:[JYHelpers readAllPeoples]];
    [self writeFileWith:self.contactsList];
    [self requestUpListAndProgressShow:isShow];
}


- (void)writeFileWith:(NSArray *)contactsList
{
//    NSString *jsonString = @"";
    if (contactsList) {
        //数组转字典再转JSON串
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in contactsList) {
            if ([dic isKindOfClass:[NSDictionary class]] && [dic objectForKey:@"name"]) {
                [resultDic setObject:[dic objectForKey:@"name"] forKey:[dic objectForKey:@"mobile"]];
            }
        }
        //字典转JSON串
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:&error];
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //获取路径
        //1、参数NSDocumentDirectory要获取的那种路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //2、得到相应的Documents的路径
        NSString* documentDirectory = [paths objectAtIndex:0];
        NSLog(@"%@", documentDirectory);
        //3、更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath:documentDirectory];
        //4、创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        NSString *contactsFileName = [NSString stringWithFormat:@"%@_contacts", uid];
        _filePath = [documentDirectory stringByAppendingPathComponent:contactsFileName];
        //5、创建数据缓冲区
        NSMutableData *writerData = [[NSMutableData alloc] init];
        //6、将字符串添加到缓冲中
        [writerData appendData:jsonData];
        //7、将其他数据添加到缓冲中
        //将缓冲的数据写入到文件中
        [writerData writeToFile:_filePath atomically:YES];
    }
    
}

#pragma mark - request

//上传通信录
- (void)requestUpListAndProgressShow:(BOOL)isShow
{
//    [[UIApplication sharedApplication] enabledRemoteNotificationTypes]
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"upload" forKey:@"mod"];
    [parametersDict setObject:@"up_mobile_list" forKey:@"func"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//    [dataDict setObject:@"4" forKey:@"type"];
//    NSMutableDictionary *formDict = [NSMutableDictionary dictionary];
    NSData *fileData = [NSData dataWithContentsOfFile:_filePath];
    if (fileData) {
        [dataDict setObject:fileData forKey:@"upload"];
    }
    
    [JYHttpServeice requestUpListWithParameters:parametersDict dataDict:dataDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        [self dismissProgressHUDtoView];
        if (iRetcode == 1) {
            if (isShow) {
                [[JYAppDelegate sharedAppDelegate] showTip:@"成功"];
            }
            //成功
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_IsUpList", uid]];
            //上传成功刷新好友数据
//            [[JYManageFriendData sharedInstance] loadMyFriendsAllWithNums:300 SuccessBlock:nil failureBlock:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterAndUpMobileListSuccessNotification object:nil userInfo:nil];
            
        } else {
            
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        }
        
    } failure:^(id error) {
        [self dismissProgressHUDtoView];
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
        
        
    }];
    
}
- (void)setMyself_profile_dict:(NSDictionary *)myself_profile_dict{
    
    _myself_profile_model = [[JYProfileModel alloc] initWithDataDic:myself_profile_dict];
    if (_myself_profile_dict) {
        _myself_profile_dict = nil;
    }
    _myself_profile_dict = [NSDictionary dictionaryWithDictionary:myself_profile_dict];
}
- (NSDictionary *)myself_profile_dict{
    if (_myself_profile_dict == nil) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:kMyProfileInfoPath]) {
            NSError *error = nil;
            NSData *jsonData = [NSData dataWithContentsOfFile:kMyProfileInfoPath];
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"用户资料本地读取失败");
            }else{
                [self setMyself_profile_dict:tempDict];
            }
        }
    }
    return _myself_profile_dict;
}

- (JYProfileModel *)myself_profile_model{
    if (_myself_profile_model == nil) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:kMyProfileInfoPath]) {
            NSError *error = nil;
            NSData *jsonData = [NSData dataWithContentsOfFile:kMyProfileInfoPath];
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"用户资料本地读取失败");
            }else{
                [self setMyself_profile_dict:tempDict];
            }
        }
    }
    return _myself_profile_model;
}

#pragma mark - ProgressHud
- (void)showProgressHUD:(NSString *)message
{


//    if (SYSTEM_VERSION >= 7.0f) {
//        [ProgressHUD show:message];
//    } else {
        [MBProgressHUD showMessag:message toView:[JYAppDelegate sharedAppDelegate].window];
//    }
}
- (void)bgClick{

}
- (void)dismissProgressHUDtoView
{
    UIView *bgView = [[JYAppDelegate sharedAppDelegate].window viewWithTag:9999];
    [bgView removeFromSuperview];
//    if (SYSTEM_VERSION >= 7.0f) {
//        [ProgressHUD dismiss];
//    } else {
        [MBProgressHUD hideHUDForView:[JYAppDelegate sharedAppDelegate].window animated:YES];
//    }
}

- (void )getLocalImageInfoWithFinishBlcok:(void (^)())finishBlock{
    
    if (_localImageArr.count > 0) {
        if (finishBlock) {
            finishBlock();
        }
        return;
    }
    
    _localImageArr = [NSMutableArray array];
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
        NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound)
        {
            //无法访问相册.请在'设置->定位服务'设置为打开状态.
            [JYHelpers showAlertWithTitle:@"无法访问相册.请在'设置->定位服务'设置为打开状态"];
        } else {
            NSLog(@"相册访问失败.");
            [JYHelpers showAlertWithTitle:@"相册访问失败"];
        }
    };
    
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result != NULL)
        {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                NSString *urlstr = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                [_localImageArr addObject:urlstr];
            }
        }
        if (stop) {
            
        }
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock
    libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop) {
        //ALAssetsGroup - Name:相机胶卷, Type:Saved Photos, Assets count:194
        if (group == nil)
        {
          NSLog(@"group == nil")
            if (finishBlock) {
                finishBlock();
            }
        }
        
        if (group != nil) {
            NSString *g = [NSString stringWithFormat:@"%@",group];//获取相簿的组
            NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
            NSRange range = [g rangeOfString:@"Type:"];
            NSString *type = [g substringWithRange:NSMakeRange(range.location+range.length, 12)];
            if ([type isEqualToString:@"Saved Photos"]) {
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        }
    };
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:libraryGroupsEnumeration
                         failureBlock:failureblock];
    
    
}
- (void)loadRecommendTagsWithMaleOrNot:(BOOL)isMale successBlock:(void (^)())successBlock{
    
    if (isMale && _maleRecommendTagArr.count > 0) {
        if (successBlock) {
            successBlock();
            return;
        }
    }else if (!isMale && _feMaleRecommendTagArr.count > 0){
        if (successBlock) {
            successBlock();
            return;
        }
    }
    
    NSString *sexStr = isMale ? @"1" : @"0";
    
    NSDictionary *paraDic = @{@"mod":@"tags",
                              @"func":@"alternative_tag_list"
                              };
    NSDictionary *postDic = @{
                              @"sex":sexStr
                              };
    
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        
        if (iRetcode == 1) {
            //do any addtion here...
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            if ([dataArr isKindOfClass:[NSArray class]]) {
//                NSMutableArray *arr = [NSMutableArray array];
                [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    NSString *tagTitle = [obj objectForKey:@"title"];
                    if (![JYHelpers isEmptyOfString:tagTitle]) {
                        if (isMale) {
                            [self.maleRecommendTagArr addObject:tagTitle];
                        }else{
                            [self.feMaleRecommendTagArr addObject:tagTitle];
                        }
//                        [arr addObject:tagTitle];
                    }
                }];
                if (successBlock) {
                    successBlock();
                }
                //                [sourceRecommendTagArr addObjectsFromArray:arr];
                //                [self relayoutRecommendTagView];
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"获取失败"];
            }
        }
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];


}
//懒加载
- (NSMutableArray *)maleRecommendTagArr{
    if (_maleRecommendTagArr == nil) {
        _maleRecommendTagArr = [NSMutableArray array];
    }
    return _maleRecommendTagArr;
}
- (NSMutableArray *)feMaleRecommendTagArr{
    if (_feMaleRecommendTagArr == nil) {
        _feMaleRecommendTagArr = [NSMutableArray array];
    }
    return _feMaleRecommendTagArr;

}
@end
