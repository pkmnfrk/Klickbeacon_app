//
//  DarkTransparentNavigationController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-11.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "DarkTransparentNavigationController.h"

#import "SlideLeftAnimationController.h"

@interface DarkTransparentNavigationController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>


@end

@implementation DarkTransparentNavigationController

-(void)viewDidLoad
{

    self.transitioningDelegate = self;
    self.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"I, a DarkTransparentNavigationController, have appeared!");
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPush) {
        return [SlideLeftAnimationController allocWithType:AnimationTypePresent curved:YES];
    } else if(operation == UINavigationControllerOperationPop) {
        return [SlideLeftAnimationController allocWithType:AnimationTypeDismiss curved:YES];
    }
    
    return nil;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"Did show a view controller inside a DarkTransparentNavigationController");
}


@end
