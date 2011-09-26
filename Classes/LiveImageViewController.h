//
//  LiveImageViewController.h
//  UAV
//
//  Created by Eric Dong on 10/5/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UAV.h"

@interface LiveImageViewController : UIViewController <UIAccelerometerDelegate>{
		IBOutlet UIImageView *imageView;
		IBOutlet UILabel *labeltxt;
	IBOutlet UIImageView *yawAndThrottle;
	IBOutlet UIImageView *rollAndPitch;
	
	CGPoint yawAndThrottlePosition;
	CGPoint rollAndPitchPosition;
	
	BOOL enableSend;
	
	BOOL sendingValue;
	
	IBOutlet UIImageView *openPayLoad;
	
	IBOutlet UIImageView *closePayLoad;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *labeltxt;

@end
