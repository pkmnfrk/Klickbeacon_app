//
//  Beacon.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Beacon : NSObject
@property NSString* beaconId;
@property NSString* uuid;
@property NSInteger major;
@property NSInteger minor;
@property NSString* bodyText;
@property NSString* title;
@property NSString* image;
@property UIImage* uiImage;
-(NSDictionary*)toDictionary;
@end
