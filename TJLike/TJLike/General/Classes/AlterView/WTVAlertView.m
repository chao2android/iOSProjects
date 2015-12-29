//
//  WTVAlertView.m
//  WiseTV
//
//  Created by littlezl on 15/2/12.
//  Copyright (c) 2015年 tjgdMobilez. All rights reserved.
//

#import "WTVAlertView.h"
#import "WTVPasswordTextField.h"

#define PasswordMaxLength 16

typedef NS_ENUM(NSInteger, WTVAlertType) {
    WTVAlertType_Default = 0,
    WTVAlertType_Buttons,
    WTVAlertType_TextFields
};

@interface WTVAlertView()<UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) WTVAlertType alertType;
@property (nonatomic, strong) UIView *alertViewPanel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) NSMutableArray *textFieldArray;
@end

@implementation WTVAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<WTVAlertViewDelegate>*/)delegate buttonTitles:(NSArray *)buttonTitles buttonImageNames:(NSArray *)buttonImageNames
{
    UIWindow *mainWin = [[[UIApplication sharedApplication] delegate] window];
    if (self = [super initWithFrame:mainWin.frame]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        self.alertViewPanel = [[UIView alloc] init];
        self.titleLabel = [[UILabel alloc] init];
        self.messageLabel = [[UILabel alloc] init];
        self.separatorLine = [[UIView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimations)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.alertType = WTVAlertType_Buttons;
        self.delegate = delegate;
        
        CGFloat viewHeight = 10.0;
        CGFloat marginHeight = 10.0;
        CGFloat viewWidth = SCREEN_WIDTH - 25.0*2;
        
        if (title) {
            _titleLabel.frame = CGRectMake(0, marginHeight, viewWidth, 21);
            [_titleLabel setText:title];
            [_titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [_titleLabel setTextColor:UIColorFromRGB(0x363636)];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [_alertViewPanel addSubview:_titleLabel];
            viewHeight = viewHeight + 21 + marginHeight;
            
            _separatorLine.frame = CGRectMake(0, viewHeight, viewWidth, 0.5);
            _separatorLine.backgroundColor = UIColorFromRGB(0x7d7d7d);
            _separatorLine.alpha = 0.7;
            [_alertViewPanel addSubview:_separatorLine];
        }
        
        if (message) {
            _messageLabel.frame = CGRectMake(5, viewHeight, viewWidth-5*2, 44.0);
            [_messageLabel setBackgroundColor:[UIColor clearColor]];
            
            [_messageLabel setTextColor:UIColorFromRGB(0x7d7d7d)];
            [_messageLabel setFont:[UIFont systemFontOfSize:14]];
            
            [_messageLabel setNumberOfLines:0];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:message];
            _messageLabel.attributedText = attrStr;
            NSRange range = NSMakeRange(0, attrStr.length);
            NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
            CGSize size = [_messageLabel.text boundingRectWithSize:_messageLabel.bounds.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            [_messageLabel setFrame:CGRectMake(5, viewHeight+5, MAX(viewWidth-10, size.width), size.height)];
            [_messageLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [_messageLabel setTextAlignment:NSTextAlignmentCenter];
            
            [_alertViewPanel addSubview:_messageLabel];
            viewHeight = viewHeight + size.height + marginHeight;
        }
        
        NSInteger num = MIN(buttonTitles.count, buttonImageNames.count);
        CGFloat buttonWidth = 65.0f;
        CGFloat buttonMarginWidth = 36.f;
        if (num>2) {
            buttonMarginWidth = buttonMarginWidth/(2^(num-2));
        }
        CGFloat oriX = (viewWidth - buttonMarginWidth*(num-1) - buttonWidth*num)/2;
        
        viewHeight = viewHeight + marginHeight*3;
        
        for (int i = 0; i < num; i++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(oriX + i*(buttonWidth + buttonMarginWidth), viewHeight, buttonWidth, buttonWidth);
            [item setImage:[UIImage imageNamed:[buttonImageNames objectAtIndex:i]] forState:UIControlStateNormal];
            item.tag = i;
            [item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(item.frame.origin.x, viewHeight + buttonWidth, buttonWidth, 21)];
            itemLabel.backgroundColor = [UIColor clearColor];
            itemLabel.font = [UIFont systemFontOfSize:9.0];
            itemLabel.textColor = UIColorFromRGB(0x7d7d7d);
            itemLabel.textAlignment = NSTextAlignmentCenter;
            itemLabel.text = [buttonTitles objectAtIndex:i];
            [_alertViewPanel addSubview:item];
            [_alertViewPanel addSubview:itemLabel];
        }
        
        viewHeight = viewHeight + buttonWidth + 21 + marginHeight*2;
        
        [_alertViewPanel setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        [_alertViewPanel setBackgroundColor:[UIColor whiteColor]];
        _alertViewPanel.layer.cornerRadius = 6;
        _alertViewPanel.layer.shadowRadius = 8;
        
        [self addSubview:_alertViewPanel];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<WTVAlertViewDelegate>*/)delegate textFieldPlaceholders:(NSArray *)placeholders specialLine:(NSArray *)specialLines limits:(NSArray *)limits cancelButton:(NSString *)cancelTitle otherButton:(NSString *)otherTitle
{
    _alertType = WTVAlertType_TextFields;
    self.delegate = delegate;
    UIWindow *mainWin = [[[UIApplication sharedApplication] delegate] window];
    if (self = [super initWithFrame:mainWin.frame]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        self.alertViewPanel = [[UIView alloc] init];
        self.titleLabel = [[UILabel alloc] init];
        self.messageLabel = [[UILabel alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimations)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    
        CGFloat viewHeight = 10.0;
        CGFloat marginHeight = 10.0;
        CGFloat viewWidth = SCREEN_WIDTH - 25.0*2;
        
        if (title) {
            _titleLabel.frame = CGRectMake(0, marginHeight, viewWidth, 21);
            [_titleLabel setText:title];
            [_titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [_titleLabel setTextColor:UIColorFromRGB(0x363636)];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [_alertViewPanel addSubview:_titleLabel];
            viewHeight = viewHeight + 21 + marginHeight;
        }
        
        if (message) {
            _messageLabel.frame = CGRectMake(5, viewHeight, viewWidth-5*2, 44.0);
            [_messageLabel setBackgroundColor:[UIColor clearColor]];
            
            [_messageLabel setTextColor:UIColorFromRGB(0x7d7d7d)];
            [_messageLabel setFont:[UIFont systemFontOfSize:14]];
            
            [_messageLabel setNumberOfLines:0];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:message];
            _messageLabel.attributedText = attrStr;
            NSRange range = NSMakeRange(0, attrStr.length);
            NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
            CGSize size = [_messageLabel.text boundingRectWithSize:_messageLabel.bounds.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            [_messageLabel setFrame:CGRectMake(5, viewHeight+5, MAX(viewWidth-10, size.width), size.height)];
            [_messageLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [_messageLabel setTextAlignment:NSTextAlignmentCenter];
            
            [_alertViewPanel addSubview:_messageLabel];
            viewHeight = viewHeight + size.height + marginHeight;
        }
        
        viewHeight = viewHeight + marginHeight;

        CGFloat textFieldWidth = viewWidth - 25.0*2;
        CGFloat textFieldHeight = 44.0;
        CGFloat textFieldMarginHeight = 10.f;
        self.textFieldArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < placeholders.count; i++) {
            
            UITextField *textF;
            NSNumber *num = [NSNumber numberWithInt:i];
            if ([specialLines containsObject:num]) {
                textF = [[WTVPasswordTextField alloc] initWithFrame:CGRectMake(25.0, viewHeight, textFieldWidth, textFieldHeight)];
                textF.secureTextEntry = YES;
                textF.tag = 1000;
                [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            } else {
                textF = [[UITextField alloc] initWithFrame:CGRectMake(25.0, viewHeight, textFieldWidth, textFieldHeight)];
                textF.secureTextEntry = NO;
                textF.tag =  [limits[i] integerValue];
                [NOTIFICATION_CENTER addObserver:self selector:@selector(textFiledEditChanged:)
                                            name:@"UITextFieldTextDidChangeNotification"
                                          object:textF];
            }
            
            textF.borderStyle = UITextBorderStyleRoundedRect;
            textF.placeholder = [placeholders objectAtIndex:i];
            textF.delegate = self;
            if (i == placeholders.count-1) {
                textF.returnKeyType = UIReturnKeyDone;
            } else {
                textF.returnKeyType = UIReturnKeyNext;
            }
            
            [_alertViewPanel addSubview:textF];
            [_textFieldArray addObject:textF];
            viewHeight = viewHeight + textFieldHeight + textFieldMarginHeight;
            
        }
        
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-0.5, viewWidth, 0.5)];
        vi.backgroundColor = UIColorFromRGB(0x7d7d7d);
        vi.alpha = 0.7;
        [_alertViewPanel addSubview:vi];
        
        CGFloat buttonW = viewWidth/2;
        
        UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(buttonW-0.5, viewHeight, 0.5, 50)];
        vie.backgroundColor = UIColorFromRGB(0x7d7d7d);
        vie.alpha = 0.7;
        [_alertViewPanel addSubview:vie];
        
        UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBut.frame = CGRectMake(0, viewHeight, buttonW-0.5, 50);
        cancelBut.tag = 0;
        [cancelBut setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelBut addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [_alertViewPanel addSubview:cancelBut];
        
        UIButton *otherBut = [UIButton buttonWithType:UIButtonTypeSystem];
        otherBut.frame = CGRectMake(buttonW+0.5, viewHeight, buttonW-0.5, 50);
        otherBut.tag = 1;
        [otherBut setTitle:otherTitle forState:UIControlStateNormal];
        [otherBut addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [_alertViewPanel addSubview:otherBut];
        
        viewHeight = viewHeight + 50;

        [_alertViewPanel setFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        [_alertViewPanel setBackgroundColor:[UIColor whiteColor]];
        _alertViewPanel.layer.cornerRadius = 6;
        _alertViewPanel.layer.shadowRadius = 8;
        
        [self addSubview:_alertViewPanel];
    }
    return self;
}


-(void)selectItem:(UIButton *)item
{
    [self hiddenWithAnimations];
    
    switch (_alertType) {
        case WTVAlertType_Buttons:
        {
            [self.delegate wtvAlertView:self clickedButtonAtIndex:item.tag];
        }
            break;
        case WTVAlertType_TextFields:
        {
            if (item.tag == 0) {
                [self.delegate wtvAlertViewCancel:self];
            } else {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (int i =0;i<_textFieldArray.count;i++) {
                    UITextField *textF = [_textFieldArray objectAtIndex:i];
                    [arr addObject:textF.text];
                }
                [self.delegate wtvAlertView:self textFieldArray:arr];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 显示及消失动画

#define degreesToRadian(x) (M_PI * (x) / 180.0)

-(void)show{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    UIWindow *mainWin = [[[UIApplication sharedApplication] delegate] window];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)// 竖屏
    {
        self.transform = CGAffineTransformMakeRotation(degreesToRadian(0));
        self.frame = mainWin.frame;
        [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, -self.bounds.size.height)];
    }
    else
    {
        float angle = ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)?90:-90;
        
        self.transform = CGAffineTransformMakeRotation(degreesToRadian(angle));
        self.frame = mainWin.frame;
        
        [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, -self.bounds.size.height)];
        
    }
    
    [mainWin addSubview:self];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if (_alertType == WTVAlertType_TextFields) {
        [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-60)];
    } else {
        [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-30)];
    }
    
    [UIView commitAnimations];
}

-(void)hiddenWithAnimations
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [_alertViewPanel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height*3/2)];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(finishAlertJob) withObject:nil afterDelay:0.25];
}

-(void)finishAlertJob
{
    for (UIView *view in _alertViewPanel.subviews) {
        [view removeFromSuperview];
    }
    
    [_alertViewPanel removeFromSuperview];
    [self removeFromSuperview];
}

-(void)dealloc
{
    _titleLabel = nil;
    _messageLabel = nil;
    _separatorLine = nil;
    _alertViewPanel = nil;
    _textFieldArray = nil;
    [NOTIFICATION_CENTER removeObserver:self];
}

#pragma mark - text delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if (textField.tag < _textFieldArray.count-1) {
        UITextField *text = [_textFieldArray objectAtIndex:textField.tag+1];
        [text becomeFirstResponder];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1000) {
        NSCharacterSet *characters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSRange strRange = [string rangeOfCharacterFromSet:characters];
        if (strRange.location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (StringEqual(textView.text, @"输入个性签名")) {
        textView.text = @"";
        textView.textColor = [UIColor lightTextColor];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSRange ran = [textView.text rangeOfString:@"\n"];
    if (ran.location != NSNotFound) {
        [textView resignFirstResponder];
    }
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > PasswordMaxLength) {
        textField.text = [textField.text substringToIndex:PasswordMaxLength];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_alertViewPanel];
    if (point.x>0 && point.x<_alertViewPanel.frame.size.width && point.y>0 && point.y<_alertViewPanel.frame.size.height) {
        return NO;
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSString *str =[toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (str.length > textField.tag) {
                textField.text = [str substringToIndex:textField.tag];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        NSString *str =[toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       
        if (str.length > textField.tag) {
            textField.text = [str substringToIndex:textField.tag];
        }
    }
}
@end
