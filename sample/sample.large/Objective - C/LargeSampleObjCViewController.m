//
//  LargeSampleObjCViewController.m
//  sample
//
//  Created by Can Soykarafakili on 04.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

#import "LargeSampleObjCViewController.h"
#import <Pubnative/Pubnative.h>
#import "sample_large-Swift.h"

@interface LargeSampleObjCViewController () <PNLayoutLoadDelegate, PNLayoutTrackDelegate, PNLayoutViewDelegate>

@property (nonatomic, strong) PNLargeLayout *largeLayout;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation LargeSampleObjCViewController

- (void)dealloc
{
    self.largeLayout = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)requestButtonTouchUpInside:(id)sender
{
    [self.loadingIndicator startAnimating];
    if (self.largeLayout == nil) {
        self.largeLayout = [[PNLargeLayout alloc] init];
    }
    self.largeLayout.loadDelegate = self;
    [self.largeLayout loadWithAppToken:[Settings appToken] placement:[Settings placement]];
}

#pragma mark - Delegates -

#pragma mark PNLayoutLoadDelegate

- (void)layoutDidFinishLoading:(PNLayout *)layout
{
    NSLog(@"Layout loaded");
    
    if (self.largeLayout == layout) {
        [self.loadingIndicator stopAnimating];
        self.largeLayout.trackDelegate = self;
        self.largeLayout.viewDelegate = self;
        [self.largeLayout show];
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

#pragma mark PNLayoutViewDelegate

- (void)layoutDidShow:(PNLayout *)layout
{
    NSLog(@"Layout shown");
}

- (void)layoutDidHide:(PNLayout *)layout
{
    NSLog(@"Layout hidden");
}

@end
