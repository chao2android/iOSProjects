//
//  ChatTableCell.h
//  MicroVideo
//
//  Created by Hepburn Alex on 12-12-2.
//  Copyright (c) 2012年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchImageView.h"
#import "AudioPlayButton.h"
#import "ImageTextLabel.h"

@interface ChatTableCell : UITableViewCell {
    TouchImageView *mHeadView;
    UIImageView *mTopView;
    UIView *mBotView;
    UIImageView *mBackView;
    UILabel *mlbTime;
    ImageTextLabel *mlbText;
    TouchImageView *mImageView;
    AudioPlayButton *mAudioView;
}

@property (readonly) AudioPlayButton *mAudioView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnAudioPlay;
@property (nonatomic, retain) NSString *mAudioPath;
@property (nonatomic, assign) SEL OnHeadSelect;
@property (nonatomic, assign) SEL OnImageSelect;

+ (int)HeightOfCell:(NSDictionary *)dict :(BOOL)bShowDate;
- (void)ShowContent:(NSDictionary *)dict :(BOOL)bShowDate;

@end
