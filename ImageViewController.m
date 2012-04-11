    //
//  ImageViewController.m
//  UAV
//
//  Created by Eric Dong on 3/17/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ImageViewController.h"


@implementation ImageViewController

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
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	fileID = 1;
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"file1.jpg"];
	image = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:documentsDirectory]] autorelease];
	image.frame = CGRectMake(0, 0, 600, 240.0/320*600);
	lbl = [[[UILabel alloc] initWithFrame:CGRectMake(500, 0, 100, 40)] autorelease];
	
	lbl.text = [NSString stringWithFormat:@"Image:%d", fileID];
	
	//lbl.center = image.center;
	lbl.backgroundColor = [UIColor clearColor];
	lbl.shadowColor = [UIColor grayColor];
	lbl.shadowOffset = CGSizeMake(1,1);
	
	[self.view addSubview:image];
	[self.view addSubview:lbl];
	
	[image addGestureRecognizer:[[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panJpeg:)] autorelease]];
	
//image.center = CGPointMake(500, 500);
	image.userInteractionEnabled = YES;
    [super viewDidLoad];
	
 
 
}


- (void)panJpeg:(UIPanGestureRecognizer*)gesture{
		
	if ([gesture state] == UIGestureRecognizerStateBegan) {
		previousCoordinate = [gesture translationInView:self.view];
	}
	//if (fabs([gesture translationInView:self.view].x - previousCoordinate.x) > 10 || fabs([gesture translationInView:self.view].y - previousCoordinate.y) > 10) {
		NSUInteger prevInt = fileID;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		if (fabs([gesture translationInView:self.view].x) > fabs([gesture translationInView:self.view].y)) {
			
			if ([gesture translationInView:self.view].x - previousCoordinate.x < 0) {
				fileID++;
			} else if ([gesture translationInView:self.view].x - previousCoordinate.x > 0) {
				fileID--;
				if (fileID <= 0) {
					fileID = 1;
				}
			} 
		} else {
			
			if ([gesture translationInView:self.view].y - previousCoordinate.y < 0) {
				fileID+=20;
			} else if ([gesture translationInView:self.view].y - previousCoordinate.y > 0) {
				fileID-=20;
				if (fileID <= 0) {
					fileID = 1;
				}
			} 
		}
		
		
		documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"file%d.jpg", fileID]];
		
		if([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
			((UIImageView*)[gesture view]).image = [UIImage imageWithContentsOfFile:documentsDirectory];
			lbl.text = [NSString stringWithFormat:@"Image:%d", fileID];
		} else {
			fileID = prevInt;
		}
		
	//}
	
	previousCoordinate = [gesture translationInView:self.view];
		
	
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
