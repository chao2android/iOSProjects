//
//  VersionManager.m
//  ColdJoke
//
//  Created by Hepburn Alex on 12-11-23.
//
//

#import "VersionManager.h"
#import "JSON.h"

static VersionManager *gVerManager = nil;

@implementation VersionManager

@synthesize mVersion, mAppUrl, mCurVersion;

- (NSString *)GetLocalPath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/versionManager.plist", docDir];
}

+ (VersionManager *)Share {
    if (!gVerManager) {
        gVerManager = [[VersionManager alloc] init];
    }
    return gVerManager;
}

- (id)init {
    self = [super init];
    if (self) {
        mDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self GetLocalPath]];
        if (!mDict) {
            mDict = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [self Cancel];
    [mDict release];
    [super dealloc];
}

- (void)setMReleaseNotes:(NSString *)value {
    if (value && value.length>0) {
        [mDict setObject:value forKey:@"releasenotes"];
        [mDict writeToFile:[self GetLocalPath] atomically:YES];
    }
}

- (NSString *)mReleaseNotes {
    return [mDict objectForKey:@"releasenotes"];
}

- (void)setMVersion:(NSString *)version {
    if (version && version.length>0) {
        [mDict setObject:version forKey:@"version"];
        [mDict writeToFile:[self GetLocalPath] atomically:YES];
    }
}

- (NSString *)mVersion {
    return [mDict objectForKey:@"version"];
}

- (NSString *)mCurVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

- (void)setMAppUrl:(NSString *)appurl {
    if (appurl && appurl.length>0) {
        [mDict setObject:appurl forKey:@"appurl"];
        [mDict writeToFile:[self GetLocalPath] atomically:YES];
    }
}

- (NSString *)mAppUrl {
    return [mDict objectForKey:@"appurl"];
}

- (BOOL)HasNewVersion {
    NSString *serverVersion = self.mVersion;
    NSString *curversion = self.mCurVersion;
    if (!serverVersion || serverVersion.length == 0) {
        return NO;
    }
    NSArray *serverArray = [serverVersion componentsSeparatedByString:@"."];
    NSArray *curverArray = [curversion componentsSeparatedByString:@"."];
    int iSerVer = 0;
    int iCurVer = 0;
    for (int i = 0; i < 3; i ++) {
        iSerVer *= 100;
        iCurVer *= 100;
        if (i<serverArray.count) {
            iSerVer += [[serverArray objectAtIndex:i] intValue];
        }
        if (i<curverArray.count) {
            iCurVer += [[curverArray objectAtIndex:i] intValue];
        }
    }
    NSLog(@"%d, %d", iSerVer, iCurVer);
    if (iSerVer <= iCurVer) {
        return NO;
    }
    return YES;
}

- (void)CheckAppVersion:(BOOL)bSucShow {
    if ([[VersionManager Share] HasNewVersion]) {
        NSString *msg = @"检测到新的版本，是否立即升级？";
        if (!IOS_7) {
            msg = [msg stringByAppendingString:@"\n\n\n\n\n\n\n"];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新内容" message:msg delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即升级", nil];
        NSLog(@"%@", self.mReleaseNotes);
        UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(15.0, 75.0, 255.0, 100.0)];
        textView.backgroundColor = [UIColor whiteColor];
        textView.font = [UIFont systemFontOfSize:15];
        textView.layer.cornerRadius = 6;
        textView.layer.masksToBounds = YES;
        textView.text = self.mReleaseNotes;
        textView.editable = NO;
        if (IOS_7) {
            [alertView setValue:textView forKey:@"accessoryView"];
        }
        else {
            [alertView addSubview:textView];
        }
        [textView release];
        
        [alertView show];
        [alertView release];
    }
    else if (bSucShow) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您安装的是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *appurl = self.mAppUrl;
        if (appurl) {
            NSURL *url = [NSURL URLWithString:appurl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)OnGetDetailRespond:(ImageDownManager *)sender {
    NSLog(@"OnGetDetailRespond");
	NSString *theXML = [[[NSString alloc] initWithBytes: [sender.mWebData mutableBytes] length:[sender.mWebData length] encoding:NSUTF8StringEncoding] autorelease];
    NSMutableDictionary *dict = [theXML JSONValue];
    [self Cancel];
    if (dict) {
        NSArray *array = [dict objectForKey:@"results"];
        NSLog(@"%@", array);
        if (array && [array count] > 0) {
            dict = [array objectAtIndex:0];
            if (dict) {
                NSString *version = [dict objectForKey:@"version"];
                self.mVersion = version;
                NSString *appurl = [dict objectForKey:@"trackViewUrl"];
                self.mAppUrl = appurl;
                self.mReleaseNotes = [dict objectForKey:@"releaseNotes"];
            }
        }
    }
}

- (void)OnDownloadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)GetAppDetail:(NSString *)appid {
    if (!appid || [appid length] == 0) {
        return;
    }
    if (mDownManager) {
        return;
    }
    mDownManager = [[ImageDownManager alloc] init];
    mDownManager.delegate = self;
    mDownManager.OnImageDown = @selector(OnGetDetailRespond:);
    mDownManager.OnImageFail = @selector(OnDownloadFail:);
    
    NSString *path = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=cn", appid];
    [mDownManager GetImageByStr:path];
}

- (void)Cancel {
    if (mDownManager) {
        mDownManager.delegate = nil;
        [mDownManager Cancel];
        [mDownManager release];
        mDownManager = nil;
    }
}

@end
