//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransportEvent : NSObject

@property  int eventId;
@property (nonatomic, strong) NSString *eventTitle;

@property  int eventTypeId;
@property (nonatomic, strong) NSString *eventTypeTitle;
@property (nonatomic, strong) NSString *eventTypeImage;

@property (strong,nonatomic) NSDate *pickupTime;
@property (strong,nonatomic) NSDate *dropOffTime;
@property (nonatomic, strong) NSString *inclusions;
@property (nonatomic, strong) NSString *exclusions;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *transportConfirmationNo;
@property (nonatomic, strong) NSString *driverName;

@property (nonatomic, strong) NSString *vehicleTitle;
@property (nonatomic, strong) NSString *vehicleFeaturedImage;
@property (nonatomic, strong) NSString *vehicleDescription;



@end
