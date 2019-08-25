//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "TripCity.h"

@implementation TripCity

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithInt:self.city_id] forKey:@"city_id"];
    [dictionary setValue:[NSNumber numberWithInt:self.airport_id] forKey:@"airport_id"];
    [dictionary setValue:self.arrival_date forKey:@"arrival_date"];
    [dictionary setValue:self.departure_date forKey:@"departure_date"];
    [dictionary setValue:[NSNumber numberWithInt:self.are_dates_flexible] forKey:@"are_dates_flexible"];
    [dictionary setValue:self.preferred_airline_class forKey:@"preferred_airline_class"];
    [dictionary setValue:self.accomodation_budget forKey:@"accomodation_budget"];
    [dictionary setValue:self.accommodation_comment forKey:@"accommodation_comment"];
    
    
    [dictionary setValue:self.accomodation_types forKey:@"accomodation_types"];
    [dictionary setValue:self.airlines forKey:@"airlines"];
   // [dictionary setValue:self.destinations forKey:@"destinations"];
    [dictionary setValue:self.destinations forKey:@"accommodation_locations"];
    [dictionary setValue:self.hotel_chains forKey:@"hotel_chains"];
    [dictionary setValue:self.hotels forKey:@"hotels"];
    [dictionary setValue:self.activities forKey:@"activities"];
    
    return dictionary;
}

@end
