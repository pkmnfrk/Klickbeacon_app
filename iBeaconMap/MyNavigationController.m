//
//  MyNavigationController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "MyNavigationController.h"
#import "DetailViewAnimation.h"

@interface MyNavigationController () <UINavigationControllerDelegate>

@property (strong, nonatomic) DetailViewAnimation * pushAnimator;
@property (strong, nonatomic) DetailViewAnimation * popAnimator;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer * gestureRecognizer;
@property (nonatomic) BOOL isInteractive;

@end

@implementation MyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pushAnimator = [[DetailViewAnimation alloc] initWithDirection:YES];
    self.popAnimator = [[DetailViewAnimation alloc] initWithDirection:NO];
    self.delegate = self;
    
    self.gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.gestureRecognizer.edges = UIRectEdgeLeft;
    //[self.view addGestureRecognizer:self.gestureRecognizer];
    
    self.isInteractive = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(viewController != [self.viewControllers firstObject]) { //don't attach it to the root view controller
        [viewController.view addGestureRecognizer:self.gestureRecognizer];
    }
    
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPush){
        return self.pushAnimator;
    } else if(operation == UINavigationControllerOperationPop) {
        return self.popAnimator;
    }
    
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if(self.isInteractive && animationController == self.popAnimator) {
        return self.popAnimator;
    }
    return nil;
}


-(void)handleGesture:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer
{
    //    NSLog(@"Gesture: %ld", gestureRecognizer.state);
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.isInteractive = YES;
        self.popAnimator.gestureRecognizer = self.gestureRecognizer;
        [self popViewControllerAnimated:YES];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.isInteractive = NO;
    }
}



@end
