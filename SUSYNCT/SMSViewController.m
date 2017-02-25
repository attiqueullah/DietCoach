//
//  SMSViewController.m
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "SMSViewController.h"
#import "IQTextView.h"
#import "ContactsViewController.h"
@interface SMSViewController ()<ContactDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (weak, nonatomic) IBOutlet IQTextView *txtmessage;
@property(nonatomic,strong)NSDictionary* selContact;
@end

@implementation SMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtMobileNumber.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DATAMANAGER trackPage:@"SMS Page"];
}
- (IBAction)btnTapContacts:(id)sender {
    [self performSegueWithIdentifier:@"contacts" sender:self];
}
- (IBAction)btnSendMessage:(id)sender {
    NSArray *phones = self.selContact[@"phones"];
    NSDictionary *phoneItem = phones[0];
    NSString* phonenumber = [phoneItem[@"value"] stringByReplacingOccurrencesOfString:@"-" withString:@""];

    [DATAMANAGER sendSMSViaTwilio:self.txtmessage.text withTo:phonenumber WithCompletionBlock:^(BOOL sucess, NSError* error){
        if (!error) {
            
            NSLog(@"Message Sent Successfully");
            [DATAMANAGER userData].totalSMS =   [DATAMANAGER userData].totalSMS + 1;
            
            [PFUser currentUser][@"total_SMS"] = [NSNumber numberWithInteger:[DATAMANAGER userData].totalSMS];
            [DATAMANAGER storeParseObject:[PFUser currentUser]];
            [DATAMANAGER storeUserInfoObject:[DATAMANAGER userData]];
           
            PFObject* obj = [PFObject objectWithClassName:@"SMS"];
            obj[@"from"] = FROM_TWILIO;
            obj[@"to"] = phonenumber;
            obj[@"message"] = self.txtmessage.text;
            obj[@"user"]= [PFUser currentUser];
            
            [DATAMANAGER storeParseObject:obj];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"contacts"]) {
        UINavigationController* nvc = [segue destinationViewController];
        ContactsViewController* vc = (ContactsViewController*)[nvc topViewController];
        vc.delegate = self;
    }
}
#pragma mark Contacts Delegates
-(void)contactDidSelect:(NSDictionary*)contact
{
    self.selContact = contact;
    NSString *firstName = [contact[@"firstName"] stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
    NSArray *phones = contact[@"phones"];
    NSDictionary *phoneItem = phones[0];
    NSString* phonenumber = [phoneItem[@"value"] stringByReplacingOccurrencesOfString:@"-" withString:@""];

    self.txtMobileNumber.text =  [NSString stringWithFormat:@"%@ (%@)",firstName,phonenumber];
}
@end
