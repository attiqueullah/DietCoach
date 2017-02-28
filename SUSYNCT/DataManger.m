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
-(void)hideStatus
{
    if ([ SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
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
-(BOOL)networkConnectivitywithCompletionBlock
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable) {
        
        return NO;
        
    }
    else if (status == ReachableViaWiFi) {
        return YES;
        
    }
    else{
        return YES;
        
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
    NSUInteger points = 0;
    for (Answers* ans in results) {
        if (ans.points==20 && !ans.isAnswered) {
            
            if (arr.count>0) {
                NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.quizType == %d) AND (SELF.questionType == %d)", ans.quizType,ans.questionType];
                NSArray *filteredArray = [arr filteredArrayUsingPredicate:namePredicate];
                if (filteredArray.count==0) {
                    ans.isAnswered = YES;
                    points = points + ans.points;
                    [arr addObject:ans];
                }
            }
            else
            {
                ans.isAnswered = YES;
                points = points + ans.points;
                [arr addObject:ans];
            }
            
        }
    }
    self.userData.quizPassed =   arr.count;
    self.userData.totalPoints =  self.userData.totalPoints + points;
    
    [self saveUserData];
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

-(void)saveParseUser:(PFUser*)user
{
    UserInfo* newUSer = [UserInfo new];
    newUSer.first_name = user[@"name"];
    newUSer.username = user.username;
    newUSer.email = user.email;
    newUSer.password = user.password;
    newUSer.gender = user[@"gender"];
    
    PFObject* quiz = user[@"quiz"];
    [quiz fetchInBackgroundWithBlock:^(PFObject* obj,NSError* error){
        newUSer.q1Attempt = [obj[@"quiz_1_attempt"] integerValue];
        newUSer.q2Attempt = [obj[@"quiz_2_attempt"] integerValue];
        newUSer.q3Attempt = [obj[@"quiz_3_attempt"] integerValue];
        newUSer.q4Attempt = [obj[@"quiz_4_attempt"] integerValue];
        newUSer.quizPassed = [obj[@"quiz_passed"] integerValue];
        newUSer.totalPoints = [obj[@"total_points"] integerValue];
        self.userData = newUSer;
        [self storeUserInfoObject:newUSer];

    }];
    
    }
-(UserInfo*)getParseQuiz:(PFUser*)obj
{
    UserInfo* newUSer = [UserInfo new];
    
    PFObject* quiz = obj[@"quiz"];
    newUSer.userId = obj;
    newUSer.first_name = obj[@"name"];
    newUSer.email = obj.email;
    newUSer.gender = obj[@"gender"];
    newUSer.q1Attempt = [quiz[@"quiz_1_attempt"] integerValue];
    newUSer.q2Attempt = [quiz[@"quiz_2_attempt"] integerValue];
    newUSer.q3Attempt = [quiz[@"quiz_3_attempt"] integerValue];
    newUSer.q4Attempt = [quiz[@"quiz_4_attempt"] integerValue];
    newUSer.quizPassed = [quiz[@"quiz_passed"] integerValue];
    newUSer.totalPoints = [quiz[@"total_points"] integerValue];

    return newUSer;
}
-(void)saveUserData
{
    [PARSEMANAGER saveUserData:self.userData];
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

-(void)trackPage:(NSString*)str
{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:str];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(NSString*)createShortText:(NSString*)name
{
    NSString* str = name;
    NSString *newStr;
    if (str.length>=2) {
        newStr =  [[str substringToIndex:2] capitalizedString];
    }
    else
    {
        newStr =  [[str substringToIndex:1] capitalizedString];
    }
    return  newStr;
}
#pragma  mark SMS TWilio Method
-(void)sendSMSViaTwilio:(NSString*)message withTo:(NSString*)to WithCompletionBlock:(void(^)(BOOL success,NSError* error))completionBlock
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            FROM_TWILIO,@"From",
                            to,@"To",
                            message,@"Body",
                            nil];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer.timeoutInterval = 30;
    [manager POST:TwilioURL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject){
        //
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization
                             JSONObjectWithData:responseObject
                             options:kNilOptions
                             error:&error];
        
        NSLog(@"message sent at: %@",dic);
        if (!error) {
            completionBlock(YES,responseObject);
        }
        else
        {
            completionBlock(NO,error);
        }
        
        
    }
          failure:^(NSURLSessionTask *operation, NSError *error){
              
          }];
    
    
}

@end
