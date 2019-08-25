//
//  MessageCommentTableViewCell.h
//  Tripronto
//
//  Created by Tanvir Palash on 4/20/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userMessage;
@property (weak, nonatomic) IBOutlet UILabel *messageDate;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;

@end
