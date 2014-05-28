//
//  DetailViewController.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+hp_layoutGuideFix.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

BOOL stop = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.backgroundImageView.image = self.backgroundViewImage;
    self.navigationController.navigationBarHidden = NO;

}


-(void)viewWillAppear:(BOOL)animated {
    //NSLog(@"self.navigationController.navigationBar: %@", self.navigationController.navigationBar);
}

-(void)viewWillLayoutSubviews{
    //NSLog(@"viewWillLayoutSubviews TopLayoutGuide: %f", self.topLayoutGuide.length);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //NSLog(@"didRotateFromInterfaceOrientation TopLayoutGuide: %f", self.topLayoutGuide.length);
    
}

-(void)viewWillDisappear:(BOOL)animated {
    stop = YES;
}


-(void) viewDidAppear:(BOOL)animated {
    [self.view layoutIfNeeded];
    [self.navigationController.view layoutIfNeeded];
    //NSLog(@"viewDidAppear TopLayoutGuide: %f", self.topLayoutGuide.length);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)hp_usesTopLayoutGuideInConstraints
{
    return YES;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    id<UILayoutSupport> topLayoutGuide = self.hp_topLayoutGuide;
    id<UILayoutSupport> bottomLayoutGuide = self.bottomLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _textView, topLayoutGuide, bottomLayoutGuide);
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][_imageView]-8-[_textView][bottomLayoutGuide]" options:0 metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
