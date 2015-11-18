//
//  GooglePlaceObject.m
//  FindNearbyLocation
//
//  Created by HYUBYN on 11/9/15.
//  Copyright © 2015 HYUBYN. All rights reserved.
//

#import "GooglePlaceObject.h"

@implementation GooglePlaceObject

@synthesize placesId;
@synthesize reference;
@synthesize name;
@synthesize icon;
@synthesize rating;
@synthesize vicinity;
@synthesize type;
@synthesize url;
@synthesize addressComponents;
@synthesize formattedAddress;
@synthesize formattedPhoneNumber;
@synthesize website;
@synthesize internationalPhoneNumber;
@synthesize coordinate;
@synthesize distanceInFeetString;
@synthesize distanceInMilesString;
@synthesize searchTerms;
@synthesize photoReference;

-(id)initWithName:(NSString *)theName
         latitude:(double)lt
        longitude:(double)lg
        placeIcon:(NSString *)icn
           rating:(NSString *)rate
         vicinity:(NSString *)vic
             type:(NSArray *)typ
        reference:(NSString *)ref
              url:(NSString *)www
addressComponents:(NSArray *)addComp
 formattedAddress:(NSString *)fAddrss
formattedPhoneNumber:(NSString *)fPhone
          website:(NSString *)web
internationalPhone:(NSString *)intPhone
      searchTerms:(NSString *)search
   distanceInFeet:(NSString *)distanceFeet
  distanceInMiles:(NSString *)distanceMiles
{
    
    if (self = [super init])
    {
        [self setName:theName];
        [self setIcon:icn];
        [self setRating:rate];
        [self setVicinity:vic];
        [self setType:typ];
        [self setReference:ref];
        [self setUrl:www];
        [self setAddressComponents:addComp];
        [self setFormattedAddress:fAddrss];
        [self setFormattedPhoneNumber:fPhone];
        [self setWebsite:web];
        [self setInternationalPhoneNumber:intPhone];
        [self setSearchTerms:search];
        [self setCoordinate:CLLocationCoordinate2DMake(lt, lg)];
        [self setDistanceInFeetString:distanceFeet];
        [self setDistanceInMilesString:distanceMiles];
        
    }
    return self;
    
}

-(id)initWithJsonResultDict:(NSDictionary *)jsonResultDict searchTerms:(NSString *)terms andUserCoordinates:(CLLocationCoordinate2D)userCoords
{
    
    NSDictionary *geo = [jsonResultDict objectForKey:@"geometry"];
    NSDictionary *loc = [geo objectForKey:@"location"];
    CLLocation *poi = [[CLLocation alloc] initWithLatitude:[[loc objectForKey:@"lat"] doubleValue]  longitude:[[loc objectForKey:@"lng"] doubleValue]];
    CLLocation *user = [[CLLocation alloc] initWithLatitude:userCoords.latitude longitude:userCoords.longitude];
    CLLocationDistance inFeet = ([user distanceFromLocation:poi]) * 3.2808;
    
    CLLocationDistance inMiles = ([user distanceFromLocation:poi]) * 0.000621371192 * 1.609;
    
    NSString *distanceInFeet = [NSString stringWithFormat:@"%.f", round(2.0f * inFeet) / 2.0f];
    NSString *distanceInMiles = [NSString stringWithFormat:@"%.2f", inMiles];
    
    
   // NSString *address =[stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self initWithName:[jsonResultDict objectForKey:@"name"]
                     latitude:[[loc objectForKey:@"lat"] doubleValue]
                    longitude:[[loc objectForKey:@"lng"] doubleValue]
                    placeIcon:[jsonResultDict objectForKey:@"icon"]
                       rating:[jsonResultDict objectForKey:@"rating"]
                     vicinity: [jsonResultDict objectForKey:@"vicinity"]
                         type:[jsonResultDict objectForKey:@"types"]
                    reference:[jsonResultDict objectForKey:@"reference"]
                          url:[jsonResultDict objectForKey:@"url"]
            addressComponents:[jsonResultDict objectForKey:@"address_components"]
             formattedAddress:[jsonResultDict objectForKey:@"formatted_address"]
         formattedPhoneNumber:[jsonResultDict objectForKey:@"formatted_phone_number"]
                      website:[jsonResultDict objectForKey:@"website"]
           internationalPhone:[jsonResultDict objectForKey:@"international_phone_number"]
                  searchTerms:[jsonResultDict objectForKey:terms]
               distanceInFeet:distanceInFeet
              distanceInMiles:distanceInMiles
            ];
    
}

-(id) initWithJsonResultDict:(NSDictionary *)jsonResultDict andUserCoordinates:(CLLocationCoordinate2D)userCoords
{
    return [self initWithJsonResultDict:jsonResultDict searchTerms:@"" andUserCoordinates:userCoords];
    
}

-(id)initWithJsonResultDictForDetail:(NSDictionary *)jsonResultDict searchTerms:(NSString *)terms andUserCoordinates:(CLLocationCoordinate2D)userCoords
{
    
    NSDictionary *geo = [jsonResultDict objectForKey:@"geometry"];
    NSDictionary *loc = [geo objectForKey:@"location"];
   // NSDictionary *photo = [jsonResultDict objectForKey:@"photos"];
    
    NSString *reference = [NSString stringWithFormat:@"%@",[jsonResultDict objectForKey:@"photos"]];
     NSArray* arrayOfString = [reference  componentsSeparatedByString:@"\""];
    if ([arrayOfString count] > 9) {
        self.photoReference = arrayOfString[9];
    }
    
    CLLocation *poi = [[CLLocation alloc] initWithLatitude:[[loc objectForKey:@"lat"] doubleValue]  longitude:[[loc objectForKey:@"lng"] doubleValue]];
    CLLocation *user = [[CLLocation alloc] initWithLatitude:userCoords.latitude longitude:userCoords.longitude];
    CLLocationDistance inFeet = ([user distanceFromLocation:poi]) * 3.2808;
    
    CLLocationDistance inMiles = ([user distanceFromLocation:poi]) * 0.000621371192 * 1.609;
    
    NSString *distanceInFeet = [NSString stringWithFormat:@"%.f", round(2.0f * inFeet) / 2.0f];
    NSString *distanceInMiles = [NSString stringWithFormat:@"%.2fkm", inMiles];
    
    
    // NSString *address =[stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self initWithName:[jsonResultDict objectForKey:@"name"]
                     latitude:[[loc objectForKey:@"lat"] doubleValue]
                    longitude:[[loc objectForKey:@"lng"] doubleValue]
                    placeIcon:[jsonResultDict objectForKey:@"icon"]
                       rating:[jsonResultDict objectForKey:@"rating"]
                     vicinity: [jsonResultDict objectForKey:@"vicinity"]
                         type:[jsonResultDict objectForKey:@"types"]
                    reference:[jsonResultDict objectForKey:@"reference"]
                          url:[jsonResultDict objectForKey:@"url"]
            addressComponents:[jsonResultDict objectForKey:@"address_components"]
             formattedAddress:[jsonResultDict objectForKey:@"formatted_address"]
         formattedPhoneNumber:[jsonResultDict objectForKey:@"formatted_phone_number"]
                      website:[jsonResultDict objectForKey:@"website"]
           internationalPhone:[jsonResultDict objectForKey:@"international_phone_number"]
                  searchTerms:[jsonResultDict objectForKey:terms]
               distanceInFeet:distanceInFeet
              distanceInMiles:distanceInMiles
            ];
    
}


-(NSString*) getVicinity{
    return self.vicinity;
}

@end
