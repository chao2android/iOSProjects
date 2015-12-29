//
//  AnalysisClass.h
//  央广视讯
//
//  Created by e420 app on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@protocol AnalysisClassDelegate;
@interface AnalysisClass : NSObject<ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    ASIFormDataRequest * _request;
}
@property (assign,nonatomic)id<AnalysisClassDelegate>delegate;
@property (retain,nonatomic)NSURL * url;
@property (retain,nonatomic)NSString * ControllerName;
@property (retain,nonatomic)NSString * DataName;
@property (retain,nonatomic)NSMutableDictionary * dataDictionary;
@property (retain,nonatomic)ASIFormDataRequest * request;
- (void)PostMenth:(NSMutableDictionary *)aDictionary;
- (void)CancelMenthrequst;
- (void)DataArray:(NSData *)data DataName:(NSString *)name ControllerName:(NSString *)controllerName;

- (AnalysisClass *)initWithIdentifier:(NSURL *)identifier DataName:(NSString *)name ControllerName:(NSString *)controllerName delegate:(id<AnalysisClassDelegate>)delegate;
@end
@protocol AnalysisClassDelegate <NSObject>

- (void)Asihttp:(AnalysisClass *)asi DataArray:(NSMutableDictionary *)array;

@end