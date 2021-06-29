//
//  TweetCellTableViewCell.m
//  twitter
//
//  Created by johnjakobsen on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setWithTweet:(Tweet *)tweet {
    self.createdAtLabel.text = tweet.createdAtString;
    self.favoriteCountLabel.text = [NSString stringWithFormat: @"%d", tweet.favoriteCount ];
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text =  [NSString stringWithFormat:@"@%@", tweet.user.screenName ];
    self.tweetTextLabel.text = tweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat: @"%d", tweet.retweetCount ];
    [self setFavorite: tweet.favorited];
    [self setRetweet: tweet.retweeted];
    
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
    //Send API Request

}

- (IBAction)onRetweet:(id)sender {
    //Send API Request
}

- (IBAction)onFavorite:(id)sender {
    //Send API Request

}
@end
