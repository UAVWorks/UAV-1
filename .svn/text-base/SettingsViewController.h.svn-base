//
//  SettingsViewController.h
//  UAV
//
//  Created by Eric Dong on 8/18/10.
//  Copyright 2010 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CFNetwork/CFNetwork.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>
#import <sqlite3.h>



@interface SettingsViewController : UIViewController {
	int sockfd;
	IBOutlet UITextField *ipAircraft;
	IBOutlet UISwitch *connectSwitch;
	IBOutlet UILabel *status;
	NSLock *myLock;
	struct dataFromUAV 
	{
		char p[8], q[8], r[8];
		char ax[8], ay[8], az[8];
		char hx[8], hy[8], hz[8];
		char phi[8], the[8], psi[8];
		char lon[8], lat[8], alt[8];
		int gpsErr, imuErr, navErr;		
	} *myData;
	sqlite3 *db;
	IBOutlet UIImageView *connected;
	
	IBOutlet UIImageView *notConnected;
	int prevRow;
}

@property (nonatomic, retain) UITextField *ipAircraft;
@property (nonatomic, retain) UISwitch *connectSwitch;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UIImageView *connected;
@property (nonatomic, retain) UIImageView *notConnected;

- (IBAction) connectSwitchToggled: (id)sender;
@end
