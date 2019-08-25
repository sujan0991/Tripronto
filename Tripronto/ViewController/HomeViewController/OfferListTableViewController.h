//
//  OfferListTableViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 3/21/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "OfferDetailsViewController.h"

@interface OfferListTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSString   *cityID;
@property (strong,nonatomic) NSString   *activtityID;


@property (weak, nonatomic) IBOutlet UITableView *offersTableView;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;


@end
