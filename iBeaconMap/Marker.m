//
//  Marker.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-24.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "Marker.h"

@implementation Marker

+(void)loadMarker:(NSString *)markerId whenComplete:(void (^)(NSError*, Marker*))whenComplete
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASEURL @"map/marker/", markerId]];
    
    NSURLRequest * req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(error) {
            if(whenComplete) {
                whenComplete(error, nil);
                return;
            }
        }
        
        id q = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if(error) {
            if(whenComplete) {
                whenComplete(error, nil);
                return;
            }
        }
        
        Marker * marker = [Marker markerFromJSON:q];
        if(!marker) {
            if(whenComplete) {
                whenComplete([NSError errorWithDomain:@"KlickBeacon" code:3 userInfo:nil], nil);
                return;
            }
        }
        
        if(whenComplete) {
            whenComplete(nil, marker);
        }
    }];
     
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}

+(Marker *)markerFromJSON:(NSDictionary *)json
{
    Marker * ret = [[Marker alloc] init];
    
    ret.title = [json valueForKey:@"title"];
    ret._id = [json valueForKey:@"_id"];
    ret.body = [json valueForKey:@"copy"];
    ret.floor = [[json valueForKey:@"floor"] intValue];
    ret.widget = [json valueForKey:@"widget"];
    ret.images = [json valueForKey:@"images"];
    
    return ret;
}

-(NSDictionary*)toDictionary
{
    return @{
             @"_id": self._id,
             @"title": self.title,
             @"body": self.body,
             @"floor": [NSNumber numberWithInt:self.floor],
             @"widget": self.widget,
             @"images": self.images ?: [NSNull null],
            };
}
@end
