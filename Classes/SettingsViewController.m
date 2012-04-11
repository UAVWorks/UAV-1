/// as of feb 2012
#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize connectSwitch;
@synthesize listenSwitch;
@synthesize imageIP;
@synthesize gcsIP;
@synthesize consoleInput;
@synthesize dataPort;
@synthesize imageIPTextField;
@synthesize imagePortTextField;
@synthesize dataPortTextField;
@synthesize viewControllersFull;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
#if !(TARGET_IPHONE_SIMULATOR)
    InitAddresses();
	GetHWAddresses();
	GetIPAddresses();
	defaultConnectedText = [NSString stringWithFormat:@"GCS IP: %s", ip_names[1]];
    [UAV sharedInstance].uavIP = [NSString stringWithFormat:@"%s", ip_names[1]];
	gcsIP.text = defaultConnectedText;
#else
	gcsIP.text = @"GCS IP: Not supported on simulator";
#endif
	
	//attempt to initiate connection to the UAV. 
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:/%@", [UAV sharedInstance].uavIP]] 
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:0.5];
	
	[[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	
	[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(ping) userInfo:nil repeats:YES];
	
	sqlArray = [[NSMutableArray array] retain];
	[self performSelectorInBackground:@selector(insertSQL:) withObject:@""];
	
	
	self.viewControllersFull = [[self tabBarController] viewControllers];
    
	[super viewDidLoad];
	[[UAV sharedInstance] removeSpinner];
}

- (void)ping{
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:/%@", [UAV sharedInstance].uavIP]] 
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:0.5];
	
	[[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	NSLog(@"data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	//NSLog(@"%@, %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	if ([[error localizedDescription] isEqualToString:@"Could not connect to the server."]) {
		//NSLog(@"Ping successful");
		[UAV sharedInstance].uavFound = YES;
	} else {
		//NSLog(@"Ping unsuccessful");
		[UAV sharedInstance].uavFound = NO;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ping" object:nil ];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
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
//connect to UAV
- (IBAction) connectSwitchToggled: (id)sender{	
//    if (![imageIPTextField.text isEqualToString:@""] && ![imagePortTextField.text isEqualToString:@""])
//    {
//        /// if the switch is on, create a socket and bind it
//        if (connectSwitch.on)         
//        {
//            int rv;
//            struct sockaddr_in remoteAddr;
//            imagesockfd = socket(AF_INET, SOCK_DGRAM, 0);
//            ///returns -1 if socket creation fails
//            if (imagesockfd == -1)
//            {
//                gcsIP.text = @"UAV IP/Port: (cannot create socket)";
//                [connectSwitch setOn:false];
//                return;
//            }
//            ///zero all & bind socket
//            bzero(&remoteAddr, sizeof(remoteAddr));
//            remoteAddr.sin_family = AF_INET;
//            inet_pton(AF_INET, [imageIPTextField.text UTF8String] , &(remoteAddr.sin_addr));
//            //remoteAddr.sin_addr.s_addr = htonl(INADDR_ANY);
//            remoteAddr.sin_port = htons([imagePortTextField.text intValue]);
//            rv = bind(datasockfd, (struct sockaddr *)&remoteAddr, sizeof(remoteAddr));
//            if (rv == -1)
//            {
//                close(datasockfd);
//                gcsIP.text = @"UAV IP/Port: (bind fail)";
//                [connectSwitch setOn:false];
//                return;
//            } else {
//                gcsIP.text = [NSString stringWithFormat:@"UAV IP/Port: %@/%@", imageIPTextField.text, imagePortTextField.text];
//            }
//            
//            // create and initialize a mutex lock that control access to shared data between threads		
//            // create a thread to monitor incoming data and a thread to update the display
//            [NSThread detachNewThreadSelector:@selector(checkForIncomingImage) toTarget:self withObject:nil];	
//            
//            ///disable the port textfield
//            imageIPTextField.enabled = imagePortTextField.enabled =  NO;
//            NSLog(@"create sockfd : %d",imagesockfd);
//        }	
//        else // close the socket to terminate the connection
//        {
//            close(imagesockfd);
//            gcsIP.text = @"UAV IP/Port: (closed)";
//            imageIPTextField.enabled = imagePortTextField.enabled =  YES;
//            NSLog(@"close sockfd : %d",imagesockfd);
//        }
//    }
    if (![imagePortTextField.text isEqualToString:@""])
    {
        /// if the switch is on, create a socket and bind it
        if (connectSwitch.on)         
        {
            int rv;
            int sockfd;
            struct sockaddr_in remoteAddr;
            sockfd = socket(AF_INET, SOCK_STREAM, 0);
            ///returns -1 if socket creation fails
            if (sockfd == -1)
            {
                imageIP.text = @"UAV IP/Port: (cannot create socket)";
                [connectSwitch setOn:false];
                return;
            }
            ///zero all & bind socket            
            bzero(&remoteAddr, sizeof(remoteAddr));
            remoteAddr.sin_family = AF_INET;
            remoteAddr.sin_addr.s_addr = htonl(INADDR_ANY);
            remoteAddr.sin_port = htons([imagePortTextField.text intValue]);
            rv = bind(sockfd, (struct sockaddr *)&remoteAddr, sizeof(remoteAddr));
            if (rv == -1)
            {
                close(sockfd);
                imageIP.text = @"UAV IP/Port: (bind fail)";
                [connectSwitch setOn:false];
                return;
            } 
            imageIP.text = @"UAV IP/Port: (listening)";
            listen(sockfd,5);
            
            int len = sizeof(remoteAddr);
            imagesockfd = accept(sockfd, (struct sockaddr *) &remoteAddr, &len);
            if (imagesockfd == -1)            
            {
                imageIP.text = @"UAV IP/Port: (listen fail)";
            }
            else 
            {
                imageIP.text = [NSString stringWithFormat:@"UAV IP/Port: %@/%@", imageIPTextField.text, imagePortTextField.text];
            }
            
            // create and initialize a mutex lock that control access to shared data between threads		
            // create a thread to monitor incoming data and a thread to update the display
            [NSThread detachNewThreadSelector:@selector(checkForIncomingImage) toTarget:self withObject:nil];	
            
            ///disable the port textfield
            imageIPTextField.enabled = imagePortTextField.enabled =  NO;
            NSLog(@"create sockfd : %d",imagesockfd);
        }	
        else // close the socket to terminate the connection
        {
            close(imagesockfd);
            imageIP.text = @"UAV IP/Port: (closed)";
            imageIPTextField.enabled = imagePortTextField.enabled =  YES;
            NSLog(@"close sockfd : %d",imagesockfd);
        }
    }
}

- (void) checkForIncomingImage
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    struct sockaddr_in remoteAddr;
    socklen_t len;	
    
    struct IMAGEHEADER *currentImageHeader = malloc((sizeof(struct IMAGEHEADER)));
        
    int rv = 0;
    char buffer[1400];
    bool imageNow = false;
    short currentWidth;
    short currentHeight;
    //check if sock exist or receiving is incorrect
    while(imagesockfd != -1 && rv != -1)
    {
        NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
        if (imageNow == false)
            memset(currentImageHeader, 0, sizeof(struct IMAGEHEADER));
//        rv = recvfrom(imagesockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&remoteAddr, &len);
        rv = recv(imagesockfd, buffer, sizeof(buffer), 0);
        if (rv != -1)
        {
            //bufferOutput.text = [NSString stringWithFormat:@"rv:%d", rv];
            short currentCode;
            memset(&currentCode, 0, sizeof(short));
            memcpy(&currentCode, buffer+4, sizeof(short));
            if (currentCode == COMMAND_IMAGE)
            {
                NSLog(@"headerv:%d", rv);
                imageNow = true;
                //content values
                //            char ufrom;
                //            char uto;
                //            short usize;
                short currentCode;
                //            short index;
                //            memcpy(&ufrom, buffer, sizeof(char));
                //            memcpy(&uto, buffer+1, sizeof(char));
                //            memcpy(&usize, buffer+2, sizeof(short));
                memset(&currentCode, 0, sizeof(short));
                memcpy(&currentCode, buffer+4, sizeof(short));
                memset(&currentWidth, 0, sizeof(short));
                memcpy(&currentWidth, buffer+8, sizeof(short));
                memset(&currentHeight, 0, sizeof(short));
                memcpy(&currentHeight, buffer+10, sizeof(short));
                //            memcpy(&index, buffer+6, sizeof(short));                
            }
            else  //receiving image now
            {
                
                NSLog(@"imagerv:%d", rv);
                imageNow = false;
                ImageProcessingImpl *ImageProc;
                
                UIImage* processedImage = [ImageProc decompressImage:buffer withSize:sizeof(buffer) withHeight:currentHeight withWidth:currentWidth];
                
                [NSThread detachNewThreadSelector:@selector(updateFullImage:) toTarget:self withObject:processedImage];                
                [self performSelectorInBackground:@selector(updateFullImage:) withObject:processedImage];
                [self performSelectorOnMainThread:@selector(postNotificationToUI) withObject:nil waitUntilDone:NO];
            }
        }
        [pool2 drain];
        
    }
    
    [pool drain];
}

- (IBAction) listenSwitchToggled: (id)sender{	
	if (![dataPortTextField.text isEqualToString:@""])
    {
        /// if the switch is on, create a socket and bind it
        if (listenSwitch.on)         
        {
            int rv;
            struct sockaddr_in remoteAddr;
            datasockfd = socket(AF_INET, SOCK_DGRAM, 0);
            ///returns -1 if socket creation fails
            if (datasockfd == -1)
            {
                dataPort.text = @"UAV Broadcast Port: (bind fail)";
                [listenSwitch setOn:false];
                return;
            }
            ///zero all & bind socket
            bzero(&remoteAddr, sizeof(remoteAddr));
            remoteAddr.sin_family = AF_INET;
            remoteAddr.sin_addr.s_addr = htonl(INADDR_ANY);
            remoteAddr.sin_port = htons([dataPortTextField.text intValue]);
            rv = bind(datasockfd, (struct sockaddr *)&remoteAddr, sizeof(remoteAddr));
            if (rv == -1)
            {
                close(datasockfd);
                dataPort.text = @"UAV Broadcast Port: (bind fail)";
                [listenSwitch setOn:false];
                return;
            } else {
                dataPort.text = [NSString stringWithFormat:@"UAV Broadcast Port: %@", dataPortTextField.text];
            }
            
            // create and initialize a mutex lock that control access to shared data between threads		
            // create a thread to monitor incoming data and a thread to update the display
            [NSThread detachNewThreadSelector:@selector(checkForIncomingData) toTarget:self withObject:nil];	
            
            ///disable the port textfield
            dataPortTextField.enabled = NO;
            NSLog(@"create sockfd : %d",datasockfd);
        }	
        else // close the socket to terminate the connection
        {
            close(datasockfd);
            dataPort.text = @"UAV Broadcast Port: (closed)";	
            dataPortTextField.enabled = YES;
            NSLog(@"close sockfd : %d",datasockfd);
        }
    }
}

- (void) checkForIncomingData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    struct sockaddr_in remoteAddr;
    socklen_t len;	
    
    struct SVODATA *currentSVOData = malloc(sizeof(struct SVODATA));
    struct UAVSTATE *currentUAVState = malloc(sizeof(struct UAVSTATE));
    struct TELEGRAPH *currentTelegraph = malloc((sizeof(struct TELEGRAPH)));
    
    memset(currentSVOData, 0, sizeof(struct SVODATA));
    memset(currentUAVState, 0, sizeof(struct UAVSTATE));
    memset(currentTelegraph, 0, sizeof(struct TELEGRAPH));
    
    BOOL checkFirstPacket = YES;
    
    int rv = 0;
    char buffer[1400];
    
    //check if sock exist or receiving is incorrect
    while(datasockfd != -1 && rv != -1)
    {
        NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
        
        memset(currentTelegraph, 0, sizeof(struct TELEGRAPH));
        rv = recvfrom(datasockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&remoteAddr, &len);
        
        if (rv != -1)
        {
            NSLog(@"rv:%d", rv);
            memcpy(currentTelegraph, buffer, rv);
            
            if(checkFirstPacket)
            {
                checkFirstPacket = 0;
                [UAV sharedInstance].firstPacketDate = [[NSDate date] retain];
            }
            
            //content values
//            char ufrom;
//            char uto;
//            short usize;
            short currentCode;
//            double utime;
//            memcpy(&ufrom, buffer, sizeof(char));
//            memcpy(&uto, buffer+1, sizeof(char));
//            memcpy(&usize, buffer+2, sizeof(short));
            memset(&currentCode, 0, sizeof(short));
            memcpy(&currentCode, buffer+4, sizeof(short));
//            memcpy(&utime, buffer+6, sizeof(double));
            if (currentCode == DATA_STATE)
            {
                memcpy(currentUAVState, buffer+14	, sizeof(struct UAVSTATE));
//                NSString *createSQL;
//                createSQL = [[NSString alloc]initWithFormat:@"INSERT INTO FLIGHTDATA ("
//                             "x,y,z,"
//                             "u,v,w,"
//                             "a,b,c,"
//                             "p,q,r,"
//                             "acx, acy, acz,"
//                             "acp, acq, acr,"
//                             "ug, vg, wg,"
//                             "longitude, latitude, altitude,"
//                             "'as', bs, rfb"
//                             ")" 
//                             "Values (%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f);", 
//                             currentUAVState->x, currentUAVState->y, currentUAVState->z, 
//                             currentUAVState->u, currentUAVState->v, currentUAVState->w,  
//                             currentUAVState->a, currentUAVState->b, currentUAVState->c, 
//                             currentUAVState->p, currentUAVState->q, currentUAVState->r,  
//                             currentUAVState->acx, currentUAVState->acy, currentUAVState->acz, 
//                             currentUAVState->acp, currentUAVState->acq, currentUAVState->acr,  
//                             currentUAVState->ug, currentUAVState->vg, currentUAVState->wg, 
//                             currentUAVState->longitude, currentUAVState->latitude, currentUAVState->altitude, 
//                             currentUAVState->as, currentUAVState->bs, currentUAVState->rfb];
//
//                NSLog(@"test: longitude: %f", currentUAVState->longitude);
//                [NSThread detachNewThreadSelector:@selector(insertSQL:) toTarget:self withObject:createSQL];	
//                
//                [sqlArray addObject:createSQL];
                [NSThread detachNewThreadSelector:@selector(updateFullData:) toTarget:self withObject:[[UAV sharedInstance] convertDataToObject:currentUAVState]];                
                [self performSelectorInBackground:@selector(updateFullData:) withObject:[[UAV sharedInstance] convertDataToObject:currentUAVState]];
                
                [self performSelectorOnMainThread:@selector(postNotificationToUI) withObject:nil waitUntilDone:NO];
//                [createSQL release];
            }
        }
        [pool2 drain];
        
    }
    
    [pool drain];
}

-(void) writeImage:(NSMutableArray*)arr{
	[[arr objectAtIndex:0] writeToFile:	[arr objectAtIndex:1] atomically:NO];
	
}
-(void) postNotificationToUI{
	
	/*generate notification here, on main thread*/
	[[NSNotificationCenter defaultCenter] postNotificationName:@"settings" object:[[UAV sharedInstance] getLatestRowData]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:[[UAV sharedInstance] getLatestImageData]];
}

-(void) updateFullImage:(id) object{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UAV *uav = [UAV sharedInstance];
    [uav.fullImageLock lock];
    if ([uav.fullImage count] == 3){
        [uav.fullImage removeObject:0];
    }
	[uav.fullImage addObject:object] ;
	[uav.fullImageLock unlock];
	
	[pool drain];
}


-(void) updateFullData:(id) object{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UAV *uav = [UAV sharedInstance];
	[uav.fullDataLock lock];
	if ([uav.fullData count] == GRAPHLIMIT){
		[uav.fullData removeObjectAtIndex:0];
	}
	[uav.fullData addObject:object] ;
	[uav.fullDataLock unlock];
	
	[pool drain];
}

-(void) insertSQL:(NSString*) sql{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//	NSMutableArray *durationArray = [NSMutableArray array];
	while (1) {
		NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
		if ([sqlArray count]) {
			UAV *uav = [UAV sharedInstance];
			//			NSDate *startDate = [NSDate date];
			[uav.sqlLock lock];
			sqlite3_exec(uav.db, [[sqlArray objectAtIndex:0] UTF8String], NULL,NULL, NULL);
			[uav.sqlLock unlock]; 
			//			NSTimeInterval duration = [startDate timeIntervalSinceNow] * -1;
			//			NSNumber *num = [NSNumber numberWithDouble:duration];
			//			[durationArray addObject:num];
			//			if ([durationArray count] == 500) {
			//				NSLog(@"%@", durationArray);
			//			}
			[sqlArray removeObjectAtIndex:0];
		}
		[pool2 release];
	}
	
	[pool drain];
	
}

-(IBAction) viewJpeg:(id) sender{
	//	[[UIPopoverController alloc] initWithContentViewController:[[ImageViewController alloc] init] ];
	UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:[[[ImageViewController alloc] init] autorelease]] ;
	[pop presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
	pop.popoverContentSize = CGSizeMake(600, 240.0/320*600);
}

-(IBAction) sendData:(id) sender{
	
	if(![[UAV sharedInstance] parseAndSendCommand:[sender text]]){
		UIAlertView *alert = [[[UIAlertView alloc] 
							   initWithTitle:@"Invalid Command" 
							   message:@"Please check your command!" 
							   delegate:self
							   cancelButtonTitle:@"Ok" 
							   otherButtonTitles:nil] autorelease];
		[alert show];
	}
	
	else 
		consoleInput.text = @"";
	
}

- (IBAction) emailData: (id) sender{
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc ] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"UAV"];
	[controller setMessageBody:@"As attached." isHTML:NO];
	
	NSString *path = [UAV sharedInstance].SQLFileName;
	NSData *data  = [NSData dataWithContentsOfFile:path];
	[controller addAttachmentData:data mimeType:@"application/octet-stream" fileName:[[path lastPathComponent] stringByDeletingPathExtension]];
	
	
	[self presentModalViewController:controller animated:YES];
	//NSLog(@"displayed");
	
}

- (IBAction) deleteAllJPG: (id) sender{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//Consolidate all the files in the Documents directory. 
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
	
	int countjpg = 0;
	int count = [files count];
	for (int i=0; i < count ; i++) {
		if ([[[files objectAtIndex:i] pathExtension] isEqualToString:@"jpg"])	{
			countjpg++;
			//NSLog(@"%@", [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], [files objectAtIndex:i] ]);
			
			[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0], [files objectAtIndex:i]] error:nil];
		}
	}
	
	[[[[UIAlertView alloc]  initWithTitle:@"JPEGs Deletion" message:[NSString stringWithFormat:@"%d files deleted", countjpg] delegate:self cancelButtonTitle:@"Ok"  otherButtonTitles:nil] autorelease] show];
}


- (void)renameCalibrateCamera:(UIButton *)btn{
	[btn setTitle:@"Calibrate Cam" forState:UIControlStateNormal];
	btn.enabled = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	return [[UAV sharedInstance].consoleCommandShortcuts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Configure each individual cell of the table.
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//Show filename
	cell.textLabel.text = [[UAV sharedInstance].consoleCommandShortcuts objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//indexPath row is selected
	BOOL rv = [[UAV sharedInstance] parseAndSendCommand:[[UAV sharedInstance].consoleCommandShortcuts objectAtIndex:[indexPath row]]];
	if (!rv) {
		[[[[UIAlertView alloc]  initWithTitle:@"Problem! Can't Send:" message:[[UAV sharedInstance].consoleCommandShortcuts objectAtIndex:[indexPath row]] delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:nil] autorelease] show];
	} else {
		
		UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1282981803_Check.png"]] ;
		image.alpha = 0;
		image.center = self.view.center;
		[self.view addSubview:image];
		
		
		[UIView animateWithDuration:0.1 animations:^(void) {
			image.alpha = 1;
		} completion:^(BOOL finished){
			[UIView animateWithDuration:0.1 animations:^(void) {
				image.alpha = 0;
			} completion:^(BOOL finished){
				[image removeFromSuperview];
				[image release];
			}];
		}];
	}
	
}
#pragma mark MFMailComposeView Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[controller dismissModalViewControllerAnimated:YES];
	if (result == MFMailComposeResultSent) {
		NSLog(@"sent");
	}
	else if	(result == MFMailComposeResultSaved){
		NSLog(@"saved");
	}
	else if (result == MFMailComposeResultFailed){
		NSLog(@"%@", error);
		NSLog(@"failed");
	}
	else {
		NSLog(@"gg");
	}
	
}

- (void)drawCoordinates:(id) obj{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"plotCoordinates" object:obj];
}
@end
