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
@property(nonatomic,strong)UserInfo* userData;
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
#pragma mark - StorePrincipalInfoObject Method Implementation

-(void)storeQuizesObject:(id)userObject
{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userObject];
    if ([NSUserDefaults keyExists:@"quizes"]) {
         [NSUserDefaults deleteObjectForKey:@"quizes"];
    }
     [NSUserDefaults saveObject:myEncodedObject forKey:@"quizes"];
}
#pragma mark - Load AccountInfo Method Implementation

-(NSArray*)loadUserInfo:(QuizType)type
{
    NSData *myEncodedObject = [NSUserDefaults retrieveObjectForKey:@"quizes"];
    if (myEncodedObject)
    {
        NSArray* quizes = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF.quizType == %d", type];
        NSArray *filteredArray = [quizes filteredArrayUsingPredicate:namePredicate];

        return filteredArray;
    }
    return [NSArray new];
}
-(NSArray*)loadQuizes
{
    NSData *myEncodedObject = [NSUserDefaults retrieveObjectForKey:@"quizes"];
    if (myEncodedObject)
    {
        NSArray* quizes = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
        
        return quizes;
    }
    return [NSArray new];
}
#pragma mark Store Quizes Results
-(void)evaluateResults:(NSArray*)results
{
    NSMutableArray* arr = [[self loadQuizes] mutableCopy];
    for (Answers* ans in results) {
        if (ans.points==20) {
            if (arr.count>0) {
                NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.quizType == %d) AND (SELF.questionType == %d)", ans.quizType,ans.questionType];
                NSArray *filteredArray = [arr filteredArrayUsingPredicate:namePredicate];
                if (filteredArray.count==0) {
                    [arr addObject:ans];
                }
            }
            else
            {
                [arr addObject:ans];
            }
            
        }
    }
    [self storeQuizesObject:arr];
}
-(void)goToLeaderBoard:(SWRevealViewController*)baseController
{
    UINavigationController* vc = (UINavigationController*)baseController.rearViewController;
    MenuViewController* menu = (MenuViewController*)[vc topViewController];
    [menu.tblData reloadData];
    LeaderboardViewController *frontViewController = [BOARD instantiateViewControllerWithIdentifier:NAV_MAIN];
    [baseController setFrontViewController:frontViewController animated:YES];    //sf
    [baseController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
}


-(void)saveUserData
{
    [self storeUserInfoObject:self.userData];
}
-(void)storeUserInfoObject:(id)userObject
{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userObject];
    if ([userObject isKindOfClass:[UserInfo class]]) {
        [NSUserDefaults saveObject:myEncodedObject forKey:@"userInfo"];
    }
    else
    {
        [NSUserDefaults deleteObjectForKey:@"userInfo"];
    }
}
-(BOOL)loadUserInfo
{
    NSData *myEncodedObject = [NSUserDefaults retrieveObjectForKey:@"userInfo"];
    if (myEncodedObject)
    {
        self.userData = (UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
        if (self.userData) {
            return YES;
        }
        else
            return NO;
    }
    return NO;
}
@end
