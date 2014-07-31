//
//  BeaconBuilder.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "BeaconBuilder.h"

@implementation BeaconBuilder


+ (Beacon*)beaconFromJSON:(NSData *)objectNotation error:(NSError *__autoreleasing *)error {
    
    NSError *localError = nil;
    
    id parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if(localError != nil) {
        *error = localError;
        return nil;
    }
    
    Beacon * ret = [[Beacon alloc] init];
    
    if([parsedObject isKindOfClass:[NSArray class]]) {
        if([parsedObject count] == 0) {
            *error = [[NSError alloc] initWithDomain:@"KlickBeacon" code:2 userInfo:@{}];
            return nil;
        }
        parsedObject = [parsedObject objectAtIndex:0];
    
    }
    
    for(NSString * key in parsedObject) {
        if([key isEqualToString:@"_id"]) {
            id val = [parsedObject valueForKey:key];
            if([val isKindOfClass:[NSNull class]]) {
                val = nil;
            }
            
            [ret setValue:val forKeyPath:@"beaconId"];
        } else {
            if([ret respondsToSelector:NSSelectorFromString(key)]) {
                id val = [parsedObject valueForKey:key];
                if([val isKindOfClass:[NSNull class]]) {
                    val = nil; //I don't want no NSNull bs up in here
                }
            
                [ret setValue:val forKeyPath:key];
            }
        }
    }
    
    if(ret.beaconId == nil) {
        *error = [[NSError alloc] initWithDomain:@"KlickBeacon" code:1 userInfo:@{}];
        return nil;
    }
    
    return ret;
    
}
@end
