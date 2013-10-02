//
//  LTRHTTPClient.h
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "AFNetworking.h"
#import "LTRList.h"
#import "LTRItem.h"

typedef void (^JSONResponseBlock)(BOOL success, NSDictionary* json);

@interface LTRHTTPClient : AFHTTPClient

+ (LTRHTTPClient *)sharedInstance;
+ (NSString *)apiVersion;

- (void)userLogin:(NSString *)username withPassword:(NSString *)password onCompletion:(JSONResponseBlock)completionBlock;
- (void)getLists:(NSString *)listId withUserId:(NSString *)userId onCompletion:(JSONResponseBlock)completionBlock;
- (void)getItems:(NSString *)listId onCompletion:(JSONResponseBlock)completionBlock;
- (void)addList:(NSString *)listText isOpen:(BOOL)open onCompletion:(JSONResponseBlock)completionBlock;
- (void)addItem:(NSString *)itemText withURL:(NSString *)itemURL forList:(LTRList *)list onCompletion:(JSONResponseBlock)completionBlock;
- (void)deleteList:(NSString *)listId onCompletion:(JSONResponseBlock)completionBlock;
- (void)deleteItem:(NSString *)itemId onCompletion:(JSONResponseBlock)completionBlock;
- (void)editList:(LTRList *)list onCompletion:(JSONResponseBlock)completionBlock;
- (void)editItem:(LTRItem *)item onCompletion:(JSONResponseBlock)completionBlock;
- (void)upDownVoteItem:(LTRItem *)item upVote:(BOOL)up onCompletion:(JSONResponseBlock)completionBlock;

@end
