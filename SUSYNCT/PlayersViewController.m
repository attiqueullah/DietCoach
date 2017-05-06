//
//  PlayersViewController.m
//  Diet Coach
//
//  Created by Attique Ullah on 14/04/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "PlayersViewController.h"

@interface PlayersViewController ()
@property(nonatomic,strong)NSArray* playersArray;
@property(nonatomic,strong)NSDictionary* selPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation PlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.tableFooterView = [UIView new];
    [self getPlayersData];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getPlayersData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"players" ofType:@"plist"];
    // Read plist from bundle and get Root Dictionary out of it
    NSArray *dictRoot = [NSArray arrayWithContentsOfFile:path];
    
    self.playersArray = [dictRoot mutableCopy];
    [self.tableview reloadData];
}
- (IBAction)btnSelectPlayer:(id)sender {
    
    NSString* str = [NSString stringWithFormat:@"%@ has been chosen by the Saudi National team Head Coach. For him to participate with the Saudi national team in the upcoming World Cup 2018, he needs to maintain healthy diet for the next three days. You have been chosen to be his diet coach! It is your responsibility to make sure that he eats well and join the team. Most importantly, please remember that you must to feed him once a day for the next three days. Good luck!",self.selPlayer[@"name"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations"
                                                                   message:str
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              [PFUser currentUser][@"image"] = self.selPlayer[@"image"];
                                                              [DATAMANAGER showWithStatus:@"Plesase wait..." withType:STATUS];
                                                              [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL sucess, NSError* error){
                                                                  [DATAMANAGER hideStatus];
                                                                  [DATAMANAGER goToLeaderBoard:self.revealViewController];
                                                              }];
                                                          }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
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
    return self.playersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TextFieldCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlayersCell" forIndexPath:indexPath];
    NSDictionary* player = self.playersArray[indexPath.section];
    
    cell.lblInput1.text = player[@"name"];
    cell.imgInput1.layer.masksToBounds = NO;
    cell.imgInput1.clipsToBounds = YES;
    cell.imgInput1.layer.borderColor = [UIColor blackColor].CGColor;
    cell.imgInput1.layer.borderWidth = 1.5;
    cell.imgInput1.layer.cornerRadius = cell.imgInput1.frame.size.width/2;
    
    cell.imgInput1.image = [UIImage imageNamed:player[@"image"]];
    
   
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
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
    NSDictionary* player = self.playersArray[indexPath.section];
    self.selPlayer = player;
    [NSUserDefaults saveObject:player forKey:@"Player"];
   
    TextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20.0;
}

@end
