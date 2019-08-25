//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "Expert.h"

@implementation Expert

- (id)init{
    if (self = [super init]){
        
        
        // Set some defaults for the first run of the application
        
        self.itineraryNumber=0;
        self.userId=0;
        
        self.offers=[[NSMutableArray alloc] init];
        self.cities=[[NSMutableArray alloc] init];
        self.activities=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    
    [dictionary setValue:self.expertName forKey:@"expertName"];
    [dictionary setValue:[NSNumber numberWithInt:self.expertId] forKey:@"expertId"];
    //[dictionary setValue:[NSNumber numberWithInt:self.userId] forKey:@"userId"];
    
    [dictionary setObject:self.image forKey:@"image"];
    [dictionary setObject:self.relevancy forKey:@"relevancy"];
    [dictionary setObject:self.feedback forKey:@"feedback"];
    [dictionary setObject:self.oneLiner forKey:@"oneLiner"];
   
    
    if(![self.companyLogo isEqual: [NSNull null]])
    {
        [dictionary setObject:self.companyLogo forKey:@"companyLogo"];
        
    }
    if(![self.affiliationLogo isEqual: [NSNull null]])
    {
        [dictionary setObject:self.affiliationLogo forKey:@"affiliationLogo"];
        
    }
    
    
    return dictionary;
}


@end
