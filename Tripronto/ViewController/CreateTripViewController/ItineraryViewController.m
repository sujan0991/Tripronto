//
//  ItineraryViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 7/21/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "ItineraryViewController.h"
#import "Constants.h"

#import "TransportEvent.h"
#import "ActivitiesEvent.h"
#import "TourEvent.h"
#import "CarHireEvent.h"
#import "FlightEvent.h"
#import "HotelEvent.h"

#import "ItineraryDayCell.h"
#import "ItineraryDayViewController.h"

@interface ItineraryViewController ()

@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itineraryDayTableView.delegate=self;
    self.itineraryDayTableView.dataSource=self;
    
    //self.itineraryDayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.itineraryDayTableView.frame.size.width, 1)];
    
    self.itineraryDayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.itineraryDayTableView.estimatedRowHeight =  100;
    self.itineraryDayTableView.rowHeight = UITableViewAutomaticDimension;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadItinerary];
}


-(void) loadItinerary
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInteger:self.singleItinerary.itinerarieId ] forKey:@"itinerary_id"];
    
    NSLog(@"postdatav %@",postData);
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/itineraries/api-get-itinerary-detail",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        NSDictionary* tempDictionary=[responseObject objectForKey:@"itinerary_detail"];
        
        NSMutableDictionary* itineraryFromWeb=[[NSMutableDictionary alloc ]initWithDictionary:[tempDictionary dictionaryByReplacingNullsWithBlanks]];
        NSLog(@"itineraryFromWeb %@",itineraryFromWeb);
        
        
        
        if( [[itineraryFromWeb objectForKey:@"cost"] isEqual: [NSNull null]] )
        {
            self.singleItinerary.itinerary_cost=@"N/A";
        }else
            self.singleItinerary.itinerary_cost=[itineraryFromWeb objectForKey:@"cost"];
        
        self.singleItinerary.is_selected=[[itineraryFromWeb objectForKey:@"is_selected"] boolValue];
        
        NSMutableArray* tempDayArray=[[NSMutableArray alloc] initWithArray:[itineraryFromWeb objectForKey:@"days"]];
        
        self.singleItinerary.days=[[NSMutableArray alloc] init];
        
        for (int i=0; i<tempDayArray.count; i++) {
            NSMutableArray* eventsArray=[[NSMutableArray alloc]initWithArray:[[tempDayArray objectAtIndex:i]objectForKey:@"events"] ];
            
            NSMutableArray* customEventArray=[[NSMutableArray alloc] init];
            for (int j=0; j<eventsArray.count; j++) {
                NSMutableDictionary* singleEvent=[eventsArray objectAtIndex:j];
                
                if([[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue]==1)
                {
                    TransportEvent *tempTransportEvent=[TransportEvent new];
                    tempTransportEvent.eventId=[[singleEvent objectForKey:@"id"] intValue];
                    tempTransportEvent.eventTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    
                    tempTransportEvent.eventTypeTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    tempTransportEvent.eventTypeId=[[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue];
                    tempTransportEvent.eventTypeImage=[[singleEvent objectForKey:@"event_type"] objectForKey:@"image"];
                    
                    
                    tempTransportEvent.pickupTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"pickup_time"]];
                    tempTransportEvent.dropOffTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"dropoff_time"]];
                    tempTransportEvent.company=[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"company"];
                    tempTransportEvent.inclusions=[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"inclusions"];
                    tempTransportEvent.exclusions=[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"exclusions"];
                    tempTransportEvent.transportConfirmationNo=[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"transport_confirmation_no"];
                    tempTransportEvent.driverName=[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"driver_name"];
                    
                    tempTransportEvent.vehicleTitle=[[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"vehicle_type"] objectForKey:@"title"];
                    tempTransportEvent.vehicleFeaturedImage=[[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"vehicle_type"] objectForKey:@"image"];
                    tempTransportEvent.vehicleDescription=[[[[singleEvent objectForKey:@"itinerary_transports"] objectAtIndex:0] objectForKey:@"vehicle_type"] objectForKey:@"description"];
                    
                    [customEventArray addObject:tempTransportEvent];

                }
                else  if([[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue]==2)
                {
                    CarHireEvent *tempCarHireEvent=[CarHireEvent new];
                    tempCarHireEvent.eventId=[[singleEvent objectForKey:@"id"] intValue];
                    tempCarHireEvent.eventTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    
                    tempCarHireEvent.eventTypeTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    tempCarHireEvent.eventTypeId=[[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue];
                    tempCarHireEvent.eventTypeImage=[[singleEvent objectForKey:@"event_type"] objectForKey:@"image"];
                   
                    tempCarHireEvent.pickupTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"pickup_time"]];
                    tempCarHireEvent.dropoffTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"dropoff_time"]];
                    tempCarHireEvent.company=[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"company"];
                    tempCarHireEvent.boosterSeats=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"booster_seats"] intValue];
                    tempCarHireEvent.infantSeats=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"infant_seats"] intValue];
                    tempCarHireEvent.childSeats=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"child_seats"] intValue];
                    tempCarHireEvent.hasGps=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"has_gps"] boolValue];
                    tempCarHireEvent.vehicleTypeId=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"vehicle_type_id"] intValue];
                    
                    
                    tempCarHireEvent.vehicleTitle=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"vehicle_type"] objectForKey:@"title"];
                    tempCarHireEvent.vehicleImage=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"vehicle_type"] objectForKey:@"image"];
                    tempCarHireEvent.vehicleDescription=[[[[singleEvent objectForKey:@"itinerary_car_hires"] objectAtIndex:0] objectForKey:@"vehicle_type"] objectForKey:@"description"];
                    
                    
                    [customEventArray addObject:tempCarHireEvent];

                }
                else  if([[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue]==3)
                {
                    TourEvent *tempTourEvent=[TourEvent new];
                    tempTourEvent.eventId=[[singleEvent objectForKey:@"id"] intValue];
                    
                    tempTourEvent.eventTypeTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    tempTourEvent.eventTypeId=[[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue];
                    tempTourEvent.eventTypeImage=[[singleEvent objectForKey:@"event_type"] objectForKey:@"image"];
                    
                    
                    tempTourEvent.tourOperatorName=[[[singleEvent objectForKey:@"itinerary_tours"] objectAtIndex:0] objectForKey:@"tour_operator_name"];
                    tempTourEvent.tourTitle=[[[singleEvent objectForKey:@"title"] objectAtIndex:0] objectForKey:@"company"];
                    tempTourEvent.tourDescription=[[[singleEvent objectForKey:@"description"] objectAtIndex:0] objectForKey:@"company"];
                    tempTourEvent.tourConfirmationNumber=[[[singleEvent objectForKey:@"itinerary_tours"] objectAtIndex:0] objectForKey:@"tour_confirmation_number"];
                    
                    [customEventArray addObject:tempTourEvent];
                    
                }
                else  if([[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue]==4)
                {
                    ActivitiesEvent *tempActivitiesEvent=[ActivitiesEvent new];
                    tempActivitiesEvent.eventId=[[singleEvent objectForKey:@"id"] intValue];
                    tempActivitiesEvent.eventTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    
                    tempActivitiesEvent.eventTypeTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    tempActivitiesEvent.eventTypeId=[[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue];
                    tempActivitiesEvent.eventTypeImage=[[singleEvent objectForKey:@"event_type"] objectForKey:@"image"];
                    
                    tempActivitiesEvent.startTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"start_time"]];
                    tempActivitiesEvent.endTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"end_time"]];
                    tempActivitiesEvent.durationUnit=[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"duration_unit"];
                    tempActivitiesEvent.durationAmount=[[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"duration_amount"] intValue];
                   
                    
                    
                    tempActivitiesEvent.activityTitle=[[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"activity"] objectForKey:@"title"];
                    tempActivitiesEvent.featuredImage=[[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"activity"] objectForKey:@"featured_image"];
                    tempActivitiesEvent.activityDescription=[[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"activity"] objectForKey:@"description"];
                    tempActivitiesEvent.isFeatured=[[[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"activity"] objectForKey:@"is_featured"] boolValue];
                    tempActivitiesEvent.isHome=[[[[[singleEvent objectForKey:@"itinerary_activities"] objectAtIndex:0] objectForKey:@"activity"] objectForKey:@"is_home"] boolValue];
                    
                    
                    [customEventArray addObject:tempActivitiesEvent];
                    
                }
                
                else  if([[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue]==5)
                {
                    FlightEvent *tempFlightEvent=[FlightEvent new];
                    tempFlightEvent.eventId=[[singleEvent objectForKey:@"id"] intValue];
                    tempFlightEvent.eventTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    
                    tempFlightEvent.eventTypeTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    tempFlightEvent.eventTypeId=[[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue];
                    tempFlightEvent.eventTypeImage=[[singleEvent objectForKey:@"event_type"] objectForKey:@"image"];
                    
                    tempFlightEvent.flightTime=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"flight_time"]];
                    tempFlightEvent.terminal=[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"terminal"];
                    tempFlightEvent.travelClass=[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"travel_class"];
                    tempFlightEvent.seatNo=[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"seat_no"];
                    tempFlightEvent.airlineConfirmationNumber=[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airline_confirmation_number"];
                    tempFlightEvent.gate=[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"gate"];
                    tempFlightEvent.flightNo=[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"flight_no"];
                    
                    
                    tempFlightEvent.flightTypeTitle=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"flight_type"] objectForKey:@"title"];
                    tempFlightEvent.flightTypeDescription=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"flight_type"] objectForKey:@"description"];
                    
                    
                    tempFlightEvent.airlineTitle=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airline"] objectForKey:@"title"];
                    tempFlightEvent.airlineDescription=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airline"] objectForKey:@"description"];
                    tempFlightEvent.airlineLogo=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airline"] objectForKey:@"logo"];
                    
                    
                    tempFlightEvent.airportTitle=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airport"] objectForKey:@"title"];
                    tempFlightEvent.airportAddress=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airport"] objectForKey:@"address"];
                    tempFlightEvent.airportShortCode=[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airport"] objectForKey:@"short_code"];
                    tempFlightEvent.cityId=[[[[[singleEvent objectForKey:@"itinerary_flights"] objectAtIndex:0] objectForKey:@"airport"] objectForKey:@"city_id"] intValue];
                    
                    
                    
                    [customEventArray addObject:tempFlightEvent];
                    
                }
                else  if([[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue]==6)
                {
                    HotelEvent *tempHotelEvent=[HotelEvent new];
                    tempHotelEvent.eventId=[[singleEvent objectForKey:@"id"] intValue];
                    tempHotelEvent.eventTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    
                    tempHotelEvent.eventTypeTitle=[[singleEvent objectForKey:@"event_type"] objectForKey:@"title"];
                    tempHotelEvent.eventTypeId=[[[singleEvent objectForKey:@"event_type"] objectForKey:@"id"] intValue];
                    tempHotelEvent.eventTypeImage=[[singleEvent objectForKey:@"event_type"] objectForKey:@"image"];
                    
                    tempHotelEvent.checkin_date=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"checkin_date"]];
                    tempHotelEvent.checkout_date=[self getDateFromString:[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"checkout_date"]];
                    tempHotelEvent.hotel_confirmation_number=[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel_confirmation_number"];
                    tempHotelEvent.room_rate=[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"room_rate"] floatValue];
                    tempHotelEvent.room_type=[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"room_type"];
                    
        
                    
                    tempHotelEvent.hotelWebsite=[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"website"];
                    tempHotelEvent.hotelPhone=[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"phone"];
                    tempHotelEvent.hotelDescription=[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"description"];
                    tempHotelEvent.hotelCityId=[[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"city_id"] intValue];
                    tempHotelEvent.hotelCountryId=[[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"country_id"] intValue];
                    tempHotelEvent.stars=[[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"stars"] intValue];
                    tempHotelEvent.hotelZipCode=[[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"zip_code"] intValue];
                    tempHotelEvent.hotelChainId=[[[[[singleEvent objectForKey:@"itinerary_hotels"] objectAtIndex:0] objectForKey:@"hotel"] objectForKey:@"hotel_chain_id"] intValue];
                    
                
                    [customEventArray addObject:tempHotelEvent];
                    
                }

                
            }
            [self.singleItinerary.days addObject:customEventArray];
            [self.itineraryDayTableView reloadData];
        }
        
        NSLog(@"Ititnerary %@",[self.singleItinerary toNSDictionary]);
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"error %@",error);
                      
    }];
}

-(IBAction)backButtonAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.singleItinerary.days.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"DayCell";
    ItineraryDayCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ItineraryDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
//    cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row ];
//    cell.weekDay.text=@"Day";
//    
    cell.dateLabel.text = @"Day";
    cell.weekDay.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row ];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(ItineraryDayCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will display cell");
    
    
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 150)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
 
    [headerView addSubview:imageView];
   
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"selected");
    
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ItineraryDayViewController *itineraryViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryDayViewController"];
    itineraryViewController.dayEvents=[[NSMutableArray alloc] initWithArray:[self.singleItinerary.days objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:itineraryViewController animated:YES];
    
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
