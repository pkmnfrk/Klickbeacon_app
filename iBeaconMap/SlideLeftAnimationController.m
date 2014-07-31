
//
//  SlideLeftAnimationController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-07-23.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "SlideLeftAnimationController.h"

@interface SlideLeftAnimationController () {
    id<UIViewControllerContextTransitioning> _transitionContext;
}

@property BOOL curved;

@end

@implementation SlideLeftAnimationController

+(SlideLeftAnimationController *)allocWithType:(int)type curved:(BOOL)curved
{
    SlideLeftAnimationController * ret = nil;
    ret = [[SlideLeftAnimationController alloc] init];
    ret.type = type;
    ret.curved = curved;

    return ret;
    
    //NSLog(@"Initializing a SlideLeftAnimationController with type of %d", type);

}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView * containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _transitionContext = transitionContext;
    /*
    
    if(self.type == AnimationTypePresent)
    {
     */
        //to is the right-hand view
        //from is the left-hand view
        
        //toViewController.view.transform = CGAffineTransformMakeTranslation(fromViewController.view.bounds.size.width, 0);
        //fromViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);

    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    CGRect toViewFrame = toViewController.view.frame;
    CGRect fromViewFrame = fromViewController.view.frame;
    
    if(self.type == AnimationTypePresent) {
        toViewFrame.origin.x = fromViewController.view.bounds.size.width;
        fromViewFrame.origin.x =  0;
    } else if(self.type == AnimationTypeDismiss) {
        toViewFrame.origin.x = -fromViewController.view.bounds.size.width;
        fromViewFrame.origin.x =  0;
    }
    
    
    toViewController.view.frame = toViewFrame;
    fromViewController.view.frame = fromViewFrame;
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(self.type == AnimationTypeDismiss ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseInOut) animations:^{
        
        CGRect toViewFrame = toViewController.view.frame;
        CGRect fromViewFrame = fromViewController.view.frame;
        
        if(self.type == AnimationTypePresent) {
            toViewFrame.origin.x = 0;
            fromViewFrame.origin.x = -fromViewController.view.bounds.size.width;
        } else if(self.type == AnimationTypeDismiss) {
            toViewFrame.origin.x = 0;
            fromViewFrame.origin.x = fromViewController.view.bounds.size.width;
        }
        
        
        toViewController.view.frame = toViewFrame;
        fromViewController.view.frame = fromViewFrame;
        
    } completion:^(BOOL finished) {
        
        [_transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

@end
