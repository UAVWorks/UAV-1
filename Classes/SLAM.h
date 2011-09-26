//
//  SLAM.h
//  UAV
//
//  Created by Lee Sing Jie on 5/8/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAV.h"


@interface SLAM : UIViewController <UIScrollViewDelegate> {

	IBOutlet UIScrollView *radarArea;
	UIImageView *radarView;
	UIImageView *uavIndicator;
	
	NSData *imageData;
	
	CGImageRef imageCG;
	CGContextRef context;
	CGContextRef contextBlackScreen;
	
	unsigned char *points;
	UISlider *sliderSLAM;
	int sliderValue;
}

@property (nonatomic, retain) UIImageView *radarView;
@property (nonatomic, retain) NSData *imageData;
- (void) plotAt: (double) x y: (double) y ;
- (void)updateUAVIndicator;

- (IBAction) clearSLAM;
@end
