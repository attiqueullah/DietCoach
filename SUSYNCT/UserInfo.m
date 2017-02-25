//
//  UserInfo.m
//  SmartSwipeV3
//
//  Created by Attique Ullah on 04/05/2015.
//  Copyright (c) 2015 SFS Designs. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.first_name forKey:@"first_name"];
    [encoder encodeObject:self.last_name forKey:@"last_name"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.q1Attempt] forKey:@"q1Attempt"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.q2Attempt] forKey:@"q2Attempt"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.q3Attempt] forKey:@"q3Attempt"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.q4Attempt] forKey:@"q4Attempt"];
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.quizPassed] forKey:@"quizPassed"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.totalPoints] forKey:@"totalPoints"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.totalSMS] forKey:@"totalSMS"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        //decode properties, other class vars
        self.first_name = [decoder decodeObjectForKey:@"first_name"];
        self.last_name = [decoder decodeObjectForKey:@"last_name"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        
        
        self.q1Attempt   = [[decoder decodeObjectForKey:@"q1Attempt"]   integerValue];
        self.q2Attempt   = [[decoder decodeObjectForKey:@"q2Attempt"]   integerValue];
        self.q3Attempt   = [[decoder decodeObjectForKey:@"q3Attempt"]   integerValue];
        self.q3Attempt   = [[decoder decodeObjectForKey:@"q4Attempt"]   integerValue];
        self.quizPassed  = [[decoder decodeObjectForKey:@"quizPassed"]  integerValue];
        self.totalPoints = [[decoder decodeObjectForKey:@"totalPoints"] integerValue];
        self.totalSMS = [[decoder decodeObjectForKey:@"totalSMS"] integerValue];
        
        
    }
    return self;
}

@end
