//
//  GooglePlaceObject.m
//  NearbyPlaces
//
//  Created by HYUBYN on 12/13/15.
// 

#import "GooglePlaceObject.h"

@implementation GooglePlaceObject

- (instancetype)init: (NSDictionary*) map userCoordinate:(CLLocationCoordinate2D) userCoords
{
    self = [super init];
    if (self) {
        self.name_ = [map objectForKey:@"name"];
        self.reference_ = [map objectForKey:@"reference"];
        self.vicinity_ = [map objectForKey:@"vicinity"];
        self.icon_ = [map objectForKey:@"icon"];
        NSDictionary *geo = [map objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        CLLocation *poi = [[CLLocation alloc] initWithLatitude:[[loc objectForKey:@"lat"] doubleValue]  longitude:[[loc objectForKey:@"lng"] doubleValue]];
        CLLocation *user = [[CLLocation alloc] initWithLatitude:userCoords.latitude longitude:userCoords.longitude];
        CLLocationDistance inMiles = ([user distanceFromLocation:poi]) * 0.000621371192 * 1.609;
        self.distanceInMile_ = [NSString stringWithFormat:@"%.2fKm", inMiles];
        self.phoneNumer_ = @"";
        self.address_ = @"";

    }
    return self;
}

- (NSString*)serialize {
    NSString* result = [NSString stringWithFormat:@"%@\nAddress: ", self.name_];
    result = [result stringByAppendingString:self.vicinity_];
    result = [result stringByAppendingString:@"\nDistance: "];
    result = [result stringByAppendingString:self.distanceInMile_];
    return result;
}
@end
