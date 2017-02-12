//
//  Answers.m
//  Diet Coach
//
//  Created by Attique Ullah on 11/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "Answers.h"

@implementation Answers
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.question forKey:@"question"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.quizType] forKey:@"quizType"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.points] forKey:@"points"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.questionType] forKey:@"questionType"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.answerType] forKey:@"answerType"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        //decode properties, other class vars
        self.question = [decoder decodeObjectForKey:@"question"];
        
        self.quizType = (QuizType)[[decoder decodeObjectForKey:@"quizType"] integerValue];
        self.points = (QuizType)[[decoder decodeObjectForKey:@"points"] integerValue];
        self.questionType = (QuestionType)[[decoder decodeObjectForKey:@"questionType"] integerValue];
        self.answerType = (AnswerType)[[decoder decodeObjectForKey:@"answerType"] integerValue];
        
        
    }
    return self;
}

@end
