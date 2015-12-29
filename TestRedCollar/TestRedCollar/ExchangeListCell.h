//
//  ExchangeListCell.h
//  TestRedCollar
//
//  Created by dreamRen on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *theOneView;
@property (weak, nonatomic) IBOutlet UIImageView *theOneImageView;
@property (weak, nonatomic) IBOutlet UILabel *theOneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *theOneCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *theOneButton;

@property (weak, nonatomic) IBOutlet UIView *theTwoView;
@property (weak, nonatomic) IBOutlet UIImageView *theTwoImageView;
@property (weak, nonatomic) IBOutlet UILabel *theTwoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *theTwoCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *theTwoButton;

@property (weak, nonatomic) IBOutlet UIView *theThreeView;
@property (weak, nonatomic) IBOutlet UIImageView *theThreeImageView;
@property (weak, nonatomic) IBOutlet UILabel *theThreeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *theThreeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *theThreeButton;


@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)SEL onButtonClick;
@property(nonatomic,assign)SEL onInfoClick;

- (IBAction)exchangeButtonClick:(id)sender;

-(void)resetInfoIndex:(NSInteger)aIndex list:(NSMutableArray*)aList;

@end
