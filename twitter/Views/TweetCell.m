//
//  TweetCellTableViewCell.m
//  twitter
//
//  Created by johnjakobsen on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 23;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setWithTweet:(Tweet *)tweet {
    self.tweet = tweet;
    self.createdAtLabel.text = tweet.createdAtString;
    self.favoriteCountLabel.text = [NSString stringWithFormat: @"%d", tweet.favoriteCount ];
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text =  [NSString stringWithFormat:@"@%@", tweet.user.screenName ];
    self.tweetTextLabel.text = tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat: @"%d", tweet.retweetCount ];
    [self setFavorite: tweet.favorited];
    [self setRetweet: tweet.retweeted];
    //self.profileImage = nil;
    [self.profileImage setImageWithURL:[NSURL URLWithString: tweet.user.profilePicture] placeholderImage: [UIImage imageNamed:@"moment-icon"] ];
    
    
}

- (void) setFavorite: (BOOL) favorited {
    [self.favoriteButton setSelected: favorited];
    if (favorited) self.favoriteCountLabel.textColor = [[UIColor alloc] initWithRed:211.0/255.0 green:58.0/255.0 blue:79.0/255.0 alpha:1];
    else self.favoriteCountLabel.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
    
}

-(void) setRetweet: (BOOL) retweeted {
    [self.retweetButton setSelected:retweeted];
    if (retweeted) self.retweetCountLabel.textColor = [[UIColor alloc] initWithRed:95.0/255.0 green:204.0/255.0 blue:140.0/255.0 alpha:1];
    else self.retweetCountLabel.textColor = [[UIColor alloc] initWithRed:172.0/255.0 green:184.0/255.0 blue:193.0/255.0 alpha:1];
}
- (IBAction)onReply:(id)sender {
    NSLog(@"in the cell");
}


- (IBAction)onRetweet:(id)sender {
    //Send API Request
    self.tweet.retweeted = !self.tweet.retweeted;
    if (self.tweet.retweeted) self.tweet.retweetCount += 1;
    else self.tweet.retweetCount -= 1;
    [self setRetweet: self.tweet.retweeted];
    self.retweetCountLabel.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount ];
    if (self.tweet.retweeted) [[APIManager shared] retweet:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error retweeting tweet: %@", error.localizedDescription);
            self.tweet.retweeted = !self.tweet.retweeted;
            self.tweet.retweetCount -= 1;
            [self setRetweet: self.tweet.retweeted];
            self.retweetCountLabel.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount ];

        } else {
            NSLog(@"Retweeted Tweet successfully");

        }
    }];
    else [[APIManager shared] unretweet:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error unretweeting tweet: %@", error.localizedDescription);
            self.tweet.retweeted = !self.tweet.retweeted;
            self.tweet.retweetCount += 1;
            [self setRetweet: self.tweet.retweeted];
            self.retweetCountLabel.text = [NSString stringWithFormat: @"%d", self.tweet.retweetCount ];

        } else {
            NSLog(@"Unretweeted Tweet successfully");

        }
    }];
    
}

- (IBAction)onFavorite:(id)sender {
    //Send API Request
    self.tweet.favorited = !self.tweet.favorited;
    if (self.tweet.favorited) self.tweet.favoriteCount += 1;
    else self.tweet.favoriteCount -= 1;
    [self setFavorite: self.tweet.favorited];
    self.favoriteCountLabel.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];
    if (self.tweet.favorited) [[APIManager shared] favorite:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error favoriting tweet: %@", error.localizedDescription);
            self.tweet.favorited = !self.tweet.favorited;
            self.tweet.favoriteCount -= 1;
            [self setFavorite: self.tweet.favorited];
            self.favoriteCountLabel.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];

        } else {
            NSLog(@"Favorited Tweet successfully");

        }
    }];
    else [[APIManager shared] unfavorite:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"error unfavoriting tweet: %@", error.localizedDescription);
            self.tweet.favorited = !self.tweet.favorited;
            self.tweet.favoriteCount += 1;
            [self setFavorite: self.tweet.favorited];
            self.favoriteCountLabel.text = [NSString stringWithFormat: @"%d", self.tweet.favoriteCount];

        } else {
            NSLog(@"unFavorited Tweet successfully");

        }
    }];
    
}
@end
