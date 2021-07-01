//
//  Tweet.m
//  twitter
//
//  Created by johnjakobsen on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

@implementation Tweet
- (instancetype) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            
            dictionary = originalTweet;
        }
        
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Setting the date created property
        
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        
        
        self.createdAtString = date.shortTimeAgoSinceNow;
        
        
    }
    return self;
}

- (instancetype) initWithReplyDictionary: (NSDictionary *) dictionary {
    self = [super init];
    
    if (self) {
        NSDictionary *reply = dictionary[@"reply"];
        if (reply != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.user = [[User alloc] initWithReplyDictionary:userDictionary];
        }
        
        self.idStr = reply[@"author_id"];
        self.text = reply[@"text"];
        self.favoriteCount = [reply[@"public_metrics"][@"like_count"] intValue];
        self.favorited = FALSE;
        self.retweetCount = [reply[@"public_metrics"][@"retweet_count"] intValue];
        self.retweeted = FALSE;
        
        // Setting the date created property
        
        NSString *createdAtOriginalString = reply[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        
        
        self.createdAtString = date.shortTimeAgoSinceNow;
        
        
    }
    return self;
}


+ (NSMutableArray *) tweetsWithArray: (NSArray *) dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary: dictionary];
        [tweets addObject: tweet];
    }
    return tweets;
}
@end
