//
//  Preferences.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-24.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+(NSString*)userName;
+(void)setUserName:(NSString*)userName;

+(NSString*)clientID;
+(void)setClientID:(NSString*)clientID;

@end
