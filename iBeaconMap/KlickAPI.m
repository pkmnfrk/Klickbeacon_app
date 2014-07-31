//
//  KlickAPI.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-30.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "KlickAPI.h"
#import "Preferences.h"

@interface KlickAPI () <NSURLConnectionDelegate> {
    NSURLSession * session;
}

@end

@implementation KlickAPI

+(KlickAPI *)default
{
    static KlickAPI * ret = nil;
    if(!ret) ret = [KlickAPI new];
    
    return ret;
}

-(id)init {
    self = [super init];
    
    if(self) {
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    }
    
    return self;
}

-(void)dealloc {
    [session finishTasksAndInvalidate];
}

-(void)pingBeaconWithUUID:(NSString *)uuid major:(NSUInteger)major minor:(NSUInteger)minor
{
    NSString * url = [NSString stringWithFormat:BASEURL @"ping/%@/%d/%d", uuid, major, minor];
    
    NSMutableURLRequest * request = [self createRequest:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData data]];
    
    [[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        
        //the only thing we really care about is the clientid
        [self retrieveAndStoreTheClientId:response];
        
    
    }] resume];
}

-(void)setClientName:(NSString*)name {
    NSString * url = BASEURL @"client/me/name";
    
    name = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)name, NULL, NULL, kCFStringEncodingUTF8));
                                                   
    NSString * rawData = [NSString stringWithFormat:@"name=%@", name];
    NSData * data = [rawData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [self createRequest:url];
    
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:data];
    
    [[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        
        //the only thing we really care about is the clientid
        [self retrieveAndStoreTheClientId:response];
        
        
    }] resume];
}

-(NSMutableURLRequest *)createRequest:(NSString*)urlString
{
    NSString * clientID = [Preferences clientID];
    
    NSURL * url =[NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:15];
    
    [request setHTTPShouldHandleCookies:NO];
    if(clientID != nil) [request setValue:[NSString stringWithFormat:@"ClientID=%@", clientID] forHTTPHeaderField:@"Cookie"];
    return request;
}

-(void)retrieveAndStoreTheClientId:(NSURLResponse*)response {
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    
    for(NSString * key in httpResponse.allHeaderFields.keyEnumerator) {
        if([key isEqualToString:@"Set-Cookie"]) {
            NSString * value = [httpResponse.allHeaderFields objectForKey:key];
            
            value = [[value componentsSeparatedByString:@";"] firstObject];
            
            if([value hasPrefix:@"ClientID="]) {
                value = [[value componentsSeparatedByString:@"="] objectAtIndex:1];
                [Preferences setClientID:value];
                return;
            }
        }
    }
}


@end
