//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SummaryDestination.h"

@implementation SummaryDestination

- (id)init{
    if (self = [super init]){
        
       
        // Set some defaults for the first run of the application
        
        self.destinationName=@"Destination";
        self.airlinePreferenceString=@"(Self Arranged)";
        self.accommodationPreferenceString=@"(Self Arranged)";
        self.activityPreferenceString=@"(Self Arranged)";
        self.datePreferenceString=@"";
    }
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  
    
    
    [dictionary setObject:self.destinationName forKey:@"destinationName"];
    [dictionary setObject:self.airlinePreferenceString forKey:@"airlinePreference"];
    [dictionary setObject:self.datePreferenceString forKey:@"datePreferenceString"];
    [dictionary setObject:self.accommodationPreferenceString forKey:@"accommodationPreference"];
    [dictionary setObject:self.activityPreferenceString forKey:@"activityPreference"];
    
    
    return dictionary;
}

@end
