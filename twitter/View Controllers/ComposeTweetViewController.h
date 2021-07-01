//
//  ComposeTweetViewController.h
//  twitter
//
//  Created by johnjakobsen on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeTweetViewControllerDelegate
- (void) didTweet: (Tweet *) tweet;

@end

@interface ComposeTweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (nonatomic, weak) id<ComposeTweetViewControllerDelegate> delegate;
@property (nonatomic, weak) NSString *tweetType;
@property (nonatomic, weak) NSString *replyUsername;
@property (nonatomic, weak) NSString *replyID;

@end

NS_ASSUME_NONNULL_END
