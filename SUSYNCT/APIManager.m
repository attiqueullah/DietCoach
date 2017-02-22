//
//  APIManager.m
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "APIManager.h"

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
                                                 [user saveInBackgroundWithBlock:nil];
                                                 completionBlock(user,YES,nil);
                                             } else {
                                                 completionBlock(nil,NO,error);
                                             }
                                             
        }];
    }];
    
}
@end
