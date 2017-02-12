//
//  Answers.h
//  Diet Coach
//
//  Created by Attique Ullah on 11/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answers : NSObject

@property(nonatomic,strong)NSDictionary* question;
@property(nonatomic,assign)NSUInteger points;
@property(nonatomic,assign)QuizType quizType;
@property(nonatomic,assign)QuestionType questionType;
@property(nonatomic,assign)AnswerType answerType;
@end
