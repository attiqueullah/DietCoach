//
//  BaseViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 20/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(nonatomic,strong)UITapGestureRecognizer* tap;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_revController) {
        self.revController = [self revealViewController];
    }
    
    //[self.revController panGestureRecognizer];
    [self.revController tapGestureRecognizer];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:self.revController action:@selector(revealToggle:)];
    
    [revealButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    [DATAMANAGER configureNotifications];
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

@end
