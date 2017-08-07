//
//  MediumSampleObjCViewController.m
//  sample
//
//  Created by Can Soykarafakili on 04.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

#import "MediumSampleObjCViewController.h"
#import <Pubnative/Pubnative.h>
#import "sample_medium-Swift.h"

@interface MediumSampleObjCViewController () <PNLayoutLoadDelegate, PNLayoutTrackDelegate>

@property (nonatomic, strong) PNMediumLayout *mediumLayout;
@property (weak, nonatomic) IBOutlet UIView *mediumAdContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation MediumSampleObjCViewController

- (void)dealloc
{
    self.mediumLayout = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mediumLayout stopTrackingView];
}

- (IBAction)requestButtonTouchUpInside:(id)sender
{
    self.mediumAdContainer.hidden = YES;
    [self.loadingIndicator startAnimating];
    if (self.mediumLayout == nil) {
        self.mediumLayout = [[PNMediumLayout alloc] init];
    }
    self.mediumLayout.loadDelegate = self;
    [self.mediumLayout loadWithAppToken:[Settings appToken] placement:[Settings placement]];
}

#pragma mark - Delegates -

#pragma mark PNLayoutLoadDelegate

- (void)layoutDidFinishLoading:(PNLayout *)layout
{
    NSLog(@"Layout loaded");
    
    if (self.mediumLayout == layout) {
        self.mediumAdContainer.hidden = NO;
        [self.loadingIndicator stopAnimating];
        self.mediumLayout.trackDelegate = self;
        UIView *layoutView = self.mediumLayout.viewController.view;
        [self.mediumAdContainer addSubview:layoutView];
        [self.mediumLayout startTrackingView];
        
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
