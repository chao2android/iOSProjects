//
//  WriteViewController.m
//  TestNewsDaLian
//
//  Created by dxy on 14/12/24.
//  Copyright (c) 2014年 zp. All rights reserved.
//

#import "WriteViewController.h"
#import "WriteTableViewCell.h"
@interface WriteViewController ()
{
    UITableView  * _tableView;
    
    UIView *_threeButtonBgView;
    UIButton *writeButton;
    
    
    UIImageView * grayImageView;
    UIImageView * whiteImageView;
    UITextView * _textView;
    
    NSMutableArray * _dataArray;
    
    NSInteger keyboardhight;//键盘的高度
    
    NSInteger rowNum;

}
@end

@implementation WriteViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"热点";
    [self registerForKeyboardNotifications];//注册通知  观察键盘的变化
    [self AddLeftImageBtn:[UIImage imageNamed:@"goBack"] target:self action:@selector(GoBack)];
    [self AddRightImageBtn:[UIImage imageNamed:@""] target:self action:Nil];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//观察键盘变化的方法
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
//    if(kbSize.height == 216)
//    {
//        keyboardhight = 0;
//    }
//    else
//    {
//        keyboardhight = 36;   //252 - 216 系统键盘的两个不同高度
//    }
//    
//    if (kbSize.height==252) {
//        
//        [UIView animateWithDuration:0.26 animations:^{
//            [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-252-150, MainScreenWidth, 150)];
//        }];
//        
//    }
    
    [UIView animateWithDuration:0.26 animations:^{
        [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-kbSize.height-150, MainScreenWidth, 150)];
    }];

    
    //输入框位置动画加载
    //[self begainMoveUpAnimation:keyboardhight];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
//    if (kVersion>7.0) {
//        
//    }else {
//        [UIView animateWithDuration:0.26 animations:^{
//            [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-216-150, MainScreenWidth, 150)];
//        }];
//    }
    
//    [UIView animateWithDuration:0.26 animations:^{
//        [whiteImageView setFrame:CGRectMake(0, MainScreenHeight - 64-216-150, MainScreenWidth, 150)];
//    }];
    
    grayImageView.hidden = YES;

}

//输入结束时调用动画（把按键。背景。输入框都移下去）
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"tabtabtab");
    //[self endEditAnimation];
    
    //释放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    [self uiConfig];
    
    [self getData];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 获取数据
- (void)getData{

    if (_iDownManager) {
        return;
    }
    [self StartLoading];
    _iDownManager = [[ImageDownManager alloc] init];
    _iDownManager.delegate = self;
    _iDownManager.OnImageDown = @selector(getCommintOnLoadFinish:);
    _iDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString *urlstr = [NSString stringWithFormat:@"http://42.202.146.236:8080/comment/services/rs/comments/commentinfo?resourceID=%@",self.model.source_id];
    
    [_iDownManager GetImageByStr:urlstr];



}


- (void)getCommintOnLoadFinish:(ImageDownManager *)sender {
    NSDictionary *dict =[ sender.mWebStr JSONValue];
    [self Cancel];
    
    NSArray * array = [dict objectForKey:@"tcomment"];
    for (NSDictionary * tcommentDict in array) {
        CommintModel * model = [[CommintModel alloc] init];
        [model setValuesForKeysWithDictionary:tcommentDict];
        [_dataArray addObject:model];
    }
    rowNum = _dataArray.count + 1;
   [_tableView reloadData];
}



- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}


- (void)dealloc {
    [self Cancel];
}

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.iDownManager);
}



#pragma mark - UI布局
- (void)uiConfig{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-40-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _threeButtonBgView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 40-64, MainScreenWidth, 40)];
    [self.view addSubview:_threeButtonBgView];
    
    grayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    grayImageView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.5];
    grayImageView.hidden = YES;
    grayImageView.userInteractionEnabled = YES;
    [self.view addSubview:grayImageView];
    
    whiteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 64-226-180, MainScreenWidth, 150)];
    whiteImageView.backgroundColor = [UIColor redColor];
    whiteImageView.userInteractionEnabled = YES;
    whiteImageView.image = [UIImage imageNamed:@"kuagn.png"];
    [grayImageView addSubview:whiteImageView];
    
    
    UIImageView * clearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    clearImageView.userInteractionEnabled = YES;
    clearImageView.backgroundColor = [UIColor clearColor];
    
    [grayImageView addSubview:clearImageView];
    
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];

    [clearImageView addGestureRecognizer:tap];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, MainScreenWidth - 40, 99)];
    _textView.font = [UIFont systemFontOfSize:17];
    [whiteImageView addSubview:_textView];
    
    
    UIButton * fabiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [fabiao setBackgroundImage:[UIImage imageNamed:@"fabiao"] forState:UIControlStateNormal];
    [fabiao setFrame:CGRectMake(MainScreenWidth - 70 , 150-30, 54, 23)];
    [fabiao addTarget:self action:@selector(ifTextViewNull) forControlEvents:UIControlEventTouchUpInside];

    [whiteImageView addSubview:fabiao];
    
    [self uiThreeButton];
    
}

#pragma mark - 判断是否可以发送空的评论
- (void)ifTextViewNull{
    
    if (_textView.text.length>0) {
        [self writeOnClick];
    }else{
        [DxyCustom showAlertViewTitle:@"提示" message:@"请输入评论内容" delegate:nil];
    }
    
}

#pragma mark - 収键盘
- (void)hiddenKeyBoard{
    grayImageView.hidden = YES;
    [_textView resignFirstResponder];
}

- (void)uiThreeButton{
    
    writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeButton setImage:[UIImage imageNamed:@"blueWrite.png"] forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(grayImageViewHidden) forControlEvents:UIControlEventTouchUpInside];
    [writeButton setFrame:CGRectMake((MainScreenWidth - 30* 3)/2  + 30, 5, 30, 30)];
    [_threeButtonBgView addSubview:writeButton];
    
}
#pragma mark - 点击评论按钮
- (void)grayImageViewHidden{
    [self.view addSubview:grayImageView];
    [_textView becomeFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        grayImageView.hidden = NO;
    }];
    
}
#pragma mark - 点击评论按钮
- (void)writeOnClick{
    
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    self.mDownManager = [[ASIDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(wirteOnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSString * str = @"http://42.202.146.236:8080/comment/services/rs/comments/add";
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.model.source_id,@"resourceID",
                          _textView.text,@"commentInfo",
                          nil];
    [_mDownManager PostHttpRequest:str :dic :nil :nil];
    
}

- (void)wirteOnLoadFinish:(ImageDownManager *)sender {
    if ([sender.mWebStr isEqualToString:@"true"]) {
        NSLog(@"评论成功");
        [grayImageView setHidden:YES];
        
        CommintModel * model = [[CommintModel alloc] init];
        [model setCommentInfo:_textView.text];
        [_dataArray addObject:model];
        rowNum ++;
        [_tableView reloadData];
        [_tableView scrollRectToVisible:CGRectMake(0, _tableView.contentSize.height-_tableView.frame.size.height, MainScreenWidth,_tableView.frame.size.height) animated:YES];
        _textView.text = @"";
        [_textView resignFirstResponder];
    }
    
    [self Cancel];
    
}



#pragma  mark - UITableView delegate & UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return rowNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 40;
    }else {
        CommintModel * model = [_dataArray objectAtIndex:indexPath.row-1];
        CGSize size =  [DxyCustom boundingRectWithString:model.commentInfo width:MainScreenWidth - 66 height:800 font:14];
        return size.height +50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        static NSString * cellIde = @"write";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
            UILabel * writeLabel = [DxyCustom creatLabelWithFrame:CGRectMake(110, 10, 46, 20) text:@"评论" alignment:NSTextAlignmentCenter];
            writeLabel.textColor = [UIColor colorWithRed:0/255.0 green:161/255.0 blue:224/255.0 alpha:1];
            writeLabel.font = [UIFont systemFontOfSize:22];
            [cell.contentView addSubview:writeLabel];
            
            UILabel * numberLabel = [DxyCustom creatLabelWithFrame:CGRectMake(160, 13, 50, 20) text:[NSString stringWithFormat:@"(%d)",_dataArray.count] alignment:NSTextAlignmentLeft];
            numberLabel.textColor =[UIColor colorWithRed:0/255.0 green:161/255.0 blue:224/255.0 alpha:1];
            numberLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:numberLabel];
        }
        cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        return cell;
        
        
    }else{
        static NSString * cellIde = @"cellIde";
        CommintModel * model = [_dataArray objectAtIndex:indexPath.row - 1];
        WriteTableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil) {
            cell = [[WriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        [cell setUIConfigWithModel:model];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
