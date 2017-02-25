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
    [self getAllQuizes];
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
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsersRankingCell" forIndexPath:indexPath];
    
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
