//
//  SignUpViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 08/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "SignUpViewController.h"
#import "TextFieldCell.h"
@interface SignUpViewController ()<TTTAttributedLabelDelegate>
@property (nonatomic,strong)UserInfo* userData;
@property (weak, nonatomic) IBOutlet UITableView *tblSignIn;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userData = [[UserInfo alloc]init];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
-(void)hideKeyboard
{
    NSArray* arr = self.tblSignIn.visibleCells;
    for (TextFieldCell * cell in arr) {
        if ([cell isKindOfClass:[TextFieldCell class]]) {
            if ([cell.txtInput1 isFirstResponder] || [cell.txtInput2 isFirstResponder]) {
                [cell.txtInput1 resignFirstResponder];
                 [cell.txtInput2 resignFirstResponder];
                break;
            }
        }
    }
}
-(void)showAlertNotification
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:APP_TITLE
                                 message:@"Thanks for joining XXX. Your next task is to setup your schedule so you can start using XXX."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark IBActions
-(void)showPassword:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSignIn];
    NSIndexPath *indexPath = [self.tblSignIn indexPathForRowAtPoint:buttonPosition];
    TextFieldCell* cell = [self.tblSignIn cellForRowAtIndexPath:indexPath];
    if (cell.txtInput1.text.length==0) {
        return;
    }
    if (sender.tag==0) {
        cell.btnShowPassword.tag = 1;
        [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"eye-slash"] forState:UIControlStateNormal];
        cell.txtInput1.secureTextEntry = NO;
    }
    else
    {
        cell.btnShowPassword.tag = 0;
        [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
        cell.txtInput1.secureTextEntry = YES;
    }
}
-(void)btnTermsAndConditions:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSignIn];
    NSIndexPath *indexPath = [self.tblSignIn indexPathForRowAtPoint:buttonPosition];
    TextFieldCell* cell = [self.tblSignIn cellForRowAtIndexPath:indexPath];
    
    if (sender.tag==2) {
        cell.btnAction.tag = 3;
        [cell.btnAction setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        self.userData.isAgreeTerms = YES;
    }
    else if (sender.tag==3)
    {
        cell.btnAction.tag = 2;
        [cell.btnAction setBackgroundImage:[UIImage imageNamed:@"unCheck"] forState:UIControlStateNormal];
        self.userData.isAgreeTerms = NO;
    }
}
-(void)btnSignIn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnSignUp:(UIButton*)sender
{
    [self hideKeyboard];
    [self performSegueWithIdentifier:@"start" sender:self];
    /*if (self.userData.first_name.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter First Name" withType:ERROR];
        return;
        
    }
    if (self.userData.last_name.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter Last Name" withType:ERROR];
        return;
        
    }
    if (self.userData.username.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter Username" withType:ERROR];
        return;
        
    }
    else
    {
        if (!self.userData.validUsername) {
            [DATAMANAGER showWithStatus:@"Username already taken" withType:ERROR];
            return;
        }
    }
    if (self.userData.email.length==0) {
        [DATAMANAGER showWithStatus:@"Please Enter Email" withType:ERROR];
        return;
        
    }
    else
    {
        if (!self.userData.validEmail && !([self.userData.email isEqualToString:[PFUser currentUser][@"email"]])) {
            [DATAMANAGER showWithStatus:@"Email already taken" withType:ERROR];
            return;
        } else if (![DATAMANAGER NSStringIsValidEmail:self.userData.email]) {
            [DATAMANAGER showWithStatus:@"Invalid email address" withType:ERROR];
            return;
        }
    }
    if (self.userData.mobile.length == 0) {
         [DATAMANAGER showWithStatus:@"Please Enter Mobile Number" withType:ERROR];
         return;
    }
    if (!self.userData.isAgreeTerms) {
        [DATAMANAGER showWithStatus:@"Please Agree To Terms & Conditions" withType:ERROR];
        return;
    }
    
    [PARSEMANAGER signupWithUsername:self.userData.username andPassword:self.userData.password andEmail:self.userData.email andPhone:self.userData.mobile andFirstName:self.userData.first_name andLastName:self.userData.last_name inController:self withCompletionBlock:^(PFUser *user, BOOL success, NSError *error){
        if (success && !error) {
            /////Go to Home Screen////
            
            [NSUserDefaults saveObject:[NSDate date] forKey:@"loginDate"];
            //[self performSegueWithIdentifier:@"start" sender:self];
        }
    }];*/
}
-(void)btnSignUpFacebook:(UIButton*)sender
{
}
-(void)btnSignUpGoogle:(UIButton*)sender
{
}
-(void)btnSignUpTwitter:(UIButton*)sender
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if (indexPath.section==0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Username/User ID";
        cell.btnShowPassword.hidden = YES;
        cell.imgInput1.image = [UIImage imageNamed:@"username"];
        cell.activityCell.hidden = YES;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.username = textField.text;
            self.userData.validUsername = NO;
        }];
        [cell.txtInput1 setBk_shouldEndEditingBlock:^BOOL(UITextField *textField){
            
            [cell.activityCell startAnimating];
            cell.activityCell.hidden = NO;
            PFQuery* query = [PFUser query];
            [query whereKey:@"username" equalTo:textField.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
                
                [cell.activityCell stopAnimating];
                cell.activityCell.hidden = YES;
                if ( [textField.text isEqualToString:[PFUser currentUser][@"username"]]) {
                    self.userData.validUsername = YES;
                    [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                    cell.btnShowPassword.hidden = NO;
                    self.userData.username = textField.text;
                    return;
                }
                if (objects.count>0) {
                    self.userData.validUsername = NO;
                    [cell.txtInput1 becomeFirstResponder];
                    [DATAMANAGER showWithStatus:@"Username already taken" withType:ERROR];
                }
                else
                {
                    self.userData.validUsername = YES;
                    [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                    cell.btnShowPassword.hidden = NO;
                    self.userData.username = textField.text;
                }
            }];
            return YES;
            
        }];
        return cell;
        
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
            
            cell.txtInput1.placeholder = @"Email";
            cell.txtInput1.keyboardType = UIKeyboardTypeEmailAddress;
            cell.btnShowPassword.hidden = YES;
            cell.imgInput1.image = [UIImage imageNamed:@"email"];
            cell.activityCell.hidden = YES;
            [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
                self.userData.validEmail = NO;
                self.userData.email = textField.text;
            }];
            [cell.txtInput1 setBk_shouldEndEditingBlock:^BOOL(UITextField *textField){
                
                if ([DATAMANAGER NSStringIsValidEmail:textField.text]) {
                    [cell.activityCell startAnimating];
                    cell.activityCell.hidden = NO;
                    PFQuery* query = [PFUser query];
                    [query whereKey:@"email" equalTo:textField.text];
                    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
                        
                        [cell.activityCell stopAnimating];
                        cell.activityCell.hidden = YES;
                        
                        if ( [textField.text isEqualToString:[PFUser currentUser][@"email"]]) {
                            [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                            self.userData.validEmail = YES;
                            cell.btnShowPassword.hidden = NO;
                            self.userData.email = textField.text;
                            return;
                        }
                        
                        if (objects.count>0) {
                            self.userData.validEmail = NO;
                            [cell.txtInput1 becomeFirstResponder];
                            [DATAMANAGER showWithStatus:@"Email already taken" withType:ERROR];
                            
                        }
                        else
                        {
                            [cell.btnShowPassword setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                            cell.btnShowPassword.hidden = NO;
                            self.userData.validEmail = YES;
                            self.userData.email = textField.text;
                        }
                    }];
                    return YES;
                }
                else
                {
                    if (textField.text.length>0) {
                        [DATAMANAGER showWithStatus:@"Invalid email address" withType:ERROR];
                    }
                    return YES;
                    
                }
                
            }];
            // [cell.btnShowPassword addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnShowPassword.tag = 0;
            return cell;
            

        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValidateCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Email Address is required to recover lost or forgotten password.";
            cell.textLabel.font = [UIFont fontWithName:AvenirRegular size:11.0];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.numberOfLines = 2.0;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
            }
    if (indexPath.section==2) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Password";
        cell.txtInput1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.btnShowPassword.hidden = NO;
        cell.activityCell.hidden = YES;
        cell.txtInput1.secureTextEntry = YES;
        cell.imgInput1.image = [UIImage imageNamed:@"password"];
        [cell.btnShowPassword addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnShowPassword.tag = 0;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.password = textField.text;
        }];
        return cell;
    }
    if (indexPath.section==3) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextField" forIndexPath:indexPath];
        
        cell.txtInput1.placeholder = @"Confirm Password";
        cell.txtInput1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        cell.btnShowPassword.hidden = NO;
        cell.activityCell.hidden = YES;
        cell.txtInput1.secureTextEntry = YES;
        cell.imgInput1.image = [UIImage imageNamed:@"password"];
        [cell.btnShowPassword addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnShowPassword.tag = 0;
        [cell.txtInput1 setBk_didEndEditingBlock:^(UITextField *textField) {
            self.userData.confirmPassword = textField.text;
        }];
        return cell;
    }
    if (indexPath.section==4) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenderCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section==5) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignUp:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
        
    }
    if (indexPath.section==6) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignUpCell" forIndexPath:indexPath];
        [cell.btnAction addTarget:self action:@selector(btnSignIn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
        
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            return 20;
        }
    }
    if (indexPath.section==6) {
        return 20.0f;
    }
    return 44.0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1 || section==2 || section==3 || section==4) {
        return 10.0f;
    }
    if (section==5) {
        return 30.0f;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

@end
