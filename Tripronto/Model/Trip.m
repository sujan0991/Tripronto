//
//  Recipe.m
//  RecipeApp
//
//  Created by Simon on 25/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "Trip.h"


@interface Trip ()

DECLARE_SINGLETON_FOR_CLASS(Trip)
@property (nonatomic, retain) NSUserDefaults *userDefaults;

@end


@implementation Trip

SYNTHESIZE_SINGLETON_FOR_CLASS(Trip)
@synthesize userDefaults = _userDefaults;


#pragma mark - init
- (id)init{
    if (self = [super init]){
        
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        // Set some defaults for the first run of the application
        
        NSLog(@"trip init called");
        
        self.trip_type_id=0;
        self.adults=0;
        self.childs=[[NSMutableArray alloc] init];
        self.starting_city_id=0;
        self.starting_airport_id=0;
        
        self.title=@"";
        self.trip_start_date=[[NSMutableDictionary alloc] init];

        self.are_destinations_flexible=0;
        self.isOneWay=0;
        
        self.cities_trips=[[NSMutableArray alloc] init];
        self.experts=[[NSMutableDictionary alloc] init];

        self.citiesIdsArray=[[NSMutableArray alloc] init];
        self.activityIdsArray=[[NSMutableArray alloc] init];
        self.citiesIdsForExperts=[[NSMutableArray alloc] init];

        self.summaryDetails=[[NSMutableDictionary alloc] init];

        [self.userDefaults synchronize];
    }
    return self;
}

-(int)user_id{
    return [[self.userDefaults stringForKey:@"user_id"] intValue];
}

- (void)setUser_id:(int)value
{
    [self.userDefaults setInteger:value forKey:@"user_id"];
    [self.userDefaults synchronize];
}

-(NSString*) userFirstName
{
    return [self.userDefaults objectForKey:@"userFirstName"];
}

- (void)setUserFirstName:(NSString *)value
{
    [self.userDefaults setObject:value forKey:@"userFirstName"];
    [self.userDefaults synchronize];
}

-(NSString*)userLastName
{
    return [self.userDefaults objectForKey:@"userLastName"];
}

- (void)setUserLastName:(NSString *)value
{
    [self.userDefaults setObject:value forKey:@"userLastName"];
    [self.userDefaults synchronize];
}

-(NSString*) userImageName
{
    return [self.userDefaults objectForKey:@"userImageName"];
}

- (void)setUserImageName:(NSString *)value
{
    [self.userDefaults setObject:value forKey:@"userImageName"];
    [self.userDefaults synchronize];
}

#pragma mark - Trip Info
-(int)trip_type_id{
    return [[self.userDefaults stringForKey:@"trip_type_id"] intValue];
}

- (void)setTrip_type_id:(int)value
{
    [self.userDefaults setInteger:value forKey:@"trip_type_id"];
    [self.userDefaults synchronize];
}

-(int)adults{
    return [[self.userDefaults stringForKey:@"adults"] intValue];
}

- (void)setAdults:(int)value
{
    [self.userDefaults setInteger:value forKey:@"adults"];
    [self.userDefaults synchronize];
}
-(NSMutableArray*)childs{
    return [self.userDefaults objectForKey:@"childs"];
}

- (void)setChilds:(NSMutableArray *)childsArray
{
    [self.userDefaults setObject:childsArray forKey:@"childs"];
    [self.userDefaults synchronize];
}

-(int)starting_city_id{
    return [[self.userDefaults stringForKey:@"starting_city_id"] intValue];
}

- (void)setStarting_city_id:(int)value
{
    [self.userDefaults setInteger:value forKey:@"starting_city_id"];
    [self.userDefaults synchronize];
}

-(int)starting_airport_id{
    return [[self.userDefaults stringForKey:@"starting_airport_id"] intValue];
}

- (void)setStarting_airport_id:(int)value
{
    [self.userDefaults setInteger:value forKey:@"starting_airport_id"];
    [self.userDefaults synchronize];
}

-(NSString*) title
{
     return [self.userDefaults objectForKey:@"title"];
}

- (void)setTitle:(NSString *)value
{
    [self.userDefaults setObject:value forKey:@"title"];
    [self.userDefaults synchronize];
}

-(NSMutableDictionary*) trip_start_date{
    return [self.userDefaults objectForKey:@"trip_start_date"];
}

- (void)setTrip_start_date:(NSMutableDictionary *)tripStartDateDictionary
{
    
    [self.userDefaults setObject:tripStartDateDictionary forKey:@"trip_start_date"];
    [self.userDefaults synchronize];
}

-(int)are_destinations_flexible{
    return [[self.userDefaults stringForKey:@"are_destinations_flexible"] intValue];
}

- (void)setAre_destinations_flexible:(int)value
{
    [self.userDefaults setInteger:value forKey:@"are_destinations_flexible"];
    [self.userDefaults synchronize];
}

-(int)isOneWay{
    return [[self.userDefaults stringForKey:@"isIsOneWay"] intValue];
}

- (void)setIsOneWay:(int)value
{
    [self.userDefaults setInteger:value forKey:@"isIsOneWay"];
    [self.userDefaults synchronize];
}


-(NSMutableDictionary*)experts{
    return [self.userDefaults objectForKey:@"experts"];
}

- (void)setExperts:(NSMutableDictionary *)expertSDictionary
{

    [self.userDefaults setObject:expertSDictionary forKey:@"experts"];
    [self.userDefaults synchronize];
}

-(NSMutableArray*)cities_trips{
    return [self.userDefaults objectForKey:@"cities_trips"];
}

- (void)setCities_trips:(NSMutableArray *)citiesDetailsArrays
{
    [self.userDefaults setObject:citiesDetailsArrays forKey:@"cities_trips"];
    [self.userDefaults synchronize];
}


-(NSMutableArray*)citiesIdsArray{
    return [self.userDefaults objectForKey:@"citiesIdsArray"];
}

- (void)setCitiesIdsArray:(NSMutableArray *)citiesDetailsArrays
{
    [self.userDefaults setObject:citiesDetailsArrays forKey:@"citiesIdsArray"];
    [self.userDefaults synchronize];
}

-(NSMutableArray*)activityIdsArray{
    return [self.userDefaults objectForKey:@"activityIdsArray"];
}

- (void)setActivityIdsArray:(NSMutableArray *)activityDetailsArrays
{
    [self.userDefaults setObject:activityDetailsArrays forKey:@"activityIdsArray"];
    [self.userDefaults synchronize];
}

-(NSMutableArray*)citiesIdsForExperts{
    return [self.userDefaults objectForKey:@"citiesIdsForExperts"];
}

- (void)setCitiesIdsForExperts:(NSMutableArray *)citiesIdsArray
{
    [self.userDefaults setObject:citiesIdsArray forKey:@"citiesIdsForExperts"];
    [self.userDefaults synchronize];
}


-(NSMutableDictionary*)summaryDetails{
    return [self.userDefaults objectForKey:@"json_summary"];
}

- (void)setSummaryDetails:(NSMutableDictionary *)summaryDictionary
{
    
    [self.userDefaults setObject:summaryDictionary forKey:@"json_summary"];
   
}


- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:@"flowdigital" forKey:@"access_key"];
    [dictionary setValue:[NSNumber numberWithInt:self.user_id] forKey:@"user_id"];
    [dictionary setValue:[NSNumber numberWithInt:self.trip_type_id] forKey:@"trip_type_id"];
    [dictionary setValue:[NSNumber numberWithInt:self.adults] forKey:@"adults"];
    [dictionary setObject:self.childs forKey:@"childs"];
    [dictionary setValue:[NSNumber numberWithInt:self.starting_city_id] forKey:@"starting_city_id"];
    [dictionary setValue:[NSNumber numberWithInt:self.starting_airport_id] forKey:@"starting_airport_id"];
    [dictionary setValue:self.title forKey:@"title"];
    [dictionary setValue:self.trip_start_date forKey:@"trip_start_date"];
    [dictionary setValue:[NSNumber numberWithInt:self.are_destinations_flexible] forKey:@"are_destinations_flexible"];
    [dictionary setValue:[NSNumber numberWithInt:self.isOneWay] forKey:@"is_one_way"];
    [dictionary setObject:self.cities_trips forKey:@"cities_trips"];
    [dictionary setObject:self.experts forKey:@"experts"];
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.summaryDetails
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    
//    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        [dictionary setObject:jsonString forKey:@"json_summary"];
//    }
    
    return dictionary;

}


@end
