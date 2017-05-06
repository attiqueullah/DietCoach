//
//  MenuViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 20/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "HealthyViewController.h"
@interface MenuViewController ()
{
    NSInteger _presentedRow;
    NSInteger _presentedSection;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _presentedSection = 0;
    _presentedRow = 0;
    self.tblData.tableFooterView = [UIView new];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"side"]];
    [tempImageView setFrame:self.tblData.frame];
    
    self.tblData.backgroundView = tempImageView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark GO TO LeaderBoard
-(void)goToLederBoard
{
    LeaderboardViewController *frontViewController = [BOARD instantiateViewControllerWithIdentifier:NAV_MAIN];
    [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
 
}

#pragma mark GO TO Saudi Meals
-(void)goToSaudiMeals
{
    SaudiMealsController *frontViewController = [SAUDI instantiateViewControllerWithIdentifier:NAV_SAUDI];
     [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
     [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO Western Meals
-(void)goToWesternMeals
{
    WesternMealsController *frontViewController = [WESTERN instantiateViewControllerWithIdentifier:NAV_WESTERN];
    [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO SMS
-(void)goToSMS
{
    SMSViewController *frontViewController = [SMS instantiateViewControllerWithIdentifier:NAV_SMS];
    [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO Profile
-(void)goToProfile
{
        ProfileViewController *frontViewController = [PROFILE instantiateViewControllerWithIdentifier:NAV_AVATAR];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark GO TO SMS
-(void)goToSettings
    {
        SMSViewController *frontViewController = [SMS instantiateViewControllerWithIdentifier:NAV_SMS];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
#pragma mark GO TO HELP
-(void)goToHelp
    {
        HelpViewController *frontViewController = [HELP instantiateViewControllerWithIdentifier:NAV_HELP];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
#pragma mark GO TO ABOUT
-(void)goToAbout
    {
        AboutViewController *frontViewController = [ABOUT instantiateViewControllerWithIdentifier:NAV_ABOUT];
        [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
#pragma mark GO TO LOGOUT
-(void)goToLogout
    {
        [PFObject unpinAllObjectsInBackground];
        [PFUser logOutInBackground];
        [DATAMANAGER removeAllNotifications];
        
        [NSUserDefaults clearUserDefaults];
        ViewController *frontViewController = [MAIN instantiateViewControllerWithIdentifier:NAV_LOGIN];
        [[UIApplication sharedApplication] keyWindow].rootViewController = frontViewController;
    }
#pragma mark GO TO Healthy Chiken Plate
-(void)goToHealthyChikenPlate
{
    HealthyViewController *frontViewController = [HEALTH instantiateViewControllerWithIdentifier:NAV_Healthy];
    [self.revealViewController setFrontViewController:frontViewController animated:YES];    //sf
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 150.0f;
    }
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    else if( section == 2  )
        return 40.0f;
    else
        return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        BOOL isTestPassed = [[PFUser currentUser][@"test_passed"] boolValue];
        
        if (!isTestPassed) {
            return 5;
        }
        return 6;
    }
    if (section == 2) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftCell";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.lblNTitle.text = @"Leaderboard";
            cell.lblNIcon.text = @"🎖";
            [cell configureCell:[UIColor whiteColor]];
            cell.backgroundColor = RGB(0, 136, 68);
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
             [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
            return cell;
        }
        if (indexPath.row==1) {
            cell.lblNTitle.text = @"Healthy Eating";
            cell.lblNIcon.text = @"🍱";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            
            return cell;
        }
        else if (indexPath.row==2)
        {
            cell.lblNTitle.text = @"Saudi Meals";
            cell.lblNIcon.text = @"🥘";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            
            return cell;
            
        }
        else if (indexPath.row==3)
        {
            cell.lblNTitle.text = @"Western Meals";
            cell.lblNIcon.text = @"🍔";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            
            return cell;
            
            
        }
        else if (indexPath.row==4)
        {
            cell.lblNTitle.text = @"SMS";
            cell.lblNIcon.text = @"💬";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
            
        }
        else if (indexPath.row==5)
        {
            cell.lblNTitle.text = @"Adventure Chamber";
            cell.lblNIcon.text = @"👤";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
        }
        
        
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0) {
            cell.lblNTitle.text = @"About";
            cell.lblNIcon.text = @"ℹ️";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
        }
        else if (indexPath.row==1)
        {
            cell.lblNTitle.text = @"Help";
            cell.lblNIcon.text = @"❔";
            [cell configureCell:[UIColor whiteColor]];
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
            
        }
        else if (indexPath.row==2)
        {
            cell.lblNTitle.text = @"Logout";
            cell.lblNIcon.text = @"❌";
            [cell configureCell:[UIColor whiteColor]];
            
            cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor whiteColor]]];
            return cell;
        }
        
    }
    else
    {
        static NSString *CellIdentifier = @"HeaderCell";
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
    
    return cell;
}
/*-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView * headerview = (UITableViewHeaderFooterView *)view;
    
    headerview.contentView.backgroundColor = [UIColor clearColor];
}*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    
    if ((indexPath.section == _presentedSection && indexPath.row == _presentedRow) && (indexPath.section!=1 && indexPath.row!=0))
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = RGB(0, 136, 68);
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [self goToLederBoard];
        }
        if (indexPath.row==1) {
            
            [self goToHealthyChikenPlate];
        }
        if (indexPath.row==2) {
            
            [self goToSaudiMeals];
        }
        if (indexPath.row==3) {
           ///Go to Western Meals ///
            [self goToWesternMeals];
        }
        if (indexPath.row==4) {
           ///Go to SMS ///
            [self goToSMS];
        }
        if (indexPath.row==5) {
           ///Go to Notifications ///
            [self goToProfile];
        }
    }
    else
    {
        if (indexPath.row==0) {
            [self goToAbout];
        }
        if (indexPath.row==1) {
            [self goToHelp];
        }
        if (indexPath.row==2) {
            ///// LOGOUT /////
            [self goToLogout];
        }
    }
    _presentedRow = indexPath.row;
    _presentedSection = indexPath.section;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTableViewCell *cell = (LeftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"LeftCell";
    
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    if (cell == nil) {
        cell = [[LeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier];
    }
    cell.lblNIcon.hidden = YES;
    cell.lblNTitle.hidden = YES;
    // Configure the cell title etc
    
    return cell;
}
@end
