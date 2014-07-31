//
//  Marker.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-24.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marker : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSString* body;
@property (nonatomic) NSInteger floor;
@property (nonatomic) NSDictionary* widget;
@property (strong, nonatomic) NSArray* images;


+(void)loadMarker:(NSString*)markerId whenComplete:(void (^)(NSError*, Marker*))whenComplete;
+(Marker*)markerFromJSON:(NSDictionary*)json;

-(NSDictionary*)toDictionary;

@end
