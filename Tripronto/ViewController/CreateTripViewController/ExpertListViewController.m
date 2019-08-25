//
//  ExpertListViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 12/29/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "ExpertListViewController.h"
#import "Constants.h"
#import "Expert.h"

#import "Trip.h"
#import "Summary.h"


@interface ExpertListViewController ()
{
    
    NSMutableArray* allExperts;
    NSMutableArray* expertsIds;
    
    NSMutableArray* tempSummaryArray;
}

@end

@implementation ExpertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.expertListHeight.active=NO;
    self.expertViewRatio.active=YES;
    
    [self.view layoutIfNeeded];
    
    NSLog(@"trip %@",[Trip sharedManager].toNSDictionary);
    
    expertsIds=[[NSMutableArray alloc] init];
    
    tempSummaryArray  =[[NSMutableArray alloc] init];
    tempSummaryArray=[[Summary sharedManager].summaryForExperts mutableCopy];
    
    
    
    
    
//    NSMutableArray *navigarray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    [navigarray removeObjectAtIndex:navigarray.count-2]; //navigarray contains all vcs
//    [[self navigationController] setViewControllers:navigarray animated:YES];
//    
    
    self.filterView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
   // [self setCornerRadius];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.containerView.parallaxView.delegate = self;
    
    
    
    
    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.expertView.subviews) {
        
        
        contentRect = CGRectUnion(contentRect, view.frame);
       // NSLog(@"contentRect %lf",contentRect.size.height);
    }
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withTitle:@"Select experts"];
    
    [[self.containerView.parallaxView backButton] addTarget:self
                                                     action:@selector(backButtonAction)
                                           forControlEvents:UIControlEventTouchUpInside];
    
    
    //NSLog(@"containerView %@",self.containerView);
    
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];
    

    self.expertScrollView.effect = JT3DScrollViewEffectDepth;
    
    self.expertScrollView.delegate = self; // Use only for animate nextButton and previousButton
    
    [self loadExperts];
    
    

}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadExperts
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
//    NSMutableArray* citiesArray=[[NSMutableArray alloc] init];
//    [citiesArray addObject:@"2"];
//    [citiesArray addObject:@"9"];
//    
   // NSArray* citiesArray=@[@2,@9];
   // NSArray* activityArray=@[@1];
    
    
    NSMutableArray* activityArray= [[NSMutableArray alloc] initWithArray:[Trip sharedManager].activityIdsArray];
    
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:ACCESS_KEY forKey:@"access_key"];
    [postData setObject:[Trip sharedManager].citiesIdsForExperts forKey:@"cities"];
    [postData setObject:activityArray forKey:@"activities"];
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/experts/api-get-suggested-experts",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     //   NSLog(@"postData %@",responseObject);
        
        
        allExperts=[[NSMutableArray alloc] init];
        
        
        NSMutableArray* expertsArray=[[NSMutableArray alloc] init];
        expertsArray=[responseObject objectForKey:@"suggested_experts"];
        
        
        
        if(expertsArray.count)
        {
            self.expertListHeight.active=NO;
            self.expertViewRatio.active=YES;
            [self.resultLabel setText:[NSString stringWithFormat:@"%lu Results found",(unsigned long)expertsArray.count]];
            
        }
        else
        {
            self.expertViewRatio.active=NO;
            self.expertListHeight.constant=0;
            self.expertListHeight.active=YES;

        }
        
        NSMutableDictionary* expert=[[NSMutableDictionary alloc]init];

        for (int i=0; i<expertsArray.count; i++) {
            
            expert=[expertsArray objectAtIndex:i];

            
            Expert *singleExpert = [Expert new];
            singleExpert.expertId =  [[expert objectForKey:@"id"] intValue];
            singleExpert.expertName = [expert objectForKey:@"name"];
            singleExpert.image =  [expert objectForKey:@"pro_pic"];
            singleExpert.relevancy= [expert objectForKey:@"Relevancy"];
            singleExpert.feedback= [expert objectForKey:@"Relevancy"];
            
            singleExpert.oneLiner= [expert objectForKey:@"one_liner"];
            singleExpert.companyLogo= [expert objectForKey:@"company_logo"];
            singleExpert.affiliationLogo= [expert objectForKey:@"industry_affiliation_logo"];
            
            [allExperts addObject:singleExpert];
        }
        
        if(allExperts.count)
        {
            for (int i=0; i<allExperts.count; i++) {
                [self createCardWithColor:i];
            }
        }
        else
        {
            //self.expertScrollView.frame=CGRectMake(self.expertScrollView.frame.origin.x, self.expertScrollView.frame.origin.y, 0, 0);
            
        }
        
        self.customStoryboardPageControl.numberOfPages = allExperts.count;
        self.customStoryboardPageControl.currentPage = 0;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}


- (void)createCardWithColor:(int) index
{
    
    Expert *expertDetails = [Expert new];
    expertDetails=[allExperts objectAtIndex:index];
    
    [self.view layoutIfNeeded];
    CGFloat width = CGRectGetWidth(self.expertScrollView.frame)-20;
    CGFloat height = CGRectGetHeight(self.expertScrollView.frame);
    
    
    CGFloat x = self.expertScrollView.subviews.count * width+(self.expertScrollView.subviews.count +1)*20;
    
    //NSLog(@"width %lf with x %lf",width,x);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x-10, 0, width, height)];
    //view.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.0];
    view.backgroundColor=[UIColor clearColor];
    
    
    ExpertHolderView* expert=[[ExpertHolderView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [expert.relevancyValue setText:[[NSString stringWithFormat:@"%@",expertDetails.relevancy] uppercaseString]];
    [expert.feedbackValue setText:[[NSString stringWithFormat:@"%@",expertDetails.feedback] uppercaseString]];;
    [expert.oneLinerLabel setText:expertDetails.oneLiner];
    [expert.expertName setText:expertDetails.expertName];
    
    
    [expert.industryLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,expertDetails.affiliationLogo]]];
    [expert.companyLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,expertDetails.companyLogo]]];
    [expert.expertPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,expertDetails.image]]];
    
    
    NSArray *areas = [tempSummaryArray valueForKey:@"expertId"];
    if([areas containsObject:[NSNumber numberWithInt:expertDetails.expertId]])
    {
        expert.selectExpertButton.selected=YES;
    }else
        expert.selectExpertButton.selected=NO;
    
    expert.selectExpertButton.tag=index;
    expert.tag=index;
    [expert.selectExpertButton
     addTarget:self
     action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandlerMethod:)];
    [expert addGestureRecognizer:tapRecognizer];
    
    
    [view addSubview:expert];
    view.layer.cornerRadius = 5.0;

    
    [self.expertScrollView addSubview:view];
    self.expertScrollView.contentSize = CGSizeMake(x + width, height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    self.customStoryboardPageControl.currentPage = pageIndex;
}

- (IBAction)filterButtonTapped:(UIButton *)sender {
    
    sender.selected=!sender.selected;
}

-(void)gestureHandlerMethod:(UITapGestureRecognizer*)sender
{
    Expert *expertDetails = [Expert new];
    expertDetails=[allExperts objectAtIndex:sender.view.tag];
    
    
    ExpertDetailsViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ExpertDetailsViewController"];
    viewController.selectedExpert=expertDetails;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)selectButtonClicked: (UIButton*) sender
{
    Expert *expertDetails = [Expert new];
    expertDetails=[allExperts objectAtIndex:sender.tag];
    
    sender.selected=!sender.selected;
    if(sender.selected)
    {
        [KSToastView ks_showToast:[NSString stringWithFormat:@"Expert %@ has been seleced",expertDetails.expertName] duration:1.0f];

        
        [expertsIds addObject:[NSNumber numberWithInteger:expertDetails.expertId]];
        [tempSummaryArray addObject:expertDetails.toNSDictionary];
        
        NSLog(@"tempSummaryArray %@",tempSummaryArray);
        
    }
    else
    {
        [KSToastView ks_showToast:[NSString stringWithFormat:@"Expert %@ has been removed",expertDetails.expertName] duration:1.0f];

        
        [expertsIds removeObject:[NSNumber numberWithInteger:expertDetails.expertId]];
        [tempSummaryArray removeObject:expertDetails.toNSDictionary];
        
    }
    
    //NSLog(@"expertsIds %@",expertsIds);

}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    //    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"expertToSummary"]) {
        SummaryViewController *nextVC=  [segue destinationViewController];
        nextVC.isManagable=YES;
    }
    
    NSMutableDictionary* expertDictionary=[[NSMutableDictionary alloc] init];
    [expertDictionary setObject:expertsIds forKey:@"_ids"];
    
    [Trip sharedManager].experts=expertDictionary;
    
    [Summary sharedManager].summaryForExperts=tempSummaryArray;
    
  
    
}


@end
