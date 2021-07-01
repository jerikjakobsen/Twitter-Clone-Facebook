//
//  TweetReplyCell.m
//  twitter
//
//  Created by johnjakobsen on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetReplyCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetReplyCell

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
    self.createdAtLabel.text = tweet.createdAtString;
    self.favoriteCountLabel.text = [NSString stringWithFormat: @"%d", tweet.favoriteCount ];
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text =  [NSString stringWithFormat:@"@%@", tweet.user.screenName ];
    self.tweetTextLabel.text = tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat: @"%d", tweet.retweetCount ];
    [self.profileImage setImageWithURL:[NSURL URLWithString: tweet.user.profilePicture] placeholderImage: [UIImage imageNamed:@"moment-icon"] ];
    
    
    //self.replyToLabel.text = NSString stringWithFormat:@"@%@"
}

@end
