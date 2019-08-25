//
//  ItineraryViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 7/21/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Itinerarie.h"

#import "NSArray+NullReplacement.h"
#import "NSDictionary+NullReplacement.h"

@interface ItineraryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (strong,nonatomic) Itinerarie *singleItinerary;

@property (weak, nonatomic) IBOutlet UITableView *itineraryDayTableView;

@end
