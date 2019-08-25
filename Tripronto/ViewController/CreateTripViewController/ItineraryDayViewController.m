//
//  ItineraryViewController.m
//  ItineraryDemo
//
//  Created by Tanvir Palash on 7/24/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "ItineraryDayViewController.h"

#import "TransportEvent.h"
#import "TourEvent.h"
#import "ActivitiesEvent.h"
#import "FlightEvent.h"
#import "HotelEvent.h"
#import "CarHireEvent.h"

@interface ItineraryDayViewController ()
{
    CGFloat kCloseCellHeight;
    CGFloat kOpenCellHeight;
    
    CGFloat kRowsCount;
    
    NSMutableArray* cellHeights;
}
@end

@implementation ItineraryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    kCloseCellHeight = 179;
    kOpenCellHeight = 488;
    kRowsCount = self.dayEvents.count;
    
    cellHeights=[[NSMutableArray alloc] init];
    
    [self createCellHeightsArray];
    
    self.itineraryTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    self.itineraryTableView.delegate=self;
    self.itineraryTableView.dataSource=self;
}

-(void)createCellHeightsArray
{
    for (int i=0; i <kRowsCount;i++) {
        
        [cellHeights addObject:[NSNumber numberWithFloat:kCloseCellHeight]];
        
    }
    
}

#pragma TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kRowsCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *simpleTableIdentifier;
    DemoCell *cell;
    
    
    
    if([[self.dayEvents objectAtIndex:indexPath.row] class] == [TransportEvent class])
    {
        simpleTableIdentifier = @"TransportCell";
        
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [CarHireEvent class])
    {
        simpleTableIdentifier = @"CarHireCell";
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [TourEvent class])
    {
        simpleTableIdentifier = @"TourCell";
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [ActivitiesEvent class])
    {
         simpleTableIdentifier = @"ActivitiesCell";
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [FlightEvent class])
    {
         simpleTableIdentifier = @"FlightCell";
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [HotelEvent class])
    {
        simpleTableIdentifier = @"HotelCell";
    }
    else
        simpleTableIdentifier = @"TransportCell";
        
    
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(DemoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will display cell");
    
//    DemoCell *tempCell=cell;
//    
//    if (tempCell ) {
//        return;
//    }
//        
    
    cell.backgroundColor = [UIColor clearColor];
    
    if ([[cellHeights objectAtIndex:indexPath.row] floatValue] == kCloseCellHeight ){
        
        [cell selectedAnimation:false animated:false completion:nil];
    } else {
        
        [cell selectedAnimation:true animated:false completion:nil];
    }
    
    
    cell.number = indexPath.row;
    
    if([[self.dayEvents objectAtIndex:indexPath.row] class] == [TransportEvent class])
    {
        TransportEvent *singleTransport=[TransportEvent new];
        singleTransport=[self.dayEvents objectAtIndex:indexPath.row];
        
        cell.openNumberLabel.text=singleTransport.eventTypeTitle;


    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [CarHireEvent class])
    {
        CarHireEvent *singleCar=[CarHireEvent new];
        singleCar=[self.dayEvents objectAtIndex:indexPath.row];
        
        cell.openNumberLabel.text=singleCar.eventTypeTitle;
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [TourEvent class])
    {
        TourEvent *singleTour=[TourEvent new];
        singleTour=[self.dayEvents objectAtIndex:indexPath.row];
        
        cell.openNumberLabel.text=singleTour.eventTypeTitle;
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [ActivitiesEvent class])
    {
        ActivitiesEvent *singleActivity=[ActivitiesEvent new];
        singleActivity=[self.dayEvents objectAtIndex:indexPath.row];
        
        cell.openNumberLabel.text=singleActivity.eventTypeTitle;
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [FlightEvent class])
    {
        FlightEvent *singleFlight=[FlightEvent new];
        singleFlight=[self.dayEvents objectAtIndex:indexPath.row];
        
        cell.openNumberLabel.text=singleFlight.eventTypeTitle;
    }
    else if([[self.dayEvents objectAtIndex:indexPath.row] class] == [HotelEvent class])
    {
        HotelEvent *singleHotel=[HotelEvent new];
        singleHotel=[self.dayEvents objectAtIndex:indexPath.row];
        
        cell.openNumberLabel.text=singleHotel.eventTypeTitle;
    }

    
    
   
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    return [[cellHeights objectAtIndex:indexPath.row] floatValue];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"selected");
    
   // [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FoldingCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.isAnimating) {
        return;
    }
    
    CGFloat duration =0.0;
    
    if([[cellHeights objectAtIndex:indexPath.row] floatValue]==kCloseCellHeight)
    {
        [cellHeights  replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:kOpenCellHeight]];
        [cell selectedAnimation:true animated:true completion:nil];
        duration = 0.5;
        
        
    }
    else
    {
        [cellHeights  replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:kCloseCellHeight]];
        [cell selectedAnimation:false animated:true completion:nil];
        duration = 0.8;
    
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.itineraryTableView beginUpdates];
        [self.itineraryTableView endUpdates];
        
    } completion:nil];
   
    
}

-(IBAction)backButtonAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
