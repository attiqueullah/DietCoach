//
//  ResultsViewController.m
//  Diet Coach
//
//  Created by Attique Ullah on 11/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *correctAns1;
@property (weak, nonatomic) IBOutlet UILabel *correctAns2;
@property (weak, nonatomic) IBOutlet UILabel *userAns1;
@property (weak, nonatomic) IBOutlet UILabel *userAns2;
@property (weak, nonatomic) IBOutlet UILabel *pt1;
@property (weak, nonatomic) IBOutlet UILabel *pt2;
@property (weak, nonatomic) IBOutlet UILabel *total;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    [self loadCorrectAnswersOne];
    [self loadCorrectAnswersTwo];
    [self totalPoints];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DATAMANAGER trackPage:@"Results"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCorrectAnswersOne
{
    Answers* ans1 = self.answersArray[0];
    
    NSArray* options = ans1.question[@"options"];
    NSString* ans = [options objectAtIndex: [ans1.question[@"answer"] integerValue]];
    NSString* userAnswer = [options objectAtIndex:ans1.answerType];
    
    self.correctAns1.text = ans;
    
    
    if ([ans isEqualToString:userAnswer]) {
        ans1.points = 20;
        self.userAns1.text = [NSString stringWithFormat:@"✅ %@",userAnswer];
    }
    else
    {
        ans1.points = 0;
        self.userAns1.text = [NSString stringWithFormat:@"❌ %@",userAnswer];
    }
    self.pt1.text = [NSString stringWithFormat:@"%d",(int)ans1.points];
    [self.answersArray replaceObjectAtIndex:0 withObject:ans1];
    
    
}
-(void)loadCorrectAnswersTwo
{
    Answers* ans1 = self.answersArray[1];
    
    NSArray* options = ans1.question[@"options"];
    NSString* ans = [options objectAtIndex: [ans1.question[@"answer"] integerValue]];
    NSString* userAnswer = [options objectAtIndex:ans1.answerType];
    self.correctAns2.text = ans;

    if ([ans isEqualToString:userAnswer]) {
        ans1.points = 20;
        self.userAns2.text = [NSString stringWithFormat:@"✅ %@",userAnswer];
        
    }
    else
    {
        ans1.points = 0;
        self.userAns2.text = [NSString stringWithFormat:@"❌ %@",userAnswer];
    }
    self.pt2.text = [NSString stringWithFormat:@"%d",(int)ans1.points];
    [self.answersArray replaceObjectAtIndex:1 withObject:ans1];
}
-(void)totalPoints
{
    int total = 0;
    for (Answers* ans in self.answersArray) {
        total = (int)ans.points + total;
    }
    self.total.text = [NSString stringWithFormat:@"%d",total];

}

-(IBAction)btnCheckMyScore:(id)sender
{
    
    [DATAMANAGER evaluateResults:self.answersArray];
    
    [DATAMANAGER goToLeaderBoard:self.revealViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
