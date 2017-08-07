//
//  SmallSampleObjCViewController.m
//  sample
//
//  Created by Can Soykarafakili on 03.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

#import "SmallSampleObjCViewController.h"
#import <Pubnative/Pubnative.h>
#import "sample_small-Swift.h"

@interface SmallSampleObjCViewController () <PNLayoutLoadDelegate, PNLayoutTrackDelegate>

@property (nonatomic, strong) PNSmallLayout *smallLayout;
@property (weak, nonatomic) IBOutlet UIView *smallAdContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation SmallSampleObjCViewController

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

- (IBAction)requestButtonTouchUpInside:(id)sender
{
    self.smallAdContainer.hidden = YES;
    [self.loadingIndicator startAnimating];
    if (self.smallLayout == nil) {
        self.smallLayout = [[PNSmallLayout alloc] init];
    }
    self.smallLayout.loadDelegate = self;
    [self.smallLayout loadWithAppToken:[Settings appToken] placement:[Settings placement]];
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
}

@end
