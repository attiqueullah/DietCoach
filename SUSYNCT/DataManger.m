//
//  DataManger.m
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "DataManger.h"
#import "Reachability.h"
@import UserNotifications;

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

-(void)setAvatarObject:(PFObject *)avatarObject
{
    _avatarObject = avatarObject;
}
-(void)setAvatarDate:(NSDate *)avatarDate
{
    _avatarDate = avatarDate;
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
-(BOOL)evaluateResults:(NSArray*)results
{
    NSMutableArray* arr = [[self loadQuizes] mutableCopy];
    NSUInteger points = 0;
    for (Answers* ans in results) {
        if (ans.points==25 && !ans.isAnswered) {
            
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
    
    BOOL isPassed = NO;
    if (self.userData.totalPoints == QUIZ_TOTAL) {
        [PFUser currentUser][@"test_passed"] = [NSNumber numberWithBool:YES];
        [PARSEMANAGER storeParseObject:[PFUser currentUser]];
        [DATAMANAGER configureNotifications];
        isPassed =  YES;
    }
    [self saveUserData];
    [self storeQuizesObject:arr];
    return isPassed;
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
    newUSer.startDate = user[@"login_date"];
    newUSer.submit = user[@"submit"];
    newUSer.test_passed = [user[@"test_passed"] boolValue];
    newUSer.totalMeals = [user[@"total_meals"] integerValue];
    
    
    PFObject* quiz = user[@"quiz"];
    if (quiz) {
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
    else
    {
        self.userData = newUSer;
        [self storeUserInfoObject:newUSer];
    }
   
    
    }
-(UserInfo*)getParseQuiz:(PFUser*)obj
{
    UserInfo* newUSer = [UserInfo new];
    
    PFObject* quiz = obj[@"quiz"];
    newUSer.userId = obj;
    newUSer.first_name = obj[@"name"];
    newUSer.email = obj.email;
    newUSer.gender = obj[@"gender"];
    newUSer.image = obj[@"image"];
    newUSer.q1Attempt = [quiz[@"quiz_1_attempt"] integerValue];
    newUSer.q2Attempt = [quiz[@"quiz_2_attempt"] integerValue];
    newUSer.q3Attempt = [quiz[@"quiz_3_attempt"] integerValue];
    newUSer.q4Attempt = [quiz[@"quiz_4_attempt"] integerValue];
    newUSer.quizPassed = [quiz[@"quiz_passed"] integerValue];
    newUSer.totalPoints = [quiz[@"total_points"] integerValue];

    if (obj[@"adventure"]) {
        newUSer.adventure = obj[@"adventure"];
        
        NSArray* foodArray = newUSer.adventure[@"foods"];
        int totPoints = 0;
        if (foodArray.count>0) {
            newUSer.adventurePoints = 0;
            for (int i=0; i<foodArray.count; i++) {
                NSDictionary* dic = foodArray[i];
                
                NSUInteger pt = [dic[@"value"] integerValue];
                totPoints = totPoints + (int)pt;
                
            }
            float avg = totPoints/foodArray.count;
            newUSer.adventurePoints = avg;
        }

    }
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
    
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:TwilioURL]];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:TwilioURL parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization
                             JSONObjectWithData:responseObject
                             options:kNilOptions
                             error:&error];
        
        NSLog(@"message sent at: %@",dic);
        if (!error) {
            completionBlock(YES,nil);
        }
        else
        {
            completionBlock(NO,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completionBlock(NO,error);
    }];
    
    [operation start];

       
}
#pragma mark Notifications
-(void)configureNotifications
{
    BOOL isTestPassed = [[PFUser currentUser][@"test_passed"] boolValue];
    
    if (!isTestPassed) {
        return;
    }
    NSUInteger avatarPoints = [[NSUserDefaults retrieveObjectForKey:@"total_avatar_points"] integerValue];
    if (avatarPoints ==0 && [DATAMANAGER userData].totalMeals == 0) {
        [self configureAvatrStartupNotifications];
    }
    else
    {
        [self configureAvatrAfterFeedNotifications];
    }
}
-(void)configureAvatrStartupNotifications
{
    
    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Ready for Coaching?" arguments:nil];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"Your Hero is Ready For Their First Healthy Meal." arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    
    /// 4. update application icon badge number
    objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    
    // Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:3600*3 repeats:YES];
    
    NSString* identi = @"FirstReminder";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identi
                                                                          content:objNotificationContent trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray* requests){
        if (requests.count>0) {
            
            NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.identifier CONTAINS[cd] %@)",identi];
            NSArray *filteredArray = [requests filteredArrayUsingPredicate:namePredicate];
            
            if (filteredArray.count == 0) {
                NSUInteger avatarPoints = [[NSUserDefaults retrieveObjectForKey:@"total_avatar_points"] integerValue];
                if (avatarPoints==0) {
                    [self addNotification:request];
                }
                else
                {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    [center removeDeliveredNotificationsWithIdentifiers:@[identi]];
                    [center removePendingNotificationRequestsWithIdentifiers:@[identi]];
                    [self configureAvatrAfterFeedNotifications];
                }

            }
            else
            {
                NSUInteger avatarPoints = [[NSUserDefaults retrieveObjectForKey:@"total_avatar_points"] integerValue];
                if (avatarPoints>0) {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    [center removeDeliveredNotificationsWithIdentifiers:@[identi]];
                    [center removePendingNotificationRequestsWithIdentifiers:@[identi]];
                    [self configureAvatrAfterFeedNotifications];
                }
            }
        }
        else
        {
            [self addNotification:request];
        }
    }];
    
}

-(void)configureAvatrAfterFeedNotifications
{
    
    NSString* identi = @"SecondReminder";
    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Hey Coach!" arguments:nil];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"Your Hero is Hungry. It's Time for Another Healthy Meal." arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];
    
    /// 4. update application icon badge number
    objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    
    // Deliver the notification in five seconds.
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:3600*24 repeats:YES];
    
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identi
                                                                          content:objNotificationContent trigger:trigger];
   
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray* requests){
        if (requests.count>0) {
            NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.identifier CONTAINS[cd] %@)",identi];
            NSArray *filteredArray = [requests filteredArrayUsingPredicate:namePredicate];
            if (filteredArray.count==0) {
                
                 [self addNotification:request];
            }
            
        }
        else
        {
            [self addNotification:request];
        }
       }];
    
}

-(void)addNotification:(UNNotificationRequest*)req
{
    /// 3. schedule localNotification
    [self removeAllNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:req withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Local Notification succeeded");
        }
        else {
            NSLog(@"Local Notification failed");
        }
    }];
}
-(void)removeAllNotifications
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
    
}
#pragma mark TutorialView
-(void)showTutorialForItem:(NSString*)data withController:(UIViewController*)controller WithCompletionBlock:(void(^)(BOOL success))completionBlock
{
    
    
    BOOL isShowed = NO;
    NSMutableArray *users = [[NSUserDefaults retrieveObjectForKey:data] mutableCopy];
    NSString *username = [PFUser currentUser].username;
   
    if (!users) {
        users = [NSMutableArray new];
    }
    if (users && [users containsObject:username]) {
        isShowed = YES;
    }
    
    if (!isShowed) {
        [controller.navigationController setNavigationBarHidden:YES];
        [users addObject:username];
        [NSUserDefaults saveObject:users forKey:data];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tutorial" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        NSArray* arr = [dict objectForKey:data];
        [DATAMANAGER createTutorialViewInView:controller withArray:arr WithCompletionBlock:^(BOOL isDone){
            completionBlock(YES);
        }];
    }else
    {
        completionBlock(NO);
    }
}
-(void)createTutorialViewInView:(UIViewController*)controller withArray:(NSArray*)images WithCompletionBlock:(void(^)(BOOL success))completionBlock
{
    self.returnHandler = completionBlock;
    NSMutableArray* pages = [NSMutableArray new];
    for (NSString* img in images) {
        
        EAIntroPage *page = [EAIntroPage page];
        page.bgImage = [UIImage imageNamed:img];
        [pages addObject:page];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:controller.view.bounds andPages:pages];
    [intro setDelegate:self];
    intro.pageControl.hidden = NO;
    [intro showInView:controller.view animateDuration:0.3];

}
#pragma mark - EAIntroView delegate
- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped
{
    NSLog(@"introDidFinish callback");
    self.returnHandler(YES);
}

@end
