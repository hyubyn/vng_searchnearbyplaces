//
//  ViewControllerTests.m
//  SearchNearbyPlaces
//
//  Created by HYUBYN on 11/18/15.
//  Copyright © 2015 HYUBYN. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "PlaceDetailController.h"
@interface ViewControllerTests : XCTestCase

@property (nonatomic) ViewController    *viewToTest;
@property (nonatomic) PlaceDetailController *detailTotest;

@end

@implementation ViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewToTest = [[ViewController alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateUrlPerformance {
        NSString *place = @"Cơm";
        [self measureBlock:^{
            [self.viewToTest createUrl:place distance:50000];
        }];
}

- (void) testLoadViewDetail{
    [self measureBlock:^{
        [self.detailTotest viewDidLoad];
    }];
}

@end
