//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SynthesizeSingleton.h"


@interface Summary : NSObject

@property (nonatomic, strong) NSDate *startingDate;
@property (nonatomic) int tripDays;
@property (nonatomic) int totalAdults;
@property (nonatomic) int totalChilds;
@property (nonatomic) int numberOfPlaces;

@property (nonatomic, strong) NSString *startingCity;
//@property (nonatomic, strong) NSString *tripName;

@property (nonatomic, strong) NSMutableArray *destinationDetails;
@property (nonatomic, strong) NSMutableArray *summaryForExperts;



+ (Summary *)sharedManager;

-(NSMutableDictionary *) toNSDictionary;

@end
