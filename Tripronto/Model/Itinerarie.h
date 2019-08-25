//
//  Recipe.h
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expert.h"

@interface Itinerarie : NSObject

@property  int itinerarieId;
@property  int versionNo;
@property (nonatomic, strong) Expert *expert;
@property (strong,nonatomic) NSDate *sendingDate;

@property (nonatomic, strong) NSString *itinerary_cost;
@property BOOL is_selected;
@property (nonatomic, strong) NSMutableArray* days;

-(NSMutableDictionary *) toNSDictionary;

@end
