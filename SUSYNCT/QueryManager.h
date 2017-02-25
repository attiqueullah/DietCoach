//
//  QueryManager.h
//  SUSYNCT
//
//  Created by Attique Ullah on 14/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <Parse/Parse.h>


@interface QueryManager : PFQuery
#pragma mark - ShareInstance Method Implementation
+(id)sharedInstance;
- (void)findObjectsInBackgroundWithBlock:(PFQueryArrayResultBlock)block;
+ (instancetype)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate;
@end
