//
//  QuizViewController.h
//  Diet Coach
//
//  Created by Attique Ullah on 11/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController
@property(nonatomic,strong)NSString* quiz;
@property(nonatomic,assign)QuizType quizType;
@property(nonatomic,assign)QuestionType questionType;
@property(nonatomic,strong)NSArray* questionArray;
@end
