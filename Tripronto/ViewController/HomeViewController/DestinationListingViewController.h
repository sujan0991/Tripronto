//
//  DestinationListingViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/19/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "KDCycleSplitBannerView.h"

#import "HWViewPager.h"

#import "RATreeView.h"
#import "RATableViewCell.h"
#import "RADataObject.h"

#import "DestinationDetailsViewController.h"

#import "AFNetworking.h"



@interface DestinationListingViewController : UIViewController<RATreeViewDataSource,RATreeViewDelegate,HWViewPagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

//@property (strong, nonatomic) IBOutlet KDCycleSplitBannerView *destinationBanner;

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet RATreeView *destinationListingTable;
@property (weak, nonatomic) IBOutlet HWViewPager *destinationViewPager;

@property (nonatomic, strong) NSMutableArray *destinations;

@end
