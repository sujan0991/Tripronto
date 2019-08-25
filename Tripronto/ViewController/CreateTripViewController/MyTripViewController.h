//
//  MyTripViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 1/3/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"
#import "HexColors.h"

#import "MessageBoardViewController.h"
#import "CreateTripViewController.h"

#import "AFNetworking.h"

@interface MyTripViewController : UIViewController<APParallaxViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)  NSMutableArray *allTrips;
@property (strong,nonatomic)  NSMutableArray *currentTrips;
@property (strong,nonatomic)  NSMutableArray *pastTrips;
@property (strong,nonatomic)  NSMutableArray *completedTrips;

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIView *createView;
@property (weak, nonatomic) IBOutlet UIView *tripsView;

@property (weak, nonatomic) IBOutlet UIButton *currentBookingsButton;
@property (weak, nonatomic) IBOutlet UIButton *pastBookingsButton;

@property (weak, nonatomic) IBOutlet UITableView *tripsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tripsTableHeight;

@property BOOL isFirstTrip;

@property (weak, nonatomic) IBOutlet UIButton *triprontoLogoButton;

-(void) setNotification;
-(void)loadDetails;
@end
