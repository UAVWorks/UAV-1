    //
//  PanelsViewController.m
//  UAV
//
//  Created by Eric Dong on 1/1/11.
//  Copyright 2011 NUS. All rights reserved.
//
#import "PanelsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UAV.h"

@implementation PanelsViewController



@synthesize skyGroundBackground;
@synthesize compassCircle;
@synthesize arrowHeight;
@synthesize arrowSpeed;


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
	barGreen1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenRectangle.png"]];
	barRed1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedRectangle.png"]];
	
	barGreen2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenRectangle.png"]];
	
	barGreen3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenRectangle.png"]];
	
	barRed3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedRectangle.png"]];
	
	barGreen1.frame = CGRectMake(733, 110, 50, 140);
	barRed1.frame = CGRectMake(733, 110, 50, 140);
	
	barGreen2.frame = CGRectMake(790, 110+130, 50, 10);
	
	barGreen3.frame = CGRectMake(790+57, 110, 50, 140); 
	barRed3.frame = CGRectMake(790+57, 110, 50, 140);
	
	[self.view addSubview:barRed1];
	[self.view addSubview:barGreen1];
	
	[self.view addSubview:barGreen2];
	
	[self.view addSubview:barGreen3];
	[self.view addSubview:barRed3];
	
	[self.view sendSubviewToBack:barRed1];
	[self.view sendSubviewToBack:barGreen1];
	[self.view sendSubviewToBack:barGreen2];
	[self.view sendSubviewToBack:barGreen3];
	[self.view sendSubviewToBack:barRed3];
	
	barGreen3.hidden = YES;	
	//releasing object. might have problem.
	UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(733+5, 220, 70, 30)] autorelease];
	label1.text = @"Track";
	
	
	UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(790+5, 220, 70, 30)] autorelease];
	label2.text = @"Pkts";
	
	
	UILabel *label3 = [[[UILabel alloc] initWithFrame:CGRectMake(790+57+5, 220, 70, 30)] autorelease];
	label3.text = @"Ping";
	
	label1.backgroundColor = [UIColor clearColor];
	label2.backgroundColor = [UIColor clearColor];
	label3.backgroundColor = [UIColor clearColor];
	
	label1.textColor = [UIColor whiteColor];
	label2.textColor = [UIColor whiteColor];
	label3.textColor = [UIColor whiteColor];
	
	[self.view addSubview:label1];
	[self.view addSubview:label2];
	[self.view addSubview:label3];
	
	
	
	
	
	
	arrowSpeed.layer.anchorPoint = CGPointMake(0.5, (arrowSpeed.bounds.size.height-16.0)/arrowSpeed.bounds.size.height);
	arrowHeight.layer.anchorPoint = CGPointMake(0.5, (arrowHeight.bounds.size.height-16.0)/arrowHeight.bounds.size.height);

	NSAssert(arrowSpeed.bounds.size.width  == arrowHeight.bounds.size.width, @"two arrows must have same dimensions!!");
	NSAssert(arrowSpeed.bounds.size.height  == arrowHeight.bounds.size.height, @"two arrows must have same dimensions!!");
	centerPointOfArrow = CGAffineTransformMakeTranslation(0, (arrowSpeed.bounds.size.height-16) - arrowSpeed.bounds.size.height/2 );
//	[arrowSpeed setNeedsDisplay];
	arrowSpeed.transform = centerPointOfArrow;
	arrowHeight.transform = centerPointOfArrow;
	
	 imageToSplit = [[[UIImage imageNamed:@"Horizon_GroundSky.bmp"] retain] CGImage] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePanels) name:@"settings" object:nil];

	[[UAV sharedInstance] removeSpinner];
	skyGroundBackground.clipsToBounds = YES;
	heightValue.text = @"0.0";

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ping) name:@"ping" object:nil];


}
- (void)ping{
	UAV *uav = [UAV sharedInstance];
	if (uav.uavFound) {
		barGreen3.hidden = NO;
		barRed3.hidden = YES;
		
		barGreen1.hidden = NO;
		barRed1.hidden = NO;
	} else { //No connection, clear all panels
		barGreen3.hidden = YES;
		barRed3.hidden = NO;
		barGreen1.hidden = YES;
		barRed1.hidden = YES;

		//reset packet panel to 0.
		barGreen2.frame = CGRectMake(790, 110+130, 50, 10);

		CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, (500-(255/2)) + (0 / M_PI * 1600), 250, 255));
		
		skyGroundBackground.image = [UIImage imageWithCGImage:partOfImageAsCG];
		
		CGImageRelease(partOfImageAsCG);
		
		skyGroundBackground.transform = CGAffineTransformMakeRotation(0);
		
		compassCircle.transform = CGAffineTransformMakeRotation(0);
		
		arrowHeight.transform = CGAffineTransformRotate(centerPointOfArrow, 0/5*M_PI);
		
		heightValue.text = [NSString stringWithFormat:@"%.2f", 0.00];
		
		arrowSpeed.transform = CGAffineTransformRotate(CGAffineTransformRotate(centerPointOfArrow, M_PI),0);
		
		
	
	}
	
	
	
}

- (void)updatePanels{
	
	int i=0;
	for (i=0; i<[self.tabBarController.viewControllers count]; i++) {
		if([[self.tabBarController.viewControllers objectAtIndex:i] isKindOfClass:[self class]]){
			break;
		}
	}
	if (self.tabBarController.selectedIndex != i) {
		return;
	}
	
	UAV *uav = [UAV sharedInstance];
	
	NSMutableArray *array = [uav getLatestRowData];
	
	CGImageRef partOfImageAsCG = CGImageCreateWithImageInRect(imageToSplit, CGRectMake(0, (500-(255/2)) + (-[[array objectAtIndex:7] floatValue] / M_PI * 1600), 250, 255));
	
	skyGroundBackground.image = [UIImage imageWithCGImage:partOfImageAsCG];
	
	CGImageRelease(partOfImageAsCG);

	skyGroundBackground.transform = CGAffineTransformMakeRotation([[array objectAtIndex:6] floatValue]);
	
	compassCircle.transform = CGAffineTransformMakeRotation(-[[array objectAtIndex:8] floatValue]);
	
	arrowHeight.transform = CGAffineTransformRotate(centerPointOfArrow, -[[array objectAtIndex:2] floatValue]/5*M_PI);
	
	heightValue.text = [NSString stringWithFormat:@"%.2f", -[[array objectAtIndex:2] floatValue]];
	
	arrowSpeed.transform = CGAffineTransformRotate(CGAffineTransformRotate(centerPointOfArrow, M_PI),[[array objectAtIndex:3] floatValue]);
	
	
	//hide green bar if no track found. no track found => yaw angle does not change.
	if ([[array objectAtIndex:8] doubleValue] == previousYawAngle) {
		barGreen1.hidden = YES;
		barRed1.hidden = NO;
	} else{
		barGreen1.hidden = NO;
		barRed1.hidden = YES;
	}
	
	
	if (uav.packetImproper) {
		if (barGreen2.frame.size.height > 50) {
			barGreen2.frame = CGRectMake(barGreen2.frame.origin.x, barGreen2.frame.origin.y+50, barGreen2.frame.size.width, barGreen2.frame.size.height-50);
		}
		uav.packetImproper = NO;
	} else if (barGreen2.frame.size.height != 140) {
		barGreen2.frame = CGRectMake(barGreen2.frame.origin.x, barGreen2.frame.origin.y-1, barGreen2.frame.size.width, barGreen2.frame.size.height+1);
	}
	
	
	previousYawAngle = [[array objectAtIndex:8] doubleValue];
	[array release];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
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


@end
