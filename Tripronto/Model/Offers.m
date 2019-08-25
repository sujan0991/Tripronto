//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "Offers.h"

@implementation Offers
#pragma mark - init
- (id)init{
    if (self = [super init]){
        
    
        
        self.offerId=@"";
        self.offerTitle=@"";
        self.expertId=@"";
        self.expertImage=@"";
        self.featuredImage=@"";
        self.city=@"";
        self.offerDetails=@"";
        self.price=@"";
        self.noOfPassengers=@"";
        self.isFeatured=@"";
        self.flightClasses=@"";
        self.noOfDays=@"";
       
        
    }
    return self;
}

@end
