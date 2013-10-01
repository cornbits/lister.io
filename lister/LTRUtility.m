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
//    CGFloat hue = (arc4random() % 128 / 256.0) + 0.33;
//    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
//    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (NSString *)slugName:(NSString *)name {
	name = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    return name;
}

+ (NSString *)dateAsString:(NSDate *)date {
    if ([date isEqual:[NSNull null]]) {
        return @"some time ago";
    }
    if (date == nil) {
        return @"some time ago";
    }
    
    NSString *returnDateString;
    NSString *tmpDate = [NSString stringWithFormat:@"%@", date];
    
    NSDateFormatter *dateFM = [[NSDateFormatter alloc] init];
    [dateFM setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [dateFM setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *postDate = [dateFM dateFromString:tmpDate];
    
    float secondsOfPostDateSinceNow = [postDate timeIntervalSinceNow];
    secondsOfPostDateSinceNow = -secondsOfPostDateSinceNow;

    if (secondsOfPostDateSinceNow < 60) {
        returnDateString = @"less than a minute ago";
    }
    else if (secondsOfPostDateSinceNow < 3600) {
        int numberOfMinutes = secondsOfPostDateSinceNow / 60;
        returnDateString = [NSString stringWithFormat:@"%i minute ago", numberOfMinutes];
    }
    else if (secondsOfPostDateSinceNow < 86400) {
        int numberOfHours = secondsOfPostDateSinceNow / 3600;
        returnDateString = [NSString stringWithFormat:@"%i hour ago", numberOfHours];
    }
    else {
        int numberOfDays = secondsOfPostDateSinceNow / 86400;
        returnDateString = [NSString stringWithFormat:@"%i days ago", numberOfDays];
    }
    
    return returnDateString;
}

@end
