//
//  APIManager.h
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject
#pragma mark - ShareInstance Method Implementation

+(id)sharedInstance;
#pragma  mark Signup Method
-(void)signupWithUsername:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)email andName:(NSString*)name andGender:(NSString*)gender inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock;
#pragma  mark Login Email Method
-(void)signinWithUsername:(NSString*)username andPassword:(NSString*)password  inController:(UIViewController*)controller withCompletionBlock:(void(^)(PFUser *user, BOOL success, NSError *error))completionBlock;
@end
