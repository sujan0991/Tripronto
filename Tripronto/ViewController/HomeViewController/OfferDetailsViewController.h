//
//  OfferDetailsViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/27/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWViewPager.h"
#import "ResponsiveLabel.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "SEFilterControl.h"

@interface OfferDetailsViewController : UIViewController<HWViewPagerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) NSString   *offerID;
@property (strong,nonatomic) NSString   *offerName;


//@property (weak, nonatomic) IBOutlet HWViewPager *offerDetailsViewPager;
//@property (weak, nonatomic) IBOutlet HWViewPager *similarOffersViewPager;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expertProPicture;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *quickInfoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *activitiesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *hotelsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *accomodationCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *offerFacilitiesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *airlinesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *similarOfferCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *termsViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIView *termsView;

@property (weak, nonatomic) IBOutlet UIView *steperView;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImage;


- (void)configureText:(NSString*)str forExpandedState:(BOOL)isExpanded;



@end
