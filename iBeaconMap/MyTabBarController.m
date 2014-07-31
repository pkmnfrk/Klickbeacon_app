//
//  MyTabBarController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-11.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "MyTabBarController.h"

#import "iBeaconManager.h"
#import "KlickAPI.h"
#import "Preferences.h"

@interface MyTabBarController () <UITabBarControllerDelegate, iBeaconManagerDelegate>

@property (strong, nonatomic) UIImageView * bgImageView;
@property (strong, nonatomic) iBeaconManager * iBeaconManager;

@end

@implementation MyTabBarController



-(void)viewDidLoad
{
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    
    self.bgImageView.frame = self.view.bounds;
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bgImageView.contentMode = UIViewContentModeScaleToFill;

    
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    
    UITabBarItem * item;
    
    item = [self.tabBar.items objectAtIndex:0];
    item.image = [[UIImage imageNamed:@"iconMapInactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:@"iconMapActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    item = [self.tabBar.items objectAtIndex:1];
    item.image = [[UIImage imageNamed:@"iconFindInactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:@"iconFindActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    item = [self.tabBar.items objectAtIndex:2];
    item.image = [[UIImage imageNamed:@"iconSettingsInactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:@"iconSettingsActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    self.delegate = self;
    
    
    self.iBeaconManager = [[iBeaconManager alloc] init];
    self.iBeaconManager.delegate = self;
    
    NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"2f73d96d-f86e-4f95-b88d-694cefe5837f"];
    
    [self.iBeaconManager registerBeaconRegionWithUUID:uuid andIdentifier:@"Klick Beacon" options:ibeaconOptionMustBeClose];
    
    uuid = [[NSUUID alloc] initWithUUIDString:EXAMPLE_UUID];
    [self.iBeaconManager registerBeaconRegionWithUUID:uuid andIdentifier:@"Example Beacon" options:iBeaconOptionOnlyMonitorRegion | ibeaconOptionMustBeClose];
    
    [[KlickAPI default] setClientName:Preferences.userName];
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    /**/
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.bgImageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.bgImageView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    }
    else {
        self.bgImageView.transform = CGAffineTransformMakeRotation(0.0);
    }
    
    self.bgImageView.frame = self.view.bounds;
    /**/
    
    //self.bgImage
}

//to stop warnings about undefined selectors
-(void)notifySelect { }

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if([viewController respondsToSelector:@selector(notifySelect)]) {
        [viewController performSelector:@selector(notifySelect)];
    }
    
    return YES;
}

#pragma mark iBeaconManagerDelegate


-(void)iBeaconManager:(iBeaconManager *)manager didEnterRegion:(CLRegion *)region {
    if(![region isKindOfClass:[CLBeaconRegion class]]) return;
    
    CLBeaconRegion * beaconRegion = (CLBeaconRegion*)region;
    
    if(NSOrderedSame == [beaconRegion.proximityUUID.UUIDString caseInsensitiveCompare:KLICK_UUID]) {
    
        /*NSString * beaconText = [NSString stringWithFormat:@"Entered Klick Region"];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"iBeacon" message:beaconText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
         */
    } else if(NSOrderedSame == [beaconRegion.proximityUUID.UUIDString caseInsensitiveCompare:EXAMPLE_UUID]) {
        
        [self performSegueWithIdentifier:@"showExample" sender:nil];
        
    }
}

-(void)iBeaconManager:(iBeaconManager *)manager didExitRegion:(CLRegion *)region
{
    if(![region isKindOfClass:[CLBeaconRegion class]]) return;
    
    CLBeaconRegion * beaconRegion = (CLBeaconRegion*)region;
    
    if(NSOrderedSame == [beaconRegion.proximityUUID.UUIDString caseInsensitiveCompare:KLICK_UUID]) {
        
        /*NSString * beaconText = [NSString stringWithFormat:@"Exited Klick Region"];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"iBeacon" message:beaconText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
         */
    } else if(NSOrderedSame == [beaconRegion.proximityUUID.UUIDString caseInsensitiveCompare:EXAMPLE_UUID]) {
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

-(void)iBeaconManager:(iBeaconManager *)manager didChooseNewBestBeacon:(NumberTuple *)beacon inRegion:(CLRegion *)region
{
    if(![region isKindOfClass:[CLBeaconRegion class]]) return;
    
    CLBeaconRegion * beaconRegion = (CLBeaconRegion*)region;
    
    if(NSOrderedSame == [beaconRegion.proximityUUID.UUIDString caseInsensitiveCompare:KLICK_UUID]) {
    
        /*
        NSString * beaconText = [NSString stringWithFormat:@"Came near beacon %ld.%ld", (long)[beacon.item1 intValue], (long)[beacon.item2 intValue]];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"iBeacon" message:beaconText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
         */
        
        [[KlickAPI default] pingBeaconWithUUID:KLICK_UUID major:[beacon.item1 unsignedIntValue] minor:[beacon.item2 unsignedIntValue]];
    }
    
    
}


@end
