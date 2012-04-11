//
//  MergedViewController.h
//  UAV
//
//  Created by natalie on 7/4/12.
//  Copyright (c) 2012 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UAV.h"

@interface MergedViewController : UIViewController{
    UILabel *distanceLabel;
    UILabel *forwardSpeedLabel;
    UILabel *heightLabel;
    UIImageView *liveImageView;
    UIImage *liveImage;
    MKMapView *mapView;
	CLLocationDegrees prevHeading;
	MKPointAnnotation *prevPin;
	MKPointAnnotation *prevPinDropped;
	double longitude;
	double latitude;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *forwardSpeedLabel;
@property (nonatomic, retain) IBOutlet UILabel *heightLabel;
@property (nonatomic, retain) IBOutlet UIImageView *liveImageView;
@end
