//
//  ExpertDetailsViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 6/22/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "ExpertDetailsViewController.h"
#import "ExpertDetailsTableViewCell.h"

#import "Constants.h"
#import <CoreText/CoreText.h>
#import "ResponsiveLabel.h"


@interface ExpertDetailsViewController ()

@end

@implementation ExpertDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.expertTableViewHeightConstraint.constant=0;
    
    NSLog(@"ExpertID = %d",self.selectedExpert.expertId);
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expertCoverPic.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.containerView.parallaxView.delegate = self;
    
    
    
    
    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.detailsView.subviews) {
        
        
        contentRect = CGRectUnion(contentRect, view.frame);
        // NSLog(@"contentRect %lf",contentRect.size.height);
    }
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    
    UIFont *boldFont = [UIFont fontWithName:@"AzoSans-Regular" size:20];
    NSDictionary *boldDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.selectedExpert.expertName] attributes: boldDict];
    
    UIFont *regularFont = [UIFont fontWithName:@"AzoSans-Regular" size:14];
    NSDictionary *regularDict = [NSDictionary dictionaryWithObject:regularFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.selectedExpert.oneLiner] attributes:regularDict];
    
    
    [aAttrString appendAttributedString:vAttrString];
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withAttributedTitle:aAttrString];
    
  //  [self.containerView addParallaxWithView:headerView andHeight:200 withTitle:@""];
    
    [[self.containerView.parallaxView backButton] addTarget:self
                                                     action:@selector(cLoseButtonAction)
                                           forControlEvents:UIControlEventTouchUpInside];
    
    
    //NSLog(@"containerView %@",self.containerView);
    
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];
    
    self.aboutExpartLabel.text = [NSString stringWithFormat:@"About %@",self.selectedExpert.expertName];
    
    [self loadExpertDetails];
    
    self.expertTableView.dataSource=self;
    self.expertTableView.delegate=self;

}

-(void)cLoseButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) loadExpertDetails
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    //    NSMutableArray* citiesArray=[[NSMutableArray alloc] init];
    //    [citiesArray addObject:@"2"];
    //    [citiesArray addObject:@"9"];
    //
    // NSArray* citiesArray=@[@2,@9];
    // NSArray* activityArray=@[@1];
    
    
    
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:ACCESS_KEY forKey:@"access_key"];
    [postData setObject:[NSNumber numberWithInt:self.selectedExpert.expertId] forKey:@"expert_id"];
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/users/api-get-expert_detail",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"postData %@",[responseObject objectForKey:@"expert_detail"]);
        
        
        NSMutableDictionary* expert=[[NSMutableDictionary alloc]init];
        expert=[responseObject objectForKey:@"expert_detail"];
        
        
        self.selectedExpert.agencyName=[expert objectForKey:@"agency_name"];
        self.selectedExpert.biography=[expert objectForKey:@"biography"];
        
        self.selectedExpert.cities=[[NSMutableArray alloc] init];
        self.selectedExpert.offers=[[NSMutableArray alloc] init];
        self.selectedExpert.activities=[[NSMutableArray alloc] init];
        
        
        
        NSMutableArray *tempArray=[[NSMutableArray alloc] init];
        tempArray=[expert objectForKey:@"cities"];
        
        for (int i=0; i<tempArray.count; i++) {
            
            NSMutableDictionary *singleData=[[NSMutableDictionary alloc] init];
            
            [singleData setObject:[[tempArray objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
            [singleData setObject:[[tempArray objectAtIndex:i] objectForKey:@"description"] forKey:@"description"];
            [singleData setObject:[[tempArray objectAtIndex:i] objectForKey:@"featured_image"] forKey:@"image"];
            
            [self.selectedExpert.cities addObject:singleData];
        }
        
        if (tempArray.count) {
            self.expertTableViewHeightConstraint.constant+=tempArray.count*80+85;
        }
      
        NSMutableArray *tempActivityArray=[[NSMutableArray alloc] init];
        tempActivityArray=[expert objectForKey:@"activities"];
        
        for (int i=0; i<tempActivityArray.count; i++) {
            
            NSMutableDictionary *singleData=[[NSMutableDictionary alloc] init];
            
            [singleData setObject:[[tempActivityArray objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
            [singleData setObject:[[tempActivityArray objectAtIndex:i] objectForKey:@"description"] forKey:@"description"];
            [singleData setObject:[[tempActivityArray objectAtIndex:i] objectForKey:@"featured_image"] forKey:@"image"];
            
            [self.selectedExpert.activities addObject:singleData];
        }
        
        if (tempActivityArray.count) {
            self.expertTableViewHeightConstraint.constant+=tempActivityArray.count*80+85;
        }
     
        
        
        NSMutableArray *tempOfferArray=[[NSMutableArray alloc] init];
        
        tempOfferArray=[expert objectForKey:@"offers"];
        
        for (int i=0; i<tempOfferArray.count; i++) {
            
            NSMutableDictionary *singleData=[[NSMutableDictionary alloc] init];
            
            [singleData setObject:[[tempOfferArray objectAtIndex:i] objectForKey:@"title"] forKey:@"title"];
            [singleData setObject:[[tempOfferArray objectAtIndex:i] objectForKey:@"description"] forKey:@"description"];
            [singleData setObject:[[tempOfferArray objectAtIndex:i] objectForKey:@"image_url"] forKey:@"image"];
            
            [self.selectedExpert.offers addObject:singleData];
        }
        
        if (tempOfferArray.count) {
            self.expertTableViewHeightConstraint.constant+=tempOfferArray.count*80+80;
        }


        NSString *labelText = @"We are what our thoughts have made us; so take care about what you think. Words are secondary. Thoughts live; they travel far.The issue that's occurring is that the height of the label has empty space at its top and bottom, and that the longer the string inside it is, the larger that empty space is. A single line label might have perhaps 10 pixels above and below it inside the label's frame, but a six-line string may have almost 100 pixels. I'm not able to track down where this extra space is coming from in the methods above.";
        
        //expart detail label
        
        self.expartDetailLabel.userInteractionEnabled = YES;
//        self.expartDetailLabel.text = self.selectedExpert.biography;
        self.expartDetailLabel.text = labelText;
        
        // Add collapse token
        
        
        
        self.expartDetailLabel.customTruncationEnabled = YES;
        
        PatternTapResponder moreTapped = ^(NSString *string) {
            NSLog(@"more tapped");
            
            self.expartDetailLabel.numberOfLines = 0;
            
            
            PatternTapResponder lessTapped = ^(NSString *string) {
                self.expartDetailLabel.numberOfLines = 3;
            };
            
            NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc]initWithAttributedString:self.expartDetailLabel.attributedText];
            
            [finalString appendAttributedString:[[NSAttributedString alloc] initWithString:@"...Less"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexString:@"#E03365"],
                                                                                             RLTapResponderAttributeName:lessTapped}]];
            
            if (![self.expartDetailLabel.text containsString:@"Less"]  ) {
                
                [self.expartDetailLabel setAttributedText:finalString];
            }
            
            
            
            
        };
        
        
        [self.expartDetailLabel setAttributedTruncationToken:[[NSAttributedString alloc] initWithString:@"...more"
                                                                                            attributes:@{NSFontAttributeName:self.expartDetailLabel.font,NSForegroundColorAttributeName:[UIColor hx_colorWithHexString:@"#E03365"],
                                                                                                         
                                                                                                         RLTapResponderAttributeName:moreTapped
                                                                                                         }]];
        
        
        [self.expertTableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

   
        static NSString *simpleTableIdentifier;
    
    
//    if(indexPath.row==[Summary sharedManager].numberOfPlaces)
//    {
    
    
        simpleTableIdentifier = @"DetailedCell";
        
        ExpertDetailsTableViewCell *cell = (ExpertDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        cell.layer.cornerRadius = 2.0f;
        
        cell.expertData=[[NSMutableArray alloc] init];
    
        if(indexPath.row==0)
        {
            cell.expertData=self.selectedExpert.offers;
            [cell.titleLabel setText:@"My Offers"];
            
        }
    
        else if(indexPath.row==1)
        {
            cell.expertData=self.selectedExpert.activities;
            [cell.titleLabel setText:@"I am an expert in the following experiences"];
            
        }
        else if(indexPath.row==2)
        {
            cell.expertData=self.selectedExpert.cities;
            [cell.titleLabel setText:@"I am an expert in the following destinations"];
            
        }
    
        [cell.expertsTableView reloadData];
    
        return cell;
    


    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    //this is the space
//    return 5;
//}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
  

    if(indexPath.row==0)
    {
        
        NSMutableArray *expertData=[[NSMutableArray alloc] init];
        expertData=self.selectedExpert.offers;
        
        if (expertData.count) {
                 return expertData.count*80+80;
        }
        else
            return expertData.count*80;

    }
    else if(indexPath.row==1)
    {
        
        NSMutableArray *expertData=[[NSMutableArray alloc] init];
        expertData=self.selectedExpert.activities;
        
        if (expertData.count) {
            return expertData.count*80+80;
        }
        else
            return expertData.count*80;
    }
    else if(indexPath.row==2)
    {
        
        NSMutableArray *expertData=[[NSMutableArray alloc] init];
        expertData=self.selectedExpert.cities;
        
        if (expertData.count) {
            return expertData.count*80+80;
        }
        else
            return expertData.count*80;
    }
    else
        return 0;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
