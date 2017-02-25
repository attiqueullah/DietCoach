//
//  QueryManager.m
//  SUSYNCT
//
//  Created by Attique Ullah on 14/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "QueryManager.h"
@interface QueryManager ()

@end

@implementation QueryManager
#pragma mark - ShareInstance Method Implementation
+(id)sharedInstance
{
    static QueryManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[QueryManager alloc] init];
    });
    return _sharedManager;
}
+ (instancetype)queryWithClassName:(NSString *)className
{
     __block QueryManager *query = nil;
    
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
        
             [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
             query = [super queryWithClassName:className];
             [query fromPinWithName:className];
             [query fromLocalDatastore];
            //query.cachePolicy = kPFCachePolicyNetworkElseCache;
         }
         else
         {
             [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
             query = [super queryWithClassName:className];
             [PFObject unpinAllObjectsInBackgroundWithName:className];

             //query.cachePolicy = kPFCachePolicyNetworkElseCache;
             
         }
         
     }];
    
    return query;
}
+ (instancetype)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate {
    if (!predicate) {
        return [self queryWithClassName:className];
    }
    __block QueryManager *query = nil;
    
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
             
             [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
             query = [super queryWithClassName:className predicate:predicate];
             [query fromPinWithName:className];
             [query fromLocalDatastore];
             //query.cachePolicy = kPFCachePolicyNetworkElseCache;
         }
         else
         {
             [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
             query = [super queryWithClassName:className predicate:predicate];
             [PFObject unpinAllObjectsInBackgroundWithName:className];
             
             //query.cachePolicy = kPFCachePolicyNetworkElseCache;
             
         }
         
     }];
    
    return query;
}
- (void)findObjectsInBackgroundWithBlock:(PFQueryArrayResultBlock)block
{
    [super findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [DATAMANAGER hideStatus];
            [PFObject pinAllInBackground:objects withName:self.parseClassName];
            
            block(objects,nil);
        } else {
            
            block(nil,error);
        }
    }];
}
@end
