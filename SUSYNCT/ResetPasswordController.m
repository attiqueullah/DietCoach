//
//  ResetPasswordController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 13/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "ResetPasswordController.h"

@interface ResetPasswordController (){
    NSString *email_;
}

@property (weak, nonatomic) IBOutlet UIButton *resetPassword;
@property (weak, nonatomic) IBOutlet UIButton *cancelPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

@implementation ResetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.resetPassword.layer.cornerRadius = 6.0;
    self.cancelPassword.layer.cornerRadius = 6.0;
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

-(void) sendRequest
{
    [self hideKeyboard];
    __block NSString *title = nil;
    __block NSString *msg = nil;
    [DATAMANAGER showWithStatus:@"Please wait..." withType:STATUS];
    [PFUser requestPasswordResetForEmailInBackground:self.txtEmail.text block:^(BOOL succeeded,NSError *error) {
        self.view.userInteractionEnabled = YES;
        [DATAMANAGER hideStatus];
        if (error) {
            NSString *errorString = [error userInfo][@"error"];
            
            if ([errorString rangeOfString:@"The request timed out"].location != NSNotFound) {
                errorString = @"Request Timed out.";
            }
            else if ([errorString rangeOfString:@"The Internet connection appears to be offline."].location != NSNotFound) {
                errorString = @"The Internet connection appears to be offline.";
            }
            
            title = @"Error";
            msg = [NSString stringWithFormat:@"Could not send reset password instructions email because %@",errorString];
            [DATAMANAGER showWithStatus:title withType:ERROR];
        }
        else {
            title = @"Email Sent";
            msg = @"An email has been sent to the email address you provided for reseting the password";
            [DATAMANAGER showWithStatus:title withType:ERROR];
        }
    }];
}

-(void) hideKeyboard
{
    UITextField *emailField = self.txtEmail;
    if ([emailField isFirstResponder]) {
        [emailField resignFirstResponder];
    }
}
- (IBAction)btnResetPassword:(id)sender {
    self.view.userInteractionEnabled = NO;
    BOOL isValid = YES;
    NSString *msg = nil;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if (self.txtEmail.text.length == 0 || ![emailTest evaluateWithObject:self.txtEmail.text]) {
        isValid = NO;
        msg = @"Email";
    }
    else {
        email_ = self.txtEmail.text;
    }
    if (!isValid) {
         [DATAMANAGER showWithStatus:[NSString stringWithFormat:@"Please enter a valid %@",msg] withType:ERROR];
        self.view.userInteractionEnabled = YES;
    }
    else {
        [self sendRequest];
    }

}
- (IBAction)btnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
