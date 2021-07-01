//
//  TweetDetailCell.h
//  twitter
//
//  Created by johnjakobsen on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TweetDetailCellDelegate

- (void) retweet: (NSInteger *) tweetRow;
- (void) favorite: (NSInteger *) tweetRow;

@end


@interface TweetDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) id<TweetDetailCellDelegate> delegate;
@property NSInteger *tweetRow;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
- (void) setWithTweet:(Tweet *)tweet;
@end

NS_ASSUME_NONNULL_END
