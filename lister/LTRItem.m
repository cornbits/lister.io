//
//  LTRItem.m
//  lister
//
//  Created by Geoff Cornwall on 8/14/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRItem.h"

@implementation LTRItem

- (id)initWithData:(NSDictionary *)data {
	self = [super init];
	if (self) {
        @try {
            _itemId = [data objectForKey:@"id"];
            _itemText = [data objectForKey:@"text"];
            _url = [data objectForKey:@"url"];
            _listId = [data objectForKey:@"listId"];
            _itemUserId = [data objectForKey:@"itemUserId"];
            _itemUsername = [data objectForKey:@"itemUsername"];
            _listSlug = [data objectForKey:@"listSlug"];
            _score = [[data objectForKey:@"score"] intValue];
            _createdAt = [data objectForKey:@"createdAt"];
        }
        @catch (NSException *exception) {
            NSLog(@"LTRItem error: %@", exception);
            self = nil;
        }
	}
	return self;
}

@end
