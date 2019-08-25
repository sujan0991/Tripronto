//
//  DestinationSelectorViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 12/14/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedDestinationCell.h"

#import "UIScrollView+APParallaxHeader.h"
#import "HexColors.h"

#import "Constants.h"

#import "KSToastView.h"

#import "AFNetworking.h"
#import "JTCalendar.h"

@interface DestinationSelectorViewController : UIViewController<APParallaxViewDelegate,UITableViewDataSource,UITableViewDelegate,JTCalendarDelegate,UISearchBarDelegate>


@property (nonatomic, strong) NSMutableArray *destinations;

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIView *step3View;
@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet UIView *stepNumberView;

@property (weak, nonatomic) IBOutlet UITableView *destinationTableView;
@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;

@property (weak, nonatomic) IBOutlet UIButton *startingDateButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneWayButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;


@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

@property (strong) NSDate *startDate;

@property BOOL isStartingDate;
@property BOOL isStartingPoint;
@property BOOL isArrivalDate;

@property (weak, nonatomic) IBOutlet UIButton *startingPoint;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *popoverTitle;
@property (weak, nonatomic) IBOutlet UIView *citiesView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end
