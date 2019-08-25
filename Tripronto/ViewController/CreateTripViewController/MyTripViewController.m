//
//  MyTripViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/3/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "MyTripViewController.h"

#import "MyTripCell.h"

#import "Constants.h"
#import "Trip.h"

@interface MyTripViewController ()
{
    NSTimer* logoTimer;
    
  //  NSMutableArray *currentTrips;
}

@end

@implementation MyTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"mytrip called");
    
    
    //[self loadDetails];
    
    self.isFirstTrip=NO;
    [self.view layoutIfNeeded];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.containerView.parallaxView.delegate = self;
    
    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    CGRect contentRect = CGRectZero;
    
    
    self.tripsTableView.contentInset=UIEdgeInsetsMake(0, 0, 30, 0);
    
    if(!self.allTrips.count)
    {
        self.tripsView.hidden=YES;
        self.createView.hidden=NO;
        
        for (UIView *view in self.createView.subviews) {
            
            contentRect = CGRectUnion(contentRect, view.frame);
           // NSLog(@"contentRect %lf",contentRect.size.height);
        }
        
        
    }else
    {
       

        
        self.createView.hidden=YES;
        self.tripsView.hidden=NO;
        
        self.currentBookingsButton.layer.masksToBounds = NO;
        self.currentBookingsButton.layer.shadowOffset = CGSizeMake(0, 0);
        self.currentBookingsButton.layer.shadowRadius = 5;
        self.currentBookingsButton.layer.shadowOpacity = 0.3;
        self.currentBookingsButton.layer.zPosition=101;
        
        self.pastBookingsButton.layer.masksToBounds = NO;
        self.pastBookingsButton.layer.shadowOffset = CGSizeMake(0, 0);
        self.pastBookingsButton.layer.shadowRadius = 5;
        self.pastBookingsButton.layer.shadowOpacity = 0.1;
        self.pastBookingsButton.layer.zPosition=100;
        
        
        self.tripsTableView.dataSource=self;
        self.tripsTableView.delegate=self;
        
        [self.tripsTableView reloadData];
        
        for (UIView *view in self.tripsView.subviews) {
            
            
            contentRect = CGRectUnion(contentRect, view.frame);
            //NSLog(@"trip contentRect %lf",contentRect.size.height);
        }
        
    }
    
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withTitle:@"Plan a new trip"];
    [self.containerView.parallaxView.backButton setHidden:YES];
//    [[self.containerView.parallaxView backButton] addTarget:self
//                                                     action:@selector(backButtonAction)
//                                           forControlEvents:UIControlEventTouchUpInside];
//    
    
    //NSLog(@"containerView %@",self.containerView);
    
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDetails];
    [logoTimer invalidate];
}


-(void)willStartBlinkingAnimation
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
//                         self.triprontoLogoButton.frame = CGRectMake(self.triprontoLogoButton.frame.origin.x-5, self.triprontoLogoButton.frame.origin.y-5, self.triprontoLogoButton.frame.size.width+10, self.triprontoLogoButton.frame.size.height+10);
//
                         self.triprontoLogoButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         
                     }
                     completion:^(BOOL finished) {
//                         self.triprontoLogoButton.frame = CGRectMake(self.triprontoLogoButton.frame.origin.x+5, self.triprontoLogoButton.frame.origin.y+5, self.triprontoLogoButton.frame.size.width-10, self.triprontoLogoButton.frame.size.height-10);
                         self.triprontoLogoButton.transform = CGAffineTransformIdentity;

                     }
     ];
}

-(void)backButtonAction
{
    //NSLog(@"backClicked");
    //[self.navigationController popViewControllerAnimated:YES];
     self.isFirstTrip=!self.isFirstTrip;
    [self viewDidAppear:YES];
    
}


#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    //    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}


- (IBAction)selectCurrentBookings:(UIButton*)sender {
    
    NSLog(@"select flight");
    //    if(!sender.selected)
    //    {
    //
    
    self.currentBookingsButton.layer.shadowOpacity = 0.3;
    self.currentBookingsButton.layer.zPosition=101;
    self.currentBookingsButton.selected=YES;
    
    self.pastBookingsButton.selected=NO;
    self.pastBookingsButton.layer.shadowOpacity = 0.1;
    self.pastBookingsButton.layer.zPosition=100;
    
    
    [self.tripsTableView reloadData];
    
    //  }
    //  self.selectFlightsButton.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    //sender.selected=!sender.selected;
    
    
    
}
- (IBAction)selectPastBookings:(UIButton*)sender {
    
    //NSLog(@"flight not required");
    
    
    if(!sender.selected)
    {
        
        self.pastBookingsButton.layer.shadowOpacity = 0.3;
        self.pastBookingsButton.layer.zPosition=101;
        self.pastBookingsButton.selected=YES;
        
        self.currentBookingsButton.selected=NO;
        self.currentBookingsButton.layer.shadowOpacity = 0.1;
        self.currentBookingsButton.layer.zPosition=100;
        
        [self.tripsTableView reloadData];
        
    }
    
    //sender.selected=!sender.selected;
    
}



-(void)loadDetails
{
    
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:[Trip sharedManager].user_id ] forKey:@"traveller_id"];
    
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/trips/api-get-my-trips",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      //  NSLog(@"responseObject %@ ",[responseObject objectForKey:@"trips"]);
        
      
        
        self.currentTrips=[[NSMutableArray alloc] init];
        self.pastTrips=[[NSMutableArray alloc] init];
        self.completedTrips=[[NSMutableArray alloc] init];
        
        self.allTrips=[responseObject objectForKey:@"trips"];
    
        if(self.allTrips.count)
        {
            self.allTrips=[[[ self.allTrips reverseObjectEnumerator] allObjects] mutableCopy];
            
            for (int i=0; i< self.allTrips.count; i++) {
                if([[self.allTrips objectAtIndex:i] objectForKey:@"start_date"] == [NSNull null] ||  ( [[NSDate date] compare:[self getDateFromString:[[self.allTrips objectAtIndex:i] objectForKey:@"start_date"]]]  != NSOrderedAscending  ) )
                    [self.pastTrips addObject:[self.allTrips objectAtIndex:i]];
                else
                    [self.currentTrips addObject:[self.allTrips objectAtIndex:i]];
            }
            
            
            [self.tripsTableView reloadData];
            
            
            CGRect contentRect = CGRectZero;
            
            
            self.createView.hidden=YES;
            self.tripsView.hidden=NO;
            
          //  self.currentBookingsButton.selected=YES;
            
            if(self.currentBookingsButton.selected)
            {
                self.currentBookingsButton.selected=YES;
                self.currentBookingsButton.layer.masksToBounds = NO;
                self.currentBookingsButton.layer.shadowOffset = CGSizeMake(0, 0);
                self.currentBookingsButton.layer.shadowRadius = 5;
                self.currentBookingsButton.layer.shadowOpacity = 0.3;
                self.currentBookingsButton.layer.zPosition=101;
                
                self.pastBookingsButton.selected=NO;
                self.pastBookingsButton.layer.masksToBounds = NO;
                self.pastBookingsButton.layer.shadowOffset = CGSizeMake(0, 0);
                self.pastBookingsButton.layer.shadowRadius = 5;
                self.pastBookingsButton.layer.shadowOpacity = 0.1;
                self.pastBookingsButton.layer.zPosition=100;

            }
            else
            {
                self.currentBookingsButton.selected=NO;
                self.currentBookingsButton.layer.masksToBounds = NO;
                self.currentBookingsButton.layer.shadowOffset = CGSizeMake(0, 0);
                self.currentBookingsButton.layer.shadowRadius = 5;
                self.currentBookingsButton.layer.shadowOpacity = 0.1;
                self.currentBookingsButton.layer.zPosition=100;
                
                self.pastBookingsButton.selected=YES;
                self.pastBookingsButton.layer.masksToBounds = NO;
                self.pastBookingsButton.layer.shadowOffset = CGSizeMake(0, 0);
                self.pastBookingsButton.layer.shadowRadius = 5;
                self.pastBookingsButton.layer.shadowOpacity = 0.3;
                self.pastBookingsButton.layer.zPosition=101;
            }
            
            
            
            self.tripsTableView.dataSource=self;
            self.tripsTableView.delegate=self;
            
            [self.tripsTableView reloadData];
            
            for (UIView *view in self.tripsView.subviews) {
                
                
                contentRect = CGRectUnion(contentRect, view.frame);
                //NSLog(@"trip contentRect %lf",contentRect.size.height);
            }
            
            
            contentRect.size.height+=20;
            
            self.containerView.contentSize=contentRect.size;


        }
        else
        {
            logoTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                         target:self
                                                       selector:
                         @selector(willStartBlinkingAnimation)
                                                       userInfo:nil
                                                        repeats:YES];
         
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
        logoTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                         target:self
                                                       selector:
                         @selector(willStartBlinkingAnimation)
                                                       userInfo:nil
                                                        repeats:YES];
        
    }];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(self.currentBookingsButton.selected)
        return self.currentTrips.count;
    else
        return self.pastTrips.count;
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    

    MyTripCell *cell = (MyTripCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier ];
    if (cell == nil)
    {
        // create a new cell if there isn't one available to recycle
         cell = [[MyTripCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }

    cell.layer.cornerRadius=10;
    

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }

    NSMutableDictionary *tripData=[[NSMutableDictionary alloc] init];
   
    if(self.currentBookingsButton.selected)
    {
        tripData=[self.currentTrips objectAtIndex:indexPath.section];
    }
    else
    {
        tripData=[self.pastTrips objectAtIndex:indexPath.section];
    }
    
    [cell.tripCityLabel setText:[tripData objectForKey:@"cities"]];
    
    
    [cell.statusLabel setText:[NSString stringWithFormat:@"(Status: %@ Experts Working)",[tripData objectForKey:@"experts"]]];
    
    
    
    if( ![[tripData objectForKey:@"created"] isEqual: [NSNull null]] ){
        [cell.submittedDateLabel setText:[NSString stringWithFormat:@"Submitted on %@",[self getStringFromDate:[self getDateFromString:[tripData objectForKey:@"created"]]]]];
        
    }
    else
    {
        [cell.submittedDateLabel setText:@"Date"];
 
    }
    
    if( ![[tripData objectForKey:@"trip_title"] isEqual: [NSNull null]] ){
        [cell.tripTitle setText:[tripData objectForKey:@"trip_title"]];

    }
    else
        [cell.tripTitle setText:@"Trip title"];

    
    
    cell.msgButton.tag=indexPath.section;
    [cell.msgButton addTarget:self action:@selector(moveToMessageView:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.notificationButton.tag=indexPath.section;
    [cell.notificationButton addTarget:self action:@selector(moveToMessageView:) forControlEvents:UIControlEventTouchUpInside];


    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"%ld",(long)indexPath.section);
    
    MessageBoardViewController *msgViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MessageBoardViewController"];
    msgViewController.tripDetails=[[NSMutableDictionary alloc] init];
   
    if(self.currentBookingsButton.selected)
    {
        msgViewController.isPastTrip=NO;
        msgViewController.tripDetails=[self.currentTrips objectAtIndex:indexPath.section];
        
    }
    else
    {
        msgViewController.isPastTrip=YES;
        msgViewController.tripDetails=[self.pastTrips objectAtIndex:indexPath.section];
    }
    msgViewController.selectedTabIndex=0;
    [self.navigationController pushViewController:msgViewController animated:YES];

    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    //this is the space
//    return 5;
//}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
        return tableView.frame.size.width*0.5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 10.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (IBAction)openTutorial:(id)sender {
    self.isFirstTrip=NO;
    
    
}

-(void) moveToMessageView: (UIButton*) sender
{
    NSLog(@"%ld",(long)sender.tag);
    //[[[currentTrips objectAtIndex:indexPath.section] objectForKey:@"trip_id"] integerValue];
    
//    MessageBoardViewController *msgViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MessageBoardViewController"];
//    msgViewController.tripId=[[[self.currentTrips objectAtIndex:sender.tag] objectForKey:@"trip_id"] intValue];
//    msgViewController.tripName= [NSString stringWithFormat:@"%@",[[self.currentTrips objectAtIndex:sender.tag] objectForKey:@"trip_title"]];
//    msgViewController.selectedTabIndex=0;
//    if(self.currentBookingsButton.selected)
//        msgViewController.isPastTrip=NO;
//    else
//        msgViewController.isPastTrip=YES;
//    
//    [self.navigationController pushViewController:msgViewController animated:YES];
    
}

-(void)dealloc
{
    [logoTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void) setNotification
{
    NSLog(@"observer set");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CreateTripNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"MyTripNotification"
                                               object:nil];

}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"CreateTripNotification"])
    {
        [self performSegueWithIdentifier:@"sendToCreateTrip" sender:notification];
    }
    else  if ([[notification name] isEqualToString:@"MyTripNotification"])
    {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        //MyTripViewController *name = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTripViewController"];
        //name.allTrips=[[NSMutableArray alloc] init];
        //name.allTrips=self.allTrips;
        //[self.navigationController pushViewController:name animated:NO];
        
        
    }
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


-(NSString *)getStringFromDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
   // NSLog(@"%@", stringFromDate);
    return stringFromDate;
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
    
    [Trip sharedManager].trip_type_id=1;
}


@end
