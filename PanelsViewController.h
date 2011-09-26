//
//  PanelsViewController.h
//  UAV
//
//  Created by Eric Dong on 1/1/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PanelsViewController : UIViewController {
	IBOutlet UIImageView *skyGroundBackground;
	IBOutlet UIImageView *compassCircle;
	IBOutlet UIImageView *arrowHeight;
	IBOutlet UIImageView *arrowSpeed;
}

@property (nonatomic, retain) UIImageView *skyGroundBackground;
@property (nonatomic, retain) UIImageView *compassCircle;
@property (nonatomic, retain) UIImageView *arrowHeight;
@property (nonatomic, retain) UIImageView *arrowSpeed;


@end
