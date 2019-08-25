//
//  DestinationInfoViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 12/20/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "DestinationInfoViewController.h"

#import "Airways.h"
#import "Hotels.h"
#import "Activity.h"

#import "Constants.h"

#import "Trip.h"
#import "TripCity.h"

#import "Summary.h"
#import "SummaryDestination.h"

#import "DateData.h"


@interface DestinationInfoViewController ()
{
    NSDate *todayDate;
    NSDate *minDate;
    NSDate *maxDate;

    NSDate *dateSelected;
    
    NSMutableDictionary *airlinesSections;
    NSMutableDictionary *airlinesSearchSections;
    NSArray *airlinesSectionTitles;
    
    
    NSMutableDictionary *hotelSections;
    NSMutableDictionary *hotelSearchSections;
    NSArray *hotelsSectionTitles;
    
    NSMutableArray *accomodationTypesArray;
    //NSMutableArray *hotelsArray;
    //NSMutableArray *locationArray;
    
    
    NSMutableDictionary *locationSections;
    NSMutableDictionary *locationSearchSections;
    NSArray *locationSectionTitles;
    
    NSMutableDictionary *activitySections;
    NSMutableDictionary *activitySearchSections;
    NSArray *activitySectionTitles;
    
    NSMutableDictionary* accomodationType;
    
    NSMutableArray* allActivities;
    NSMutableArray* featuredActivities;
    NSMutableArray* popularActivities;
    
    NSMutableArray* selectedActivities;
    
    TripCity *cityPreference;
    SummaryDestination *summaryDestinationPreference;
    
    NSString* cityName;
    NSString* airlineClass;
    
    NSUInteger currentCityIndex;
}


@end

@implementation DestinationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   // NSString *string = @"Airline class (Required)";
   
    self.accommodationTextView.textColor = [UIColor lightGrayColor];
    self.accommodationTextView.text = @"Add any additional details here";

    
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: self.airlineClassLabel.attributedText];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor hx_colorWithHexString:@"E03365"]
                 range:NSMakeRange(15, 8)];
    
    self.airlineClassLabel.attributedText = text;
    
    if([Trip sharedManager].cities_trips.count)
    {
        currentCityIndex=[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityIndex"] unsignedIntegerValue];
        
    }
    else
    {
        currentCityIndex=0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:currentCityIndex] forKey:@"currentCityIndex"];
    }
    
    
    if ([Trip sharedManager].citiesIdsArray.count)
    {
    
        cityPreference=[TripCity new];
        cityPreference.city_id=[[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"city_id"] intValue];
        cityPreference.airport_id=[[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"airport_id"] intValue];
        cityName=[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"cityName"];
        
        self.destinationName.text=[NSString stringWithFormat:@"Select preference for %@",cityName];
        
        summaryDestinationPreference=[SummaryDestination new];
        summaryDestinationPreference.destinationName=[NSString stringWithFormat:@"%@, %@",cityName,[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"countryName"]];
        
        
        [self.DepDate setText:[self getDateFromString:[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"depDate"]]];
        cityPreference.departure_date=[self getDateData:[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"depDate"]];
        

        [self.arivalDate setText:[self getDateFromString:[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"arrivalDate"]]];
        cityPreference.arrival_date=[self getDateData:[[[Trip sharedManager].citiesIdsArray objectAtIndex:currentCityIndex] objectForKey:@"arrivalDate"]];
        
        summaryDestinationPreference.datePreferenceString=[NSString stringWithFormat:@"%@",self.DepDate.text];
     
        
//        if([Trip sharedManager].cities_trips.count)
//        {
//            NSMutableArray *navigarray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//            [navigarray removeObjectAtIndex:navigarray.count-2]; //navigarray contains all vcs
//            [[self navigationController] setViewControllers:navigarray animated:YES];
//        }
    }
    
    [self setShaddow];
    
    self.flightLists =[[NSMutableArray alloc] init];
    self.accommodationType =[[NSMutableArray alloc] init];
    self.hotelList =[[NSMutableArray alloc] init];
    self.locationList =[[NSMutableArray alloc] init];
    selectedActivities=[[NSMutableArray alloc] init];
    
    
    airlinesSections=[[NSMutableDictionary alloc] init];
    hotelSections=[[NSMutableDictionary alloc] init];
    locationSections=[[NSMutableDictionary alloc] init];
    activitySections=[[NSMutableDictionary alloc] init];
    
    if(currentCityIndex<[Trip sharedManager].cities_trips.count)
    {
        //NSLog(@"current data %@",[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex]);
        //NSLog(@"Summary data %@",[[Summary sharedManager].destinationDetails objectAtIndex:currentCityIndex]);
        
        summaryDestinationPreference.airlinePreferenceString=[[[Summary sharedManager].destinationDetails objectAtIndex:currentCityIndex] objectForKey:@"airlinePreference"];
        summaryDestinationPreference.accommodationPreferenceString=[[[Summary sharedManager].destinationDetails objectAtIndex:currentCityIndex] objectForKey:@"accommodationPreference"];
        summaryDestinationPreference.activityPreferenceString=[[[Summary sharedManager].destinationDetails objectAtIndex:currentCityIndex] objectForKey:@"activityPreference"];
        
        if([[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"are_dates_flexible"] intValue]|| [[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"preferred_airline_class"])
        {
            airlineClass=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"preferred_airline_class"];
            self.flexibleDatesButton.selected=[[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"are_dates_flexible"] intValue];

            cityPreference.preferred_airline_class=airlineClass;
            cityPreference.are_dates_flexible=self.flexibleDatesButton.selected;
            
            
            
            if(![airlineClass isEqualToString:@"Economy"] ||  self.flexibleDatesButton.selected)
            {
                
                self.isFlightList=YES;
                
                self.selectFlightsButton.layer.shadowOpacity = 0.3;
                self.selectFlightsButton.layer.zPosition=101;
                self.selectFlightsButton.selected=YES;
                
                self.flightsNotRequiredButton.selected=NO;
                self.flightsNotRequiredButton.layer.shadowOpacity = 0.1;
                self.flightsNotRequiredButton.layer.zPosition=100;
                
                self.selectFlightsButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
                //self.viewFlightButton.hidden=NO;
                self.flightModifyButton.hidden=NO;
                //self.flightViewSeperator.hidden=NO;
                
                self.viewFlightButton.enabled=YES;
                self.flightModifyButton.enabled=YES;

            }
            
            
            
            if([airlineClass isEqualToString:@"Economy"])
            {
                
                UIButton *random1 = (UIButton *)[self.view viewWithTag:203];
                random1.selected=YES;
                
                UIButton *random2 = (UIButton *)[self.view viewWithTag:202];
                random2.selected=NO;
                
                UIButton *random3 = (UIButton *)[self.view viewWithTag:201];
                random3.selected=NO;
                
            }
            else  if([airlineClass isEqualToString:@"Business"])
            {
                UIButton *random1 = (UIButton *)[self.view viewWithTag:203];
                random1.selected=NO;
                
                UIButton *random2 = (UIButton *)[self.view viewWithTag:202];
                random2.selected=YES;
                
                UIButton *random3 = (UIButton *)[self.view viewWithTag:201];
                random3.selected=NO;
                
            } else  if([airlineClass isEqualToString:@"First"])
            {
                UIButton *random1 = (UIButton *)[self.view viewWithTag:203];
                random1.selected=NO;
                
                UIButton *random2 = (UIButton *)[self.view viewWithTag:202];
                random2.selected=NO;
                
                UIButton *random3 = (UIButton *)[self.view viewWithTag:201];
                random3.selected=YES;
                
            }
            

            
            
        }
        else
            self.isFlightList=NO;
        
        if([[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accomodation_budget"])
        {
            self.isHotelList=YES;
            
            
            
            self.selectHotelsButton.layer.shadowOpacity = 0.3;
            self.selectHotelsButton.layer.zPosition=101;
            self.selectHotelsButton.selected=YES;
            
            self.hotelsNotRequiredButton.selected=NO;
            self.hotelsNotRequiredButton.layer.shadowOpacity = 0.1;
            self.hotelsNotRequiredButton.layer.zPosition=100;
            
            self.selectHotelsButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            //self.viewFlightButton.hidden=NO;
            self.hotelsModifyButton.hidden=NO;
            //self.flightViewSeperator.hidden=NO;
            
            self.viewHotelsButton.enabled=YES;
            self.hotelsModifyButton.enabled=YES;

            
            
            CGFloat leftRange,rightRange;
            
            NSString *range =[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accomodation_budget"];
            NSMutableArray *listItems = [[NSMutableArray alloc] initWithArray: [range componentsSeparatedByCharactersInSet:
                                                                                [NSCharacterSet characterSetWithCharactersInString:@"$- "]]];
            
            //NSLog(@" before listitems %@",listItems);
            for (int i=0; i<listItems.count; i++) {
                NSString *singleRange= [listItems objectAtIndex:i];
                if([singleRange isEqualToString:@""])
                    [listItems removeObjectAtIndex:i];
            }
            
            leftRange=[[listItems objectAtIndex:0 ] floatValue]/1000;
            rightRange=[[listItems objectAtIndex:2 ] floatValue]/1000;
            
           // NSLog(@"listitems %@",listItems);
            [self setUpViewComponentsFrom:leftRange to:rightRange];
            
            cityPreference.accomodation_budget = self.rangeLabel.titleLabel.text;
            cityPreference.accommodation_comment = [[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accommodation_comment"];
            
            self.accommodationTextView.text=cityPreference.accommodation_comment;

        }
        else
        {
            self.isHotelList=NO;
             [self setUpViewComponentsFrom:0.2 to:.5];
        }
        if([[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"activities"] objectForKey:@"_ids"])
        {
             self.isActivityList=YES;
            
            
            self.selectActivityButton.layer.shadowOpacity = 0.3;
            self.selectActivityButton.layer.zPosition=101;
            self.selectActivityButton.selected=YES;
            
            self.activityNotRequiredButton.selected=NO;
            self.activityNotRequiredButton.layer.shadowOpacity = 0.1;
            self.activityNotRequiredButton.layer.zPosition=100;
            
            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            //self.viewFlightButton.hidden=NO;
            self.activityModifyButton.hidden=NO;
            //self.flightViewSeperator.hidden=NO;
            
            self.viewActivityButton.enabled=YES;
            self.activityModifyButton.enabled=YES;
        }
        else
            self.isActivityList=NO;
        
        cityPreference.accomodation_types=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accomodation_types"];
        cityPreference.airlines=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"airlines"];
        cityPreference.destinations=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accommodation_locations"];
        cityPreference.hotel_chains=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"hotel_chains"];
        cityPreference.hotels=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"hotels"];
        cityPreference.activities=[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"activities"];

        
        
        [self loadAirlines];
        [self loadAccomodationTypes];
        [self loadHotels];
        [self loadLocations];
        [self loadTemporaryActivities];
        
    
    }
    else
    {
        airlineClass=@"Economy";
        
        self.isFlightList=NO;
        self.isHotelList=NO;
        self.isActivityList=NO;
        
        [self setUpViewComponentsFrom:0.2 to:.5];
       
        [self loadAirlines];
        [self loadAccomodationTypes];
        [self loadHotels];
        [self loadLocations];
        [self loadTemporaryActivities];
        //[self loadActivites];
    }

   
    
    self.calendarManager = [JTCalendarManager new];
    self.calendarManager.delegate = self;

    [self createMinAndMaxDate];
    
//    _calendarMenuView.contentRatio = .75;
//    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
//    
    
    [self.calendarManager setMenuView:self.calendarMenuView];
    [self.calendarManager setContentView:self.calendarContentView];
    [self.calendarManager setDate:todayDate];

    
    [self.view layoutIfNeeded];
    
    self.travelDatesView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    self.containerView.parallaxView.delegate = self;
    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.destinationView.subviews) {
        
        
        contentRect = CGRectUnion(contentRect, view.frame);
       // NSLog(@"contentRect %lf %@",contentRect.size.height,view);
    }
    
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withTitle:[NSString stringWithFormat:@"Select preference for %@",cityName]];
    
    if(!self.isFromSummary)
    {
        [[self.containerView.parallaxView backButton] addTarget:self
                                                         action:@selector(backButtonAction)
                                               forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }else
    {
        [self.containerView.parallaxView.backButton setHidden:YES];
        [self.nextButton setTitle:@"U P D A T E" forState:UIControlStateNormal];
        
    }
    
    
   
    
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];

    //NSLog(@"destinationView %@ %@",self.destinationView,self.containerView);
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    self.selectedActivityTable.userInteractionEnabled = YES;
    self.selectedActivityTable.exclusiveTouch = YES;
    self.selectedActivityTable.canCancelContentTouches = YES;
    self.selectedActivityTable.delaysContentTouches = NO;
    
    

    
    
    
   
    
    
    self.accommodationTypeTable.dataSource=self;
    self.accommodationTypeTable.delegate=self;
    
    self.hotelChainTable.dataSource=self;
    self.hotelChainTable.delegate=self;
    
    self.locationTable.dataSource=self;
    self.locationTable.delegate=self;
    
    self.flightTableList.dataSource=self;
    self.flightTableList.delegate=self;
    
    self.selectedActivityTable.dataSource=self;
    self.selectedActivityTable.delegate=self;
    
    self.activityTableView.dataSource=self;
    self.activityTableView.delegate=self;
    
    self.favActivityTable.dataSource=self;
    self.favActivityTable.delegate=self;
    
    self.genericDataTableView.dataSource=self;
    self.genericDataTableView.delegate=self;
  //  self.genericDataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.genericDataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.genericDataTableView.frame.size.width, 1)];
    
    
    self.locationTableView.dataSource=self;
    self.locationTableView.delegate=self;
   self.locationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.locationTableView.frame.size.width, 1)];
    
    self.activityTable.dataSource=self;
    self.activityTable.delegate=self;
    //self.activityTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.activityTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.activityTable.frame.size.width, 1)];

    self.selectedActivityTable.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.activityTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.favActivityTable.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.genericDataTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.locationTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.activityTable.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    
    self.activityScrollView.delegate=self;
    
    self.activityTableViewHeight.constant= self.activityScrollView.frame.size.height-self.showAllLabel.frame.size.height-10;
    
    
    self.accommodationTextView.delegate=self;
    self.accommodationTextView.layer.cornerRadius=3.0f;
    self.accommodationTextView.layer.borderWidth=1.0f;
    self.accommodationTextView.layer.borderColor = [UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    [self registerForKeyboardNotifications];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureInAccommodation:)];
    [self.hotelScrollView addGestureRecognizer:singleTap];
    
    self.featuredViewPager.isSingle=YES;
    self.featuredViewPager.dataSource=self;
    self.featuredViewPager.userPagerDelegate=self;

    
    self.popularNearViewPager.isSingle=YES;
    self.popularNearViewPager.dataSource=self;
    self.popularNearViewPager.userPagerDelegate=self;
    
    
   


}




- (void)initializePageControl {
    
    if(self.featuredPageControl)
       [self.featuredPageControl removeFromSuperview];
    if(self.popularPageControl)
        [self.popularPageControl removeFromSuperview];
    
    CGRect pageControlFrame = CGRectMake(0, 0, CGRectGetWidth(self.featuredView.frame)*0.1, 10);
    self.featuredPageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.featuredPageControl.center = CGPointMake(CGRectGetWidth(self.featuredView.frame)*0.85, 10);
    self.featuredPageControl.userInteractionEnabled = YES;
    self.featuredPageControl.pageIndicatorTintColor = [UIColor lightTextColor];
    self.featuredPageControl.currentPageIndicatorTintColor = [UIColor hx_colorWithHexString:@"#E03365"];
    self.featuredPageControl.backgroundColor = [UIColor clearColor];
    self.featuredPageControl.numberOfPages = featuredActivities.count;
    self.featuredPageControl.currentPage = 0;
    
    [self.featuredView addSubview:self.featuredPageControl];
    
    //NSLog(@"pagecontrol %@",self.featuredPageControl);
    
    self.popularPageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.popularPageControl.center = CGPointMake(CGRectGetWidth(self.nearActivityView.frame)*0.85, 10);
    self.popularPageControl.userInteractionEnabled = YES;
    self.popularPageControl.pageIndicatorTintColor = [UIColor lightTextColor];
    self.popularPageControl.currentPageIndicatorTintColor = [UIColor hx_colorWithHexString:@"#E03365"];
    self.popularPageControl.backgroundColor = [UIColor clearColor];
    self.popularPageControl.numberOfPages = popularActivities.count;
    self.popularPageControl.currentPage = 0;
    
    [self.nearActivityView addSubview:self.popularPageControl];
    
    //NSLog(@"pagecontrol %@",self.featuredPageControl);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    CGFloat labelX = (CGRectGetWidth(self.view.frame) - kViewControllerLabelWidth) / 2;
//    self.rangeLabel.frame = CGRectMake(labelX, 110.0, kViewControllerLabelWidth, 20.0);
//    
//    CGFloat sliderX = (CGRectGetWidth(self.view.frame) - kViewControllerRangeSliderWidth) / 2;
//    self.rangeSlider.frame = CGRectMake(sliderX, CGRectGetMaxY(self.rangeLabel.frame) + 20.0, 290.0, 20.0);
}


-(void)setShaddow
{
    self.selectFlightsButton.layer.masksToBounds = NO;
    self.selectFlightsButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.selectFlightsButton.layer.shadowRadius = 5;
    self.selectFlightsButton.layer.shadowOpacity = 0.1;
    self.selectFlightsButton.layer.zPosition=100;
    
    self.flightsNotRequiredButton.layer.masksToBounds = NO;
    self.flightsNotRequiredButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.flightsNotRequiredButton.layer.shadowRadius = 5;
    self.flightsNotRequiredButton.layer.shadowOpacity = 0.3;
    self.flightsNotRequiredButton.layer.zPosition=101;
    
    self.selectHotelsButton.layer.masksToBounds = NO;
    self.selectHotelsButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.selectHotelsButton.layer.shadowRadius = 5;
    self.selectHotelsButton.layer.shadowOpacity = 0.1;
    self.selectHotelsButton.layer.zPosition=100;
    
    self.hotelsNotRequiredButton.layer.masksToBounds = NO;
    self.hotelsNotRequiredButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.hotelsNotRequiredButton.layer.shadowRadius = 5;
    self.hotelsNotRequiredButton.layer.shadowOpacity = 0.3;
    self.hotelsNotRequiredButton.layer.zPosition=101;
    
    self.selectActivityButton.layer.masksToBounds = NO;
    self.selectActivityButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.selectActivityButton.layer.shadowRadius = 5;
    self.selectActivityButton.layer.shadowOpacity = 0.1;
    self.selectActivityButton.layer.zPosition=100;
    
    self.activityNotRequiredButton.layer.masksToBounds = NO;
    self.activityNotRequiredButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.activityNotRequiredButton.layer.shadowRadius = 5;
    self.activityNotRequiredButton.layer.shadowOpacity = 0.3;
    self.activityNotRequiredButton.layer.zPosition=101;
}

-(NSString *)getDateFromString:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

-(NSMutableDictionary*) getDateData: (NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    
    DateData* dateFormat=[DateData new];
    
    dateFormat.day= (int)[components day];
    dateFormat.month= (int)[components month];
    dateFormat.year= (int)[components year];
    dateFormat.hour= 0;
    dateFormat.minute= 0;
    
    return [dateFormat toNSDictionary];
}


-(void)backButtonAction
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:currentCityIndex-1] forKey:@"currentCityIndex"];

    [self.navigationController popViewControllerAnimated:YES];
    
    
//    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
//    
//    NSLog(@"numberOfViewControllers %li",(long)numberOfViewControllers);
//    
//    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers-2];
//    
//    [self.navigationController popToViewController:vc animated:NO];

}

-(void) loadAirlines
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/airlines/api-get-airlines",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray* airwaysArray=[[NSMutableArray alloc] init];
        airwaysArray=[responseObject objectForKey:@"airlines"];
        
        NSMutableArray* flightIdsList=[[NSMutableArray alloc]init];
        
        if(currentCityIndex<[Trip sharedManager].cities_trips.count)
        {
            flightIdsList=[[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"airlines"] objectForKey:@"_ids"];
            
        }
        
        
        NSMutableDictionary* airline=[[NSMutableDictionary alloc]init];
        
        
        for (int i=0; i<airwaysArray.count; i++) {
            
            airline=[airwaysArray objectAtIndex:i];
            
            NSString *firstSubString;
            
            Airways *airway = [Airways new];
            airway.airwaysId =  [airline objectForKey:@"id"];
            airway.name = [airline objectForKey:@"title"];
            airway.logo =  [airline objectForKey:@"logo"];
            airway.airwaysDescription= [airline objectForKey:@"description"];
            
            int j=0;
            for (j=0; j<flightIdsList.count; j++) {
                
                if( airway.airwaysId == [flightIdsList objectAtIndex:j])
                {
                    
                    [self.flightLists addObject:airway];
                    
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        
                        self.flightTableHeight.constant= (self.flightLists.count)*50;
                    } completion:^(BOOL finished) {
                        ;
                        
                    }];
                    
                    [self.flightTableList reloadData];
                    break;
                }
              
                
            }
            if(j==flightIdsList.count)
            {
                
                firstSubString=[[airway.name substringToIndex:1] capitalizedString];
                
                NSMutableArray *contactsArray = [airlinesSections objectForKey: firstSubString];
                
                if (contactsArray == nil) {
                    contactsArray = [[NSMutableArray alloc] init] ;
                    
                }
                
                [contactsArray addObject:airway];
                
                [airlinesSections setObject:contactsArray forKey:firstSubString];
                
            }
            
        }
        
        airlinesSectionTitles = [[airlinesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

-(void) loadAccomodationTypes
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/accomodation-types/api-get-accomodation-types/",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        accomodationTypesArray=[[NSMutableArray alloc] init];
        accomodationTypesArray=[responseObject objectForKey:@"accomodation_types"];
        
        NSMutableArray* typeIdList=[[NSMutableArray alloc]init];
        
        if(currentCityIndex<[Trip sharedManager].cities_trips.count)
        {
            typeIdList=[[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accomodation_types"] objectForKey:@"_ids"];
            
        }

        
        //NSLog(@"accomodationTypesArray %@",accomodationTypesArray);
        
        
        for (int j=0; j<typeIdList.count; j++) {
            
            
            for (int i=0; i<accomodationTypesArray.count; i++) {
                
                NSLog(@"%@ %d",[[accomodationTypesArray objectAtIndex:i] objectForKey:@"id"],[[typeIdList objectAtIndex:j] intValue]);
                
                if( [[accomodationTypesArray objectAtIndex:i] objectForKey:@"id"]  == [typeIdList objectAtIndex:j])
                {
                    [self.accommodationType addObject: [accomodationTypesArray objectAtIndex:i]];
                    
                   
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        
                        self.accommodationTableHeight.constant= (self.accommodationType.count)*50;
                    } completion:^(BOOL finished) {
                        ;
                        
                    }];
                    //[self.accommodationTypeTable reloadData];
                    
                    break;

                }
            }
            
        }

        self.accomodationTypePicker.dataSource=self;
        self.accomodationTypePicker.delegate=self;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

-(void) loadHotels
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:cityPreference.city_id] forKey:@"city_id"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/hotels/api-get-hotels-by-city-id/",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray* airwaysArray=[[NSMutableArray alloc] init];
        airwaysArray=[responseObject objectForKey:@"hotels"];
        
        
        NSMutableArray* hotelIdList=[[NSMutableArray alloc]init];
        
        if(currentCityIndex<[Trip sharedManager].cities_trips.count)
        {
            hotelIdList=[[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"hotels"] objectForKey:@"_ids"];
            
        }
        
        
        
        NSMutableDictionary* airline=[[NSMutableDictionary alloc]init];
        
        for (int i=0; i<airwaysArray.count; i++) {
            
            airline=[airwaysArray objectAtIndex:i];
            
            
            
            NSString *firstSubString;
            
            Hotels *airway = [Hotels new];
            airway.name = [airline objectForKey:@"title"];
            airway.hotelId =  [airline objectForKey:@"id"];
            
            
            
            int j=0;
            for (j=0; j<hotelIdList.count; j++) {
                
                if( airway.hotelId == [hotelIdList objectAtIndex:j])
                {
                    
                    [self.hotelList addObject:airway];
                    
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        
                        self.hotelTableHeight.constant= (self.hotelList.count)*50;
                    } completion:^(BOOL finished) {
                        ;
                        
                    }];
                    
                    [self.hotelChainTable reloadData];
                    break;
                }
                
                
            }
            
            if(j==hotelIdList.count)
            {
                firstSubString=[[airway.name substringToIndex:1] capitalizedString];
                NSMutableArray *contactsArray = [hotelSections objectForKey: firstSubString];
                
                if (contactsArray == nil) {
                    contactsArray = [[NSMutableArray alloc] init] ;
                    
                }
                
                [contactsArray addObject:airway];
                
                [hotelSections setObject:contactsArray forKey:firstSubString];
            
            }
            
           
            
        }
        
        hotelsSectionTitles = [[hotelSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

-(void) loadLocations
{
    
//    NSMutableArray* locationArray =[[NSMutableArray alloc] init];
//    NSMutableDictionary* location1=[[NSMutableDictionary alloc]init];
//    [location1 setObject:@"City Centre" forKey:@"title"];
//    [location1 setObject:@"1" forKey:@"id"];
//    [locationArray addObject:location1];
//    
//    NSMutableDictionary* location2=[[NSMutableDictionary alloc]init];
//    [location2 setObject:@"City Outskirts" forKey:@"title"];
//    [location2 setObject:@"2" forKey:@"id"];
//    [locationArray addObject:location2];
//    
//    NSMutableDictionary* location3=[[NSMutableDictionary alloc]init];
//    [location3 setObject:@"Near Airport" forKey:@"title"];
//    [location3 setObject:@"3" forKey:@"id"];
//    [locationArray addObject:location3];
//    
//    //NSLog(@"locationArray %@",locationArray);
//    
//    NSMutableDictionary* airline=[[NSMutableDictionary alloc]init];
//
//    for (int i=0; i<locationArray.count; i++) {
//        
//        airline=[locationArray objectAtIndex:i];
//        
//        NSString *firstSubString;
//        
//        firstSubString=[[[airline objectForKey:@"title"] substringToIndex:1] capitalizedString];
//        
//        NSMutableArray *contactsArray = [locationSections objectForKey: firstSubString];
//        
//        if (contactsArray == nil) {
//            contactsArray = [[NSMutableArray alloc] init] ;
//            
//        }
//        
//        [contactsArray addObject:airline];
//        
//        [locationSections setObject:contactsArray forKey:firstSubString];
//        
//    }
//    
    
    // NSLog(@"locationSections %@",locationSections);
    
    locationSectionTitles = [[locationSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    

    
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
   // [postData setObject:[NSNumber numberWithInt:cityPreference.city_id] forKey:@"city_id"];
    
    //[apiLoginManager POST:[NSString stringWithFormat:@"%@/destinations/api-get-city-destinations/",SERVER_BASE_API_URL] parameters:postData success:^
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/accommodation-locations/api-get-accommodation-locations",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray* loacationIdList=[[NSMutableArray alloc]init];
        
        if(currentCityIndex<[Trip sharedManager].cities_trips.count)
        {
            loacationIdList=[[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"accommodation_locations"] objectForKey:@"_ids"];
            
        }
        
        NSMutableArray* airwaysArray=[[NSMutableArray alloc] init];
        airwaysArray=[responseObject objectForKey:@"locations"];
        
        NSMutableDictionary* airline=[[NSMutableDictionary alloc]init];
        
        for (int i=0; i<airwaysArray.count; i++) {
            
            airline=[airwaysArray objectAtIndex:i];
            
           
            //  NSLog(@"accomodationTypesArray %@",accomodationTypesArray);
            
            
            for (int j=0; j<loacationIdList.count; j++) {
                
            
                    if( [[airline objectForKey:@"id"] intValue] == [[loacationIdList objectAtIndex:j] intValue])
                    {
                        
                        [self.locationList addObject:airline];
                       
                        [UIView animateWithDuration:1.0 animations:^{
                            
                            self.locationTableHeight.constant= (self.locationList.count)*50;
                        } completion:^(BOOL finished) {
                            ;
                            
                        }];
                        
                        [self.locationTable reloadData];
                        
                        break;

                    }

            }
            

            
            
            
            NSString *firstSubString;
            
            firstSubString=[[[airline objectForKey:@"title"] substringToIndex:1] capitalizedString];
    
            NSMutableArray *contactsArray = [locationSections objectForKey: firstSubString];
            
            if (contactsArray == nil) {
                contactsArray = [[NSMutableArray alloc] init] ;
                
            }
            
            [contactsArray addObject:airline];
            
            [locationSections setObject:contactsArray forKey:firstSubString];
            
        }
        
        
       // NSLog(@"locationSections %@",locationSections);
        
        locationSectionTitles = [[locationSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

-(void) loadTemporaryActivities
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:cityPreference.city_id] forKey:@"city_id"];
    
//    [apiLoginManager POST:[NSString stringWithFormat:@"%@/activities-cities/api-get-city-activities/",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/activities/api-get-activities",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
    
        NSMutableArray* allActivites=[[NSMutableArray alloc] init];
        allActivites=[responseObject objectForKey:@"activities"];
        
        NSMutableArray* activityIdList=[[NSMutableArray alloc]init];
        
        if(currentCityIndex<[Trip sharedManager].cities_trips.count)
        {
            activityIdList=[[[[Trip sharedManager].cities_trips objectAtIndex:currentCityIndex] objectForKey:@"activities"] objectForKey:@"_ids"];
            
        }
        
        
        NSMutableDictionary* acitvity=[[NSMutableDictionary alloc]init];
    
        for (int i=0; i<allActivites.count; i++) {
            
            acitvity=[allActivites objectAtIndex:i];
        
            NSString *firstSubString;
            
            Activity *singleActivity = [Activity new];
           // singleActivity.activityId =  [acitvity objectForKey:@"id"];
            
            singleActivity.activityId =  [[acitvity objectForKey:@"activity"] objectForKey:@"id"];
            singleActivity.activityName = [[acitvity objectForKey:@"activity"] objectForKey:@"title"];
            
            
            for (int j=0; j<activityIdList.count; j++) {
                
                if( singleActivity.activityId == [activityIdList objectAtIndex:j])
                {
                    
                    [selectedActivities addObject:singleActivity];
                    
                    break;
                }
                
                
            }

            
            
            
            firstSubString=[[singleActivity.activityName substringToIndex:1] capitalizedString];
            
            NSMutableArray *contactsArray = [activitySections objectForKey: firstSubString];
            
            if (contactsArray == nil) {
                contactsArray = [[NSMutableArray alloc] init] ;
                
            }
            
            [contactsArray addObject:singleActivity];
            
            [activitySections setObject:contactsArray forKey:firstSubString];
            
        }
        
        activitySectionTitles = [[activitySections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        //NSLog(@"activitySectionTitles %@",activitySectionTitles);
   
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
    
}

-(void) loadActivites
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:cityPreference.city_id] forKey:@"city_id"];
    
   
    //[apiLoginManager POST:[NSString stringWithFormat:@"%@/activities-cities/api-get-city-activities/",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/activities/api-get-activities",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        allActivities=[[NSMutableArray alloc] init];
        featuredActivities =[[NSMutableArray alloc] init];
        popularActivities =[[NSMutableArray alloc] init];
        
        NSMutableArray* allActivites=[[NSMutableArray alloc] init];
        allActivites=[responseObject objectForKey:@"activities"];
        
        NSMutableDictionary* acitvity=[[NSMutableDictionary alloc]init];
        
        
        
        
        for (int i=0; i<allActivites.count; i++) {
            
            acitvity=[allActivites objectAtIndex:i];
            
            Activity *singleActivity = [Activity new];
            singleActivity.activityId =  [acitvity objectForKey:@"id"];
            singleActivity.activityName = [[acitvity objectForKey:@"activity"] objectForKey:@"title"];
            singleActivity.price =  [acitvity objectForKey:@"price"];
            singleActivity.isPopular= [acitvity objectForKey:@"is_popular"];
            singleActivity.isFeatured=[acitvity objectForKey:@"is_featured"];
            singleActivity.featuredImage=[[acitvity objectForKey:@"activity"]  objectForKey:@"featured_image"];
            
            [allActivities addObject:singleActivity];
            
            
            if([singleActivity.isPopular integerValue] ==1)
                [popularActivities addObject:singleActivity];
            if([singleActivity.isFeatured integerValue] ==1)
                [featuredActivities addObject:singleActivity];
            
        }
        
        [self initializePageControl];
        
        //NSLog(@"allActivities %@",allActivities);
        //NSLog(@"featuredActivities %@",featuredActivities);
        //NSLog(@"popularActivities %@",popularActivities);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    //    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}

#pragma mark - overlayCallmethods

- (IBAction)selectFlightsAction:(UIButton*)sender {
    
 //   NSLog(@"select flight");
//    if(!sender.selected)
//    {
//    
    
        self.selectFlightsButton.layer.shadowOpacity = 0.3;
        self.selectFlightsButton.layer.zPosition=101;
        self.selectFlightsButton.selected=YES;
        
        self.flightsNotRequiredButton.selected=NO;
        self.flightsNotRequiredButton.layer.shadowOpacity = 0.1;
        self.flightsNotRequiredButton.layer.zPosition=100;
        
        if(self.isFlightList)
        {
            self.selectFlightsButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
           // self.viewFlightButton.hidden=NO;
            self.flightModifyButton.hidden=NO;
          //  self.flightViewSeperator.hidden=NO;
            
            self.viewFlightButton.enabled=YES;
            self.flightModifyButton.enabled=YES;
        }
        else
        {
            //select first time
            
            self.popUpView.hidden=NO;
            self.shadeView.hidden=NO;
            
            self.flightScrollView.hidden=NO;
            
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select your flight preference"];
            
            
            
            [self.flightTableList reloadData];
            
            //self.isFlightList=YES;
        }
    
    
    
    
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;

  //  }
      //  self.selectFlightsButton.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    //sender.selected=!sender.selected;
    
    
    
}
- (IBAction)flightNotRequiredAction:(UIButton*)sender {
    
 //   NSLog(@"flight not required");
    
    
    if(!sender.selected)
    {
        
        self.flightsNotRequiredButton.layer.shadowOpacity = 0.3;
        self.flightsNotRequiredButton.layer.zPosition=101;
        self.flightsNotRequiredButton.selected=YES;
        
        self.selectFlightsButton.selected=NO;
        self.selectFlightsButton.layer.shadowOpacity = 0.1;
        self.selectFlightsButton.layer.zPosition=100;
        
        
        
        self.selectFlightsButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
   
//        if(self.isFlightList)
//        {
//            self.viewFlightButton.enabled=NO;
//            self.flightModifyButton.enabled=NO;
//            
//        }else
//        {
            self.viewFlightButton.hidden=YES;
            self.flightModifyButton.hidden=YES;
            self.flightViewSeperator.hidden=YES;

//        }
        
       // summaryDestinationPreference.airlinePreferenceString=@"(Self Arranged)";
        
    
        summaryDestinationPreference.airlinePreferenceString=@"(Self Arranged)";
        //summaryDestinationPreference.datePreferenceString=@"(Self Arranged)";
        
    }
    
    //sender.selected=!sender.selected;
    
}

- (IBAction)hotelNotRequiredAction:(UIButton*)sender {
    
  //  NSLog(@"hotel not required");
    
    
    if(!sender.selected)
    {
        
        self.hotelsNotRequiredButton.layer.shadowOpacity = 0.3;
        self.hotelsNotRequiredButton.layer.zPosition=101;
        self.hotelsNotRequiredButton.selected=YES;
        
        self.selectHotelsButton.selected=NO;
        self.selectHotelsButton.layer.shadowOpacity = 0.1;
        self.selectHotelsButton.layer.zPosition=100;
        
        
        self.selectHotelsButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
//        if(self.isHotelList)
//        {
//            self.viewHotelsButton.enabled=NO;
//            self.hotelsModifyButton.enabled=NO;
//            
//        }else
//        {
            self.viewHotelsButton.hidden=YES;
            self.hotelsModifyButton.hidden=YES;
            self.hotelsViewSeperator.hidden=YES;
            
//        }
        summaryDestinationPreference.accommodationPreferenceString=@"(Self Arranged)";
        
    }

    
}
- (IBAction)selectHotelAction:(UIButton*)sender {
    
   // NSLog(@"select hotel");
    
//    if(!sender.selected)
//    {
//        
        self.selectHotelsButton.layer.shadowOpacity = 0.3;
        self.selectHotelsButton.layer.zPosition=101;
        self.selectHotelsButton.selected=YES;
        
        self.hotelsNotRequiredButton.selected=NO;
        self.hotelsNotRequiredButton.layer.shadowOpacity = 0.1;
        self.hotelsNotRequiredButton.layer.zPosition=100;
        
        if(self.isHotelList)
        {
            self.selectHotelsButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            
           // self.viewHotelsButton.hidden=NO;
            self.hotelsModifyButton.hidden=NO;
          //  self.hotelsViewSeperator.hidden=NO;
            
            self.viewHotelsButton.enabled=YES;
            self.hotelsModifyButton.enabled=YES;
        }
        else
        {
            //select first time
  
            self.popUpView.hidden=NO;
            self.shadeView.hidden=NO;
            
            self.hotelScrollView.hidden=NO;
            
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select accommodation preference"];
            
            
            [self.accommodationTypeTable reloadData];
            [self.hotelChainTable reloadData];
            [self.locationTable reloadData];
            
            
            //self.isHotelList=YES;

        }
    

    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;
 
    
//    }
    
}
- (IBAction)activityNotRequiredAction:(UIButton*)sender {
    
 //   NSLog(@"activity not required");
    
    if(!sender.selected)
    {
    
        self.activityNotRequiredButton.layer.shadowOpacity = 0.3;
        self.activityNotRequiredButton.layer.zPosition=101;
        self.activityNotRequiredButton.selected=YES;
        
        self.selectActivityButton.selected=NO;
        self.selectActivityButton.layer.shadowOpacity = 0.1;
        self.selectActivityButton.layer.zPosition=100;
        
        self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);

        
//        if(self.isActivityList)
//        {
//            self.viewActivityButton.enabled=NO;
//            self.activityModifyButton.enabled=NO;
//            
//        }else
//        {
            self.viewActivityButton.hidden=YES;
            self.activityModifyButton.hidden=YES;
            
            self.activityViewSeperator.hidden=YES;
            
//        }
        summaryDestinationPreference.activityPreferenceString=@"(Self Arranged)";
    }
    
}

- (IBAction)selectActivityAction:(UIButton*)sender {

 //   NSLog(@"select activity");
    
//    if(allActivities.count)
//    {
//        [self.featuredViewPager reloadData];
//        [self.popularNearViewPager reloadData];
//        
//        [self initializePageControl];
//        
//        //    if(!sender.selected)
//        //    {
//        
//        self.selectActivityButton.layer.shadowOpacity = 0.3;
//        self.selectActivityButton.layer.zPosition=101;
//        self.selectActivityButton.selected=YES;
//        
//        self.activityNotRequiredButton.selected=NO;
//        self.activityNotRequiredButton.layer.shadowOpacity = 0.1;
//        self.activityNotRequiredButton.layer.zPosition=100;
//        
//        
//        if(self.isActivityList)
//        {
//            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
//            
//            self.viewActivityButton.hidden=NO;
//            self.activityModifyButton.hidden=NO;
//            self.activityViewSeperator.hidden=NO;
//            
//            self.viewActivityButton.enabled=YES;
//            self.activityModifyButton.enabled=YES;
//            
//            ///
//            
//        }
//        else
//        {
//            
//            self.popUpView.hidden=NO;
//            self.shadeView.hidden=NO;
//            
//            self.activityHeaderView.hidden=NO;
//            self.activityScrollView.hidden=NO;
//            
//            [self.activityTableView reloadData];
//            
//            [self.popupViewTitle setText:cityName];
//            [self.popupViewSubtitle setText:@"Select your activity preference"];
//            
//            
//        }
//        
//        self.saveButton.hidden=NO;
//        self.resetButton.hidden=NO;
//        self.showAllButton.hidden=YES;
//
//    }
    
    if(activitySections.count)
    {
        
        self.selectActivityButton.layer.shadowOpacity = 0.3;
        self.selectActivityButton.layer.zPosition=101;
        self.selectActivityButton.selected=YES;
        
        self.activityNotRequiredButton.selected=NO;
        self.activityNotRequiredButton.layer.shadowOpacity = 0.1;
        self.activityNotRequiredButton.layer.zPosition=100;
        
        
        if(self.isActivityList)
        {
            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            
           // self.viewActivityButton.hidden=NO;
            self.activityModifyButton.hidden=NO;
           // self.activityViewSeperator.hidden=NO;
            
            self.viewActivityButton.enabled=YES;
            self.activityModifyButton.enabled=YES;
            
            ///
            
        }
        else
        {
            
            self.popUpView.hidden=NO;
            self.shadeView.hidden=NO;
            
            //self.activityHeaderView.hidden=NO;
            self.activityListTableView.hidden=NO;
            
            [self.activityTable reloadData];
            
            
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select your activity preference"];
            
            
        }
        
        self.saveButton.hidden=NO;
        self.resetButton.hidden=NO;
        self.showAllButton.hidden=YES;
        
    }
    else
    {
    
        [KSToastView ks_showToast:@"There's no activity in this city" duration:2.0f];
    }

    

}
- (IBAction)flightModifyAction:(id)sender {
    
    self.popUpView.hidden=NO;
    self.shadeView.hidden=NO;
    
    self.flightScrollView.hidden=NO;
    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select your flight preference"];
    
    [self.flightTableList reloadData];
    
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;



    
    
}

- (IBAction)hotelModifyAction:(id)sender {
    
    self.popUpView.hidden=NO;
    self.shadeView.hidden=NO;
    
    self.hotelScrollView.hidden=NO;
    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select accommodation preference"];
    
    [self.accommodationTypeTable reloadData];
    [self.hotelChainTable reloadData];
    [self.locationTable reloadData];
    
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;

}

- (IBAction)activityModifyAction:(id)sender {
    
//    self.popUpView.hidden=NO;
//    self.shadeView.hidden=NO;
//    
//     [self initializePageControl];
//    
//    self.selectedActivityView.hidden=NO;
//    
//    [self.popupViewTitle setText:cityName];
//    [self.popupViewSubtitle setText:@"Select your activity preference"];
//    
//    [self.featuredViewPager reloadData];
//    [self.popularNearViewPager reloadData];
//    
//    [self.selectedActivityTable reloadData];
//  
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
//    self.showAllButton.hidden=NO;
    
    self.popUpView.hidden=NO;
    self.shadeView.hidden=NO;
    
    
    //self.activityHeaderView.hidden=NO;
    self.activityListTableView.hidden=NO;
    

     [self.activityTable reloadData];
    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select your activity preference"];
    

}



- (IBAction)addFlight:(id)sender {
    
    
    self.saveButton.hidden=YES;
    self.resetButton.hidden=YES;
    self.showAllButton.hidden=YES;
    self.todayButton.hidden=YES;
    
    [self.commonTable setHidden:NO];
    [self.genericDataTableView reloadData];
    
    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select preferred alliance"];
    
    
//    [self.flightLists addObject:@"Select Airlines"];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        self.flightTableHeight.constant= (self.flightLists.count)*60;
//    } completion:^(BOOL finished) {
//        ;
//        
//    }];
//    
//    
//    [self.flightTableList reloadData];
    
}

-(IBAction)addAccomodation:(id)sender {
    
    [self.accomodationTypeView setHidden:NO];
    [self.accomodationTypePicker reloadAllComponents];

    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select preferred accomodation type"];
    
//    [self.accommodationType addObject:@"Select Accomodation"];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        self.accommodationTableHeight.constant= (self.accommodationType.count)*60;
//    } completion:^(BOOL finished) {
//        ;
//        
//    }];
//    
//    
//    [self.accommodationTypeTable reloadData];
    
}

-(IBAction)addHoteLChain:(id)sender {
    
    
    self.saveButton.hidden=YES;
    self.resetButton.hidden=YES;
    self.showAllButton.hidden=YES;
    self.todayButton.hidden=YES;
    
    [self.commonTable setHidden:NO];
    [self.genericDataTableView reloadData];
    
    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select Preferred Hotel"];

//    
//    [self.hotelList addObject:@"Select Hotel"];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        self.hotelTableHeight.constant= (self.hotelList.count)*60;
//    } completion:^(BOOL finished) {
//        ;
//        
//    }];
//    
//    
//    [self.hotelChainTable reloadData];
//    
}

-(IBAction)addLocation:(id)sender {
    
    
    
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;
    self.todayButton.hidden=YES;
    
    [self.locationView setHidden:NO];
    [self.locationTableView reloadData];
    
    [self.popupViewTitle setText:cityName];
    [self.popupViewSubtitle setText:@"Select Preferred Locations"];
    
    
//    [self.locationList addObject:@"Select Location"];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        self.locationTableHeight.constant= (self.locationList.count)*60;
//    } completion:^(BOOL finished) {
//        ;
//        
//    }];
//    
//    
//    [self.locationTable reloadData];
    
}

-(void)deleteFlight
{
    
    [self.flightLists removeLastObject];
    // [self.destinations removeObjectAtIndex:indexPath.section];
    [UIView animateWithDuration:1.0 animations:^{
        
        self.flightTableHeight.constant= (self.flightLists.count)*50;

    } completion:^(BOOL finished) {
        ;
        
    }];
    
    [self.flightTableList reloadData];
    
}

-(void)deleteAccomodation
{
    
    [self.accommodationType removeLastObject];
    // [self.destinations removeObjectAtIndex:indexPath.section];
    [UIView animateWithDuration:1.0 animations:^{
        
        self.accommodationTableHeight.constant= (self.accommodationType.count)*50;
        
    } completion:^(BOOL finished) {
        ;
        
    }];
    
    [self.accommodationTypeTable reloadData];
    
}

-(void)deleteHotel
{
    
    [self.hotelList removeLastObject];
    // [self.destinations removeObjectAtIndex:indexPath.section];
    [UIView animateWithDuration:1.0 animations:^{
        
        self.hotelTableHeight.constant= (self.hotelList.count)*60;
        
    } completion:^(BOOL finished) {
        ;
        
    }];
    
    [self.hotelChainTable reloadData];
    
}

-(void)deleteLocation
{
    
    [self.locationList removeLastObject];
    // [self.destinations removeObjectAtIndex:indexPath.section];
    [UIView animateWithDuration:1.0 animations:^{
        
        self.locationTableHeight.constant= (self.locationList.count)*50;
        
    } completion:^(BOOL finished) {
        ;
        
    }];
    
    [self.locationTable reloadData];
    
}


- (IBAction)closePopUp:(id)sender {
    
    
    if(self.commonTable.hidden)
    {
         [self hideEveryPopup];
    }
    else
    {
        self.commonTable.hidden=YES;
        self.saveButton.hidden=NO;
        self.resetButton.hidden=NO;
        
        if(!self.flightScrollView.hidden)
        {
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select your flight preference"];
        }
        else
        {
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select accommodation preference"];
        }
    }
    
    
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    if(tableView.tag==101)
         return self.flightLists.count;
    else if(tableView.tag==201)
        return self.accommodationType.count;
    else if(tableView.tag==202)
        return self.hotelList.count;
    else if(tableView.tag==203)
        return self.locationList.count;
    else if(tableView.tag==204)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [locationSearchSections allKeys].count;
            
        } else {
            
            //NSLog(@"%lu",(unsigned long)[locationSectionTitles count]);
            return [locationSectionTitles count];
        }

    }
    else if ( tableView.tag==301)
    {
        return allActivities.count;
    }
    else if ( tableView.tag==303)
    {
        return selectedActivities.count;
    }
    else if ( tableView.tag==302 )
    {
        return 3;
    }
    else if(tableView.tag==304)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [activitySearchSections allKeys].count;
            
        } else {
            

            return [activitySectionTitles count];
        }
        
    }

    else
    {
        
        if (!self.hotelScrollView.hidden) {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                return [hotelSearchSections allKeys].count;
                
            } else {
                
                return [hotelsSectionTitles count];
            }
            
        }else
        {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                return [airlinesSearchSections allKeys].count;
                
            } else {
                
                return [airlinesSectionTitles count];
            }
        }
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    
    if(tableView.tag==101 || tableView.tag==201 || tableView.tag==202 || tableView.tag==203 || tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
    {
        return @"";
    }
    else if(tableView.tag==204)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [[locationSearchSections allKeys] objectAtIndex:section];
            
        } else {
           
            return [locationSectionTitles objectAtIndex:section];
        }
    }
    else if(tableView.tag==304)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [[activitySearchSections allKeys] objectAtIndex:section];
            
        } else {
            
            return [activitySectionTitles objectAtIndex:section];
        }
    }
    
    
    else
    {
        if (!self.hotelScrollView.hidden) {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                return [[hotelSearchSections allKeys] objectAtIndex:section];
                
            } else {
                return [hotelsSectionTitles objectAtIndex:section];
            }
        }
        else
        {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                return [[airlinesSearchSections allKeys] objectAtIndex:section];
                
            } else {
                return [airlinesSectionTitles objectAtIndex:section];
            }
        
        }
        
    
    }
   
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==101 || tableView.tag==201 || tableView.tag==202 || tableView.tag==203 || tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
        return 1;
    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if(tableView.tag==204)
        {
            NSString *sectionTitle = [[locationSearchSections allKeys] objectAtIndex:section];
            NSArray *sectionAnimals = [locationSearchSections objectForKey:sectionTitle];
            return [sectionAnimals count];
        }
        else if(tableView.tag==304)
        {
            NSString *sectionTitle = [[activitySearchSections allKeys] objectAtIndex:section];
            NSArray *sectionAnimals = [activitySearchSections objectForKey:sectionTitle];
            return [sectionAnimals count];
        }
        else
        {
            if (!self.hotelScrollView.hidden) {
                NSString *sectionTitle = [[hotelSearchSections allKeys] objectAtIndex:section];
                NSArray *sectionAnimals = [hotelSearchSections objectForKey:sectionTitle];
                return [sectionAnimals count];
            }
            else
            {
                NSString *sectionTitle = [[airlinesSearchSections allKeys] objectAtIndex:section];
                NSArray *sectionAnimals = [airlinesSearchSections objectForKey:sectionTitle];
                return [sectionAnimals count];
                
            }

        }

        
    } else {
        
        if(tableView.tag==204)
        {
            NSString *sectionTitle = [locationSectionTitles objectAtIndex:section];
            NSArray *sectionAnimals = [locationSections objectForKey:sectionTitle];
            return [sectionAnimals count];
        }
        else if(tableView.tag==304)
        {
            NSString *sectionTitle = [activitySectionTitles objectAtIndex:section];
            NSArray *sectionAnimals = [activitySections objectForKey:sectionTitle];
            return [sectionAnimals count];
        }

        else
        {
            if (!self.hotelScrollView.hidden) {
                NSString *sectionTitle = [hotelsSectionTitles objectAtIndex:section];
                NSArray *sectionAnimals = [hotelSections objectForKey:sectionTitle];
                return [sectionAnimals count];        }
            else
            {
                NSString *sectionTitle = [airlinesSectionTitles objectAtIndex:section];
                NSArray *sectionAnimals = [airlinesSections objectForKey:sectionTitle];
                return [sectionAnimals count];
                
            }

        }
        
        
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    static NSString *citiesTableIdentifier = @"CommonCell";
    UITableViewCell *cell;
    
    [[UITableViewCell appearance] setTintColor:[UIColor hx_colorWithHexString:@"#E03365"]];

    
    if(tableView.tag==101)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.layer.cornerRadius=2;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
            
        }
        UILabel *userName = (UILabel *)[cell viewWithTag:101];
        UIButton *dltButton = (UIButton *)[cell viewWithTag:102];
        
        
        cell.backgroundView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownBG"]];
        
        Airways* airline=[Airways new];
        airline=[self.flightLists objectAtIndex:indexPath.section];
        
               
        [userName setText:airline.name];
        
        
        [dltButton addTarget:self
                      action:@selector(deleteFlight)
            forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(tableView.tag==201)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.layer.cornerRadius=2;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
            
        }

        UILabel *userName = (UILabel *)[cell viewWithTag:101];
        UIButton *dltButton = (UIButton *)[cell viewWithTag:102];
        
        cell.backgroundView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownBG"]];
        
        [userName setText:[[self.accommodationType objectAtIndex:indexPath.section] objectForKey:@"title"]];
        [dltButton addTarget:self
                      action:@selector(deleteAccomodation)
            forControlEvents:UIControlEventTouchUpInside];

    }
    else if(tableView.tag==202)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.layer.cornerRadius=2;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
            
        }

        UILabel *userName = (UILabel *)[cell viewWithTag:101];
        UIButton *dltButton = (UIButton *)[cell viewWithTag:102];
        
        cell.backgroundView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownBG"]];
        
        Hotels *hotel = [Hotels new];
        hotel=[self.hotelList objectAtIndex:indexPath.section];
        
        
        [userName setText:hotel.name];
        [dltButton addTarget:self
                      action:@selector(deleteHotel)
            forControlEvents:UIControlEventTouchUpInside];

    }
    else if(tableView.tag==203)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        cell.layer.cornerRadius=2;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
            
        }

        UILabel *userName = (UILabel *)[cell viewWithTag:101];
        UIButton *dltButton = (UIButton *)[cell viewWithTag:102];
        
        cell.backgroundView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownBG"]];
        
        [userName setText:[[self.locationList objectAtIndex:indexPath.section] objectForKey:@"title"]];
        [dltButton addTarget:self
                      action:@selector(deleteLocation)
            forControlEvents:UIControlEventTouchUpInside];
    }
    else if(tableView.tag==204)
    {
       
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSString *sectionTitle = [[locationSearchSections allKeys] objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [locationSearchSections objectForKey:sectionTitle];
            cell.textLabel.text=[[contactsInSection objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            if([self.locationList containsObject:[contactsInSection objectAtIndex:indexPath.row]])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            
        } else {
            
            NSString *sectionTitle = [locationSectionTitles objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [locationSections objectForKey:sectionTitle];
            cell.textLabel.text=[[contactsInSection objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            if([self.locationList containsObject:[contactsInSection objectAtIndex:indexPath.row]])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
     
        
        
    }
    else if(tableView.tag==304)
    {
     
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        
        Activity *singleActivity = [Activity new];

        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSString *sectionTitle = [[activitySearchSections allKeys] objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [activitySearchSections objectForKey:sectionTitle];
            singleActivity=[contactsInSection objectAtIndex:indexPath.row];
            
          
            
        } else {
            
            NSString *sectionTitle = [activitySectionTitles objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [activitySections objectForKey:sectionTitle];
            singleActivity=[contactsInSection objectAtIndex:indexPath.row];
            
        }
        
        if([selectedActivities containsObject:singleActivity])
        {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",singleActivity.activityName];
        cell.imageView.image=nil ;
        
        
        
        
    }
    else if( tableView.tag==301 )
    {
        
        Activity *singleActivity = [Activity new];
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
    
        singleActivity=[allActivities objectAtIndex:indexPath.section];
        
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:3011];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleActivity.featuredImage]]];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius=3;
        
        
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:3012];
        [priceLabel setText:[[NSString stringWithFormat:@"AED %@",singleActivity.price] uppercaseString]];
        
        
        UIButton *activityName = (UIButton *)[cell viewWithTag:3013];
        [activityName setTitle:[singleActivity.activityName uppercaseString] forState:UIControlStateNormal];
        
        UIButton *addButton = (UIButton *)[cell viewWithTag:3014];
        
        UIButton *dynamicButton = addButton;
        dynamicButton.tag = indexPath.section;
        //NSLog(@"indexPath %ld",(long)indexPath.section);
       
        [dynamicButton addTarget:self action:@selector(addToActivityFromAll:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [addButton
//         addTarget:self
//         action:@selector(addToActivity) forControlEvents:UIControlEventTouchUpInside];
      
    }
    else if( tableView.tag==303 )
    {
        
        Activity *singleActivity = [Activity new];
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            
        }
        
        singleActivity=[selectedActivities objectAtIndex:indexPath.section];
        
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:3031];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleActivity.featuredImage]]];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius=3;
        
        
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:3032];
        [priceLabel setText:[[NSString stringWithFormat:@"AED %@",singleActivity.price] uppercaseString]];
        
        
        UIButton *activityName = (UIButton *)[cell viewWithTag:3033];
        [activityName setTitle:[singleActivity.activityName uppercaseString] forState:UIControlStateNormal];
        
        
        UIButton *removeButton = (UIButton *)[cell viewWithTag:3034];
        
        UIButton *dynamicButton = removeButton;
        dynamicButton.tag = indexPath.section;
        [dynamicButton addTarget:self action:@selector(removeFromActivity:) forControlEvents:UIControlEventTouchUpInside];
        
//        [removeButton
//         addTarget:self
//         action:@selector(removeFromActivity) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    else if( tableView.tag==302 )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            
        }

        
    }

    else
    {
        

        cell = [tableView dequeueReusableCellWithIdentifier:citiesTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:citiesTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        if (!self.hotelScrollView.hidden) {
            
            Hotels *hotel = [Hotels new];
            
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                
                NSString *sectionTitle = [[hotelSearchSections allKeys] objectAtIndex:indexPath.section];
                
                NSMutableArray *contactsInSection = [hotelSearchSections objectForKey:sectionTitle];
                hotel=[contactsInSection objectAtIndex:indexPath.row];
                
            } else {
                
                NSString *sectionTitle = [hotelsSectionTitles objectAtIndex:indexPath.section];
                
                NSMutableArray *contactsInSection = [hotelSections objectForKey:sectionTitle];
                hotel=[contactsInSection objectAtIndex:indexPath.row];
                
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",hotel.name];
            cell.imageView.image=nil ;

        }
        else
        {
            
            Airways *airline = [Airways new];
            
            
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                
                NSString *sectionTitle = [[airlinesSearchSections allKeys] objectAtIndex:indexPath.section];
                
                NSMutableArray *contactsInSection = [airlinesSearchSections objectForKey:sectionTitle];
                airline=[contactsInSection objectAtIndex:indexPath.row];
                
            } else {
                
                NSString *sectionTitle = [airlinesSectionTitles objectAtIndex:indexPath.section];
                
                NSMutableArray *contactsInSection = [airlinesSections objectForKey:sectionTitle];
                airline=[contactsInSection objectAtIndex:indexPath.row];
                
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",airline.name];
            
//            if(airline.logo)
//            {
//                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,airline.logo]]];
//                
//            }
//            else
//            {
//                cell.imageView.image=nil ;
//            }

        }
    
    }

    
    

    //[dltButton performSelector:@selector(deleteDestination) withObject:indexPath];
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView.tag==101  || tableView.tag==201 || tableView.tag==202 || tableView.tag==203 || tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
        
    {
        
    }
    
    else if (tableView.tag==204)
    {
        //NSLog(@"select location");
        NSMutableDictionary *location=[[NSMutableDictionary alloc] init];
        
        //Nsdictionary
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSString *sectionTitle = [[locationSearchSections allKeys] objectAtIndex:indexPath.section];
            NSMutableArray *contactsInSection = [locationSearchSections objectForKey:sectionTitle];
            location=[contactsInSection objectAtIndex:indexPath.row];
            
        } else {
            
            NSString *sectionTitle = [locationSectionTitles objectAtIndex:indexPath.section];
            NSMutableArray *contactsInSection = [locationSections objectForKey:sectionTitle];
            location=[contactsInSection objectAtIndex:indexPath.row];
            
        }
        
        //NSLog(@"%@",location);
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [self.locationList removeObject:location];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [self.locationList addObject:location];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        
       // [self.locationList addObject:location];
       
        [UIView animateWithDuration:1.0 animations:^{
            
            self.locationTableHeight.constant= (self.locationList.count)*50;
        } completion:^(BOOL finished) {
            ;
            
        }];
        
        
//        [self.locationTable reloadData];
        
//        [self.popupViewTitle setText:cityName];
//        [self.popupViewSubtitle setText:@"Select accommodation preference"];
//        
//        [self.locationView setHidden:YES];
//        
//        self.saveButton.hidden=NO;
//        self.resetButton.hidden=NO;
    }
    
    else if (tableView.tag==304)
    {
       // NSLog(@"select activity");
        
       
        
        Activity *singleActivity = [Activity new];
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSString *sectionTitle = [[activitySearchSections allKeys] objectAtIndex:indexPath.section];
            NSMutableArray *contactsInSection = [activitySearchSections objectForKey:sectionTitle];
            singleActivity=[contactsInSection objectAtIndex:indexPath.row];
            
        } else {
            
            NSString *sectionTitle = [activitySectionTitles objectAtIndex:indexPath.section];
            NSMutableArray *contactsInSection = [activitySections objectForKey:sectionTitle];
            singleActivity=[contactsInSection objectAtIndex:indexPath.row];
            
        }

        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [selectedActivities removeObject:singleActivity];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [selectedActivities addObject:singleActivity];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
              // NSMutableArray *choosenActivity=[[NSMutableArray alloc] init];
        
      
      
    }

    else
    {
        
        if (!self.hotelScrollView.hidden) {
           
            Hotels *hotel = [Hotels new];
            
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                
                NSString *sectionTitle = [[hotelSearchSections allKeys] objectAtIndex:indexPath.section];
                NSMutableArray *contactsInSection = [hotelSearchSections objectForKey:sectionTitle];
                hotel=[contactsInSection objectAtIndex:indexPath.row];
                
            } else {
                
                NSString *sectionTitle = [hotelsSectionTitles objectAtIndex:indexPath.section];
                NSMutableArray *contactsInSection = [hotelSections objectForKey:sectionTitle];
                hotel=[contactsInSection objectAtIndex:indexPath.row];
                
            }
            
            
            [self.hotelList addObject:hotel];
            
            
            [UIView animateWithDuration:1.0 animations:^{
                
                self.hotelTableHeight.constant= (self.hotelList.count)*50;
            } completion:^(BOOL finished) {
                ;
                
            }];
            
            [self.hotelChainTable reloadData];
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select accommodation preference"];

        
        
        }
        else
        {
        
            Airways *airline = [Airways new];
            
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                
                NSString *sectionTitle = [[airlinesSearchSections allKeys] objectAtIndex:indexPath.section];
                NSMutableArray *contactsInSection = [airlinesSearchSections objectForKey:sectionTitle];
                airline=[contactsInSection objectAtIndex:indexPath.row];
                
            } else {
                
                NSString *sectionTitle = [airlinesSectionTitles objectAtIndex:indexPath.section];
                NSMutableArray *contactsInSection = [airlinesSections objectForKey:sectionTitle];
                airline=[contactsInSection objectAtIndex:indexPath.row];
                
            }
            
            
            [self.flightLists addObject:airline];
            
            
            [UIView animateWithDuration:1.0 animations:^{
                
                self.flightTableHeight.constant= (self.flightLists.count)*50;
            } completion:^(BOOL finished) {
                ;
                
            }];
            
            [self.flightTableList reloadData];
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select your flight preference"];
        }
    
        

        
        [self.commonTable setHidden:YES];

        self.saveButton.hidden=NO;
        self.resetButton.hidden=NO;
    
    }
    
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView.tag==101  || tableView.tag==201 || tableView.tag==202 || tableView.tag==203 || tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
        
    {
        return nil;
    }
    else if (tableView.tag==204)
    {
        tableView.sectionIndexColor= [UIColor hx_colorWithHexString:@"#E03365"];
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return [locationSearchSections allKeys];
        
        } else {
        
            return locationSectionTitles;
        }

    
    }
    else if (tableView.tag==304)
    {
        tableView.sectionIndexColor= [UIColor hx_colorWithHexString:@"#E03365"];
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            return [activitySearchSections allKeys];
            
        } else {
            
            return activitySectionTitles;
        }
        
        
    }
    else
    {
        
        tableView.sectionIndexColor= [UIColor hx_colorWithHexString:@"#E03365"];
        
        
         if (!self.hotelScrollView.hidden) {
             if (tableView == self.searchDisplayController.searchResultsTableView) {
                 
                 return [hotelSearchSections allKeys];
                 
             } else {
                 return hotelsSectionTitles;
             }
         
         }else
         {
             if (tableView == self.searchDisplayController.searchResultsTableView) {
                 
                 return [airlinesSearchSections allKeys];
                 
             } else {
                 return airlinesSectionTitles;
             }
         
         }
        
    }
    
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
  
    if (tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
        return tableView.frame.size.width*0.6;
    else
        return 50;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
        return 10;
    else
        return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
    
    
    if(tableView.tag==101  || tableView.tag==201 || tableView.tag==202 || tableView.tag==203 || tableView.tag==301 || tableView.tag==302 || tableView.tag==303)
    {
            return 0.0;
    }
    else
    {
        return 25.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    if(tableView.tag==204)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [[locationSearchSections allKeys] indexOfObject:title];
            
        } else {
            return [locationSectionTitles indexOfObject:title];
            
        }

    }
    else if(tableView.tag==304)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [[activitySearchSections allKeys] indexOfObject:title];
            
        } else {
            return [activitySectionTitles indexOfObject:title];
            
        }
        
    }
    else
    {
        if (!self.hotelScrollView.hidden) {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                return [[hotelSearchSections allKeys] indexOfObject:title];
                
            } else {
                return [hotelsSectionTitles indexOfObject:title];
                
            }
            
        }
        else
        {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                return [[airlinesSearchSections allKeys] indexOfObject:title];
                
            } else {
                return [airlinesSectionTitles indexOfObject:title];
                
            }
            
        }

    }

}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor clearColor];
    
}


//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    return headerView;
//}

#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
    
    Activity *singleActivity = [Activity new];

    
    if(collectionView.tag==302)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedActivityCell" forIndexPath:indexPath];
        
        singleActivity=[featuredActivities objectAtIndex:indexPath.row];
        
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:3021];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleActivity.featuredImage]]];
        
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:3022];
        [priceLabel setText:[[NSString stringWithFormat:@"AED %@",singleActivity.price] uppercaseString]];

        
        UIButton *activityName = (UIButton *)[cell viewWithTag:3023];
        [activityName setTitle:[singleActivity.activityName uppercaseString] forState:UIControlStateNormal];
        
        UIButton *addButton = (UIButton *)[cell viewWithTag:3024];
        
        UIButton *dynamicButton = addButton;
        dynamicButton.tag = indexPath.row;
        [dynamicButton addTarget:self action:@selector(addToActivityFromFeatured:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [addButton
//         addTarget:self
//         action:@selector(addToActivity) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if(collectionView.tag==303)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopularActivityCell" forIndexPath:indexPath];
        
        singleActivity=[popularActivities objectAtIndex:indexPath.row];
        
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:3031];
        //NSLog(@"%@/%@",SERVER_BASE_API_URL,singleActivity.featuredImage);
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleActivity.featuredImage]]];
        
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:3032];
        [priceLabel setText:[[NSString stringWithFormat:@"AED %@",singleActivity.price] uppercaseString]];

        
        UIButton *activityName = (UIButton *)[cell viewWithTag:3033];
        [activityName setTitle:[singleActivity.activityName uppercaseString] forState:UIControlStateNormal];
        
        UIButton *addButton = (UIButton *)[cell viewWithTag:3034];
        
        UIButton *dynamicButton = addButton;
        dynamicButton.tag = indexPath.row;
        [dynamicButton addTarget:self action:@selector(addToActivityFromPopular:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        [addButton
//         addTarget:self
//         action:@selector(addToActivity) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;

    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView.tag==302)
    {
        return  featuredActivities.count;
    }else if(collectionView.tag==303)
    {
        
        return  popularActivities.count;
    }
    else
        return 4;
}




/*
 HWViewPagerDelegate
 connection IBOulet with Storyboard
 
 or
 call method : " [pager setPagerDelegate:id] "
 
 */

#pragma mark - HWViewPagerDelegate
-(void)pagerDidSelectedPage:(NSInteger)selectedPage with:(NSInteger *)pagerTag{
    NSLog(@"FistViewController, SelectedPage : %@ pagerTag %d",[@(selectedPage) stringValue],(int)pagerTag);
    
    if((int)pagerTag==302)
    {
        self.featuredPageControl.currentPage = selectedPage;

    }
    else if ((int)pagerTag==303)
    {
        self.popularPageControl.currentPage = selectedPage;
    }
    
}


-(IBAction)checkTapped:(UIButton*)sender {
    
    sender.selected=!sender.selected;
    
    
}
- (IBAction)classTapped:(UIButton*)sender {

    UIButton *random;
    
    for (int i=201; i<=203; i++) {
        
        random = (UIButton *)[self.view viewWithTag:i];
        if(random.tag!=sender.tag)
            random.selected=NO;
        else
        {
            if (!sender.selected) {
                sender.selected=!sender.selected;
                if(sender.tag==201)
                    airlineClass=@"First";

                else  if(sender.tag==202)
                    airlineClass=@"Business";

                else if(sender.tag==203)
                    airlineClass=@"Economy";

            }
        }
        
    }
}


#pragma mark - Actions

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    [self updateRangeText];
}

-(void)addToActivityFromFeatured:(UIButton*) sender
{
   // NSLog(@"featured sender %ld",(long)sender.tag);
    
    [selectedActivities addObject:[featuredActivities objectAtIndex:sender.tag]];
}
-(void)addToActivityFromPopular:(UIButton*) sender
{
   // NSLog(@"popular sender %ld",(long)sender.tag);
    [selectedActivities addObject:[popularActivities objectAtIndex:sender.tag]];
}
-(void)addToActivityFromAll:(UIButton*) sender
{
   // NSLog(@"all activity sender %ld",(long)sender.tag);
    [selectedActivities addObject:[allActivities objectAtIndex:sender.tag]];
}

-(void)removeFromActivity:(UIButton*) sender
{

    //NSLog(@"sender %ld",(long)sender.tag);
    [selectedActivities removeObjectAtIndex:sender.tag];
    [self.selectedActivityTable reloadData];
}

#pragma mark - UI

- (void)setUpViewComponentsFrom:(CGFloat)initialValue to:(CGFloat)rightValue
{


    // Init slider
    [self.rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    self.rangeSlider.minimumValue = 0.001;
    self.rangeSlider.maximumValue = 1.0;
    self.rangeSlider.leftValue = initialValue;
    self.rangeSlider.rightValue = rightValue;
    self.rangeSlider.minimumDistance = 0.01;
    self.rangeSlider.pushable=YES;
    
    [self updateRangeText];
  
}

- (void)updateRangeText
{
    CGFloat bubblePosition;
    bubblePosition=((self.rangeSlider.leftValue+(self.rangeSlider.rightValue-self.rangeSlider.leftValue)/2)-0.5);
    
    
    //NSLog(@"%0.2f - %0.2f", self.rangeSlider.leftValue, self.rangeSlider.rightValue);
    if(bubblePosition>(-0.3) && bubblePosition<0.3)
    {
        self.centerOfRangeLabel.constant=bubblePosition*self.rangeSlider.frame.size.width;
        
    }
    
    [self.rangeLabel setTitle:[NSString stringWithFormat:@"$%0.0f - $%0.0f",
                               self.rangeSlider.leftValue*1000, self.rangeSlider.rightValue*1000] forState:UIControlStateNormal];



}

- (IBAction)saveAction:(id)sender {
    
    if(!self.flightScrollView.hidden)
    {
        self.isFlightList=YES;
        self.flightScrollView.hidden=YES;
        
        self.selectFlightsButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
        //self.viewFlightButton.hidden=NO;
        self.flightModifyButton.hidden=NO;
        //self.flightViewSeperator.hidden=NO;
        
        self.viewFlightButton.enabled=YES;
        self.flightModifyButton.enabled=YES;
        
        [self hideEveryPopup];
        
        if([airlineClass isEqualToString:@"(null)"])
           airlineClass=@"Economy";
            
            
        cityPreference.preferred_airline_class=airlineClass;
        cityPreference.are_dates_flexible=self.flexibleDatesButton.selected;
        
        NSString* airPreferenceString=@"";
        
         NSMutableArray* flightIdsList=[[NSMutableArray alloc]init];
         for (int i=0; i<self.flightLists.count; i++) {
             
             Airways* airline=[Airways new];
             airline=[self.flightLists objectAtIndex:i];
             [flightIdsList addObject:airline.airwaysId];
             
             
             if(i==0)
             {
                 airPreferenceString=[NSString stringWithFormat:@"%@",airline.name];
             }
             else
             {
                airPreferenceString=[NSString stringWithFormat:@"%@, %@",airPreferenceString,airline.name];
             }
         }
      
        
         NSMutableDictionary* flightListDictionary=[[NSMutableDictionary alloc] init];
         [flightListDictionary setObject:flightIdsList forKey:@"_ids"];
         
         cityPreference.airlines=flightListDictionary;
        
        if(airPreferenceString.length)
            airPreferenceString=[NSString stringWithFormat:@"%@\n%@",airPreferenceString,cityPreference.preferred_airline_class];
        else
            airPreferenceString=cityPreference.preferred_airline_class;
        
        summaryDestinationPreference.airlinePreferenceString=airPreferenceString;
        
        if(self.flexibleDatesButton.selected)
        {
            summaryDestinationPreference.datePreferenceString=[NSString stringWithFormat:@"%@ *(flexible)",summaryDestinationPreference.datePreferenceString];
        }
        

    }
    else if (!self.hotelScrollView.hidden && !self.locationView.hidden)
    {
        //self.locationList = [self.locationList valueForKeyPath:@"@distinctUnionOfObjects.self"];
        //NSLog(@"self.locationList %@",self.locationList);
        
            [self.locationTable reloadData];
        
            [self.popupViewTitle setText:cityName];
            [self.popupViewSubtitle setText:@"Select accommodation preference"];
        
            [self.locationView setHidden:YES];
        
            self.saveButton.hidden=NO;
            self.resetButton.hidden=NO;
    }
    else if (!self.hotelScrollView.hidden && self.accomodationTypeView.hidden)
    {
        self.isHotelList=YES;
        self.hotelScrollView.hidden=YES;
        
        self.selectHotelsButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
        
        //self.viewHotelsButton.hidden=NO;
        self.hotelsModifyButton.hidden=NO;
       // self.hotelsViewSeperator.hidden=NO;
        
        self.viewHotelsButton.enabled=YES;
        self.hotelsModifyButton.enabled=YES;
        
        [self hideEveryPopup];
        
        
        cityPreference.accomodation_budget = self.rangeLabel.titleLabel.text;
        summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"Budget: %@",cityPreference.accomodation_budget];
        
        //add accommodation type
        NSMutableArray* accommodationTypeIds=[[NSMutableArray alloc]init];
        for (int i=0; i<self.accommodationType.count; i++) {
            [accommodationTypeIds addObject:[[self.accommodationType objectAtIndex:i] objectForKey:@"id"] ];
            
                summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.accommodationPreferenceString,[[self.accommodationType objectAtIndex:i] objectForKey:@"title"] ];
                
            
        }
        
        
        NSMutableDictionary* accommodationDictionary=[[NSMutableDictionary alloc] init];
        [accommodationDictionary setObject:accommodationTypeIds forKey:@"_ids"];
        
        cityPreference.accomodation_types=accommodationDictionary;
        
        
        //add location
       
        
        NSMutableArray* locationIdsArray=[[NSMutableArray alloc]init];
        for (int i=0; i< self.locationList.count; i++) {
            [locationIdsArray addObject:[[self.locationList objectAtIndex:i] objectForKey:@"id"] ];
            
         
                summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.accommodationPreferenceString,[[self.locationList objectAtIndex:i] objectForKey:@"title"] ];
         }
        
        
        NSMutableDictionary* locationDictionary=[[NSMutableDictionary alloc] init];
        [locationDictionary setObject:locationIdsArray forKey:@"_ids"];
        
        cityPreference.destinations=locationDictionary;
        
        //add hotel
        NSMutableArray* hotelIdsList=[[NSMutableArray alloc]init];
        for (int i=0; i<self.hotelList.count; i++) {
            
            Hotels* hotel=[Hotels new];
            hotel=[self.hotelList objectAtIndex:i];
            [hotelIdsList addObject:hotel.hotelId];
            
            
            summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.accommodationPreferenceString,hotel.name ];
        }
        
        
        NSMutableDictionary* hotelListDictionary=[[NSMutableDictionary alloc] init];
        [hotelListDictionary setObject:hotelIdsList forKey:@"_ids"];
        
        cityPreference.hotels=hotelListDictionary;
        
        cityPreference.accommodation_comment=self.accommodationTextView.text;
        
    }
 
    else if (!self.activityScrollView.hidden || !self.selectedActivityView.hidden)
    {
        //select first time
       
        
        if(selectedActivities.count)
        {
            self.isActivityList=YES;
            
            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            
            //self.viewActivityButton.hidden=NO;
            self.activityModifyButton.hidden=NO;
            //self.activityViewSeperator.hidden=NO;
            
            self.viewActivityButton.enabled=YES;
            self.activityModifyButton.enabled=YES;
        }
        
        
        [self hideEveryPopup];
        
    }
    else if (!self.activityListTableView.hidden)
    {
        if(selectedActivities.count)
        {
            self.isActivityList=YES;
            
            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            
           // self.viewActivityButton.hidden=NO;
            self.activityModifyButton.hidden=NO;
           // self.activityViewSeperator.hidden=NO;
            
            self.viewActivityButton.enabled=YES;
            self.activityModifyButton.enabled=YES;
        }
        
        
        [self hideEveryPopup];
    }
    else if (!self.datePickerView.hidden)
    {
        if (!dateSelected) {
            dateSelected=[NSDate date];
        }
        
        if(self.isArrivalDate)
        {
            [self.arivalDate setText:[self getDateFromString:dateSelected]];
            cityPreference.arrival_date=[self getDateData:dateSelected];
        }
        else
        {
            [self.DepDate setText:[self getDateFromString:dateSelected]];
            cityPreference.departure_date=[self getDateData:dateSelected];

        }
        [self hideEveryPopup];
    }
    else if (!self.accomodationTypeView.hidden)
    {
        [self.popupViewTitle setText:cityName];
        [self.popupViewSubtitle setText:@"Select accommodation preference"];
        
        
        [self.accomodationTypeView setHidden:YES];
        
        if(!accomodationType)
        {
            if(accomodationTypesArray.count)
                accomodationType=[accomodationTypesArray objectAtIndex:0];
            
        }
    
        if(accomodationType)
        {
            [self.accommodationType addObject:accomodationType];
            
            [UIView animateWithDuration:1.0 animations:^{
                
                self.accommodationTableHeight.constant= (self.accommodationType.count)*50;
            } completion:^(BOOL finished) {
                ;
                
            }];
        }
        else
        {
            NSLog(@"Please Select One type First");
        }
        
            
            
            [self.accommodationTypeTable reloadData];
        
    }
    
    
    
}

-(IBAction)resetAction:(id)sender
{
    NSLog(@"Reset Called");
    
    if(!self.flightScrollView.hidden)
    {
        self.isFlightList=NO;
     
        self.selectFlightsButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
        self.viewFlightButton.hidden=YES;
        self.flightModifyButton.hidden=YES;
        self.flightViewSeperator.hidden=YES;
    
        
        [cityPreference.airlines removeAllObjects];
        
        self.flightLists=[[NSMutableArray alloc] init];
        [self.flightTableList reloadData];
        
        self.flightTableHeight.constant= (self.flightLists.count)*50;
        
        airlineClass=@"Economy";
        cityPreference.preferred_airline_class=airlineClass;
        cityPreference.are_dates_flexible=NO;
        self.flexibleDatesButton.selected=NO;
        
        summaryDestinationPreference.airlinePreferenceString=@"(Self Arranged)";
        summaryDestinationPreference.datePreferenceString=@"(Self Arranged)";
        
        UIButton *random1 = (UIButton *)[self.view viewWithTag:203];
        random1.selected=YES;
        
        UIButton *random2 = (UIButton *)[self.view viewWithTag:202];
        random2.selected=NO;
        
        UIButton *random3 = (UIButton *)[self.view viewWithTag:201];
        random3.selected=NO;
        
    }
    else if (!self.hotelScrollView.hidden && !self.locationView.hidden)
    {
        //self.locationList = [self.locationList valueForKeyPath:@"@distinctUnionOfObjects.self"];
        //NSLog(@"self.locationList %@",self.locationList);
        
        self.locationList=[[NSMutableArray alloc] init];
        [self.locationTable reloadData];
        [self.locationTableView reloadData];
        self.locationTableHeight.constant= (self.locationList.count)*50;
        
        [self.popupViewTitle setText:cityName];
        [self.popupViewSubtitle setText:@"Select accommodation preference"];
        
        [self.locationView setHidden:YES];
        
        self.saveButton.hidden=NO;
        self.resetButton.hidden=NO;
    }
    else if (!self.hotelScrollView.hidden && self.accomodationTypeView.hidden)
    {
        self.isHotelList=NO;
        self.hotelScrollView.hidden=NO;
        
        self.selectHotelsButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
        
        self.viewHotelsButton.hidden=YES;
        self.hotelsModifyButton.hidden=YES;
        self.hotelsViewSeperator.hidden=YES;
        
        
        //[self updateRangeText];
        [self setUpViewComponentsFrom:0.2 to:.5];
        cityPreference.accomodation_budget = self.rangeLabel.titleLabel.text;
        summaryDestinationPreference.accommodationPreferenceString=@"(Self Arranged)";
        
        cityPreference.accommodation_comment=@"";
        self.accommodationTextView.text=@"";
        [self adjustFrames];
        
        self.accommodationType=[[NSMutableArray alloc] init];
        self.locationList=[[NSMutableArray alloc ] init];
        self.hotelList=[[NSMutableArray alloc] init];
        
        [self.accommodationTypeTable reloadData];
        [self.locationTable reloadData];
        [self.hotelChainTable reloadData];
        
        self.accommodationTableHeight.constant= (self.accommodationType.count)*50;
        self.locationTableHeight.constant= (self.locationList.count)*50;
        self.hotelTableHeight.constant= (self.hotelList.count)*50;

        
        [cityPreference.accomodation_types removeAllObjects];
        [cityPreference.destinations removeAllObjects];
        [cityPreference.hotels removeAllObjects];
        
    }
    
    else if (!self.activityScrollView.hidden || !self.selectedActivityView.hidden)
    {
        //select first time
        
        
        if(selectedActivities.count)
        {
            self.isActivityList=YES;
            
            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(-20,0 , 0, 0);
            
            //self.viewActivityButton.hidden=NO;
            self.activityModifyButton.hidden=NO;
            //self.activityViewSeperator.hidden=NO;
            
            self.viewActivityButton.enabled=YES;
            self.activityModifyButton.enabled=YES;
        }
        
        
        [self hideEveryPopup];
        
    }
    else if (!self.activityListTableView.hidden)
    {
       
        selectedActivities=[[NSMutableArray alloc] init];
        [self.activityTable reloadData];
        
            self.isActivityList=NO;
            
            self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
            
            self.viewActivityButton.hidden=YES;
            self.activityModifyButton.hidden=YES;
            self.activityViewSeperator.hidden=YES;
            
            self.viewActivityButton.enabled=NO;
            self.activityModifyButton.enabled=NO;
        
    }
    else if (!self.datePickerView.hidden)
    {
//        if (!dateSelected) {
//            dateSelected=[NSDate date];
//        }
//        
//        if(self.isArrivalDate)
//        {
//            [self.arivalDate setText:[self getDateFromString:dateSelected]];
//            cityPreference.arrival_date=[self getDateData:dateSelected];
//        }
//        else
//        {
//            [self.DepDate setText:[self getDateFromString:dateSelected]];
//            cityPreference.departure_date=[self getDateData:dateSelected];
//            
//        }
//        [self hideEveryPopup];
    }
    else if (!self.accomodationTypeView.hidden)
    {
        [self.popupViewTitle setText:cityName];
        [self.popupViewSubtitle setText:@"Select accommodation preference"];
        
        
        [self.accomodationTypeView setHidden:YES];
        
        //[self.accommodationTypeTable reloadData];
        
    }

}

-(void) hideEveryPopup
{
    [self.popupViewTitle setText:@""];
    [self.popupViewSubtitle setText:@""];

    [self.accommodationTextView resignFirstResponder];
    
    self.popUpView.hidden=YES;
    self.shadeView.hidden=YES;
    
    self.hotelScrollView.hidden=YES;
    self.flightScrollView.hidden=YES;
    self.activityHeaderView.hidden=YES;
    self.activityScrollView.hidden=YES;
    self.selectedActivityView.hidden=YES;
    self.datePickerView.hidden=YES;
    self.commonTable.hidden=YES;
    self.accomodationTypeView.hidden=YES;
    self.locationView.hidden=YES;
    self.activityListTableView.hidden=YES;
    
    self.saveButton.hidden=YES;
    self.resetButton.hidden=YES;
    self.todayButton.hidden=YES;
    self.showAllButton.hidden=YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.shadeView)
    {
        [self hideEveryPopup];
        
    }
    
    [self.view endEditing:YES];
    [self.accommodationTextView resignFirstResponder];
    

}

-(void)tapGestureInAccommodation: (UIEvent *)event
{
    
    [self.accommodationTextView resignFirstResponder];
}


- (IBAction)activityCategoryChanged:(UISegmentedControl*)sender {
    
    if (sender.selectedSegmentIndex == 0)
    {
        //All Activity
        self.allActivityView.hidden=NO;
        self.favActivityView.hidden=YES;
        
        [self.activityTableView reloadData];
        
        self.activityScrollView.contentSize=CGSizeMake(self.activityScrollView.frame.size.width, self.allActivityView.frame.size.height);
    }
    else
    {
        self.allActivityView.hidden=YES;
        self.favActivityView.hidden=NO;
        
        [self.favActivityTable reloadData];
        
        
        self.activityScrollView.contentSize=CGSizeMake(self.activityScrollView.frame.size.width, self.favActivityTable.frame.size.height);
        [self.activityScrollView setContentOffset:CGPointZero animated:NO];
       // [self.favActivityTable setContentOffset:CGPointZero animated:NO];
    }

}

- (IBAction)removeAllAction:(id)sender {
    
    
    selectedActivities=[[NSMutableArray alloc] init];
    
    self.isActivityList=NO;
    
    self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
    
    self.viewActivityButton.hidden=YES;
    self.activityModifyButton.hidden=YES;
    self.activityViewSeperator.hidden=YES;
    
    self.viewActivityButton.enabled=NO;
    self.activityModifyButton.enabled=NO;

    
    self.selectedActivityView.hidden=YES;
    
    self.activityHeaderView.hidden=NO;
    self.activityScrollView.hidden=NO;
    
    [self.activityTableView reloadData];
    
    [self.activitySegment setSelectedSegmentIndex:0];
    self.allActivityView.hidden=NO;
    self.favActivityView.hidden=YES;
    
    
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;
    
}
- (IBAction)showAllActivity:(id)sender {
    
//    self.selectActivityButton.titleEdgeInsets=UIEdgeInsetsMake(0,0 , 0, 0);
//    
//    self.viewActivityButton.hidden=YES;
//    self.activityModifyButton.hidden=YES;
//    self.activityViewSeperator.hidden=YES;
//    
//    self.viewActivityButton.enabled=NO;
//    self.activityModifyButton.enabled=NO;
    
    
    self.selectedActivityView.hidden=YES;
    
    self.activityHeaderView.hidden=NO;
    self.activityScrollView.hidden=NO;
    
    [self.activityTableView reloadData ];
    
    [self.activitySegment setSelectedSegmentIndex:0];
    
    self.allActivityView.hidden=NO;
    self.favActivityView.hidden=YES;
    
    self.activityScrollView.contentSize=CGSizeMake(self.activityScrollView.frame.size.width, self.allActivityView.frame.size.height);
    
    self.saveButton.hidden=NO;
    self.resetButton.hidden=NO;
    self.showAllButton.hidden=YES;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scroll %lf",scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y >= 325) {
//        [scrollView setScrollEnabled:NO];
//        [scrollView setContentOffset:CGPointMake(0, 325) animated:NO];
//        [scrollView setScrollEnabled:YES];
//    }
}
- (IBAction)arrivalsPicker:(id)sender {
//    ESTimePicker *timePicker = [[ESTimePicker alloc] initWithDelegate:self]; // Delegate is optional
//    [timePicker setFrame:CGRectMake(20, 150, 300, 300)];
//    [self.view addSubview:timePicker];

    self.isArrivalDate=YES;
    
    [self showDatePicker];
   // [self showClockView];
}

- (IBAction)departurePicker:(id)sender {
    
    self.isArrivalDate=NO;
    [self showDatePicker];
}

- (void)timePickerHoursChanged:(ESTimePicker *)timePicker toHours:(int)hours
{
    [self.arivalDate setText:[NSString stringWithFormat:@"%i", hours]];
}

- (void)timePickerMinutesChanged:(ESTimePicker *)timePicker toMinutes:(int)minutes
{
    [self.arivalDate setText:[NSString stringWithFormat:@"%i", minutes]];
}

-(void)showClockView{
    
    self.clockView = [[CustomTimePicker alloc] initWithView:self.view withDarkTheme:YES];
    self.clockView.delegate = self;
    [self.view addSubview:self.clockView];
}

-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode{
    
    
    [self.arivalDate setText:[NSString stringWithFormat:@"%@:%@  %@",hours,minutes,timeMode]];
    
    //[self.hourLabel setFont:[UIFont boldSystemFontOfSize:30]];
    
    //[self.view addSubview:self.hourLabel];
    
    //[self.initiateClock setHidden:FALSE];
}

-(void)showDatePicker
{
    
    self.datePickerView.hidden=NO;
    
    self.popUpView.hidden=NO;
    self.shadeView.hidden=NO;
    
    self.saveButton.hidden=NO;
    self.todayButton.hidden=NO;
    
    if (self.isArrivalDate) {
        [self.popupViewTitle setText:@"Arrival date"];
        [self.popupViewSubtitle setText:@"Select arrival date"];
    }
    else
    {
        [self.popupViewTitle setText:@"Departure date"];
        [self.popupViewSubtitle setText:@"Select departure date"];
    }
    
    
    
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor hx_colorWithHexString:@"#E03365"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(dateSelected && [_calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor hx_colorWithHexString:@"#E03365"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor hx_colorWithHexString:@"#E03365"];
        dayView.textLabel.textColor = [UIColor hx_colorWithHexString:@"#5A5A5A"];
    }
    
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Views customization

- (void)createMinAndMaxDate
{
    todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    minDate = [_calendarManager.dateHelper addToDate:todayDate months:0];
    maxDate = [_calendarManager.dateHelper addToDate:todayDate months:24];
    
    
    
}

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:todayDate];
}

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UILabel *label = [UILabel new];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"AzoSans-Medium" size:16];
    
    return label;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"AzoSans-Regular" size:14];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    //view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    view.textLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:13];
    //[UIFont fontWithName:@"AzoSans-Regular" size:15];
 
    view.circleRatio = .8;
    view.dotRatio = 1. / .9;
    
    return view;
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:minDate andEqualOrBefore:maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

//- (BOOL)haveEventForDay:(NSDate *)date
//{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//    
//    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
//        return YES;
//    }
//    
//    return NO;
//    
//}

//- (void)createRandomEvents
//{
//    _eventsByDate = [NSMutableDictionary new];
//    
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//        
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//        
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//        
//        [_eventsByDate[key] addObject:randomDate];
//    }
//}
//
#pragma mark - PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return accomodationTypesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  
    return [[accomodationTypesArray objectAtIndex:row] objectForKey:@"title"];
}
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
   
    
    NSLog(@"%@",[[accomodationTypesArray objectAtIndex:row] objectForKey:@"title"]);
    accomodationType=[[NSMutableDictionary alloc] init];
    accomodationType=[accomodationTypesArray objectAtIndex:row];
  
}

#pragma mark - Textview delegate

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    //textView.text=@"";
    
    //self.formScrollView.contentOffset = CGPointMake(0, textView.frame.origin.y);
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"Add any additional details here"])
        textView.text = @"";
    
    textView.textColor = [UIColor hx_colorWithHexString:@"#5A5A5A"];
    return YES;
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
  
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self adjustFrames];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Add any additional details here";
        [textView resignFirstResponder];
    }
    
}

-(void) adjustFrames
{
    CGRect textFrame = self.accommodationTextView.frame;
    textFrame.size.height = self.accommodationTextView.contentSize.height;
    self.accommodationTextView.frame = textFrame;
    self.textViewHeightConstraint.constant=textFrame.size.height;
    //NSLog(@"textFrame.size.height %lf",textFrame.size.height);
    
    //CGPoint bottomOffset = CGPointMake(0, self.hotelScrollView.contentSize.height - self.hotelScrollView.bounds.size.height);
    //[self.hotelScrollView setContentOffset:bottomOffset animated:YES];
    
}

- (void)registerForKeyboardNotifications{

    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWasShown:)

                                                 name:UIKeyboardDidShowNotification object:nil];



    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWillBeHidden:)

                                                 name:UIKeyboardWillHideNotification object:nil];

}
- (void)keyboardWasShown:(NSNotification*)aNotification{

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.hotelScrollView.contentInset = contentInsets;
    self.hotelScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.popUpView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect,  self.accommodationTextView.frame.origin) ) {
       
        CGPoint scrollPoint = CGPointMake(0.0, self.accommodationTextView.frame.origin.y-kbSize.height);
        [self.hotelScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.hotelScrollView.contentInset = contentInsets;
    self.hotelScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)NextTapped:(UIButton *)sender {
    
    
//    NSMutableArray* tempCityIdsArray=[[NSMutableArray alloc] init];
//    tempCityIdsArray=[[Trip sharedManager].citiesIdsArray mutableCopy];
//    
    
    //[tempCityIdsArray removeObjectAtIndex:0];
    //[Trip sharedManager].citiesIdsArray=tempCityIdsArray;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:currentCityIndex+1] forKey:@"currentCityIndex"];

}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
 //   NSLog(@"citiesIdsArray %lu",(unsigned long)[Trip sharedManager].citiesIdsArray.count);
    
    
//    if ([identifier isEqualToString:@"sendToExpert"])
//    {
//        NSLog(@"in expert");
//         if([Trip sharedManager].citiesIdsArray.count)
//         {
//             return NO;
//         }
//         else
//            return YES;
//
//    }
    
    if ([identifier isEqualToString:@"sendToCity"])
    {
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityIndex"] unsignedIntegerValue]< [Trip sharedManager].citiesIdsArray.count && !self.isFromSummary)
        {
           
//            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityIndex"] unsignedIntegerValue]<[Trip sharedManager].cities_trips.count)
//            {
//                NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
//                
//                UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers];
//                
//                
//                [self.navigationController popToViewController:vc animated:NO];
//                
//                return NO;
//            }
//            else
                return YES;
        }
        else if (self.isFromSummary)
        {
            [self updateEditedPreference];
            self.isFromSummary=false;
            
            [self.navigationController popViewControllerAnimated:YES];
            return NO;

        }
        else
        {
            [self performSegueWithIdentifier:@"sendToExpert" sender:sender];

            return NO;
        }
        
        
    }
    else
    {
        
        return YES;
    }
    
}

-(void) updateEditedPreference
{
    NSMutableArray* activityIdsList=[[NSMutableArray alloc]init];
    summaryDestinationPreference.activityPreferenceString=@"(Self Arranged)";
    for (int i=0; i<selectedActivities.count; i++) {
        
        Activity* activity=[Activity new];
        activity=[selectedActivities objectAtIndex:i];
        [activityIdsList addObject:activity.activityId];
        
        if(i==0)
        {
            summaryDestinationPreference.activityPreferenceString=[NSString stringWithFormat:@"%@",activity.activityName];
        }
        else
        {
            summaryDestinationPreference.activityPreferenceString=[NSString stringWithFormat:@"%@, %@",summaryDestinationPreference.activityPreferenceString,activity.activityName];
        }
        
    }
   // NSLog(@"summaryDestinationPreference.activityPreferenceString %@",summaryDestinationPreference.activityPreferenceString);
    
    NSMutableDictionary* activityListDictionary=[[NSMutableDictionary alloc] init];
    [activityListDictionary setObject:activityIdsList forKey:@"_ids"];
    
    cityPreference.activities=activityListDictionary;
    
    
    NSLog(@"cityPreference %@",[cityPreference toNSDictionary]);
    
    
    NSMutableArray* tempTripsArray=[[NSMutableArray alloc] init];
    tempTripsArray=[[Trip sharedManager].cities_trips mutableCopy];
    
    
    if(currentCityIndex < tempTripsArray.count)
        [tempTripsArray replaceObjectAtIndex:currentCityIndex withObject:cityPreference.toNSDictionary];
    else
        
        [tempTripsArray addObject:cityPreference.toNSDictionary];
    
    
    [Trip sharedManager].cities_trips=tempTripsArray;
    
    
    
    if (activityIdsList.count) {
        
        
        
        NSMutableArray* tempTripsArray=[[NSMutableArray alloc] init];
        tempTripsArray=[[Trip sharedManager].activityIdsArray mutableCopy ];
        
        [tempTripsArray addObjectsFromArray:activityIdsList];
        
        [Trip sharedManager].activityIdsArray=tempTripsArray;
        
        //NSLog(@"activityIdsList %@", tempTripsArray);
    }
    
    NSMutableArray* tempSummaryArray=[[NSMutableArray alloc] init];
    tempSummaryArray=[[Summary sharedManager].destinationDetails mutableCopy];
    
    
    
    if(currentCityIndex < tempSummaryArray.count)
        [tempSummaryArray replaceObjectAtIndex:currentCityIndex withObject:summaryDestinationPreference.toNSDictionary];
    else
        
        [tempSummaryArray addObject:summaryDestinationPreference.toNSDictionary];
    
    
    
    [Summary sharedManager].destinationDetails=tempSummaryArray;

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
   // selectedActivities = [selectedActivities valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    
    NSMutableArray* activityIdsList=[[NSMutableArray alloc]init];
    for (int i=0; i<selectedActivities.count; i++) {
        
        Activity* activity=[Activity new];
        activity=[selectedActivities objectAtIndex:i];
        [activityIdsList addObject:activity.activityId];
        
        if(i==0)
        {
            summaryDestinationPreference.activityPreferenceString=[NSString stringWithFormat:@"%@",activity.activityName];
        }
        else
        {
          summaryDestinationPreference.activityPreferenceString=[NSString stringWithFormat:@"%@, %@",summaryDestinationPreference.activityPreferenceString,activity.activityName];
        }
      
    }
    
    
    NSMutableDictionary* activityListDictionary=[[NSMutableDictionary alloc] init];
    [activityListDictionary setObject:activityIdsList forKey:@"_ids"];
    
    cityPreference.activities=activityListDictionary;
    
    
    //NSLog(@"cityPreference %@",[cityPreference toNSDictionary]);
    
    
    NSMutableArray* tempTripsArray=[[NSMutableArray alloc] init];
    tempTripsArray=[[Trip sharedManager].cities_trips mutableCopy];
    
    if(currentCityIndex < tempTripsArray.count)
        [tempTripsArray replaceObjectAtIndex:currentCityIndex withObject:cityPreference.toNSDictionary];
    else
        
        [tempTripsArray addObject:cityPreference.toNSDictionary];
    
    
    [Trip sharedManager].cities_trips=tempTripsArray;
    

    
    if (activityIdsList.count) {
        
        NSMutableArray* tempTripsArray=[[NSMutableArray alloc] init];
        tempTripsArray=[[Trip sharedManager].activityIdsArray mutableCopy ];
       
        [tempTripsArray addObjectsFromArray:activityIdsList];
        
        [Trip sharedManager].activityIdsArray=tempTripsArray;
        
        //NSLog(@"activityIdsList %@", tempTripsArray);
    }
    
    NSMutableArray* tempSummaryArray=[[NSMutableArray alloc] init];
    tempSummaryArray=[[Summary sharedManager].destinationDetails mutableCopy];
    
    
    
    if(currentCityIndex < tempSummaryArray.count)
        [tempSummaryArray replaceObjectAtIndex:currentCityIndex withObject:summaryDestinationPreference.toNSDictionary];
    else
        
        [tempSummaryArray addObject:summaryDestinationPreference.toNSDictionary];
    
    
    
    [Summary sharedManager].destinationDetails=tempSummaryArray;
    
     //NSLog(@"%@", [Summary sharedManager].destinationDetails);
    
    //sendToExpert
    
    
}


@end
