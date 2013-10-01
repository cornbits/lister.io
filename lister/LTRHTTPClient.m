//
//  LTRHTTPClient.m
//  lister
//
//  Created by Geoff Cornwall on 7/31/13.
//  Copyright (c) 2013 Geoff Cornwall. All rights reserved.
//

#import "LTRHTTPClient.h"
#import "LTRUtility.h"

@implementation LTRHTTPClient {
	dispatch_queue_t _callbackQueue;
}

+ (LTRHTTPClient *)sharedInstance {
	static LTRHTTPClient *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});

	return sharedInstance;
}

+ (NSString *)apiVersion {
	return @"v2";
}

- (id)init {
    NSURL *base = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/", @"http", @"lister.io/api"]];
	
	if ((self = [super initWithBaseURL:base])) {
		// Use JSON
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:@"application/json"];
		
		_callbackQueue = dispatch_queue_create("com.lister.network-callback-queue", 0);
        
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"LTRHTTPClient: reachability changed: %d", status);
        }];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userLogin:(NSString *)username withPassword:(NSString *)password onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/login"];
    NSURL *url = [NSURL URLWithString:apiURL];
    NSString *parameters = [NSString stringWithFormat:@"user=%@&password=%@", username, password];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"userLogin: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"userLogin: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)getLists:(NSString *)listId withUserId:(NSString *)userId onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiURL;
    
    if (listId == nil && userId == nil) {
        apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists"];
    }
    else if (userId == nil) {
        apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists/%@", listId];
    }
    else {
        apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/users/%@/lists", userId];
    }
    
    NSURL *url = [NSURL URLWithString:apiURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getLists: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getLists: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    /**
    [operation setCompletionBlock:^{
         NSLog(@"%@", operation.responseString); //Gives a very scary warning
    }];
    **/
    
    [operation start];
}

- (void)getItems:(NSString *)listId onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists/%@", listId];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];

    NSLog(@"getItems: URL = %@", url);
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getItems: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getItems: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)addList:(NSString *)listText isOpen:(BOOL)open onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *openAsText = open ? @"true" : @"false";
    
    NSString *parameters = [NSString stringWithFormat:@"name=%@&open=%@", listText, openAsText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists"];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:apiToken forHTTPHeaderField:@"X-Login-Token"];
    [request setValue:userId forHTTPHeaderField:@"X-User-Id"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"addList: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"addList: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}


- (void)addItem:(NSString *)itemText forList:(LTRList *)list onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    NSString *parameters = [NSString stringWithFormat:@"text=%@&url=lister.io", itemText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists/%@/items", list.listId];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:apiToken forHTTPHeaderField:@"X-Login-Token"];
    [request setValue:userId forHTTPHeaderField:@"X-User-Id"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"addItem: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"addItem: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];

    [operation start];
}

- (void)deleteList:(NSString *)listId onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists/%@", listId];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:apiToken forHTTPHeaderField:@"X-Login-Token"];
    [request setValue:userId forHTTPHeaderField:@"X-User-Id"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"deleteList: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"deleteList: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)deleteItem:(NSString *)itemId onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/items/%@", itemId];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:apiToken forHTTPHeaderField:@"X-Login-Token"];
    [request setValue:userId forHTTPHeaderField:@"X-User-Id"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"deleteItem: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"deleteItem: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)editList:(LTRList *)list onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *openAsText = list.isOpen ? @"true" : @"false";
    
    NSString *parameters = [NSString stringWithFormat:@"{\"name\" : \"%@\" , \"open\" : %@}", list.listName, openAsText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/lists/%@?auth-token=%@",
                        list.listId, apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"editList: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"editList: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)editItem:(LTRItem *)item onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    
    NSString *parameters = [NSString stringWithFormat:@"{\"text\":\"%@\"}", item.itemText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/items/%@?auth-token=%@", item.itemId, apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"editItem: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"editItem: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

- (void)upDownVoteItem:(LTRItem *)item upVote:(BOOL)up onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *upVoteAsText = up ? @"up" : @"down";

    NSString *parameters = [NSString stringWithFormat:@"vote=%@", upVoteAsText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v2/items/%@", item.itemId];
    NSURL *url = [NSURL URLWithString:apiURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:apiToken forHTTPHeaderField:@"X-Login-Token"];
    [request setValue:userId forHTTPHeaderField:@"X-User-Id"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"upDownVoteItem: SUCCESS");
        completionBlock(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"upDownVoteItem: FAILURE");
        completionBlock(NO, [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

@end
