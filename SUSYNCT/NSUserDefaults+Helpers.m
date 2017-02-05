//
//  NSUserDefaults+Helpers.m

//
//  Created by Reejo Samuel on 8/2/13.
//  Copyright (c) 2013 Reejo Samuel | m[at]reejosamuel.com All rights reserved.
//

#import "NSUserDefaults+Helpers.h"

@implementation NSUserDefaults (Helpers)


+ (BOOL)keyExists:(NSString *)key;
{
	NSObject *object = [[self standardUserDefaults] objectForKey:key];
	if (object)
		return YES;
	return NO;
}

+ (CLLocationCoordinate2D)coordinateForKey:(NSString *)key
{
	CLLocationCoordinate2D theCoordinate = {NAN, NAN};
	
	id theObject = [[self standardUserDefaults] objectForKey:key];
	if ([theObject isKindOfClass:[NSString class]])
	{
		NSArray *theComponents = [theObject componentsSeparatedByString:@","];
		if (theComponents.count == 2)
		{
			theCoordinate.latitude = [[theComponents objectAtIndex:0] doubleValue];
			theCoordinate.longitude = [[theComponents objectAtIndex:1] doubleValue];
		}
	}
	
	return theCoordinate;
}

+ (void)setCoordinate:(CLLocationCoordinate2D)coordinate forKey:(NSString *)key
{
	NSString *coordString = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
	[[self standardUserDefaults] setObject:coordString forKey:key];
}

/* convenience method to save a given bool for a given key */
+ (void)saveBool:(BOOL)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setBool:object forKey:key];
    [defaults synchronize];
}
/* convenience method to save a given string for a given key */
+ (void)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

/* convenience method to return a string for a given key */
+ (id)retrieveObjectForKey:(NSString *)key
{
    return [[self standardUserDefaults] objectForKey:key];
}

/* convenience method to delete a value for a given key */
+ (void)deleteObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [self standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

/* convenience method to clear userdefaults for current application */
+(void)clearUserDefaults
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[self standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
