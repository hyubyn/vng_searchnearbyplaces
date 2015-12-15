//
//  NearbyPlacesTests.m
//  NearbyPlacesTests
//
//  Created by HYUBYN on 12/13/15.
//  Copyright © 2015 hyubyn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GooglePlaceObject.h"
#import "GoogleMapService.h"
@interface NearbyPlacesTests : XCTestCase
{
    GooglePlaceObject* testObject;
    GoogleMapService* service;
    CLLocationCoordinate2D location;
}
@end

@implementation NearbyPlacesTests

- (void)setUp {
    [super setUp];
    service = [[GoogleMapService alloc] init];
    location = CLLocationCoordinate2DMake(10.811761, 106.674317);
    NSError *jsonError;
    NSData *objectData = [@" {\n         \"geometry\" : {\n            \"location\" : {\n               \"lat\" : 10.8080462,\n               \"lng\" : 106.6739738\n            }\n         },\n         \"icon\" : \"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png\",\n         \"id\" : \"5fb57fe70674223b04a22b1d7dccf3515788a8c1\",\n         \"name\" : \"Quán Cơm Cô Ba\",\n         \"place_id\" : \"ChIJ_Rbr3CApdTERfyiq7r87P3I\",\n         \"reference\" : \"CnRpAAAALa2TnieLTuG23I13yi7oHgaIru-bTcORNCPTAkIz-3phq6vB7iEbfXdIfr0FMchQ4qiDsdcJPfPhoSk22XAE_4aZ9DkZEhT4wYeoyNYXB32pP32Ggh4l-_SVm9dvQJAPI2cx1S_UuSt1TW12I3dPpBIQ9pknyKgOQvQhufrLc7t58xoUvqL-LXi1G7kYBsSRHoF9CxNZ6XI\",\n         \"scope\" : \"GOOGLE\",\n         \"types\" : [ \"establishment\" ],\n         \"vicinity\" : \"323 Đào Duy Anh, 9\"\n      }" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    testObject = [[GooglePlaceObject alloc] init:json userCoordinate:location];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testModel {
    XCTAssertTrue([testObject.name_ isEqualToString:@"Quán Cơm Cô Ba"]);
    XCTAssertTrue([testObject.reference_ isEqualToString: @"CnRpAAAALa2TnieLTuG23I13yi7oHgaIru-bTcORNCPTAkIz-3phq6vB7iEbfXdIfr0FMchQ4qiDsdcJPfPhoSk22XAE_4aZ9DkZEhT4wYeoyNYXB32pP32Ggh4l-_SVm9dvQJAPI2cx1S_UuSt1TW12I3dPpBIQ9pknyKgOQvQhufrLc7t58xoUvqL-LXi1G7kYBsSRHoF9CxNZ6XI"]);
    XCTAssertTrue([testObject.vicinity_ isEqualToString:@"323 Đào Duy Anh, 9"]);
    XCTAssertTrue([testObject.icon_ isEqualToString:@"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png" ]);
    
}

- (void)testGetResultFromServer {
    [service getResultFromServer:@"cơm" location:location distance:1000];
    XCTAssertEqual(service.listResults_.count, 20);
}

- (void)testGetNextPage {
    [service getResultFromServer:@"cơm" location:location distance:1000];
    XCTAssertEqual(service.listResults_.count, 20);
    [service getNextPageResult];
    XCTAssertEqual(service.listResults_.count, 40);
}

- (void)testGetLastPage {
    [service getResultFromServer:@"cơm" location:location distance:1000];
    XCTAssertEqual(service.listResults_.count, 20);
    [service getNextPageResult];
    XCTAssertEqual(service.listResults_.count, 40);
    [service getNextPageResult];
    XCTAssertEqual(service.listResults_.count, 60);
}

- (void)testGetDetailObject {
    [service getDetailPlace:testObject];
    XCTAssertTrue([testObject.phoneNumer_ isEqualToString:@"0188 983 7275"]);
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
