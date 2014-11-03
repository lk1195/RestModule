//
//  RMMappingProvider.m
//  RestMod
//
//  Created by lk1195 on 11/3/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import "RMMappingProvider.h"
#import "RMEntityMapping.h"
#import "RMDataMapping.h"
#import "RMStatusMapping.h"

@implementation RMMappingProvider

+ (RKObjectMapping *) entityMapping {
    // setup object mappings
    RKObjectMapping *entityMapping = [RKObjectMapping mappingForClass:[RMEntityMapping class]];
    [entityMapping addAttributeMappingsFromDictionary:@{@"entity": @"entity"} ];
    
    RKObjectMapping *dataMapping = [RKObjectMapping mappingForClass:[RMDataMapping class]];
    NSDictionary *attributesMappings = @{@"id": @"id",
                                         @"title": @"title",
                                         @"description":@"description",
                                         @"order":@"order",
                                         @"icon":@"icon",
                                         @"parent_id":@"parent_id",
                                         @"created_at":@"created_at",
                                         @"updated_at":@"updated_at",
                                         @"lft":@"lft",
                                         @"rgt":@"rgt"};
    
    [dataMapping addAttributeMappingsFromDictionary:attributesMappings];
    
    //[entityMapping mapKeyPath:@"data" toRelationship:@"dataArray" withMapping:dataMapping];
    
    [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                  toKeyPath:@"dataArray"
                                                                                withMapping:dataMapping]];
    
    return entityMapping;
}

+ (RKObjectMapping *) statusMapping {
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:[RMStatusMapping class]];
    [statusMapping addAttributeMappingsFromArray:@[@"status", @"result"]];
    return statusMapping;
}

@end
