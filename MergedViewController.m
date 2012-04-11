//
//  MergedViewController.m
//  UAV
//
//  Created by natalie on 7/4/12.
//  Copyright (c) 2012 NUS. All rights reserved.
//

#import "MergedViewController.h"
#import "UAV.h"

@implementation MergedViewController

@synthesize mapView;
@synthesize distanceLabel;
@synthesize forwardSpeedLabel;
@synthesize heightLabel;
@synthesize liveImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    mapView.mapType = MKMapTypeHybrid;
	mapView.showsUserLocation = NO;
    prevHeading = 0;
    MKCoordinateRegion region;
	CLLocationCoordinate2D  pt[1];
	NSMutableArray *result = [[UAV sharedInstance] getLatestRowData];
	pt[0].latitude = [[result objectAtIndex:22] doubleValue];
	pt[0].longitude = [[result objectAtIndex:21] doubleValue];
	region.center = *pt;//{1.367617, 103.836596};
	
	MKCoordinateSpan span = {0.00182, 0.00182}; //tune to show the best in satellite mode.
	region.span = span;
    [mapView setRegion:region animated:YES];
	
	
	CLLocationCoordinate2D  pointsa[5];
	pointsa[0].latitude = [[result objectAtIndex:22] doubleValue];
	pointsa[0].longitude = [[result objectAtIndex:21] doubleValue];
	
	longitude = 0;
	latitude = 0;
	
	MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
	pin.coordinate = pointsa[0];
	pin.title = @"Coordinates";
    //	[self.mapView addAnnotation:pin];
	
	[result release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerRefreshMap:) name:@"settings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage) name:@"image" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateValues) name:@"settings" object:nil];
    
    liveImageView.image = liveImage;
    
	[[UAV sharedInstance] removeSpinner];
}

-(void)triggerRefreshMap:(NSNotification*)pNotification{
    [self performSelectorOnMainThread:@selector(refreshMap:) withObject:pNotification waitUntilDone:YES];
}

-(void)refreshMap:(NSNotification*)pNotification{
	NSMutableArray *result = (NSMutableArray *)[pNotification object];
	CLLocationCoordinate2D  pointsa[5];
	
	pointsa[0].longitude = [[result objectAtIndex:21] doubleValue];
	pointsa[0].latitude = [[result objectAtIndex:22] doubleValue];
	
	if (prevPin != NULL && [[result objectAtIndex:8] doubleValue] == prevHeading && pointsa[0].latitude == prevPin.coordinate.latitude && pointsa[0].longitude == prevPin.coordinate.longitude)
	{
		//[result release];
		return;
	}
	
	MKPointAnnotation *pin = [[[MKPointAnnotation alloc] init] autorelease];
	
	
	pin.title = @"Coordinates";
	pin.subtitle = [[NSString alloc]initWithFormat:@"%f",[[result objectAtIndex:8]floatValue]] ;
	pin.coordinate = pointsa[0];
	
	[self.mapView addAnnotation:pin];
	
	prevHeading = [[result objectAtIndex:8] doubleValue];
	
	if(prevPin != NULL){
		[self.mapView removeAnnotation:prevPin];
        
		
		CLLocationCoordinate2D linePoints[2];
		linePoints[0] = pointsa[0];
		
		linePoints[1] = (prevPin.coordinate);
		
		MKPolyline *line = [MKPolyline polylineWithCoordinates:linePoints count:2];
		[self.mapView addOverlay:line];
		prevPin.coordinate = pointsa[0];
		
	}	
	prevPin = pin;
	
    MKCoordinateRegion region;
    region.center = pointsa[0];
    MKCoordinateSpan span = {0.00182, 0.00182}; //tune to show the best in satellite mode.
    region.span = span;
    [self.mapView setRegion:region animated:NO];
    
	
}

-(void) updateImage{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UAV *uav = [UAV sharedInstance];
    liveImage = [[UAV sharedInstance] getLatestImageData] ;
	
	[pool drain];
}


-(void) updateData{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UAV *uav = [UAV sharedInstance];
	NSMutableArray *array = [uav getLatestRowData];
	
	heightLabel.text = [NSString stringWithFormat:@"%.2f", -[[array objectAtIndex:2] floatValue]];
    forwardSpeedLabel.text = [NSString stringWithFormat:@"%.2f", -[[array objectAtIndex:3] floatValue]];
    float distance = sqrtf((-[[array objectAtIndex:0] floatValue]*-[[array objectAtIndex:0] floatValue])+(-[[array objectAtIndex:1] floatValue]*-[[array objectAtIndex:1] floatValue]));
	distanceLabel.text = [NSString stringWithFormat:@"%.2f", distance];
//	arrowSpeed.transform = CGAffineTransformRotate(CGAffineTransformRotate(centerPointOfArrow, M_PI),[[array objectAtIndex:3] floatValue]);
	
	[array release];
    [pool drain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
