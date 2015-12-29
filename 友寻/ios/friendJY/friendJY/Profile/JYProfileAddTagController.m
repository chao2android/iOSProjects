//
//  JYProfileAddTagController.m
//  friendJY
//
//  Created by ouyang on 3/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYProfileAddTagController.h"

@interface JYProfileAddTagController (){
    UITextField *_editTagTextField;
}

@end

@implementation JYProfileAddTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"添加标签"];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(-1, 15, kScreenWidth+2, 50)];
    bg.backgroundColor = [UIColor whiteColor];
    bg.layer.borderColor = [[JYHelpers setFontColorWithString:@"#cccccc"] CGColor];
    bg.layer.borderWidth = 1;
    [self.view addSubview:bg];
    
    _editTagTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth-20, 20)];
    [_editTagTextField setBackgroundColor:[UIColor clearColor]];
    [_editTagTextField setDelegate:self];
    [_editTagTextField setPlaceholder:@"输入标签(最多10个字)"];
    [_editTagTextField setReturnKeyType:UIReturnKeyDone];
    //    [_editTagTextField becomeFirstResponder];
    [self.view addSubview:_editTagTextField];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  
    [theTextField resignFirstResponder];
    
    return YES;
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
