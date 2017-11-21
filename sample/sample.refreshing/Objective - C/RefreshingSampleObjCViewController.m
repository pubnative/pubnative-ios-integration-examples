//
//  RefreshingSampleObjCViewController.m
//  sample.refreshing
//
//  Created by Can Soykarafakili on 21.11.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

#import "RefreshingSampleObjCViewController.h"
#import <Pubnative/Pubnative.h>
#import "sample_refreshing-Swift.h"

@interface RefreshingSampleObjCViewController () <PNLayoutLoadDelegate, PNLayoutTrackDelegate>

@property (nonatomic, strong) PNSmallLayout *smallLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *smallAdContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation RefreshingSampleObjCViewController

- (void)dealloc
{
    self.smallLayout = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.smallLayout stopTrackingView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (IBAction)requestButtonTouchUpInside:(id)sender
{
    self.smallAdContainer.hidden = YES;
    [self.loadingIndicator startAnimating];
    if (self.smallLayout == nil) {
        self.smallLayout = [[PNSmallLayout alloc] init];
    }
    [self.smallLayout loadWithAppToken:[Settings appToken] placement:[Settings placement] delegate:self];
}

#pragma mark - Delegates -

#pragma mark PNLayoutLoadDelegate

- (void)layoutDidFinishLoading:(PNLayout *)layout
{
    NSLog(@"Layout loaded");
    
    if (self.smallLayout == layout) {
        self.smallAdContainer.hidden = NO;
        [self.loadingIndicator stopAnimating];
        self.smallLayout.trackDelegate = self;
        UIView *layoutView = self.smallLayout.viewController.view;
        [self.smallAdContainer addSubview:layoutView];
        [self.smallLayout startTrackingView];
        
        // You can access layout.viewController and customize the ad appearance with the predefined methods.
        
        if (self.timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[Settings repeatTime]
                                                          target:self
                                                        selector:@selector(requestButtonTouchUpInside:)
                                                        userInfo:nil
                                                         repeats:YES];
        }
    }
}

- (void)layout:(PNLayout *)layout didFailLoading:(NSError *)error
{
    [self.loadingIndicator stopAnimating];
    NSLog(@"Error: %@", error.localizedDescription);
}

#pragma mark PNLayoutTrackDelegate

- (void)layoutTrackImpression:(PNLayout *)layout
{
    NSLog(@"Layout impression tracked");
}

- (void)layoutTrackClick:(PNLayout *)layout
{
    NSLog(@"Layout click tracked");
    [self.timer invalidate];
    self.timer = nil;
}

@end
