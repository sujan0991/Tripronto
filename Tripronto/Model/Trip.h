//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SynthesizeSingleton.h"

#import "NSString+URLEncoding.h"


@interface Trip : NSObject

@property (nonatomic) int user_id;
@property (nonatomic, strong) NSString *userFirstName;
@property (nonatomic, strong) NSString *userLastName;
@property (nonatomic, strong) NSString *userImageName;

@property (nonatomic) int trip_type_id;
@property (nonatomic) int adults;
@property (nonatomic, strong) NSMutableArray *childs;
@property (nonatomic) int starting_city_id;
@property (nonatomic) int starting_airport_id;


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableDictionary *trip_start_date;//dictionary

@property (nonatomic) int are_destinations_flexible;
@property (nonatomic) int isOneWay;


@property (nonatomic, strong) NSMutableArray *cities_trips; // Tripcity
@property (nonatomic, strong) NSMutableDictionary *experts;//NSMutableDictionary _ids

@property (nonatomic, strong) NSMutableArray *citiesIdsArray;
@property (nonatomic, strong) NSMutableArray *activityIdsArray;
@property (nonatomic, strong) NSMutableArray *citiesIdsForExperts;

@property (nonatomic, strong) NSMutableDictionary *summaryDetails;//dictionary


+ (Trip *)sharedManager;

-(NSMutableDictionary *) toNSDictionary;


@end
