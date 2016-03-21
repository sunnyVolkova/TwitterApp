//
//  SingleImageViewController2.m
//  TwitterApp
//
//  Created by Sunny on 21/03/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SingleImageViewController2.h"
#import "TwitterApp-Swift.h"

@interface SingleImageViewController2 ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *replyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *retweetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
- (IBAction)replyButtonPressed:(id)sender;
- (IBAction)retweetButtonPressed:(id)sender;
- (IBAction)favoriteButtonPressed:(id)sender;
@property Tweet *tweet;
@end
@implementation SingleImageViewController2

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (_imageUrl != NULL) {
        NSURL *url = [[NSURL alloc] initWithString: _imageUrl];
        [_imageView sd_setImageWithURL: url];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
    Tweet *tweet = [Tweet getTweetById: managedContext tweetId:_tweetId];
    if(tweet != NULL){
        _tweet = tweet;
        [self initButtonsWithTweet: tweet];
    }
}

- (void) initButtonsWithTweet: (Tweet*) tweet {
    if([tweet.favorited intValue] == 1){
        _favoriteButton.title = @"UnFavorite";
    } else {
        _favoriteButton.title = @"Favorite";
    }
    if([tweet.retweeted intValue] == 1){
        _retweetButton.title = @"UnRetweet";
    } else {
        _retweetButton.title = @"Retweet";
    }
}

- (IBAction)replyButtonPressed:(id)sender {
    if(_tweet == NULL){
        return;
    }
    
    if([_tweet.retweeted intValue] == 1){
        void (^successBlock)(void) = ^{
            self.tweet.retweeted = 0;
        };
        void (^failureBlock)(NSError*) = ^(NSError *error){
            NSLog(@"failure");
        };
        [NetworkServiceBridge sendUnRetweet: _tweetId success: successBlock failure: failureBlock];
    } else {
        
    }
}

- (IBAction)retweetButtonPressed:(id)sender {
    if(_tweet == NULL){
        return;
    }
    void (^failureBlock)(NSError*) = ^(NSError *error){
        NSLog(@"failure");
    };
    if([_tweet.retweeted intValue] == 1){
        void (^successBlock)(void) = ^{
            [self.tweet setRetweeted: [NSNumber numberWithInt:0]];
            [self initButtonsWithTweet: _tweet];
        };
        [NetworkServiceBridge sendUnRetweet: _tweetId success: successBlock failure: failureBlock];
    } else {
        void (^successBlock)(void) = ^{
            [self.tweet setRetweeted: [NSNumber numberWithInt:1]];
            [self initButtonsWithTweet: _tweet];
        };
        [NetworkServiceBridge sendRetweet: _tweetId success: successBlock failure: failureBlock];
    }
}

- (IBAction)favoriteButtonPressed:(id)sender {
    if(_tweet == NULL){
        return;
    }
    void (^failureBlock)(NSError*) = ^(NSError *error){
        NSLog(@"failure");
    };
    if([_tweet.favorited intValue] == 1){
        void (^successBlock)(void) = ^{
            [self.tweet setFavorited: [NSNumber numberWithInt:0]];
            [self initButtonsWithTweet: _tweet];
        };
        [NetworkServiceBridge sendUnFavorite: _tweetId success: successBlock failure: failureBlock];
    } else {
        void (^successBlock)(void) = ^{
            [self.tweet setFavorited: [NSNumber numberWithInt:1]];
            [self initButtonsWithTweet: _tweet];
        };
        [NetworkServiceBridge sendFavorite: _tweetId success: successBlock failure: failureBlock];
    }
}
@end
