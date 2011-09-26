//
//  SettingsViewController.h
//  UAV
//
//  Created by Eric Dong on 8/18/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UAV.h"
#import "ImageViewController.h"
#import "MapViewController.h"
#import "OpenGLViewController.h"
#import "IPAddress.h"
#import "SLAM.h"



@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>{
	int sockfd;
	IBOutlet UISwitch *connectSwitch;
	IBOutlet UILabel *status;

	IBOutlet UIImageView *connected;
	
	IBOutlet UIImageView *notConnected;
	IBOutlet UITextField *consoleInput;
	int prevRow;
	
	IBOutlet UILabel *uavIP;
	
	int filelist;
	
	NSString *defaultConnectedText;
	
	IBOutlet UISlider *slider1;
	IBOutlet UISlider *slider2;
	IBOutlet UISlider *slider3;
	IBOutlet UISlider *slider4;
	IBOutlet UISlider *slider5;
	IBOutlet UISlider *slider6;
	IBOutlet UISlider *slider7;
	IBOutlet UISlider *slider8;
	
	IBOutlet UILabel *sliderText1;
	IBOutlet UILabel *sliderText2;
	IBOutlet UILabel *sliderText3;
	IBOutlet UILabel *sliderText4;
	IBOutlet UILabel *sliderText5;
	IBOutlet UILabel *sliderText6;
	IBOutlet UILabel *sliderText7;
	IBOutlet UILabel *sliderText8;
	
	
	IBOutlet UIButton *sliderAdd1;
	IBOutlet UIButton *sliderAdd2;
	IBOutlet UIButton *sliderAdd3;
	IBOutlet UIButton *sliderAdd4;
	IBOutlet UIButton *sliderAdd5;
	IBOutlet UIButton *sliderAdd6;
	IBOutlet UIButton *sliderAdd7;
	IBOutlet UIButton *sliderAdd8;
	
	IBOutlet UIButton *sliderSub1;
	IBOutlet UIButton *sliderSub2;
	IBOutlet UIButton *sliderSub3;
	IBOutlet UIButton *sliderSub4;
	IBOutlet UIButton *sliderSub5;
	IBOutlet UIButton *sliderSub6;
	IBOutlet UIButton *sliderSub7;
	IBOutlet UIButton *sliderSub8;
	
	IBOutlet UILabel *sliderLabel1;
	IBOutlet UILabel *sliderLabel2;
	IBOutlet UILabel *sliderLabel3;
	IBOutlet UILabel *sliderLabel4;
	IBOutlet UILabel *sliderLabel5;
	IBOutlet UILabel *sliderLabel6;
	IBOutlet UILabel *sliderLabel7;
	IBOutlet UILabel *sliderLabel8;
	
	
	UIImageView *imageView;
	
	BOOL notFirstTimeActivate;

	NSMutableArray *sqlArray;
	
	NSUInteger fileID;
	
	NSArray *viewControllersFull;
	
	IBOutlet UIButton *calibrateCamera;
}

@property (nonatomic, retain) UISwitch *connectSwitch;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UIImageView *connected;
@property (nonatomic, retain) UIImageView *notConnected;
@property (nonatomic, retain) UITextField *consoleInput;
@property (nonatomic, retain) UILabel *uavIP;
@property (nonatomic, retain) NSArray *viewControllersFull;

- (void)setEnableSliders:(BOOL)enable;

- (IBAction) connectSwitchToggled: (id)sender;
- (IBAction) sendData: (id) sender;
- (IBAction) emailData: (id) sender;
- (IBAction)valueChangedForSliders;
- (IBAction) deleteAllJPG: (id) sender;
- (IBAction) calibrateCamera: (UIButton*) sender;
- (IBAction) addValue: (UIButton*) sender;
- (IBAction) subValue: (UIButton*) sender;
-(IBAction) viewJpeg:(id) sender;
- (IBAction) uavTypeToggled:(id)sender;
- (void)setVisibleSliders:(double)alpha;

@end
