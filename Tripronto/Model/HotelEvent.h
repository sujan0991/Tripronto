//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HotelEvent : NSObject

@property  int eventId;
@property (nonatomic, strong) NSString *eventTitle;

@property  int eventTypeId;
@property (nonatomic, strong) NSString *eventTypeTitle;
@property (nonatomic, strong) NSString *eventTypeImage;

@property (strong,nonatomic) NSDate *checkin_date;
@property (strong,nonatomic) NSDate *checkout_date;
@property (nonatomic, strong) NSString *hotel_confirmation_number;
@property  float room_rate;
@property  (nonatomic, strong) NSString* room_type; //Problem

@property  int hotelCityId;//pblm
@property  int hotelCountryId;//pblm
@property  int stars;
@property  int hotelZipCode;
@property  int hotelChainId;//pblm
@property (nonatomic, strong) NSString *hotelWebsite;
@property (nonatomic, strong) NSString *hotelPhone;
@property (nonatomic, strong) NSString *hotelDescription;



@end
