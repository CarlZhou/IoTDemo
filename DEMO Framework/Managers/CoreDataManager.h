//
//  CoreDataManager.h
//  DEMO Framework
//
//  Created by Zhou, Zian on 2015-02-17.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;

// Core Data
- (NSEntityDescription *)getEntityForName:(NSString *)name;

// test
- (void)addMockupData;
- (void)clearMockupData;

@end
