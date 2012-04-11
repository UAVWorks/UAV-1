//
//  LiveImageViewController.h
//  UAV
//
//  Created by Eric Dong on 10/5/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAVAppDelegate.h"

@interface LiveImageViewController : UIViewController {
		IBOutlet UIImageView *imageView;
		IBOutlet UILabel *labeltxt;
	UAVAppDelegate *mainDelegate;

}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *labeltxt;

@end
