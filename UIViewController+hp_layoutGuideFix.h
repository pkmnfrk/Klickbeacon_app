//
//  UIViewController+hp_layoutGuideFix.h
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-21.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (hp_layoutGuideFix)

@property (nonatomic, readonly) BOOL hp_usesTopLayoutGuideInConstraints;

@property (nonatomic, strong) id<UILayoutSupport> hp_topLayoutGuide;

@end
