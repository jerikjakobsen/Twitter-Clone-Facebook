//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeTweetViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeTweetViewController.h"

@interface TimelineViewController () <ComposeTweetViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (nonatomic, strong) NSMutableArray* arrayOfTweets;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetsTableView.delegate = self;
    self.tweetsTableView.dataSource = self;
    
    // Get timeline
    [self loadTweets];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action: @selector(loadTweets:) forControlEvents: UIControlEventValueChanged];
    [self.tweetsTableView insertSubview:refreshControl atIndex:0];
}

- (void) loadTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {

            self.arrayOfTweets = [[NSMutableArray alloc] initWithArray:tweets];
            [[APIManager shared] getReplies: self.arrayOfTweets[0] completion:^(NSArray *replyArray, NSError *error) {
                            if (error != nil) {
                                NSLog(@"%@",error.localizedDescription);
                            } else {
                                NSLog(@"%@", replyArray);
                            }
            }];
            [self.tweetsTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void) loadTweets:(UIRefreshControl *) refreshControl {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");

            self.arrayOfTweets = [[NSMutableArray alloc] initWithArray:tweets];
            [self.tweetsTableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    appDelegate.window.rootViewController = loginVC;
    [[APIManager shared] logout];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"toComposeTweet"] ) {

        UINavigationController *navigationController = [segue destinationViewController];
        ComposeTweetViewController *CTVC = (ComposeTweetViewController *) navigationController.topViewController;
        CTVC.delegate = self;

    }
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [self.tweetsTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    [cell setWithTweet: self.arrayOfTweets[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tweetsTableView reloadData];
}

@end
