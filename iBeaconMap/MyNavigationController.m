//
//  MyNavigationController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "MyNavigationController.h"
#import "DetailViewAnimation.h"
#import "iBeaconManager.h"
#import "SlideLeftAnimationController.h"
#import "MapViewController.h"
#import "SwipeInteractionController.h"

@interface MyNavigationController () <UINavigationControllerDelegate, iBeaconManagerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic) BOOL isInteractive;

@end

@implementation MyNavigationController {
    SwipeInteractionController * _interactionController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transitioningDelegate = self;
    self.delegate = self;
    
    _interactionController = [SwipeInteractionController new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(viewController != [self.viewControllers firstObject]) { //don't attach it to the root view controller
        //[viewController.view addGestureRecognizer:self.gestureRecognizer];
        [_interactionController wireToViewController:viewController];
        
    }
    
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPush) {
        return [SlideLeftAnimationController allocWithType:AnimationTypePresent curved:YES];
    } else if(operation == UINavigationControllerOperationPop) {
        return [SlideLeftAnimationController allocWithType:AnimationTypeDismiss curved:!_interactionController.interactionInProgress];
    }
    
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
   
    return _interactionController.interactionInProgress ? _interactionController : nil;
    
}

-(void)notifySelect
{
    NSLog(@"Being notified about re-selection");
    
    [self popToRootViewControllerAnimated:YES];
    MapViewController * map = (MapViewController *)self.topViewController;
    [map loadMap];
}



@end
