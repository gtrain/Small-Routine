//
//  FriendsViewController.m
//  SinaWeiBoClient
//
//  Created by yzq on 13-6-28.
//  Copyright (c) 2013年 yzq. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
//    if (self.listType.selectedSegmentIndex==0) {
//        [notifCenter addObserver:self selector:@selector(gotFollowUserList:) name:MMSinaGotFollowingUserList object:nil];
//    }
//    else {
//        [notifCenter addObserver:self selector:@selector(gotFollowUserList:) name:MMSinaGotFollowedUserList object:nil];
//    }
//    [notifCenter addObserver:self selector:@selector(gotAvatar:) name:HHNetDataCacheNotification object:nil];
//    [notifCenter addObserver:self selector:@selector(gotFollowResult:) name:MMSinaFollowedByUserIDWithResult object:nil];
//    [notifCenter addObserver:self selector:@selector(gotUnfollowResult:) name:MMSinaUnfollowedByUserIDWithResult object:nil];
//    [notifCenter addObserver:self selector:@selector(mmRequestFailed:) name:MMSinaRequestFailed object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_listType release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setListType:nil];
    [super viewDidUnload];
}
@end
