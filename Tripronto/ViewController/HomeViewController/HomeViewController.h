//
//  HomeViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCycleBannerView.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"

#import "Constants.h"

#import "MyTripViewController.h"
#import "DestinationDetailsViewController.h"
#import "ExperienceDetailsViewController.h"
#import "OfferDetailsViewController.h"

@interface HomeViewController : UIViewController<KDCycleBannerViewDataource, KDCycleBannerViewDelegate>

@property (strong, nonatomic)  KDCycleBannerView *destinationBanner;
@property (strong, nonatomic)  KDCycleBannerView *experienceBanner;
@property (strong, nonatomic)  KDCycleBannerView *offersBanner;

@property (strong,nonatomic) NSMutableArray *destinationImageUrls;
@property (strong,nonatomic) NSMutableArray *experienceImageUrls;
@property (strong,nonatomic) NSMutableArray *offerImageUrls;


@property (strong,nonatomic) NSMutableArray *destinations;
@property (strong,nonatomic) NSMutableArray *experiences;
@property (strong,nonatomic) NSMutableArray *offers;


@property (weak, nonatomic) IBOutlet UIView *destinationPagerView;
@property (weak, nonatomic) IBOutlet UIView *experiencePagerView;
@property (weak, nonatomic) IBOutlet UIView *offersPagerView;

@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButtonNav;


@property (weak, nonatomic) IBOutlet UIButton *experinceButton;
@property (weak, nonatomic) IBOutlet UIButton *experinceButtonNav;

@property (weak, nonatomic) IBOutlet UIButton *offerButton;
@property (weak, nonatomic) IBOutlet UIButton *offerButtonNav;

@end
