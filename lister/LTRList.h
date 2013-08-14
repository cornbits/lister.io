//
//  LTRList.h
//  lister
//
//  Created by Geoff Cornwall on 8/14/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

@interface LTRList : NSObject

@property (nonatomic) NSString *listId;
@property (nonatomic) NSString *listName;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *username;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSDate *createdAt;

-(id)initWithData:(NSDictionary *)data;

@end
