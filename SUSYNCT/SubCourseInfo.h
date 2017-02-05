//
//  SubCourseInfo.h
//  SUSYNCT
//
//  Created by Attique Ullah on 17/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseInfo.h"
@interface SubCourseInfo : CourseInfo
@property(nonatomic,strong)NSString* dclass_code;
@property(nonatomic,strong)NSString* location;
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* number_registered;
@property(nonatomic,strong)NSString* day;
@property(nonatomic,strong)NSString* blackboard;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSString* wait_qty;
@property(nonatomic,strong)NSString* session;
@property(nonatomic,strong)NSString* subCourse_id;
@property(nonatomic,strong)NSString* units;
@property(nonatomic,strong)NSDictionary* instructor;
@property(nonatomic,strong)NSDictionary* syllabus;
@property(nonatomic,strong)NSString* isDistanceLearning;
@property(nonatomic,strong)NSString* start_time;
@property(nonatomic,strong)NSDictionary* notes;
@property(nonatomic,strong)NSString* spaces_available;
@property(nonatomic,strong)NSString* section_title;
@property(nonatomic,strong)NSString* canceled;
@property(nonatomic,strong)NSString* comment;
@property(nonatomic,strong)NSString* end_time;
@property(nonatomic,strong)NSString* course_description;



@end
