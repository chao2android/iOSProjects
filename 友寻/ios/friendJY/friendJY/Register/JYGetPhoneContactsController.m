//
//  JYGetPhoneContactsController.m
//  friendJY
//
//  Created by 高斌 on 15/3/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGetPhoneContactsController.h"
#import <AddressBook/AddressBook.h>
#import "JYHttpServeice.h"
#import "JYAppDelegate.h"

@interface JYGetPhoneContactsController ()

@property (nonatomic, strong) NSMutableArray *contactsList;

@end

@implementation JYGetPhoneContactsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self setTitle:@"同步通讯录"];
        
        _contactsList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 100, kScreenWidth-200, 60)];
    [btn setTitle:@"确定并继续" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:btn];
    
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipBtn setFrame:CGRectMake(100, btn.bottom+10, kScreenWidth-200, 60)];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(skipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:skipBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)btnClick:(UIButton *)btn
{
//    [self readAllPeoples];
    
    [self setContactsList:[JYHelpers readAllPeoples]];
    [self writeFileWith:self.contactsList];
    [self requestUpList];
}

- (void)skipBtnClick:(UIButton *)btn
{
    NSLog(@"跳过");
}

//读取所有联系人
-(void)readAllPeoples
{
    
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
        return ;
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
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
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
                        //新建一个联系人Dict
                        NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
                        [contactDict setObject:nameString forKey:@"name"];
                        NSString *mobile = [(__bridge NSString *)value stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        [contactDict setObject:mobile forKey:@"mobile"];
                        [_contactsList addObject:contactDict];
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
    
    NSLog(@"%@", _contactsList);
    [self writeFileWith:_contactsList];
    
    //释放内存&nbsp;
    //    [tmpPeoples release];
    //    CFRelease(tmpAddressBook);
    
}

- (void)writeFileWith:(NSArray *)contactsList
{
    NSString *jsonString = @"";
    if (contactsList) {
        //数组转JSON串
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactsList options:NSJSONWritingPrettyPrinted error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
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
    [writerData appendData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //7、将其他数据添加到缓冲中
    //将缓冲的数据写入到文件中
    [writerData writeToFile:_filePath atomically:YES];
    
    
}

#pragma mark - request

//上传通信录
- (void)requestUpList
{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:@"upload" forKey:@"mod"];
    [parametersDict setObject:@"up_mobile_list" forKey:@"func"];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSData *fileData = [NSData dataWithContentsOfFile:_filePath];
    if (fileData) {
        [dataDict setObject:fileData forKey:@"upload"];
    }
    
    [JYHttpServeice requestUpListWithParameters:parametersDict dataDict:dataDict success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            
            //成功
            [[JYAppDelegate sharedAppDelegate] showTip:@"通信录上传成功"];
            
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_IsUpList", uid]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterAndUpMobileListSuccessNotification object:nil userInfo:nil];
            
            
        } else {
            NSLog(@"%@", [responseObject objectForKey:@"retmean"]);
        }
        
    } failure:^(id error) {
        
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];

        
    }];
    
}

@end
