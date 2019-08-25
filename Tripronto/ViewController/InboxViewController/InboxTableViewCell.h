//
//  InboxTableViewCell.h
//  Tripronto
//
//  Created by Sujan on 10/4/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *senderPic;

@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
