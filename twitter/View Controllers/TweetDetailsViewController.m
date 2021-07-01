//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by johnjakobsen on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"

@interface TweetDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) NSArray *replies;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[APIManager shared] getReplies:self.tweet completion:^(NSArray *repliesArray, NSError *error) {
        if (error != nil) NSLog(@"%@",error.localizedDescription);
            else {
                self.replies = repliesArray;
                [self.tweetsTableView reloadData];
            }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier: @"TweetCell"];
    User *user = [[User alloc] initWithReplyDictionary: self.replies[indexPath.row][@"user_info"] ];
    Tweet *tweet = [[Tweet alloc] initWithReplyDictionary:self.replies[indexPath.row][@"user_info"]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

@end
