//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by johnjakobsen on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "Tweet.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeTweetViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;

@end

@implementation ComposeTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePic.layer.cornerRadius = 23;

    [[APIManager shared] getProfile:^(User *user, NSError *error) {
            if (error != nil){
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSURL *urlString = [NSURL URLWithString: user.profilePicture];
                [self.profilePic setImageWithURL: urlString];
            }
    }];
    self.tweetTextView.layer.cornerRadius = 10;
    self.tweetTextView.layer.borderWidth = 2;
    self.tweetTextView.delegate = self;
    [self.tweetTextView becomeFirstResponder];
    if (@available(iOS 13.0, *)) {
        self.tweetTextView.layer.borderColor = CGColorCreateGenericRGB(47/255.0, 124/255.0, 246/255.0, 1);
    } else {
        // Fallback on earlier versions

    }
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textViewDidChange:(UITextView *)textView {
    self.charactersRemainingLabel.text = [NSString stringWithFormat:@"%ld", 280 - self.tweetTextView.text.length ];
    self.tweetTextView.layer.borderColor = CGColorCreateGenericRGB(47/255.0, 124/255.0, 246/255.0, 1);
    if (self.tweetTextView.text.length == 280) [self.tweetTextView setTintColor: UIColor.redColor];
    else [self.tweetTextView setTintColor: UIColor.blackColor];
    
}



- (IBAction)didTapTweet:(id)sender {
    if (self.tweetTextView.text.length == 0) {
        [UIView animateWithDuration: 2 animations:^{
            self.tweetTextView.layer.borderColor = CGColorCreateGenericRGB(1, 0, 20/255.0, 1);
        }];
    } else {
        if ([self.tweetType isEqualToString: @"newTweet"]) {
            [[APIManager shared] postStatusWithText: self.tweetTextView.text completion:^(Tweet *tweet, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                        } else {
                            [self.delegate didTweet:tweet];
                            [self dismissViewControllerAnimated:true completion:nil];
                        }
            }];
        } else if ([self.tweetType isEqualToString: @"reply"]) {
            [[APIManager shared] postReplyWithText: self.tweetTextView.text replyToUsername: self.replyUsername replyID: self.replyID completion:^(Tweet *tweet, NSError *error) {
                            if (error != nil) {
                                NSLog(@"%@", error.localizedDescription);
                            } else {
                                NSLog(@"IT WORKS");
                                [self.delegate didTweet:tweet];
                                [self dismissViewControllerAnimated:true completion:nil];
                            }
            }];
        }
    }
}
- (IBAction)didCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString: text];
    
    return newText.length <281;
}

@end
