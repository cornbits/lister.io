//
//  LTRHTTPClient.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "AFNetworking.h"

typedef void (^JSONResponseBlock)(NSArray* json);

@interface LTRHTTPClient : AFHTTPClient

+ (LTRHTTPClient *)sharedInstance;
+ (NSString *)apiVersion;

- (void)getLists:(NSString *)apiToken onCompletion:(JSONResponseBlock)completionBlock;
- (void)getItems:(NSString *)listID onCompletion:(JSONResponseBlock)completionBlock;
- (void)addList:(NSString *)listText isOpen:(BOOL)open onCompletion:(JSONResponseBlock)completionBlock;
- (void)addItem:(NSString *)itemText withListId:(NSString *)listId withListName:(NSString *)listName onCompletion:(JSONResponseBlock)completionBlock;
- (void)deleteList:(NSString *)listId onCompletion:(JSONResponseBlock)completionBlock;
- (void)deleteItem:(NSString *)itemId onCompletion:(JSONResponseBlock)completionBlock;

@end
