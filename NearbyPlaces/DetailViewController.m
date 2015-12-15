//
//  DetailViewController.m
//  NearbyPlaces
//
//  Created by HYUBYN on 12/14/15.
//  Copyright © 2015 hyubyn. All rights reserved.
//

#import "DetailViewController.h"
#define appKey @"AIzaSyAwlYQGG1bHRo6YNj3xMyOMGmHg5E0cvNo"

@interface DetailViewController ()
{
    GooglePlaceObject* placeDetail;
}
@property (nonatomic, strong) UIImage *icon;
@end

@implementation DetailViewController

- (void)setDetailPlace:(GooglePlaceObject *)place {
    placeDetail = place;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.labelAddress.numberOfLines = 3;
    self.labelName.text = placeDetail.name_;
    if ([placeDetail.address_ isEqualToString:@""]) {
        self.labelAddress.text = placeDetail.vicinity_;
    }
    else {
        self.labelAddress.text = placeDetail.address_;
    }
    if ([placeDetail.phoneNumer_ isEqualToString:@""]) {
        self.labelPhone.text = @"Updating";
    }
    else {
        self.labelPhone.text = placeDetail.phoneNumer_;
    }
    self.labelDistance.text = placeDetail.distanceInMile_;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (placeDetail.photoReference_ != nil) {
            NSString* stringUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@", placeDetail.photoReference_, appKey];
            NSString* webStringURL = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:webStringURL];
            NSData* iconData = [[NSData alloc] initWithContentsOfURL:url];
            self.icon = [[UIImage alloc] initWithData:iconData scale:1.0];
        }
        else{
            NSURL* url = [NSURL URLWithString:placeDetail.icon_];
            NSData* iconData = [[NSData alloc] initWithContentsOfURL:url];
            self.icon = [[UIImage alloc] initWithData:iconData scale:1.0];
        }
        [self.imageView setImage:self.icon];
        [self.view addSubview:self.imageView];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Back{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseModal" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
