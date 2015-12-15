//
//  ViewController.h
//  NearbyPlaces
//
//  Created by HYUBYN on 12/13/15.
//
#import <UIKit/UIKit.h>
#import "GoogleMapService.h"
#import "DetailViewController.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GoogleMapService   *service;
@property (strong, nonatomic) CLLocationManager  *locationManager;
@end

