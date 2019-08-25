//
//  ExperienceListingViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/19/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "ExperienceListingViewController.h"

#import "Activity.h"
#import "Constants.h"

@interface ExperienceListingViewController ()

@end

@implementation ExperienceListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    self.experienceBannerview.datasource = self;
//    self.experienceBannerview.delegate = self;
//    self.experienceBannerview.continuous = YES;
//    self.experienceBannerview.autoPlayTimeInterval = 5;
//    self.experienceBannerview.tag=1;
//    [self.experienceBannerview hiddenPageControl];
//    
   // [self loadData];
    
    
    [self loadActvities];
    
    self.experienceViewPager.isSingle=false;
    self.experienceViewPager.dataSource=self;
    self.experienceViewPager.delegate=self;

    
    self.experienceListingTable.delegate=self;
    self.experienceListingTable.dataSource=self;
    
    self.experienceListingTable.treeFooterView = [UIView new];
    self.experienceListingTable.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
    [self.experienceListingTable.scrollView addSubview:refreshControl];
    
    [self.experienceListingTable reloadData];
    [self.experienceListingTable setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    [self.experienceListingTable registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCityIndex"] unsignedIntegerValue]-1] forKey:@"currentCityIndex"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadActvities
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/activities/api-get-experience-listing",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.experiences=[[NSMutableArray alloc] init];
        self.experiences=[responseObject objectForKey:@"Featured_Experiences"];
        
        [self.experienceViewPager reloadData];
        
        
        NSMutableArray* categoryList=[responseObject objectForKey:@"category_list"];
        
        
        NSMutableArray *dataArray=[[NSMutableArray alloc] init];
        
        
        for (int i=0; i<categoryList.count; i++) {
            
            
            
            NSString* cateName= [[categoryList objectAtIndex:i] objectForKey:@"title"];
            
            NSMutableArray *activites=[[NSMutableArray alloc] init];
            activites=[[categoryList objectAtIndex:i] objectForKey:@"activities"];
            
            NSMutableArray *activityChildArray=[[NSMutableArray alloc] init];
            
            
            for (int j=0; j<activites.count; j++) {
                
            
            
                    
                    Activity *singleActivity=[Activity new];
                    singleActivity.activityId=[[activites objectAtIndex:j] objectForKey:@"id"];
                    singleActivity.activityName=[[activites objectAtIndex:j] objectForKey:@"title"];
                    singleActivity.featuredImage=[[activites objectAtIndex:j] objectForKey:@"featured_image"];
                    singleActivity.categoryName=cateName;
                
                    
                    RADataObject *activity = [RADataObject dataObjectWithName:singleActivity.activityName children:nil withLevel:@"3"];
                    activity.dataId=singleActivity.activityId;
                    
                    [activityChildArray addObject:activity];
                    
                    
                    
                }
                
                RADataObject *category = [RADataObject dataObjectWithName:cateName
                                                               children:activityChildArray withLevel:@"2"];
                
                [dataArray addObject:category];
                
                
            }
        
        self.data = dataArray;
        [self.experienceListingTable reloadData];
        
     
    }
     
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"error %@",error);
                      
                  }];
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
    
    RADataObject *notebook1 = [RADataObject dataObjectWithName:@"City" children:nil withLevel:@"3"];
    RADataObject *notebook2 = [RADataObject dataObjectWithName:@"Outside" children:nil withLevel:@"3"];
    
    
    RADataObject *computer = [RADataObject dataObjectWithName:@"Shopping"
                                                     children:[NSArray arrayWithObjects:notebook1, notebook2, nil] withLevel:@"1"];
    RADataObject *car = [RADataObject dataObjectWithName:@"Flying" children:nil withLevel:@"1"];
    RADataObject *bike = [RADataObject dataObjectWithName:@"Family" children:nil withLevel:@"1"];
    RADataObject *house = [RADataObject dataObjectWithName:@"Beach" children:nil withLevel:@"1"];
    RADataObject *flats = [RADataObject dataObjectWithName:@"Jumping" children:nil withLevel:@"1"];
   
    
    self.data = [NSArray arrayWithObjects: computer, car, bike, house, flats, nil];
    
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

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.experienceListingTable levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of Destination %@", [@(numberOfChildren) stringValue]];
    
    
    RATableViewCell *cell = [self.experienceListingTable dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //__weak typeof(self) weakSelf = self;
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
        ExperienceDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ExperienceDetailsViewController"];
        viewController.activityId=dataObject.dataId;
        viewController.activityName=dataObject.name;
        
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

- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
}

#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView* contentView=(UIImageView* )[cell viewWithTag:101];
    [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
    
    UIButton *activityName = (UIButton *)[cell viewWithTag:102];
    //activityName.titleLabel.text=[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"];
    [activityName setTitle:[[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
    
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.experiences.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"r");
//    return CGSizeMake(50, 80 );
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected");
    
    ExperienceDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ExperienceDetailsViewController"];
    viewController.activityId=[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"id"];
    viewController.activityName=[[self.experiences objectAtIndex:indexPath.row] objectForKey:@"title"];
    
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
//    return @[[UIImage imageNamed:@"destination.png"],
//             [UIImage imageNamed:@"destination.png"],
//             [UIImage imageNamed:@"destination.png"],
//             [UIImage imageNamed:@"destination.png"]];
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
