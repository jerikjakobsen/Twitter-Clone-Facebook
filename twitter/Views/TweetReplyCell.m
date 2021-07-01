//
//  TweetReplyCell.m
//  twitter
//
//  Created by johnjakobsen on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetReplyCell.h"

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
    [super setWithTweet: tweet];
    
    //self.replyToLabel.text = NSString stringWithFormat:@"@%@"
}

@end
