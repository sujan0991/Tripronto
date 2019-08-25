//
//  DestinationSelectorViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 12/14/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "DestinationSelectorViewController.h"
#import "Airports.h"
#import "Trip.h"
#import "Summary.h"
#import "DateData.h"

@interface DestinationSelectorViewController ()
{
    
    NSDate *todayDate;
    NSDate *minDate;
    NSDate *maxDate;
    
    NSDate *dateSelected;
    NSInteger selectedIndex;

    
    NSMutableDictionary *citiesSections;
    NSMutableDictionary *searchResults;
    
    NSArray *citiesSectionTitles;
    
    NSMutableArray *tempDestinationsToAdd;
    NSMutableArray *tempDestinationsToDelete;

}

@end

@implementation DestinationSelectorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self.view layoutIfNeeded];
    
   
    [Trip sharedManager].starting_airport_id=0;
    [Trip sharedManager].starting_city_id=0;
    
    
    [self.startingPoint setTitle:@"Starting point" forState:UIControlStateNormal];
    
    
    self.destinations=[[NSMutableArray alloc] init];
    citiesSections=[[NSMutableDictionary alloc] init];
    

    
    
    self.stepView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    self.containerView.parallaxView.delegate = self;
    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    CGRect contentRect = CGRectZero;
    for (UIView *view in self.step3View.subviews) {
        
        
        contentRect = CGRectUnion(contentRect, view.frame);
       // NSLog(@"contentRect %lf",contentRect.size.height);
    }
    
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withTitle:@"Select destinations"];
    
    
    [[self.containerView.parallaxView backButton] addTarget:self
                                                     action:@selector(backButtonAction)
                                           forControlEvents:UIControlEventTouchUpInside];
    
    
    
   // NSLog(@"containerView %@",self.containerView);
    
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];
    
    self.destinationTableView.dataSource=self;
    self.destinationTableView.delegate=self;
    
   

    self.calendarManager = [JTCalendarManager new];
    self.calendarManager.delegate = self;
    
    [self createMinAndMaxDate];
    
    //    _calendarMenuView.contentRatio = .75;
    //    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    //
    
    [self.calendarManager setMenuView:self.calendarMenuView];
    [self.calendarManager setContentView:self.calendarContentView];
    [self.calendarManager setDate:todayDate];
    
    self.citiesTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    self.searchDisplayController.searchBar.delegate=self;
    
    [self loadCities];

}


-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadCities
{
        AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
        apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
        NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
        [postData setObject:@"flowdigital" forKey:@"access_key"];
    
        [apiLoginManager POST:[NSString stringWithFormat:@"%@/cities/api_get_cities_and_airports",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            
            NSMutableArray* citiesArray=[[NSMutableArray alloc] init];
            citiesArray=[responseObject objectForKey:@"cities"];
            
            NSMutableDictionary* city=[[NSMutableDictionary alloc]init];
        
            
            for (int i=0; i<citiesArray.count; i++) {
                
                city=[citiesArray objectAtIndex:i];
               
                NSString *firstSubString;
                
                
                if([[city objectForKey:@"airports"] count]>0)
                {
                    for (int j=0; j<[[city objectForKey:@"airports"] count]; j++) {
                        
                        
                        Airports *airport = [Airports new];
                        airport.cityId =  [[city objectForKey:@"id"] intValue];
                        airport.countryName = [[city objectForKey:@"country"] objectForKey:@"title"];
                        airport.cityName =  [city objectForKey:@"title"];
                        
                        airport.airportId =  [[[[city objectForKey:@"airports"] objectAtIndex:j] objectForKey:@"id"] intValue];
                        airport.name =  [[[city objectForKey:@"airports"] objectAtIndex:j] objectForKey:@"title"];
                        airport.shortCode =  [[[city objectForKey:@"airports"] objectAtIndex:j] objectForKey:@"short_code"];
                        airport.address =  [[[city objectForKey:@"airports"] objectAtIndex:j] objectForKey:@"address"];
                        
                        //[cities addObject:airport];
                        
                        firstSubString=[[airport.cityName substringToIndex:1] capitalizedString];
                        
                        NSMutableArray *contactsArray = [citiesSections objectForKey: firstSubString];
                        
                        if (contactsArray == nil) {
                            contactsArray = [[NSMutableArray alloc] init] ;
                            
                        }
                        
                        [contactsArray addObject:airport];
                        
                        [citiesSections setObject:contactsArray forKey:firstSubString];
                    }
                }
                else
                {
                    
                    Airports *airport = [Airports new];
                    airport.cityId =  [[city objectForKey:@"id"] intValue];
                    airport.countryName = [[city objectForKey:@"country"] objectForKey:@"title"];
                    airport.cityName =  [city objectForKey:@"title"];
                    
                    //[cities addObject:airport];
                    
                    firstSubString=[[airport.cityName substringToIndex:1] capitalizedString];
                    
                    NSMutableArray *contactsArray = [citiesSections objectForKey: firstSubString];
                    
                    if (contactsArray == nil) {
                        contactsArray = [[NSMutableArray alloc] init] ;
                        
                    }
                    
                    [contactsArray addObject:airport];
                    
                    [citiesSections setObject:contactsArray forKey:firstSubString];
                }
                
            }
            
            citiesSectionTitles = [[citiesSections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
            
            self.citiesTableView.dataSource=self;
            self.citiesTableView.delegate=self;
            [self.citiesTableView reloadData];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@",error);
            
        }];
}

-(void) setCornerRadius
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.stepNumberView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.stepNumberView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.stepNumberView.layer.mask = maskLayer;
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    //    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag==101)
        return self.destinations.count;
    else
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [searchResults allKeys].count;
            
        } else {
            return [citiesSectionTitles count];
        }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[searchResults allKeys] objectAtIndex:section];
        
    } else {
        return [citiesSectionTitles objectAtIndex:section];
    }

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView.tag==101)
        return 1;
    
    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        NSString *sectionTitle = [[searchResults allKeys] objectAtIndex:section];
        NSArray *sectionAnimals = [searchResults objectForKey:sectionTitle];
        return [sectionAnimals count];
        
    } else {
        
        NSString *sectionTitle = [citiesSectionTitles objectAtIndex:section];
        NSArray *sectionAnimals = [citiesSections objectForKey:sectionTitle];
        return [sectionAnimals count];
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *simpleTableIdentifier = @"Cell";
    static NSString *citiesTableIdentifier = @"CitiesCell";

    [[UITableViewCell appearance] setTintColor:[UIColor hx_colorWithHexString:@"#E03365"]];

    
    if(tableView.tag==101)
    {
        
        SelectedDestinationCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier ];
        
        if (cell == nil) {
            cell = [[SelectedDestinationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
            
        }

        cell.layer.cornerRadius = 2.0f;
        
        cell.contentView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
        [cell.contentView.layer setBorderWidth:1.0f];
        
//      cell.backgroundView=  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDownBG"]];
        
        
        Airports *airport = [Airports new];
        airport=[self.destinations objectAtIndex:indexPath.section];
        
        //UILabel *userName = (UILabel *)[cell viewWithTag:101];
        [cell.destinationName setText:[NSString stringWithFormat:@"%@, %@",airport.cityName,airport.countryName]];
        
        //UIButton *dltButton = (UIButton *)[cell viewWithTag:102];
        
        cell.deleteButton.tag=indexPath.section;
        [cell.deleteButton addTarget:self
                              action:@selector(deleteDestination:)
            forControlEvents:UIControlEventTouchUpInside];
        
//        UIButton *arrivalButton = (UIButton *)[cell viewWithTag:103];
//        UIButton *dynamicArrivalButton = arrivalButton;
//        dynamicArrivalButton.tag = indexPath.section;
//        
//        [dynamicArrivalButton addTarget:self
//                                 action:@selector(setArraivalPicker:)
//            forControlEvents:UIControlEventTouchUpInside];
        
        //UIButton *depButton = (UIButton *)[cell viewWithTag:103];
//        
//        UIButton *dynamicDepButton = depButton;
//        dynamicDepButton.tag = indexPath.section;
//
        cell.dateButton.tag=indexPath.section;
        [cell.dateButton addTarget:self
                             action:@selector(setDeparturePicker:)
                forControlEvents:UIControlEventTouchUpInside];
        
        
//        if(airport.arrivalDate)
//        {
//            UILabel *arTime = (UILabel *)[cell viewWithTag:105];
//            [arTime  setText:[self getDateFromString:airport.arrivalDate]];
//            
//            
//        }
//        else
//        {
//            UILabel *arTime = (UILabel *)[cell viewWithTag:105];
//            [arTime  setText:@"Select Date"];
//            
//        }
        NSLog(@"airport.departureDate %@",airport.departureDate);
        if(airport.departureDate)
        {
           // UILabel *depTime = (UILabel *)[cell viewWithTag:106];
           // [depTime  setText:[self getDateFromString:airport.departureDate]];
            [cell.dateButton setTitle:[self getDateFromString:airport.departureDate] forState:UIControlStateNormal];
            
        
        }
        else
        {
           // UILabel *depTime = (UILabel *)[cell viewWithTag:106];
           // [depTime  setText:@"Select Date"];
            [cell.dateButton setTitle:@"Select Date" forState:UIControlStateNormal];
            
        }
        
        return cell;
    }
    else
    {
        
        UITableViewCell *cell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:citiesTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:citiesTableIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }
        
        Airports *airport = [Airports new];
      
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSString *sectionTitle = [[searchResults allKeys] objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [searchResults objectForKey:sectionTitle];
            airport=[contactsInSection objectAtIndex:indexPath.row];
            
        } else {
            
            NSString *sectionTitle = [citiesSectionTitles objectAtIndex:indexPath.section];

            NSMutableArray *contactsInSection = [citiesSections objectForKey:sectionTitle];
            airport=[contactsInSection objectAtIndex:indexPath.row];
            
             // NSLog(@"cell %lf",cell.frame.size.width);

        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",airport.cityName,airport.countryName];
        if(airport.airportId)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@, %@",airport.name,airport.shortCode,airport.address];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",airport.cityName,airport.countryName];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
//        if(!self.isStartingPoint)
//        {
//            if(![self.destinations containsObject:airport] )
//            {
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            else
//            {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            }
//        }
//        
        return cell;
    }
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
    
    if(tableView.tag!=101)
    {
        //city data from web
        
        Airports *airport = [Airports new];
        //NSLog(@"date %@",airport.arrivalDate);
        //NSLog(@"airportId %i",airport.airportId);
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSString *sectionTitle = [[searchResults allKeys] objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [searchResults objectForKey:sectionTitle];
            airport=[contactsInSection objectAtIndex:indexPath.row];
            
        } else {
            
            NSString *sectionTitle = [citiesSectionTitles objectAtIndex:indexPath.section];
            
            NSMutableArray *contactsInSection = [citiesSections objectForKey:sectionTitle];
            airport=[contactsInSection objectAtIndex:indexPath.row];
            
            
        }
        
        NSString* selectedDestination = [NSString stringWithFormat:@"%@, %@",airport.cityName,airport.countryName];
        
        //        if(airport.airportId)
        //        {
        //            selectedDestination = [NSString stringWithFormat:@"%@ %@, %@",airport.name,airport.shortCode,airport.address];
        //        }
        //        else
        //        {
        //            selectedDestination = [NSString stringWithFormat:@"%@, %@",airport.cityName,airport.countryName];
        //        }
        
        //NSLog(@"%@",selectedDestination);
        
        if (self.isStartingPoint) {
           
            [self.startingPoint setTitle:selectedDestination forState:UIControlStateNormal];
            self.isStartingPoint=NO;
            
            [Trip sharedManager].starting_airport_id=airport.airportId;
            [Trip sharedManager].starting_city_id=airport.cityId;
            
            self.popUpView.hidden=YES;
            self.shadeView.hidden=YES;
            
            [Summary sharedManager].startingCity=[NSString stringWithFormat:@"%@, %@",airport.cityName,airport.countryName];
            
           
            
        }
        else
        {
          //  [self.destinations addObject:airport];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                [tempDestinationsToDelete addObject:airport];
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                [tempDestinationsToAdd addObject:airport];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }

            
//        
//            [UIView animateWithDuration:1.0 animations:^{
//                
//             //   self.containerView.contentSize = CGSizeMake(self.containerView.frame.size.width , self.containerView.contentSize.height+self.destinationTableView.frame.size.width*0.35);
//                self.tableViewHeight.constant= (self.destinations.count)*(self.destinationTableView.frame.size.width*0.35+10);
//                
//            } completion:^(BOOL finished) {
//                ;
//                
//            }];
//            
//            [self.destinationTableView reloadData];
            
         


        }
        
        
    }
    else
    {
        //selected destination list
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//       // [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else {
//        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
//    }
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    //this is the space
//    return 5;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return UITableViewAutomaticDimension;
//}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    
    if (tableView.tag==101)
    {
        
        return tableView.frame.size.width*0.25;
        
    }
    else
        return 50;
}


- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView.tag==101)
    {
        return nil;
    }
    
    else
    {
        tableView.sectionIndexColor= [UIColor hx_colorWithHexString:@"#E03365"];

        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            
            return [searchResults allKeys];
            
        } else {
            
            
            return citiesSectionTitles;
        }

    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView.tag==101)
    {
        return 10;
    }
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    
    if(tableView.tag==101)
    {
        return 0.0;
    } else
    {
        return 25.0;
    }
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    view.tintColor = [UIColor clearColor];
    
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    if(tableView.tag==101)
//    {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
//        [headerView setBackgroundColor:[UIColor clearColor]];
//        return headerView;
//
//    }
//    else
//    {
//        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//        [header.textLabel setTextColor:[UIColor whiteColor]];
//        
//    }
//
//}






- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
 
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       return [[searchResults allKeys] indexOfObject:title];
        
    } else {
        return [citiesSectionTitles indexOfObject:title];
        
    }

}

- (IBAction)addDestination:(UIButton*)sender {
    
    //[self.popoverTitle setText:@"Arrival airport"];
    self.todayButton.hidden=YES;
    self.resetButton.hidden=NO;
    
    tempDestinationsToAdd=[[NSMutableArray alloc] init];
    tempDestinationsToDelete=[[NSMutableArray alloc] init];
    
    
    if (sender.tag==20) {
        self.isStartingPoint=YES;
        self.footerView.hidden=YES;
        [self.popoverTitle setText:@"Select starting point"];
    }
    else
        [self.popoverTitle setText:@"Arrival airport"];
        self.footerView.hidden=NO;
    
//        [self.destinations addObject:@"Select Destination"];
//        
//    
//            [UIView animateWithDuration:1.0 animations:^{
//                
//                self.containerView.contentSize = CGSizeMake(self.containerView.frame.size.width , self.containerView.contentSize.height+60);
//
//                
//                  self.tableViewHeight.constant= (self.destinations.count)*60;                
//            } completion:^(BOOL finished) {
//                ;
//                
//            }];
//            
//    
//        [self.destinationTableView reloadData];

    
    //Open destination selector
    
    [self.citiesTableView reloadData];
    
    self.datePickerView.hidden=YES;
    
    self.citiesView.hidden=NO;
    
    self.popUpView.hidden=NO;
    self.shadeView.hidden=NO;
    
    
}

-(void)deleteDestination: (UIButton*) sender
{

    [self.destinations removeObjectAtIndex:sender.tag];
   // [self.destinations removeObjectAtIndex:indexPath.section];
    
    [UIView animateWithDuration:1.0 animations:^{
        
    //    self.containerView.contentSize = CGSizeMake(self.containerView.frame.size.width , self.containerView.contentSize.height-50);
        
   //     self.tableViewHeight.constant= (self.destinations.count)*50;
        self.tableViewHeight.constant= (self.destinations.count)*(self.destinationTableView.frame.size.width*0.25+10);
        
        
    } completion:^(BOOL finished) {
        ;
    }];

    
    [self.destinationTableView reloadData];

}


- (IBAction)checkButtonTapped:(UIButton*)sender {
    
    sender.selected=!sender.selected;
    
}

- (IBAction)oneWayAction:(UIButton*)sender {
    
      sender.selected=!sender.selected;
}


- (IBAction)closePopUp:(id)sender {
    
    self.isStartingPoint=NO;
    
    self.popUpView.hidden=YES;
    self.shadeView.hidden=YES;
    
    self.footerView.hidden=YES;
    self.todayButton.hidden=YES;
    self.resetButton.hidden=YES;
    
    [self.view endEditing:YES];
   
     [self.searchDisplayController setActive:NO animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.shadeView)
    {
        self.popUpView.hidden=YES;
        self.shadeView.hidden=YES;

        
    }
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"cityName contains[c] %@ OR name contains[c] %@ OR countryName contains[c] %@", searchText,searchText,searchText];
    
    searchResults=[[NSMutableDictionary alloc] init];
    for (int i=0; i<[citiesSectionTitles count]; i++) {
        
        
        NSMutableArray* searchedCities= [[NSMutableArray alloc] initWithArray:[[citiesSections objectForKey:[citiesSectionTitles objectAtIndex:i]] filteredArrayUsingPredicate:resultPredicate]];
        if (searchedCities.count) {
            
            [searchResults setObject:searchedCities forKey:[citiesSectionTitles objectAtIndex:i]];
        }
        
        //NSLog(@"search %@",searchedCities);
       
    }
    
   
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
   // [self.citiesTableView reloadData];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{

    NSLog(@"self.destinationTableView] %@",self.destinationTableView);
//    [self.searchDisplayController.searchResultsTableView setFrame:self.destinationTableView.frame];
//
    [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(self.destinationTableView.frame.origin.x+5, tableView.frame.origin.y, self.destinationTableView.frame.size.width-10, tableView.frame.size.height)];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:NO animated:YES];
}

- (void)setArraivalPicker:(UIButton*) sender {
    //    ESTimePicker *timePicker = [[ESTimePicker alloc] initWithDelegate:self]; // Delegate is optional
    //    [timePicker setFrame:CGRectMake(20, 150, 300, 300)];
    //    [self.view addSubview:timePicker];
    
    self.isStartingDate=NO;
    self.isArrivalDate=YES;
    selectedIndex=sender.tag;
    
    [self showDatePicker];
    // [self showClockView];
}

- (void)setDeparturePicker:(UIButton*) sender{
    
    self.isStartingDate=NO;
    self.isArrivalDate=NO;
    selectedIndex=sender.tag;
    [self showDatePicker];
}

-(void)showDatePicker
{
    self.datePickerView.hidden=NO;
    self.footerView.hidden=YES;
    self.citiesView.hidden=YES;
    
    self.todayButton.hidden=NO;
    self.resetButton.hidden=YES;
    
    self.popUpView.hidden=NO;
    self.shadeView.hidden=NO;
    
//    self.saveButton.hidden=NO;
//    self.todayButton.hidden=NO;
    
//    dateSelected=[NSDate date];
//    [self.calendarManager reload];
    
    if(self.isStartingDate)
    {
        [self.popoverTitle setText:@"Select trip start date"];
    }
    else if (self.isArrivalDate) {
       // [self.popoverTitle setText:@"Select arrival date"];
    }
    else
    {
        [self.popoverTitle setText:@"Select departure date"];
    }
    
}

-(IBAction)startingDateSelectAction:(id)sender
{
    
    self.isStartingDate=YES;
    [self showDatePicker];
}

-(IBAction)saveAction :(id)sender
{
        if(tempDestinationsToAdd.count)
            [self.destinations addObjectsFromArray:tempDestinationsToAdd];
        if(tempDestinationsToDelete.count)
            [self.destinations removeObjectsInArray:tempDestinationsToDelete];
        

        [self.destinationTableView reloadData];
        
        [UIView animateWithDuration:1.0 animations:^{
            
            //   self.containerView.contentSize = CGSizeMake(self.containerView.frame.size.width , self.containerView.contentSize.height+self.destinationTableView.frame.size.width*0.35);
            self.tableViewHeight.constant= (self.destinations.count)*(self.destinationTableView.frame.size.width*0.25+10);
            
        } completion:^(BOOL finished) {
           
            
        }];
        
        self.popUpView.hidden=YES;
        self.shadeView.hidden=YES;
        self.footerView.hidden=YES;

}



-(NSString *)getDateFromString:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
//    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor hx_colorWithHexString:@"#E03365"];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
//    // Selected date
//    else
    if(dateSelected && [_calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor hx_colorWithHexString:@"#E03365"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor hx_colorWithHexString:@"#E03365"];
        dayView.textLabel.textColor = [UIColor hx_colorWithHexString:@"#5A5A5A"];
    }
    
    //    if([self haveEventForDay:dayView.date]){
    //        dayView.dotView.hidden = NO;
    //    }
    //    else{
    //        dayView.dotView.hidden = YES;
    //    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    
    NSDate *compareDate;
    BOOL isDateSelected=YES;
    Airports *airport = [Airports new];
    
    if(self.isStartingDate)
    {
        compareDate=[NSDate date];
    }
    else if(selectedIndex==0)
    {
            if(self.startDate)
                compareDate=self.startDate;
            else
                isDateSelected=NO;
       
    }
    else if(selectedIndex>0)
    {
        airport = [self.destinations objectAtIndex:selectedIndex-1];
        
        if(airport.departureDate)
            compareDate=  airport.departureDate;
        else
            isDateSelected=NO;

    }
    
    if(isDateSelected)
    {
        if ([dayView.date compare:compareDate] == NSOrderedAscending) {
            
            NSLog(@"selected is earlier than previous");
            
            [KSToastView ks_showToast:@"Please Select a later one" duration:1.0f];
            
        } else
        {
            
            NSLog(@"dates are the same");
            
            dateSelected = dayView.date;
            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
            [UIView transitionWithView:dayView
                              duration:.3
                               options:0
                            animations:^{
                                dayView.circleView.transform = CGAffineTransformIdentity;
                                [_calendarManager reload];
                            } completion:^(BOOL finished) {
                                
                                [self afterDateSelectionAction];
                                
                            }];
            
            
            // Load the previous or next page if touch a day from another month
            
            if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date])
            {
                if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
                    [_calendarContentView loadNextPageWithAnimation];
                }
                else{
                    [_calendarContentView loadPreviousPageWithAnimation];
                }
            }
            
        }

    }
    else
    {
        [KSToastView ks_showToast:@"Please Select the previous date first" duration:2.0f];
        
        self.isStartingDate=NO;
        self.datePickerView.hidden=YES;
        self.footerView.hidden=YES;
        self.citiesView.hidden=YES;
        
        self.popUpView.hidden=YES;
        self.shadeView.hidden=YES;

    }
    
    
    
    // Animation for the circleView
}

-(void) afterDateSelectionAction
{
    if(self.isStartingDate)
    {
        if (!dateSelected) {
            [KSToastView ks_showToast:@"Please select a valid date" duration:2.0f];
        }
        else
        {
            self.startDate=dateSelected;
            [Trip sharedManager].trip_start_date=[self getDateData:dateSelected];
            [Summary sharedManager].startingDate= dateSelected ;

            [self.startingDateButton setTitle:[self getDateFromString:dateSelected] forState:UIControlStateNormal];
            
            self.isStartingDate=NO;
            self.datePickerView.hidden=YES;
            self.footerView.hidden=YES;
            self.citiesView.hidden=YES;
            
            self.popUpView.hidden=YES;
            self.shadeView.hidden=YES;
            
        }
        
    }
    else
    {
        if (!dateSelected || [[NSDate date] compare:dateSelected] != NSOrderedAscending ) {
            
            [KSToastView ks_showToast:@"Please select a valid date" duration:2.0f];
            
        }
        else
        {
            Airports *airport = [Airports new];
            
            airport = [self.destinations objectAtIndex:selectedIndex];
        
            airport.arrivalDate=dateSelected;
            airport.departureDate=dateSelected;
           
            [self.destinations replaceObjectAtIndex:selectedIndex withObject:airport];
            [self.destinationTableView reloadData];
            
         
            
            self.datePickerView.hidden=YES;
            self.footerView.hidden=YES;
            self.citiesView.hidden=YES;
            
            self.popUpView.hidden=YES;
            self.shadeView.hidden=YES;
            
        }
        
    }
}

#pragma mark - Views customization

- (void)createMinAndMaxDate
{
    todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    minDate = [_calendarManager.dateHelper addToDate:todayDate months:0];
    maxDate = [_calendarManager.dateHelper addToDate:todayDate months:24];
    
    
    
}

- (IBAction)didGoTodayTouch
{
    
    [_calendarManager setDate:todayDate];
    dateSelected=[NSDate date];
    [self.calendarManager reload];
}

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UILabel *label = [UILabel new];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"AzoSans-Medium" size:16];
    
    return label;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"AzoSans-Regular" size:14];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    //view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    view.textLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:13];
    //[UIFont fontWithName:@"AzoSans-Regular" size:15];
    
    view.circleRatio = .8;
    view.dotRatio = 1. / .9;
    
    return view;
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:minDate andEqualOrBefore:maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

//- (BOOL)haveEventForDay:(NSDate *)date
//{
//    NSString *key = [[self dateFormatter] stringFromDate:date];
//
//    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
//        return YES;
//    }
//
//    return NO;
//
//}

//- (void)createRandomEvents
//{
//    _eventsByDate = [NSMutableDictionary new];
//
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//
//        [_eventsByDate[key] addObject:randomDate];
//    }
//}
//

- (IBAction)resetButtonAction:(id)sender {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
 
    if(![Trip sharedManager].starting_city_id)
    {
        [KSToastView ks_showToast:@"Please select a starting point" duration:2.0f];
        return NO;
    }
    if(![Trip sharedManager].trip_start_date)
    {
        [KSToastView ks_showToast:@"Please select trip start date" duration:2.0f];
        return NO;
    }

    
    else if (self.destinations.count) {
        
        for (int i=0; i<self.destinations.count; i++) {
            
            
            Airports *airport = [Airports new];
            airport=[self.destinations objectAtIndex:i];
            
            if (!airport.departureDate ) {
                
            
                [KSToastView ks_showToast:@"Please select all the depart date" duration:2.0f];
               return NO;
            }
            
        }
        return YES;

    }
    else
    {
          [KSToastView ks_showToast:@"Please select at least one destination" duration:2.0f];
          return NO;
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [Trip sharedManager].are_destinations_flexible=self.checkButton.selected;
    [Trip sharedManager].isOneWay=self.oneWayButton.selected;
    
    [Trip sharedManager].cities_trips=[[NSMutableArray alloc] init];
    
    [Trip sharedManager].citiesIdsArray=[[NSMutableArray alloc] init];
    [Trip sharedManager].activityIdsArray=[[NSMutableArray alloc] init];
    [Trip sharedManager].citiesIdsForExperts=[[NSMutableArray alloc] init];
    
    
    [Summary sharedManager].destinationDetails=[[NSMutableArray alloc] init];
    [Summary sharedManager].summaryForExperts=[[NSMutableArray alloc] init];
    
    [Trip sharedManager].experts=[[NSMutableDictionary alloc] init];
    
    NSMutableArray* airportArray=[[NSMutableArray alloc] init];
    NSMutableArray* cityArray=[[NSMutableArray alloc] init];
    
    for (int i=0; i<self.destinations.count; i++) {
        
        
        Airports *airport = [Airports new];
        airport=[self.destinations objectAtIndex:i];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:airport.airportId] forKey:@"airport_id"];
        [dic setObject:[NSNumber numberWithInt:airport.cityId] forKey:@"city_id"];
        [dic setObject:airport.cityName forKey:@"cityName"];
        [dic setObject:airport.countryName forKey:@"countryName"];
        [dic setObject:airport.arrivalDate forKey:@"arrivalDate"];
        [dic setObject:airport.departureDate forKey:@"depDate"];
        
        
      
        [airportArray addObject:dic];
        [cityArray addObject:[NSNumber numberWithInt:airport.cityId]];
        
        if(i==self.destinations.count-1)
        {
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:[Summary sharedManager].startingDate
                                                                  toDate:airport.departureDate
                                                                 options:NSCalendarWrapComponents];
            
            //NSLog(@"components %ld", [components day]);
            
            [Summary sharedManager].tripDays=(int)[components day];
        }
        
    }
    
    if (airportArray.count) {
        [Trip sharedManager].citiesIdsArray=airportArray;
        [Trip sharedManager].citiesIdsForExperts=cityArray;
        
        [Summary sharedManager].numberOfPlaces= (int)airportArray.count;
        
    }
    
    
}


@end
