//
//  QuizViewController.m
//  Diet Coach
//
//  Created by Attique Ullah on 11/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "QuizViewController.h"
#import "ResultsViewController.h"
@interface QuizViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UIButton *option1;
@property (weak, nonatomic) IBOutlet UIButton *option2;
@property (weak, nonatomic) IBOutlet UIButton *option3;
@property (weak, nonatomic) IBOutlet UIButton *option4;
@property (nonatomic,assign)AnswerType answerType;
@property(nonatomic,strong)NSArray* quizeArray;
@property(nonatomic,strong)NSMutableArray* answersArray;
@property (weak, nonatomic) IBOutlet UIView *buttonViews;
@property(nonatomic,strong)NSDictionary* question;

@property(nonatomic,strong)Answers* answer;
@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.answer = [Answers new];
    [self getQuiz];
    self.navigationController.navigationBarHidden = YES;
    
    self.answersArray = [NSMutableArray arrayWithArray:self.questionArray];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DATAMANAGER trackPage:@"Quiz"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark GET Quiz
-(void)getQuiz
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Quiz" ofType:@"plist"];
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:path];
    self.quizeArray = dictRoot[self.quiz];
    self.question = self.quizeArray[self.questionType];
    [self loadQuestion:self.question];
}
#pragma mark Custom Methods
-(void)loadQuestion:(NSDictionary*)qst
{
    self.answer.question = qst;
    self.answer.quizType = self.quizType;
    self.answer.questionType = self.questionType;
    
    
    [self makeTextMultiline];
    self.lblQuestion.text = qst[@"question"];
    NSArray* options = qst[@"options"];
    
    [self.option1 setTitle:options[0] forState:UIControlStateNormal];
    [self.option2 setTitle:options[1] forState:UIControlStateNormal];
    [self.option3 setTitle:options[2] forState:UIControlStateNormal];
    [self.option4 setTitle:options[3] forState:UIControlStateNormal];
}
-(void)makeTextMultiline
{
    for (id vw in self.buttonViews.subviews) {
        if ([vw isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)vw;
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        }
    }
}
-(void)markAnswer:(NSUInteger)answer
{
    for (id vw in self.buttonViews.subviews) {
        if ([vw isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)vw;
            if (answer == btn.tag) {
                btn.enabled = false;
            }
            else
            {
                 btn.enabled = true;
            }
        }
    }
}
-(BOOL)isAnswerGiven
{
    BOOL answerGiven = true;
    for (id vw in self.buttonViews.subviews) {
        if ([vw isKindOfClass:[UIButton class]]) {
            UIButton* btn = (UIButton*)vw;
            
            if (btn.isEnabled) {
                answerGiven = false;
            }
            else
            {
                answerGiven = true;
                return answerGiven;
                break;
            }
        }
    }
    return answerGiven;
}
-(BOOL)checkAnswer:(AnswerType)ans
{
    if (ans == self.answer.answerType) {
        //// Correct Answer ////
        NSLog(@"Correct Answer");
        return YES;
        
    }
    else {
        //// Wrong Answer ////
        NSLog(@"Wrong Answer");
        return NO;
    }
}
-(void)updateUserData
{
    if (self.quizType==QuizTypeFirst) {
        if (self.questionType==QuestionTypeFirst) {
            [DATAMANAGER userData].q1Attempt =  [DATAMANAGER userData].q1Attempt+1;
        }
        else
        {
            [DATAMANAGER userData].q2Attempt =  [DATAMANAGER userData].q2Attempt+1;
        }
    }
    else
    {
        if (self.questionType==QuestionTypeFirst) {
            [DATAMANAGER userData].q3Attempt =  [DATAMANAGER userData].q3Attempt+1;
        }
        else
        {
            [DATAMANAGER userData].q4Attempt =  [DATAMANAGER userData].q4Attempt+1;
        }
    }
    [DATAMANAGER saveUserData];
}
#pragma mark Actions
-(IBAction)btnSelectOption:(UIButton*)sender
{
    self.answer.answerType = (AnswerType)sender.tag;
    [self markAnswer:sender.tag];
}
-(IBAction)btnDone:(id)sender
{
    if (![self isAnswerGiven]) {
        [DATAMANAGER showWithStatus:@"Please Choose Answer First" withType:ERROR];
        return;
    }
    [self.answersArray addObject:self.answer];
    if (self.questionArray.count==0) {
        QuizViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
        vc.quizType = self.quizType;
        vc.questionType = QuestionTypeSecond;
        vc.quiz = self.quiz;
        vc.questionArray = [self.answersArray copy];
        [self.navigationController pushViewController:vc animated:YES];

    }
    else
    {
        //// Go To Results ////
        [self performSegueWithIdentifier:@"results" sender:self.answersArray];
    }
    [self updateUserData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"results"]) {
        ResultsViewController* vc = segue.destinationViewController;
        vc.answersArray = [NSMutableArray arrayWithArray:sender];
    }
}


@end
