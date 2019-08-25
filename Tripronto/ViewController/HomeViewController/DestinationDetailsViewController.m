//
//  DestinationDetailsViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/27/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "DestinationDetailsViewController.h"

#import "Constants.h"

@interface DestinationDetailsViewController ()
{
    NSLayoutManager *layoutManager;
    NSTextContainer *textContainer;
    NSTextStorage *textStorage;
}

@end

@implementation DestinationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDetails];
    
    self.navTitle.text=self.cityName;
    
    self.experienceInLabel.text=[NSString stringWithFormat:@"Experience in %@",self.cityName];
    self.offerInLabel.text=[NSString stringWithFormat:@"Offers in %@",self.cityName];
    self.expertInLabel.text=[NSString stringWithFormat:@"Experts in %@",self.cityName];

    
    
    
    self.destinationViewPager.isSingle=YES;
    self.destinationViewPager.dataSource=self;
    self.destinationViewPager.userPagerDelegate=self;
    //self.destinationViewPager.delegate=self;
    
    self.experienceViewPager.isSingle=false;
    self.experienceViewPager.dataSource=self;
    self.experienceViewPager.delegate=self;
    //self.experienceViewPager.userPagerDelegate=self;
    
    self.offersViewPager.isSingle=false;
    self.offersViewPager.dataSource=self;
    self.offersViewPager.delegate=self;
    //self.offersViewPager.userPagerDelegate=self;
    
    
    self.expertListView.effect = JT3DScrollViewEffectNone;
    
    self.expertListView.delegate = self;
//
    
    
    //self.descriptionLabel.text=@"Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum";
   // self.descriptionLabel.lineBreakMode=UILineBreakModeTailTruncation;
   // [self.descriptionLabel setTruncationTokenString:@"... more"];
 

//    UIFont *regularFont = [UIFont fontWithName:@"AzoSans-Regular" size:14];
//    NSDictionary *TextDict = [NSDictionary dictionaryWithObject: regularFont forKey:NSFontAttributeName];
//    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"Lorem ipsum Lorem ipsum Lorem ipsum" attributes: TextDict];
//    
//    NSLog(@"aAttrString.length %lu",(unsigned long)aAttrString.length);
//    
//  //  NSDictionary *buttonDict = [NSDictionary dictionaryWithObject:regularFont forKey:NSFontAttributeName];
//    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:@"  More.." attributes:TextDict];
//    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor hx_colorWithHexString:@"#E03365"] range:(NSMakeRange(0,vAttrString.length))];
//    
//    
//    
//    
//    [aAttrString appendAttributedString:vAttrString];
//    
//    self.descriptionLabel.attributedText=aAttrString;
//    
//    
//    self.descriptionLabel.userInteractionEnabled = YES;
//    [ self.descriptionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
//    
//    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
//    layoutManager = [[NSLayoutManager alloc] init];
//    textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
//    textStorage = [[NSTextStorage alloc] initWithAttributedString:aAttrString];
//    
//    // Configure layoutManager and textStorage
//    [layoutManager addTextContainer:textContainer];
//    [textStorage addLayoutManager:layoutManager];
//    
//    // Configure textContainer
//    textContainer.lineFragmentPadding = 0.0;
//    textContainer.lineBreakMode = self.descriptionLabel.lineBreakMode;
//    textContainer.maximumNumberOfLines = self.descriptionLabel.numberOfLines;
   // [self initializePageControl];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    textContainer.size = self.descriptionLabel.bounds.size;
//}

//- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
//{
//    CGPoint locationOfTouchInLabel = [tapGesture locationInView:tapGesture.view];
//    CGSize labelSize = tapGesture.view.bounds.size;
//    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
//    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
//                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
//    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
//                                                         locationOfTouchInLabel.y - textContainerOffset.y);
//    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
//                                                            inTextContainer:textContainer
//                                   fractionOfDistanceBetweenInsertionPoints:nil];
//    NSRange linkRange = NSMakeRange(self.descriptionLabel.text.length-7, 7); // it's better to save the range somewhere when it was originally used for marking link in attributed string
//    if (NSLocationInRange(indexOfCharacter, linkRange))
//    {
//        // Open an URL, or handle the tap on the link in any other way
//        NSLog(@"more clicked");
//    }
//        
//}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadDetails
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"flowdigital" forKey:@"access_key"];
    [postData setObject:self.cityID forKey:@"city_id"];
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/cities/api-get-destination-detail",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@ ",responseObject);
        
        self.cityDetails=[[responseObject objectForKey:@"destination_detail"] objectAtIndex:0];
        self.cityMedia=[responseObject objectForKey:@"media"];
        self.cityOffers=[responseObject objectForKey:@"offers"];
        self.cityAcitivites=[responseObject objectForKey:@"activities"];
        self.cityExperts=[responseObject objectForKey:@"experts"];
        
        
        self.descriptionLabel.text= [self.cityDetails objectForKey:@"description"];
        
        
        for (int i=0; i<self.cityExperts.count; i++) {
            [self createExpertViewwithTitle:[[self.cityExperts objectAtIndex:i] objectForKey:@"name"]  image:[[self.cityExperts objectAtIndex:i] objectForKey:@"photo"] Liner:[[self.cityExperts objectAtIndex:i] objectForKey:@"one_liner"]];
        }
        
        [self.destinationViewPager reloadData];
        [self.offersViewPager reloadData];
        [self.experienceViewPager reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
}

#pragma mark - ColelctionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
    
    if(collectionView.tag==101)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DesCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:102];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.cityMedia objectAtIndex:indexPath.row] objectForKey:@"url"]]]];
        
       
    }else if(collectionView.tag==201)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:202];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"featured_image"]]]];
        
        UIButton *activityName = (UIButton *)[cell viewWithTag:203];
        //activityName.titleLabel.text=[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"];
        [activityName setTitle:[[[self.cityAcitivites objectAtIndex:indexPath.row] objectForKey:@"title"] uppercaseString] forState:UIControlStateNormal];
        
    }
    else if(collectionView.tag==301)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OfferCell" forIndexPath:indexPath];
        UIImageView* contentView=(UIImageView* )[cell viewWithTag:302];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"image_url"]]]];
        
        UIButton *offerName = (UIButton *)[cell viewWithTag:303];
        //offerName.titleLabel.text= [NSString stringWithFormat:@"%@ Started From %@",  [[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"title"],  [[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"price"]];
        
        [offerName setTitle:[[NSString stringWithFormat:@"%@ Started From %@",  [[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"title"],  [[self.cityOffers objectAtIndex:indexPath.row] objectForKey:@"price"]] uppercaseString] forState:UIControlStateNormal];
    }

    
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //NSLog(@"%lu",(unsigned long)self.cityMedia.count);
    
    if(collectionView.tag==101)
    {
       return  self.cityMedia.count;
    }else if(collectionView.tag==201)
    {
    
       return  self.cityAcitivites.count;
    }
    else if(collectionView.tag==301)
    {
        return  self.cityOffers.count;
    
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
