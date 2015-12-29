//
//  PhotoEffectView.h
//  TestPhotoEffect
//
//  Created by Bruce on 11-7-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoEffectView : UIImageView {
	UIImageView *mCoverView;
}

@property (nonatomic, retain) UIImage *mSrcImage;

- (void)ShowBaseImage;
- (void)ShowEffect1Image;
- (void)ShowEffect2Image;
- (void)ShowEffect3Image;
- (void)ShowEffect4Image;
- (void)ShowEffect5Image;
- (void)ShowEffect6Image;
- (void)ShowEffect7Image;
- (void)ShowEffect8Image;
- (void)ShowEffect9Image;
- (void)ShowEffect10Image;
- (void)ShowEffect11Image;
- (void)ShowEffect12Image;
- (void)ShowEffect13Image;
- (void)ShowEffect14Image;

- (void)LoadEffectImage:(int)index;

@end
