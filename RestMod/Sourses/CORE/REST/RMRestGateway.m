//
//  RMRestGateway.m
//  RestMod
//
//  Created by lk1195 on 10/29/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import "RMRestGateway.h"
#import "RMStatusMapping.h"
#import "RMEntityMapping.h"
#import "RMDataMapping.h"

#define BASE_URL @"http://mpm.head-system.com/"
#define PATH_TO_CHECK_UPDATES @"/api/get_updates"

//Array of entities that will be uploaded from server
#define ENTITIES_ARRAY [[NSArray alloc] initWithObjects:@"Category", nil];

@implementation RMRestGateway

- (id)init
{
    if([super init]){
        // initialize AFNetworking HTTPClient
        self.baseURL = [NSURL URLWithString:BASE_URL];
        self.client = [[AFHTTPClient alloc] initWithBaseURL:self.baseURL];
        
        // initialize RestKit
        self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:self.client];
    }
    return self;
}

- (void)configureForUpdateStatus
{
    // setup object mappings
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:[RMStatusMapping class]];
    [statusMapping addAttributeMappingsFromArray:@[@"status", @"result"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:statusMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"api/get_updates"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
}

- (void)configureForUpdate
{    
    // setup object mappings
    RKObjectMapping *entityMapping = [RKObjectMapping mappingForClass:[RMEntityMapping class]];
    [entityMapping addAttributeMappingsFromDictionary:@{@"entity": @"entity"} ];
    
    RKObjectMapping *dataMapping = [RKObjectMapping mappingForClass:[RMDataMapping class]];
    [dataMapping addAttributeMappingsFromDictionary:@{@"title": @"title"} ];
    
    //[entityMapping mapKeyPath:@"data" toRelationship:@"dataArray" withMapping:dataMapping];
    
    [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"dataArray"
                                                                                 withMapping:dataMapping]];
    

    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:entityMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"api/get_last_updates_for_time"
                                                keyPath:@"result"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
}

- (void)checkForUpdates: (NSNumber *) timestamp
internetConnectionError: (void (^)(void)) internetConnectionError
           code404Error: (void (^)(void)) code404Error
      noUpdatesAtServer: (void (^)(void)) noUpdatesAtServer
{
    
    [self configureForUpdateStatus];
    
    NSDictionary *queryParams = @{@"timestamp" : timestamp};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:PATH_TO_CHECK_UPDATES
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  RMStatusMapping *statusMapping = [mappingResult.array objectAtIndex:0];
                                                  
                                                  if([statusMapping.status isEqualToNumber:@400]){
                                                      code404Error();
                                                      return;
                                                  }
                                                  
                                                  if([statusMapping.result isEqual: @"full"]){
                                                      [self getUpdates:timestamp];
                                                  } else if([statusMapping.result isEqual: @"part"]){
                                                      [self getUpdates:timestamp];
                                                  } else if([statusMapping.result isEqual: @"none"]){
                                                      noUpdatesAtServer();
                                                  }
                                                  
                                              }
     
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  internetConnectionError();
                                              }];
    
}

- (void) getResultStatus {
    
}

- (void) getUpdates: (NSNumber *) timestamp
{
    [self configureForUpdate];
    
    NSDictionary *queryParams = @{@"timestamp" : timestamp};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/get_last_updates_for_time"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {                                                  
                                                  NSArray *entities = mappingResult.array;                                                 
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                              }];
}


@end
