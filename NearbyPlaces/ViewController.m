//
//  ViewController.m
//  NearbyPlaces
//
//  Created by HYUBYN on 12/13/15.
//  Copyright © 2015 hyubyn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,GMSMapViewDelegate, UISearchBarDelegate, UITableViewDataSource>
{
    float radius;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [[GoogleMapService alloc] init];
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    // get current place
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    // Create Left Barbutton item to change distance
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self action:@selector(changeDistance)];
    radius = 1000;
}

-(void)changeDistance{
    NSString* title = [NSString stringWithFormat:@"Please insert radius to find (current is %f meters):", radius];
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

#pragma Handle SearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    CLLocationCoordinate2D currentLocation = self.locationManager.location.coordinate;
    [self.service getResultFromServer:searchBar.text location: currentLocation distance:radius];
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

#pragma implement UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.service.listResults_.count - 1 && [self.service hasNextPage]) {
        [self.service getNextPageResult];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.listResults_.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GooglePlaceObject* place = [self.service.listResults_ objectAtIndex:indexPath.row];
    [self.service getDetailPlace:place];
    DetailViewController* detail = [self.storyboard instantiateViewControllerWithIdentifier:@"viewDetail"];
    [detail setDetailPlace:place];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentModalViewController:navigation animated:YES];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    GooglePlaceObject* place = [self.service.listResults_ objectAtIndex:indexPath.row];
    NSString* displayCell = [NSString stringWithFormat:@"%d. ", indexPath.row + 1];
    displayCell = [displayCell stringByAppendingString:[place serialize]];
    cell.textLabel.text = displayCell;
    cell.textLabel.numberOfLines = 3;
    return cell;
}

@end
