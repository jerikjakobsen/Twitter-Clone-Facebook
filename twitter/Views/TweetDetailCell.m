//
//  TweetDetailCell.m
//  twitter
//
//  Created by johnjakobsen on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetDetailCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"


@implementation TweetDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setWithTweet:(Tweet *)tweet {
    self.tweet = tweet;
    self.createdAt.text = tweet.createdAtString;
    self.likeCount.text = [NSString stringWithFormat: @"%d", tweet.favoriteCount ];
    self.name.text = tweet.user.name;
    self.username.text =  [NSString stringWithFormat:@"@%@", tweet.user.screenName ];
    self.tweetText.text = tweet.text;
    self.retweetCount.text = [NSString stringWithFormat: @"%d", tweet.retweetCount ];
    [self.profilePic setImageWithURL:[NSURL URLWithString: tweet.user.profilePicture] placeholderImage: [UIImage imageNamed:@"moment-icon"] ];
    [self setFavorite: tweet.favorited];
    [self setRetweet: tweet.retweeted];
    
    //self.replyToLabel.text = NSString stringWithFormat:@"@%@"
}
- (IBAction)didRetweet:(id)sender {
    self.tweet.retweeted = !self.tweet.retweeted;
    if (self.tweet.retweeted) self.tweet.retweetCount += 1;
    else self.tweet.retweetCount -= 1;
    [self setRetweet: self.tweet.retweeted];
    self.retweetCount.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount ];
    if (self.tweet.retweeted) [[APIManager shared] retweet:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error retweeting tweet: %@", error.localizedDescription);
            self.tweet.retweeted = !self.tweet.retweeted;
            self.tweet.retweetCount -= 1;
            [self setRetweet: self.tweet.retweeted];
            self.retweetCount.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount ];

        } else {
            [self.delegate retweet: self.tweetRow];
            NSLog(@"Retweeted Tweet successfully");

        }
    }];
    else [[APIManager shared] unretweet:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error unretweeting tweet: %@", error.localizedDescription);
            self.tweet.retweeted = !self.tweet.retweeted;
            self.tweet.retweetCount += 1;
            [self setRetweet: self.tweet.retweeted];
            self.retweetCount.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount ];

        } else {
            [self.delegate retweet: self.tweetRow];
            NSLog(@"Unretweeted Tweet successfully");

        }
    }];
    
}
- (IBAction)didFavorite:(id)sender {
    self.tweet.favorited = !self.tweet.favorited;
    if (self.tweet.favorited) self.tweet.favoriteCount += 1;
    else self.tweet.favoriteCount -= 1;
    [self setFavorite: self.tweet.favorited];
    self.likeCount.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];
    if (self.tweet.favorited) [[APIManager shared] favorite:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error favoriting tweet: %@", error.localizedDescription);
            self.tweet.favorited = !self.tweet.favorited;
            self.tweet.favoriteCount -= 1;
            [self setFavorite: self.tweet.favorited];
            self.likeCount.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];

        } else {
            [self.delegate favorite: self.tweetRow];

            NSLog(@"Favorited Tweet successfully");

        }
    }];
    else [[APIManager shared] unfavorite:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error unfavoriting tweet: %@", error.localizedDescription);
            self.tweet.favorited = !self.tweet.favorited;
            self.tweet.favoriteCount += 1;
            [self setFavorite: self.tweet.favorited];
            self.likeCount.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];

        } else {
            [self.delegate favorite: self.tweetRow];

            NSLog(@"unFavorited Tweet successfully");

        }
    }];
}

- (void) setFavorite: (BOOL) favorited {
    [self.favoriteButton setSelected: favorited];
    if (favorited) self.likeCount.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:58.0/255.0 blue:79.0/255.0 alpha:1];
    else self.likeCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
    
}

-(void) setRetweet: (BOOL) retweeted {
    [self.retweetButton setSelected:retweeted];
    if (retweeted) self.retweetCount.textColor = [[UIColor alloc] initWithRed:95.0/255.0 green:204.0/255.0 blue:140.0/255.0 alpha:1];
    else self.retweetCount.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
}
@end
