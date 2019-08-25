//
//  InboxViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "InboxViewController.h"
#import "InboxTableViewCell.h"
#import "Constants.h"
#import "Trip.h"
#import "Inbox.h"
#import "MessageBoardViewController.h"

@interface InboxViewController (){

    NSMutableArray *inboxArray;
    NSMutableArray *allInboxMessage;


}

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inboxTableView.delegate = self;
    self.inboxTableView.dataSource = self;
    
    self.inboxTableView.estimatedRowHeight = 92;
    self.inboxTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.inboxTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.inboxTableView.frame.size.width, 1)];
    
    
    [self makeRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) viewDidAppear:(BOOL)animated
{

}

-(void) makeRequest
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:[Trip sharedManager].user_id] forKey:@"user_id"];
    
    //NSLog(@"user_id in inbox %d ",[Trip sharedManager].user_id);
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/users/api-get-user-inbox",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        inboxArray = [[NSMutableArray alloc]init];
        inboxArray = responseObject;
        
        allInboxMessage = [[NSMutableArray alloc]init];
        
        NSMutableDictionary* inbox=[[NSMutableDictionary alloc]init];
        
        for (int i=0; i<inboxArray.count; i++) {
            
            inbox=[inboxArray objectAtIndex:i];
            
            
            Inbox *singleInbox = [Inbox new];
            singleInbox.inboxId =  [[inbox objectForKey:@"id"] intValue];
            singleInbox.tripId =  [[inbox objectForKey:@"trip_id"] intValue];
            singleInbox.senderId = [[inbox objectForKey:@"user_id"] intValue];
            
            singleInbox.tripName = [[inbox objectForKey:@"trip"] objectForKey:@"trip_title"];
            singleInbox.tripCreatedTime =[[inbox objectForKey:@"trip"] objectForKey:@"created"];
            

            
            NSString *fullName = [NSString stringWithFormat:@"%@ %@",[[inbox objectForKey:@"user"] objectForKey:@"first_name"],[[inbox objectForKey:@"user"] objectForKey:@"last_name"]];
            
            singleInbox.senderName =  fullName;
            singleInbox.senderImage = [[inbox objectForKey:@"user"] objectForKey:@"photo_reference"];
            singleInbox.message= [inbox objectForKey:@"message"];
            singleInbox.messageTime= [inbox objectForKey:@"created"];
            
           // NSLog(@"singleInbox in inbox %@ ",singleInbox.message);
            
            [allInboxMessage addObject:singleInbox];
        }
        
        
        
        [self.inboxTableView reloadData];
        
    }
     
     
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
                      NSLog(@"error %@",error);
                      
        }];
    
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allInboxMessage.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inboxCell"];
    
      Inbox *singleInbox = [Inbox new];
      singleInbox = [allInboxMessage objectAtIndex:indexPath.row];
    
      NSLog(@"singleInbox in inbox %@ ",singleInbox.message);

      cell.senderPic.layer.cornerRadius = 3.0;
      cell.senderPic.clipsToBounds = YES;
      [cell.senderPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleInbox.senderImage]]];
    
      cell.senderNameLabel.text = singleInbox.senderName;
      cell.messageLabel.text = singleInbox.message;
      cell.dateLabel.text = [self relativeDateStringForDate:[self getDateFromString:singleInbox.messageTime]];
    
   
    return cell;
  
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Inbox *singleInbox = [Inbox new];
    singleInbox = [allInboxMessage objectAtIndex:indexPath.row];
    
    MessageBoardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageBoardViewController"];
    
       controller.isFromInboxVC = YES;
       controller.tripId = singleInbox.tripId;
       controller.tripName = singleInbox.tripName;
       controller.tripCreatedTime = singleInbox.tripCreatedTime;
    
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
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
    [formatter setDateFormat:@"MMM dd, YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"stringFromDate %@", stringFromDate);
    return stringFromDate;
}


- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    

    if (components.year > 0) {
        
        return [self getStringFromDate:date];
        

        
        
    } else if (components.month > 0) {
        
        if (components.month > 1) {
            return [self getStringFromDate:date];
            
           
        } else {
            return [NSString stringWithFormat:@"%ld month ago", (long)components.month];
            
        }
        
        
        
    } else if (components.weekOfYear > 0) {
        
        if (components.weekOfYear > 1) {
            
            return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
            
        } else {
            
            return [NSString stringWithFormat:@"%ld week ago", (long)components.weekOfYear];
        }
        
        
        
    } else if (components.day > 0) {
        
        if (components.day > 1) {
            
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
            
        } else {
            
            return @"Yesterday";
        }
    } else {
        if (components.hour > 1) {
            
            return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
        }
        else if(components.minute > 1){
            
            return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
        }
        
    }
}

@end
