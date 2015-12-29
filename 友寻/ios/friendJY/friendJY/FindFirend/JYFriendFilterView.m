//
//  JYFriendFilterView.m
//  friendJY
//
//  Created by chenxiangjing on 15/5/29.
//  Copyright (c) 2015年 友寻. All rights reserved.
//

#import "JYFriendFilterView.h"
#import "JYShareData.h"
#import "JYLocationManage.h"
#import "JYBaseController.h"

/**
 *  KVO
 */
static NSString *kFrameChangeConstellationSection = @"kFrameChangeConstellationSection";
static NSString *kFrameChangeAgeSection = @"kFrameChangeAgeSection";
static NSString *kFrameChangeHeightSection = @"kFrameChangeHeightSection";
static NSString *kFrameChangeAeraSection = @"kFrameChangeAeraSection";
static NSString *kFrameChangeTagSection = @"kFrameChangeTagSection";
static NSString *kKVOContentSizeChanged = @"kKVOContentSizeChanged";


#define kSiftLabelHeight 25.0f
#define kSiftYPadding 15.0f

@implementation JYFriendFilterView
{
    CGFloat oofset;
    CGPoint selectedTagEndPoint;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setScrollEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];

        [self setDefaultData];
        [self layoutSubviewsOfMyScrollView];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdate:) name:kLocationDidFinishedNotification object:nil];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:&kKVOContentSizeChanged];
    }
    return self;
}

- (void)addObserverFoyKeyBoard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserverFoyKeyBoard{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [_sectionConstellation removeObserver:self forKeyPath:@"frame"];
    [_sectionAge removeObserver:self forKeyPath:@"frame"];
    [_sectionHeight removeObserver:self forKeyPath:@"frame"];
    [_sectionArea removeObserver:self forKeyPath:@"frame"];
    [_sectionTag removeObserver:self forKeyPath:@"frame"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"contentSize"];
    //    [_siftBtn removeObserver:self forKeyPath:@"selected"];
}

#pragma mark - Setter && Getter
- (void)setDefaultData{
    
    _siftStatusDic = [NSMutableDictionary dictionaryWithDictionary:@{@"sex":@"0",
                                                                     @"marriage":@"0",
                                                                     @"min_age":@"0",
                                                                     @"max_age":@"0",
                                                                     @"height":@"0",
                                                                     @"live_location":@"0"
                                                                     }];
    _profileOptionDic = [JYShareData sharedInstance].profile_dict;
    _showTagArr = [NSMutableArray array];
    _starSelectedArr = [NSMutableArray array];
    _selectedTidArr = [NSMutableArray array];
    _isFirstLayout = YES;
    _status = JYFriendFilterStatusClose;
    
}

- (void)setStatus:(JYFriendFilterStatus)status{
    
    _status = status;
    
    switch (status) {
        case JYFriendFilterStatusClose:
        {
            [UIView animateWithDuration:.2 animations:^{
                [self setHeight:0];
            } completion:^(BOOL finished) {
                [self setContentOffset:CGPointMake(0, 0)];
            }];
        }
            break;
        case JYFriendFilterStatusFullScreen:
        {
            NSLog(@"currentbottom --> %lf",currentBottom);
            if (currentBottom >= kScreenHeight - kStatusBarHeight - kNavigationBarHeight - 29) {
                [self setScrollEnabled:YES];
            }
            [UIView animateWithDuration:.2 animations:^{
                [self setHeight:currentBottom];
            }];
        }
            break;
        case JYFriendFilterStatusHalf:
        {
            [UIView animateWithDuration:.2 animations:^{
                [self setHeight:90];
                [self setScrollEnabled:NO];
                [self setContentOffset:CGPointMake(0, 0)];
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - LayoutSubviews
- (void)layoutSubviewsOfMyScrollView{
    //    UILabel *sexLab = [self initLabelWithText:@"性别" andOriginY:<#(CGFloat)#>]
    NSArray *titleArr = @[@"性别",@"情感状态",@"星座",@"年龄",@"身高",@"地区",@"标签"];
    currentBottom = 10;
    for (int i = 0; i < titleArr.count; i++) {
        
        UILabel *label = [self LabelWithText:titleArr[i]];
        
        switch (i) {
            case 0:{
                _sectionSex = [[UIView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, kSiftLabelHeight)];
                [_sectionSex addSubview:label];
                [_sectionSex setTag:111];
                [self addSubview:_sectionSex];
                UIButton *buttonOne = [self buttonWithFrame:CGRectMake(label.right + 28 - 5, label.top, 46, label.height) title:@"不限" action:@selector(statusChangedAction:) tag:1000];
                [buttonOne setSelected:YES];
                UIButton *buttonMale = [self buttonWithFrame:CGRectMake(buttonOne.right + 10, label.top, 31, label.height) title:@"男" action:@selector(statusChangedAction:) tag:1001];
                UIButton *buttonFemale = [self buttonWithFrame:CGRectMake(buttonMale.right + 10, label.top, 31, label.height) title:@"女" action:@selector(statusChangedAction:) tag:1002];
                
                [_sectionSex addSubview:buttonOne];
                [_sectionSex addSubview:buttonMale];
                [_sectionSex addSubview:buttonFemale];
            }
                break;
            case 1:{
                _sectionMarriageStatus = [[UIView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, kSiftLabelHeight)];
                [_sectionMarriageStatus setTag:222];
                [_sectionMarriageStatus addSubview:label];
                [self addSubview:_sectionMarriageStatus];
                UIButton *btnFree = [self buttonWithFrame:CGRectMake(label.right + 28 - 5, label.top, 46, label.height) title:@"不限" action:@selector(statusChangedAction:) tag:1000];
                [btnFree setSelected:YES];
                UIButton *btnSingle = [self buttonWithFrame:CGRectMake(btnFree.right + 10, label.top, 46, label.height) title:@"单身" action:@selector(statusChangedAction:) tag:1001];
                
                [_sectionMarriageStatus addSubview:btnFree];
                [_sectionMarriageStatus addSubview:btnSingle];
            }
                break;
            case 2:{
                _sectionConstellation = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, kSiftLabelHeight)];
                [_sectionConstellation setTag:333];
                [_sectionConstellation addSubview:label];
                [_sectionConstellation setScrollEnabled:NO];
                [self addSubview:_sectionConstellation];
                
                UIButton *btnFree = [self buttonWithFrame:CGRectMake(label.right + 28 - 5, label.top, 46, label.height) title:@"不限" action:@selector(starChangedAction:) tag:1000];
                [btnFree setSelected:YES];
                UIButton *btnUnfold = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnUnfold setFrame:CGRectMake(kScreenWidth - 15 - 13-10, label.top + (label.height - 8)/2 - 10, 13+20, 8+20)];
                [btnUnfold setTag:1324];
                [btnUnfold setImage:[UIImage imageNamed:@"find_open_detail"] forState:UIControlStateNormal];
                [btnUnfold setImage:[UIImage imageNamed:@"find_close_detail"] forState:UIControlStateSelected];
                [btnUnfold addTarget:self action:@selector(showConstellationAction:) forControlEvents:UIControlEventTouchUpInside];
                [_sectionConstellation addSubview:btnFree];
                [_sectionConstellation addSubview:btnUnfold];
                //星座
                CGFloat btnWidth = (kScreenWidth - 3*7.5 - 15 - 42)/4;
                NSMutableArray *starArr = [NSMutableArray array];
                for (int i=0; i<12; i++) {
                    NSString *key = [NSString stringWithFormat:@"%d",i+1];
                    [starArr addObject:_profileOptionDic[@"star"][key]];
                }
                
                for(int j = 0; j < 12 ; j++){
                    NSInteger row = j % 4;
                    NSInteger line = j / 4;
                    UIButton *constellationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [constellationBtn setFrame:CGRectMake(42 + (btnWidth+7.5)*row, label.bottom + 25 + (15 + 25)*line, btnWidth, 25)];
                    //                    [constellationBtn setBackgroundColor:[UIColor orangeColor]];
                    [constellationBtn setTitle:starArr[j] forState:UIControlStateNormal];
                    [constellationBtn setTag:1001+j];
                    [constellationBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
                    [constellationBtn setTitleColor:[JYHelpers setFontColorWithString:@"#ffffff"] forState:UIControlStateSelected];
                    [constellationBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                    [constellationBtn addTarget:self action:@selector(starChangedAction:) forControlEvents:UIControlEventTouchUpInside];
                    [constellationBtn setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_normal"] forState:UIControlStateNormal];
                    [constellationBtn setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_selected"] forState:UIControlStateSelected];
                    [_sectionConstellation addSubview:constellationBtn];
                }
                [_sectionConstellation setContentSize:CGSizeMake(kScreenWidth, kSiftLabelHeight + 25*4 + 10 + 2*15)];
                //                [_sectionConstellation setFrame:CGRectMake(0, bottom, kScreenWidth, kSiftLabelHeight + 25*4 + 10 + 2*15)];
                //                [sectionView setBackgroundColor:[UIColor blueColor]];
                currentBottom = _sectionConstellation.bottom - kSiftLabelHeight;
                
                [_sectionConstellation addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:&kFrameChangeConstellationSection];
            }
                break;
            case 3:{
                _sectionAge = [[UIView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, kSiftLabelHeight)];
                [_sectionAge addSubview:label];
                [_sectionAge addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:&kFrameChangeAgeSection];
                [self addSubview:_sectionAge];
                
                _minAgeTF = [self textFieldWithFrame:CGRectMake(label.right + 15, label.top, 60, 25)];
                _maxAgeTF = [self textFieldWithFrame:CGRectMake(_minAgeTF.right + 38, label.top, 60, 25)];
                [_sectionAge addSubview:_minAgeTF];
                [_sectionAge addSubview:_maxAgeTF];
                
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_minAgeTF.right+9, _minAgeTF.center.y-1, 20, 2)];
                [line.layer setBorderColor:[kTextColorGray CGColor]];
                [line.layer setBorderWidth:1];
                [_sectionAge addSubview:line];
                
            }
                break;
            case 4:{
                //                CGRectMake(0, bottom, kScreenWidth, kSiftLabelHeight + 25 + 4*25 + 15*3)]
                _sectionHeight = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, 0)];
                [_sectionHeight setTag:555];
                [_sectionHeight setScrollEnabled:NO];
                [_sectionHeight setShowsHorizontalScrollIndicator:NO];
                [_sectionHeight setShowsVerticalScrollIndicator:NO];
                [_sectionHeight addSubview:label];
                [_sectionHeight addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:&kFrameChangeHeightSection];
                [self addSubview:_sectionHeight];
                
                UIButton *btnFree = [self buttonWithFrame:CGRectMake(label.right + 28 - 5, label.top, 46, label.height) title:@"不限" action:@selector(statusChangedAction:) tag:1000];
                [btnFree setSelected:YES];
                [_sectionHeight addSubview:btnFree];
                //身高
                NSMutableArray *heightArr = [NSMutableArray array];
                for (int i = 0; i < [_profileOptionDic[@"height"] count]; i++) {
                    [heightArr addObject:[_profileOptionDic[@"height"] objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
                }
                //                NSArray *titleArr = @[@"135mm~145mm",@"145mm~155mm",@"155mm~165mm",@"165mm~175mm",@"175mm~185mm",@"185mm以上"];
                CGFloat btnWidth = (kScreenWidth - 15 - 42 - 13)/2;
                for (int j = 0; j < heightArr.count; j ++) {
                    NSInteger row = j % 2;
                    NSInteger line = j / 2;
                    UIButton *heightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [heightBtn setFrame:CGRectMake(42 + (btnWidth+13)*row, label.bottom + 25 + (15 + 25)*line, btnWidth, 25)];
                    //                    [constellationBtn setBackgroundColor:[UIColor orangeColor]];
                    [heightBtn setTitle:heightArr[j] forState:UIControlStateNormal];
                    [heightBtn setTag:1001+j];
                    [heightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
                    [heightBtn setTitleColor:[JYHelpers setFontColorWithString:@"#ffffff"] forState:UIControlStateSelected];
                    [heightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                    [heightBtn addTarget:self action:@selector(statusChangedAction:) forControlEvents:UIControlEventTouchUpInside];
                    [heightBtn setBackgroundImage:[[UIImage imageNamed:@"find_constellation_btn_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal];
                    [heightBtn setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_selected"] forState:UIControlStateSelected];
                    [_sectionHeight addSubview:heightBtn];
                }
                [_sectionHeight setContentSize:CGSizeMake(kScreenWidth, kSiftLabelHeight + 25 + 4*25 + 15*3)];
                currentBottom = _sectionHeight.bottom - kSiftLabelHeight - kSiftYPadding;
            }
                break;
            case 5:{
                //                 + 25*5 + 15*3)
                _sectionArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, kSiftLabelHeight)];
                [_sectionArea setTag:666];
                [_sectionArea setScrollEnabled:NO];
                [_sectionArea addSubview:label];
                [_sectionArea addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:&kFrameChangeAeraSection];
                [self addSubview:_sectionArea];
                
                UIButton *btnFree = [self buttonWithFrame:CGRectMake(label.right + 28 - 5, label.top, 46, label.height) title:@"不限" action:@selector(areaChangedAction:) tag:1000];
                [btnFree setSelected:YES];
                
                //展开
                UIButton *btnUnfold = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnUnfold setFrame:CGRectMake(kScreenWidth - 15 - 13 - 10, label.top + (label.height - 8)/2 -10, 13+20, 8+20)];
                [btnUnfold setTag:4999];
                [btnUnfold setImage:[UIImage imageNamed:@"find_open_detail"] forState:UIControlStateNormal];
                [btnUnfold setImage:[UIImage imageNamed:@"find_close_detail"] forState:UIControlStateSelected];
                [btnUnfold addTarget:self action:@selector(showAreaAction:) forControlEvents:UIControlEventTouchUpInside];
                [_sectionArea addSubview:btnFree];
                [_sectionArea addSubview:btnUnfold];
                
                //定位城市
                CGFloat btnWidth = (kScreenWidth - 3*7.5 - 15 - 42)/4;
                
                _btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
                [_btnLocation setImage:[UIImage imageNamed:@"find_location"] forState:UIControlStateNormal];
                [_btnLocation setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, btnWidth - 20)];
                [_btnLocation.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [_btnLocation setFrame:CGRectMake(42, label.bottom + 20, btnWidth + 7.5, 25)];
                [_btnLocation setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
                [_btnLocation setTitleColor:[JYHelpers setFontColorWithString:@"#ffffff"] forState:UIControlStateSelected];
                [_btnLocation setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_normal"] forState:UIControlStateNormal];
                [_btnLocation setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_selected"] forState:UIControlStateSelected];
                //                [_btnLocation addTarget:self action:@selector(locationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [_btnLocation setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentProvince"] forState:UIControlStateNormal];
                //                [_btnLocation setTitle:@"南京" forState:UIControlStateNormal];
                [_sectionArea addSubview:_btnLocation];
                
                UIButton *reLocation = [UIButton buttonWithType:UIButtonTypeCustom];
                [reLocation.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [reLocation setFrame:CGRectMake(_btnLocation.right + 20, _btnLocation.top, 60, 25)];
                [reLocation setTitle:@"重新定位" forState:UIControlStateNormal];
                [reLocation addTarget:self action:@selector(reloactionArea) forControlEvents:UIControlEventTouchUpInside];
                [reLocation setTitleColor:[JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
                [_sectionArea addSubview:reLocation];
                
                //城市选择
                NSArray *provinceArr = [[JYShareData sharedInstance] province_array];
                //                NSLog(@"%@",dic)
                //                NSArray *titleArr = @[@"上海",@"广州",@"贵州",@"湖南",@"四川",@"重庆",@"福建",@"西藏",@"云南",@"陕西"];
                for(int j = 0; j < provinceArr.count ; j++){
                    NSInteger row = j % 4;
                    NSInteger line = j / 4;
                    UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [areaBtn setFrame:CGRectMake(42 + (btnWidth+7.5)*row, _btnLocation.bottom + 15 + (15 + 25)*line, btnWidth, 25)];
                    //                    [constellationBtn setBackgroundColor:[UIColor orangeColor]];
                    [areaBtn setTitle:provinceArr[j] forState:UIControlStateNormal];
                    [areaBtn setTag:1001+j];
                    [areaBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
                    [areaBtn setTitleColor:[JYHelpers setFontColorWithString:@"#ffffff"] forState:UIControlStateSelected];
                    [areaBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                    [areaBtn addTarget:self action:@selector(areaChangedAction:) forControlEvents:UIControlEventTouchUpInside];
                    [areaBtn setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_normal"] forState:UIControlStateNormal];
                    [areaBtn setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_selected"] forState:UIControlStateSelected];
                    [_sectionArea addSubview:areaBtn];
                }
                [_sectionArea setContentSize:CGSizeMake(kScreenWidth, kSiftLabelHeight + 25*11 + 15*9)];
            }
                break;
            case 6:{
                _sectionTag = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, kSiftLabelHeight)];
                [_sectionTag addSubview:label];
                [_sectionTag setTag:777];
                [_sectionTag addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:&kFrameChangeTagSection];
                [_sectionTag setScrollEnabled:NO];
                [self addSubview:_sectionTag];
                
                UIButton *btnFree = [self buttonWithFrame:CGRectMake(label.right + 28 - 5, label.top, 46, label.height) title:@"不限" action:@selector(tagChangedAction:) tag:1000];
                [btnFree setSelected:YES];
                
                [_sectionTag addSubview:btnFree];
                selectedTagEndPoint = CGPointMake(btnFree.right, btnFree.bottom);
                //展开
                UIButton *btnUnfold = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnUnfold setFrame:CGRectMake(kScreenWidth - 15 - 13 -10, label.top + (label.height - 8)/2 -10, 13+20, 8+20)];
                [btnUnfold setTag:5999];
                [btnUnfold setImage:[UIImage imageNamed:@"find_open_detail"] forState:UIControlStateNormal];
                [btnUnfold setImage:[UIImage imageNamed:@"find_close_detail"] forState:UIControlStateSelected];
                [btnUnfold addTarget:self action:@selector(showTagAction:) forControlEvents:UIControlEventTouchUpInside];
                [_sectionTag addSubview:btnUnfold];
                
                //                _tagArr = [NSMutableArray arrayWithObjects:@"男神",@"宅",@"怪大叔",@"神经病",@"猥琐大叔",nil];
                UIView *tagsBgView = [[UIView alloc] init];
                [tagsBgView setBackgroundColor:[UIColor clearColor]];
                [tagsBgView setTag:778];
//                label.bottom + 25
                CGFloat lastBottom = 0;
                CGFloat lastRight = 32;
                for(int j = 0; j < 6; j++){
                    CGFloat width = 50;
                    if (lastRight+width > kScreenWidth) {
                        lastRight = 32;
                        lastBottom = lastBottom +15 + 25;
                    }
                    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [tagBtn setFrame:CGRectMake(lastRight+10, lastBottom+15, width, 25)];
                    //                    [constellationBtn setBackgroundColor:[UIColor orangeColor]];
                    //                    [tagBtn setTitle:_tagArr[j] forState:UIControlStateNormal];
                    [tagBtn setTag:1001+j];
                    [tagBtn setTitleColor:[JYHelpers setFontColorWithString:@"#2695ff"] forState:UIControlStateNormal];
                    [tagBtn setTitleColor:[JYHelpers setFontColorWithString:@"#ffffff"] forState:UIControlStateSelected];
                    [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                    [tagBtn addTarget:self action:@selector(tagChangedAction:) forControlEvents:UIControlEventTouchUpInside];
                    [tagBtn setBackgroundImage:[[UIImage imageNamed:@"find_constellation_btn_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forState:UIControlStateNormal];
                    [tagBtn setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_selected"] forState:UIControlStateSelected];
                    [tagsBgView addSubview:tagBtn];
                    lastRight += (width + 10);
                }
                if (lastRight + 60 +33/2 > kScreenWidth) {
                    lastBottom = lastBottom + 25 + 15;
                }
                UIButton *change = [UIButton buttonWithType:UIButtonTypeCustom];
                [change setFrame:CGRectMake(kScreenWidth - 33/2 - 60, lastBottom+25+15, 60, 25)];
                [change setBackgroundImage:[UIImage imageNamed:@"find_constellation_btn_selected"] forState:UIControlStateNormal];
                [change addTarget:self action:@selector(changeTag:) forControlEvents:UIControlEventTouchUpInside];
                [change setTitle:@"换一批" forState:UIControlStateNormal];
                [change.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
                [change setTag:6789];
                [tagsBgView addSubview:change];
                [tagsBgView setFrame:CGRectMake(0, label.bottom + kSiftYPadding, kScreenWidth, change.bottom)];
                [_sectionTag addSubview:tagsBgView];
                
                [self loadTags];
            }
                break;
            default:
                break;
        }
        currentBottom = currentBottom + kSiftYPadding + kSiftLabelHeight;
    }
    _sectionConfirm = [[UIView alloc] initWithFrame:CGRectMake(0, currentBottom, kScreenWidth, 44)];
    [self addSubview:_sectionConfirm];
    
    UIButton *resetBtn = [self buttonWithFrame:CGRectMake(0, 0, kScreenWidth/2, 44) title:@"重置" action:@selector(resetBtnAction) tag:1000];
    [_sectionConfirm addSubview:resetBtn];
    
    UIButton *confirmBtn = [self buttonWithFrame:CGRectMake(resetBtn.right, 0, kScreenWidth/2, 44) title:@"确认" action:@selector(confirmBtnAction) tag:1001];
    [confirmBtn setSelected:YES];
    [_sectionConfirm addSubview:confirmBtn];
    currentBottom += 44;
    NSLog(@"endcurrentbottom --> %lf",currentBottom);
    [self setContentSize:CGSizeMake(kScreenWidth, currentBottom)];
    
}
//创建label
- (UILabel *)LabelWithText:(NSString*)text{
    
    UILabel *sexLab = [[UILabel alloc] initWithFrame:CGRectMake(kSiftYPadding, 0, 60, kSiftLabelHeight)];
    [sexLab setFont:[UIFont systemFontOfSize:15.0f]];
    [sexLab setTextColor:[JYHelpers setFontColorWithString:@"#303030"]];
    [sexLab setTextAlignment:NSTextAlignmentRight];
    [sexLab setText:text];
    
    return sexLab;
}
//创建btn选项
- (UIButton*)buttonWithFrame:(CGRect)frame title:(NSString*)title action:(SEL)action tag:(NSInteger)tag{
    
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOne setFrame:frame];
    [btnOne setTag:tag];
    [btnOne setAdjustsImageWhenHighlighted:NO];
    [btnOne setTitle:title forState:UIControlStateNormal];
    [btnOne setTitleColor:[JYHelpers setFontColorWithString:@"#848484"] forState:UIControlStateNormal];
    [btnOne setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnOne.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [btnOne addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *backImg = [UIImage imageNamed:@"find_contact_btnBg"];
    backImg = [backImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [btnOne setBackgroundImage:backImg forState:UIControlStateSelected];
    return btnOne;
}
//创建textField
- (UITextField*)textFieldWithFrame:(CGRect)rect{
    
    UILabel *tfRightView00 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 25)];
    [tfRightView00 setText:@"岁"];
    [tfRightView00 setFont:[UIFont systemFontOfSize:15.0f]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    [textField setRightView:tfRightView00];
    //    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    [textField setRightViewMode:UITextFieldViewModeAlways];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    [textField setBackground:[UIImage imageNamed:@"find_constellation_btn_normal"]];
    [textField setTextAlignment:NSTextAlignmentRight];
    [textField setFont:[UIFont systemFontOfSize:15.0f]];
    [textField setClearsOnBeginEditing:YES];
    [textField setDelegate:self];
    
    return textField;
    
}

//重新加载 身高选项
- (void)relayoutSectionHeight{
    
//    CGFloat height = self.contentSize.height;
    if (_isShowHeight) {
        //        [self setScrollEnabled:YES];
//        [self setContentSize:CGSizeMake(kScreenWidth, height+kSiftLabelHeight + 25 + 4*25 + 15*3+kSiftYPadding)];
        [UIView animateWithDuration:.2 animations:^{
            [_sectionHeight setFrame:CGRectMake(0, _sectionAge.bottom+kSiftYPadding, kScreenWidth, kSiftLabelHeight + 25 + 4*25 + 15*3)];
        }];
    }else{
        
        NSInteger lastSelect = [JYHelpers integerValueOfAString:_siftStatusDic[@"height"]];
        if (lastSelect != 0) {
            UIButton *lastSelectBtn = (UIButton*)[_sectionHeight viewWithTag:1000+lastSelect];
            UIButton *btnFree = (UIButton*)[_sectionHeight viewWithTag:1000];
            [lastSelectBtn setSelected:NO];
            [btnFree setSelected:YES];
            [_siftStatusDic setObject:@"0" forKey:@"height"];
        }
        
//        [self setContentSize:CGSizeMake(kScreenWidth, height-kSiftLabelHeight - 25 - 4*25 - 15*3 - kSiftYPadding)];
        [UIView animateWithDuration:.2 animations:^{
            [_sectionHeight setFrame:CGRectMake(0, _sectionAge.bottom, kScreenWidth, 0)];
        }];
    }
}
- (void)relayoutSectionTag{
    
    [_showTagArr removeAllObjects];
    if (_tagArr.count >= 6) {
        //随机取6个tag
        while (_showTagArr.count < 6) {
            NSInteger index = arc4random()%_tagArr.count;
            //        NSLog(@"%ld",index)
            NSDictionary *dic = [_tagArr objectAtIndex:index];
            if (![_showTagArr containsObject:dic]) {
                [_showTagArr addObject:dic];
            }
        }
    }else{
        [_showTagArr addObjectsFromArray:_tagArr];
    }
    
    //    CGFloat height = _sectionTag.contentSize.height;
    UIView *selectTagBgView = [_sectionTag viewWithTag:778];
    //    kSiftLabelHeight + 10
    CGFloat lastBottom = -15;
    CGFloat lastRight = 32;
    for(int j = 0; j < _showTagArr.count ; j++){
        CGFloat width = [JYHelpers getTextWidthAndHeight:_showTagArr[j][@"title"] fontSize:15].width;
        if (lastRight+width+10+15 > kScreenWidth) {
            lastRight = 32;
            lastBottom = lastBottom + 15 + 25;
        }
        UIButton *tagBtn = (UIButton*)[_sectionTag viewWithTag:1001+j];
        [tagBtn setFrame:CGRectMake(lastRight+10, lastBottom+15, width, 25)];
        [tagBtn setTitle:_showTagArr[j][@"title"] forState:UIControlStateNormal];
        for (NSDictionary *dic in _selectedTidArr) {
            if ([JYHelpers integerValueOfAString:[dic objectForKey:@"tid"]]  == [JYHelpers integerValueOfAString:_showTagArr[j][@"tid"]]) {
                [tagBtn setSelected:YES];
            }
        }
        
        lastRight += (width + 10);
    }
    //    if (lastRight + 60 +33/2 > kScreenWidth) {
    lastBottom = lastBottom + 25 + 15;
    //    }
    UIButton *change = (UIButton*)[selectTagBgView viewWithTag:6789];
    [change setFrame:CGRectMake(kScreenWidth - 33/2 - 60, lastBottom+15, 60, 25)];
    
    [selectTagBgView setFrame:CGRectMake(0, selectTagBgView.top, kScreenWidth, change.bottom)];
    [_sectionTag setContentSize:CGSizeMake(kScreenWidth, selectTagBgView.bottom+15)];
    
    if (!_isFirstLayout) {
        [self setContentSize:CGSizeMake(kScreenWidth, _sectionArea.bottom+kSiftYPadding+selectTagBgView.bottom+kSiftYPadding+44)];
        [_sectionTag setFrame:CGRectMake(0, _sectionArea.bottom+kSiftYPadding, kScreenWidth, selectTagBgView.bottom)];
    }
    
    _isFirstLayout = NO;
    
}

- (void)removeSeletedTagButton{
    NSLog(@"----------\n删除所有标签\n--------------")
    for (NSDictionary *tagInfoDic in _selectedTidArr) {
        if ([tagInfoDic isKindOfClass:[NSDictionary class]]) {
            UIView *view = [_sectionTag viewWithTag:[JYHelpers integerValueOfAString:[tagInfoDic objectForKey:@"tid"]]];
            if (view) {
                NSLog(@"--------------\n删除的标签 tid == %ld",view.tag);
                [view removeFromSuperview];
            }
        }
    }
    UIView *tagBgView = [_sectionTag viewWithTag:778];
    [tagBgView setOrigin:CGPointMake(0, selectedTagEndPoint.y+kSiftYPadding)];
    [_sectionTag setFrame:CGRectMake(_sectionTag.left, _sectionTag.top, _sectionTag.width, tagBgView.bottom)];
    
}
- (void)addSelectedTagButton{
    
    NSLog(@"----------\n重新添加所有标签\n--------------")

    CGPoint startPoint = selectedTagEndPoint;
    for (NSDictionary *tagInfoDic in _selectedTidArr) {
        
        if ([tagInfoDic isKindOfClass:[NSDictionary class]]) {
            CGFloat width = [JYHelpers getTextWidthAndHeight:[tagInfoDic objectForKey:@"title"] fontSize:15].width;
           
            if (startPoint.y == selectedTagEndPoint.y) {//第一行 因为有更多按钮不能被挡住
                if (width + startPoint.x + 10 >= kScreenWidth - 15 - 13 -10) {
                    startPoint = CGPointMake(32, startPoint.y + kSiftLabelHeight + 10);
                }
            }else{
                if (width + startPoint.x + 10 >= _sectionTag.width - 15) {
                    startPoint = CGPointMake(32, startPoint.y + kSiftLabelHeight + 10);
                }
            }
            
            UIButton *button = [self buttonWithFrame:CGRectMake(startPoint.x + 10, startPoint.y - kSiftLabelHeight, width, kSiftLabelHeight) title:[tagInfoDic objectForKey:@"title"] action:@selector(selectedTagButtonClicked:) tag:[JYHelpers integerValueOfAString:[tagInfoDic objectForKey:@"tid"]]];
            [button setSelected:YES];
            NSLog(@"-------------------\n添加的标签 tid == %ld",(long)button.tag);
//            [button setAlpha:0];
            [_sectionTag addSubview:button];
            
//            [UIView animateWithDuration:.2 animations:^{
//            [button setAlpha:1];
//            }];
            startPoint = CGPointMake(button.right, button.bottom);
        }
  
    }
    
    UIView *tagBgView = [_sectionTag viewWithTag:778];
    [tagBgView setOrigin:CGPointMake(0, startPoint.y+kSiftYPadding)];
    [_sectionTag setFrame:CGRectMake(_sectionTag.left, _sectionTag.top, _sectionTag.width, tagBgView.bottom)];
   
}

#pragma mark - request
//获取tag
- (void)loadTags{
    NSDictionary *paraDic = @{@"mod":@"tags",
                              @"func":@"max_tags"
                              };
    [JYHttpServeice requestWithParameters:paraDic postDict:nil httpMethod:@"POST" success:^(id responseObject) {
        NSInteger iRetcode = [[responseObject objectForKey:@"retcode"] integerValue];
        if (iRetcode == 1) {
            //do any addtion here...
            _tagArr = [responseObject objectForKey:@"data"];
            [self relayoutSectionTag];
        }
    } failure:^(id error) {
        [[JYAppDelegate sharedAppDelegate] showTip:kNetworkConnectionFailure];
    }];
}


#pragma mark - click handler
- (void)statusChangedAction:(UIButton*)sender{
    [self bgClicked];
    NSInteger index = sender.superview.tag;
    UIView *superView = sender.superview;
    NSString *key = @"";
    switch (index) {
        case 111:
            key = @"sex";
            break;
        case 222:
            key = @"marriage";
            break;
        case 333:
            key = @"star";
            break;
        case 555:
            key = @"height";
            break;
        case 666:
            key = @"live_location";
            break;
        case 777:
            key = @"tag";
        default:
            break;
    }
    NSInteger tag = sender.tag - 1000;
    
    NSInteger lastSelect = [JYHelpers integerValueOfAString:_siftStatusDic[key]];
    NSLog(@"tag ->%ld,lastTag ->%ld",(long)tag,(long)lastSelect)
    UIButton *lastSelectBtn = (UIButton*)[superView viewWithTag:lastSelect+1000];
    if (tag != lastSelect) {

        if (index == 222 && tag == 1) {
            //            单身
            _isShowHeight = YES;
            [self relayoutSectionHeight];
        }else if (index == 222 && tag == 0){
            _isShowHeight = NO;
            [self relayoutSectionHeight];
        }
        [lastSelectBtn setSelected:NO];
        [_siftStatusDic setObject:[NSString stringWithFormat:@"%ld",(long)tag] forKey:key];
        [sender setSelected:YES];
    }
    
    if (_status == JYFriendFilterStatusHalf) {
        [self confirmBtnAction];
    }
    
}
//标签
- (void)tagChangedAction:(UIButton*)sender{
    [self bgClicked];
    NSInteger index = sender.tag - 1000;
    if (index == 0) {
        //        if (sender.selected) {
        //            return;
        //        }
        [sender setSelected:YES];
        
        for (NSDictionary *selectInfo in _selectedTidArr) {
            NSInteger index = 0;
            for (int i = 0; i < _showTagArr.count; i ++) {
                NSDictionary *dic = [_showTagArr objectAtIndex:i];
                if ([dic isEqual:selectInfo]) {
                    index = i+1;
                    break;
                }
            }
            if (index != 0) {
                UIButton *button = (UIButton*)[_sectionTag viewWithTag:index+1000];
                [button setSelected:NO];
            }
        }

        [self removeSeletedTagButton];
        [_selectedTidArr removeAllObjects];
        
        CGFloat height = self.contentSize.height;
        UIButton *btnUnfold = (UIButton*)[_sectionTag viewWithTag:5999];
        if (btnUnfold.selected) {
            [btnUnfold setSelected:NO];
            UIButton *btn = (UIButton*)[_sectionTag viewWithTag:6789];
            [self setContentSize:CGSizeMake(kScreenWidth, height - btn.bottom + kSiftLabelHeight)];
            [_sectionTag setFrame:CGRectMake(0, _sectionArea.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
        }else{
            [_sectionTag setFrame:CGRectMake(_sectionTag.left, _sectionTag.top, _sectionTag.width, kSiftLabelHeight)];
        }
        
    }else{
        
        UIButton *btnFree = (UIButton*)[_sectionTag viewWithTag:1000];
        if (btnFree.selected) {
            [btnFree setSelected:NO];
        }
        
        if (sender.selected) {
            [sender setSelected:NO];
//            [_tagSelectedArr removeObject:[NSString stringWithFormat:@"%ld",(long)index]];
            [self removeSeletedTagButton];
            
            NSDictionary *dic = [_showTagArr objectAtIndex:index-1];
            for (NSDictionary *tagInfo in _selectedTidArr) {
                if ([tagInfo isEqual:dic]) {
                    [_selectedTidArr removeObject:tagInfo];
                    break;
                }
            }
            [self addSelectedTagButton];
            
            if (_selectedTidArr.count == 0) {
                [btnFree setSelected:YES];
            }
        }else{
            if (_selectedTidArr.count < 5) {
                [sender setSelected:YES];
//                [_tagSelectedArr addObject:[NSString stringWithFormat:@"%ld",(long)index]];
                [self removeSeletedTagButton];
                [_selectedTidArr addObject:[_showTagArr objectAtIndex:index-1]];
                [self addSelectedTagButton];
            }else{
                [[JYAppDelegate sharedAppDelegate] showTip:@"您最多选择5个标签"];
            }
           
        }
    }
    
}
//星座
- (void)starChangedAction:(UIButton*)sender{
    [self bgClicked];
    NSInteger index = sender.tag - 1000;
    if (index == 0) {
        //        if (sender.selected) {
        //            return;
        //        }
        [sender setSelected:YES];
        for (NSString *tagStr in _starSelectedArr) {
            UIButton *button = (UIButton*)[_sectionConstellation viewWithTag:[tagStr integerValue]+1000];
            [button setSelected:NO];
        }
        [_starSelectedArr removeAllObjects];
        UIButton *btnUnfold = (UIButton*)[_sectionConstellation viewWithTag:1324];
        if (btnUnfold.selected) {
            [btnUnfold setSelected:NO];
            CGFloat height = self.contentSize.height;
            //        NSLog(@"关闭 %f",height);
            [self setContentSize:CGSizeMake(kScreenWidth, height - 25*4 - 10 - 2*15)];
            [_sectionConstellation setFrame:CGRectMake(0, _sectionMarriageStatus.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
        }
    }else{
        
        UIButton *btnFree = (UIButton*)[_sectionConstellation viewWithTag:1000];
        if (btnFree.selected) {
            [btnFree setSelected:NO];
        }
        if (sender.selected) {
            [sender setSelected:NO];
            [_starSelectedArr removeObject:[NSString stringWithFormat:@"%ld",(long)index]];
            if (_starSelectedArr.count == 0) {
                [btnFree setSelected:YES];
            }
        }else{
            [sender setSelected:YES];
            [_starSelectedArr addObject:[NSString stringWithFormat:@"%ld",(long)index]];
        }
    }
    
}
//地区
- (void)areaChangedAction:(UIButton*)sender{
    [self bgClicked];
    
    NSInteger tag = sender.tag - 1000;
    NSInteger lastSelect = [JYHelpers integerValueOfAString:_siftStatusDic[@"live_location"]];
    NSLog(@"tag ->%ld,lastTag ->%ld",(long)tag,(long)lastSelect)
    UIButton *lastSelectBtn = (UIButton*)[_sectionArea viewWithTag:lastSelect+1000];
    [sender setSelected:YES];

    if (tag != lastSelect) {
        
        [lastSelectBtn setSelected:NO];
        [_siftStatusDic setObject:[NSString stringWithFormat:@"%ld",(long)tag] forKey:@"live_location"];
    }

    if (tag == 0) {

        UIButton *btnUnfold = (UIButton*)[_sectionArea viewWithTag:4999];
        if (btnUnfold.selected) {
            [btnUnfold setSelected:NO];

            [_sectionArea setFrame:CGRectMake(0, _sectionArea.top, kScreenWidth, kSiftLabelHeight)];
        }
    }
    
}
//展开或关闭星座
- (void)showConstellationAction:(UIButton*)sender{
    [self bgClicked];
    if (sender.selected) {
//        CGFloat height = self.contentSize.height;
        //        NSLog(@"关闭 %f",height);
        [UIView animateWithDuration:.2 animations:^{
            
//            [self setContentSize:CGSizeMake(kScreenWidth, height - 25*4 - 10 - 2*15)];
            [_sectionConstellation setFrame:CGRectMake(0, _sectionMarriageStatus.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
        }];
    }else{
//        CGFloat height = self.contentSize.height;
        //        NSLog(@"展开 %f",height);
//        [self setContentSize:CGSizeMake(kScreenWidth, height + 25*4 + 10 + 2*15)];
        [UIView animateWithDuration:.2 animations:^{
            [_sectionConstellation setFrame:CGRectMake(0, _sectionMarriageStatus.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight + 25*4 + 10 + 2*15)];
        }];
    }
    sender.selected = !sender.selected;
}

//展开地区选择
- (void)showAreaAction:(UIButton*)sender{
    [self bgClicked];
//    CGFloat height = self.contentSize.height;
    if (sender.selected) {
        //        NSLog(@"关闭 %f",height);
//        [self setContentSize:CGSizeMake(kScreenWidth, height - 25*11 - 9*15)];
        if (_isShowHeight) {
            [UIView animateWithDuration:.2 animations:^{
                [_sectionArea setFrame:CGRectMake(0, _sectionHeight.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
            }];
        }else{
            [UIView animateWithDuration:.2 animations:^{
                [_sectionArea setFrame:CGRectMake(0, _sectionAge.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
            }];
        }
    }else{
        //        NSLog(@"展开 %f",height);
//        [self setContentSize:CGSizeMake(kScreenWidth, height + 25*11 + 9*15)];
        if (_isShowHeight) {
            [UIView animateWithDuration:.2 animations:^{
                [_sectionArea setFrame:CGRectMake(0, _sectionHeight.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight + 25*11 + 15*9)];
            }];
        }else{
            [UIView animateWithDuration:.2 animations:^{
                [_sectionArea setFrame:CGRectMake(0, _sectionAge.bottom + kSiftYPadding, kScreenWidth, kSiftLabelHeight + 25*11 + 15*9)];
            }];
        }
    }
    sender.selected = !sender.selected;
}


//展开标签选择
- (void)showTagAction:(UIButton*)sender{
    [self bgClicked];
    UIView *tagBgView = [_sectionTag viewWithTag:778];
    
    if (sender.selected) {
        //        NSLog(@"关闭 %f",height);
        
        [UIView animateWithDuration:.2 animations:^{
            [_sectionTag setFrame:CGRectMake(0, _sectionArea.bottom + kSiftYPadding, kScreenWidth, tagBgView.top-kSiftYPadding)];
        }];
    }else{
        //        NSLog(@"展开 %f",height);
        [UIView animateWithDuration:.2 animations:^{
            [_sectionTag setFrame:CGRectMake(0, _sectionArea.bottom + kSiftYPadding, kScreenWidth,tagBgView.bottom)];
        }];
    }
    sender.selected = !sender.selected;
}
//重置点击事件
- (void)resetBtnAction{
    [self bgClicked];
    [self resetOptionInView:_sectionSex andStatusDicWithKey:@"sex"];
    [self resetOptionInView:_sectionMarriageStatus andStatusDicWithKey:@"marriage"];
    [self resetOptionInView:_sectionHeight andStatusDicWithKey:@"height"];
    [self resetOptionInView:_sectionArea andStatusDicWithKey:@"live_location"];
    [self resetOptionInView:_sectionConstellation isStar:YES];
    [self resetOptionInView:_sectionTag isStar:NO];
    _isShowHeight = NO;
    [self relayoutSectionHeight];
    [_maxAgeTF setText:@""];
    [_minAgeTF setText:@""];
    
//    [self setContentSize:CGSizeMake(kScreenWidth, bottom)];
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)resetOptionInView:(UIView*)sectionView andStatusDicWithKey:(NSString*)key{
    NSInteger index = 1000+[[_siftStatusDic objectForKey:key] integerValue];
    if (index == 1000 && sectionView != _sectionArea) {
        return;
    }
    UIButton *lastSexBtn = (UIButton*)[sectionView viewWithTag:index];
    UIButton *sexFreeBtn = (UIButton*)[sectionView viewWithTag:1000];
    
    if (sectionView == _sectionArea) {
        [self areaChangedAction:sexFreeBtn];
    }else{
        [sexFreeBtn setSelected:YES];
        [lastSexBtn setSelected:NO];
    }
    [_siftStatusDic setObject:@"0" forKey:key];
}

- (void)resetOptionInView:(UIView*)sectionView isStar:(BOOL)isStar{
    if (isStar) {
        UIButton *btnFree = (UIButton*)[_sectionConstellation viewWithTag:1000];
        if (btnFree) {
            [self starChangedAction:btnFree];
        }
    }else{
        UIButton *btnFree = (UIButton*)[_sectionTag viewWithTag:1000];
        [self tagChangedAction:btnFree];
    }
}

- (void)bgClicked{
    if ([_maxAgeTF isFirstResponder]) {
        [_maxAgeTF resignFirstResponder];
    }else if ([_minAgeTF isFirstResponder]){
        [_minAgeTF resignFirstResponder];
    }
}
//重新定位
- (void)reloactionArea{
    [((JYBaseController*)self.filterDelegate) showProgressHUD:@"定位中..." toView:nil];
    [[JYLocationManage shareInstance] startLocationManager];
}

//换一批标签
- (void)changeTag:(UIButton*)sender{

    for (NSDictionary *selectInfo in _selectedTidArr) {
        NSInteger index = 0;
        for (int i = 0; i < _showTagArr.count; i ++) {
            NSDictionary *dic = [_showTagArr objectAtIndex:i];
            if ([dic isEqual:selectInfo]) {
                index = i+1;
                break;
            }
        }
        if (index != 0) {
            UIButton *button = (UIButton*)[_sectionTag viewWithTag:index+1000];
            [button setSelected:NO];
        }
    }
    if (_selectedTidArr.count == 0) {
        UIButton *btnFree = (UIButton*)[_sectionTag viewWithTag:1000];
        [btnFree setSelected:YES];
    }

    [self relayoutSectionTag];
}
//确定点击事件
- (void)confirmBtnAction{
    [self bgClicked];
    if ([_maxAgeTF.text integerValue] < [_minAgeTF.text integerValue]) {
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入有效的年龄区间"];
        return;
    }
    NSMutableString *jsonStr = [NSMutableString stringWithString:@"{"];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    //      性别编码
    NSInteger sexFlag = [[_siftStatusDic objectForKey:@"sex"] integerValue];
    switch (sexFlag) {
        case 1:
            [mutDic setObject:@"1" forKey:@"sex"];
            [jsonStr appendString:[NSString stringWithFormat:@"\"sex\":\"1\","]];
            break;
        case 2:
            [mutDic setObject:@"0" forKey:@"sex"];
            [jsonStr appendString:[NSString stringWithFormat:@"\"sex\":\"0\","]];
            break;
        default:
            break;
    }
    //      情感状态编码
    if ([[_siftStatusDic objectForKey:@"marriage"] isEqualToString:@"1"]) {
        [mutDic setObject:@"1" forKey:@"marriage"];
        [jsonStr appendString:[NSString stringWithFormat:@"\"marriage\":\"1\","]];
    }
    
    //      身高编码
    if (![[_siftStatusDic objectForKey:@"height"] isEqualToString:@"0"]) {
        NSString *heightKey = [NSString stringWithFormat:@"%ld",(long)[_siftStatusDic[@"height"] integerValue] - 1];
        [mutDic setObject:heightKey forKey:@"height"];
        [jsonStr appendString:[NSString stringWithFormat:@"\"height\":\"%@\",",heightKey]];
    }
    
    //      地址编码
    if (![[_siftStatusDic objectForKey:@"live_location"] isEqualToString:@"0"]) {
        NSString *provinceName = [[[JYShareData sharedInstance] province_array] objectAtIndex:[[_siftStatusDic objectForKey:@"live_location"] integerValue]-1];
        NSArray *provinceCodeKeyArr = [JYShareData sharedInstance].province_code_dict.allKeys;
        for (NSString *key in provinceCodeKeyArr) {
            if ([[[JYShareData sharedInstance].province_code_dict objectForKey:key] isEqualToString:provinceName]) {
                provinceName = key;
                break;
            }
        }
        [mutDic setObject:provinceName forKey:@"live_location"];
        [jsonStr appendString:[NSString stringWithFormat:@"\"live_location\":\"%@\",",provinceName]];
    }
    //     标签编码
    //http://c.friendly.dev/cmiajax/?mod=friends&func=friends_get_fsfriends&uid=1001850&is_reg=1&start=1&condition_tags=16750&nums=30
    
    
    //     年龄编码
    if (_minAgeTF.text.length > 0 && _maxAgeTF.text.length > 0) {
        
        [jsonStr appendString:[NSString stringWithFormat:@"\"max_age\":\"%@\",",_maxAgeTF.text]];
        [jsonStr appendString:[NSString stringWithFormat:@"\"min_age\":\"%@\",",_minAgeTF.text]];
    }
    //http://c.friendly.dev/cmiajax/?mod=friends&func=friends_get_fsfriends&uid=2086550&is_reg=1&condition={"min_age":1,"max_age":99,"sex":"1","height":4,"marriage":"1","live_location":"13"}&start=1&condition_tags=16750&condition_star=2,4,6&nums=300
    NSString *str = @"";
    if (jsonStr.length > 2) {
        str = [jsonStr substringToIndex:jsonStr.length-1];
        str = [str stringByAppendingString:@"}"];
        
    }
    NSLog(@"%@",str)
    
    [self filterViewDidFinishFilterWithStr:str];
}

/**
 *  已选择标签点击时删除标签
 *
 *  @param button 点击的标签
 */
- (void)selectedTagButtonClicked:(UIButton*)button{
    [self removeSeletedTagButton];
    for (NSDictionary *tagInfoDic in _selectedTidArr) {
        if ([JYHelpers integerValueOfAString:[tagInfoDic objectForKey:@"tid"]] == button.tag) {
            [_selectedTidArr removeObject:tagInfoDic];
            break;
        }
    }
    [self addSelectedTagButton];
    
  
    NSInteger index = 0;
    for (int i = 0; i < _showTagArr.count; i ++) {
        NSDictionary *dic = [_showTagArr objectAtIndex:i];
        if ([JYHelpers integerValueOfAString:[dic objectForKey:@"tid"]] == button.tag) {
            index = i+1;
            break;
        }
    }
    if (index != 0) {
        UIButton *button = (UIButton*)[_sectionTag viewWithTag:index+1000];
        [button setSelected:NO];
    }
    
    if (_selectedTidArr.count == 0) {
        UIButton *btnFree = (UIButton*)[_sectionTag viewWithTag:1000];
        [btnFree setSelected:YES];
    }
}
#pragma mark - Notification
//
- (void)locationUpdate:(NSNotification*)noti{
    [((JYBaseController*)self.filterDelegate) dismissProgressHUDtoView:nil];
    [[JYAppDelegate sharedAppDelegate] showTip:@"定位成功"];
    if ([noti.object isKindOfClass:[NSString class]]) {
        [_btnLocation setTitle:noti.object forState:UIControlStateNormal];
    }else{
        [[JYAppDelegate sharedAppDelegate] showTip:@"定位不可用，您的定位服务未打开。"];
    }
}

- (void)keyBoardWillShow:(NSNotification*)notification{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat distanceFromTop = _maxAgeTF.superview.bottom - self.contentOffset.y;
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (KScreenVisualHeight - distanceFromTop < rect.size.height) {
        [UIView animateWithDuration:duration animations:^{
            [self setContentOffset:CGPointMake(0,_maxAgeTF.superview.bottom - KScreenVisualHeight + rect.size.height)];
        }];
    }
}
- (void)keyBoardWillHide:(NSNotification*)aNotification{
    CGFloat duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self setContentOffset:CGPointMake(0,oofset)];
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //    NSString *str = (NSString*)();
    
    BOOL isConstel = &kFrameChangeConstellationSection == context;
    BOOL isAge = &kFrameChangeAgeSection == context;
    BOOL isHeight = &kFrameChangeHeightSection == context;
    BOOL isArea = &kFrameChangeAeraSection == context;
    BOOL isTag = &kFrameChangeTagSection == context;
    BOOL isContentSize = &kKVOContentSizeChanged == context;
    
    CGRect frame = [[change objectForKey:@"new"] CGRectValue];
    if (isConstel) {
        [_sectionAge setFrame:CGRectMake(0, frame.origin.y + frame.size.height + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
    }
    if (isAge) {
        if (_isShowHeight) {
            [_sectionHeight setFrame:CGRectMake(0, frame.origin.y + frame.size.height + kSiftYPadding, kScreenWidth, kSiftLabelHeight + 25 + 4*25 + 15*3)];
        }else{
            [_sectionHeight setFrame:CGRectMake(0, frame.origin.y + frame.size.height, kScreenWidth, 0)];
        }
    }
    if (isHeight) {
        UIButton *btn = (UIButton*)[_sectionArea viewWithTag:4999];
        //        kSiftLabelHeight + 25 + 4*25 + 15*3 kSiftLabelHeight + 25*11 + 15*9
        if (btn.selected) {
            
            [_sectionArea setFrame:CGRectMake(0, frame.origin.y + frame.size.height + kSiftYPadding, kScreenWidth, kSiftLabelHeight + 25*11 + 15*9)];
            
        }else{
            [_sectionArea setFrame:CGRectMake(0, frame.origin.y + frame.size.height + kSiftYPadding, kScreenWidth, kSiftLabelHeight)];
        }
    }
    if (isArea) {
        UIButton *btn = (UIButton*)[_sectionTag viewWithTag:5999];
//        UIButton *change = (UIButton*)[_sectionTag viewWithTag:6789];
        UIView *tagBgView = [_sectionTag viewWithTag:778];
        if (btn.selected) {
            [_sectionTag setFrame:CGRectMake(0, frame.origin.y + frame.size.height + kSiftYPadding, kScreenWidth,tagBgView.bottom)];
        }else{
            [_sectionTag setFrame:CGRectMake(0, frame.origin.y + frame.size.height + kSiftYPadding, kScreenWidth, tagBgView.top-kSiftYPadding)];
        }
    }
    if (isTag) {
        [_sectionConfirm setFrame:CGRectMake(0, _sectionTag.bottom+kSiftYPadding, kScreenWidth, 44)];
        [self setContentSize:CGSizeMake(kScreenWidth, _sectionConfirm.bottom)];
    }
    
    if (isContentSize && _status) {
        if (self.contentSize.height > currentBottom) {
            if (self.contentSize.height > kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 29) {
                //展开超过屏幕宽度的处理
                if (_status != JYFriendFilterStatusHalf) {
                    [self setHeight:kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 29];
                }
                currentBottom = kScreenHeight - kNavigationBarHeight - kStatusBarHeight - 29;
                NSLog(@"currentbottom --> %lf",currentBottom);
                [self setScrollEnabled:YES];
            }else{
                if (_status != JYFriendFilterStatusHalf) {
                    [self setHeight:self.contentSize.height];
                }
                currentBottom = self.contentSize.height;
                [self setScrollEnabled:NO];
                NSLog(@"currentbottom --> %lf",currentBottom);

            }
        }else{
            if (_status != JYFriendFilterStatusHalf) {
                [self setHeight:self.contentSize.height];
            }
            currentBottom = self.contentSize.height;
            NSLog(@"currentbottom --> %lf",currentBottom);
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    oofset = self.contentOffset.y;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length == 2 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"0"]) {
        [textField setText:@""];
        [[JYAppDelegate sharedAppDelegate] showTip:@"请输入1~99的数字"];
    }
}


- (void)filterViewDidFinishFilterWithStr:(NSString*)str{

    NSMutableDictionary *filterDic = [NSMutableDictionary dictionaryWithObject:str forKey:@"condition"];
    
    if (_starSelectedArr.count > 0) {
        NSMutableString *mutStr = [NSMutableString string];
        for (NSString*str in _starSelectedArr) {
            [mutStr appendFormat:@"%@,",str];
        }
        [filterDic setObject:[mutStr substringToIndex:mutStr.length - 1] forKeyedSubscript:@"condition_star"];
    }
    if (_selectedTidArr.count > 0) {
        NSMutableString *mutStr = [NSMutableString string];
        for (NSDictionary *tagInfoDic in _selectedTidArr) {
            [mutStr appendFormat:@"%@,",[tagInfoDic objectForKey:@"tid"]];
        }
        [filterDic setObject:[mutStr substringToIndex:mutStr.length - 1] forKeyedSubscript:@"condition_tags"];
    }

    if ([self.filterDelegate respondsToSelector:@selector(friendFilterView:didFinishedFilterViewFilterResultDict:)]) {
        [self.filterDelegate friendFilterView:self didFinishedFilterViewFilterResultDict:filterDic];
    }
    if (self.status == JYFriendFilterStatusFullScreen) {
        [self setStatus:JYFriendFilterStatusClose];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
