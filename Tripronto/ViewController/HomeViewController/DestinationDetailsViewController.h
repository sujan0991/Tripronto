//
//  DestinationDetailsViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/27/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "JT3DScrollView.h"

#import "HexColors.h"

#import "TTTAttributedLabel.h"


#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface DestinationDetailsViewController : UIViewController<HWViewPagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) NSString   *cityID;
@property (strong,nonatomic) NSString   *cityName;

@property (strong,nonatomic) NSMutableDictionary   *cityDetails;
@property (strong,nonatomic) NSMutableArray   *cityMedia;
@property (strong,nonatomic) NSMutableArray   *cityAcitivites;
@property (strong,nonatomic) NSMutableArray   *cityOffers;
@property (strong,nonatomic) NSMutableArray   *cityExperts;


@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet HWViewPager *destinationViewPager;
@property (weak, nonatomic) IBOutlet HWViewPager *experienceViewPager;
@property (weak, nonatomic) IBOutlet HWViewPager *offersViewPager;


@property (weak, nonatomic) IBOutlet JT3DScrollView *expertListView;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *experienceInLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerInLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertInLabel;


@end
