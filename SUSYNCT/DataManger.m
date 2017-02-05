//
//  DataManger.m
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "DataManger.h"
#import "Reachability.h"

@interface DataManger ()
@end

@implementation DataManger

#pragma mark - ShareInstance Method Implementation
+(id)sharedInstance
{
    static DataManger *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DataManger alloc] init];
    });
    return _sharedManager;
}
- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}


#pragma mark SVProgressHud
-(void)showWithStatus:(NSString*)text withType:(ProgressHUDType)type
{
    if (type == STATUS) {
         [SVProgressHUD showWithStatus:text];
    }
   else if (type == ERROR)
   {
       [SVProgressHUD showErrorWithStatus:text];
   }
   else if (type == SUCESS)
   {
       [SVProgressHUD showSuccessWithStatus:text];
   }
   else if (type == INFO)
   {
       [SVProgressHUD showInfoWithStatus:text];
   }
}
#pragma mak Custom Methods
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
#pragma mark Check Internet Availability
-(void)checkInterneConnectivitywithCompletionBlock:(void(^)( BOOL connect))completionBlock
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        completionBlock(NO);
    }
    else if (status == ReachableViaWiFi) {
        completionBlock(YES);
    }
    else{
        completionBlock(YES);
    }
}

@end
