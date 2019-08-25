//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TripCity : NSObject

@property (nonatomic) int city_id;
@property (nonatomic) int airport_id;

@property (nonatomic, strong) NSMutableDictionary *arrival_date;//dictionary
@property (nonatomic, strong) NSMutableDictionary *departure_date;

@property (nonatomic) int are_dates_flexible;
@property (nonatomic, strong) NSString *preferred_airline_class;
@property (nonatomic, strong) NSString *accomodation_budget;


@property (nonatomic, strong) NSString *additional_information;
@property (nonatomic, strong) NSString *accommodation_comment;

@property (nonatomic, strong) NSMutableDictionary *accomodation_types;//NSMutableDictionary _ids
@property (nonatomic, strong) NSMutableDictionary *airlines;//NSMutableDictionary _ids
@property (nonatomic, strong) NSMutableDictionary *destinations;;//NSMutableDictionary _ids
@property (nonatomic, strong) NSMutableDictionary *hotel_chains;;//NSMutableDictionary _ids
@property (nonatomic, strong) NSMutableDictionary *hotels;;//NSMutableDictionary _ids
@property (nonatomic, strong) NSMutableDictionary *activities;;//NSMutableDictionary _ids


-(NSMutableDictionary *) toNSDictionary;

@end
