//
//  ManualViewController.h
//  UAV
//
//  Created by Eric Dong on 2/18/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "UAV.h"

@interface ManualViewController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	IBOutlet UIImageView *image;
}

@end
