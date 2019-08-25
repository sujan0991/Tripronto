//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "Summary.h"


@interface Summary ()

DECLARE_SINGLETON_FOR_CLASS(Summary)
@property (nonatomic, retain) NSUserDefaults *userDefaults;


@end



@implementation Summary

SYNTHESIZE_SINGLETON_FOR_CLASS(Summary)
@synthesize userDefaults = _userDefaults;


#pragma mark - init
- (id)init{
    if (self = [super init]){
        
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        // Set some defaults for the first run of the application
        
        self.tripDays=0;
        self.totalAdults=0;
        self.totalChilds=0;
        self.numberOfPlaces=0;
        
        self.startingCity=@"";
        self.startingDate=nil;
        
        self.destinationDetails=[[NSMutableArray alloc] init];
        self.summaryForExperts=[[NSMutableArray alloc] init];
        
        [self.userDefaults synchronize];
        
    }
    return self;
}

#pragma mark - Trip Info


-(NSDate*)startingDate{
    return [self.userDefaults objectForKey:@"startingDate"] ;
}



- (void)setStartingDate:(NSDate *)startingDate
{
    
    [self.userDefaults setObject:startingDate forKey:@"startingDate"];
    [self.userDefaults synchronize];
}

-(NSString*)startingCity{
    return [self.userDefaults objectForKey:@"startingCity"] ;
}



- (void)setStartingCity:(NSString *)startingValue
{
    
    [self.userDefaults setObject:startingValue forKey:@"startingCity"];
    [self.userDefaults synchronize];
}

//-(NSString*)tripName{
//    return [self.userDefaults objectForKey:@"tripName"] ;
//}
//
//
//
//- (void)setTripName:(NSString *)startingValue
//{
//    
//    [self.userDefaults setObject:startingValue forKey:@"tripName"];
//    [self.userDefaults synchronize];
//}

-(int)tripDays{
    return [[self.userDefaults stringForKey:@"tripDays"] intValue];
}

- (void)setTripDays:(int)value
{
    [self.userDefaults setInteger:value forKey:@"tripDays"];
    [self.userDefaults synchronize];
}

-(int)totalAdults{
    return [[self.userDefaults stringForKey:@"totalAdults"] intValue];
}

- (void)setTotalAdults:(int)value
{
    [self.userDefaults setInteger:value forKey:@"totalAdults"];
    [self.userDefaults synchronize];
}

-(int)totalChilds{
    return [[self.userDefaults stringForKey:@"totalChilds"] intValue];
}

- (void)setTotalChilds:(int)value
{
    [self.userDefaults setInteger:value forKey:@"totalChilds"];
    [self.userDefaults synchronize];
}

-(int)numberOfPlaces{
    return [[self.userDefaults stringForKey:@"numberOfPlaces"] intValue];
}

- (void)setNumberOfPlaces:(int)value
{
    [self.userDefaults setInteger:value forKey:@"numberOfPlaces"];
    [self.userDefaults synchronize];
}



-(NSMutableArray*)destinationDetails{
    return [self.userDefaults objectForKey:@"destinationDetails"];
}

- (void)setDestinationDetails:(NSMutableArray *)destinationDetails
{
    [self.userDefaults setObject:destinationDetails forKey:@"destinationDetails"];
    [self.userDefaults synchronize];
}


-(NSMutableArray*)summaryForExperts{
    return [self.userDefaults objectForKey:@"summaryForExperts"];
}

- (void)setSummaryForExperts:(NSMutableArray *)summaryForExpertsArray
{
    [self.userDefaults setObject:summaryForExpertsArray forKey:@"summaryForExperts"];
    [self.userDefaults synchronize];
}


-(NSString *)getStringFromDate:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    // NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:[self getStringFromDate:self.startingDate] forKey:@"startingDate"];
    [dictionary setObject:self.startingCity forKey:@"startingCity"];
    //[dictionary setObject:self.tripName forKey:@"tripName"];
    
    [dictionary setValue:[NSNumber numberWithInt:self.tripDays] forKey:@"tripDays"];
    [dictionary setValue:[NSNumber numberWithInt:self.totalAdults] forKey:@"totalAdults"];
    [dictionary setValue:[NSNumber numberWithInt:self.totalChilds] forKey:@"totalChilds"];
    [dictionary setValue:[NSNumber numberWithInt:self.numberOfPlaces] forKey:@"numberOfPlaces"];

    [dictionary setObject:self.destinationDetails forKey:@"destinationDetails"];
    [dictionary setObject:self.summaryForExperts forKey:@"summaryForExperts"];
    
    return dictionary;
}


@end
