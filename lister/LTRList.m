//
//  LTRList.m
//  lister
//
//  Created by Geoff Cornwall on 8/14/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRList.h"

@implementation LTRList

- (id)initWithData:(NSDictionary *)data {
	self = [super init];
	if (self) {
        @try {
            _listId = [data objectForKey:@"_id"];
            _listName = [data objectForKey:@"name"];
            _userId = [data objectForKey:@"userId"];
            _username = [data objectForKey:@"username"];
            _slug = [data objectForKey:@"slug"];
            _createdAt = [data objectForKey:@"createdAt"];
            
            // big hackery to set isOpen because of different types coming back
            id isOpenValue = [data objectForKey:@"open"];
            if ([isOpenValue isKindOfClass:[NSNumber class]]) {
                _isOpen = [isOpenValue boolValue];
            }
            else if ([isOpenValue isKindOfClass:[NSString class]]) {
                if ([isOpenValue isEqualToString:@"true"]) _isOpen = TRUE; else _isOpen = FALSE;
            }
            else {
                _isOpen = FALSE;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"LTRList error: %@", exception);
            self = nil;
        }
	}
	return self;
}

@end
