//
//  PhotoEffectView.m
//  TestPhotoEffect
//
//  Created by Bruce on 11-7-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoEffectView.h"
#import "PhotoEffectManager.h"

#define DEG2RAD (M_PI/180.0f)

@implementation PhotoEffectView

@synthesize mSrcImage;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)ClearCoverView {
	if (mCoverView) {
		[mCoverView removeFromSuperview];
		mCoverView = nil;
	}
}

- (UIImage *)GetBaseImage {
	return self.mSrcImage;
}

- (void)ShowBaseImage {
	[self ClearCoverView];
	self.image = [self GetBaseImage];
}

- (void)ShowEffect1Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect1:image1];
}

- (void)ShowEffect2Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect2:image1];
}

- (void)ShowEffect3Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect3:image1];
}

- (void)ShowEffect4Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect4:image1];
}

- (void)ShowEffect5Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect5:image1];
}

- (void)ShowEffect6Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect6:image1];
}

- (void)ShowEffect7Image {
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect7:image1];
}

- (void)ShowEffect8Image {
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect8:image1];
}

- (void)ShowEffect9Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	self.image = [PhotoEffectManager Effect9:image1];
	if (!image1) {
		return;
	}
	mCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	mCoverView.image = [UIImage imageNamed:@"old.png"];
	[self addSubview:mCoverView];
	[mCoverView release];
}

- (void)ShowEffect10Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect10:image1];
}

- (void)ShowEffect11Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	self.image = [PhotoEffectManager Effect11:image1];
	if (!image1) {
		return;
	}
	mCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	mCoverView.image = [UIImage imageNamed:@"cow.png"];
	mCoverView.alpha = 1.0;
	[self addSubview:mCoverView];
	[mCoverView release];
}

- (void)ShowEffect12Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect12:image1];
}

- (void)ShowEffect13Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect13:image1];
}

- (void)ShowEffect14Image {
	[self ClearCoverView];
	UIImage *image1 = [self GetBaseImage];
	if (!image1) {
		return;
	}
	self.image = [PhotoEffectManager Effect14:image1];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self ShowBaseImage];
    }
    return self;
}

- (void)dealloc {
	self.mSrcImage = nil;
    [super dealloc];
}

- (void)LoadEffectImage:(int)index {
	switch (index) {
		case 0:	//原图
			[self ShowBaseImage];
			break;
		case 1:	//经典LOMO
			[self ShowEffect2Image];
			break;
		case 2:	//炫彩LOMO
			[self ShowEffect3Image];
			break;
		case 3:	//胶片
			[self ShowEffect4Image];
			break;
		case 4:	//复古
			[self ShowEffect5Image];
			break;
		case 5:	//印象
			[self ShowEffect6Image];
			break;
		case 6:	//HDR
			[self ShowEffect7Image];
			break;
		case 7:	//经典HDR
			[self ShowEffect8Image];
			break;
		case 8:	//老照片
			[self ShowEffect9Image];
			break;
		case 9:	//古铜色
			[self ShowEffect10Image];
			break;
		case 10:	//牛皮纸
			[self ShowEffect11Image];
			break;
		case 11:	//流金岁月
			[self ShowEffect12Image];
			break;
		case 12:	//哥特风
			[self ShowEffect13Image];
			break;
		case 13:	//反转色
			[self ShowEffect14Image];
			break;
		default:
			break;
	}
}

@end
