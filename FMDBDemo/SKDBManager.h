//
//  SKDBManager.h
//  FMDBDemo
//
//  Created by shrek wang on 11/13/14.
//  Copyright (c) 2014 shrek wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB.h>

@interface SKDBManager : NSObject

- (FMDatabase *)getDB;

- (void)createTable;

- (void)insertData;

- (void)queryData;

@end
