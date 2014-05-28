//
//  UIView+convertViewToImage.m
//  iBeaconMap
//
//  Created by Michael Caron on 2014-05-20.
//  Copyright (c) 2014 Klick. All rights reserved.
//

#import "UIView+convertViewToImage.h"

@implementation UIView (convertViewToImage)
-(UIImage *) convertViewToImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage * ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return ret;
}
@end
