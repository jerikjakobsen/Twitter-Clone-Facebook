//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"consumer_key"];
    NSString *secret = [dict objectForKey:@"consumer_secret"];
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    NSDictionary *parameters = @{@"tweet.fields": @"conversation_id"};
    [self GET:@"1.1/statuses/home_timeline.json"
       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           // Success
           NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];

        //NSLog(@"%@", tweetDictionaries[0]);
           completion(tweets, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
    }];
}

- (void) favorite: (Tweet *) tweet completion: (void (^)(Tweet *, NSError *)) completion {
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST: urlString parameters: parameters progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void) retweet: (Tweet *) tweet completion: (void (^)(Tweet *, NSError *)) completion {
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.idStr];
    NSDictionary *parameters = @{@"id": tweet.idStr};

    [self POST: urlString parameters: parameters progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void) unfavorite: (Tweet *) tweet completion: (void (^)(Tweet *, NSError *)) completion {
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST: urlString parameters: parameters progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


- (void) unretweet: (Tweet *) tweet completion: (void (^)(Tweet *, NSError *)) completion {
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.idStr];
    [self POST: urlString parameters: nil progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure: ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void) postStatusWithText: (NSString *) text completion: (void (^) (Tweet *, NSError *)) completion {
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable tweetDictionary) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary: tweetDictionary];
            completion(tweet, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
}


- (void) getTweetConversationID:(Tweet *)tweet completion:(void (^)(NSString *, NSError *))completion {
    NSString *urlString = @"2/tweets";
    NSDictionary *parameters = @{@"ids": @"1410264579024822279", @"tweet.fields": @"conversation_id"};
    [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable tweetDictionary) {
            completion(tweetDictionary[@"data"][0][@"conversation_id"], nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
    
}

- (void) getReplies:(Tweet *)tweet completion:(void (^)(NSArray *, NSError *))completion {
    [self getTweetConversationID:tweet completion:^(NSString *conversationID, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed at getTweetConversationID %@", error.localizedDescription);
            completion(nil, error);
        } else {
            [self getRepliesWithID:conversationID completion:^(NSDictionary *dataDict, NSError *error) {
                if (error != nil) {
                    NSLog(@"%@",error.localizedDescription);
                    completion(nil, error);
                } else {
                    NSDictionary *users = [[NSDictionary alloc] init];
                    for (NSDictionary *user in dataDict[@"includes"][@"users"]) {
                        [users setValue: user forKey: user[@"id"]];
                    }
                    for (NSDictionary *reply in dataDict[@"data"]) {
                        NSDictionary *userInfo = reply[@"author_id"];
                        
                    }
                    completion(dataDict[@"data"], error);
                }
            }];
        }
    }];
    
}

- (void) getRepliesWithID: (NSString *) tweetID completion:(void (^)(NSDictionary *dataDict, NSError *))completion {
    NSString *urlString = @"2/tweets/search/recent";
    NSDictionary *parameters = @{@"query":[NSString stringWithFormat:@"conversation_id:%@", tweetID], @"tweet.fields": @"in_reply_to_user_id,author_id,created_at,conversation_id", @"expansions":@"author_id", @"user.fields": @"name,username,created_at,profile_image_url"};
    NSLog(@"%@", parameters);
    [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable tweetDictionary) {
        NSLog(@"%@", tweetDictionary);
        completion(tweetDictionary, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
}
@end
