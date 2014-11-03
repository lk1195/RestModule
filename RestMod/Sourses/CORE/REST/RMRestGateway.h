//
//  RMRestGateway.h
//  RestMod
//
//  Created by lk1195 on 10/29/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>



@interface RMRestGateway : NSObject

@property (nonatomic, strong) NSArray *venues;

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) AFHTTPClient *client;
@property (nonatomic, strong) RKObjectManager *objectManager;

@property (nonatomic, strong, readonly) NSArray *entitiesArray;

- (void)checkForUpdates: (NSNumber *) timestamp
internetConnectionError: (void (^)(void)) internetConnectionError
           code404Error: (void (^)(void)) code404Error
      noUpdatesAtServer: (void (^)(void)) noUpdatesAtServer;

@end
