//
//  ChatTableCell.m
//  MicroVideo
//
//  Created by Hepburn Alex on 12-12-2.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import "ChatTableCell.h"

@implementation ChatTableCell

@synthesize delegate, OnAudioPlay, OnHeadSelect, mAudioPath, mAudioView, OnImageSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        mTopView = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_Width-70)/2, 10, 70, 16)];
        mTopView.image = [UIImage imageNamed:@"chat-timeback.png"];
//        mTopView.hidden = YES;
        [self.contentView addSubview:mTopView];
        [mTopView release];

        mlbTime = [[UILabel alloc] initWithFrame:mTopView.bounds];
        mlbTime.backgroundColor = [UIColor clearColor];
        mlbTime.textColor = [UIColor whiteColor];
        mlbTime.font = [UIFont systemFontOfSize:10];
        mlbTime.textAlignment = UITextAlignmentCenter;
        mlbTime.text = @"13:33";
        [mTopView addSubview:mlbTime];
        [mlbTime release];
        
        mBotView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.contentView.frame.size.width, 45)];
        [self.contentView addSubview:mBotView];
        [mBotView release];
        
        mHeadView = [[TouchImageView alloc] initWithFrame:CGRectMake(25, 5, 30, 30)];
        mHeadView.backgroundColor = [UIColor lightGrayColor];
        mHeadView.mDefaultPath = @"headimage.png";
        mHeadView.delegate = self;
        mHeadView.OnViewClick = @selector(OnHeadClick);
        [mBotView addSubview:mHeadView];
        [mHeadView release];
        [mHeadView ShowLocalImage];
        
        mBackView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, mBotView.frame.size.width-100, mBotView.frame.size.height-5)];
        mBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mBackView.userInteractionEnabled = YES;
        mBackView.backgroundColor = [UIColor clearColor];
        [mBotView addSubview:mBackView];
        [mBackView release];
        
        mImageView = [[TouchImageView alloc] initWithFrame:CGRectMake(15, 5, 150, 80)];
        mImageView.backgroundColor = [UIColor clearColor];
        mImageView.hidden = YES;
        mImageView.delegate = self;
        mImageView.OnViewClick = @selector(OnImageClick);
        mImageView.mImageType = TImageType_LeftAlign;
        [mBackView addSubview:mImageView];
        [mImageView release];

        mAudioView = [[AudioPlayButton alloc] initWithFrame:CGRectMake(20, 5, mBackView.frame.size.width-30, 30)];
        mAudioView.delegate = self;
        mAudioView.OnAudioStart = @selector(OnAudioStart:);
        mAudioView.hidden = YES;
        [mBackView addSubview:mAudioView];
        [mAudioView release];
    }
    return self;
}

- (void)OnImageClick {
    if (delegate && OnImageSelect) {
        [delegate performSelector:OnImageSelect withObject:self];
    }
}

- (void)OnAudioStart:(NSString *)localpath {
    self.mAudioPath = localpath;
    if (delegate && OnAudioPlay) {
        [delegate performSelector:OnAudioPlay withObject:self];
    }
}

- (void)OnHeadClick {
    if (delegate && OnHeadSelect) {
        [delegate performSelector:OnHeadSelect withObject:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (int)HeightOfCell:(NSDictionary *)dict :(BOOL)bShowDate {
    int iDefaultHeight = 40;
    int iHeight = 25;
    if (bShowDate) {
        iDefaultHeight += 20;
        iHeight += 20;
    }
    int iSubType = [[dict objectForKey:@"subtype"] intValue];
    if (iSubType == 1) {
        NSString *text = [dict objectForKey:@"content"];
        if (text && [text isEqualToString:@"　"]) {
            text = nil;
        }
        if (text) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            ImageTextLabel *lbText = [[ImageTextLabel alloc] initWithFrame:CGRectMake(0, 0, 320-140, 200)];
            iHeight += [lbText LoadContent:text];
            [lbText release];
            [pool release];
        }
    }
    else {
        NSString *imagename = [dict objectForKey:@"content"];
        if (imagename && imagename.length>0) {
            if (iSubType == 2) {
                iHeight += 85;
            }
            else {
                iHeight += 35;
            }
        }
    }
    if (iHeight < iDefaultHeight) {
        return iDefaultHeight;
    }
    return iHeight;
}

- (void)ShowContent:(NSDictionary *)dict :(BOOL)bShowDate {
    NSLog(@"%@",dict);
    
    NSDictionary *userDict = dict;
    if (![userDict isKindOfClass:[NSDictionary class]]) {
        userDict = [NSDictionary dictionary];
    }
    mlbTime.text =[dict objectForKey:@"time"];
    NSString * headimage = [userDict objectForKey:@"icon"];
    NSLog(@"%@",headimage);
    [mHeadView GetImageByStr:headimage];
    
    BOOL bMyMsg = ([[dict valueForKey:@"style"] intValue]==1);
    NSLog(@"mlbTime %@",mlbTime.text);
    
    NSString *text = [dict objectForKey:@"content"];
    NSLog(@"%@",text);
    if (text && [text isEqualToString:@"　"]) {
        text = nil;
    }
    if (mlbText) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [mlbText removeFromSuperview];
        mlbText = nil;
        [pool release];
    }
    int iHeight = 20;
    int iTop = 5;
    mImageView.hidden = YES;
    mAudioView.hidden = YES;
    int iType = [[dict objectForKey:@"subtype"] intValue];
    if (iType == 1) {
        if (text) {
            mlbText = [[ImageTextLabel alloc] initWithFrame:CGRectMake(10, iTop, mBackView.frame.size.width-20, 200)];
            mlbText.backgroundColor = [UIColor clearColor];
            mlbText.textColor = [UIColor blackColor];
            [mBackView addSubview:mlbText];
            [mlbText release];
            
            iHeight = [mlbText LoadContent:text];
            iTop += (iHeight+5);
        }
    }
    else {
        NSString *imagename = [dict objectForKey:@"content"];
        if (imagename && imagename.length>0) {
            if (iType == 2) {
                mImageView.hidden = NO;
                mImageView.frame = CGRectMake(20, iTop, 150, 80);
                [mImageView GetImageByStr:imagename];
                iTop += 85;
            }
            else {
                mAudioView.hidden = NO;
                mAudioView.frame = CGRectMake(20, iTop, mBackView.frame.size.width-30, 30);
                mAudioView.mbWhite = NO;
                [mAudioView GetAudioStr:imagename];
                iTop += 35;
            }
        }
    }
    int iBotTop = 0;
    if (bShowDate) {
        iBotTop = 30;
    }
    if (iTop < 30) {
        iTop = 30;
    }
    mTopView.hidden = NO;
    if (ISIPAD) {
        mBotView.frame = CGRectMake(0, iBotTop, Screen_Width-100, iTop+5);

    }
    else
    {
    mBotView.frame = CGRectMake(0, iBotTop, Screen_Width, iTop+5);
    }
    if (bMyMsg) {
        mBackView.image = [[UIImage imageNamed:@"chatback01.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:20];
        mHeadView.frame = CGRectMake(mBotView.frame.size.width-45, 5, 30, 30);
    }
    else {
        mBackView.image = [[UIImage imageNamed:@"chatback03.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:20];
        mHeadView.frame = CGRectMake(15, 5, 30, 30);
    }
}

- (NSString *)DateToStr:(int)interval {
    if (interval == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}

- (NSString *)GetYearMonth:(int)interval {
    if (interval == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"YYYY年M月";
    return [formatter stringFromDate:date];
}

- (NSString *)GetDay:(int)interval {
    if (interval == 0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"dd日";
    return [formatter stringFromDate:date];
}

@end
