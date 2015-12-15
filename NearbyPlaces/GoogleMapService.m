//
//  GoogleMapService.m
//  NearbyPlaces
//
//  Created by HYUBYN on 12/13/15.
//

#import "GoogleMapService.h"
#define appKey @"AIzaSyAwlYQGG1bHRo6YNj3xMyOMGmHg5E0cvNo"

@interface GoogleMapService()
{
    CLLocationCoordinate2D  userLocation;
    float radius;
}
@property (nonatomic, strong) NSData   *data;
@property (nonatomic, retain) NSURL    *urlPlaces;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *previousNextPageToken_;
@end

@implementation GoogleMapService

- (bool) hasNextPage {
    bool result = [self.nextPageToken_ isEqualToString:self.previousNextPageToken_];
    return !result;
}

- (void)getResultFromServer:(NSString *)placeName location:(CLLocationCoordinate2D)coordinate distance:(float)distance {
    userLocation = coordinate;
    self.placeName = placeName;
    radius = distance;
    [self.listResults_ removeAllObjects];
    NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%f&name=%@&key=%@",
                           coordinate.latitude, coordinate.longitude, distance, placeName, appKey];
    NSString* webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.urlPlaces = [NSURL URLWithString:webStringURL];
    self.data = [NSData dataWithContentsOfURL:self.urlPlaces];
    if (self.data != nil) {
        NSError* error = nil;
        NSDictionary *placesResponse = [NSJSONSerialization
                                        JSONObjectWithData:self.data
                                        options:kNilOptions
                                        error:&error];
        if (error == nil) {
            NSString *responseStatus = [NSString stringWithFormat:@"%@",[placesResponse objectForKey:@"status"]];
            if ([responseStatus isEqualToString:@"OK"])
            {
                if ([placesResponse objectForKey: @"results"] == nil) {
                    NSDictionary *gResponseDetailData = [placesResponse objectForKey: @"result"];
                    self.listResults_ = [NSMutableArray arrayWithCapacity:1];
                    GooglePlaceObject *detailObject = [[GooglePlaceObject alloc] init:gResponseDetailData userCoordinate:coordinate];
                    [self.listResults_ addObject:detailObject];
                } else {
                    self.listResults_ = [[NSMutableArray alloc] init];
                    NSDictionary *gResponseData  = [placesResponse objectForKey: @"results"];
                    for (NSDictionary *result in gResponseData)
                    {
                        GooglePlaceObject *place = [[GooglePlaceObject alloc] init:result userCoordinate:coordinate];
                        [self.listResults_ addObject:place];
                    }
                }
            }else if ([responseStatus isEqualToString:@"OVER_QUERY_LIMIT"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Query Limited"
                                                                message:@"You got over request, please for 24h to try again!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matches found near this location"
                                                            message:@"Try another place name or address"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            NSLog(@"%@", error.description);
        }
        self.nextPageToken_ = [placesResponse objectForKey: @"next_page_token"];
        
    }
    else{
        NSLog(@"Cannot get information");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot get information"
                                                        message:@"Try another place name or check your wifi connection!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)getNextPageResult {
    if (![self.nextPageToken_ isEqualToString:self.previousNextPageToken_]) {
        NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%f&name=%@&hasNextPage=true&nextPage()=true&sensor=false&key=%@&pagetoken=%@",
                               userLocation.latitude, userLocation.longitude, radius, self.placeName, appKey, self.nextPageToken_];
        NSString* webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.urlPlaces = [NSURL URLWithString:webStringURL];
        self.data = [NSData dataWithContentsOfURL:self.urlPlaces];
        NSError* error = nil;
        NSDictionary *placesResponse = [NSJSONSerialization
                                        JSONObjectWithData:self.data
                                        options:kNilOptions
                                        error:&error];
        if (error == nil) {
            NSString *responseStatus = [NSString stringWithFormat:@"%@",[placesResponse objectForKey:@"status"]];
            while ([responseStatus isEqualToString:@"INVALID_REQUEST"]) {
                self.data = [NSData dataWithContentsOfURL:self.urlPlaces];
                placesResponse = [NSJSONSerialization
                                  JSONObjectWithData:self.data
                                  options:kNilOptions
                                  error:&error];
                responseStatus = [NSString stringWithFormat:@"%@",[placesResponse objectForKey:@"status"]];
            }
            if ([responseStatus isEqualToString:@"OK"])
            {
                if ([placesResponse objectForKey: @"results"] == nil) {
                    NSDictionary *gResponseDetailData = [placesResponse objectForKey: @"result"];
                    self.listResults_ = [NSMutableArray arrayWithCapacity:1];
                    GooglePlaceObject *detailObject = [[GooglePlaceObject alloc] init:gResponseDetailData userCoordinate:userLocation];
                    [self.listResults_ addObject:detailObject];
                } else {
                    NSDictionary *gResponseData  = [placesResponse objectForKey: @"results"];
                    for (NSDictionary *result in gResponseData)
                    {
                        GooglePlaceObject *place = [[GooglePlaceObject alloc] init:result userCoordinate:userLocation];
                        [self.listResults_ addObject:place];
                    }
                }
            }
            self.previousNextPageToken_ = self.nextPageToken_;
            NSString* temp = [placesResponse objectForKey: @"next_page_token"];
            if (temp != nil) {
                self.nextPageToken_ = temp;
            }
        }
        else{
            NSLog(@"Cannot get information");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot get information"
                                                            message:@"Try another place name or check your wifi connection!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)getDetailPlace:(GooglePlaceObject *)place {
    NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&key=%@", place.reference_, appKey];
    NSString* webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.urlPlaces = [NSURL URLWithString:webStringURL];
    self.data = [NSData dataWithContentsOfURL:self.urlPlaces];
    NSError* error = nil;
    NSDictionary *placesResponse = [NSJSONSerialization
                                    JSONObjectWithData:self.data
                                    options:kNilOptions
                                    error:&error];
    if (error == nil) {
        NSDictionary *gResponseDetailData = [placesResponse objectForKey: @"result"];
        place.phoneNumer_ = [gResponseDetailData objectForKey:@"formatted_phone_number"];
        NSString *reference = [NSString stringWithFormat:@"%@",[gResponseDetailData objectForKey:@"photos"]];
        NSArray* arrayOfString = [reference  componentsSeparatedByString:@"\""];
        if ([arrayOfString count] > 9) {
            place.photoReference_ = [arrayOfString[9] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        place.address_ = [gResponseDetailData objectForKey:@"formatted_address"];
    }
}


@end
