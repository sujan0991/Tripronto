//
//  OfferListingViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/19/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "OfferDetailsViewController.h"
#import "OfferListTableViewController.h"

@interface OfferListingViewController : UIViewController<HWViewPagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet HWViewPager *offerByDestinations;
@property (weak, nonatomic) IBOutlet HWViewPager *offersByExperience;
@property (weak, nonatomic) IBOutlet HWViewPager *featuredOffers;

@property (nonatomic, strong) NSMutableArray *destinations;
@property (nonatomic, strong) NSMutableArray *experiences;
@property (nonatomic, strong) NSMutableArray *offers;

@end
