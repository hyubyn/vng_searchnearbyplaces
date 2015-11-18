//
//  PlaceDetailController.m
//  SearchNearbyPlaces
//
//  Created by HYUBYN on 11/10/15.
//  Copyright © 2015 HYUBYN. All rights reserved.
//

#import "PlaceDetailController.h"
#import "AppKey.h"

@implementation PlaceDetailController

- (void)setDetailPlace:(GooglePlaceObject*)newDetailPlace {
    if (_detailPlace != newDetailPlace) {
        _detailPlace = newDetailPlace;
    }
}

- (void)viewDidLoad {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    float width = self.view.bounds.size.width - 20;
    float height = self.view.bounds.size.height - 20;
    // Update the user interface for the detail item.
    if (self.detailPlace) {
        
            self.name = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, width, 50)];
            self.name.lineBreakMode = NSLineBreakByWordWrapping;
            self.name.numberOfLines = 2;
            self.address = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, width, 50)];
            self.distance = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, width, 50)];
            self.rating = [[UILabel alloc] initWithFrame:CGRectMake(20, 330, width, 50)];
            self.address.lineBreakMode = NSLineBreakByWordWrapping;
            self.address.numberOfLines = 2;
            self.phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, width, 50)];
            self.website = [[UILabel alloc] initWithFrame:CGRectMake(20, 430, width, 50)];
            NSString* displayResult = @"Unknown";
            self.name.text = [NSString stringWithFormat:@"Name: %@",self.detailPlace.name];
            if (self.detailPlace.rating != nil) {
                displayResult = self.detailPlace.rating;
            }
            self.rating.text = [NSString stringWithFormat:@"Rating: %@",displayResult];
            if (self.detailPlace.website != nil) {
                displayResult = self.detailPlace.website;
            }
            else{
                displayResult = @"Unknown";
            }
            self.website.text = [NSString stringWithFormat:@"Website: %@",displayResult];
            if (self.detailPlace.vicinity != nil) {
                displayResult = self.detailPlace.vicinity;
            }else{
                displayResult = @"Unknown";
            }
            self.address.text = [NSString stringWithFormat:@"Address: %@",displayResult];
            if (self.detailPlace.internationalPhoneNumber != nil) {
                displayResult = self.detailPlace.internationalPhoneNumber;
            }else{
                displayResult = @"Unknown";
            }
            self.phoneNumber.text = [NSString stringWithFormat:@"Phone Number: %@",displayResult];
            if (self.detailPlace.distanceInMilesString != nil) {
                displayResult = self.detailPlace.distanceInMilesString;
            }else{
                displayResult = @"Unknown";
            }
            self.distance.text = [NSString stringWithFormat:@"Distance: %@",displayResult];

            // self.icon.a
            [self.view addSubview:self.name];
            [self.view addSubview:self.rating];
            [self.view addSubview:self.website];
            [self.view addSubview:self.address];
            [self.view addSubview:self.phoneNumber];
            [self.view addSubview:self.distance];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.detailPlace.photoReference != nil) {
                NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@", self.detailPlace.photoReference, kAPIKey];
                NSString* webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL* url = [NSURL URLWithString:webStringURL];
                NSData* iconData = [[NSData alloc] initWithContentsOfURL:url];
                self.icon = [[UIImage alloc] initWithData:iconData scale:1.0];
            }
            else{
                NSURL* url = [NSURL URLWithString:self.detailPlace.icon];
                NSData* iconData = [[NSData alloc] initWithContentsOfURL:url];
                self.icon = [[UIImage alloc] initWithData:iconData scale:1.0];
            }
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 80, 100, 100)];
            [self.imageView setImage:self.icon];
            [self.view addSubview:self.imageView];
        });
    }
}

-(IBAction)Back{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseModal" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
