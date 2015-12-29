//
//  AnalysisClass.m
//  央广视讯
//
//  Created by e420 app on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnalysisClass.h"
#import "JSON.h"
#import "CSDataHandle.h"
#import "TishiView.h"
#import "AutoAlertView.h"

@implementation AnalysisClass
@synthesize delegate,url,ControllerName,DataName;
@synthesize dataDictionary;
@synthesize request=_request;
- (void)dealloc
{
    _request=nil;
    self.dataDictionary=nil;
    self.DataName=nil;
    self.ControllerName=nil;
    self.url=nil;
    [super dealloc];
}
- (AnalysisClass *)initWithIdentifier:(NSURL *)identifier DataName:(NSString *)name ControllerName:(NSString *)controllerName delegate:(id<AnalysisClassDelegate>)delegate1
{
    self=[super init];
    if (self) {
        [self setUrl:identifier];
        [self setDataName:name];
        [self setControllerName:controllerName];
        [self setDelegate:delegate1];
    }
    return self;
}
- (void)CancelMenthrequst
{
//    (@"4324234sfdgf76765867");
    if (_request) {
        
        [_request cancel];
    _request.delegate=nil;
    [_request clearDelegatesAndCancel];
    }
}
- (void)PostMenth:(NSMutableDictionary *)aDictionary
{
//    (@"%@",aDictionary);
//    if (_request) {
//        [self CancelMenthrequst];
//        _request=nil;
//    }
//    if (_request==nil) {
    
    
    _request=[[ASIFormDataRequest alloc] initWithURL:self.url];
    _request.timeOutSeconds=60.0;
    for (int i=0; i<[[aDictionary allKeys] count]; i++) {
        if ([[[aDictionary allKeys]objectAtIndex:i] isEqualToString:@"file"]) {
//            (@"%@",[aDictionary valueForKey:[[aDictionary allKeys]objectAtIndex:i]]);
            [_request setFile:[aDictionary valueForKey:[[aDictionary allKeys]objectAtIndex:i]] forKey:@"file"];
//        [_request addFile:[aDictionary valueForKey:[[aDictionary allKeys]objectAtIndex:i]]  forKey:@"file"];
        }
        else
        {
        [_request setPostValue:[aDictionary valueForKey:[[aDictionary allKeys]objectAtIndex:i]] forKey:[[aDictionary allKeys]objectAtIndex:i]];
        }
    }
    _request.delegate=self;
    _request.shouldAttemptPersistentConnection=NO;
    [_request startAsynchronous];
    [_request release];
//    }
}
//- (void)Asihttp
//{    
//    _request=[[ASIHTTPRequest alloc] initWithURL:self.url];
//    _request.delegate=self;
//    _request.shouldAttemptPersistentConnection=NO;
//    [_request startAsynchronous];
//}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData * data=[request responseData];
    
    if ([self respondsToSelector:@selector(DataArray:DataName:ControllerName:)])
    {
        [self DataArray:data DataName:nil ControllerName:[self ControllerName]];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{

    NSString* string=[NSString stringWithFormat:@"%@",request.error];
   
    if ([[self delegate] respondsToSelector:@selector(Asihttp:DataArray:)] && self.delegate)
    {
//        self.dataDictionary=[[[NSMutableDictionary alloc]initWithCapacity:10]autorelease];
//        NSMutableDictionary * dic=[[NSMutableDictionary alloc]initWithCapacity:1];
        NSString * tishiString=tishiString=@"加载超时,请重新请求...";
        if ([string rangeOfString:@"The operation couldn’t be completed. Connection refused"].length)
        {
            tishiString=@"服务器异常,无法连接服务器...";
//            [dic setValue:@"服务器异常,无法连接服务器..." forKey:@"msg"];
        }
        else if ([string rangeOfString:@"The operation couldn’t be completed. No route to host"].length)
        {
            tishiString=@"无法与服务器通讯。请连接到移动数据网络或者WiFi";
//            [dic setValue:@"无法与服务器通讯。请连接到移动数据网络或者WiFi" forKey:@"msg"];
        }
//        else
//        {
//            
////            [dic setValue:@"加载超时,请从新请求..." forKey:@"msg"];
//        }
        if (![self.ControllerName isEqualToString:@"tishi"]&&![self.ControllerName isEqualToString:@"banben"]) {
            
        [AutoAlertView ShowAlert:@"温馨提示" message:tishiString];
        }
        [[self delegate] Asihttp:self DataArray:nil];
//        [dic release];
    }
    _request=nil;

}
- (void)DataArray:(NSData *)data DataName:(NSString *)name ControllerName:(NSString *)controllerName
{
    
    NSString * dataString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    self.dataDictionary=[[[NSMutableDictionary alloc]initWithCapacity:10]autorelease];
    NSDictionary * Dictionary=[dataString JSONValue];
//    (@"%@",Dictionary);
    [self.dataDictionary setValue:Dictionary forKey:controllerName];
    [dataString release];

    if ([[self delegate] respondsToSelector:@selector(Asihttp:DataArray:)] && self.delegate)
    {
        if ([[NSString stringWithFormat:@"%@",[Dictionary valueForKey:@"message"]] isEqualToString:@"校验token失败"])
        {
            
            TishiView * tishi=[TishiView tishiViewMenth];
            [tishi StopMenth];
            UIAlertView *  _alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的账号在其他设备上登录,是否重新登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新登录", nil];
            [_alertview show];
            [_alertview release];
            _request=nil;
            return;
        }
        [[self delegate] Asihttp:self DataArray:self.dataDictionary];
    }
    _request=nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex) {
//    if (_alertview) {
//        _alertview=nil;
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chongxindenglu" object:nil];
    //    }
}

@end
