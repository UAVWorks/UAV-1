#import <UIKit/UIKit.h>
//#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UAV.h"
#import "ImageViewController.h"
#import "MapViewController.h"
#import "OpenGLViewController.h"
#import "IPAddress.h"
#import "SLAM.h"
#import "ImageProcessingImpl.hpp"

#define DATA_STATE		0x21
#define DATA_SVO		0x16
#define DATA_SIG		0x17
#define COMMAND_IMAGE   120

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>{
	int datasockfd;
    int imagesockfd;
	IBOutlet UITextField *consoleInput;
	IBOutlet UITextField *imageIPTextField;
	IBOutlet UITextField *imagePortTextField;
	IBOutlet UITextField *dataPortTextField;
	IBOutlet UISwitch *connectSwitch;
	IBOutlet UISwitch *listenSwitch;
	IBOutlet UILabel *gcsIP;
	IBOutlet UILabel *dataPort;
    IBOutlet UILabel *imageIP;
    IBOutlet UITextView *bufferOutput;
	int prevRow;
	
	int filelist;
	
	NSString *defaultConnectedText;	
	UIImageView *imageView;
	
	BOOL notFirstTimeActivate;

	NSMutableArray *sqlArray;
	
	NSUInteger fileID;
	
	NSArray *viewControllersFull;
	
	IBOutlet UIButton *calibrateCamera;
}

@property (nonatomic, retain) UITextField *consoleInput;
@property (nonatomic, retain) UITextField *imageIPTextField;
@property (nonatomic, retain) UITextField *imagePortTextField;
@property (nonatomic, retain) UITextField *dataPortTextField;
@property (nonatomic, retain) UISwitch *connectSwitch;
@property (nonatomic, retain) UISwitch *listenSwitch;
@property (nonatomic, retain) UILabel *gcsIP;
@property (nonatomic, retain) UILabel *dataPort;
@property (nonatomic, retain) UILabel *imageIP;
@property (nonatomic, retain) NSArray *viewControllersFull;

- (IBAction) connectSwitchToggled: (id)sender;
- (IBAction) listenSwitchToggled: (id)sender;
- (IBAction) sendData: (id) sender;
- (IBAction) emailData: (id) sender;
- (IBAction) deleteAllJPG: (id) sender;
-(IBAction) viewJpeg:(id) sender;

@end
