//
//  OfferDetailsViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/27/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import "Constants.h"
#import "Offers.h"
#import "ResponsiveLabel.h"
#import "HexColors.h"

#import <CoreText/CoreText.h>



@interface OfferDetailsViewController ()
{
    NSMutableDictionary* offerDetails;
    NSMutableArray *imagesArray;
    NSMutableArray *activityArray;
    NSMutableArray *hotelsArray;
    NSMutableArray *accmodationTypeArray;
    NSMutableArray *facitityArray;
    NSMutableArray *airLinesArray;
    NSMutableArray *similarOfferArray;
    
    Offers *offer;
}

@end

@implementation OfferDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navTitle.text=self.offerName;
    
    offer=[Offers new];
    
    self.expertProPicture.layer.cornerRadius = self.expertProPicture.frame.size.width / 2;
    self.expertProPicture.clipsToBounds = YES;
    
    
//    self.offerDetailsViewPager.isSingle=true;
//    self.offerDetailsViewPager.dataSource=self;
//    //self.offerDetailsViewPager.delegate=self;
//    self.offerDetailsViewPager.userPagerDelegate=self;
//    
//    self.similarOffersViewPager.isSingle=false;
//    self.similarOffersViewPager.dataSource=self;
//    self.similarOffersViewPager.delegate=self;
    //self.similarOffersViewPager.userPagerDelegate=self;
    
    
    
    self.descriptionLabel.userInteractionEnabled = YES;
    
    
    
    
    imagesArray = [[NSMutableArray alloc] initWithObjects:@"guests.png", @"business.png",@"days.png", nil];
    
//     demoArray =[[NSMutableArray alloc] initWithObjects:@"time:",@"2",@"items:",@"10",@"difficulty:",@"hard",@"category:",@"main",nil];
    
    
    self.quickInfoCollectionView.delegate =self;
    self.quickInfoCollectionView.dataSource = self;
    
    self.activitiesCollectionView.delegate = self;
    self.activitiesCollectionView.dataSource=self;
    
    self.similarOfferCollectionView.delegate = self;
    self.similarOfferCollectionView.dataSource=self;
    
    self.accomodationCollectionView.delegate =self;
    self.accomodationCollectionView.dataSource = self;
    
    self.hotelsCollectionView.delegate = self;
    self.hotelsCollectionView.dataSource=self;
    
    self.offerFacilitiesCollectionView.delegate = self;
    self.offerFacilitiesCollectionView.dataSource=self;
   
    self.airlinesCollectionView.delegate = self;
    self.airlinesCollectionView.dataSource=self;
    
    //test
    
    NSString *labelText = @"We are what our thoughts have made us; so take care about what you think. Words are secondary. Thoughts live; they travel far.The issue that's occurring is that the height of the label has empty space at its top and bottom, and that the longer the string inside it is, the larger that empty space is. A single line label might have perhaps 10 pixels above and below it inside the label's frame, but a six-line string may have almost 100 pixels. I'm not able to track down where this extra space is coming from in the methods above.";

    self.termsLabel.text = labelText;
    
    [self loadDetails];

}


-(void)loadDetails
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:self.offerID forKey:@"offer_id"];
    
    
    NSLog(@"self.offerID %@",self.offerID);
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/offers/api-get-offer-detail",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        
        offerDetails=[[NSMutableDictionary alloc] init];
        
        offerDetails=[responseObject objectForKey:@"offer_detail"];
        
        similarOfferArray =[[NSMutableArray alloc]init];
        similarOfferArray = [responseObject objectForKey:@"similar_offers"];
        
        
       // NSLog(@"offerDetails%@ ",offerDetails);
        
       
        offer.offerId=[offerDetails objectForKey:@"id"];
        offer.offerTitle=[offerDetails objectForKey:@"title"];
        offer.offerDetails=[offerDetails objectForKey:@"description"];
        offer.featuredImage=  [offerDetails objectForKey:@"image_url"];
        offer.price = [NSString stringWithFormat:@"%@",[offerDetails objectForKey:@"price"]];
        offer.noOfPassengers = [offerDetails objectForKey:@"no_of_passengers"];
        offer.noOfDays = [offerDetails  objectForKey:@"nights"];
        offer.flightClasses = [offerDetails objectForKey:@"flight_classes"];
        
        
        NSMutableArray *cityArray =[[NSMutableArray alloc]init];
        
        cityArray = [offerDetails objectForKey:@"cities"];
        
       // offer.city = [[[offerDetails objectForKey:@"cities"] objectAtIndex:0] objectForKey:@"title"];

        offer.expertId=  [[offerDetails objectForKey:@"expert"] objectForKey:@"id"];
        offer.expertImage = [[offerDetails objectForKey:@"expert"] objectForKey:@"photo_reference"];
        
        
        
        NSLog(@"offers offer city array %@",cityArray);
        
        activityArray =[[NSMutableArray alloc]init];
        activityArray = [offerDetails objectForKey:@"activities"];
        
        hotelsArray =[[NSMutableArray alloc]init];
        hotelsArray = [offerDetails objectForKey:@"hotels"];
        
        accmodationTypeArray=[[NSMutableArray alloc]init];
        accmodationTypeArray = [offerDetails objectForKey:@"accomodation_types"];
        
        facitityArray =[[NSMutableArray alloc]init];
        facitityArray = [offerDetails objectForKey:@"offered_facilities"];
       
        airLinesArray =[[NSMutableArray alloc]init];
        airLinesArray = [offerDetails objectForKey:@"airlines"];
        
       
        
        
        //cost label
        
        NSDictionary * superscriptAttrs = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
                                                                      forKey:kCTSuperscriptAttributeName];
        
        
        NSMutableAttributedString * st = [[NSMutableAttributedString alloc] initWithString:@"$"
                                                                                attributes:superscriptAttrs];
        
        [st addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Azosans-Regular" size:12.0] range:NSMakeRange(0, st.length)];
        
        
        NSAttributedString * priceTag = [[NSAttributedString alloc] initWithString:offer.price];
        
        [st appendAttributedString:priceTag];
        
        self.costLabel.attributedText = st;
        
        self.offerNameLabel.text = offer.offerTitle;
        
        
        [self.offerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL, offer.featuredImage]]];
        [self.expertProPicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL, offer.expertImage]]];
        
         self.descriptionLabel.text = offer.offerDetails;

        // Add collapse token
        
  
          self.descriptionLabel.customTruncationEnabled = YES;
        
          PatternTapResponder moreTapped = ^(NSString *string) {
            NSLog(@"more tapped");
              
              self.descriptionLabel.numberOfLines = 0;
              
              
                  PatternTapResponder lessTapped = ^(NSString *string) {
                      self.descriptionLabel.numberOfLines = 2;
                  };
                  
                  NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc]initWithAttributedString:self.descriptionLabel.attributedText];
                  
                  [finalString appendAttributedString:[[NSAttributedString alloc] initWithString:@"...Less"
                                                                                      attributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexString:@"#E03365"],
                                                                                                   RLTapResponderAttributeName:lessTapped}]];
              
              if (![self.descriptionLabel.text containsString:@"Less"]  ) {
                  
                  [self.descriptionLabel setAttributedText:finalString];
              }
              
              
              

          };
        
        
          [self.descriptionLabel setAttributedTruncationToken:[[NSAttributedString alloc] initWithString:@"...read more"
                                                                                            attributes:@{NSFontAttributeName:self.descriptionLabel.font,NSForegroundColorAttributeName:[UIColor hx_colorWithHexString:@"#E03365"],
                                                                                                         
                                                                                                         RLTapResponderAttributeName:moreTapped
                                                                                                         }]];
        
        
        //steperView
        
        CGFloat filterWidth=65;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, self.steperView.bounds.size.width-10, 60)];
        
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator=NO;
        [self.steperView addSubview:scrollView];
        
        NSMutableArray* destinations=[[NSMutableArray alloc] init];
        
        //[destinations addObject:[[[offerDetails objectForKey:@"cities"] objectAtIndex:0] objectForKey:@"title"]];
        // NSLog(@"destinations %@",destinations);
        
        for (int i=1; i<= cityArray.count; i++) {

                [destinations addObject: [[cityArray objectAtIndex:i-1] objectForKey:@"title"]];
            
        }
        //NSLog(@"destinations after %@",destinations);
//        if (![Trip sharedManager].isOneWay) {
//            [destinations addObject:[self getCityFromFullString:[Summary sharedManager].startingCity]];
//            
//        }
        //  NSLog(@"destinations after after %@",destinations);
        
        if(([UIScreen mainScreen].bounds.size.width-30)>filterWidth*destinations.count)
        {
            filterWidth=  ([UIScreen mainScreen].bounds.size.width-30)/destinations.count;
            
        }
        
        //  [Summary sharedManager]
        SEFilterControl *filter = [[SEFilterControl alloc]initWithFrame:CGRectMake(0, 0, filterWidth*destinations.count, 60) titles:destinations];
        [scrollView addSubview:filter];
        
        [filter setProgressColor:[UIColor grayColor]];
        //    filter.handler.shadowColor=[UIColor clearColor];
        filter.handler.handlerColor = [UIColor clearColor];
        filter.handler.circleColor = [UIColor clearColor];
        [filter setTitlesFont:[UIFont fontWithName:@"AzoSans-Regular" size:12]];
        
        scrollView.contentSize = CGSizeMake(filterWidth*destinations.count, scrollView.frame.size.height);
        
        
      
        [self.quickInfoCollectionView reloadData];
        [self.similarOfferCollectionView reloadData];
        [self.activitiesCollectionView reloadData];
        [self.hotelsCollectionView reloadData];
        [self.accomodationCollectionView reloadData];
        [self.offerFacilitiesCollectionView reloadData];
        [self.airlinesCollectionView reloadData];
       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
#pragma mark - CollectionView data source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.quickInfoCollectionView)
    {
      return imagesArray.count ;
    }
    else if(collectionView == self.activitiesCollectionView)
    {
    
      return  activityArray.count;
    
    }else if (collectionView == self.hotelsCollectionView)
    {
        
        return  hotelsArray.count;
        
    }else if (collectionView == self.accomodationCollectionView)
    {
        
        return  accmodationTypeArray.count;
        
    }else if (collectionView == self.offerFacilitiesCollectionView)
    {
        
        return  facitityArray.count;
        
    }else if (collectionView == self.airlinesCollectionView)
    {
        
        return  airLinesArray.count;
        
    }
    else if (collectionView == self.similarOfferCollectionView)
    {
        
        return  similarOfferArray.count;
        
    }
    
    return  0;
    
}

#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
    
    if(collectionView == self.quickInfoCollectionView)
    {
        
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"quickInfoCell" forIndexPath:indexPath];
        
        //offer=[Offers new];
        
        NSLog(@"offers offer city.... %@",offer.noOfPassengers);
        NSLog(@"offers offer city.... %@",offer.noOfDays);
        NSLog(@"offers offer city .....%@",offer.flightClasses);
        
        UIImageView* quickInfoImage=(UIImageView* )[cell viewWithTag:1];
        
         quickInfoImage.image = [UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
        
        UILabel* quickInfoLabel=(UILabel* )[cell viewWithTag:2];
        
        if (indexPath.row == 0) {
            
            quickInfoLabel.text = [NSString stringWithFormat:@"%@ guests",offer.noOfPassengers];
            
        }
        else if (indexPath.row == 1){
        
            quickInfoLabel.text = offer.flightClasses;

        }
        else if (indexPath.row == 2){
        
            quickInfoLabel.text = [NSString stringWithFormat:@"%@ nights",offer.noOfDays];

        
        }
       
        
    }
    else if(collectionView == self.activitiesCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"activitiesCell" forIndexPath:indexPath];
        
        NSMutableDictionary *temDic = [activityArray objectAtIndex:indexPath.row];
        
        UIImageView* activityImage=(UIImageView* )[cell viewWithTag:1];

        [activityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[temDic objectForKey:@"featured_image"]]]];
        
        UILabel *activityName = (UILabel *)[cell viewWithTag:2];
        
        activityName.text = [NSString stringWithFormat:@"%@",[temDic objectForKey:@"title"]];

    }else if(collectionView == self.hotelsCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotelsCell" forIndexPath:indexPath];
        
        UIView *borderView = (UIView *)[cell viewWithTag:1];
        
        borderView.layer.borderWidth = 1.0;
        borderView.layer.borderColor = [[UIColor hx_colorWithHexString:@"#E03365"]CGColor];
        borderView.layer.cornerRadius = 15;
        
        UILabel *hotelName = (UILabel *)[cell viewWithTag:2];
        
        NSMutableDictionary *temDic = [hotelsArray objectAtIndex:indexPath.row];
        
        hotelName.text = [NSString stringWithFormat:@"%@",[temDic objectForKey:@"title"]];
        
        
    }else if(collectionView == self.accomodationCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"accomodationCell" forIndexPath:indexPath];
        UIView *borderView = (UIView *)[cell viewWithTag:1];
        
        borderView.layer.borderWidth = 1.0;
        borderView.layer.borderColor = [[UIColor hx_colorWithHexString:@"#E03365"]CGColor];
        borderView.layer.cornerRadius = 15;
        
        UILabel *accomodationTypeName = (UILabel *)[cell viewWithTag:2];
        NSMutableDictionary *temDic = [accmodationTypeArray objectAtIndex:indexPath.row];
        accomodationTypeName.text = [NSString stringWithFormat:@"%@",[temDic objectForKey:@"title"]];
        
    }else if(collectionView == self.offerFacilitiesCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerFacilitiesCell" forIndexPath:indexPath];
        
        UIView *borderView = (UIView *)[cell viewWithTag:1];
        
        borderView.layer.borderWidth = 1.0;
        borderView.layer.borderColor = [[UIColor hx_colorWithHexString:@"#E03365"]CGColor];
        borderView.layer.cornerRadius = 15;
        
        UILabel *facilityName = (UILabel *)[cell viewWithTag:2];
        NSMutableDictionary *temDic = [facitityArray objectAtIndex:indexPath.row];
        facilityName.text = [NSString stringWithFormat:@"%@",[temDic objectForKey:@"facility"]];
        
        NSLog(@" facility  %@",[temDic objectForKey:@"facility"]);
        
    }else if(collectionView == self.airlinesCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"airLinesCell" forIndexPath:indexPath];
        
        NSMutableDictionary *temDic = [airLinesArray objectAtIndex:indexPath.row];
        
        UIImageView* logo=(UIImageView* )[cell viewWithTag:1];
        
        logo.layer.cornerRadius = 3;
        logo.layer.borderWidth = 1.0;
        logo.layer.borderColor = [[UIColor hx_colorWithHexString:@"#E03365"]CGColor];
        logo.clipsToBounds = YES;
        
        [logo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[temDic objectForKey:@"logo"]]]];
        
    }
    else if(collectionView == self.similarOfferCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"similarOfferCell" forIndexPath:indexPath];
        
        NSMutableDictionary *temDic = [similarOfferArray objectAtIndex:indexPath.row];
        
        UIImageView* offerImage=(UIImageView* )[cell viewWithTag:1];
        
        [offerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[temDic objectForKey:@"image_url"]]]];
        
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
        
        priceLabel.text = [NSString stringWithFormat:@"$%@",[temDic objectForKey:@"price"]];
        
    }

    
    return cell;
    
}

//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    
//    return 1;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == self.quickInfoCollectionView)
    {
    
       return CGSizeMake(([UIScreen mainScreen].bounds.size.width-50)/3, ([UIScreen mainScreen].bounds.size.width-50)/3);
    }
    else if(collectionView == self.activitiesCollectionView)
    {
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width)/2, ([UIScreen mainScreen].bounds.size.width)/2);
        
    }else if(collectionView == self.hotelsCollectionView)
    {
      if (hotelsArray.count != 0) {
        
        CGSize calCulateSizze =[(NSString*)[[hotelsArray objectAtIndex:indexPath.row] objectForKey:@"title"] sizeWithAttributes:NULL];
        NSLog(@"%f     %f",calCulateSizze.height, calCulateSizze.width);
        calCulateSizze.width = calCulateSizze.width+40;
        calCulateSizze.height = 44;
        return calCulateSizze;
      }
    }else if(collectionView == self.accomodationCollectionView)
    {
      if (accmodationTypeArray.count !=0) {
       
        CGSize calCulateSize =[(NSString*)[[accmodationTypeArray objectAtIndex:indexPath.row] objectForKey:@"title"] sizeWithAttributes:NULL];
                calCulateSize.width = calCulateSize.width+40;
        calCulateSize.height = 44;
        return calCulateSize;
      }
    }else if(collectionView == self.offerFacilitiesCollectionView)
    {
      if (facitityArray.count !=0) {
        CGSize calCulateSizze =[(NSString*)[[facitityArray objectAtIndex:indexPath.row] objectForKey:@"facility"] sizeWithAttributes:NULL];
        NSLog(@"%f     %f",calCulateSizze.height, calCulateSizze.width);
        calCulateSizze.width = calCulateSizze.width+40;
        calCulateSizze.height = 44;
        return calCulateSizze;
      }
    }else if(collectionView == self.airlinesCollectionView)
    {
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width)/5, ([UIScreen mainScreen].bounds.size.width)/5);
    }
    else if(collectionView == self.similarOfferCollectionView)
    {
    
       return CGSizeMake(([UIScreen mainScreen].bounds.size.width)/3, ([UIScreen mainScreen].bounds.size.width)/3);
    }
    
    return CGSizeMake(0,0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    ExploreTableViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreTableViewController"];
    //
    //
    //
    //    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (IBAction)termsButtonAction:(UIButton*)sender {
    
    sender.selected=!sender.selected;
    
    if (sender.selected) {
        
        //get text size
        CGSize constraint = CGSizeMake(self.termsLabel.frame.size.width, CGFLOAT_MAX);
        CGSize size;
        
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGSize boundingBox = [self.termsLabel.text boundingRectWithSize:constraint
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:self.termsLabel.font}
                                                      context:context].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        
        CGFloat newHeight = size.height + 60 ;
        
        NSLog(@"newHeight %f",newHeight);
        
        
        [UIView animateWithDuration:0.5f
                         animations:^{

                             self.termsViewHeight.constant = newHeight;
                             [self.view layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished){
                             
                             

                             NSLog( @"woo! Finished animating the frame of myView!" ); 
                         }];
        
       
        

        self.termsView.layer.cornerRadius = 5;
        
    }else
    {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             
                             self.termsViewHeight.constant = 40;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                             
                             
                         }];
        
        
        
        self.termsView.layer.cornerRadius = 0;
    }
    
    
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: 0
                     animations: ^{
                         self.downArrowImage.transform = CGAffineTransformRotate(self.downArrowImage.transform, M_PI);
                     }
                     completion: ^(BOOL finished) {
                         
                        
                     }];
    
    
}





@end
