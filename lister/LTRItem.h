//
//  LTRItem.h
//  lister
//
//  Created by Geoff Cornwall on 8/14/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

@interface LTRItem : NSObject

@property (nonatomic) NSString *itemId;
@property (nonatomic) NSString *itemText;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *listId;
@property (nonatomic) NSString *listSlug;
@property (nonatomic) int score;
@property (nonatomic) NSString *itemUserId;
@property (nonatomic) NSString *itemUsername;
@property (nonatomic) NSDate *createdAt;

-(id)initWithData:(NSDictionary *)data;

@end
