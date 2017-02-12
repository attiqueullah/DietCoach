//
//  ProfileViewController.h
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "BaseViewController.h"
#import "DNDDragAndDrop.h"

@interface ProfileViewController : BaseViewController
@property (nonatomic, strong) IBOutlet DNDDragAndDropController *dragAndDropController;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *dropTargetViews;
@end
