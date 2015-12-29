//
//  contentCell.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-11.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "contentCell.h"
@interface contentCell ()


@end

@implementation contentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //      @property (nonatomic,retain ) IBOutlet UIImageView  *contentImage;
        //      @property (nonatomic,retain ) IBOutlet UIImageView *lineImage;
        //      @property (nonatomic,retain ) IBOutlet UIImageView *lineImage2;
        //      @property (nonatomic,retain ) IBOutlet UIImageView *contentBgView;
        
        _contentBgView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 5, 220, 70)];
        [self addSubview:_contentBgView];
        [_contentBgView release];
        
        _contentImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(80, 80, 230, 130)];
        [self addSubview:_contentImage];
        [_contentImage release];
        
        _lineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001_15.png"]];
        _lineImage.frame = CGRectMake(70, 0, 6, 270);
        [self addSubview:_lineImage];
        [_lineImage release];
        
        
        _lineImage2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001_xian.png"]];
        _lineImage2.frame = CGRectMake(0, 269, 320, 1);
        //      _lineImage2.backgroundColor = [UIColor redColor];
        [self addSubview:_lineImage2];
        [_lineImage2 release];
        
        
        //      @property (nonatomic,retain ) IBOutlet UIImageView *iconImage;
        //      @property (nonatomic,retain)  IBOutlet UILabel *numLab;
        //      @property (nonatomic,retain)  IBOutlet UIImageView *numView;
        //      @property (nonatomic ,retain) IBOutlet UIButton *iconBut;
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
        [self addSubview:_iconImage];
        [_iconImage release];
        
        _levelLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 72, 50, 30)];
        _levelLab.backgroundColor = [UIColor clearColor];
        _levelLab.textAlignment = 1;
        _levelLab.textColor = [UIColor colorWithRed:79/255.0f green:80/255.0f blue:83/255.0f alpha:1];

        _levelLab.font = [UIFont systemFontOfSize:14];
        _levelLab.text = @"LV.12";
        [self addSubview:_levelLab];
        [_levelLab release];
        
        _numView = [[UIImageView alloc]initWithFrame:CGRectMake(63, 25, 20, 20)];
        _numView.image = [UIImage imageNamed:@"001_8.png"];
        [self addSubview:_numView];
        [_numView release];
        
        _numLab = [[UILabel alloc]initWithFrame:CGRectMake(58, 24, 30, 20)];
        _numLab.backgroundColor = [UIColor clearColor];
        _numLab.textAlignment = 1;
        //      _numLab.text = @"1";
        _numLab.textColor = [UIColor whiteColor];
        _numLab.font = [UIFont systemFontOfSize:9];
        [self addSubview:_numLab];
        [_numLab release];
        
        _iconBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBut.frame = CGRectMake(10, 20, 50, 50);
        [self addSubview:_iconBut];
        
        //      _jubaoBut = [UIButton buttonWithType:UIButtonTypeSystem];
        //      _jubaoBut.frame = CGRectMake(10, 75, 30, 20);
        //      [self addSubview:_jubaoBut];
        
        
        if (ISIPAD) {
            _iconImage.frame =CGRectMake(10+50, 20, 50, 50);
            _levelLab.frame = CGRectMake(10+50, 72, 50, 30);
            _numView.frame = CGRectMake(63+100, 25, 20, 20);
            _numLab.frame = CGRectMake(58+100, 24, 30, 20);
            _iconBut.frame = CGRectMake(10+50, 20, 50, 50);
            
            
        }
        
        
        //      @property (nonatomic,retain ) IBOutlet UILabel *contentLab;
        //      @property (nonatomic,retain ) IBOutlet UILabel *nameLab;
        //      @property (nonatomic,retain ) IBOutlet UILabel *statusLab;
        //      @property (nonatomic,retain ) IBOutlet UILabel *timeLab;
        
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 235, 50, 20)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor colorWithRed:79/255.0f green:80/255.0f blue:83/255.0f alpha:1];

        _nameLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:_nameLab];
        [_nameLab release];
        
        _statusLab = [[UILabel alloc]initWithFrame:CGRectMake(130, 235, 70, 20)];
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textAlignment = 1;
        _statusLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_background.png"]];
        _statusLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:_statusLab];
        [_statusLab release];
        
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(200, 235, 70, 20)];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textColor = [UIColor colorWithRed:79/255.0f green:80/255.0f blue:83/255.0f alpha:1];
        _timeLab.textAlignment = 2;
        _timeLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:_timeLab];
        [_timeLab release];
        
        //      @property (nonatomic,retain)  IBOutlet UIButton *zanBut;
        //      @property (nonatomic ,retain) IBOutlet UIButton *plBut;
        //
        
        _zanBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanBut.frame = CGRectZero;
        _zanBut.titleLabel.font = [UIFont systemFontOfSize:10];
        [_zanBut setBackgroundImage:[UIImage imageNamed:@"001_9.png"] forState:UIControlStateNormal];
        [self addSubview:_zanBut];
        
        
        
        //      @property(nonatomic,retain) IBOutlet UIImageView *replyBgView;
        //      @property(nonatomic,retain) IBOutlet UIImageView *replyIconView;
        //      @property(nonatomic,retain) IBOutlet UILabel *replyContentLab;
        //      @property(nonatomic,retain) IBOutlet UILabel *replyTimeLab;
        //      @property(nonatomic,retain) IBOutlet UILabel *replyNameLab;
        
        
        _replyBgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_replyBgView];
        [_replyBgView release];
        
        _replyIconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_replyIconView];
        [_replyIconView release];
        
        
        _replyTimeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _replyTimeLab.backgroundColor = [UIColor clearColor];
        _replyTimeLab.textAlignment = 2;
        _replyTimeLab.textColor = [UIColor colorWithRed:79/255.0f green:80/255.0f blue:83/255.0f alpha:1];

        _replyTimeLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:_replyTimeLab ];
        [_replyTimeLab release];
        
        _replyNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _replyNameLab.backgroundColor = [UIColor clearColor];
        _replyNameLab.textAlignment = 0;
        _replyNameLab.textColor = [UIColor colorWithRed:79/255.0f green:80/255.0f blue:83/255.0f alpha:1];

        _replyNameLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:_replyNameLab ];
        [_replyNameLab release];
        
        
        //      @property(nonatomic,retain) IBOutlet UIImageView *repLineView;
        //      @property(nonatomic,retain) IBOutlet UIImageView *repBgNumView;
        //      @property(nonatomic,retain) IBOutlet UILabel *repNumLab;
        
        _repLineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001_15.png"]];
        _repLineView.frame = CGRectZero;
        [self addSubview:_repLineView];
        [_repLineView release];
        
        _repBgNumView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001_8.png"]];
        _repBgNumView.frame = CGRectZero;
        [self addSubview:_repBgNumView];
        [_repBgNumView release];
        
        _repNumLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _repNumLab.backgroundColor = [UIColor clearColor];
        _repNumLab.textColor = [UIColor whiteColor];
        _repNumLab.textAlignment = 1;
        _repNumLab.font = [UIFont systemFontOfSize:9];
        [self addSubview:_repNumLab];
        [_repNumLab release];
        
        
        _audioButton = [[Mp3PlayerButton alloc] initWithFrame:CGRectMake(90, 20,70, 30)];
        _audioButton.hidden = YES ;
        [self addSubview:_audioButton];
        
        if (ISIPAD) {
            _audioButton.frame = CGRectMake(90+200, 20,70, 30);
        }
        
        
    }
    return self;
}

- (void)ShowContent:(NSDictionary *)dic{
    
    
    
    int _Height = 0;
    
    NSString *contentStr = dic[@"content"];
    CGSize size = [contentCell HeightOfText:contentStr];
    
    _Height = size.height;
    
    if (_contentLab) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [_contentLab removeFromSuperview];
        [_plBut removeFromSuperview];
        _contentLab = nil;
        [pool release];
    }
    
    
    _plBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _plBut.frame = CGRectZero;
    [_plBut setImage:[UIImage imageNamed:@"001_10.png"] forState:UIControlStateNormal];
    [self addSubview:_plBut];
    
    _contentLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(100, 5, 200, 30)];
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.textColor = [UIColor colorWithRed:79/255.0f green:80/255.0f blue:83/255.0f alpha:1];
    _contentLab.m_Font = [UIFont systemFontOfSize:15];
    _contentLab.m_EmoWidth = 18;
    _contentLab.m_EmoHeight = 18;
    //      _contentLab.numberOfLines = 0;
    [self addSubview:_contentLab];
    [_contentLab release];
    CGSize Msize = CGSizeMake(200, 1000);
    
    if (ISIPAD) {
        Msize = CGSizeMake(400, 1000);
    }
    
    _Height =[ImageTextLabel HeightOfContent:contentStr :Msize];
    
    if (_replyContentLab) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [_replyContentLab removeFromSuperview];
        _replyContentLab = nil;
        [pool release];
    }
    
    _replyContentLab = [[ImageTextLabel alloc]initWithFrame:CGRectZero];
    _replyContentLab.backgroundColor = [UIColor clearColor];
    _replyContentLab.textColor = [UIColor grayColor];
    _replyContentLab.m_Font = [UIFont systemFontOfSize:15];
    _replyContentLab.m_EmoWidth = 15;
    _replyContentLab.m_EmoHeight = 15;
    
    
    //  _replyContentLab.numberOfLines = 0;
    [self addSubview:_replyContentLab];
    [_replyContentLab release];
    
    
    
    self.contentImage.userInteractionEnabled=YES;
    self.iconImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"001_默认.png"]];
    self.replyIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"20_20.png"]];
    
    CALayer* l1=[self.contentImage layer];
    [l1 setMasksToBounds:YES];
    [l1 setBorderWidth:5];
    [l1 setBorderColor:[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]CGColor] ];
    
    
    
    self.nameLab.adjustsFontSizeToFitWidth = YES;
    self.nameLab.minimumFontSize = 1.0f;
    self.statusLab.adjustsFontSizeToFitWidth = YES;
    self.statusLab.minimumFontSize = 1.0f;
    
    UIImage *image = [[UIImage imageNamed:@"001_qipao.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:18];
    self.contentBgView.image = image;
    self.replyBgView.backgroundColor = [UIColor colorWithRed:255/255.0f green:249/255.0f blue:234/255.0f alpha:1];
    
    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
    
    self.contentLab.frame = CGRectMake(100, 25,size.width-20, _Height);
    
    if (ISIPAD) {
        self.contentLab.frame = CGRectMake(100+120, 25,size.width-20, _Height);
    }
    
    if ([type isEqualToString:@"(null)"]||[type isEqualToString:@"1"]) {
        
        self.replyBgView.hidden = YES;
        self.replyContentLab.hidden = YES;
        self.replyIconView.hidden = YES;
        self.replyNameLab.hidden = YES;
        self.replyTimeLab.hidden = YES;
        self.repNumLab.hidden = YES;
        self.repBgNumView.hidden = YES;
        self.repLineView.hidden = YES;
        
        self.contentBgView.frame = CGRectMake(90, 18, size.width, _Height+12);
        if (ISIPAD) {
            self.contentBgView.frame = CGRectMake(90+120, 18, size.width, _Height+12);
            
        }
        NSString *imageStr = dic[@"image"];
        if ([imageStr isEqualToString:@""]) {
            self.contentImage.hidden = YES;
            self.zanBut.hidden = YES;
            int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
            
            self.nameLab.frame = CGRectMake(80, Y+20, 50, 20);
            self.statusLab.frame = CGRectMake(130, Y+20, 70, 20);
            self.timeLab.frame = CGRectMake(200, Y+20, 70, 20);
            self.plBut.frame = CGRectMake(275, Y+15, 35, 25);
            self.lineImage2.frame = CGRectMake(0, Y+20+20+9, 320, 1);
            self.lineImage.frame = CGRectMake(70, 0, 6, _Height +80);
            
            if (ISIPAD) {
                self.nameLab.frame = CGRectMake(80+200-80, Y+20, 50, 20);
                self.statusLab.frame = CGRectMake(130+220, Y+20, 100, 20);
                self.timeLab.frame = CGRectMake(Screen_Width- 200, Y+20, 70, 20);
                self.plBut.frame = CGRectMake(Screen_Width - 80, Y+15, 35, 25);
                self.lineImage2.frame = CGRectMake(0, Y+20+20+9, Screen_Width, 1);
                self.lineImage.frame = CGRectMake(70+100, 0, 6, _Height +80);
            }
            
            
        }else{
            self.contentImage.hidden = NO;
            self.zanBut.hidden = NO;
            int ht  = [dic[@"height"] intValue];
            int wd = [dic[@"width"] intValue];
            if (wd >230) {
                ht = 230*ht/wd;
                wd = 230;
                
            }
            if (wd < 100) {
                ht = 100*ht/wd;
                wd = 100;
            }
            int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
            
            
            
            self.contentImage.frame = CGRectMake(80, Y+20, wd, ht);
            self.zanBut.frame = CGRectMake(80 +wd -50, Y+20+5, 45, 20);
            
            Y = self.contentImage.frame.origin.y + self.contentImage.frame.size.height;
            
            
            self.nameLab.frame = CGRectMake(80, Y+20, 50, 20);
            self.statusLab.frame = CGRectMake(130, Y+20, 70, 20);
            self.timeLab.frame = CGRectMake(200, Y+20, 70, 20);
            self.plBut.frame = CGRectMake(275, Y+15, 35, 25);
            
            self.lineImage2.frame = CGRectMake(0, Y+20+20+9, 320, 1);
            self.lineImage.frame = CGRectMake(70, 0, 6, _Height +80 +ht +20);
            if (ISIPAD) {
                int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
                
                
                
                self.contentImage.frame = CGRectMake(80+200, Y+20, wd, ht);
                self.zanBut.frame = CGRectMake(80+200 +wd -50, Y+20+5, 45, 20);
                
                Y = self.contentImage.frame.origin.y + self.contentImage.frame.size.height;
                
                
                self.nameLab.frame = CGRectMake(80+200-80, Y+20, 50, 20);
                self.statusLab.frame = CGRectMake(130+220, Y+20, 100, 20);
                self.timeLab.frame = CGRectMake(Screen_Width- 200, Y+20, 70, 20);
                self.plBut.frame = CGRectMake(Screen_Width- 80, Y+15, 35, 25);
                
                self.lineImage2.frame = CGRectMake(0, Y+20+20+9, Screen_Width, 1);
                self.lineImage.frame = CGRectMake(70+100, 0, 6, _Height +80 +ht +20);
            }
            
        }
        
        
        
    }else{
        self.replyBgView.hidden = NO;
        self.replyContentLab.hidden = NO;
        self.replyIconView.hidden = NO;
        self.replyNameLab.hidden = NO;
        self.replyTimeLab.hidden = NO;
        self.repNumLab.hidden = NO;
        self.repBgNumView.hidden = NO;
        self.repLineView.hidden = NO;
        
        
        
        NSDictionary*relpDic = dic[@"recontent"];
        NSString *relpContent = relpDic[@"content"];
        
        //    self.contentLab.frame = CGRectMake(100, 25,200, _Height);
        CGSize Msize2 = CGSizeMake(150, 1000);
        
        if (ISIPAD) {
            Msize2 = CGSizeMake(350, 1000);
        }

        
        int repHeight = [ImageTextLabel HeightOfContent:relpContent : Msize2];
        
        self.replyContentLab.frame = CGRectMake(130, 25+_Height+20, 150, repHeight);
        self.replyIconView.frame = CGRectMake(130, self.replyContentLab.frame.origin.y + self.replyContentLab.frame.size.height+10 , 20, 20);
        self.replyNameLab.frame = CGRectMake(158, self.replyContentLab.frame.origin.y + self.replyContentLab.frame.size.height +10 , 80, 20);
        self.replyTimeLab.frame = CGRectMake(218, self.replyContentLab.frame.origin.y + self.replyContentLab.frame.size.height+10, 80, 20) ;
        
        self.replyBgView.frame = CGRectMake(100, 25+_Height+10,200, repHeight +45);
        
        self.repLineView.frame = CGRectMake(111, 25+_Height+10, 5, repHeight +45);
        
        self.repNumLab.frame = CGRectMake(98, 25+_Height+14, 30, 20) ;
        self.repBgNumView.frame = CGRectMake(103, 25+_Height+15, 20, 20);
        
        
        self.contentBgView.frame = CGRectMake(90, 18, 220, _Height+10+repHeight +45+5+12);
        if (ISIPAD) {
            int repHeight = [ImageTextLabel HeightOfContent:relpContent : CGSizeMake(350, 1000)];
            
            self.replyContentLab.frame = CGRectMake(130+200-80, 25+_Height+20, 350, repHeight);
            self.replyIconView.frame = CGRectMake(130+200-80, self.replyContentLab.frame.origin.y + self.replyContentLab.frame.size.height+10 , 20, 20);
            self.replyNameLab.frame = CGRectMake(158+200-80, self.replyContentLab.frame.origin.y + self.replyContentLab.frame.size.height +10 , 80, 20);
            self.replyTimeLab.frame = CGRectMake(218+200-80, self.replyContentLab.frame.origin.y + self.replyContentLab.frame.size.height+10, 80, 20) ;
            
            self.replyBgView.frame = CGRectMake(100+200-80, 25+_Height+10,400, repHeight +45);
            
            self.repLineView.frame = CGRectMake(111+200-80, 25+_Height+10, 5, repHeight +45);
            
            self.repNumLab.frame = CGRectMake(98+200-80, 25+_Height+14, 30, 20) ;
            self.repBgNumView.frame = CGRectMake(103+200-80, 25+_Height+15, 20, 20);
            
            
            self.contentBgView.frame = CGRectMake(90+200-80, 18, 420, _Height+10+repHeight +45+5+12);
            
        }
        
        
        NSString *imageStr = dic[@"image"];
        if ([imageStr isEqualToString:@""]) {
            self.contentImage.hidden = YES;
            self.zanBut.hidden = YES;
            int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
            
            self.nameLab.frame = CGRectMake(80, Y+20, 50, 20);
            self.statusLab.frame = CGRectMake(130, Y+20, 70, 20);
            self.timeLab.frame = CGRectMake(200, Y+20, 70, 20);
            self.plBut.frame = CGRectMake(275, Y+15, 35, 25);
            self.lineImage2.frame = CGRectMake(0, Y+20+20+9, 320, 1);
            
            self.lineImage.frame = CGRectMake(70, 0, 6, _Height +80+repHeight +45+5+10);
            if (ISIPAD) {
                int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
                
                self.nameLab.frame = CGRectMake(80+200-80, Y+20, 50, 20);
                self.statusLab.frame = CGRectMake(130+270-50, Y+20, 100, 20);
                self.timeLab.frame = CGRectMake(Screen_Width- 200, Y+20, 70, 20);
                self.plBut.frame = CGRectMake(Screen_Width- 80, Y+15, 35, 25);
                self.lineImage2.frame = CGRectMake(0, Y+20+20+9, Screen_Width, 1);
                
                self.lineImage.frame = CGRectMake(70+100, 0, 6, _Height +80+repHeight +45+5+10);
            }
            
        }else{
            self.contentImage.hidden = NO;
            self.zanBut.hidden = NO;
            
            int ht  = [dic[@"height"] intValue];
            int wd = [dic[@"width"] intValue];
            if (wd >230) {
                ht = 230*ht/wd;
                wd = 230;
                
            }
            if (wd < 100) {
                ht = 100*ht/wd;
                wd = 100;
            }
            
            
            
            int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
            
            
            
            self.contentImage.frame = CGRectMake(80, Y+20, wd, ht);
            self.zanBut.frame = CGRectMake(80 +wd -50, Y+20+5, 45, 20);
            
            Y = self.contentImage.frame.origin.y + self.contentImage.frame.size.height;
            
            
            self.nameLab.frame = CGRectMake(80, Y+20, 50, 20);
            self.statusLab.frame = CGRectMake(130, Y+20, 70, 20);
            self.timeLab.frame = CGRectMake(200, Y+20, 70, 20);
            self.plBut.frame = CGRectMake(275, Y+15, 35, 25);
            
            self.lineImage2.frame = CGRectMake(0, Y+20+20+9, 320, 1);
            self.lineImage.frame = CGRectMake(70, 0, 6, _Height +80 +ht +20+repHeight +45+5+10);
            
            if (ISIPAD) {
                int Y = self.contentBgView.frame.origin.y + self.contentBgView.frame.size.height;
                
                
                
                self.contentImage.frame = CGRectMake(80+200, Y+20, wd, ht);
                self.zanBut.frame = CGRectMake(80 +wd -50+200, Y+20+5, 45, 20);
                
                Y = self.contentImage.frame.origin.y + self.contentImage.frame.size.height;
                
                
                self.nameLab.frame = CGRectMake(80+200-80, Y+20, 50, 20);
                self.statusLab.frame = CGRectMake(130+270-50, Y+20, 100, 20);
                self.timeLab.frame = CGRectMake(Screen_Width- 200, Y+20, 70, 20);
                self.plBut.frame = CGRectMake(Screen_Width- 80, Y+15, 35, 25);
                
                self.lineImage2.frame = CGRectMake(0, Y+20+20+9, Screen_Width, 1);
                self.lineImage.frame = CGRectMake(70+100, 0, 6, _Height +80 +ht +20+repHeight +45+5+10);
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
}
+ (int)HeightOfContent:(NSDictionary *)dic{
    int _Height = 0;
    
    NSString *contentStr = dic[@"content"];
    CGSize Msize = CGSizeMake(200, 1000);
    
    if (ISIPAD) {
        Msize = CGSizeMake(400, 1000);
    }

    _Height = [ImageTextLabel HeightOfContent:contentStr :Msize];
    
    
    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
    if ([type isEqualToString:@"(null)"]||[type isEqualToString:@"1"]) {
        
    }else{
        NSDictionary*relpDic = dic[@"recontent"];
        NSString *relpContent = relpDic[@"content"];
        
        //    CGSize relpySize = [contentCell HeightOfText2:relpContent];
        CGSize Msize2 = CGSizeMake(150, 1000);
        
        if (ISIPAD) {
            Msize2 = CGSizeMake(350, 1000);
        }

        _Height += [ImageTextLabel HeightOfContent:relpContent :Msize2]+60;
    }
    
    
    NSString *imageStr = dic[@"image"];
    if (![imageStr isEqualToString:@""]) {
        int ht  = [dic[@"height"] intValue];
        int wd = [dic[@"width"] intValue];
        if (wd >230) {
            ht = 230*ht/wd;
            wd = 230;
            
        }
        if (wd < 100) {
            ht = 100*ht/wd;
            wd = 100;
        }
        
        
        _Height+=ht+20;
    }
    
    NSString *vieo = dic[@"vieo"];
    if (vieo) {
        //    _Height += 50;
    }
    _Height +=80;
    return _Height;
}
+(CGSize )HeightOfText:(NSString *)content{
    CGSize mySize = CGSizeZero;
    if (!content) {
        return mySize;
    }
    CGSize size = CGSizeMake(200, 1000);
    
    if (ISIPAD) {
        size = CGSizeMake(400, 1000);
    }
    CGSize calcSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:0];
    int iHeight = calcSize.height+10;
    
    if (iHeight < 30) {
        iHeight = 30;
    }
    
    int iWidth = calcSize.width +22;
    mySize = CGSizeMake(iWidth, iHeight);
    return mySize;
    
}

+(CGSize )HeightOfText2:(NSString *)content{
    CGSize mySize = CGSizeZero;
    if (!content) {
        return mySize;
    }
    CGSize size = CGSizeMake(150, 1000);
    CGSize calcSize = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:0];
    int iHeight = calcSize.height;
    
    
    if (iHeight < 20) {
        iHeight = 20;
    }
    
    int iWidth = calcSize.width+22;
    mySize = CGSizeMake(iWidth, iHeight);
    return mySize;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
