//
//  PlaceDetailController.h
//  SearchNearbyPlaces
//
//  Created by HYUBYN on 11/10/15.
//  Copyright © 2015 HYUBYN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePlaceObject.h"
@interface PlaceDetailController : UIViewController

@property (strong, nonatomic) GooglePlaceObject* detailPlace;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (strong, nonatomic) IBOutlet UILabel *website;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
@property (nonatomic, strong) UIImage   *icon;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UILabel   *distance;


@end
