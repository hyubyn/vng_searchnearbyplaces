//
//  DetailViewController.h
//  NearbyPlaces
//
//  Created by HYUBYN on 12/14/15.
//

#import <UIKit/UIKit.h>
#import "GooglePlaceObject.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;

- (void)setDetailPlace:(GooglePlaceObject*) place;
@end
