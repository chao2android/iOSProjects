//
//  JYContactSearchView.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/27.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYContactSearchView.h"
#import "JYPhoneContactsModel.h"

@implementation JYContactSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self setTransform:cg
        _siftContactsList = [NSMutableArray array];
        //半透明背景
        UIView *searchViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight - kStatusBarHeight)];
//        [searchViewBg setTag:1234];
        [searchViewBg setBackgroundColor:[UIColor whiteColor]];
//        [searchViewBg setAlpha:0.3];
        [searchViewBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancekButtonClicked)]];
        noResultLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kScreenWidth - 20 , 50)];
        [noResultLab setText:@"没有搜索结果"];
        [noResultLab setTextColor:kTextColorGray];
        [noResultLab setFont:[UIFont boldSystemFontOfSize:17]];
        [noResultLab setTextAlignment:NSTextAlignmentCenter];
        [searchViewBg addSubview:noResultLab];
        
//        [self addSubview:searchViewBg];
        //搜索view
        UIView *searchView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [searchView setBackgroundColor:[UIColor clearColor]];
//        [searchView setTag:4321];
        [self addSubview:searchView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40+kStatusBarHeight + 10)];
        [bgView setBackgroundColor:[JYHelpers setFontColorWithString:@"#edf1f4"]];
        [searchView addSubview:bgView];
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, kStatusBarHeight + 10, kScreenWidth - 50 - 15-5, 30)];
        [_searchTextField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        [_searchTextField setBackgroundColor:[UIColor whiteColor]];
        [_searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [_searchTextField setClearButtonMode:UITextFieldViewModeAlways];
        [_searchTextField setFont:[UIFont systemFontOfSize:15]];
        [_searchTextField setDelegate:self];
        [_searchTextField addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
        [_searchTextField setPlaceholder:@"输入电话或者姓名"];
        //    [barSearch setPrompt:@"搜索"];
//        [barSearch setDelegate:self];
        [bgView addSubview:_searchTextField];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(self.width - 50, kStatusBarHeight+10, 40, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [cancelBtn setTitleColor:kTextColorBlue forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancekButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        _contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, bgView.bottom, self.width, self.height - 40) style:UITableViewStylePlain];
        [_contactsTableView setBackgroundColor:[UIColor clearColor]];
        [_contactsTableView setTableFooterView:[[UIView alloc] init]];
        [_contactsTableView setDelegate:self];
        [_contactsTableView setDataSource:self];
        [_contactsTableView setBackgroundView:searchViewBg];
        [self addSubview:_contactsTableView];
    }
    return self;
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _siftContactsList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"JYContactSearchViewCellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    }
    JYPhoneContactsModel *model = (JYPhoneContactsModel*)[_siftContactsList objectAtIndex:indexPath.row];
    [cell.textLabel setText:model.name];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchTextField resignFirstResponder];
    JYPhoneContactsModel *contact = (JYPhoneContactsModel*)[_siftContactsList objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(contactSearchView:didFinishedSearchWithContactsModel:)]) {
        [self.delegate contactSearchView:self didFinishedSearchWithContactsModel:contact];
    }
    [self cancekButtonClicked];

}
#pragma mark - Click Handler && Gesture
- (void)cancekButtonClicked{
    
    [_siftContactsList removeAllObjects];
    [_searchTextField resignFirstResponder];
    [_searchTextField setText:@""];
    [_contactsTableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(contactSearchViewShouldCancelSearch:)]) {
        [self.delegate contactSearchViewShouldCancelSearch:self];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChangeText:(UITextField*)textField{
    
    [textField setClipsToBounds:NO];
    
    bool isChinese;//判断当前输入法是否是中文
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    NSString *str = [[textField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSLog(@"汉字");
            [self reloadDataWithText:textField.text];
        }
        else
        {
            NSLog(@"输入的英文还没有转化为汉字的状态");
            
        }
    }else{
        NSLog(@"str=%@; 本次长度=%ld",str,(long)[str length]);
        [self reloadDataWithText:textField.text];
    }

}

#pragma mark - Data Handler
- (void)reloadDataWithText:(NSString*)text{
  
    [_siftContactsList removeAllObjects];
    for (JYPhoneContactsModel *model in _contactsList) {
        NSRange rangeName = [model.name rangeOfString:text];
        NSRange rangeMobile = [model.mobile rangeOfString:text];
        
        if (rangeMobile.location != NSNotFound || rangeName.location != NSNotFound) {
            [_siftContactsList addObject:model];
        }
    }
    if (_siftContactsList.count == 0) {
        [noResultLab setHidden:NO];
    }else{
        [noResultLab setHidden:YES];
    }
    [_contactsTableView reloadData];
}
- (void)beginEdit{
    [_searchTextField becomeFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
