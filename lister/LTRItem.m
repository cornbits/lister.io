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
        _itemId = [data objectForKey:@"_id"];
        _itemText = [data objectForKey:@"text"];
        _listId = [data objectForKey:@"listId"];
        _userId = [data objectForKey:@"userId"];
        _username = [data objectForKey:@"username"];
        _listSlug = [data objectForKey:@"listSlug"];
        _score = [data objectForKey:@"score"];
	}
	return self;
}

@end
