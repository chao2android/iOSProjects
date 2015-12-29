//
//  InstallViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/22.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "InstallViewController.h"
#import "InstallTableViewCell.h"
#import "AboutUsViewController.h"
#import "AdviceViewController.h"
@interface InstallViewController ()
{
    UITableView * _tableView;
    NSArray * _imageArray;
    NSArray * _titleArray;
    
    UILabel * _catchLabel;
    
    BOOL _isClear;
}
@end

@implementation InstallViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"功能设置";
    [self AddLeftImageBtn:[UIImage imageNamed:@"goBack"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@""] target:self action:Nil];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self beginData];
    [self uiConfig];
    // Do any additional setup after loading the view.
}

#pragma mark - 数据初始化
- (void)beginData{
    _imageArray = @[@"font.png",@"apns",@"clear.png",@"wifi.png",@"advice.png",@"aboutUs.png",@"update.png"];
    _titleArray = @[@"正文字号选择",@"消息推送",@"清除缓存",@"Wifi环境下自动播放",@"意见反馈",@"关于我们",@"检查更新"];
}


#pragma mark - UI布局
- (void)uiConfig{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 378) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}

#pragma mark - UITableView Delegate & UITabelView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//每个分组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellIde = @"cellfont";
        InstallTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == Nil) {
            
            cell = [[InstallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        [cell creatImageViewAndLabelWithImageString:[_imageArray objectAtIndex:indexPath.row] Title:[_titleArray objectAtIndex:indexPath.row]];
        cell.jiantouImageView.hidden  =YES;
        if (indexPath.row == 1) {//推送的开关
            cell.lineImageView.hidden = YES;
            
            self.clearSwtich = [[UISwitch alloc]initWithFrame:CGRectMake(MainScreenWidth - 70, 6, 0, 0)];//实例化，坐标为 x100,y100
            NSString * apns = [[NSUserDefaults standardUserDefaults] objectForKey:@"apns"];
            if ([apns isEqualToString:@"1"]) {//开着的
                [self.clearSwtich setOn:YES animated:YES];
            }else{
                [self.clearSwtich setOn:NO animated:YES];
            }
            

            [cell.contentView addSubview:self.clearSwtich];

            self.clearSwtich.onTintColor = [UIColor colorWithRed:(51./255.0) green:(181./255.0) blue:(229./255.0) alpha:1];
            [self.clearSwtich addTarget:self action:@selector(clearSwitchIsChanged:) forControlEvents:UIControlEventValueChanged];

        }else{//字号大小
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, MainScreenWidth, 44)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled= YES;
            [cell.contentView addSubview:imageView];
            imageView.tag = 900;

            NSArray * fontArray = @[@"小",@"中",@"大"];
            
            for (int i = 0; i<3; i++) {
                UIButton * pointButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [pointButton setFrame:CGRectMake(MainScreenWidth-140 + 40 * i, 10, 14, 14)];
                [pointButton addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
                [pointButton setTag:100+i];
                [pointButton setBackgroundImage:[UIImage imageNamed:@"13.png"] forState:UIControlStateNormal];
                [pointButton setBackgroundImage:[UIImage imageNamed:@"14.png"] forState:UIControlStateSelected];
                [imageView addSubview:pointButton];

                
                UIButton * fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [fontButton setFrame:CGRectMake(MainScreenWidth - 130  + 40 *i, 0, 34, 39)];
                [fontButton addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
                [fontButton setTag:100 + i];
                [fontButton setTitle:fontArray[i] forState:UIControlStateNormal];
                [fontButton setTitleColor:[UIColor colorWithRed:0/255.0 green:161/255.0 blue:224/255.0 alpha:1] forState:UIControlStateSelected];
                [fontButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [imageView addSubview:fontButton];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]==13) {
                    if (i==0) {
                        pointButton.selected = YES;
                        fontButton.selected = YES;
                    }
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]==16){
                    if (i==1) {
                        pointButton.selected = YES;
                        fontButton.selected = YES;

                    }
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"font"] integerValue]==19){
                    if (i==2) {
                        pointButton.selected = YES;
                        fontButton.selected = YES;

                    }
                }

            }
        }
        return cell;
        
    }else if (indexPath.section == 1){
        
        static NSString * cellIde = @"cellclear";
        InstallTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == Nil) {
            
            cell = [[InstallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        [cell creatImageViewAndLabelWithImageString:[_imageArray objectAtIndex:indexPath.row + 2] Title:[_titleArray objectAtIndex:indexPath.row + 2]];
        cell.jiantouImageView.hidden  =YES;
        if (indexPath.row == 1) {//非WIFI环境
            cell.lineImageView.hidden = YES;
            
            self.mainSwtich = [[UISwitch alloc]initWithFrame:CGRectMake(MainScreenWidth - 70, 6, 0, 0)];//实例化，坐标为 x100,y100
            
            [cell.contentView addSubview:self.mainSwtich];
            
            NSString * apns = [[NSUserDefaults standardUserDefaults] objectForKey:@"wifi"];
            if ([apns isEqualToString:@"1"]) {//开着的
                [self.mainSwtich setOn:YES animated:YES];
            }else{
                [self.mainSwtich setOn:NO animated:YES];
            }

            
            self.mainSwtich.onTintColor = [UIColor colorWithRed:(51./255.0) green:(181./255.0) blue:(229./255.0) alpha:1];
            [self.mainSwtich addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];

        }else{
            _catchLabel = [DxyCustom creatLabelWithFrame:CGRectMake(MainScreenWidth - 100, 11, 80, 20) text:@"" alignment:NSTextAlignmentRight];
            _catchLabel.text = [NSString stringWithFormat:@"%.2fM",[self countCache]];

            [cell.contentView addSubview:_catchLabel];
        }
        return cell;

    }else if (indexPath.section == 2){
        static NSString * cellIde = @"celladvice";
        InstallTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == Nil) {
            
            cell = [[InstallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        [cell creatImageViewAndLabelWithImageString:[_imageArray objectAtIndex:indexPath.row + 4] Title:[_titleArray objectAtIndex:indexPath.row + 4]];
        if (indexPath.row == 2) {
            cell.lineImageView.hidden = YES;
        }
        return cell;
    }else{
        static NSString * cellIde = @"cellShezhi";
        UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == Nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
            cell.tag = indexPath.row;
        }
        
        return cell;
    }
}

#pragma mark - 改变字体大小
- (void)changeFont:(UIButton *)button{
    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:900];
    for (UIView *subView in imageView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn1 = (UIButton *)subView;
            if (btn1.tag == button.tag) {
                btn1.selected = YES;
            }else{
                btn1.selected = NO;
            }
        }
        
        if (button.tag == 100) {
            [[NSUserDefaults standardUserDefaults] setObject:@"13" forKey:@"font"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if (button.tag == 101){
            [[NSUserDefaults standardUserDefaults] setObject:@"16" forKey:@"font"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if (button.tag == 102){
            [[NSUserDefaults standardUserDefaults] setObject:@"19" forKey:@"font"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


#pragma mark - 非WIFI环境下的开关
- (void)switchIsChanged:(UISwitch *)paramSender
 {
     if ([self.mainSwtich isOn]) {
         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"wifi"];
         [[NSUserDefaults standardUserDefaults]synchronize];

         NSLog(@"Switch is on");
     }else{
         [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"wifi"];
         [[NSUserDefaults standardUserDefaults]synchronize];

         NSLog(@"Switch is off");
    }
}
#pragma mark - 消息推送的开关
- (void)clearSwitchIsChanged:(UISwitch *)paramSender
{
    if ([self.clearSwtich isOn]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"apns"];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                       UIRemoteNotificationTypeSound |
//                                                       UIRemoteNotificationTypeAlert)];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge  |
                                                                               　　UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        NSLog(@"Switch is on");
    }else{

        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"apns"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];

        NSLog(@"Switch is off");
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row==1) {//关于我们
            AboutUsViewController * about =[[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }else if (indexPath.row==0){//意见反馈
            AdviceViewController * advice = [[AdviceViewController alloc] init];
            [self.navigationController pushViewController:advice animated:YES];
        }else if (indexPath.row ==2){
            _isClear = NO;
            [DxyCustom showAlertViewTitle:@"发现新版本，是否更新" message:nil delegate:self];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            _isClear = YES;
            [self backNavigationController];
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//清理缓存的
- (void)backNavigationController{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清空缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (float)countCache{
    //清除documents中的文件
    NSString*path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    float MCount =  [self folderSizeAtPath:path];
    
    
    
    NSString*lbPath= [NSString stringWithFormat:@"%@/Library",NSHomeDirectory()];
    MCount += [self folderSizeAtPath:lbPath];
    NSLog(@"%f = ",MCount);
    
    
    return MCount;
    
    
    
    
}


-  (float) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSArray *filePathArray = [fileName componentsSeparatedByString:@"."];
        NSString *houZuiStr = nil;
        if (filePathArray.count == 2) {
            houZuiStr = [[fileName componentsSeparatedByString:@"."] lastObject];
            if ([houZuiStr isEqualToString:@"jpg"]||[houZuiStr isEqualToString:@"aac"]||[houZuiStr isEqualToString:@"png"]) {
                NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
                folderSize += [self fileSizeAtPath: fileAbsolutePath];
            }
        }
        
        
        
    }
    
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小

-  (float) fileSizeAtPath:(NSString*) filePath{
    
    
    

    
    
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    
    
    if ([manager fileExistsAtPath:filePath]){
        
        NSLog(@"%llu",[[manager attributesOfItemAtPath:filePath error:nil] fileSize]);
        unsigned long long fileDX = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        
        
        return fileDX;
        
    }
    
    return 0;
    
    
    
}

- (void)ClearCache{
    
    //清除documents中的文件
    NSString*path=[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    
    NSFileManager*manager=[NSFileManager defaultManager];
    //array保存的是所有文件名字
    NSArray*array= [manager contentsOfDirectoryAtPath:path error:nil];
    
    
    //YOUR-Bundle_Identifier.plist
    
    for (NSString*fileName in array) {
        //删除指定文件
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),fileName] error:nil];
    }
    NSLog(@"document =%@",array);
    
    
    
    
    //清楚library中的 文件
    NSString*lbPath= [NSString stringWithFormat:@"%@/Library",NSHomeDirectory()];;
    
    
    
    //array保存的是所有文件名字
    NSArray*lbArray= [manager contentsOfDirectoryAtPath:lbPath error:nil];
    
    
    
    for (NSString*fileName in lbArray) {
        //删除指定文件
        if ([fileName isEqualToString:@"Caches"]||[fileName isEqualToString:@"Preferences"]) {
            
        }else{
            [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",lbPath,fileName] error:nil];
        }
        
    }
    
    NSLog(@"libaar = %@",lbArray);

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_isClear) {
        
        if (buttonIndex == 1) {
            [self StartLoading];
            [self ClearCache];
            [self StopLoading];
            _catchLabel.text = [NSString stringWithFormat:@"0 M"];
        }


    }else{
        if (buttonIndex ==1) {
            [DxyCustom showSureAlertViewTitle:@"已经是最新版本" message:nil delegate:nil];
        }

    }
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

@end
