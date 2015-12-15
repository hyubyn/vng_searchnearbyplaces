//
//  GoogleMapService.h
//  NearbyPlaces
//
//  Created by HYUBYN on 12/13/15.
//  

#import <Foundation/Foundation.h>
#import "GooglePlaceObject.h"

@interface GoogleMapService : NSObject

@property (nonatomic, strong) NSMutableArray    *listResults_;
@property (nonatomic, strong) NSString          *nextPageToken_;
@property (nonatomic, strong) CLLocationManager *locationManager_;

- (void)getResultFromServer:(NSString*) placeName location:(CLLocationCoordinate2D) coordinate distance:(float) distance;
- (void)getNextPageResult;
- (void)getDetailPlace: (GooglePlaceObject*) place;
- (bool)hasNextPage;
@end
