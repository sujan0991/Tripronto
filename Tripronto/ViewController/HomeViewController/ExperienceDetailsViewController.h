//
//  ExperienceDetailsViewController.h
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


@interface ExperienceDetailsViewController : UIViewController<HWViewPagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic)  NSString *activityId;
@property (strong, nonatomic)  NSString *activityName;


@property (strong,nonatomic) NSMutableDictionary   *activityDetails;
@property (strong,nonatomic) NSMutableArray   *activityMedia;
@property (strong,nonatomic) NSMutableArray   *activityCities;
@property (strong,nonatomic) NSMutableArray   *similarActivity;
@property (strong,nonatomic) NSMutableArray   *activityExperts;


@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet HWViewPager *experienceViewPager;
@property (weak, nonatomic) IBOutlet HWViewPager *relatedExperienceViewPager;
@property (weak, nonatomic) IBOutlet HWViewPager *citiesViewPager;


@property (weak, nonatomic) IBOutlet JT3DScrollView *expertListView;


@property (weak, nonatomic) IBOutlet TTTAttributedLabel *experienceDetailsLabel;

@property (weak, nonatomic) IBOutlet UILabel *citiesForLabel;
@property (weak, nonatomic) IBOutlet UILabel *expertInLabel;

@end
