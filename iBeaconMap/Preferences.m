//
//  Preferences.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-24.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

+(NSString*)userName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
}

+(void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
}

+(NSString*)clientID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"clientID"];
}

+(void)setClientID:(NSString *)clientID
{
    [[NSUserDefaults standardUserDefaults] setValue:clientID forKey:@"clientID"];
}

@end
