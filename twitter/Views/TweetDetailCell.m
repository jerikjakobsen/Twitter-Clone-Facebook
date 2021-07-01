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
    
    
    //self.replyToLabel.text = NSString stringWithFormat:@"@%@"
}
@end
