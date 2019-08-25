//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlightEvent : NSObject

@property  int eventId;
@property (nonatomic, strong) NSString *eventTitle;

@property  int eventTypeId;
@property (nonatomic, strong) NSString *eventTypeTitle;
@property (nonatomic, strong) NSString *eventTypeImage;

@property (strong,nonatomic) NSString *terminal;
@property (strong,nonatomic) NSString *travelClass;
@property (nonatomic, strong) NSString *seatNo;
@property (nonatomic, strong) NSString *airlineConfirmationNumber;
@property (nonatomic, strong) NSString *gate;
@property (nonatomic, strong) NSDate *flightTime;
@property (nonatomic, strong) NSString *flightNo;

@property (nonatomic, strong) NSString *flightTypeTitle;
@property (nonatomic, strong) NSString *flightTypeDescription;

@property (nonatomic, strong) NSString *airlineTitle;
@property (nonatomic, strong) NSString *airlineDescription;
@property (nonatomic, strong) NSString *airlineLogo;

@property (nonatomic, strong) NSString *airportTitle;
@property (nonatomic, strong) NSString *airportAddress;
@property (nonatomic, strong) NSString *airportShortCode;

@property  int cityId;//problem need details


@end
