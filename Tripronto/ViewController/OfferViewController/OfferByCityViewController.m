//
//  OfferByCityViewController.m
//  Tripronto
//
//  Created by Sujan on 11/14/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "OfferByCityViewController.h"
#import "OfferByCityCollectionViewCell.h"
#import "OfferDetailsViewController.h"
#import "Offers.h"
#import "Constants.h"

#import <CoreText/CoreText.h>

@interface OfferByCityViewController (){


    NSMutableArray* cityOfferArray;



}

@end

@implementation OfferByCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"city id %@",self.cityId);
    
    self.nevTitle.text = self.cityName;
    
    self.offerByCityCollectionView.delegate = self;
    self.offerByCityCollectionView.dataSource= self;
    
    [self loadOffers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadOffers
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:self.cityId forKey:@"city_id"];
    
    NSLog(@"postdata %@",postData);
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/offers/api-get-offer-by-city",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        cityOfferArray = [[NSMutableArray alloc]init];
        
        NSMutableArray* offersArray = [[NSMutableArray alloc]init];
        
        offersArray =[responseObject objectForKey:@"Offers"];
        
         NSLog(@"offers offersArray %@",offersArray);
        
        NSMutableDictionary* singleOffer=[[NSMutableDictionary alloc]init];
        
        
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
            
            
            
            
            [cityOfferArray addObject:offer];
            
            
            
        }
        
       [self.offerByCityCollectionView reloadData];
    
         NSLog(@"offers offersArray %@",cityOfferArray);
        
       
        
    }
     
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"error %@",error);
                      
                  }];
}



#pragma mark - CollectionView data source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  cityOfferArray.count;
    
    

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *identifier = @"offerByCityCell";
    
    OfferByCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Offers *singleOffer=[Offers new];
    
    singleOffer = [cityOfferArray objectAtIndex:indexPath.row];
    

    [cell.cityFeaturedImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL, singleOffer.featuredImage]]];
    [cell.expertProPicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL, singleOffer.expertImage]]];
    
    cell.cityNameLabel.text = singleOffer.city;
    cell.offerNameLabel.text = singleOffer.offerTitle;
    
    
    NSDictionary * superscriptAttrs = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
                                                                  forKey:kCTSuperscriptAttributeName];
    
    
    NSMutableAttributedString * st = [[NSMutableAttributedString alloc] initWithString:@"$"
                                                                            attributes:superscriptAttrs];
    
    [st addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Azosans-Regular" size:10.0] range:NSMakeRange(0, st.length)];
    
    
    NSAttributedString * priceTag = [[NSAttributedString alloc] initWithString:singleOffer.price];
    
    [st appendAttributedString:priceTag];
    
    cell.costLabel.attributedText = st;
    
    
    
    return cell;
    
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-20-2)/2, ([UIScreen mainScreen].bounds.size.width-20-2)/2);
    
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Offers *singleOffer=[Offers new];
    
    singleOffer = [cityOfferArray objectAtIndex:indexPath.row];
    
    OfferDetailsViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OfferDetailsViewController"];
    
      controller.offerID = singleOffer.offerId;
      controller.offerName = singleOffer.offerTitle;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
