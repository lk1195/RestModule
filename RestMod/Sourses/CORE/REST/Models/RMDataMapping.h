//
//  RMDataMapping.h
//  RestMod
//
//  Created by lk1195 on 11/3/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMDataMapping : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *order;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSNumber *parent_id;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;
@property (strong, nonatomic) NSString *lft;
@property (strong, nonatomic) NSString *rgt;
@end
