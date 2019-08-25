//
//  OfferViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "OfferViewController.h"
#import "OfferByCityViewController.h"
#import "OfferDetailsViewController.h"
#import "Offers.h"
#import "Constants.h"

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>


@interface OfferViewController (){


    NSMutableArray *offersArray;

}

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.destinationCollectionView.delegate = self;
    self.destinationCollectionView.dataSource = self;
    
    self.offers = [[NSMutableArray alloc]init];
    self.citysArray = [[NSMutableArray alloc]init];
    
    
    [self loadFeaturesOffers];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // NSLog(@"self %@",self.view);
//    [self setupCarousel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadFeaturesOffers
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/offers/api-get-offer-listing",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    
        offersArray = [[NSMutableArray alloc]init];
        offersArray =[responseObject objectForKey:@"offers"];
        
        self.citysArray = [responseObject objectForKey:@"cities"];

        NSMutableDictionary* singleOffer=[[NSMutableDictionary alloc]init];
        
       //[[inbox objectForKey:@"user"] objectForKey:@"first_name"]
        
        for (int i=0; i<offersArray.count; i++) {
            
            singleOffer = [offersArray objectAtIndex:i];
            
            
            Offers *offer=[Offers new];
            offer.offerId=[singleOffer objectForKey:@"id"];
            offer.offerTitle=[singleOffer objectForKey:@"title"];
            offer.offerDetails=[singleOffer objectForKey:@"description"];
            offer.featuredImage=  [singleOffer objectForKey:@"image_url"];
            offer.price = [NSString stringWithFormat:@"%@",[singleOffer objectForKey:@"price"]];
            
            offer.city = [[[singleOffer objectForKey:@"cities"] objectAtIndex:0] objectForKey:@"title"];
            offer.noOfDays = [[[singleOffer objectForKey:@"cities"] objectAtIndex:0] objectForKey:@"nights"];
            
            offer.expertId=  [[singleOffer objectForKey:@"expert"] objectForKey:@"id"];
            offer.expertImage = [[singleOffer objectForKey:@"expert"] objectForKey:@"photo_reference"];
            
            NSLog(@"offers offerTitle %@",offer.offerTitle);
            
           
            [self.offers addObject:offer];
            
            if (offersArray.count - 1 == i) {
                
                [self setupCarousel];
            }
            
        }
        
    
        
        [self.destinationCollectionView reloadData];
        
         NSLog(@"offers offer %@",self.offers);

    }
     
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"error %@",error);
                      
                  }];
}

-(void)setupCarousel
{
    self.carouselView.delegate = self;
    self.carouselView.datasource = self;
    self.carouselView.itemMargin = 10;
    
}

-(NSInteger)numberOfItemsInCarousel:(TGLParallaxCarousel *)carousel
{

    return self.offers.count;
}

-(TGLParallaxCarouselItem *)viewForItemAtIndex:(NSInteger)index carousel:(TGLParallaxCarousel *)carousel
{
    //    TGLCustomView* customView=[[TGLCustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height-90,self.view.frame.size.height-90) number:[NSString stringWithFormat:@"%@",[[ self.imageDetailsArray objectAtIndex:index] objectForKey:@"artist"]]];
    
    //NSLog(@"offers offer %@",self.offers);
    
    Offers *singleOffer=[Offers new];
    
    singleOffer = [self.offers objectAtIndex:index];
    
    
   
    NSLog(@"singleoffer in offers %@ ",singleOffer);
  
    
    TGLCustomView* customView=[[TGLCustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60,self.view.frame.size.width-60) cost:@"100"];
    
       [customView.containerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL, singleOffer.featuredImage]]];
      [customView.expartImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL, singleOffer.expertImage]]];
    
       customView.destinationName.text = singleOffer.city;
       customView.offerName.text = singleOffer.offerTitle;
    
    
    NSDictionary * superscriptAttrs = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
                                                                  forKey:kCTSuperscriptAttributeName];
    
    
    NSMutableAttributedString * st = [[NSMutableAttributedString alloc] initWithString:@"$"
                                                              attributes:superscriptAttrs];
    
    [st addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Azosans-Regular" size:11.0] range:NSMakeRange(0, st.length)];
    
    
    NSAttributedString * priceTag = [[NSAttributedString alloc] initWithString:singleOffer.price];
    
    [st appendAttributedString:priceTag];
    
    
    customView.costLabel.attributedText = st;
    
    
    
    
    // NSLog(@"customView %@",customView);
    
    return customView;
}


-(void)didTapOnItemAtIndex:(NSInteger)index carousel:(TGLParallaxCarousel *)carousel
{
    NSLog(@"tap at index %li",(long)index);
    
    Offers *singleOffer=[Offers new];
    
    singleOffer = [self.offers objectAtIndex:index];
    
    OfferDetailsViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetailsViewController"];
    
     controller.offerID = singleOffer.offerId;
     controller.offerName = singleOffer.offerTitle;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)didMovetoPageAtIndex:(NSInteger)index
{
    NSLog(@"move to index %li",(long)index);
}






#pragma mark - CollectionView data source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  self.citysArray.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *identifier = @"destinationCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    cell.contentView.layer.cornerRadius = 5.0;
//    cell.contentView.layer.masksToBounds = YES;
//    
    NSMutableDictionary *singleCity = [[NSMutableDictionary alloc] init];
    
    singleCity = [self.citysArray objectAtIndex:indexPath.row];
    
    [cell layoutIfNeeded];
    
    UIImageView *cityImage = (UIImageView*) [cell viewWithTag:1];
    
    cityImage.layer.cornerRadius = 5.0;
    cityImage.layer.masksToBounds = YES;
    cityImage.clipsToBounds = YES;
    
    [cityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[singleCity objectForKey:@"featured_image"]]]];
    
   
    UILabel *cityName = (UILabel*) [cell viewWithTag:2];
    
    cityName.text = [singleCity objectForKey:@"title"];
    
    UIView *shadeView = (UIView*) [cell viewWithTag:3];
    
    shadeView.layer.cornerRadius = 5.0;
    shadeView.clipsToBounds = YES;
    shadeView.layer.masksToBounds = YES;
//
    
    
    
    return cell;
    
    
}
-(void)viewDidLayoutSubviews
{
    NSLog(@"viewDidLayoutSubviews");
    [self.view layoutIfNeeded];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-40)/2.5, ([UIScreen mainScreen].bounds.size.width-40)/2.5);
    
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
       NSMutableDictionary *singleCity = [[NSMutableDictionary alloc] init];
    
       singleCity = [self.citysArray objectAtIndex:indexPath.row];
    
        OfferByCityViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferByCityViewController"];
    
           controller.cityId = [singleCity objectForKey:@"id"];
           controller.cityName = [singleCity objectForKey:@"title"];
    
        [self.navigationController pushViewController:controller animated:YES];
    
    
}




@end
