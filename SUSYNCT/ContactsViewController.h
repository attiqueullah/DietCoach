//
//  ContactsViewController.h
//  Diet Coach
//
//  Created by Attique Ullah on 25/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContactDelegate <NSObject>
@required
-(void)contactDidSelect:()contact;
@end

@interface ContactsViewController : UIViewController
@property(nonatomic,assign)id<ContactDelegate>delegate;
@end
