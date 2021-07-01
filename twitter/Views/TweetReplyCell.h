//
//  TweetReplyCell.h
//  twitter
//
//  Created by johnjakobsen on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetReplyCell : TweetCell
@property (weak, nonatomic) IBOutlet UILabel *replyToLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTo;
- (void) setWithTweet:(Tweet *)tweet;
@end

NS_ASSUME_NONNULL_END
