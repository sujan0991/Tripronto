//
//  OfferListTableViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 3/21/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "OfferListTableViewController.h"
#import "Constants.h"
#import "Offers.h"

@interface OfferListTableViewController ()
{
    NSMutableArray* offerData;
}

@end

@implementation OfferListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"city id = %@ activity id = %@",self.cityID,self.activtityID);
    
    
    offerData=[[NSMutableArray alloc] init];
    
    self.offersTableView.dataSource=self;
    self.offersTableView.delegate=self;
    
    
    [self loadDetails];
    //[self.offersTableView reloadData];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)loadDetails
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString* urlString;
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    if(self.cityID)
    {
        [postData setObject:self.cityID forKey:@"city_id"];
        urlString=@"offers/api-get-offer-by-city";
    }else
    {
        [postData setObject:self.activtityID forKey:@"activity_id"];
        urlString=@"offers/api-get-offer-by-activity";
    }
    
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,urlString] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray* responseData=[[NSMutableArray alloc] init];
        responseData=[responseObject objectForKey:@"Offers"];
        
        for (int i=0; i<responseData.count; i++) {
            
            Offers *offer=[Offers new];
            offer.offerId=[[responseData objectAtIndex:i] objectForKey:@"id"];
            offer.offerTitle=[[responseData objectAtIndex:i] objectForKey:@"title"];
            offer.offerDetails=[[responseData objectAtIndex:i] objectForKey:@"description"];
            offer.featuredImage=  [[responseData objectAtIndex:i] objectForKey:@"image_url"];
            offer.price=  [[responseData objectAtIndex:i] objectForKey:@"price"];
            offer.noOfPassengers=  [[responseData objectAtIndex:i] objectForKey:@"no_of_passengers"];
            offer.expertId=  [[responseData objectAtIndex:i] objectForKey:@"expert_id"];
            offer.isFeatured=  [[responseData objectAtIndex:i] objectForKey:@"is_featured"];
            offer.flightClasses=  [[responseData objectAtIndex:i] objectForKey:@"flight_classes"];
            
            
            [offerData addObject:offer];
            
            
        }

        
        [self.offersTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return offerData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell;
    
   
    
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
    
    Offers *singleOffer = [Offers new];
    
    singleOffer=[offerData objectAtIndex:indexPath.section];
    
    UIImageView* contentView=(UIImageView* )[cell viewWithTag:1011];
    [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleOffer.featuredImage]]];

    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius=3;
    

    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:1012];
    [priceLabel setText:[[NSString stringWithFormat:@"AED %@",singleOffer.price] uppercaseString]];
    
    
    UIButton *activityName = (UIButton *)[cell viewWithTag:1013];
    [activityName setTitle:[singleOffer.offerTitle uppercaseString] forState:UIControlStateNormal];
    

    
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"selected");
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OfferDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetailsViewController"];
    
    Offers *offer=[Offers new];
    offer=[offerData objectAtIndex:indexPath.section];
    
    viewController.offerID=offer.offerId;
    viewController.offerName=offer.offerTitle;
    
    [self.navigationController pushViewController:viewController animated:YES];

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    
   
    return tableView.frame.size.width*0.6;
 
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
        return 10;
  
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor clearColor];
    
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
