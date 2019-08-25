//
//  HomeViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "HomeViewController.h"
#import "Destination.h"
#import "Activity.h"
#import "Offers.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view layoutIfNeeded];

    self.destinationImageUrls=[[NSMutableArray alloc] init];
    self.experienceImageUrls=[[NSMutableArray alloc] init];
    self.offerImageUrls=[[NSMutableArray alloc] init];
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
     
        [self.destinationImageUrls addObject:[UIImage imageNamed:@"destination.png"]];
        [self.destinationImageUrls addObject:[UIImage imageNamed:@"destination.png"]];
        [self.destinationImageUrls addObject:[UIImage imageNamed:@"destination.png"]];

        [self.experienceImageUrls addObject:[UIImage imageNamed:@"experience.png"]];
        [self.experienceImageUrls addObject:[UIImage imageNamed:@"experience.png"]];
        [self.experienceImageUrls addObject:[UIImage imageNamed:@"experience.png"]];
        
        [self.offerImageUrls addObject:[UIImage imageNamed:@"offers.png"]];
        [self.offerImageUrls addObject:[UIImage imageNamed:@"offers.png"]];
        [self.offerImageUrls addObject:[UIImage imageNamed:@"offers.png"]];
        
       // [self loadCarousal];
    }
    else
    {
      //  [self downloadImages];

        
    }
   
    for (UIViewController* testViewController in self.tabBarController.viewControllers) {
        if ([testViewController isKindOfClass:[UINavigationController class]]) {
            
            UIViewController* MyViewController=((UINavigationController *)testViewController).viewControllers[0];
            
            if ( [MyViewController isKindOfClass:[MyTripViewController class]]) {
                [(MyTripViewController *)MyViewController setNotification];
                [(MyTripViewController *)MyViewController loadDetails];

            }
           
        }
    }
    
   //  [self.view layoutIfNeeded];
    
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.destinationBanner.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,self.destinationPagerView.bounds.size.height);
    self.experienceBanner.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,self.experiencePagerView.bounds.size.height);
    self.offersBanner.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,self.offersPagerView.bounds.size.height);
    

    //[self.view layoutIfNeeded];
}

-(void) viewWillAppear:(BOOL)animated{
    
    
}

-(void) downloadImages
{
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:ACCESS_KEY forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/cities/api-get-home-sliders",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"home Result %@",responseObject);
        
    
        NSMutableArray *imageArray=[[NSMutableArray alloc] init];
        imageArray=[responseObject objectForKey:@"cities"];
        
        self.destinations=[[NSMutableArray alloc] init];
        
        
        for (int i=0; i<imageArray.count; i++) {
            
            Destination *destionations=[Destination new];
            destionations.cityName=  [[imageArray objectAtIndex:i] objectForKey:@"title"];
            destionations.cityId=  [[imageArray objectAtIndex:i] objectForKey:@"id"];
            destionations.featuredImage=  [[imageArray objectAtIndex:i] objectForKey:@"featured_image"];
            
            [self.destinations addObject:destionations];
            
            [self.destinationImageUrls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,destionations.featuredImage]]];
        }
        
        imageArray=[[NSMutableArray alloc] init];
        imageArray=[responseObject objectForKey:@"experiences"];
       
        self.experiences=[[NSMutableArray alloc] init];
        
        for (int i=0; i<imageArray.count; i++) {
            
            Activity *activity=[Activity new];
            activity.activityId=  [[imageArray objectAtIndex:i] objectForKey:@"id"];
            activity.activityName=  [[imageArray objectAtIndex:i] objectForKey:@"title"];
            activity.featuredImage=  [[imageArray objectAtIndex:i] objectForKey:@"featured_image"];
            
            [self.experiences addObject:activity];
            
            [self.experienceImageUrls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,activity.featuredImage]]];
        }
        
        
        imageArray=[[NSMutableArray alloc] init];
        imageArray=[responseObject objectForKey:@"offers"];
        
        self.offers=[[NSMutableArray alloc] init];
        
        
        for (int i=0; i<imageArray.count; i++) {
            
            Offers *singleOffer=[Offers new];
            singleOffer.offerId=  [[imageArray objectAtIndex:i] objectForKey:@"id"];
            singleOffer.offerTitle=  [[imageArray objectAtIndex:i] objectForKey:@"title"];
            singleOffer.featuredImage=  [[imageArray objectAtIndex:i] objectForKey:@"image_url"];
            
            [self.offers addObject:singleOffer];
            
            
            [self.offerImageUrls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,singleOffer.featuredImage]]];
        }

        
        [self loadCarousal];
        
        }
        
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@",error);
        
            [self.destinationImageUrls addObject:[UIImage imageNamed:@"destination.png"]];
            [self.destinationImageUrls addObject:[UIImage imageNamed:@"destination.png"]];
            [self.destinationImageUrls addObject:[UIImage imageNamed:@"destination.png"]];
            
            [self.experienceImageUrls addObject:[UIImage imageNamed:@"experience.png"]];
            [self.experienceImageUrls addObject:[UIImage imageNamed:@"experience.png"]];
            [self.experienceImageUrls addObject:[UIImage imageNamed:@"experience.png"]];
            
            [self.offerImageUrls addObject:[UIImage imageNamed:@"offers.png"]];
            [self.offerImageUrls addObject:[UIImage imageNamed:@"offers.png"]];
            [self.offerImageUrls addObject:[UIImage imageNamed:@"offers.png"]];
            
            [self loadCarousal];
    }];
    
}

-(void) loadCarousal
{
    self.destinationBanner = [KDCycleBannerView new];
     self.destinationBanner.datasource = self;
    self.destinationBanner.delegate = self;
    self.destinationBanner.continuous = YES;
    self.destinationBanner.autoPlayTimeInterval = 5;
    self.destinationBanner.tag=1;
    [self.destinationPagerView addSubview:self.destinationBanner];
    [self.destinationPagerView sendSubviewToBack:self.destinationBanner];
    
    
    self.experienceBanner = [KDCycleBannerView new];
    
    self.experienceBanner.datasource = self;
    self.experienceBanner.delegate = self;
    self.experienceBanner.continuous = YES;
    self.experienceBanner.autoPlayTimeInterval = 5;
    self.experienceBanner.tag=2;
    
    [self.experiencePagerView addSubview:self.experienceBanner];
    [self.experiencePagerView sendSubviewToBack:self.experienceBanner];
    
    
    self.offersBanner = [KDCycleBannerView new];
      self.offersBanner.datasource = self;
    self.offersBanner.delegate = self;
    self.offersBanner.continuous = YES;
    self.offersBanner.autoPlayTimeInterval = 5;
    self.offersBanner.tag=3;
    
    [self.offersPagerView addSubview:self.offersBanner];
    [self.offersPagerView sendSubviewToBack:self.offersBanner];

    
}

//- (UIImage *)placeHolderImageOfZeroBannerView {
//    return [UIImage imageNamed:@"lower_marketing_ad_image.png"];
//}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index {
    NSLog(@"didScrollToIndex:%ld", (long)index);
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"didSelectedAtIndex:%ld %ld", (long)index,(long)bannerView.tag);
 
    
    if(bannerView.tag==1)
    {
        DestinationDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"DestinationDetailsViewController"];
        
        Destination *destionations=[Destination new];
        destionations=[self.destinations objectAtIndex:index];

        viewController.cityID=destionations.cityId;
        viewController.cityName=destionations.cityName;
        [self.navigationController pushViewController:viewController animated:YES];
    
    }
    else if(bannerView.tag==2)
    {
        
        ExperienceDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ExperienceDetailsViewController"];
        
        Activity *activity=[Activity new];
        activity=[self.experiences objectAtIndex:index];
        
        viewController.activityId=activity.activityId;
        viewController.activityName=activity.activityName;
        
        //NSLog(@"%@",viewController.activityId);
        
        //NSLog(@"%@",viewController.activityName);
        [self.navigationController pushViewController:viewController animated:YES];
    }else
    {
        
        OfferDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetailsViewController"];
        
        Offers *offer=[Offers new];
        offer=[self.offers objectAtIndex:index];
        
        viewController.offerID=offer.offerId;
        viewController.offerName=offer.offerTitle;
        
        [self.navigationController pushViewController:viewController animated:YES];

    
    }
    
    
    
    
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"destination.png"];
}

#pragma mark - KDCycleBannerViewDataource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView {
    
    //return self.addImageArray;
    
    if (bannerView.tag==1) {
//        return @[[UIImage imageNamed:@"destination.png"],
//                 [UIImage imageNamed:@"experience.png"],
//                 [UIImage imageNamed:@"destination.png"],
//                 [UIImage imageNamed:@"experience.png"],
//                 [UIImage imageNamed:@"destination.png"]];
        
        return self.destinationImageUrls;
        
    }
    else if (bannerView.tag==2) {
        
//        return @[[UIImage imageNamed:@"experience.png"],
//                 [UIImage imageNamed:@"experience.png"],
//                 [UIImage imageNamed:@"experience.png"]];
        
        return self.experienceImageUrls;

    }
    else
    {
        
//        return @[[UIImage imageNamed:@"offers.png"],
//                 [UIImage imageNamed:@"offers.png"],
//                 [UIImage imageNamed:@"offers.png"]];
        
        return self.offerImageUrls;

        
    }
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleToFill;
}

- (IBAction)moveToCreateTrip:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CreateTripNotification"
     object:self];

    self.tabBarController.selectedIndex = 0;
    
}
- (IBAction)moveToOffers:(id)sender {
    self.tabBarController.selectedIndex = 3;
}
- (IBAction)moveToMyTrip:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MyTripNotification"
     object:self];
    
    self.tabBarController.selectedIndex = 0;
    
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
