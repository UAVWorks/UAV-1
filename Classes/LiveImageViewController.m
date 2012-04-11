//
//  LiveImageViewController.m
//  UAV
//
//  Created by Eric Dong on 10/5/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import "LiveImageViewController.h"

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
/*
 - (IBAction) performLongTaskOnClick: (id)sender
 {
 statusMessage.text = @"Running long task";
 [self performSelectorInBackground:@selector(performLongTaskInBackground) withObject:nil];
 }
 
 - (void) performLongTaskInBackground
 {
 // Set up a pool for the background task.
 NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
 // perform some long task here, say fetching some data over the web.
 
 
 
 // Always update the components back on the main UI thread.
 
 [self performSelectorOnMainThread:@selector(completeLongRunningTask) withObject:nil waitUntilDone:YES];
 
 
 [pool release];
 
 }
 
 // Called once the background long running task has finished.
 
 - (void) completeLongRunningTask
 {
 statusMessage.text = @"Finished long task";
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	//5hz
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePicture) name:@"settings" object:nil];
	[[UAV sharedInstance] removeSpinner];
	
	[yawAndThrottle addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveYawAndThrottle:)]];
	
	UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapRollAndPitch:)];
	gesture.minimumPressDuration = 0.05;
	[rollAndPitch addGestureRecognizer:gesture];
	
	UILongPressGestureRecognizer *gesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openPayLoad:)];
	gesture2.minimumPressDuration = 0.05;
	[openPayLoad addGestureRecognizer:gesture2];
	
	
	
	UILongPressGestureRecognizer *gesture3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(closePayLoad:)];
	gesture3.minimumPressDuration = 0.05;
	[closePayLoad addGestureRecognizer:gesture3];
	
	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enableSend:) userInfo:nil repeats:YES];
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 0.1;
	
	yawAndThrottle.hidden = YES;
	rollAndPitch.hidden = YES;
	openPayLoad.hidden = YES;
	closePayLoad.hidden = YES;
}

- (void)openPayLoad:(UILongPressGestureRecognizer*)gesture{
	if ([gesture state] == UIGestureRecognizerStateBegan) {
		openPayLoad.alpha = 1;
		
		NSLog(@"drop object");
		[[UAV sharedInstance] parseAndSendCommand:@"Drop object"];
	} 
	
	if ([gesture state] == UIGestureRecognizerStateEnded) {
		openPayLoad.alpha = 0.5;
	}

}

- (void)closePayLoad:(UILongPressGestureRecognizer*)gesture{
	if ([gesture state] == UIGestureRecognizerStateBegan) {
		closePayLoad.alpha = 1;
		
		[[UAV sharedInstance] parseAndSendCommand:@"Close object servo"];
	} 
	
	if ([gesture state] == UIGestureRecognizerStateEnded) {
		closePayLoad.alpha = 0.5;
	}
	

}


- (void)enableSend:(NSTimer*) time{
	enableSend = YES;
	
}

- (void)moveYawAndThrottle:(UIPanGestureRecognizer*)gesture{
	UAV *uav = [UAV sharedInstance];
	if ([gesture state] == UIGestureRecognizerStateBegan) {
		yawAndThrottlePosition = yawAndThrottle.center;
		yawAndThrottle.alpha = 1;
	}
	
	CGPoint newPos = [gesture translationInView:self.view];
	yawAndThrottle.center = CGPointMake(yawAndThrottlePosition.x + newPos.x , yawAndThrottlePosition.y + newPos.y);
	
	if ([gesture state] == UIGestureRecognizerStateEnded) {
		yawAndThrottle.center = yawAndThrottlePosition;
		yawAndThrottle.alpha = 0.5;
	}
	
	if (enableSend) {
		sendingValue = 0;
		if (fabs(newPos.x) > 20) {
			
			if (newPos.x < 0) {
				
				sendingValue = 1;
				[uav parseAndSendCommand:@"Yaw left(0)"];
			} else if (newPos.x > 0) {
				sendingValue = 1;
				[uav parseAndSendCommand:@"Yaw right(0)"];
			}
		}
		
		if (fabs(newPos.y) > 20) {
			
			if (newPos.y < 0) {
				//change for debugging only. use back Elevate and Descend
				sendingValue = 1;
				[uav parseAndSendCommand:@"Elevate(0)"];
			} else if (newPos.y > 0) {
				sendingValue = 1;
				[uav parseAndSendCommand:@"Descend(0)"];
			}	
		}
		enableSend = NO;
	}
}

- (void)tapRollAndPitch:(UILongPressGestureRecognizer*)gesture{
	
	if ([gesture state] == UIGestureRecognizerStateEnded) {
		rollAndPitch.alpha = 0.5;
	} else if ([gesture state] == UIGestureRecognizerStateBegan) {
		rollAndPitch.alpha = 1;
	}
	
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acc{
	UAV *uav = [UAV sharedInstance];

	if (rollAndPitch.alpha == 0.5){
		if (!uav.autoMode && !sendingValue) {
			[[UAV sharedInstance] parseAndSendCommand:@"Hover(0)"];
		}
		return;
	}
	
	float x = fabsf(acc.x);
	float y = fabsf(acc.y);
	
	
	if (x*127*2 > 127) {
		x = 0.5;
	}
	
		if (acc.x  < 0) {
			[uav parseAndSendCommand:[NSString stringWithFormat:@"Forward(%d)", (int)(x*127*2)]];
		} else {
			
			[uav parseAndSendCommand:[NSString stringWithFormat:@"Backward(%d)", (int)(x*127*2)]];
		}
	if (y*127*2 > 127) {
		y = 0.5;
	}
		if (acc.y < 0) {
			[uav parseAndSendCommand:[NSString stringWithFormat:@"Roll left(%d)", (int)(y*127*2)]];
		} else {
			[uav parseAndSendCommand:[NSString stringWithFormat:@"Roll right(%d)", (int)(y*127*2)]];
		}

	
}

- (void)updatePicture{
	
	int i=0;
	for (i=0; i<[self.tabBarController.viewControllers count]; i++) {
		if([[self.tabBarController.viewControllers objectAtIndex:i] isKindOfClass:[self class]]){
			break;
		}
	}
	if(self.tabBarController.selectedIndex == i){
		UAV *uav = [UAV sharedInstance];
		[[imageView image] release];
		[uav.fullImageLock lock];
		[imageView setImage:[[UIImage alloc] initWithData:uav.image]];
		[uav.fullImageLock unlock];
		
		if (uav.autoMode){
			rollAndPitch.hidden = YES;
			yawAndThrottle.hidden = YES;
			//togglePayLoad.hidden = YES;
		}
		else {
			rollAndPitch.hidden = NO;
			yawAndThrottle.hidden = NO;
			//togglePayLoad.hidden = NO;
		}
		
		if ([UAV sharedInstance].currentUAVType == kUAVTypeMerlion) {
			openPayLoad.hidden = NO;
			closePayLoad.hidden = NO;
		}
		else if([UAV sharedInstance].currentUAVType == kUAVTypeCANCAM) {
			openPayLoad.hidden = YES;
			closePayLoad.hidden = YES;
		}
		

	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


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
