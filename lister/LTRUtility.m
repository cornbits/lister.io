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
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.66;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.33;
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

+ (NSString *) URLEncodeString:(NSString *)escaped {
    if ([escaped isEqual:[NSNull null]]) {
        escaped = @"";
    }
    
	escaped = [escaped stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"\t" withString:@"%09"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@")" withString:@"%29"];

	return escaped;
}

+ (NSString *) URLDecodeString:(NSString *)escaped {
    if ([escaped isEqual:[NSNull null]]) {
        escaped = @"";
    }
    
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%2C" withString:@","];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%3B" withString:@";"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%5C" withString:@"\\"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%09" withString:@"\t"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%3C" withString:@"<"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%3E" withString:@">"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%22" withString:@"\\"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%0A" withString:@"\n"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%21" withString:@"!"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%22" withString:@"\""];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%24" withString:@"$"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%25" withString:@"%"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%28" withString:@"("];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%29" withString:@")"];
	escaped = [escaped stringByReplacingOccurrencesOfString:@"%97" withString:@"—"];

	return escaped;
}


@end
