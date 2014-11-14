//
//  SKViewController.m
//  FMDBDemo
//
//  Created by shrek wang on 11/13/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "SKViewController.h"

#import "SKDBManager.h"

@interface SKViewController ()

@property (nonatomic, strong) SKDBManager *dbManager;

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.dbManager createTable];
    [self.dbManager insertData];
}

- (SKDBManager *)dbManager
{
    if (!_dbManager) {
        _dbManager = [[SKDBManager alloc] init];
    }
    return _dbManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.dbManager queryData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
