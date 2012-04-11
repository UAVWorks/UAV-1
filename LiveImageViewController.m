//
//  LiveImageViewController.m
//  UAV
//
//  Created by Eric Dong on 10/5/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import "LiveImageViewController.h"
#import "UAVAppDelegate.h"

@implementation LiveImageViewController

@synthesize imageView;
@synthesize labeltxt;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
		//	mainDelegate = (UAVAppDelegate *) [[UIApplication sharedApplication] delegate];
		//5hz
		//	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePicture) userInfo:nil repeats:YES];

}

- (void)updatePicture{

	[imageView setImage:[[[UIImage alloc] initWithData:mainDelegate.image]autorelease]];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
