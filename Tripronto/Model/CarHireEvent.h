//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarHireEvent : NSObject

@property  int eventId;
@property (nonatomic, strong) NSString *eventTitle;

@property  int eventTypeId;
@property (nonatomic, strong) NSString *eventTypeTitle;
@property (nonatomic, strong) NSString *eventTypeImage;

@property (strong,nonatomic) NSDate *pickupTime;
@property (strong,nonatomic) NSDate *dropoffTime;
@property (nonatomic, strong) NSString *company;
@property  int boosterSeats;
@property  int infantSeats;
@property  int childSeats;
@property  int vehicleTypeId;

@property (nonatomic, strong) NSString *vehicleTitle;
@property (nonatomic, strong) NSString *vehicleImage;
@property (nonatomic, strong) NSString *vehicleDescription;

@property BOOL hasGps;


@end
