//
//  SummaryViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 3/7/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"

#import "HexColors.h"
#import "AFNetworking.h"

#import "SEFilterControl.h"
#import "ZHPopupView.h"

#import "MessageBoardViewController.h"
#import "MyTripViewController.h"
#import "DestinationInfoViewController.h"

@interface SummaryViewController : UIViewController<APParallaxViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property  bool isManagable;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (weak, nonatomic) IBOutlet UIView *summaryView;

@property (weak, nonatomic) IBOutlet UICollectionView *commonDataCollectionView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *destinationTableView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *destinationViewHeightConstant;

@end
