//
//  ViewController.m
//  SearchNearbyPlaces
//
//  Created by HYUBYN on 11/10/15.
//  Copyright © 2015 HYUBYN. All rights reserved.
//

#import "ViewController.h"
#import "AppKey.h"
#import "PlaceDetailController.h"


@interface ViewController () <GMSMapViewDelegate, UISearchBarDelegate>
{
    int radius;
}
@property (nonatomic, strong) NSData                 *data;
@property (nonatomic, retain) NSURL                  *urlPlaces;
@property (nonatomic, retain) NSMutableData          *responseData;
@property (nonatomic, strong) NSMutableArray         *googlePlacesObject;
@property (nonatomic) CLLocationCoordinate2D          currentLocation;
@property (nonatomic, strong) NSString               *nextPageToken;
@property (nonatomic, strong) NSString               *placeName;
@property (nonatomic, strong) UIActivityIndicatorView   *indicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeModal:) name:@"CloseModal" object:nil];
    
    self.googlePlacesObject = [[NSMutableArray alloc] init];
    //initialize the activity indicator
    UIActivityIndicatorView *actInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    //Change the color of the indicator, this override the color set by UIActivityIndicatorViewStyleWhiteLarge
    actInd.color=[UIColor blueColor];
    
    //Assign it to the property
    self.indicator= actInd;
        // Create Left Barbutton item to change distance
   self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self action:@selector(changeDistance)];
    //Create Right Barbutton item to clear map
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithCustomView:self.indicator];
    [[self navigationItem] setRightBarButtonItem:barButton];
    
    [barButton release];
    [self.indicator startAnimating];
    self.indicator.hidden = TRUE;
     UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                       style:UIBarButtonItemStylePlain target:self action:@selector(clearMap)];
    //Create Current Place button
    UIBarButtonItem *currentPlace = [[UIBarButtonItem alloc] initWithTitle:@"Current Place"
                                                                     style:UIBarButtonItemStylePlain target:self action:@selector(showLocation)];
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    [self.navigationController setToolbarHidden:NO];
    
    //set the toolbar buttons
    [self setToolbarItems:[NSArray arrayWithObjects: currentPlace, flexibleSpace, clearButton, nil]];
    // add search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, 250, 50)];
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar setDelegate:self];

    // get current place
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    
    // Create a GMSCameraPosition that tells the map to display the
    // current place at zoom level 15.
    self.currentLocation = self.locationManager.location.coordinate;
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.latitude
                                                            longitude:self.currentLocation.longitude
                                                                 zoom:15];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
    
    radius = 1000;
    
    
}

-(void)closeModal:(NSNotification *)notification{
    UIViewController *controller=(UIViewController *)notification.object;
    
    [controller dismissViewControllerAnimated:YES completion:^ {
        self.indicator.hidden = TRUE;
    }];
    
}

#pragma mark - Handle Navigation Bar Items.

- (void) clearMap{
    [self.mapView clear];
    [self.googlePlacesObject removeAllObjects];
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

-(void)changeDistance{
    NSString* title = [NSString stringWithFormat:@"Please insert radius to find (current is %d meters):", radius];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle: title
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Ok"])
    {
        UITextField *radiusInput = [alertView textFieldAtIndex:0];
        radius = radiusInput.text.intValue;
        if (radius == 0 || radius > 50000) {
            radius = 1000;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input is incorrect!"
                                                            message:@"Please insert number from 1 to 50000"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];

        } else{
            if (![self.searchBar.text isEqualToString:@""]) {
                [self searchBarSearchButtonClicked:self.searchBar];
            }
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    self.placeName = self.searchBar.text;
    if (![self.placeName isEqualToString:@""]) {
        [self createUrl:self.placeName distance:radius];
        [self.searchBar resignFirstResponder];
    }
}



-(void)showLocation{
    [self.mapView animateToLocation:self.mapView.myLocation.coordinate];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Input.
- (void)createUrl:(NSString *)placeName distance:(float)distance{
    [self.googlePlacesObject removeAllObjects];
    NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%f&name=%@&key=%@",
                           self.currentLocation.latitude, self.currentLocation.longitude, distance, placeName, kAPIKey];
    NSString* webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.urlPlaces = [NSURL URLWithString:webStringURL];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.data = [NSData dataWithContentsOfURL:self.urlPlaces];
        if (self.data != nil) {
            [self getLocations];
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
    });
}

- (void)createUrlNextPage{
    NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&name=%@&hasNextPage=true&nextPage()=true&sensor=false&key=%@&pagetoken=%@",
                           self.currentLocation.latitude, self.currentLocation.longitude, radius, self.placeName, kAPIKey, self.nextPageToken];
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

    }
    [self.indicator setHidden:TRUE];
    if (self.data != nil) {
        [self getLocations];
    }
    else{
        NSLog(@"Cannot get information");
    }

    
}

- (GooglePlaceObject*) getPlaceDetail:(NSString*)reference{
    NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&key=%@", reference, kAPIKey];
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
        GooglePlaceObject *detailObject = [[GooglePlaceObject alloc] initWithJsonResultDictForDetail:gResponseDetailData searchTerms:@"" andUserCoordinates:self.currentLocation];
        return detailObject;
    }
    return nil;
}

- (void)getLocations{
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
                self.googlePlacesObject = [NSMutableArray arrayWithCapacity:1];
                GooglePlaceObject *detailObject = [[GooglePlaceObject alloc] initWithJsonResultDict:gResponseDetailData andUserCoordinates:self.currentLocation];
                [self.googlePlacesObject addObject:detailObject];
            } else {
                NSDictionary *gResponseData  = [placesResponse objectForKey: @"results"];
                NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[[placesResponse objectForKey:@"results"] count]];
                
                for (NSDictionary *result in gResponseData)
                {
                    [arrayTemp addObject:result];
                }
                
                for (int i = 0; i < [arrayTemp count]; ++i)
                {
                    GooglePlaceObject *object = [[GooglePlaceObject alloc] initWithJsonResultDict:[arrayTemp objectAtIndex:i] andUserCoordinates:self.currentLocation];
                    [arrayTemp replaceObjectAtIndex:i withObject:object];
                }
                for (int i = 0; i < [arrayTemp count]; ++i) {
                    [self.googlePlacesObject addObject:[arrayTemp objectAtIndex:i]];
                }
            }
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
    self.nextPageToken = [placesResponse objectForKey: @"next_page_token"];
    if (self.nextPageToken != nil) {
        self.indicator.hidden = FALSE;
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self createUrlNextPage];
        });
        
    }
    else{
        GooglePlaceObject* nearestPlace = [self.googlePlacesObject objectAtIndex:0];
        for (int i = 0; i < [self.googlePlacesObject count]; ++i) {
            GooglePlaceObject* temp = [self.googlePlacesObject objectAtIndex:i];
            if (temp.distanceInMilesString.floatValue < nearestPlace.distanceInMilesString.floatValue) {
                nearestPlace = temp;
            }
        }
        NSString* message = [NSString stringWithFormat:@"%lu Places were Found:\n The nearest place is: %@ \n At: %@ \n Distance: %@Km", (unsigned long)[self.googlePlacesObject count], nearestPlace.name, nearestPlace.vicinity, nearestPlace.distanceInMilesString];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Results"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawMarkers];
        });
    }
    
}

#pragma mark - work with map after receive results.
- (void)drawMarkers{
    [self.mapView clear];
    for (int i = 0; i < [self.googlePlacesObject count]; ++i) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        GooglePlaceObject* object = [self.googlePlacesObject objectAtIndex:i];
        marker.position = CLLocationCoordinate2DMake(object.coordinate.latitude, object.coordinate.longitude);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.title = object.name;
        marker.snippet = object.distanceInMilesString;
        marker.map = self.mapView;
    }
}

-(BOOL) mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    //NSLog(@"%@ \n %@", marker.title, marker.description);
    for (int i = 0; i < [self.googlePlacesObject count]; ++i) {
        GooglePlaceObject* object = [self.googlePlacesObject objectAtIndex:i];
        if ([object.name isEqualToString:marker.title] && [object.distanceInMilesString isEqualToString:marker.snippet]) {
            GooglePlaceObject* detailPlace = [self getPlaceDetail:object.reference];
             PlaceDetailController* detail = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceDetailController"];
            [detail setDetailPlace:detailPlace];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:detail];
            [self presentModalViewController:navigation animated:YES];
            [navigation release];
            return YES;

        }
    }
    return NO;
}



@end
