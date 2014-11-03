//
//  RMMappingProvider.h
//  RestMod
//
//  Created by lk1195 on 11/3/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@class RKObjectMapping;

@interface RMMappingProvider : NSObject

+ (RKObjectMapping *) entityMapping;
+ (RKObjectMapping *) statusMapping;
@end
