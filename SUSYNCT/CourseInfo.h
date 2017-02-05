//
//  CourseInfo.h
//  SUSYNCT
//
//  Created by Attique Ullah on 14/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseInfo : NSObject
@property(nonatomic,strong)NSDictionary* courseData;
@property(nonatomic,strong)NSArray* sectionData;
@property(nonatomic,strong)NSString* scheduledCourseId;
@property(nonatomic,strong)NSString* isCrossListed;
@property(nonatomic,strong)NSString* publishedCourseId;

@end
