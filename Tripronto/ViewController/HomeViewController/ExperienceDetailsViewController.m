//
//  ExperienceDetailsViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/27/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "ExperienceDetailsViewController.h"

#import "Constants.h"

@interface ExperienceDetailsViewController ()

@end

@implementation ExperienceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navTitle.text=self.activityName;
    
    self.citiesForLabel.text=[NSString stringWithFormat:@"Cities for %@",self.activityName];
    self.expertInLabel.text=[NSString stringWithFormat:@"Experts in %@",self.activityName];
    
    
    [self loadActivityDetails];
    
    
    
    self.experienceViewPager.isSingle=YES;
    self.experienceViewPager.dataSource=self;
    self.experienceViewPager.userPagerDelegate=self;
    //self.experienceViewPager.delegate=self;
    
    
    self.relatedExperienceViewPager.isSingle=false;
    self.relatedExperienceViewPager.dataSource=self;
    //self.relatedExperienceViewPager.userPagerDelegate=self;
    self.relatedExperienceViewPager.delegate=self;
    
    self.citiesViewPager.isSingle=false;
    self.citiesViewPager.dataSource=self;
    //xself.citiesViewPager.userPagerDelegate=self;
    self.citiesViewPager.delegate=self;
    
    self.expertListView.effect = JT3DScrollViewEffectNone;
    
    self.expertListView.delegate = self;
    //
  
//    for (int i=0; i<=5; i++) {
//        [self createExpertView];
//    }
//    
  //  self.experienceDetailsLabel.text=@"Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum";
    
}
- (IBAction)backToPrevious:(id)sender {
    
      [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadActivityDetails
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:self.activityId forKey:@"activity_id"];
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/activities/api-get-experience-detail",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       // NSLog(@"%@ ",responseObject);
        
        self.activityDetails=[[responseObject objectForKey:@"Experience_detail"] objectAtIndex:0];
        self.activityMedia=[responseObject objectForKey:@"media"];
        self.activityCities=[responseObject objectForKey:@"cities"];
        self.similarActivity=[responseObject objectForKey:@"similar_experiences"];
        self.activityExperts=[responseObject objectForKey:@"experts"];
        
        self.experienceDetailsLabel.text= [self.activityDetails objectForKey:@"description"];
        
        
        for (int i=0; i<self.activityExperts.count; i++) {
            [self createExpertViewwithTitle:[[self.activityExperts objectAtIndex:i] objectForKey:@"name"]  image:[[self.activityExperts objectAtIndex:i] objectForKey:@"photo"] Liner:[[self.activityExperts objectAtIndex:i] objectForKey:@"one_liner"]];
        }
        
        [self.relatedExperienceViewPager reloadData];
        [self.experienceViewPager reloadData];
        [self.citiesViewPager reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
}


#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
    
    if(collectionView.tag==101)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:102];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.activityMedia objectAtIndex:indexPath.row] objectForKey:@"url"]]]];
        
        
    }else if(collectionView.tag==201)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CitiesCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:202];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.activityCities objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
        
        UIButton *activityName = (UIButton *)[cell viewWithTag:203];
        //activityName.titleLabel.text=[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"];
        [activityName setTitle:[[[self.activityCities objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
        
    }
    else if(collectionView.tag==301)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimExCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:302];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.similarActivity objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
        
        UIButton *offerName = (UIButton *)[cell viewWithTag:303];
        //offerName.titleLabel.text= [NSString stringWithFormat:@"%@ Started From %@",  [[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"title"],  [[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"price"]];
        
        [offerName setTitle:[[[self.similarActivity objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
        
    }
    
    
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if(collectionView.tag==101)
    {
        return  self.activityMedia.count;
    }else if(collectionView.tag==201)
    {
        
        return  self.activityCities.count;
    }
    else if(collectionView.tag==301)
    {
        return  self.similarActivity.count;
        
    }
    else
        return 4;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"r");
//    return CGSizeMake(50, 80 );
//}



#pragma mark - HWViewPagerDelegate
-(void)pagerDidSelectedPage:(NSInteger)selectedPage with:(NSInteger *)pagerTag{
    NSLog(@"FistViewController, SelectedPage : %@ pagerTag %d",[@(selectedPage) stringValue],(int)pagerTag);
    
    if((int)pagerTag==304)
    {
        
        ;
    }
    else if ((int)pagerTag==305)
    {
        ;
    }
    
    
}

- (void)createExpertViewwithTitle:(NSString*)name image: (NSString*) imageUrl Liner:(NSString*)liner
{
    // [self.view layoutIfNeeded];
    CGFloat width = CGRectGetWidth(self.expertListView.frame);
    CGFloat height = CGRectGetHeight(self.expertListView.frame);
    
    
    CGFloat x = self.expertListView.subviews.count * width/2+(self.expertListView.subviews.count +1)*20;
    
    //NSLog(@"width %lf with x %lf",width,x);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x-20, 0, width/2, height)];
    //view.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.0];
    view.backgroundColor=[UIColor clearColor];
    
    
    UIImageView* expertImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    //expertImageView.image=[UIImage imageNamed:@"expertPic.png"];
    [expertImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,imageUrl]]];
    expertImageView.layer.zPosition=100;
    [view addSubview:expertImageView];
    
    UIImageView* expertPicHolder=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    expertPicHolder.image=[UIImage imageNamed:@"ExpertPicHolderGrey.png"];
    expertPicHolder.layer.zPosition=101;
    [view addSubview:expertPicHolder];
    
    //NSLog(@"expert %@",expertImageView);
    
    
    UILabel *expertName=[[UILabel alloc] initWithFrame:CGRectMake(0, expertImageView.frame.size.height+10, view.frame.size.width, 30)];
    expertName.textAlignment =  UITextAlignmentCenter;
    expertName.textColor = [UIColor grayColor];
    expertName.backgroundColor = [UIColor clearColor];
    expertName.font = [UIFont fontWithName:@"AzoSans-Medium" size:15];
    expertName.text=name;
    
    [view addSubview:expertName];
    
    
    UILabel *oneLiner=[[UILabel alloc] initWithFrame:CGRectMake(0, expertImageView.frame.size.height+expertName.frame.size.height, view.frame.size.width, 30)];
    oneLiner.textAlignment =  UITextAlignmentCenter;
    oneLiner.textColor = [UIColor grayColor];
    oneLiner.backgroundColor = [UIColor clearColor];
    oneLiner.font = [UIFont fontWithName:@"AzoSans-Regular" size:14];
    oneLiner.text=liner;
    
    [view addSubview:oneLiner];
    
    view.layer.cornerRadius = 5.0;
    
    [self.expertListView addSubview:view];
    self.expertListView.contentSize = CGSizeMake(x+width/2, height);
    self.expertListView.pagingEnabled=false;
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
