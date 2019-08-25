//
//  MessageBoardViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 4/20/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "MessageBoardViewController.h"
#import "ItineraryViewController.h"
#import "Constants.h"

#import "Trip.h"
#import "Summary.h"
#import "Messages.h"
#import "Itinerarie.h"
#import "Expert.h"
#import "SummaryDestination.h"


@interface MessageBoardViewController ()
{
    NSInteger selectedExpert;
    NSInteger checkedExpert;
    
    int selectedExpertId;
    
    NSArray *rootOfAllMessage;
    
    NSMutableArray* expertList;
    NSMutableArray* itinerariesList;
    NSMutableArray* messageList;
    
    NSMutableArray* dummyDataForAllMessage;
    NSMutableArray* dummyDataForAllItineraries;
    
    PTPusher *pusherClient;
    NSTimer *countDownTimer;
    NSDate *endDate;

}

@end

@implementation MessageBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"tripDetails s%@",self.tripDetails);
    
    if (self.isFromInboxVC) {
        
        
    }else{
        
       self.tripId=[[self.tripDetails objectForKey:@"trip_id"] intValue];
       self.tripName= [NSString stringWithFormat:@"%@",[self.tripDetails objectForKey:@"trip_title"]];
    
    }

    
    [self configureSummary];
    
    pusherClient = [PTPusher pusherWithKey:@"3ecfd8838e81ab117836" delegate:self encrypted:YES cluster:@"ap1"];
    
    //[self.client connect];
    
    PTPusherChannel *channel = [pusherClient subscribeToChannelNamed:@"tripronto"];
    
    [channel bindToEventNamed:@"trip-message" handleWithBlock:^(PTPusherEvent *channelEvent) {
      
        NSLog(@"message received: %@", [channelEvent.data objectForKey:@"message"]);
        
        [self loadDetails];

    }];
    NSLog(@"why didload");
    [pusherClient connect];


    
    if(self.tripName.length)
        
        [self.navTitle setText:self.tripName];
    
    if (self.selectedTabIndex == 0)
    {
        self.segmentControl.selectedSegmentIndex=0;
        [self.allUpdatesView setHidden:NO];
        [self.iteneraryView setHidden:YES];
        [self.manageView setHidden:YES];
    }
    else  if (self.selectedTabIndex == 1)
    {
        self.segmentControl.selectedSegmentIndex=1;
        [self.allUpdatesView setHidden:YES];
        [self.iteneraryView setHidden:NO];
        [self.manageView setHidden:YES];
    }
    else
    {
        self.segmentControl.selectedSegmentIndex=2;
        [self.allUpdatesView setHidden:YES];
        [self.iteneraryView setHidden:YES];
        [self.manageView setHidden:NO];
    }
    
    if(self.isPastTrip)
    {
        self.checkoutButton.hidden=YES;
        self.withDrawButton.hidden=YES;
    }
    
    selectedExpert=0;
    checkedExpert=500;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"AzoSans-Regular" size:14],
                               NSForegroundColorAttributeName : [UIColor hx_colorWithHexString:@"#5A5A5A"]
                               };
    
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString : @"Type your message here"
                                                                    attributes : attrDict];
    
    self.inputView.layer.zPosition=101;
    self.inputTextField.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1];
    self.inputTextField.placeholderAttributedText=labelText;
    
    
    [self registerForKeyboardNotifications];
    
    NSLog(@"self.inputTextField %@",self.inputTextField);
    
    self.inputTextField.textColor=[UIColor hx_colorWithHexString:@"#5A5A5A"];
    
    
   
    
//  for (int i=0; i<10; i++) {
//        [messageList addObject:@"1"];
//  }

    self.expertSelectorFilter.delegate=self;
    self.expertSelectorFilter.dataSource=self;
    
    self.expertSelectorForIteneray.delegate=self;
    self.expertSelectorForIteneray.dataSource=self;
    
    
//  self.feedTableView.estimatedRowHeight = 80;//the estimatedRowHeight but if is more this autoincremented with autolayout
//  self.feedTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self.feedTableView setNeedsLayout];
    [self.feedTableView layoutIfNeeded];
    self.feedTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    self.feedTableView.delegate=self;
    self.feedTableView.dataSource=self;
    
    self.iteneraryFeedTableView.delegate=self;
    self.iteneraryFeedTableView.dataSource=self;
    
    self.ExpertListTableView.delegate=self;
    self.ExpertListTableView.dataSource=self;
    
   
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureInFeedTable:)];
    [self.feedTableView addGestureRecognizer:singleTap];
    
    
    [self loadDetails];
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    NSDate *tempDate;
    
    
    if (self.isFromInboxVC) {
        
        tempDate = [self getDateFromString:self.tripCreatedTime];
        
    }else{
        
       tempDate = [[self getDateFromString:[self.tripDetails objectForKey:@"created"]] dateByAddingTimeInterval:60*60*24];
    }
    
    NSLog(@"tempDate %@ ",tempDate);
    NSDate * now = [NSDate date];
    
    NSComparisonResult result = [now compare:tempDate];
    
    
    if (result == NSOrderedDescending) {
        
        [self.timerView setHidden:YES];
        
    }else{
    
        [self.timerView setHidden:NO];
        [self loadTimers];
    }
    
    
//    if(!self.isPastTrip )
//    {
//        [self.timerView setHidden:NO];
//        [self loadTimers];
//        
//    }else
//        [self.timerView setHidden:YES];

}

- (void)registerForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    self.inputViewBottomConstant.constant=kbSize.height-49;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    
     self.inputViewBottomConstant.constant=0;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

-(void)configureSummary
{
    
        if([self.tripDetails objectForKey:@"summaryData"])
        {
//            NSData *data = [[self.tripDetails objectForKey:@"json_summary"] dataUsingEncoding:NSUTF8StringEncoding];
//            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSMutableDictionary *json=[[NSMutableDictionary alloc] init];
            json=[self.tripDetails objectForKey:@"summaryData"];
    
            NSLog(@"jsonObject=%@", json );
    
            [Summary sharedManager ].tripDays=[[json objectForKey:@"tripDays"] intValue];
            [Summary sharedManager ].totalAdults=[[json objectForKey:@"totalAdults"] intValue];
            [Summary sharedManager ].totalChilds=[[json objectForKey:@"totalChilds"] intValue];
            [Summary sharedManager ].numberOfPlaces=[[json objectForKey:@"numberOfPlaces"] intValue];
    
            [Summary sharedManager ].startingCity=[json objectForKey:@"startingCity"];
            [Summary sharedManager ].startingDate=[self getDateFromString:[json objectForKey:@"startingDate"]];
    
            [Summary sharedManager ].destinationDetails=[[NSMutableArray alloc] init];
            [Summary sharedManager ].destinationDetails=[json objectForKey:@"destinationDetails"];
    
            [Summary sharedManager ].summaryForExperts=[[NSMutableArray alloc] init];
            //[Summary sharedManager ].summaryForExperts=[json objectForKey:@"summaryForExperts"];
    
            [Trip sharedManager].title= self.tripName;
    
            self.summaryViewButton.enabled=YES;
            
        }
        else
        {
            
            if([self.tripDetails objectForKey:@"detail"])
            {
               
                if([[self.tripDetails objectForKey:@"detail"] objectForKey:@"adults"] != [NSNull null])
                {
                    [Summary sharedManager ].totalAdults=[[[self.tripDetails objectForKey:@"detail"] objectForKey:@"adults"] intValue];
                }
                
                
                
                if([[self.tripDetails objectForKey:@"detail"] objectForKey:@"childs"] != [NSNull null])
                {
                    NSMutableArray *childArry=[[NSMutableArray alloc] init];
                    childArry=[[self.tripDetails objectForKey:@"detail"] objectForKey:@"childs"];
                    [Summary sharedManager ].totalChilds=(int)childArry.count;
                }
                
                [Summary sharedManager ].startingDate= [self getDateFromString:[self.tripDetails objectForKey:@"start_date"]];
                [Summary sharedManager ].startingCity=[NSString stringWithFormat:@"%@, %@",[[[self.tripDetails objectForKey:@"detail"] objectForKey:@"starting_location_detail"] objectForKey:@"title"],[[[[self.tripDetails objectForKey:@"detail"] objectForKey:@"starting_location_detail"] objectForKey:@"country"] objectForKey:@"title"]];
                
                NSMutableArray *citiesDetailsArray=[[NSMutableArray alloc]init];
                citiesDetailsArray=[[self.tripDetails objectForKey:@"detail"] objectForKey:@"cities_trips"];
                
                [Summary sharedManager ].numberOfPlaces=(int)citiesDetailsArray.count;
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                    fromDate:[Summary sharedManager].startingDate
                                                                      toDate:[self getDateFromString:[[citiesDetailsArray objectAtIndex:citiesDetailsArray.count-1] objectForKey:@"departure_date"]]
                                                                     options:NSCalendarWrapComponents];
                
                [Summary sharedManager].tripDays=(int)[components day];
                [Summary sharedManager ].destinationDetails=[[NSMutableArray alloc] init];
                
                
                NSMutableArray* tempSummaryArray=[[NSMutableArray alloc] init];
                
                for (int i=0; i<citiesDetailsArray.count;i++) {
                    
                    SummaryDestination  *summaryDestinationPreference=[SummaryDestination new];
                    
                    summaryDestinationPreference.destinationName=[NSString stringWithFormat:@"%@",[[[citiesDetailsArray objectAtIndex:i] objectForKey:@"city"] objectForKey:@"title"]];
                    summaryDestinationPreference.datePreferenceString=[self getDateFormatFromDate:[self getDateFromString:[[citiesDetailsArray objectAtIndex:i] objectForKey:@"departure_date"]]];
                    
                    if([[[citiesDetailsArray objectAtIndex:i] objectForKey:@"are_dates_flexible"] intValue])
                    {
                        summaryDestinationPreference.datePreferenceString=[NSString stringWithFormat:@"%@ *(flexible)",summaryDestinationPreference.datePreferenceString];
                        
                    }
                    if([[citiesDetailsArray objectAtIndex:i] objectForKey:@"accomodation_budget"] != [NSNull null] && ![[[citiesDetailsArray objectAtIndex:i] objectForKey:@"accomodation_budget"] isEqualToString:@""])
                    {
                        summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"Budget: %@",[[citiesDetailsArray objectAtIndex:i] objectForKey:@"accomodation_budget"]];
                        
                    }
                    
                    NSMutableArray *accommodationTypesArray=[[NSMutableArray alloc] init];
                    accommodationTypesArray=[[citiesDetailsArray objectAtIndex:i] objectForKey:@"accomodation_types"];
                    
                    for (int j=0; j<accommodationTypesArray.count; j++) {
                        
                        summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.accommodationPreferenceString,[[accommodationTypesArray objectAtIndex:j] objectForKey:@"title"] ];
                        
                        
                    }
                    NSMutableArray *accommodationLocationsArray=[[NSMutableArray alloc] init];
                    accommodationLocationsArray=[[citiesDetailsArray objectAtIndex:i] objectForKey:@"accommodation_locations"];
                    
                    
                    for (int j=0; j<accommodationLocationsArray.count; j++) {
                        
                        summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.accommodationPreferenceString,[[accommodationLocationsArray objectAtIndex:j] objectForKey:@"title"] ];
                        
                        
                    }
                    
                    NSMutableArray *hotelsArray=[[NSMutableArray alloc] init];
                    hotelsArray=[[citiesDetailsArray objectAtIndex:i] objectForKey:@"hotels"];
                    
                    
                    for (int j=0; j<hotelsArray.count; j++) {
                        
                        summaryDestinationPreference.accommodationPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.accommodationPreferenceString,[[hotelsArray objectAtIndex:j] objectForKey:@"title"] ];
                        
                    }
                    
                    NSMutableArray *airlinesArray=[[NSMutableArray alloc] init];
                    airlinesArray=[[citiesDetailsArray objectAtIndex:i] objectForKey:@"airlines"];
                    
                    
                    for (int j=0; j<airlinesArray.count; j++) {
                        
                        if(j==0)
                        {
                            summaryDestinationPreference.airlinePreferenceString=[[airlinesArray objectAtIndex:j] objectForKey:@"title"];
                            
                        }else
                            
                            summaryDestinationPreference.airlinePreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.airlinePreferenceString,[[airlinesArray objectAtIndex:j] objectForKey:@"title"] ];
                        
                    }
                    
                    summaryDestinationPreference.airlinePreferenceString=[NSString stringWithFormat:@"%@\n%@", summaryDestinationPreference.airlinePreferenceString,[[citiesDetailsArray objectAtIndex:i] objectForKey:@"preferred_airline_class"] ];
                    
                    
                    
                    NSMutableArray *activitiesArray=[[NSMutableArray alloc] init];
                    activitiesArray=[[[citiesDetailsArray objectAtIndex:i] objectForKey:@"city"] objectForKey:@"activities"];
                    
                    
                    for (int j=0; j<activitiesArray.count; j++) {
                        
                        if(j==0)
                        {
                            summaryDestinationPreference.activityPreferenceString=[[activitiesArray objectAtIndex:j] objectForKey:@"title"];
                            
                        }else
                            
                            summaryDestinationPreference.activityPreferenceString=[NSString stringWithFormat:@"%@, %@", summaryDestinationPreference.activityPreferenceString,[[activitiesArray objectAtIndex:j] objectForKey:@"title"] ];
                        
                    }
                    
                    [tempSummaryArray addObject:summaryDestinationPreference.toNSDictionary];
                }
                
                [Summary sharedManager].destinationDetails=tempSummaryArray;
                [Summary sharedManager ].summaryForExperts=[[NSMutableArray alloc] init];
                
                [Trip sharedManager].title= self.tripName;
                [Trip sharedManager].isOneWay=[[[self.tripDetails objectForKey:@"detail"] objectForKey:@"is_one_way"] intValue];
                self.summaryViewButton.enabled=YES;
                
                NSLog(@"[Summary sharedManager] %@",[Summary sharedManager].toNSDictionary);
                
                self.summaryViewButton.enabled=YES;
                
            }
            else
            {
                self.summaryViewButton.enabled=NO;
                
               
            }
            
        }
    
}


-(void)loadDetails
{
    
    expertList=[[NSMutableArray alloc] init];
    itinerariesList=[[NSMutableArray alloc] init];
    messageList=[[NSMutableArray alloc] init];
    
    
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:self.tripId] forKey:@"trip_id"];
    
    NSLog(@"full trip messages %@",postData);
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/trip-messages/api-get-trip-messages",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"responseObject %@ ",responseObject);
    
        NSMutableArray *expertsArray=[[NSMutableArray alloc] init];
        expertsArray=[responseObject objectForKey:@"experts"];
        
        for (int i=0; i<expertsArray.count; i++) {
            
            Expert *singleExpert=[Expert new];
            singleExpert.expertId=[[[expertsArray objectAtIndex:i] objectForKey:@"id"] intValue];
            singleExpert.userId=[[[[expertsArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"id"] intValue];
            singleExpert.expertName=[NSString stringWithFormat:@"%@ %@",[[[expertsArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"first_name"],[[[expertsArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"last_name"]];
            singleExpert.image=[[[expertsArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"photo_reference"];
            
            [expertList addObject:singleExpert];
            
        }
       
        [self.expertSelectorFilter reloadData];
        [self.expertSelectorForIteneray reloadData];
        [self.ExpertListTableView reloadData];
        
        
        if(!expertList.count)
        {
            [self.ExpertListTableView setHidden:YES];
            
        }
        else
        {
            [self.ExpertListTableView setHidden:NO];
            
        }
        
        
        
        
        NSMutableArray *itinerariesArray=[[NSMutableArray alloc] init];
        itinerariesArray=[responseObject objectForKey:@"itineraries"];
        
        //Sort itinerariesArray
        
        for (int i=0; i<itinerariesArray.count; i++) {
            
            Itinerarie *singleItinerary=[Itinerarie new];
            singleItinerary.itinerarieId=[[[itinerariesArray objectAtIndex:i] objectForKey:@"id"] intValue];
            singleItinerary.sendingDate= [self getDateFromString:[[itinerariesArray objectAtIndex:i] objectForKey:@"created"]];

            
            for (int j=0; j<expertList.count; j++) {
                
                Expert *singleExpert=[Expert new];
                singleExpert=[expertList objectAtIndex:j];
                
                if([[[itinerariesArray objectAtIndex:i] objectForKey:@"expert_id"] intValue]== singleExpert.expertId)
                {
                    singleExpert.itineraryNumber+=1;
                  
                    singleItinerary.versionNo=singleExpert.itineraryNumber;
                  
                    singleItinerary.expert=singleExpert;
                    [expertList replaceObjectAtIndex:j withObject:singleExpert];
                    break;
                }
                
            }
            
            
        NSUInteger newIndex = [itinerariesList indexOfObject:singleItinerary
                                         inSortedRange:(NSRange){0, [itinerariesList count]}
                                               options:NSBinarySearchingInsertionIndex
                                       usingComparator:^(Itinerarie *obj1, Itinerarie *obj2) {
                                          
                                           return [ obj2.sendingDate compare: obj1.sendingDate];
                                       }];
            
        [itinerariesList insertObject:singleItinerary atIndex:newIndex];
            
        //    [itinerariesList addObject:singleItinerary];
      
        }
        
        dummyDataForAllItineraries=[[NSMutableArray alloc] initWithArray:itinerariesList];
        //dummyDataForAllItineraries=itinerariesList;
       
        
        if(dummyDataForAllItineraries.count )
        {
            [countDownTimer invalidate];
            [self.timerView setHidden:YES];
            
            [self.iteneraryFeedTableView setHidden:NO];
            [self.iteneraryFeedTableView reloadData];
        }
        
        else
        {
            [self.iteneraryFeedTableView setHidden:YES];
//            if(!self.isPastTrip)
//            {
//                [self.timerView setHidden:NO];
//                [self loadTimers];
//
//            }else
//                [self.timerView setHidden:YES];
            
            
            //[KSToastView ks_showToast:@"There are no itineraries from any of the experts yet" duration:2.0f];
            
        }
        
        NSMutableArray *messageArray=[[NSMutableArray alloc] init];
        messageArray=[responseObject objectForKey:@"messages"];
        
        for (int i=0; i<messageArray.count; i++) {
            
            Messages *singleMessage=[Messages new];
            singleMessage.messageId=[[[messageArray objectAtIndex:i] objectForKey:@"id"] intValue];
            singleMessage.messageDetails=[[messageArray objectAtIndex:i] objectForKey:@"message"];
            singleMessage.modifiedDate= [self getDateFromString:[[messageArray objectAtIndex:i] objectForKey:@"modified"]];
            singleMessage.comments=[[NSMutableArray alloc] init];
            
            int j;
            for (j=0; j<expertList.count; j++) {
                
                Expert *singleExpert=[Expert new];
                singleExpert=[expertList objectAtIndex:j];
                
                if([[[messageArray objectAtIndex:i] objectForKey:@"user_id"] intValue]== singleExpert.userId)
                {
                    singleMessage.user=singleExpert;
                    break;
                }
                
            }
            
            if(j==expertList.count)
            {
                Expert *singleExpert=[Expert new];
                singleExpert.userId=[Trip sharedManager].user_id;
                singleExpert.expertName=[NSString stringWithFormat:@"%@ %@",[Trip sharedManager].userFirstName,[Trip sharedManager].userLastName];
                singleExpert.image=[Trip sharedManager].userImageName;
                
                singleMessage.user=singleExpert;

            }
            
            
            
            NSMutableArray *commentsArray=[[NSMutableArray alloc] init];
            commentsArray=[[messageArray objectAtIndex:i] objectForKey:@"trip_message_comments"];

            
            for (int k=0; k<commentsArray.count; k++) {
                
                Messages *singleComment=[Messages new];
                singleComment.messageId=[[[commentsArray objectAtIndex:k] objectForKey:@"id"] intValue];
                singleComment.messageDetails=[[commentsArray objectAtIndex:k] objectForKey:@"comment"];
                singleComment.modifiedDate= [self getDateFromString:[[commentsArray objectAtIndex:k] objectForKey:@"modified"]];
                
                for (int l=0; l<expertList.count; l++) {
                    
                    Expert *singleExpert=[Expert new];
                    singleExpert=[expertList objectAtIndex:l];
                    
                    if([[[commentsArray objectAtIndex:k] objectForKey:@"user_id"] intValue]== singleExpert.userId)
                    {
                        singleComment.user=singleExpert;
                        break;
                    }
                    
                }
                
                NSUInteger newIndex = [singleMessage.comments indexOfObject:singleComment
                                                       inSortedRange:(NSRange){0, [singleMessage.comments count]}
                                                             options:NSBinarySearchingInsertionIndex
                                                     usingComparator:^(Messages *obj1, Messages *obj2) {
                                                         
                                                         return [ obj2.modifiedDate compare: obj1.modifiedDate];
                                                     }];
                
                [singleMessage.comments insertObject:singleComment atIndex:newIndex];

                
                //[singleMessage.comments addObject:singleComment];
                
            }

            
            NSUInteger newIndex = [messageList indexOfObject:singleMessage
                                                          inSortedRange:(NSRange){0, [messageList count]}
                                                                options:NSBinarySearchingInsertionIndex
                                                        usingComparator:^(Messages *obj1, Messages *obj2) {
                                                            
                                                            return [ obj2.modifiedDate compare: obj1.modifiedDate];
                                                        }];
            
            [messageList insertObject:singleMessage atIndex:newIndex];
            
           // [messageList addObject:singleMessage];
        }

        NSLog(@"message %@",messageList);
      
        
        //rootOfAllMessage=messageList;
        
        NSMutableArray* allMessage=[[NSMutableArray alloc] init];
        
        [allMessage addObjectsFromArray:messageList];
        [allMessage addObjectsFromArray:itinerariesList];
        
        rootOfAllMessage = [allMessage sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSDate *aDate = [self dateForObject:obj1];
            NSDate *bDate = [self dateForObject:obj2];
                      return [ bDate compare: aDate];
        }];
        
        
        dummyDataForAllMessage=[[NSMutableArray alloc] initWithArray:rootOfAllMessage];
        
        //dummyDataForAllMessage=[rootOfAllMessage mutableCopy];
        
        
        if(dummyDataForAllMessage.count )
        {
            [self.feedTableView setHidden:NO];
            [self.feedTableView reloadData];
        }
        
        else
        {
            [self.feedTableView setHidden:YES];
            [KSToastView ks_showToast:@"There are no responses yet" duration:2.0f];
            
        }
        
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
        [KSToastView ks_showToast:@"Connection Timeout" duration:2.0f];
    }];
    
}

- (NSDate *)dateForObject:(id) obj
{
    if ([obj class] == [Messages class]) {
        return ((Messages*) obj).modifiedDate;
    }
    else {
        return ((Itinerarie*) obj).sendingDate;
    }
}

-(IBAction)backButtonAction:(id)sender
{
    [countDownTimer invalidate];
    [self.timerView setHidden:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark collectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(expertList.count)
        return expertList.count+1;
    else
        return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userBg.png"]];
    
    
    Expert *cellExpert=[Expert new];
 

    
    UIImageView *expertImage=(UIImageView*) [cell viewWithTag:101];
    
    UILabel *expertName= (UILabel*) [cell viewWithTag:102];
    UIView *expertLine= (UIView*) [cell viewWithTag:103];

    
    if(indexPath.row==0)
    {
    
        expertImage.image=[UIImage imageNamed:@"allExpertButton.png"];
        
        [expertName setText:@""];
    }
    else
    {
       // expertImage.image=[UIImage imageNamed:@"expertSelectPic.png"];
        cellExpert=[expertList objectAtIndex:indexPath.row-1];
        [expertImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,cellExpert.image]]];
        
        
    
        [expertName setText:cellExpert.expertName];
    }
    
    if(indexPath.row==selectedExpert)
    {
        expertLine.hidden=NO;
    }
    else
    {
        expertLine.hidden=YES;

    }
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.zPosition=100;
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self.view endEditing:YES];
    selectedExpert=indexPath.row;
   
   
    [collectionView reloadData];
    
    
    if(collectionView==self.expertSelectorFilter)
    {
        //all message
        // selectedExpertId=((Expert*)[expertList objectAtIndex:indexPath.row]).expertId;
        
        dummyDataForAllMessage=[[NSMutableArray alloc] init];
        if(indexPath.row==0)
        {
            dummyDataForAllMessage=[rootOfAllMessage mutableCopy];
            
        }
        else
        {
            
            
            for (int i=0; i<rootOfAllMessage.count; i++) {
                
                id obj= [rootOfAllMessage objectAtIndex:i];
                
                if ([obj class] == [Messages class]) {
                    if ([((Messages*) obj).user isEqual:((Expert*)[expertList objectAtIndex:indexPath.row-1])]) {
                        [dummyDataForAllMessage addObject:[rootOfAllMessage objectAtIndex:i]];
                    }
                }
                else {
                    if ([((Itinerarie*) obj).expert isEqual:((Expert*)[expertList objectAtIndex:indexPath.row-1])]) {
                        [dummyDataForAllMessage addObject:[rootOfAllMessage objectAtIndex:i]];
                    }
                    
                }

            }
            
        }
        
        if(dummyDataForAllMessage.count )
        {
            [self.feedTableView setHidden:NO];
            [self.feedTableView reloadData];
        }
        
        else
        {
            [self.feedTableView setHidden:YES];
            [KSToastView ks_showToast:@"There are no responses yet" duration:2.0f];
            
        }
        
        //[self.feedTableView reloadData];

        //dummyDataForAllMessage=[tempArray mutableCopy];

        
    }
    else
    {
         //selectedExpertId=((Expert*)[expertList objectAtIndex:indexPath.row]).expertId;
        
        dummyDataForAllItineraries=[[NSMutableArray alloc] init];
        if(indexPath.row==0)
        {
            dummyDataForAllItineraries=itinerariesList;
        }
        else
        {
            
            for (int i=0; i<itinerariesList.count; i++) {
                
                Itinerarie *singleItinerary=[Itinerarie new];
                singleItinerary=[itinerariesList objectAtIndex:i];
               
                if ([singleItinerary.expert isEqual:((Expert*)[expertList objectAtIndex:indexPath.row-1])]) {
                        [dummyDataForAllItineraries addObject:singleItinerary];
               
                
                }
            }

        }
        
        if(dummyDataForAllItineraries.count )
        {
            [self.iteneraryFeedTableView setHidden:NO];
            [self.iteneraryFeedTableView reloadData];
        }
        
        else
        {
            [self.iteneraryFeedTableView setHidden:YES];
            //[KSToastView ks_showToast:@"There are no itineraries from any of the experts yet" duration:2.0f];
            
        }
        
       // [self.iteneraryFeedTableView reloadData];

    }
    
//    cell.layer.masksToBounds = NO;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    cell.layer.shadowRadius = 5;
//    cell.layer.shadowOpacity = 0.8;
//    cell.layer.zPosition=101;
    
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((collectionView.bounds.size.width-15)*0.20, collectionView.bounds.size.height );
//}


#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (tableView==self.ExpertListTableView) {
        return expertList.count;
    }
    else  if (tableView==self.iteneraryFeedTableView) {
        return dummyDataForAllItineraries.count;
    }
    else
        return dummyDataForAllMessage.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier;
    
    if (tableView==self.ExpertListTableView) {
        simpleTableIdentifier = @"ExpertCell";//iteneraryCell
        
        ManageExpertCell *cell = (ManageExpertCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        cell.layer.cornerRadius = 2.0f;
        
        
        if(cell.checkButton.tag==checkedExpert)
        {
            cell.checkButton.selected=YES;
        }else
        {
            cell.checkButton.selected=NO;
        }
        
        Expert *cellExpert=[Expert new];
        cellExpert=[expertList objectAtIndex:indexPath.section];
        
        cell.expertName.text=cellExpert.expertName;
        cell.numberOfSubmit.text=[NSString stringWithFormat:@"%i Itinerary Submitted",cellExpert.itineraryNumber];
        
        [cell.expertPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,cellExpert.image]]];
        
        if(self.isPastTrip)
        {
            cell.checkButton.hidden=YES;
            cell.deleteButton.hidden=YES;
            
            cell.checkButtonFixedWidth.active=YES;
            cell.checkButtonWidthConstraint.active=NO;
        }
        else
        {
            cell.checkButtonWidthConstraint.active=YES;
            cell.checkButtonFixedWidth.active=NO;

            cell.checkButton.hidden=NO;
            [cell.checkButton
             addTarget:self
             action:@selector(expertClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.checkButton.tag=indexPath.section;
            
            cell.deleteButton.hidden=NO;

            

        }
        
        

        
        return cell;

    }
    else
    {
        if(tableView==self.iteneraryFeedTableView)
        {
            simpleTableIdentifier = @"itinerayMsgCell";//iteneraryCell
            
            MessageCommentTableViewCell *cell = (MessageCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
            
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
            }
            
            cell.layer.cornerRadius = 2.0f;
            
            Itinerarie *cellItinerary=[Itinerarie new];
            cellItinerary=[dummyDataForAllItineraries objectAtIndex:indexPath.section];
            
            [cell.userName setText:cellItinerary.expert.expertName];
            [cell.messageDate setText:[self getStringFromDate:cellItinerary.sendingDate]];
            [cell.userMessage setText:[NSString stringWithFormat:@"Itinerary %i submitted by %@",cellItinerary.versionNo, cellItinerary.expert.expertName]];
            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,cellItinerary.expert.image]]];
            
            
            return cell;

        }
        else
        {
            

            if([[dummyDataForAllMessage objectAtIndex:indexPath.section] class] == [Messages class])
            {
                simpleTableIdentifier = @"msgCell";//messages
                
                MessageCommentTableViewCell *cell = (MessageCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
                
                if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    
                }
                
                cell.layer.cornerRadius = 2.0f;
                
                
                Messages *cellMessage=[Messages new];
                cellMessage= [dummyDataForAllMessage objectAtIndex:indexPath.section];;
                
                [cell.userName setText:cellMessage.user.expertName];
                [cell.messageDate setText:[self getStringFromDate:cellMessage.modifiedDate]];
                [cell.userMessage setText:[NSString stringWithFormat:@"%@",cellMessage.messageDetails]];
                [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,cellMessage.user.image]]];
                [cell.commentsButton setTitle:[NSString stringWithFormat:@"   Comments(%lu)",(unsigned long)[cellMessage.comments count]] forState:UIControlStateNormal];
                
                return cell;

            }
            else
            {
                
                simpleTableIdentifier = @"iteneraryCell";//iteneraryCell
                
                IteneraryCommentCell *cell = (IteneraryCommentCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
                
                if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    
                }
                
                cell.layer.cornerRadius = 2.0f;
                
                Itinerarie *cellMessage=[Itinerarie new];
                cellMessage= [dummyDataForAllMessage objectAtIndex:indexPath.section];;

                
                [cell.messageDetails setText:[NSString stringWithFormat:@"Itinerary %i submitted by %@",cellMessage.versionNo, cellMessage.expert.expertName]];
                
                return cell;

                
            }

        }
    }
  
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView==self.iteneraryFeedTableView)
    {
        [countDownTimer invalidate];
        
        Itinerarie *cellItinerary=[Itinerarie new];
        cellItinerary=[dummyDataForAllItineraries objectAtIndex:indexPath.section];
        
        
        
        ItineraryViewController *itineraryViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryViewController"];
        itineraryViewController.singleItinerary=cellItinerary;
        [self.navigationController pushViewController:itineraryViewController animated:YES];

    }
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    
    if(tableView==self.feedTableView)
    {
        if([[dummyDataForAllMessage objectAtIndex:indexPath.section] class] == [Messages class])
        {
            return 80;
        }
        else
        {
            return 40;
        }
    }
    else
    {
        return 80;

    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor clearColor];
    
}


- (IBAction)expertClicked:(UIButton*)sender {
    
    sender.selected=!sender.selected;
    if(sender.selected)
    {
        checkedExpert=sender.tag;
        self.checkoutButton.enabled=YES;
        
        [self.ExpertListTableView reloadData];
    }
    
    else
    {
        self.checkoutButton.enabled=NO;
    }
    
    
}

- (IBAction)tipsValueChanged:(id)sender
{
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        [self.allUpdatesView setHidden:NO];
        [self.iteneraryView setHidden:YES];
        [self.manageView setHidden:YES];
        
//        if(dummyDataForAllMessage.count )
//        {
//            [self.feedTableView setHidden:NO];
//            [self.feedTableView reloadData];
//        }
//        
//        else
//        {
//            [self.feedTableView setHidden:YES];
//            [KSToastView ks_showToast:@"There are no responses from any of the experts yet" duration:2.0f];
//            
//        }
    }
    else  if (self.segmentControl.selectedSegmentIndex == 1)
    {
        

        [self.allUpdatesView setHidden:YES];
        [self.iteneraryView setHidden:NO];
        [self.manageView setHidden:YES];
        
//        if(dummyDataForAllItineraries.count )
//        {
//            [self.iteneraryFeedTableView setHidden:NO];
//            [self.iteneraryFeedTableView reloadData];
//        }
//        
//        else
//        {
//            [self.iteneraryFeedTableView setHidden:YES];
//            [KSToastView ks_showToast:@"There are no responses from any of the experts yet" duration:2.0f];
//            
//        }
    }
    else
    {
        [self.allUpdatesView setHidden:YES];
        [self.iteneraryView setHidden:YES];
        [self.manageView setHidden:NO];
    }
}
- (IBAction)CheckOut:(id)sender {
    
}

- (IBAction)withdrawReqAction:(id)sender {
}

-(NSDate *)getDateFromString:(NSString *)dateString
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
    //   [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    
    //[formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSDate *currentDate=[formatter dateFromString:dateString];
    return currentDate;
}

-(NSString *)getDateFormatFromDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

-(NSString *)getStringFromDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm, MMM dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

- (IBAction)sendMessageAction:(UIButton*)sender {
    
    NSString *messageDataString=self.inputTextField.text;
    sender.enabled=NO;
    //self.inputViewBottomConstant.constant=0;
    //[self.view endEditing:YES];
    self.inputTextField.text = @"";
    
    
    Messages *singleMessage=[Messages new];
    singleMessage.messageDetails=messageDataString;
    singleMessage.modifiedDate= [NSDate date];
    singleMessage.comments=[[NSMutableArray alloc] init];
    
    
    Expert *singleExpert=[Expert new];
    singleExpert.userId=[Trip sharedManager].user_id;
    singleExpert.expertName=[NSString stringWithFormat:@"%@ %@",[Trip sharedManager].userFirstName,[Trip sharedManager].userLastName];
    singleExpert.image=[Trip sharedManager].userImageName;
    
    singleMessage.user=singleExpert;
    
    
    dummyDataForAllMessage=[[NSMutableArray alloc] init];
    dummyDataForAllMessage=[rootOfAllMessage mutableCopy];
    [dummyDataForAllMessage insertObject:singleMessage  atIndex:0];
    
    
    [self.feedTableView setHidden:NO];
    [self.feedTableView reloadData];
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:self.tripId] forKey:@"trip_id"];
    [postData setObject:[NSNumber numberWithInt:[Trip sharedManager].user_id] forKey:@"user_id"];
    [postData setObject:messageDataString forKey:@"message"];
    
    NSLog(@"postData %@",postData);
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/trip-messages/api-submit-trip-message",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //[self loadDetails];
       
        NSLog(@"Success");
        sender.enabled=YES;
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
        sender.enabled=YES;
        
        [KSToastView ks_showToast:@"Message sending failed" duration:2.0f];
    }];
    


    
}

-(void)tapGestureInFeedTable: (UIEvent *)event
{
    [self.view endEditing:YES];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    [self.view endEditing:YES];
}


#pragma mark - Pusher Delegate Connection
//////////////////////////////////

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"[Pusher] connected to %@", [connection.URL absoluteString]);
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
    if (error) {
        NSLog(@"[Pusher] connection failed: %@", [error localizedDescription]);
    } else {
        NSLog(@"[Pusher] connection failed");
    }
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)reconnect
{
    if (error) {
        NSLog(@"[Pusher] didDisconnectWithError: %@ willAttemptReconnect: %@", [error localizedDescription], (reconnect ? @"YES" : @"NO"));
    } else {
        NSLog(@"[Pusher] disconnected");
    }
}

- (void)loadTimers {
    //_DDHTimerTypeElements;
    //DDHTimerTypeSolid
    //DDHTimerTypeEqualElements
    
    [self.timerView setHidden:NO];
    
    self.hourControl.type=0;
    self.hourControl.color = [UIColor hx_colorWithHexString:@"#E03365"];
    self.hourControl.highlightColor = [UIColor redColor];
    self.hourControl.minutesOrSeconds = 23;
    self.hourControl.titleLabel.text = @"hr";
    self.hourControl.userInteractionEnabled = NO;
    
    //[self.hourControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.minControl.type = DDHTimerTypeElements;
    self.minControl.color = [UIColor hx_colorWithHexString:@"#E03365"];
    self.minControl.highlightColor = [UIColor redColor];
    self.minControl.minutesOrSeconds = 59;
    self.minControl.titleLabel.text = @"min";
    self.minControl.userInteractionEnabled = NO;
    
    self.secControl.type = DDHTimerTypeEqualElements;
    self.secControl.color = [UIColor hx_colorWithHexString:@"#E03365"];
    self.secControl.highlightColor = [UIColor redColor];
    self.secControl.minutesOrSeconds = 59;
    self.secControl.titleLabel.text = @"sec";
    self.secControl.userInteractionEnabled = NO;
    
    
    
    countDownTimer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
    
    //endDate = [NSDate dateWithTimeIntervalSinceNow:24.0f*60.0f*60.0f];
    endDate = [[self getDateFromString:[self.tripDetails objectForKey:@"created"]] dateByAddingTimeInterval:60*60*24];
}

- (void)changeTimer:(NSTimer*)timer {
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceNow];
    
    
    self.hourControl.minutesOrSeconds = (NSInteger)(timeInterval/3600.0f);
    //self.hourControl.minutesOrSeconds = ((NSInteger)(timeInterval/3600.0f)%12)*5;
    
    
    self.minControl.minutesOrSeconds = ((NSInteger)timeInterval%3600)/60.0f;
    self.secControl.minutesOrSeconds = ((NSInteger)timeInterval)%60;
    NSLog(@"timeInterval: %f, minutes: %ld %ld", timeInterval, (NSInteger)(timeInterval/3600.0f),((NSInteger)(timeInterval/3600.0f)%12)*5);
    
}


- (void)valueChanged:(DDHTimerControl*)sender {
    NSLog(@"value: %ld", (long)sender.minutesOrSeconds);
}

-(void) dealloc
{
    [countDownTimer invalidate];
    [self.timerView setHidden:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
 
    if ([[segue identifier] isEqualToString:@"messageToSummary"]) {
        SummaryViewController *nextVC=  [segue destinationViewController];
        nextVC.isManagable=NO;
    }

}


@end
