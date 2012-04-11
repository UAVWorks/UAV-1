    //
//  PanelsViewController.m
//  UAV
//
//  Created by Eric Dong on 1/1/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "PanelsViewController.h"
#import <QuartzCore/QuartzCore.h>

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
//	arrowSpeed.layer.position
	NSLog(@"%f", arrowSpeed.layer.position.x);
	NSLog(@"%f", arrowSpeed.layer.position.y);
	
	arrowSpeed.layer.anchorPoint = CGPointMake(0.5, (arrowSpeed.bounds.size.height-10)/arrowSpeed.bounds.size.height);
	arrowSpeed.transform = CGAffineTransformMakeTranslation(0, 10);



	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

}
- (void)timerFireMethod:(NSTimer*)theTimer{

	skyGroundBackground.transform = CGAffineTransformMakeRotation(0.31);
	compassCircle.transform = CGAffineTransformMakeRotation(0.31);
	arrowHeight.transform = CGAffineTransformMakeRotation(0.31);
	//arrowSpeed.transform = CGAffineTransformMakeRotation(M_PI/4);

//	CGPoint rotationOfArrow = CGPointApplyAffineTransform(CGPointMake(arrowSpeed.bounds.size.width/2, 	arrowSpeed.bounds.size.height/2), CGAffineTransformMakeRotation(M_PI/2));
//	NSLog(@"x:%f", rotationOfArrow.x);
//		NSLog(@"y:%f", rotationOfArrow.y);
//	arrowSpeed.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(rotationOfArrow.x, rotationOfArrow.y), M_PI/2);
	//CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), 30, 5);//(5, 5);

	skyGroundBackground.clipsToBounds = YES;
	//arrowSpeed.transform = CGaff
	
	//CGAffineTransformMakeRotation(rand()/2);
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
