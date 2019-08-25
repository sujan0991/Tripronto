//
//  InboxViewController.h
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface InboxViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *inboxTableView;



@end
