//
//  UserInfo.h
//  SmartSwipeV3
//
//  Created by Attique Ullah on 04/05/2015.
//  Copyright (c) 2015 SFS Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic,strong)NSString* first_name;
@property(nonatomic,strong)NSString* last_name;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* mobile;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,strong)NSString* confirmPassword;
@property(nonatomic)BOOL validEmail;
@property(nonatomic)BOOL validUsername;
@property(nonatomic)BOOL isAgreeTerms;
@end
