//
//  LeaderboardViewController.m
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()
{
    BOOL isTestPassed ;
}
@property(nonatomic,strong)NSArray* quizes;
@property (weak, nonatomic) IBOutlet UITableView *tblUsers;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isTestPassed = NO;
    
    if (!isTestPassed) {
        [self getAllQuizes];
    }
    else
    {
        [self getAllAvatar];
    }
    
    // Do any additional setup after loading the view.
}
- (IBAction)segBarOptions:(UISegmentedControl*)sender {
    
    self.quizes = nil;
    [self.tblUsers reloadData];
    
    if (sender.selectedSegmentIndex==0) {
        isTestPassed = NO;
        [self getAllQuizes];
    }
    else
    {
        isTestPassed = YES;
        [self getAllAvatar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DATAMANAGER trackPage:@"Leaderboard"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    [DATAMANAGER showTutorialForItem:@"Leaderboard" withController:self WithCompletionBlock:^(BOOL isDone){
        [self.navigationController setNavigationBarHidden:NO];
    }];
    
}
-(void)getAllQuizes
{
    [PARSEMANAGER getAllQuizWithCompletionBlock:^(NSArray* quizes,NSError* error){
        if (!error) {
            if (quizes.count>0) {
                self.quizes = quizes;
                [self.tblUsers reloadData];
            }
        }
    }];
}
-(void)getAllAvatar
{
    [PARSEMANAGER getAllAvatarWithCompletionBlock:^(NSArray* quizes,NSError* error){
        if (!error) {
            if (quizes.count>0) {
                self.quizes = quizes;
                [self.tblUsers reloadData];
            }
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return self.quizes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TextFieldCell *cell = nil;
    
    if (!isTestPassed) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UsersRankingCell" forIndexPath:indexPath];
        
        UserInfo* quiz = self.quizes[indexPath.section];
        
        cell.lblInput1.text = quiz.first_name;
        
        cell.lblInput3.layer.masksToBounds = NO;
        cell.lblInput3.clipsToBounds = YES;
        cell.lblInput3.layer.borderColor = [UIColor blackColor].CGColor;
        cell.lblInput3.layer.borderWidth = 1.5;
        cell.lblInput3.layer.cornerRadius = cell.lblInput3.frame.size.width/2;
        cell.lblInput3.text = [DATAMANAGER createShortText:quiz.username];
        
        if (indexPath.section==0) {
            cell.lblInput2.text = [NSString stringWithFormat:@"🥇%d",(int)quiz.totalPoints];
        }
        else if (indexPath.section==1) {
            cell.lblInput2.text = [NSString stringWithFormat:@"🥈%d",(int)quiz.totalPoints];
        }
        else if (indexPath.section==2) {
            cell.lblInput2.text = [NSString stringWithFormat:@"🥉%d",(int)quiz.totalPoints];
        }
        else
        {
            cell.lblInput2.text = [NSString stringWithFormat:@"%d",(int)quiz.totalPoints];
        }
         return cell;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UsersRankingCell2" forIndexPath:indexPath];
        UserInfo* quiz = self.quizes[indexPath.section];
        
        cell.lblInput1.text = quiz.first_name;
        
        cell.imgInput1.layer.masksToBounds = NO;
        cell.imgInput1.clipsToBounds = YES;
        cell.imgInput1.layer.borderColor = [UIColor blackColor].CGColor;
        cell.imgInput1.layer.borderWidth = 1.5;
        cell.imgInput1.layer.cornerRadius = cell.imgInput1.frame.size.width/2;
        
        cell.imgInput1.image = [UIImage imageNamed:quiz.image];
        
        NSArray* foodArray = quiz.adventure[@"foods"];
        int totPoints = 0;
        if (foodArray.count>0) {
            for (int i=0; i<foodArray.count; i++) {
                NSDictionary* dic = foodArray[i];
                
                NSUInteger pt = [dic[@"value"] integerValue];
                totPoints = totPoints + (int)pt;
                
            }
            float avg = totPoints/foodArray.count;
            cell.lblInput2.text = [NSString stringWithFormat:@"(%d)",(int)avg];
            if (avg > 0 && avg <= 20) {
                cell.starRateing.value = 1.0;
            }
            else if (avg > 20 && avg <= 40) {
                cell.starRateing.value = 2.0;
            }
            else if (avg > 40 && avg <= 60) {
                cell.starRateing.value = 3.0;
            }
            else if (avg > 60 && avg <= 80) {
                cell.starRateing.value = 4.0;
            }
            else if (avg > 80 && avg <= 100)
            {
                cell.starRateing.value = 5.0;
            }
            else
            {
                cell.starRateing.value = 0.0;
            }
        }
        else
        {
            cell.starRateing.value = 0;
        }
        cell.starRateing.userInteractionEnabled = false;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
 [v setBackgroundColor:[UIColor clearColor]];
 return v;
 }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5.0;
}


@end
