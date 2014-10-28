//
//  RMAppDelegate.h
//  RestMod
//
//  Created by lk1195 on 10/29/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
