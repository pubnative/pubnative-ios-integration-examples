//
//  NativeSampleObjCViewController.m
//  sample
//
//  Created by Can Soykarafakili on 07.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

#import "NativeSampleObjCViewController.h"
#import <Pubnative/Pubnative.h>
#import "sample_native-Swift.h"

@interface NativeSampleObjCViewController () <PNRequestDelegate, PNAdModelDelegate>

@property (nonatomic, strong) PNRequest *request;
@property (weak, nonatomic) IBOutlet UIView *adContainer;
@property (weak, nonatomic) IBOutlet UIImageView *adIcon;
@property (weak, nonatomic) IBOutlet UILabel *adTitle;
@property (weak, nonatomic) IBOutlet PNStarRatingView *adRating;
@property (weak, nonatomic) IBOutlet UIImageView *adBanner;
@property (weak, nonatomic) IBOutlet UILabel *adDescription;
@property (weak, nonatomic) IBOutlet UIButton *adCTA;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation NativeSampleObjCViewController

- (void)dealloc
{
    self.request = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.adContainer.hidden = YES;
}

- (IBAction)requestButtonTouchUpInside:(id)sender
{
    self.adContainer.hidden = YES;
    [self.loadingIndicator startAnimating];
    if (self.request == nil) {
        self.request = [[PNRequest alloc] init];
    }
    [self.request startWithAppToken:[Settings appToken] placementName:[Settings placement] delegate:self];
}

- (void)render:(PNAdModel *)ad
{
    PNAdModelRenderer *renderer = [[PNAdModelRenderer alloc] init];
    renderer.titleView = self.adTitle;
    renderer.descriptionView = self.adDescription;
    renderer.iconView = self.adIcon;
    renderer.bannerView = self.adBanner;
    renderer.starRatingView = self.adRating;
    renderer.callToActionView = self.adCTA;
    
    [ad renderAd:renderer];
    [ad startTrackingView:self.adContainer withViewController:self];
    
    self.adContainer.hidden = NO;
    [self.loadingIndicator stopAnimating];
}

#pragma mark - Delegates -

#pragma mark PNRequestDelegate

- (void)pubnativeRequestDidStart:(PNRequest *)request
{
    NSLog(@"Request started");

}

- (void)pubnativeRequest:(PNRequest *)request didLoad:(PNAdModel *)ad
{
    NSLog(@"Request loaded");
    ad.delegate = self;
    [self render:ad];
}

- (void)pubnativeRequest:(PNRequest *)request didFail:(NSError *)error
{
    [self.loadingIndicator stopAnimating];
    NSLog(@"Error: %@", error.localizedDescription);
}

#pragma mark PNAdModelDelegate

- (void)pubantiveAdDidConfirmImpression:(PNAdModel *)ad
{
    NSLog(@"Ad impression confirmed");
}

- (void)pubnativeAdDidClick:(PNAdModel *)ad
{
    NSLog(@"Ad click tracked");

}

@end
