    //
//  ManualViewController.m
//  UAV
//
//  Created by Eric Dong on 2/18/11.
//  Copyright 2011 NUS. All rights reserved.
//


#import "ManualViewController.h"


@implementation ManualViewController

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[UIAccelerometer sharedAccelerometer].delegate = self;
	[UIAccelerometer sharedAccelerometer].updateInterval = 1.0/25;
	
	[[UAV sharedInstance] removeSpinner];
	/*
	cross = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1282981817_Delete.png"]];
	[self.view addSubview:cross];
	*/
	CLLocationManager *location = [[CLLocationManager alloc] init];
	location.delegate = self;
	[location startUpdatingHeading];
	
	//[[UIViewController alloc] initWithNibName:<#(NSString *)nibNameOrNil#> bundle:<#(NSBundle *)nibBundleOrNil#>];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	//cross.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading/180 * M_PI);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	//cross.center = CGPointMake(ceil(self.view.frame.size.width/2 + acceleration.y * 250), ceil(self.view.frame.size.height/2 + acceleration.x * 250));
	
}


@end
