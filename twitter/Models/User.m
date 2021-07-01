//
//  User.m
//  twitter
//
//  Created by johnjakobsen on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.profileBackgroundPicture = dictionary[@"profile_background_image_url_https"];
        
    }
    return self;
}

- (instancetype) initWithReplyDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"user_info"][@"name"];
        self.screenName = dictionary[@"user_info"][@"username"];
        self.profilePicture = dictionary[@"user_info"][@"profile_image_url"];
        self.profileBackgroundPicture = @"not available";
        
    }
    return self;
}
@end
