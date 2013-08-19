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
	return @"v1";
}

- (id)init {
	NSURL *base = nil;
	NSString *version = [[self class] apiVersion];
    
    base = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@/", @"http", @"lister.io/api", version]];
	
	if ((self = [super initWithBaseURL:base])) {
		// Use JSON
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:@"application/json"];
		
		_callbackQueue = dispatch_queue_create("com.lister.network-callback-queue", 0);
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getLists:(NSString *)apiToken onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/lists?auth-token=%@", apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getLists: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getItems: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    /**
    [operation setCompletionBlock:^{
         NSLog(@"%@", operation.responseString); //Gives a very scary warning
    }];
    **/
    
    [operation start];
}

- (void)getItems:(NSString *)listID onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/items?auth-token=%@", apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getItems: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getItems: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    [operation start];
}

- (void)addList:(NSString *)listText isOpen:(BOOL)open onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *openAsText = open ? @"true" : @"false";
    
    NSString *parameters = [NSString stringWithFormat:@"{\"name\" : \"%@\" , \"open\" : \"%@\" , \"userId\" : \"%@\" , \"username\" : \"%@\" , \"slug\" : \"%@\"}", listText, openAsText, userId, username, [LTRUtility slugName:listText]];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/lists?auth-token=%@", apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"addList: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"addList: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    [operation start];
}


- (void)addItem:(NSString *)itemText forList:(LTRList *)list onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

    NSString *parameters = [NSString stringWithFormat:@"{\"userId\":\"%@\",\"listId\":\"%@\",\"username\":\"%@\",\"listSlug\":\"%@\",\"text\":\"%@\"}", userId, list.listId, username, [LTRUtility slugName:list.listName], itemText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/items/%@?auth-token=%@", list.listId, apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"addItem: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"addItem: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];

    [operation start];
}

- (void)deleteList:(NSString *)listId onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *parameters = [NSString stringWithFormat:@"{\"_id\" : \"%@\"}", listId];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/lists/%@?auth-token=%@", listId, apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"deleteList: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"deleteList: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    [operation start];
}

- (void)deleteItem:(NSString *)itemId onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *parameters = [NSString stringWithFormat:@"{\"_id\" : \"%@\"}", itemId];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/items/%@?auth-token=%@", itemId, apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"deleteItem: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"deleteItem: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    [operation start];
}

- (void)editList:(LTRList *)list onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    NSString *openAsText = list.isOpen ? @"true" : @"false";
    
    NSString *parameters = [NSString stringWithFormat:@"{\"name\" : \"%@\" , \"open\" : %@}", list.listName, openAsText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/lists/%@?auth-token=%@",
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
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"editList: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    [operation start];
}

- (void)editItem:(LTRItem *)item onCompletion:(JSONResponseBlock)completionBlock {
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    
    NSString *parameters = [NSString stringWithFormat:@"{\"text\":\"%@\"}", item.itemText];
    NSData *postData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
    NSString *apiURL = [NSString stringWithFormat:@"http://lister.io/api/v1/items/%@?auth-token=%@", item.itemId, apiToken];
    NSURL *url = [NSURL URLWithString:apiURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"editItem: SUCCESS");
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"editItem: FAILURE");
        completionBlock([NSArray arrayWithObject:[error localizedDescription]]);
    }];
    
    [operation start];
}

@end
