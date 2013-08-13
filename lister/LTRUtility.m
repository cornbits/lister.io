//
//  LTRUtility.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRUtility.h"

@implementation LTRUtility

+ (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 128 / 256.0) + 0.33;
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (NSString *)slugName:(NSString *)name {
	name = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    return name;
}

@end
