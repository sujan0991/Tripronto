//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "Itinerarie.h"

@implementation Itinerarie

- (id)init{
    if (self = [super init]){
        
        
        // Set some defaults for the first run of the application
        
        self.itinerarieId=0;
        self.versionNo=0;
        
        self.days=[[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    

    [dictionary setValue:[NSNumber numberWithInt:self.itinerarieId] forKey:@"itinerarieId"];
    [dictionary setValue:[NSNumber numberWithInt:self.versionNo] forKey:@"versionNo"];
    
    [dictionary setValue:[NSNumber numberWithInt:self.expert.expertId] forKey:@"expertid"];
    [dictionary setObject:self.itinerary_cost forKey:@"itinerary_cost"];
    [dictionary setObject:self.days forKey:@"days"];
    
  
    
    return dictionary;
}


@end


