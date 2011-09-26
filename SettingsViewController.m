    //
	//  SettingsViewController.m
	//  UAV
	//
	//  Created by Eric Dong on 8/18/10.
	//  Copyright 2010 NUS. All rights reserved.
	//

#import "SettingsViewController.h"
#import "UAVAppDelegate.h"

#define MAX_INCOMING_DATA_LENGTH 200
#define MAX_DISPLAY_DATA_LENGTH 13

@implementation SettingsViewController

@synthesize ipAircraft;
@synthesize connectSwitch;
@synthesize status;
@synthesize connected;
@synthesize notConnected;
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
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		//	UAV *uav;
		//uav = [(UAV*) initialize];
		//uav->currentDataNew->
	prevRow = 0;
	[connected setHidden:YES];// = YES;
	notConnected.hidden = YES;
	
	struct addrinfo hints, *res, *p;
    int statusa;
    char ipstr[INET6_ADDRSTRLEN];
    char hostname[500] = "Sing-Jies-iPhone-4.local";	
	memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET; // AF_INET or AF_INET6 to force version
    hints.ai_socktype = SOCK_STREAM;
	
		//	gethostname(hostname, 500);
    if ((statusa = getaddrinfo(hostname, NULL, &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(statusa));
        return;
    }
	
    for(p = res;p != NULL; p = p->ai_next) {
        void *addr;
        char *ipver;
		
			// get the pointer to the address itself,
			// different fields in IPv4 and IPv6:
        if (p->ai_family == AF_INET) { // IPv4
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = "IPv4";
        }
		
			// convert the IP to a string and print it:
        inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
        
		status.text = [NSString stringWithFormat:@"%s", ipstr];	
    }
	
	[super viewDidLoad];
}
	// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Return YES for supported orientations
	return YES;
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

#pragma mark -
#pragma mark IBAction
- (IBAction) mapSwitchToggled: (id)sender{
	
}

- (IBAction) connectSwitchToggled: (id)sender{	
	int rv;
	struct sockaddr_in iPhoneAddr;
	
	UAVAppDelegate *mainDelegate = (UAVAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	db =  mainDelegate.db;
	
	
	myData = malloc(sizeof(struct dataFromUAV));
	memset(myData, 0, sizeof(struct dataFromUAV));
	
	if (connectSwitch.on) // if the switch is on, create a socket and bind it
	{
		sockfd = socket(AF_INET, SOCK_DGRAM, 0);
		if (sockfd == -1)
		{
			status.text = @"Fail to create socket";
			return;
		}	
			//getAddrinfo(
		bzero(&iPhoneAddr, sizeof(iPhoneAddr));
		iPhoneAddr.sin_family = AF_INET;
		iPhoneAddr.sin_addr.s_addr = htonl(INADDR_ANY);//htonl(hostlong);
		iPhoneAddr.sin_port = htons(9001);
		rv = bind(sockfd, (struct sockaddr *)&iPhoneAddr, sizeof(iPhoneAddr));
		if (rv == -1)
		{
			close(sockfd);
			status.text = @"Fail to bind socket";
			return;
		}
			// create and initialize a mutex lock that control access to shared data between threads
		myLock = [[NSLock alloc] init];
		
			// create a thread to monitor incoming data and a thread to update the display
		[NSThread detachNewThreadSelector:@selector(checkForIncomingData) toTarget:self withObject:nil];	
			//[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
		
			//	status.text = [NSString stringWithFormat:@"Listening", sockfd];
	}	
	else // close the socket to terminate the connection
	{	
			//sockfd = [[globalVars sharedInstance] getSockfd];
		
		close(sockfd);
		status.text = [NSString stringWithFormat:@"Not listening at id:%d", sockfd];	
	}
	
	return;
	
}- (void) startTheBackgroundJob
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(updateDisplay) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void) updateDisplay
{		
	
	
	if ([myLock tryLock])
	{
		NSString *query = @"Select count(*) from FLIGHTDATA;";
		
		int row=0;
		
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
			if (sqlite3_step(statement) == SQLITE_ROW){
				row = sqlite3_column_int(statement, 0);
			}
		}
		[query release];
		
		connected.hidden = FALSE;
		notConnected.hidden = FALSE;
		
		if(prevRow == row){
			connected.hidden = TRUE;
		}
		else 
			notConnected.hidden = TRUE;
		
		prevRow = row;
		
		query = [[NSString alloc] initWithFormat:@"Select p from FLIGHTDATA where id=%d;",row];
		sqlite3_stmt *newstatement;
		int rc = sqlite3_prepare_v2(db, [query UTF8String], -1, &newstatement, nil);
		int sc = 999;
		if(rc == SQLITE_OK){
			sc = sqlite3_step(newstatement);
				//if (sc == SQLITE_ROW){
			row = sqlite3_column_int(newstatement, 0);
				//}
		}
		
			//status.text = [NSString stringWithFormat: @"-->%d", row];
		
		[query release];
		
		newstatement = nil;
		[myLock unlock];
	}
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDisplay) userInfo:nil repeats:NO];	
}

- (void) checkForIncomingData
{
		//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		////status.text = [NSString stringWithFormat:@"Listening at id:%d", sockfd];
	struct sockaddr_in aircraftAddr;
	socklen_t len;	
	
	struct UAVSTATE{
		double x,y,z;	//position
		double u,v,w;	//velocity
		double a,b,c;	//altitude
		double p,q,r;	//rotating
		
		double acx, acy, acz; //acelerate along x,y,z
		double acp, acq, acr;
		
		double ug, vg, wg;	//velocity in user ground frame
		double longitude, latitude, altitude;
		
		double as, bs, rfb; //observable variables
		
		int imagePackets;
		
	} *currentDataNew;
	currentDataNew = malloc(sizeof(struct UAVSTATE));
	
	memset(currentDataNew, 0, sizeof(struct UAVSTATE));
	
		//UAVAppDelegate *mainDelegate = (UAVAppDelegate *) [[UIApplication sharedApplication] delegate];
		//NSData *imageData;
	char fullbuffer[50000]; //50kb pic size. MAX.
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	

	char buffer[1000];
	for(;;)
	{
//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		NSLog(@"startof");
		recvfrom(sockfd, currentDataNew, sizeof(struct UAVSTATE), 0, (struct sockaddr *)&aircraftAddr, &len);
			//	printf("p:%d l:%.4f\n", currentDataNew->imagePackets, currentDataNew->longitude);
			//limit of packet size is 50kb = 50*1000 => 50 packets. more than that means error, throw.
		while (currentDataNew->imagePackets > 50 || currentDataNew->imagePackets < 0){
				//error packet
				//	printf("error packet p: %d\n", currentDataNew->imagePackets);
			recvfrom(sockfd, currentDataNew, sizeof(struct UAVSTATE), 0, (struct sockaddr *)&aircraftAddr, &len);
				//	printf("echk:p:%d l:%.4f\n", currentDataNew->imagePackets, currentDataNew->longitude);
				//keep receiving the correct packet.
				
		}
		if (currentDataNew->imagePackets > 0){		
			
			int countpackets = 0;
			while(currentDataNew->imagePackets--){
				countpackets++;
				if(recvfrom(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&aircraftAddr, &len) == -1){
					countpackets = 5;
				}
				if(countpackets == 1)
					memcpy(fullbuffer, buffer, sizeof(buffer));
					//					sprintf(fullbuffer, "%s", buffer);
				else {
					memcpy(fullbuffer+(sizeof(buffer)*(countpackets-1)), buffer, sizeof(buffer));
				}
				
			}

				//imageData = [NSData dataWithBytes:fullbuffer length:(countpackets*sizeof(buffer))];
			
				//mainDelegate.image = imageData;	
		}
		NSLog(@"mid");
			
		
		if ([myLock tryLock])
		{
			NSString *createSQL;
			char *errorMsg;
			createSQL = [[NSString alloc]initWithFormat:@"INSERT INTO FLIGHTDATA ("
						 "x,y,z,"
						 "u,v,w,"
						 "a,b,c,"
						 "p,q,r,"
						 "acx, acy, acz,"
						 "acp, acq, acr,"
						 "ug, vg, wg,"
						 "longitude, latitude, altitude,"
						 "'as', bs, rfb"
						 ")" 
						 "Values (%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f);", 
						 currentDataNew->x, currentDataNew->y, currentDataNew->z, 
						 currentDataNew->u, currentDataNew->v, currentDataNew->w,  
						 currentDataNew->a, currentDataNew->b, currentDataNew->c, 
						 currentDataNew->p, currentDataNew->q, currentDataNew->r,  
						 currentDataNew->acx, currentDataNew->acy, currentDataNew->acz, 
						 currentDataNew->acp, currentDataNew->acq, currentDataNew->acr,  
						 currentDataNew->ug, currentDataNew->vg, currentDataNew->wg, 
						 currentDataNew->longitude, currentDataNew->latitude, currentDataNew->altitude, 
						 currentDataNew->as, currentDataNew->bs, currentDataNew->rfb];
			NSLog(@"bexe");
	//		[createSQL UTF8String];
	//		db;
			NSLog(@"cexe");
			sqlite3_exec(db, [createSQL UTF8String], NULL,NULL, &errorMsg);
			NSLog(@"aexe");
			[createSQL release];
			[myLock unlock];
		}
		NSLog(@"endof");
	//	[pool drain];

		
	}
	
	[pool release];
}

@end
