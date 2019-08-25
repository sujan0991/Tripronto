//
//  DestinationInfoViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 12/20/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+APParallaxHeader.h"
#import "HexColors.h"
#import "MARKRangeSlider.h"
#import "HWViewPager.h"

#import "ESTimePicker.h"
#import "CustomTimePicker.h"
#import "JTCalendar.h"

#import "KSToastView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface DestinationInfoViewController : UIViewController<APParallaxViewDelegate, UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HWViewPagerDelegate,ESTimePickerDelegate,CustomTimePickerDelegate,JTCalendarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *destinationName;

@property (nonatomic, strong) IBOutlet MARKRangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UIButton *rangeLabel;


@property (weak, nonatomic) IBOutlet UIScrollView *containerView;

@property (weak, nonatomic) IBOutlet UIView *destinationView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIView *travelDatesView;

@property (weak, nonatomic) IBOutlet UILabel *arivalDate;
@property (weak, nonatomic) IBOutlet UILabel *DepDate;



@property (weak, nonatomic) IBOutlet UIButton *selectFlightsButton;
@property (weak, nonatomic) IBOutlet UIButton *flightsNotRequiredButton;
@property (weak, nonatomic) IBOutlet UIButton *viewFlightButton;
@property (weak, nonatomic) IBOutlet UIButton *flightModifyButton;
@property (weak, nonatomic) IBOutlet UIView *flightViewSeperator;

@property (weak, nonatomic) IBOutlet UIButton *selectHotelsButton;
@property (weak, nonatomic) IBOutlet UIButton *hotelsNotRequiredButton;
@property (weak, nonatomic) IBOutlet UIButton *viewHotelsButton;
@property (weak, nonatomic) IBOutlet UIButton *hotelsModifyButton;
@property (weak, nonatomic) IBOutlet UIView *hotelsViewSeperator;

@property (weak, nonatomic) IBOutlet UIButton *selectActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *activityNotRequiredButton;
@property (weak, nonatomic) IBOutlet UIButton *viewActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *activityModifyButton;
@property (weak, nonatomic) IBOutlet UIView *activityViewSeperator;

@property (weak, nonatomic) IBOutlet UILabel *popupViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *popupViewSubtitle;

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *shadeView;


@property (nonatomic, strong) NSMutableArray *flightLists;
@property (nonatomic, strong) NSMutableArray *accommodationType;
@property (nonatomic, strong) NSMutableArray *hotelList;
@property (nonatomic, strong) NSMutableArray *locationList;


@property (weak, nonatomic) IBOutlet UIView *commonTable;
@property (weak, nonatomic) IBOutlet UITableView *genericDataTableView;


@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;



@property (weak, nonatomic) IBOutlet UILabel *airlineClassLabel;
@property (weak, nonatomic) IBOutlet UIButton *flexibleDatesButton;

@property (weak, nonatomic) IBOutlet UITableView *flightTableList;
@property (weak, nonatomic) IBOutlet UIScrollView *flightScrollView;


@property (weak, nonatomic) IBOutlet UIScrollView *hotelScrollView;
@property (weak, nonatomic) IBOutlet UITableView *accommodationTypeTable;
@property (weak, nonatomic) IBOutlet UITableView *hotelChainTable;
@property (weak, nonatomic) IBOutlet UITableView *locationTable;
@property (weak, nonatomic) IBOutlet UITextView *accommodationTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;




@property (weak, nonatomic) IBOutlet UIView *activityListTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *activityScrollView;
@property (weak, nonatomic) IBOutlet UIView *selectedActivityView;
@property (weak, nonatomic) IBOutlet UIView *activityHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *selectedActivityTable;
@property (weak, nonatomic) IBOutlet UITableView *activityTable;


@property (weak, nonatomic) IBOutlet UIView *allActivityView;
@property (weak, nonatomic) IBOutlet UIView *favActivityView;

@property (weak, nonatomic) IBOutlet UITableView *activityTableView;
@property (weak, nonatomic) IBOutlet UILabel *showAllLabel;

@property (weak, nonatomic) IBOutlet UITableView *favActivityTable;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;



@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySegment;

@property BOOL isFlightList;
@property BOOL isHotelList;
@property BOOL isActivityList;

@property BOOL isArrivalDate;
@property BOOL isFromSummary;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flightTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accommodationTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotelTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTableHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityTableViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerOfRangeLabel;

@property (weak, nonatomic) IBOutlet UIView *featuredView;
@property (weak, nonatomic) IBOutlet HWViewPager *featuredViewPager;
@property (strong, nonatomic) UIPageControl *featuredPageControl;


@property (weak, nonatomic) IBOutlet UIView *nearActivityView;
@property (weak, nonatomic) IBOutlet HWViewPager *popularNearViewPager;
@property (strong, nonatomic) UIPageControl *popularPageControl;


@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *accomodationTypeView;
@property (weak, nonatomic) IBOutlet UIPickerView *accomodationTypePicker;


@property (nonatomic,strong) CustomTimePicker *clockView;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
