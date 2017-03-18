//
//  LeaderboardViewController.m
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()
@property(nonatomic,strong)NSArray* quizes;
@property (weak, nonatomic) IBOutlet UITableView *tblUsers;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isTestPassed = [[PFUser currentUser][@"test_passed"] boolValue];
    
    if (!isTestPassed) {
        [self getAllQuizes];
    }
    else
    {
        [self getAllAvatar];
    }
    
    // Do any additional setup after loading the view.
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
    BOOL isTestPassed = [[PFUser currentUser][@"test_passed"] boolValue];
    
    if (!isTestPassed) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UsersRankingCell" forIndexPath:indexPath];
        
        UserInfo* quiz = self.quizes[indexPath.section];
        
        cell.lblInput1.text = quiz.first_name;
        cell.lblInput3.layer.masksToBounds = NO;
        cell.lblInput3.clipsToBounds = YES;
        cell.lblInput3.layer.borderColor = [UIColor blackColor].CGColor;
        cell.lblInput3.layer.borderWidth = 1.5;
        cell.lblInput3.layer.cornerRadius = cell.lblInput3.frame.size.width/2;
        cell.lblInput3.text = [DATAMANAGER createShortText:quiz.first_name];
        
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
        cell.lblInput3.layer.masksToBounds = NO;
        cell.lblInput3.clipsToBounds = YES;
        cell.lblInput3.layer.borderColor = [UIColor blackColor].CGColor;
        cell.lblInput3.layer.borderWidth = 1.5;
        cell.lblInput3.layer.cornerRadius = cell.lblInput3.frame.size.width/2;
        cell.lblInput3.text = [DATAMANAGER createShortText:quiz.first_name];
        
        
        NSArray* foodArray = quiz.adventure[@"foods"];
        int points = 0;
        int totPoints = 0;
        if (foodArray.count>0) {
            for (int i=0; i<foodArray.count; i++) {
                NSDictionary* dic = foodArray[i];
                
                NSUInteger pt = [dic[@"value"] integerValue];
                points = ((int)pt * (i+1)) + points;
                totPoints = totPoints + (int)pt;
                
            }
            float avg = points/totPoints;
            cell.starRateing.value = avg;
        }
        else
        {
            cell.starRateing.value = 0;
        }
        
        cell.lblInput2.text = [NSString stringWithFormat:@"(%d)",(int)totPoints];
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
