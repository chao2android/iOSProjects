//
//  JYModifyPwdController.m
//  friendJY
//
//  Created by coder_zhang on 15/4/1.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYModifyPwdController.h"
#import "JYAppDelegate.h"

@interface JYModifyPwdController ()<UITextFieldDelegate>
//存储输入框的数组
@property (nonatomic, strong) NSMutableArray *pwdTextFieldArr;
//错误提示信息
@property (nonatomic, strong) UILabel *wrongMsgLab;

@end

@implementation JYModifyPwdController
//懒加载
- (NSArray *)cellTitleArr{
    if (_cellTitleArr == nil) {
        _cellTitleArr = @[@[@"输入原密码",@"输入新密码",@"再次输入新密码"]];
    }
    return _cellTitleArr;
}
- (NSMutableArray *)pwdTextFieldArr{
    if (_pwdTextFieldArr == nil) {
        _pwdTextFieldArr = [NSMutableArray array];
    }
    return _pwdTextFieldArr;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [(UITextField*)_pwdTextFieldArr[0] becomeFirstResponder];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"修改密码"];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(pwdDone)];
    
}
- (void)initFooterView{
    [super initFooterView];
    _wrongMsgLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    _wrongMsgLab.font = [UIFont systemFontOfSize:14.0f];
    _wrongMsgLab.textColor = [UIColor redColor];
    [_tableView.tableFooterView addSubview:_wrongMsgLab];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.cellTitleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kTextColorBlack;
    [self initSubViewsOfCell:cell inIndex:indexPath.row];
    return cell;
}
//初始化cell上的子视图
- (void)initSubViewsOfCell:(UITableViewCell*)cell inIndex:(NSInteger)index{
    NSString *str = @"输入新密码";
    CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:15]].width;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + width + 49, 12, kScreenWidth - 15 - width - 60, 20)];
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setFont:[UIFont systemFontOfSize:15]];

    if (index != 0) {
        [textField setPlaceholder:@"请输入6~20位密码"];
        [textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    textField.clearsOnBeginEditing = YES;
    [textField setDelegate:self];
    //将textField添加到pwdTextFieldArr数组中方便管理
    [self.pwdTextFieldArr addObject:textField];
    [cell.contentView addSubview:textField];
}
//点击完成按钮出发的方法
- (void)pwdDone{
//http://c.friendly.dev/cmiajax/?mod=login&func=login&name=13126798912&password=111111
    
    if (((UITextField*)self.pwdTextFieldArr[0]).text.length == 0) {
        _wrongMsgLab.text = @"原密码为空";
        return;
    }
    //判断两次输入的密码是否相同
    if ([((UITextField*)self.pwdTextFieldArr[1]).text isEqualToString:((UITextField*)self.pwdTextFieldArr[2]).text]) {
        
    NSDictionary *paraDic = @{@"mod":@"login",@"func":@"change_password"};
    NSDictionary *postDic = @{@"current":((UITextField*)self.pwdTextFieldArr[0]).text,@"new":((UITextField*)self.pwdTextFieldArr[2]).text};
     //相同则执行上传旧密码和新密码到服务器进行修改
    [JYHttpServeice requestWithParameters:paraDic postDict:postDic httpMethod:@"POST" success:^(id responseObject) {
        
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
//      iRetcode字段值的含义 -1 新密码为空 -3 密码位数不对 -4 旧密码不对 -5 数据库修改失败
        //修改成功，AlertView提醒用户并且返回上级界面
        if (iRetcode == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(iRetcode == -1){
    //修改失败是的处理
        _wrongMsgLab.text = @"新密码为空";
            NSLog(@"失败");
        }else if(iRetcode == -3){
            //修改失败是的处理
            _wrongMsgLab.text = @"密码位数不对";
            NSLog(@"失败");
        }else if(iRetcode == -4){
            //修改失败是的处理
            _wrongMsgLab.text = @"旧密码不对";
            NSLog(@"失败");
        }
    } failure:^(id error) {
    //发生错误时的处理
        NSLog(@"错误");
       _wrongMsgLab.text = @"发生错误";
    }];
    }else
        _wrongMsgLab.text = @"两次输入密码不一致";
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length == 20 && ![string isEqualToString:@""]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"密码最多只能20位"];
        return NO;
    }
    return YES;
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
