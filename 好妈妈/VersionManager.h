//
//  VersionManager.h
//  ColdJoke
//
//  Created by Hepburn Alex on 12-11-23.
//
//

#import <Foundation/Foundation.h>
#import "ImageDownManager.h"

@interface VersionManager : NSObject<UIAlertViewDelegate> {
    ImageDownManager *mDownManager;
    NSMutableDictionary *mDict;
}

@property (readonly) NSString *mCurVersion;
@property (nonatomic, assign) NSString *mVersion;
@property (nonatomic, assign) NSString *mAppUrl;
@property (nonatomic, assign) NSString *mReleaseNotes;

- (void)GetAppDetail:(NSString *)appid;
- (BOOL)HasNewVersion;
- (void)CheckAppVersion:(BOOL)bSucShow;

+ (VersionManager *)Share;

@end
