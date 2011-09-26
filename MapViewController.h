//
//  MapViewController.h
//  UAV
//
//  Created by Eric Dong on 8/18/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "UAV.h"


@interface MapViewController : UIViewController <MKMapViewDelegate>{
	MKMapView *mapView;
	UISwitch *mapType;
	UISwitch *followSwitch;
	double longitude;
	double latitude;
	MKPointAnnotation *prevPin;
	MKPointAnnotation *prevPinDropped;
	UIButton *dropPinButton;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISwitch *mapType;
@property (nonatomic, retain) IBOutlet UISwitch *followSwitch;
@property (nonatomic, retain) IBOutlet UIButton *dropPinButton;

-(IBAction) mapTypeToggled:(id)sender;
-(IBAction)followSwitchToggled: (id)sender;
-(IBAction)pinDrop:(id)sender;
@end
