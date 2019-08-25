//
//  OfferListingViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/19/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "OfferListingViewController.h"
#import "Constants.h"

#import "Offers.h"


@interface OfferListingViewController ()

@end

@implementation OfferListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.featuredOffers.isSingle=false;
    self.featuredOffers.dataSource=self;
    self.featuredOffers.delegate=self;
    //self.featuredOffers.userPagerDelegate=self;
    
    
    self.offerByDestinations.isSingle=false;
    self.offerByDestinations.dataSource=self;
    self.offerByDestinations.delegate=self;
    //self.offerByDestinations.userPagerDelegate=self;
    
    self.offersByExperience.isSingle=false;
    self.offersByExperience.dataSource=self;
    self.offersByExperience.delegate=self;
    //self.offersByExperience.userPagerDelegate=self;
    
    self.offers=[[NSMutableArray alloc] init];
    self.destinations=[[NSMutableArray alloc] init];
    self.experiences=[[NSMutableArray alloc] init];
    
    [self loadFeaturesOffers];
    [self loadDestination];
    [self loadExperiences];
    
    //Have a look
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
//        NSData *imgData =  NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:feeds2[indexPath.row]]];
//        if (imgData) {
//            UIImage *image = [UIImage imageWithData:imgData];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^(void) {
//                UIImage *image = [UIImage imageWithData:imgData];
//                if (image) {
//                    cell.ThumbImage.image = image;
//                }
//            });
//        });
    
    
//    [imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/r4uwx.jpg"]
//              placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]
//                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                           [UIView transitionWithView:self.imageView
//                                             duration:0.3
//                                              options:UIViewAnimationOptionTransitionCrossDissolve
//                                           animations:^{
//                                               self.imageView.image = image;
//                                           }
//                                           completion:NULL];
//                       }
//                       failure:NULL];

}


-(void) loadFeaturesOffers
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/offers/api-get-offer-listing",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray* responseData =[[NSMutableArray alloc] init];
        responseData=[responseObject objectForKey:@"offers"];
        
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
            
            
            [self.offers addObject:offer];
            

        }

        [self.featuredOffers reloadData];

    }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

-(void) loadExperiences
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/activities/api-get-experience-listing",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.experiences=[[NSMutableArray alloc] init];
        self.experiences=[responseObject objectForKey:@"Featured_Experiences"];
        
        [self.offersByExperience reloadData];
        
       // NSLog(@"self.experiences %@",self.experiences);
    }
    
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
                      
    }];
}

-(void) loadDestination
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/cities/api-get-destination-listing",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.destinations=[[NSMutableArray alloc] init];
        self.destinations=[responseObject objectForKey:@"Featured_Cities"];
        
        [self.offerByDestinations reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
                      
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
  
    
    if(collectionView.tag==101)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OfferCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:1011];
        
        
        Offers* offer=[Offers new];
        offer= [self.offers objectAtIndex:indexPath.row];
        
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,offer.featuredImage]]];
        
        UIButton *offerPrice = (UIButton *)[cell viewWithTag:1012];
        [offerPrice setTitle:[[NSString stringWithFormat:@"%@ Started From %@", offer.offerTitle,offer.price] uppercaseString] forState:UIControlStateNormal];
        
        
    }

    else if(collectionView.tag==102)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DesCell" forIndexPath:indexPath];
        
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:1021];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
        
        UIButton *activityName = (UIButton *)[cell viewWithTag:1022];
        //activityName.titleLabel.text=[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"];
        [activityName setTitle:[[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
        

        
    }
    else if(collectionView.tag==103)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:1031];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
        
        UIButton *activityName = (UIButton *)[cell viewWithTag:1032];
        //activityName.titleLabel.text=[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"];
        [activityName setTitle:[[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
    }


    
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(collectionView.tag==101)
    {
        return self.offers.count;

    }
    else if(collectionView.tag==102)
    {
        return self.destinations.count;

    }
    else if(collectionView.tag==103)
    {
        return self.experiences.count;

    }
    else
        return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected");
    

    
    if(collectionView.tag==101)
    {
        Offers* offer= [Offers new];
        offer=[self.offers objectAtIndex:indexPath.row];
        
        OfferDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetailsViewController"];
        viewController.offerID=offer.offerId;
        viewController.offerName=offer.offerTitle;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    else if(collectionView.tag==102)
    {
       OfferListTableViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"OfferListTableViewController"];
        viewController.cityID=[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"id"];
       // viewController.activtityID=[[self.destinations objectAtIndex:indexPath.row] objectForKey:@""];
        [self.navigationController pushViewController:viewController animated:YES];
        
        
    }
    else if(collectionView.tag==103)
    {
        
        OfferListTableViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"OfferListTableViewController"];
    //    viewController.cityID=[[self.experiences objectAtIndex:indexPath.row] objectForKey:@""];
        viewController.activtityID=[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:viewController animated:YES];
        
        
    }
 
}

#pragma mark - HWViewPagerDelegate
-(void)pagerDidSelectedPage:(NSInteger)selectedPage with:(NSInteger *)pagerTag{
    NSLog(@"FistViewController, SelectedPage : %@ pagerTag %d",[@(selectedPage) stringValue],(int)pagerTag);
    
   // self.experiencePageControl.currentPage = selectedPage;
    
    
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
