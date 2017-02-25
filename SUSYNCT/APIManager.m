//
//  APIManager.m
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "APIManager.h"
#import "QueryManager.h"
@implementation APIManager
#pragma mark - ShareInstance Method Implementation
+(id)sharedInstance
{
    static APIManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[APIManager alloc] init];
    });
    return _sharedManager;
}
#pragma  mark Signup Method
-(void)signupWithUsername:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)email andName:(NSString*)name andGender:(NSString*)gender inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock

{
    controller.view.userInteractionEnabled = NO;
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
             [DATAMANAGER showWithStatus:INTERNET withType:ERROR];
             controller.view.userInteractionEnabled = YES;
             return ;
         }
         [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
         PFUser *user = [PFUser user];
         user.username = username;
         user.password = password;
         user.email = email;
         user[@"gender"] = gender;
         user[@"name"] = name;
        
         [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             controller.view.userInteractionEnabled = YES;
             if (!error) {
                 [DATAMANAGER saveParseUser:user];
                 [SVProgressHUD dismiss];
                 
                 completionBlock(user,succeeded,nil);
             } else {
                 completionBlock(user,NO,error);
             }
         }];
         
     }];
}
#pragma  mark Login Email Method
-(void)signinWithUsername:(NSString*)username andPassword:(NSString*)password  inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock
{
     controller.view.userInteractionEnabled = NO;
    [DATAMANAGER checkInterneConnectivitywithCompletionBlock:^(BOOL isavailable)
     {
         if (!isavailable) {
             [DATAMANAGER showWithStatus:INTERNET withType:ERROR];
             controller.view.userInteractionEnabled = YES;
             return ;
         }
         [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
         [PFUser logInWithUsernameInBackground:username password:password
                                         block:^(PFUser *user, NSError *error) {
                                             [SVProgressHUD dismiss];
                                             controller.view.userInteractionEnabled = YES;
                                             if (user) {
                                                 [DATAMANAGER saveParseUser:user];
                                                 [user saveInBackgroundWithBlock:nil];
                                                 completionBlock(user,YES,nil);
                                             } else {
                                                 completionBlock(nil,NO,error);
                                             }
                                             
        }];
    }];
    
}
-(void)getAllQuizWithCompletionBlock:(void(^)(NSArray *reqObj, NSError *error))completionBlock

{
    QueryManager *query = [QueryManager queryWithClassName:@"_User"];
    
    [query includeKey:@"quiz"];
    //[query orderByDescending:@"total_points"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* users = [NSMutableArray new];
            for (PFUser* user in objects) {
                
                [users addObject:[DATAMANAGER getParseQuiz:user]];
                
            }
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalPoints"
                                                         ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [users sortedArrayUsingDescriptors:sortDescriptors];
            completionBlock(sortedArray,nil);
        } else {
            
            completionBlock(nil,error);
        }
    }];
}

-(void)saveUserData:(UserInfo*)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"Quiz"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count==0) {
                PFObject* obj = [PFObject objectWithClassName:@"Quiz"];
                obj[@"user"] = [PFUser currentUser];
                obj[@"name"] = user.first_name;
                
                obj[@"quiz_1_attempt"] = [NSNumber numberWithInteger:user.q1Attempt];
                obj[@"quiz_2_attempt"] = [NSNumber numberWithInteger:user.q2Attempt];
                obj[@"quiz_3_attempt"] = [NSNumber numberWithInteger:user.q3Attempt];
                obj[@"quiz_4_attempt"] = [NSNumber numberWithInteger:user.q4Attempt];
                obj[@"quiz_passed"]    = [NSNumber numberWithInteger:user.quizPassed];
                obj[@"total_points"]    = [NSNumber numberWithInteger:user.totalPoints];
                
                [obj saveInBackgroundWithBlock:^(BOOL sucess, NSError* error){
                    [PFUser currentUser][@"quiz"] = obj;
                    [[PFUser currentUser] saveInBackground];
                }];

            }
            else
            {
                
                PFObject* obj = [objects lastObject];
                obj[@"user"] = [PFUser currentUser];
                obj[@"name"] = user.first_name;
                
                obj[@"quiz_1_attempt"] = [NSNumber numberWithInteger:user.q1Attempt];
                obj[@"quiz_2_attempt"] = [NSNumber numberWithInteger:user.q2Attempt];
                obj[@"quiz_3_attempt"] = [NSNumber numberWithInteger:user.q3Attempt];
                obj[@"quiz_4_attempt"] = [NSNumber numberWithInteger:user.q4Attempt];
                obj[@"quiz_passed"]    = [NSNumber numberWithInteger:user.quizPassed];
                obj[@"total_points"]    = [NSNumber numberWithInteger:user.totalPoints];
                
                [obj saveInBackgroundWithBlock:nil];

            }
            
        }
    }];

    }
-(void)storeParseObject:(PFObject*)obj
{
    if (ISNETWORK) {
        [obj saveInBackground];
    }
    else
    {
        [obj saveEventually];
    }
}


@end
