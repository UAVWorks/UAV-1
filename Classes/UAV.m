#import "UAV.h"

static UAV *sharedInstance = nil;

@implementation UAV

@synthesize db;
@synthesize sqlLock;
@synthesize fullImageLock;
@synthesize fullDataLock;
@synthesize liveImage;
@synthesize image;
@synthesize newest600Data;
@synthesize latestTelegraph;
@synthesize latestData;
@synthesize fullData;
@synthesize fullImage;
@synthesize firstPacketDate;
@synthesize uavIP;
@synthesize consoleCommandShortcuts;
@synthesize activityIndicator;
@synthesize graphIsZoomed;
@synthesize packetImproper;
@synthesize uavFound;
@synthesize autoMode;
@synthesize SQLFileName;
@synthesize currentUAVType;
#pragma mark -
#pragma mark SQL DB Methods

- (id) init{
	//auto Mode = TRUE;
	autoMode = TRUE;
	sqlLock = [[NSLock alloc] init];
	fullImageLock = [[NSLock alloc] init];
	fullDataLock = [[NSLock alloc] init];
	uavIP = [NSString stringWithString:@"192.168.1.3"];
    //ENDTODO
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	fullData = [[NSMutableArray array] retain];
	fullImage = [[NSMutableArray array] retain];
	for(int i=0;i<1;i++){
		UAVSTRUCT *uav = [[UAVSTRUCT alloc] init] ;
		uav.x = 0.00;
		uav.y = 0.00;
		uav.z = 0.00;
		
		uav.u = 0.00;
		uav.v = 0.00;
		uav.w = 0.00;
		
		uav.a = 0.00;
		uav.b = 0.00;
		uav.c = 0.00;
		
		uav.p = 0.00;
		uav.q = 0.00;
		uav.r = 0.00;
		
		uav.acx = 0.00;
		uav.acy = 0.00;
		uav.acz = 0.00;
		
		uav.acp = 0.00;
		uav.acq = 0.00;
		uav.acr = 0.00;
		
		uav.ug = 0.00;
		uav.vg = 0.00;
		uav.wg = 0.00;
		
		uav.longitude = 0.00;
		uav.latitude = 0.00;
		uav.altitude = 0.00;
		
		uav.as = 0.00;
		uav.bs = 0.00;
		uav.rfb = 0.00;
		
		[fullData addObject:uav];
	}
    
	
	consoleCommandShortcuts = [[[NSArray alloc] initWithObjects:
								
								@"Hover(0)", 
								@"Forward(0)", 
								@"Backward(0)", 
								@"Roll left(0)", 
								@"Roll right(0)", 
								@"Yaw left(0)", 
								@"Yaw right(0)", 
								@"Drop object", 
								@"Close object servo",
								@"Elevate",
								@"Descend", 
								@"Manual Mode", 
								@"Auto Mode", 
								
								nil] retain];
	
	
	sendsockfd = socket(AF_INET, SOCK_DGRAM, 0);
	
	currentUAVType = kUAVTypeMerlion;
	
	return self;
}

- (NSString *)dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	int i = 1;
	while ([[NSFileManager defaultManager] fileExistsAtPath:[[documentsDirectory stringByAppendingPathComponent:kSQLFileName] stringByAppendingFormat:@"%d.sql", i]]) {
		i++;
	}
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:i];
	
	
	
	self.SQLFileName = [[documentsDirectory stringByAppendingPathComponent:kSQLFileName] stringByAppendingFormat:@"%d.sql", i];
	return SQLFileName;
	
	//[paths release];
	
	
}
-(void) createSQL{
	int sc = sqlite3_open([[self dataFilePath] UTF8String], &db); 
	if (sc != SQLITE_OK) {
		sqlite3_close(db);
		
	}
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FLIGHTDATA ("
	"id integer primary key,"
	"x real, y real, z real,"
	"u real, v real, w real,"
	"a real, b real, c real,"
	"p real, q real, r real,"
	"acx real, acy real, acz real,"
	"acp real, acq real, acr real,"
	"ug real, vg real, wg real,"
	"longitude real, latitude real, altitude real,"
	"'as' real, bs real, rfb real);";
	NSString *insertSQL = @"INSERT INTO FLIGHTDATA (x,y,z,u,v,w,a,b,c,p,q,r,acx,acy,acz,acp,acq,acr,ug,vg,wg,longitude, latitude, altitude, 'as', bs, rfb) VALUES(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);";
	sqlite3_exec (db, [createSQL UTF8String], NULL, NULL, NULL);
	
	sqlite3_exec(db, [insertSQL UTF8String], NULL, NULL, NULL);
	
	[createSQL release];
	[insertSQL release];
	
}

-(NSMutableArray*) getLatestRowData {
	
	NSMutableArray *results;
	
	results = [[NSMutableArray array] retain]; //results is released after been printed on screen.
	[sqlLock lock];
	
	UAVSTRUCT* uav = [[UAV sharedInstance].fullData lastObject] ;
	
	[results addObject:[NSNumber numberWithDouble:uav.x]];
	[results addObject:[NSNumber numberWithDouble:uav.y]];
	[results addObject:[NSNumber numberWithDouble:uav.z]];
	
	[results addObject:[NSNumber numberWithDouble:uav.u]];
	[results addObject:[NSNumber numberWithDouble:uav.v]];
	[results addObject:[NSNumber numberWithDouble:uav.w]];
	
	[results addObject:[NSNumber numberWithDouble:uav.a]];
	[results addObject:[NSNumber numberWithDouble:uav.b]];
	[results addObject:[NSNumber numberWithDouble:uav.c]];
	
	[results addObject:[NSNumber numberWithDouble:uav.p]];
	[results addObject:[NSNumber numberWithDouble:uav.q]];
	[results addObject:[NSNumber numberWithDouble:uav.r]];
	
	[results addObject:[NSNumber numberWithDouble:uav.acx]];
	[results addObject:[NSNumber numberWithDouble:uav.acy]];
	[results addObject:[NSNumber numberWithDouble:uav.acz]];
	
	[results addObject:[NSNumber numberWithDouble:uav.acp]];
	[results addObject:[NSNumber numberWithDouble:uav.acq]];
	[results addObject:[NSNumber numberWithDouble:uav.acr]];
	
	[results addObject:[NSNumber numberWithDouble:uav.ug]];
	[results addObject:[NSNumber numberWithDouble:uav.vg]];
	[results addObject:[NSNumber numberWithDouble:uav.wg]];
	
	[results addObject:[NSNumber numberWithDouble:uav.longitude]];
	[results addObject:[NSNumber numberWithDouble:uav.latitude]];
	[results addObject:[NSNumber numberWithDouble:uav.altitude]];
	
	[results addObject:[NSNumber numberWithDouble:uav.as]];
	[results addObject:[NSNumber numberWithDouble:uav.bs]];
	[results addObject:[NSNumber numberWithDouble:uav.rfb]];
	[sqlLock unlock];
	//return results;
	
	return results;
}

-(UIImage*) getLatestImageData {
		
	return (UIImage*) [[UAV sharedInstance].fullImage lastObject] ;
}

-(BOOL) parseAndSendCommand:(NSString *)string{
	
	struct COMMAND cmd;
	BOOL isPayloadCmd=NO;
	
	//NSLog(@"command:%@", string);
	
	if ([string isEqualToString:@""]) {
		return false;
	}
	NSArray *result = [string componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
	
	NSLog(@"%@", result);
	if([result count] == 1){
		if ([string isEqualToString:@"quit"]) {
			cmd.code = COMMAND_QUIT;
		}
		else if ([string isEqualToString:@"run"]){
			cmd.code = COMMAND_RUN;
		}
		else if ([string isEqualToString:@"forward"]){
			cmd.code = kCommandMerlion_FORWARD;
		}
		else if ([string isEqualToString:@"Drop object"]) {
			cmd.code = kCommandMerlion_DROPPAYLOAD;
			isPayloadCmd = YES;
		} 
		else if ([string isEqualToString:@"Close object servo"]){
			cmd.code = kCommandMerlion_CLOSEPAYLOAD;
			isPayloadCmd = YES;
		}
		else if ([string isEqualToString:@"Auto Mode"]){
			cmd.code = kCommandMerlion_MODEAUTO;
			autoMode = 1;
		} else if ([string isEqualToString:@"Manual Mode"]) {
			cmd.code = kCommandMerlion_MODEMANUAL;
			autoMode = 0;
		} 
		else {
			return false;
		}		
	}
	else {
		//have to use result, since already tokenized.
		NSString *command = [result objectAtIndex:0];
		if ([command isEqualToString:@"run"]){
			NSLog(@"decode: run with %@\n", [result objectAtIndex:1]);
			
			if([result count] != 1+2){
				return false;
			}
			cmd.code = COMMAND_RUN;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"path"]){
			if([result count] != 1+2){
				return false;
			}
			
			cmd.code = COMMAND_PATH;
			
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		
		else if ([command isEqualToString:@"backward"]){
			cmd.code = kCommandMerlion_BACKWARD;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"rotateLeft"]){
			cmd.code = kCommandMerlion_YAW_LEFT;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"rotateRight"]){
			cmd.code = kCommandMerlion_YAW_RIGHT;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"rollLeft"]){
			cmd.code = kCommandMerlion_ROLL_LEFT;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"rollRight"]){
			cmd.code = kCommandMerlion_ROLL_RIGHT;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"elevate"]){
			cmd.code = kCommandMerlion_ELEVATE;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"descend"]){
			cmd.code = kCommandMerlion_DESCEND;
			*(int *)cmd.parameter = [[result objectAtIndex:1]intValue];
		}
		else if ([command isEqualToString:@"calibrate"]){
			cmd.code = kCommandMerlion_MODECALIBRATE; 
			isPayloadCmd = YES;
			int count = [result count];
			for (int j=0; j<count-2; j++) {
				cmd.parameter[j] = [[result objectAtIndex:j+1] intValue];
			}
			
		} else if ([command isEqualToString:@"calibrateLive"]) {
			cmd.code = kCommandMerlion_MODELIVECALIBRATE;
			isPayloadCmd = YES;
			int count = [result count];
			for (int j=0; j<count-2; j++) {
				cmd.parameter[j] = [[result objectAtIndex:j+1] intValue];
			}
			
		} else if ([command isEqualToString:@"Elevate"]){
			cmd.code = kCommandMerlion_ELEVATE;
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
		}  else if ([command isEqualToString:@"Descend"]){
			cmd.code = kCommandMerlion_DESCEND;
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
		} 
		else if ([command isEqualToString:@"Forward"]){
			cmd.code = kCommandMerlion_FORWARD;
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
		} else if ([command isEqualToString:@"Backward"]){
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
			cmd.code = kCommandMerlion_BACKWARD;
		} else if ([command isEqualToString:@"Roll left"]){
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
			cmd.code = kCommandMerlion_ROLL_LEFT;
		} else if ([command isEqualToString:@"Roll right"]){
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
			cmd.code = kCommandMerlion_ROLL_RIGHT;
		} else if ([command isEqualToString:@"Yaw left"]) {
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
			cmd.code = kCommandMerlion_YAW_LEFT;
		} else if ([command isEqualToString:@"Yaw right"]) {
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
			cmd.code = kCommandMerlion_YAW_RIGHT;
		} else if ([command isEqualToString:@"Hover"]) {
			cmd.code = kCommandMerlion_HOVER;
			cmd.parameter[0] = [[result objectAtIndex:1] intValue];
		}
		else {
			return false;
		}
	}
	int rv = sendto(sendsockfd, &cmd, sizeof(struct COMMAND), 0, (struct sockaddr*)&UAVAddr, sizeof(UAVAddr));
	
	if (isPayloadCmd) {
		sendto(sendsockfd, &cmd, sizeof(struct COMMAND), 0, (struct sockaddr*)&UAVAddr, sizeof(UAVAddr));
		sendto(sendsockfd, &cmd, sizeof(struct COMMAND), 0, (struct sockaddr*)&UAVAddr, sizeof(UAVAddr));
		sendto(sendsockfd, &cmd, sizeof(struct COMMAND), 0, (struct sockaddr*)&UAVAddr, sizeof(UAVAddr));
		sendto(sendsockfd, &cmd, sizeof(struct COMMAND), 0, (struct sockaddr*)&UAVAddr, sizeof(UAVAddr));
		
	}
	
	if (rv == -1) {
		NSLog(@"Sending failed");
		return false;
	}
	
	return true;
}

- (void)removeSpinner{
	
	if ([activityIndicator isAnimating]) {
		[activityIndicator stopAnimating];
	}
	if ([activityIndicator superview] != nil) {
		[activityIndicator removeFromSuperview];
	}
}

- (NSObject*)convertDataToObject:(const struct UAVSTATE*)current{
	UAVSTRUCT *uav = [[[UAVSTRUCT alloc] init] autorelease];
	uav.x = current->x;
	uav.y = current->y;
	uav.z = current->z;
	
	uav.u = current->u;
	uav.v = current->v;
	uav.w = current->w;
	
	uav.a = current->a;
	uav.b = current->b;
	uav.c = current->c;
	
	uav.p = current->p;
	uav.q = current->q;
	uav.r = current->r;
	
	uav.acx = current->acx;
	uav.acy = current->acy;
	uav.acz = current->acz;
	
	uav.acp = current->acp;
	uav.acq = current->acq;
	uav.acr = current->acr;
	
	uav.ug = current->ug;
	uav.vg = current->vg;
	uav.wg = current->wg;
	
	uav.longitude = current->longitude;
	uav.latitude = current->latitude;
	uav.altitude = current->altitude;
	
	uav.as = current->as;
	uav.bs = current->bs;
	uav.rfb = current->rfb;
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"A"];
	
    ///TODO
//	NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
//	[f setNumberStyle:NSNumberFormatterDecimalStyle];
//	NSNumber *myNumber = [f numberFromString:[formatter stringFromDate: [NSDate date]]];
//	
//	NSNumber *originalNumber = [f numberFromString:[formatter stringFromDate: firstPacketDate]];
//	
//	uav.ms = ([myNumber intValue] - [originalNumber intValue])/1000;
	
	return uav;
}

- (NSMutableArray*)graphData{
	if (graphIsZoomed) {
		[fullDataLock lock];
		NSMutableArray *graphData = [NSMutableArray arrayWithArray:[UAV sharedInstance].fullData]  ;
		[fullDataLock unlock];
		int count = [graphData count] * 0.8;
		for (int i=0; i<count; i++) {
			[graphData removeObjectAtIndex:0];
		}
		return graphData;
	} else {
		[fullDataLock lock];
		NSMutableArray *graphData = fullData;//[NSMutableArray arrayWithArray:[UAV sharedInstance].fullData];
		[fullDataLock unlock];
		return graphData;
	}
	
	return nil;
}

#pragma mark -
#pragma mark Singleton methods

+ (UAV*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[UAV alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end