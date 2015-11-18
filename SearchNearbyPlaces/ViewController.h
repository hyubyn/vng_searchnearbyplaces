//
//  ViewController.h
//  SearchNearbyPlaces
//
//  Created by HYUBYN on 11/10/15.
//  Copyright © 2015 HYUBYN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "GooglePlaceObject.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) GMSMapView    *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UISearchBar   *searchBar;

-(void)createUrl:(NSString*) placeName distance:(float)distance;
-(void)getLocations;
@end

