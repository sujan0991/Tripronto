//
//  DestinationListingViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/19/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "DestinationListingViewController.h"

#import "Destination.h"
#import "Constants.h"

@interface DestinationListingViewController ()
@end

@implementation DestinationListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.destinationBanner.datasource = self;
//    self.destinationBanner.delegate = self;
//    self.destinationBanner.continuous = YES;
//    self.destinationBanner.autoPlayTimeInterval = 5;
//    self.destinationBanner.tag=1;
//    [self.destinationBanner hiddenPageControl];
    
    //[self loadData];

    [self loadCities];
    
    self.destinationViewPager.isSingle=false;
    self.destinationViewPager.dataSource=self;
    self.destinationViewPager.delegate=self;
    //self.experienceViewPager.userPagerDelegate=self;
    
    self.destinationListingTable.delegate=self;
    self.destinationListingTable.dataSource=self;
    
    self.destinationListingTable.treeFooterView = [UIView new];
    self.destinationListingTable.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.destinationListingTable.scrollView addSubview:refreshControl];
    
    [self.destinationListingTable reloadData];
    [self.destinationListingTable setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    [self.destinationListingTable registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
}



-(void) loadCities
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/cities/api-get-destination-listing",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.destinations=[[NSMutableArray alloc] init];
        self.destinations=[responseObject objectForKey:@"Featured_Cities"];
        
        [self.destinationViewPager reloadData];
        
        NSMutableArray* regionList=[responseObject objectForKey:@"region_list"];
        
        
        NSMutableArray *dataArray=[[NSMutableArray alloc] init];
        
        
        for (int i=0; i<regionList.count; i++) {
            
           
            
            NSString* regionName= [[regionList objectAtIndex:i] objectForKey:@"title"];
            
            NSMutableArray *countries=[[NSMutableArray alloc] init];
            countries=[[regionList objectAtIndex:i] objectForKey:@"countries"];
            
            NSMutableArray *countryChildArray=[[NSMutableArray alloc] init];
            
            
            for (int j=0; j<countries.count; j++) {
                
                NSString* countryName=[[countries objectAtIndex:j] objectForKey:@"title"];
                
                NSMutableArray *cities=[[NSMutableArray alloc] init];
                cities=[[countries objectAtIndex:j] objectForKey:@"cities"];
                
                NSMutableArray *citisChildArray=[[NSMutableArray alloc] init];
                
                for (int k=0; k<cities.count; k++) {
                  
                    Destination *destionations=[Destination new];
                    destionations.regionName=regionName;
                    destionations.countryName=countryName;
                    destionations.cityName=  [[cities objectAtIndex:k] objectForKey:@"title"];
                    destionations.cityId=  [[cities objectAtIndex:k] objectForKey:@"id"];

                    
                    RADataObject *city = [RADataObject dataObjectWithName:destionations.cityName children:nil withLevel:@"3"];
                    city.dataId=destionations.cityId;
                    
                    [citisChildArray addObject:city];
                    

                   
                }
                
                RADataObject *county = [RADataObject dataObjectWithName:countryName
                                                                  children:citisChildArray withLevel:@"2"];
                
                [countryChildArray addObject:county];
                
                
            }
            
            RADataObject *regionData = [RADataObject dataObjectWithName:regionName children:countryChildArray withLevel:@"1"];
            
            [dataArray addObject:regionData];

          

        }
        
        self.data = dataArray;
        [self.destinationListingTable reloadData];
        }
        
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return YES;
}

//- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
//{
//    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
//    [cell setAdditionButtonHidden:NO animated:YES];
//}
//
//- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
//{
//    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
//    [cell setAdditionButtonHidden:YES animated:YES];
//}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    RADataObject *parent = [self.destinationListingTable parentForItem:item];
    NSInteger index = 0;
    
    if (parent == nil) {
        index = [self.data indexOfObject:item];
        NSMutableArray *children = [self.data mutableCopy];
        [children removeObject:item];
        self.data = [children copy];
        
    } else {
        index = [parent.children indexOfObject:item];
        [parent removeChild:item];
    }
    
    [self.destinationListingTable deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
    if (parent) {
        [self.destinationListingTable reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.destinationListingTable levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of Destination %@", [@(numberOfChildren) stringValue]];
    
    
    RATableViewCell *cell = [self.destinationListingTable dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    __weak typeof(self) weakSelf = self;
//    cell.additionButtonTapAction = ^(id sender){
//        if (![weakSelf.destinationListingTable isCellForItemExpanded:dataObject] || weakSelf.destinationListingTable.isEditing) {
//            return;
//        }
//        RADataObject *newDataObject = [[RADataObject alloc] initWithName:@"Added value" children:@[]];
//        [dataObject addChild:newDataObject];
//        [weakSelf.destinationListingTable insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
//        [weakSelf.destinationListingTable reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
//    };
    
    return cell;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{

    RADataObject *dataObject = item;
    if([dataObject.childLevel isEqualToString:@"3"])
    {
        
        //NSLog(@"data id %@",dataObject.dataId);
        
        DestinationDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"DestinationDetailsViewController"];
        viewController.cityID=dataObject.dataId;
        viewController.cityName=dataObject.name;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

#pragma mark - Helpers

- (void)loadData
{
//    RADataObject *phone1 = [RADataObject dataObjectWithName:@"Phone 1" children:nil];
//    RADataObject *phone2 = [RADataObject dataObjectWithName:@"Phone 2" children:nil];
//    RADataObject *phone3 = [RADataObject dataObjectWithName:@"Phone 3" children:nil];
//    RADataObject *phone4 = [RADataObject dataObjectWithName:@"Phone 4" children:nil];
//    
//    RADataObject *phone = [RADataObject dataObjectWithName:@"Phones"
//                                                  children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]];
    
    RADataObject *notebook1 = [RADataObject dataObjectWithName:@"Doha" children:nil withLevel:@"3"];
    RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Dubai" children:nil withLevel:@"3"];
    
    RADataObject *computer1 = [RADataObject dataObjectWithName:@"Middle East"
                                                      children:[NSArray arrayWithObjects:notebook1, notebook2, nil] withLevel:@"2"];
    RADataObject *computer2 = [RADataObject dataObjectWithName:@"East" children:nil withLevel:@"2"];
    RADataObject *computer3 = [RADataObject dataObjectWithName:@"West" children:nil withLevel:@"2"];
    
    RADataObject *computer = [RADataObject dataObjectWithName:@"Asia"
                                                     children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil] withLevel:@"1"];
    RADataObject *car = [RADataObject dataObjectWithName:@"Cars" children:nil withLevel:@"1"];
    RADataObject *bike = [RADataObject dataObjectWithName:@"Bikes" children:nil withLevel:@"1"];
    RADataObject *house = [RADataObject dataObjectWithName:@"Houses" children:nil withLevel:@"1"];
    RADataObject *flats = [RADataObject dataObjectWithName:@"Flats" children:nil withLevel:@"1"];
    RADataObject *motorbike = [RADataObject dataObjectWithName:@"Motorbikes" children:nil withLevel:@"1"];
    RADataObject *drinks = [RADataObject dataObjectWithName:@"Drinks" children:nil withLevel:@"1"];
    RADataObject *food = [RADataObject dataObjectWithName:@"Food" children:nil withLevel:@"1"];
    RADataObject *sweets = [RADataObject dataObjectWithName:@"Sweets" children:nil withLevel:@"1"];
    RADataObject *watches = [RADataObject dataObjectWithName:@"Watches" children:nil withLevel:@"1"];
    RADataObject *walls = [RADataObject dataObjectWithName:@"Walls" children:nil withLevel:@"1"];
    
    self.data = [NSArray arrayWithObjects: computer, car, bike, house, flats, motorbike, drinks, food, sweets, watches, walls, nil];
    
}

#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView* contentView=(UIImageView* )[cell viewWithTag:101];
    [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
    
    UIButton *activityName = (UIButton *)[cell viewWithTag:102];
    //activityName.titleLabel.text=[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"];
    [activityName setTitle:[[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   
    return self.destinations.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"r");
//    return CGSizeMake(50, 80 );
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected");
    
    DestinationDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"DestinationDetailsViewController"];
    
    
    
    viewController.cityID=[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"id"];
    viewController.cityName=[[self.destinations objectAtIndex:indexPath.row] objectForKey:@"title"];
    

    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - HWViewPagerDelegate
-(void)pagerDidSelectedPage:(NSInteger)selectedPage with:(NSInteger *)pagerTag{
    NSLog(@"FistViewController, SelectedPage : %@ pagerTag %d",[@(selectedPage) stringValue],(int)pagerTag);
    
    
}


//#pragma mark - KDCycleBannerViewDataource
//
//- (NSArray *)numberOfKDCycleSplitBannerView:(KDCycleSplitBannerView *)bannerView {
//    
//    //return self.addImageArray;
//        return @[[UIImage imageNamed:@"destination.png"],
//                 [UIImage imageNamed:@"destination.png"],
//                 [UIImage imageNamed:@"destination.png"],
//                 [UIImage imageNamed:@"destination.png"]];
//   
//    
//}
//
//- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
//    return UIViewContentModeScaleToFill;
//}
//
////- (UIImage *)placeHolderImageOfZeroBannerView {
////    return [UIImage imageNamed:@"lower_marketing_ad_image.png"];
////}
//
//#pragma mark - KDCycleBannerViewDelegate
//
//- (void)cycleBannerView:(KDCycleSplitBannerView *)bannerView didScrollToIndex:(NSUInteger)index {
//    NSLog(@"didScrollToIndex:%ld", (long)index);
//}
//
//- (void)cycleBannerView:(KDCycleSplitBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
//    NSLog(@"didSelectedAtIndex:%ld", (long)index);
//    
//    
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
