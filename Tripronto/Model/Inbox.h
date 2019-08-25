//
//  Inbox.h
//  Tripronto
//
//  Created by Sujan on 10/4/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inbox : NSObject


@property  int inboxId;

@property  int senderId;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *senderImage;
@property (strong,nonatomic)  NSString *messageTime;

@property  int tripId;
@property (strong,nonatomic)  NSString *tripName;
@property (strong,nonatomic)  NSString *tripCreatedTime;

@end
