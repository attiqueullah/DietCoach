//
//  DataManger.h
//  SUSYNCT
//
//  Created by Attique Ullah on 09/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
typedef NS_ENUM(NSUInteger, ProgressHUDType) {
    STATUS = 1,
    SUCESS,
    ERROR,
    IMAGE,
    PROGRESS,
    INFO
};

typedef NS_ENUM(NSUInteger, QuizType) {
    QuizTypeFirst = 1,
    QuizTypeSecond = 2
};
typedef NS_ENUM(NSUInteger, QuestionType) {
    QuestionTypeFirst = 0,
    QuestionTypeSecond = 1
};
typedef NS_ENUM(NSUInteger, AnswerType) {
    AnswerTypeFirst = 0,
    AnswerTypeSecond = 1,
    AnswerTypeThird = 2,
    AnswerTypeFourth = 3
};
@interface DataManger : NSObject
@property(nonatomic,readonly)UserInfo* userData;
+(id)sharedInstance;


#pragma mark SVProgressHud
-(void)showWithStatus:(NSString*)text withType:(ProgressHUDType)type;
#pragma mak Custom Methods
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(void)checkInterneConnectivitywithCompletionBlock:(void(^)( BOOL connect))completionBlock;
-(BOOL)networkConnectivitywithCompletionBlock;
-(void)storeQuizesObject:(id)userObject;
-(NSArray*)loadUserInfo:(QuizType)type;
-(void)evaluateResults:(NSArray*)results;
-(void)goToLeaderBoard:(SWRevealViewController*)baseController;
-(void)saveUserData;
-(BOOL)loadUserInfo;
-(void)saveParseUser:(PFUser*)user;
-(void)trackPage:(NSString*)str;
-(UserInfo*)getParseQuiz:(PFUser*)obj;
-(void)hideStatus;
-(NSString*)createShortText:(NSString*)name;
-(void)storeUserInfoObject:(id)userObject;
#pragma  mark SMS TWilio Method
-(void)sendSMSViaTwilio:(NSString*)message withTo:(NSString*)to WithCompletionBlock:(void(^)(BOOL success,NSError* error))completionBlock;
@end
