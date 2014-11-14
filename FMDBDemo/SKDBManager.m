//
//  SKDBManager.m
//  FMDBDemo
//
//  Created by shrek wang on 11/13/14.
//  Copyright (c) 2014 shrek wang. All rights reserved.
//

#import "SKDBManager.h"

// contants: table names

static NSString * const TableNameOrder = @"_Order";

static NSString * const TableNameFood = @"Food";

static NSString * const TableNameCustomer = @"Customer";

// enum: food type

typedef NS_ENUM(NSInteger, FoodType) {
    FoodTypeNoodle = 1,
    FoodTypeRice = 2,
    FoodTypeSnacks = 3
};


@interface SKDBManager ()

@end

@implementation SKDBManager

- (NSString *)pathOfDB
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"sell.db"];
    return dbPath;
}

- (FMDatabase *)getDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self pathOfDB]];
    return db;
}

- (void)errorHappenOnDB:(FMDatabase *)db
{
    NSLog(@"%@", [db lastErrorMessage]);
    [db close];
}

- (void)createTable
{
    FMDatabase *db = [self getDB];
    if (![db open]) {
        NSLog(@"%@", [db lastErrorMessage]);
        return;
    }
    
    NSString *createFoodTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(type INTEGER PRIMARY KEY ASC, desc TEXT, price REAL)", TableNameFood];
    if (![db executeUpdate:createFoodTableSQL]) {
        [self errorHappenOnDB:db];
        return;
    }
    
    NSString *createCustomerTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(name TEXT PRIMARY KEY ASC)", TableNameCustomer];
    if (![db executeUpdate:createCustomerTableSQL]) {
        [self errorHappenOnDB:db];
        return;
    }
    
    NSString *createOrderTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY ASC, customerId INTEGER, foodId INTEGER, quantity INTEGER, FOREIGN KEY (customerId) REFERENCES %@(name), FOREIGN KEY (foodId) REFERENCES %@(type))", TableNameOrder, TableNameCustomer, TableNameFood];
    if (![db executeUpdate:createOrderTableSQL]) {
        [self errorHappenOnDB:db];
        return;
    }
    
    [db close];
}

- (void)insertData
{
    FMDatabase *db = [self getDB];
    if (![db open]) {
        NSLog(@"%@", [db lastErrorMessage]);
        return;
    }
    
    NSString *insertFoodTableSQL = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(?, ?, ?)", TableNameFood];
    if (![db executeUpdate:insertFoodTableSQL, [NSNumber numberWithInteger:FoodTypeRice], @"rice", [NSNumber numberWithFloat:20.0f]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertFoodTableSQL, [NSNumber numberWithInteger:FoodTypeNoodle], @"noodle", [NSNumber numberWithFloat:10.0f]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertFoodTableSQL, [NSNumber numberWithInteger:FoodTypeSnacks], @"snacks", [NSNumber numberWithFloat:15.0f]]) {
        [self errorHappenOnDB:db];
        return;
    }
    
    NSString *insertCustomerTableSQL = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(?)", TableNameCustomer];
    if (![db executeUpdate:insertCustomerTableSQL, @"shrek1"]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertCustomerTableSQL, @"shrek2"]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertCustomerTableSQL, @"shrek3"]) {
        [self errorHappenOnDB:db];
        return;
    }
    
    NSString *insertOrderTableSQL = [NSString stringWithFormat:@"INSERT INTO %@(customerId, foodId, quantity) VALUES(?, ?, ?)", TableNameOrder];
    if (![db executeUpdate:insertOrderTableSQL, @"shrek1", [NSNumber numberWithInteger:FoodTypeRice], [NSNumber numberWithInteger:1]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertOrderTableSQL, @"shrek1", [NSNumber numberWithInteger:FoodTypeSnacks], [NSNumber numberWithInteger:3]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertOrderTableSQL, @"shrek2", [NSNumber numberWithInteger:FoodTypeNoodle], [NSNumber numberWithInteger:1]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertOrderTableSQL, @"shrek2", [NSNumber numberWithInteger:FoodTypeSnacks], [NSNumber numberWithInteger:2]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertOrderTableSQL, @"shrek3", [NSNumber numberWithInteger:FoodTypeRice], [NSNumber numberWithInteger:1]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertOrderTableSQL, @"shrek3", [NSNumber numberWithInteger:FoodTypeNoodle], [NSNumber numberWithInteger:1]]) {
        [self errorHappenOnDB:db];
        return;
    }
    if (![db executeUpdate:insertOrderTableSQL, @"shrek3", [NSNumber numberWithInteger:FoodTypeSnacks], [NSNumber numberWithInteger:1]]) {
        [self errorHappenOnDB:db];
        return;
    }
    
    [db close];
}

- (void)queryData
{
    FMDatabaseQueue *dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self pathOfDB]];
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *selectOrderTableSQL = [NSString stringWithFormat:@"SELECT * FROM %@", TableNameOrder];
        FMResultSet *resultSet = [db executeQuery:selectOrderTableSQL];
        NSLog(@"%@", selectOrderTableSQL);
        NSLog(@"=========== Result ============");
        while ([resultSet next]) {
            NSLog(@"(%@, %d, %d)", [resultSet stringForColumn:@"customerId"], [resultSet intForColumn:@"foodId"], [resultSet intForColumn:@"quantity"]);
        }
        resultSet = nil;
        
        NSString *select3TableSQL = [NSString stringWithFormat:@"SELECT c.name AS username, f.desc AS fdesc, o.quantity * f.price AS cost FROM %@ as c, %@ as f, %@ as o WHERE c.name == o.customerId AND f.type == o.foodId", TableNameCustomer, TableNameFood, TableNameOrder];
        FMResultSet *resultSet2 = [db executeQuery:select3TableSQL];
        NSLog(@"%@", select3TableSQL);
        NSLog(@"=========== Result ============");
        while ([resultSet2 next]) {
            NSLog(@"%@ buy %@ cost %f", [resultSet2 stringForColumn:@"username"], [resultSet2 stringForColumn:@"fdesc"], [resultSet2 doubleForColumn:@"cost"]);
        }
        resultSet2 = nil;
        
        NSString *selectTotalCostSQL = [NSString stringWithFormat:@"SELECT username, total(cost) AS totalCost FROM (SELECT c.name AS username, f.desc AS fdesc, o.quantity * f.price AS cost FROM %@ as c, %@ as f, %@ as o WHERE c.name == o.customerId AND f.type == o.foodId) GROUP BY username ORDER BY totalCost DESC", TableNameCustomer, TableNameFood, TableNameOrder];
        FMResultSet *resultSet3 = [db executeQuery:selectTotalCostSQL];
        NSLog(@"%@", selectTotalCostSQL);
        NSLog(@"=========== Result ============");
        while ([resultSet3 next]) {
            NSLog(@"%@ total cost %f", [resultSet3 stringForColumn:@"username"], [resultSet3 doubleForColumn:@"totalCost"]);
        }
        resultSet3 = nil;
    }];
    NSLog(@"kik ass");
    [dbQueue close];
}

@end
