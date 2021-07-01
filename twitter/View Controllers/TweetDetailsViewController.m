//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by johnjakobsen on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "APIManager.h"
#import "TweetReplyCell.h"
#import "TweetDetailCell.h"
#import "Tweet.h"
#import "User.h"
#import "TimelineViewController.h"

@interface TweetDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) NSArray *replies;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;
    [[APIManager shared] getReplies:self.tweet completion:^(NSArray *repliesArray, NSError *error) {
        if (error != nil) NSLog(@"%@",error.localizedDescription);
            else {
                self.replies = repliesArray;
                [self.tweetsTableView reloadData];
            }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        TweetDetailCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:@"TweetDetailCell"];
        [cell setWithTweet:self.tweet];
        cell.delegate = self.TVC;
        cell.tweetRow = self.tweetRow;
        return cell;
    } else {
        TweetReplyCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier: @"TweetReplyCell"];
        Tweet *tweet = [[Tweet alloc] initWithReplyDictionary:self.replies[indexPath.row]];
        [cell setWithTweet: tweet];
        cell.replyTo.text = [NSString stringWithFormat:@"Replying to @%@", self.tweet.user.screenName ];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) return self.replies.count;
    else return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
@end
