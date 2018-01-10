//
//  InFeedSampleObjCViewController.m
//  sample.infeed
//
//  Created by Can Soykarafakili on 09.01.18.
//  Copyright © 2018 Can Soykarafakili. All rights reserved.
//

#import "InFeedSampleObjCViewController.h"
#import "SmallLayoutObjCCell.h"
#import "MediumLayoutObjCCell.h"
#import <Pubnative/Pubnative.h>
#import "sample_infeed-Swift.h"

@interface InFeedSampleObjCViewController () <UITableViewDataSource, PNLayoutLoadDelegate, PNLayoutTrackDelegate>

@property (nonatomic, strong) PNSmallLayout *smallLayout;
@property (nonatomic, strong) PNMediumLayout *mediumLayout;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *layoutSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InFeedSampleObjCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // Stop tracking of the layout that you have (Either Small or Medium)
    [self.smallLayout stopTrackingView];
    [self.mediumLayout stopTrackingView];
}

- (IBAction)requestButtonTouchUpInside:(id)sender
{
    self.dataSource = [[Settings initialDataSource] mutableCopy];
    [self.tableView reloadData];
    [self.loadingIndicator startAnimating];
    // In order to be more efficient this ViewController is handling both Small and Medium Layout Integrations..
    // That's why some of the methods are generealized..
    // You can always choose one of them and integrate like you are integrating a Small or Medium Layout and remove the codes that is related with other Layout.
    switch (self.layoutSegmentedControl.selectedSegmentIndex) {
        case 0:
            if (self.smallLayout == nil) {
                self.smallLayout = [[PNSmallLayout alloc] init];
            }
            [self.smallLayout loadWithAppToken:[Settings appToken] placement:[Settings placementSmall] delegate:self];
            break;
        case 1:
            if (self.mediumLayout == nil) {
                self.mediumLayout = [[PNMediumLayout alloc] init];
            }
            [self.mediumLayout loadWithAppToken:[Settings appToken] placement:[Settings placementMedium] delegate:self];
            break;
        default:
            break;
    }
}

#pragma mark - Delegates -

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // You can add the number of sections that your app requires in here...
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // You can add your own data source to here...
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[PNSmallLayout class]]) {
        return 80;
    } else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[PNMediumLayout class]]) {
        return 250;
    } else {
        // You can give the necessary height parameter to your UITableViewCells in here...
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[PNSmallLayout class]]) {
        SmallLayoutObjCCell *smallLayoutCell = [self.tableView dequeueReusableCellWithIdentifier:@"SmallLayoutObjCCell" forIndexPath:indexPath];
        UIView *layoutView = self.smallLayout.viewController.view;
        [smallLayoutCell.smallAdContainer addSubview:layoutView];
        [self.smallLayout startTrackingView];
        return smallLayoutCell;
        
    } else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[PNMediumLayout class]]) {
        MediumLayoutObjCCell *mediumLayoutCell = [self.tableView dequeueReusableCellWithIdentifier:@"MediumLayoutObjCCell" forIndexPath:indexPath];
        UIView *layoutView = self.mediumLayout.viewController.view;
        [mediumLayoutCell.mediumAdContainer addSubview:layoutView];
        [self.mediumLayout startTrackingView];
        return mediumLayoutCell;
    } else {
        // You can add your own UITableViewCell implementations from here...
        UITableViewCell *defaultCell = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
        return defaultCell;
    }
}

#pragma mark PNLayoutLoadDelegate

- (void)layoutDidFinishLoading:(PNLayout *)layout
{
    NSLog(@"Layout loaded");
    layout.trackDelegate = self;
    // You can insert the Layout at any index... For example we added into the 7th index.
    [self.dataSource insertObject:layout atIndex:7];
    [self.tableView reloadData];
    [self.loadingIndicator stopAnimating];
    self.tableView.hidden = NO;
    // You can access layout.viewController and customize the ad appearance with the predefined methods.
    
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
