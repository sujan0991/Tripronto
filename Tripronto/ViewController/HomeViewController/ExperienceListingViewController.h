//
//  ExperienceListingViewController.h
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

#import "ExperienceDetailsViewController.h"


#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface ExperienceListingViewController : UIViewController<RATreeViewDataSource,RATreeViewDelegate,HWViewPagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


//@property (weak, nonatomic) IBOutlet KDCycleSplitBannerView *experienceBannerview;

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet RATreeView *experienceListingTable;


@property (weak, nonatomic) IBOutlet HWViewPager *experienceViewPager;

@property (nonatomic, strong) NSMutableArray *experiences;

@end
