//
//  BeaconCommunicator.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-28.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "BeaconCommunicator.h"
#import "BeaconCommunicatorDelegate.h"
#import "BEacon.h"


@implementation BeaconCommunicator

-(void)fetchBeaconWithUUID:(NSUUID *)uuid major:(NSInteger)major minor:(NSInteger)minor {
    
    NSString * urlAsString = [NSString stringWithFormat:(BASEURL @"/beacon/flat/%@/%ld/%ld"), [[uuid UUIDString] lowercaseString], (long)major, (long)minor];
    NSURL * url = [[NSURL alloc] initWithString:urlAsString];
    
    NSLog(@"URL: %@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(self.delegate) {
            
            if(error) {
                [self.delegate fetchingBeaconFailedWithError:error];
            } else {
                [self.delegate receivedBeaconJSON:data];
            }
            
        }
        
    }];
}

-(void)fetchBeaconWithId:(NSString *)beaconid {
    NSString * urlAsString = [NSString stringWithFormat:(BASEURL @"/beacon/id/%@"),beaconid];
    NSURL * url = [[NSURL alloc] initWithString:urlAsString];
    
    NSLog(@"URL: %@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(self.delegate) {
            
            if(error) {
                [self.delegate fetchingBeaconFailedWithError:error];
            } else {
                [self.delegate receivedBeaconJSON:data];
            }
            
        }
        
    }];

}

-(void)fetchImageForBeacon:(Beacon*)beacon
{
    if(!beacon.image) {
        if(self.delegate) {
            [self.delegate imageLoadedForBeacon:beacon withError:nil];
        }
        return;
    }
    
    NSString * urlAsString = [NSString stringWithFormat:BASEURL @"%@", beacon.image];
    NSURL * url = [[NSURL alloc] initWithString:urlAsString];
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error)
        {
            if(self.delegate) {
                [self.delegate imageLoadedForBeacon:beacon withError:error];
            }
            return;
        }
        
        UIImage *img = [[UIImage alloc] initWithData:data];
        beacon.uiImage = img;
        
        if(self.delegate) {
            [self.delegate imageLoadedForBeacon:beacon withError:nil];
        }
    }];
}

@end
