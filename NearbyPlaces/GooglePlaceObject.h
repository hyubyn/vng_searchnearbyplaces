//
//  GooglePlaceObject.h
//  NearbyPlaces
//
//  Created by HYUBYN on 12/13/15.
//  

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface GooglePlaceObject : NSObject

@property (nonatomic, strong) NSString  *name_;
@property (nonatomic, strong) NSString  *reference_;
@property (nonatomic, strong) NSString  *vicinity_;
@property (nonatomic, strong) NSString  *icon_;
@property (nonatomic, strong) NSString  *address_;
@property (nonatomic, strong) NSString  *phoneNumer_;
@property (nonatomic, strong) NSString  *photoReference_;
@property (nonatomic, strong) NSString  *distanceInMile_;
-(instancetype)init:(NSDictionary*) map userCoordinate:(CLLocationCoordinate2D) userCoords;
-(NSString*)serialize;
@end
