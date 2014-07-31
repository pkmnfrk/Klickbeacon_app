//
//  PulseLogoSegue.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-11.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "PulseLogoSegue.h"

@implementation PulseLogoSegue

-(void)perform
{
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    UINavigationController *navigationController = sourceViewController.navigationController;
    // Pop to root view controller (not animated) before pushing
    
    
    [navigationController popToRootViewControllerAnimated:NO];
    [navigationController setViewControllers:@[destinationController] animated:YES];
}

@end
