//
//  SummaryViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 3/7/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "SummaryViewController.h"

#import "SummaryTableViewCell.h"
#import "ExpertTableViewCell.h"

#import "Constants.h"

#import "Trip.h"
#import "Summary.h"
#import "DateData.h"


@interface SummaryViewController ()
{
    NSArray* placeHolderTexts;
}

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Trip %@ ",[Trip sharedManager].toNSDictionary);
    if([Trip sharedManager].title)
    {
        [self.navTitle setText:[Trip sharedManager].title];
    }
    else
        [self.navTitle setText:@"Summary View"];
    
    if(self.isManagable)
        self.submitButton.hidden=NO;
    else
        self.submitButton.hidden=YES;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
//    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
//    [imageView setContentMode:UIViewContentModeScaleAspectFill];
//    
//    self.containerViewForSummary.parallaxView.delegate = self;
//    
//    
//    
//    self.containerViewForSummary.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    
//    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in self.summaryView.subviews) {
//        
//        
//        contentRect = CGRectUnion(contentRect, view.frame);
//        NSLog(@"contentRect %lf",contentRect.size.height);
//    }
//    contentRect.size.height+=20;
//    
//    self.containerViewForSummary.contentSize=contentRect.size;
//    
//    [self.containerViewForSummary addParallaxWithView:imageView andHeight:200 withTitle:@"Submit the trip"];
//    
//    [[self.containerViewForSummary.parallaxView backButton] addTarget:self
//                                                     action:@selector(backButtonAction)
//                                           forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    //NSLog(@"containerView %@",self.containerView);
//    
//    
//    self.containerViewForSummary.userInteractionEnabled = YES;
//    self.containerViewForSummary.exclusiveTouch = YES;
//    self.containerViewForSummary.canCancelContentTouches = YES;
//    self.containerViewForSummary.delaysContentTouches = NO;
//    
//    [self.containerViewForSummary setContentOffset:CGPointMake(0, -200) animated:YES];
    
    

    placeHolderTexts = @[@"Date",@"Days",@"Adults",@"Kids",@"Places"];

    self.commonDataCollectionView.dataSource=self;
    self.commonDataCollectionView.delegate=self;
    
    self.destinationTableView.dataSource=self;
    self.destinationTableView.delegate=self;
    
    
    self.destinationTableView.estimatedRowHeight = 350;
    self.destinationTableView.rowHeight = UITableViewAutomaticDimension;
    
//    self.destinationTableView.estimatedRowHeight =  self.destinationTableView.frame.size.height*0.25;
//    self.destinationTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.destinationTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.commonDataCollectionView reloadData ];
    
    [self.destinationTableView reloadData];
    
}

-(IBAction)backButtonAction:(id)sender
{
    
    NSLog(@"backClicked");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)submitTrip:(id)sender {
    
    //NSLog(@"Summary %@ ",[Summary sharedManager].toNSDictionary);
    
//    [Trip sharedManager].summaryDetails=[[NSMutableDictionary alloc] init];
//    [Trip sharedManager].summaryDetails=[Summary sharedManager].toNSDictionary;
//    
   
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/trips/api-create-trip",SERVER_BASE_API_URL] parameters:[Trip sharedManager].toNSDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject %@",responseObject);
        
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            ZHPopupView *popupView = [ZHPopupView popUpDialogViewInView:nil
                                                                iconImg:[UIImage imageNamed:@"home_sel"]
                                                        backgroundStyle:ZHPopupViewBackgroundType_Blur
                                                                  title:@"Success"
                                                                content:@"Your trip has been submitted"
                                                           buttonTitles:@[@"Go to Manage Expert"]
                                                    confirmBtnTextColor:nil otherBtnTextColor:nil
                                                     buttonPressedBlock:^(NSInteger btnIdx) {
                                                         
                                                         
                                                         // Need user id in response
                                                       
                                                    
                                                         
                                                         MessageBoardViewController *msgViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MessageBoardViewController"];
                                                         
                                                         msgViewController.tripDetails=[[NSMutableDictionary alloc] init];
                                                         [msgViewController.tripDetails setObject:@"Cities" forKey:@"cities"];
                                                         [msgViewController.tripDetails setObject:[responseObject objectForKey:@"created"] forKey:@"created"];
                                                         [msgViewController.tripDetails setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[Summary sharedManager].summaryForExperts.count] forKey:@"experts"];
                                                         [msgViewController.tripDetails setObject:[NSNumber numberWithInteger:[[responseObject objectForKey:@"trip_id"] intValue]] forKey:@"trip_id"];
                                                         [msgViewController.tripDetails setObject:[Trip sharedManager].title forKey:@"trip_title"];
                                                         
//                                                         
//                                                         NSError *error;
//                                                         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[Summary sharedManager].toNSDictionary
//                                                                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                                                                              error:&error];
//                                                         
//                                                         if (! jsonData) {
//                                                             NSLog(@"Got an error: %@", error);
//                                                         } else {
//                                                             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                                                         }
                                                         
                                                        [msgViewController.tripDetails setObject:[Summary sharedManager].toNSDictionary forKey:@"summaryData"];
                                                         
                                                         
                                                         msgViewController.selectedTabIndex=2;
                                                         msgViewController.isPastTrip=NO;
                                                         

                                                         [self.navigationController pushViewController:msgViewController animated:NO];

                                                         
                                                         
                                                         
                                                     }];
            [popupView present];

        }
        
        
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
    if([Summary sharedManager].summaryForExperts.count)
        return [Summary sharedManager].numberOfPlaces+1;
    else
        return [Summary sharedManager].numberOfPlaces;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier;
   
    
    if(indexPath.row==[Summary sharedManager].numberOfPlaces)
    {
        simpleTableIdentifier = @"ExpertCell";
        
        ExpertTableViewCell *cell = (ExpertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        cell.layer.cornerRadius = 2.0f;
      
        cell.expertData=[[NSMutableArray alloc] init];
        

        cell.expertData=[Summary sharedManager].summaryForExperts;
        
        
//        NSMutableArray* tempArray=[[NSMutableArray alloc]init];
//        [tempArray addObject:@"Lorem"];
//        [tempArray addObject:@"Ipsum"];
//        
//        cell.expertData=tempArray;
        NSLog(@"cell.expertData %@",cell.expertData);
        [cell.expertsTableView reloadData];
        
        CGFloat tableHeight = cell.expertsTableView.contentSize.height;
        CGFloat nameViewHeight = cell.expertHeaderView.frame.size.height;
        
        cell.expertViewHeightConstraint.constant = tableHeight+nameViewHeight;
        
        [cell layoutIfNeeded];

        
        return cell;

    }
    else
    {
        NSLog(@"not in row 2");

        simpleTableIdentifier = @"DestinationCell";
        
        SummaryTableViewCell *cell = (SummaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        cell.layer.cornerRadius = 2.0f;
        
        cell.destinationData=[[NSMutableDictionary alloc] init];
        
//        NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]init];
//        [tempDictionary setObject:@"(Self Arranged)" forKey:@"flight"];
//        [tempDictionary setObject:@"flexible" forKey:@"date"];
//        [tempDictionary setObject:@"(Self Arranged)" forKey:@"accommodation"];
//        [tempDictionary setObject:@"(Self Arranged)" forKey:@"activity"];
//        
//        cell.destinationData=tempDictionary;
//        
       // NSLog(@"self.destinationData= %@",[[Summary sharedManager].destinationDetails objectAtIndex:indexPath.row]);
        

       
        cell.destinationData=[[Summary sharedManager].destinationDetails objectAtIndex:indexPath.row];
        [cell.titleLabel setText:[[[Summary sharedManager].destinationDetails objectAtIndex:indexPath.row] objectForKey:@"destinationName"]];
        
        
        CGFloat tableHeight = cell.detailsTableView.contentSize.height;
        CGFloat nameViewHeight = cell.nameView.frame.size.height;
        
        cell.destinationViewHeightConstant.constant = tableHeight+nameViewHeight;
        
        [cell layoutIfNeeded];
        
        
 

        
        [cell.detailsTableView reloadData];
        //[cell adjustHeightOfTableview];
        
        
        if(self.isManagable)
        {
            cell.editButton.hidden=NO;
        }else
            cell.editButton.hidden=YES;
        
        cell.editButton.tag=indexPath.row;
        [cell.editButton addTarget:self
                            action:@selector(editPreference:)
            forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    
 
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
    
    
    //    cell.layer.borderWidth = 1.0f;
    //    cell.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    //
    
    //    UILabel *userName = (UILabel *)[cell viewWithTag:101];
    //    UIButton *dltButton = (UIButton *)[cell viewWithTag:102];
    //
    
    //   cell.backgroundView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownBG"]];
    
    //    [userName setText:[self.locationList objectAtIndex:indexPath.section]];
    //    [dltButton addTarget:self
    //                  action:@selector(deleteLocation)
    //        forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //[dltButton performSelector:@selector(deleteDestination) withObject:indexPath];
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    //this is the space
//    return 5;
//}

//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
//{
//    if(indexPath.row==[Summary sharedManager].numberOfPlaces)
//    {
//
//        
//        NSMutableArray *expertData=[[NSMutableArray alloc] init];
//        expertData=[Summary sharedManager].summaryForExperts;
//        
//        NSLog(@"expertData %lu",(unsigned long)expertData.count);
//        return expertData.count*80+85;
//    
//    }
//   
//    else
//        return 350;
//}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 80.0;
}



- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat filterWidth=65;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 5, tableView.bounds.size.width-40, 70)];

    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    [headerView addSubview:scrollView];
    
    NSMutableArray* destinations=[[NSMutableArray alloc] init];
  
    [destinations addObject:[self getCityFromFullString:[Summary sharedManager].startingCity]];
   // NSLog(@"destinations %@",destinations);
   
    for (int i=1; i<= [Summary sharedManager].numberOfPlaces; i++) {
        
        if([[[[Summary sharedManager].destinationDetails objectAtIndex:i-1] objectForKey:@"destinationName"] containsString:@","])
            [destinations addObject: [self getCityFromFullString:[[[Summary sharedManager].destinationDetails objectAtIndex:i-1] objectForKey:@"destinationName"]]];
        else
            [destinations addObject: [[[Summary sharedManager].destinationDetails objectAtIndex:i-1] objectForKey:@"destinationName"]];
    }
    //NSLog(@"destinations after %@",destinations);
    if (![Trip sharedManager].isOneWay) {
    [destinations addObject:[self getCityFromFullString:[Summary sharedManager].startingCity]];
        
    }
    //  NSLog(@"destinations after after %@",destinations);
    
    if(([UIScreen mainScreen].bounds.size.width-40)>filterWidth*destinations.count)
    {
        filterWidth=  ([UIScreen mainScreen].bounds.size.width-40)/destinations.count;
        
    }
    
  //  [Summary sharedManager]
    SEFilterControl *filter = [[SEFilterControl alloc]initWithFrame:CGRectMake(0, 0, filterWidth*destinations.count, 70) titles:destinations];
    [scrollView addSubview:filter];
    
    [filter setProgressColor:[UIColor grayColor]];
//    filter.handler.shadowColor=[UIColor clearColor];
    filter.handler.handlerColor = [UIColor hx_colorWithHexString:@"#E03365"];
    filter.handler.circleColor = [UIColor whiteColor];

    [filter setTitlesFont:[UIFont fontWithName:@"AzoSans-Regular" size:12]];

    [filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];

    scrollView.contentSize = CGSizeMake(filterWidth*destinations.count, scrollView.frame.size.height);
    
    return headerView;
}

-(void)filterValueChanged:(SEFilterControl *) sender{
    NSLog(@"filterValueChanged %@", [NSString stringWithFormat:@"%ld", (long)sender.selectedIndex]);
    
    if(sender.selectedIndex>0 && sender.selectedIndex<=[Summary sharedManager].numberOfPlaces)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.selectedIndex-1 inSection:0];
        [self.destinationTableView scrollToRowAtIndexPath:indexPath
                                         atScrollPosition:UITableViewScrollPositionTop
                                                 animated:YES];

    }
    else
    {
        [self.destinationTableView setContentOffset:CGPointZero animated:YES];

    }
    
}



#pragma mark collectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userBg.png"]];
    
    
    NSString* valueDataString, *dateMonth;
    
    UILabel *valueLabel = (UILabel *)[cell viewWithTag:101];

    
    if(indexPath.row==1)
    {
        dateMonth=@" ";
        valueDataString=[NSString stringWithFormat:@"%i",[Summary sharedManager].tripDays];
        cell.contentView.backgroundColor=[UIColor clearColor];
        valueLabel.textColor=[UIColor hx_colorWithHexString:@"#5A5A5a"];

    }
    else  if(indexPath.row==2)
    {
        dateMonth=@" ";
        valueDataString=[NSString stringWithFormat:@"%i",[Summary sharedManager].totalAdults];
        cell.contentView.backgroundColor=[UIColor clearColor];
        valueLabel.textColor=[UIColor hx_colorWithHexString:@"#5A5A5a"];

        
    }
    
    else  if(indexPath.row==3)
    {
        dateMonth=@" ";
        valueDataString=[NSString stringWithFormat:@"%i",[Summary sharedManager].totalChilds];
        cell.contentView.backgroundColor=[UIColor clearColor];
        valueLabel.textColor=[UIColor hx_colorWithHexString:@"#5A5A5a"];

    }
    else  if(indexPath.row==4)
    {
        dateMonth=@" ";
        valueDataString=[NSString stringWithFormat:@"%i",[Summary sharedManager].numberOfPlaces];
        cell.contentView.backgroundColor=[UIColor clearColor];
        valueLabel.textColor=[UIColor hx_colorWithHexString:@"#5A5A5a"];

    }
    else  if(indexPath.row==0)
    {
        
//        int monthNumber =[[[[[Trip sharedManager].cities_trips objectAtIndex:0] objectForKey:@"departure_date"] objectForKey:@"month"] intValue];
//        
//        //int monthNumber =[[[[[Trip sharedManager].cities_trips objectAtIndex:0] objectForKey:@"departure_date"] objectForKey:@"month"] intValue];
//        
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        NSString *monthName = [[df monthSymbols] objectAtIndex:(monthNumber-1)];
//        NSLog(@" monthName %@",monthName);
        
        dateMonth=[[self getMonthFromString:[Summary sharedManager].startingDate] uppercaseString];
        
        valueDataString=[NSString stringWithFormat:@"%@",[self getDayFromString: [Summary sharedManager].startingDate]];
        cell.contentView.backgroundColor=[UIColor hx_colorWithHexString:@"#E03365"];
        valueLabel.textColor=[UIColor whiteColor];
    }

    
    
    UIFont *boldFont = [UIFont fontWithName:@"AzoSans-Regular" size:26];
    NSDictionary *boldDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",valueDataString] attributes: boldDict];
    
    UIFont *regularFont = [UIFont fontWithName:@"AzoSans-Regular" size:12];
    NSDictionary *regularDict = [NSDictionary dictionaryWithObject:regularFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[placeHolderTexts objectAtIndex:indexPath.row]] attributes:regularDict];
    
    
    
    NSMutableAttributedString *dateAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",dateMonth] attributes: regularDict];
        
        
    [aAttrString appendAttributedString:vAttrString];
    [dateAttrString appendAttributedString:aAttrString];
        
    [valueLabel setAttributedText:dateAttrString];





    //    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    //    lpgr.minimumPressDuration = 1.0f;
    //    lpgr.allowableMovement = 100.0f;
    //
    //    [cell addGestureRecognizer:lpgr];
    
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width-15)*0.20, collectionView.bounds.size.height );
}

-(NSMutableDictionary*) getDateData: (NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    
    DateData* dateFormat=[DateData new];
    
    dateFormat.day= (int)[components day];
    dateFormat.month= (int)[components month];
    dateFormat.year= (int)[components year];
    dateFormat.hour= 0;
    dateFormat.minute= 0;
    
    return [dateFormat toNSDictionary];
}

-(NSString *)getMonthFromString:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}


-(NSString *)getDayFromString:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

-(NSString*) getCityFromFullString: (NSString*) name
{
    NSString *cityName;
    NSRange range = [name rangeOfString:@","];
    cityName=[name substringToIndex:range.location];;
    return cityName;
}

-(void)editPreference :(UIButton *)sender
{

    NSLog(@"button tag %ld",(long)sender.tag);
   
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:sender.tag] forKey:@"currentCityIndex"];

}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
   
    NSLog(@"moving to destinationInfo");
//    
//    
//    if ([identifier isEqualToString:@"sendToPreference"])
//    {
//        return YES;
//        
//        
//    }else
        return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    DestinationInfoViewController *userViewController = [segue destinationViewController];
    userViewController.isFromSummary = YES;
    
}


@end
