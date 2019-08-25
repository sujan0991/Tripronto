//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "DateData.h"


@interface DateData ()
@end



@implementation DateData


- (NSMutableDictionary *)toNSDictionary
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithInt:self.hour] forKey:@"hour"];
    [dictionary setValue:[NSNumber numberWithInt:self.minute] forKey:@"minute"];
    [dictionary setValue:[NSNumber numberWithInt:self.year] forKey:@"year"];
    [dictionary setValue:[NSNumber numberWithInt:self.month] forKey:@"month"];
    [dictionary setValue:[NSNumber numberWithInt:self.day] forKey:@"day"];
    
    return dictionary;
}


@end
