//
//  tuijianCell.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "tuijianCell.h"

@implementation tuijianCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 320, 6)];
        lineIV.image = [UIImage imageNamed:@"001_line.png"];
        [self addSubview:lineIV];
        [lineIV release];
        
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(125, 6, 80, 20)];
        _timeLab.textAlignment = 1;
        _timeLab.textColor = [UIColor colorWithRed:216/255.0f green:190/255.0f blue:159/255.0f alpha:1];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLab];
        [_timeLab release];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 300, 340)];
        bgView.image = [UIImage imageNamed:@"001_22.png"];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        [bgView release];
        
        UILabel *xianLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 260, 280, 1)];
        xianLab.alpha = 0.5f;
        xianLab.backgroundColor = [UIColor grayColor];
        [self addSubview:xianLab];
        [xianLab release];
        
        UILabel *xianLab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 315, 280, 1)];
        xianLab2.alpha = 0.5f;
        xianLab2.backgroundColor = [UIColor grayColor];
        [self addSubview:xianLab2];
        [xianLab2 release];
        
        
        _bigImageView = [[NetImageView alloc]initWithFrame:CGRectMake(20, 40, 280, 165)];
        _bigImageView.mImageType = TImageType_CutFill;
        [self addSubview:_bigImageView];
        [_bigImageView release];
        
        _listImageView1 = [[NetImageView alloc]initWithFrame:CGRectMake(255, 210, 45, 45)];
         _listImageView1.mImageType = TImageType_CutFill;
        [self addSubview:_listImageView1];
        [_listImageView1 release];
        
        _listImageView2 = [[NetImageView alloc]initWithFrame:CGRectMake(255, 265, 45, 45)];
        _listImageView2.mImageType = TImageType_CutFill;
        [self addSubview:_listImageView2];
        [_listImageView2 release];
        
        
        _listImageView3 = [[NetImageView alloc]initWithFrame:CGRectMake(255, 320, 45, 45)];
        _listImageView3.mImageType = TImageType_CutFill;
        [self addSubview:_listImageView3];
        [_listImageView3 release];
        
        
        UIImageView *bigLableView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 175, 280, 30)];
        bigLableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shadow.png"]];
        //      bigLableView.alpha = 0.5f;
        [self addSubview:bigLableView];
        [bigLableView release];
        
        if (ISIPAD) {
            CGFloat xX =(Screen_Width - 320*1.4)/2;
            lineIV.frame = CGRectMake(xX, 14, 320*1.4, 6*1.4);
            _timeLab.frame = CGRectMake(xX + 195, 6, 80, 20);
            
            bgView .frame = CGRectMake(xX + 10, 30, 300*1.4, 368*1.4);
            _bigImageView.frame = CGRectMake(xX + 25, 45, 280*1.4, 175*1.4);
            
            _listImageView1.frame = CGRectMake(xX + 347, 300, 50*1.4, 50*1.4);
            
            xianLab.frame = CGRectMake(xX + 25, 375, 280*1.4, 1);
            _listImageView2.frame = CGRectMake(xX + 347, 380, 50*1.4, 50*1.4);
            
            xianLab2.frame = CGRectMake(xX + 25, 455, 280*1.4, 1);
            _listImageView3.frame = CGRectMake(xX + 347, 460, 50*1.4, 50*1.4);
            bigLableView.frame = CGRectMake(xX + 25, 248, 280*1.4, 30*1.4);
        }
    }
    return self;
}
-(void)remImageTextLab{
    if (_bigLab) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [_bigLab removeFromSuperview];
        [_bigBut removeFromSuperview];
        _bigLab = nil;
        [pool release];
    }
    if (_listLab1) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [_listLab1 removeFromSuperview];
        [_but1 removeFromSuperview];
        
        _listLab1 = nil;
        [pool release];
    }
    if (_listLab2) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [_listLab2 removeFromSuperview];
        [_but2 removeFromSuperview];
        
        _listLab2 = nil;
        [pool release];
    }
    if (_listLab3) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [_listLab3 removeFromSuperview];
        [_but3 removeFromSuperview];
        
        _listLab3 = nil;
        [pool release];
    }
    
    
    
    _bigLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(25, 180, 270, 25)];
    _bigLab.backgroundColor = [UIColor clearColor];
    _bigLab.textColor = [UIColor whiteColor];
    //  _bigLab.alpha = 0.5f;
    _bigLab.m_Font = [UIFont boldSystemFontOfSize:18];
    _bigLab.m_RowHeigh = 25;
    [self addSubview:_bigLab];
    [_bigLab release];
    
    _listLab1 = [[ImageTextLabel alloc]initWithFrame:CGRectMake(20, 225, 232, 50)];
    _listLab1.backgroundColor = [UIColor clearColor];
    _listLab1.m_Font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_listLab1];
    [_listLab1 release];
    
    _listLab2 = [[ImageTextLabel alloc]initWithFrame:CGRectMake(20, 280, 232, 50)];
    _listLab2.m_Font = [UIFont boldSystemFontOfSize:16];
    _listLab2.backgroundColor = [UIColor clearColor];
    [self addSubview:_listLab2];
    [_listLab2 release];
    
    _listLab3 = [[ImageTextLabel alloc]initWithFrame:CGRectMake(20, 335, 232, 50)];
    _listLab3.backgroundColor = [UIColor clearColor];
    _listLab3.m_Font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_listLab3];
    [_listLab3 release];
    
    
    
    _bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _bigBut.frame = CGRectMake(20, 40, 280, 165);
    [self addSubview:_bigBut];
    
    _but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _but1.frame = CGRectMake(20, 205, 280, 55);
    [self addSubview:_but1];
    
    _but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _but2.frame =  CGRectMake(20, 260, 280, 55);
    [self addSubview:_but2];
    
    _but3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _but3.frame =  CGRectMake(20, 315, 280, 53);
    [self addSubview:_but3];
//    _but3.backgroundColor=[UIColor redColor];
//    _but1.backgroundColor=[UIColor redColor];
//    _but2.backgroundColor=[UIColor redColor];
//    _bigBut.backgroundColor=[UIColor redColor];
    if (ISIPAD) {
        
        CGFloat xX =(Screen_Width - 320*1.4)/2;
        
        _bigLab.frame =CGRectMake(xX + 25, 258, 280, 30);
        
        _listLab1.frame = CGRectMake(xX + 25, 320, 222*1.4, 55*1.4);
        _listLab2.frame = CGRectMake(xX + 25, 400, 222*1.4, 55*1.4);
        _listLab3.frame = CGRectMake(xX + 25, 480, 222*1.4, 53*1.4);
        _listLab1.m_Font = [UIFont boldSystemFontOfSize:18];
        _listLab2.m_Font = [UIFont boldSystemFontOfSize:18];
        _listLab3.m_Font = [UIFont boldSystemFontOfSize:18];

        
        _bigBut.frame = CGRectMake(xX + 25, 45, 280*1.4, 175*1.4);
        _but1.frame = CGRectMake(xX + 25, 305, 280*1.4, 50*1.4);
        _but2.frame = CGRectMake(xX + 25, 385, 280*1.4, 50*1.4);
        _but3.frame = CGRectMake(xX + 25, 465, 280*1.4, 50*1.4);
    }
    
    
    [_bigBut addTarget:self action:@selector(clicked_but:) forControlEvents:UIControlEventTouchUpInside];
    [_but1 addTarget:self action:@selector(clicked_but:) forControlEvents:UIControlEventTouchUpInside];
    [_but2 addTarget:self action:@selector(clicked_but:) forControlEvents:UIControlEventTouchUpInside];
    [_but3 addTarget:self action:@selector(clicked_but:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(IBAction)clicked_but:(UIButton *)sender{
    
    [self.delegate clickCellButton:sender.tag];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
