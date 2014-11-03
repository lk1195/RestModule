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

#import "RMMappingProvider.h"

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

#pragma mark configure response descriptors
- (void)configureForUpdateStatus
{
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[RMMappingProvider statusMapping]
                                                 method:RKRequestMethodGET
                                            pathPattern:@"api/get_updates"
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
}


- (void)configureForUpdate
{
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[RMMappingProvider entityMapping]
                                                 method:RKRequestMethodGET
                                            pathPattern:@"api/get_last_updates_for_time"
                                                keyPath:@"result"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
}

#pragma mark update functions

- (void)checkUpdatesForTimestamp: (NSNumber *) timestamp
internetConnectionError: (void (^)(void)) internetConnectionError
           code404Error: (void (^)(void)) code404Error
      noUpdatesAtServer: (void (^)(void)) noUpdatesAtServer
{
    
    [self configureForUpdateStatus];
    self.timestamp = timestamp;
    
    NSDictionary *queryParams = @{@"timestamp" : timestamp};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:PATH_TO_CHECK_UPDATES
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  RMStatusMapping *statusMapping = [mappingResult.array objectAtIndex:0];
                                                  [self switchStatus:statusMapping code404Error:code404Error noUpdatesAtServer:noUpdatesAtServer];                                                  
                                                  
                                              }
     
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  internetConnectionError(); // if error while connecting server
                                              }];
    
}

- (void)switchStatus: (RMStatusMapping *) statusMapping
        code404Error: (void (^)(void)) code404Error
   noUpdatesAtServer: (void (^)(void)) noUpdatesAtServer
{
    
    // if 404 error at server
    if([statusMapping.status isEqualToNumber:@400]){
        code404Error();
        return;
    }
    
    if([statusMapping.result isEqual: @"full"]){
        [self getUpdates];
    } else if([statusMapping.result isEqual: @"part"]){
        [self getUpdates];
    } else if([statusMapping.result isEqual: @"none"]){
        noUpdatesAtServer();
    }
}

- (void) getUpdates
{
    [self configureForUpdate];
    
    NSDictionary *queryParams = @{@"timestamp" : self.timestamp};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/get_last_updates_for_time"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray *entities = mappingResult.array;                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                              }];
}


@end
