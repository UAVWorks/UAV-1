#import <Foundation/Foundation.h>

#import "rotateImage.h"
#import "UAVSTRUCT.h"
#import <sqlite3.h>

#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <errno.h>
#import <string.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>

#define MAXSIZE_PARAMETER  256

#define kCommandMerlion_HOVER 0
#define kCommandMerlion_FORWARD 1
#define kCommandMerlion_BACKWARD 2
#define kCommandMerlion_ROLL_LEFT 3
#define kCommandMerlion_ROLL_RIGHT 4
#define kCommandMerlion_ELEVATE 5
#define kCommandMerlion_DESCEND 6
#define kCommandMerlion_YAW_LEFT 7
#define kCommandMerlion_YAW_RIGHT 8
#define kCommandMerlion_DROPPAYLOAD 9
#define kCommandMerlion_MODEAUTO 10
#define kCommandMerlion_MODEMANUAL 11
#define kCommandMerlion_CAMERACALIBRATIONPIXELS 12
#define kCommandMerlion_MODECALIBRATE 13
#define kCommandMerlion_MODELIVECALIBRATE 14
#define kCommandMerlion_CLOSEPAYLOAD 15

/* COMMAND list */
#define COMMAND_RUN 1
#define COMMAND_QUIT 2
#define COMMAND_MAGTEST 3
#define COMMAND_MAGSET 4
#define COMMAND_ENGINE 5
#define COMMAND_HOVER 6
#define COMMAND_LIFT 7
#define COMMAND_DESCEND 8
#define COMMAND_HEADTO 9
#define COMMAND_TURN 10
#define COMMAND_ROUND 11
#define COMMAND_CIRCLE 12
#define COMMAND_CIRCLE2 13
#define COMMAND_HOVER2 14
#define COMMAND_CNFHOVER 15
#define COMMAND_HFLY 16
#define COMMAND_CFLY 17 //fly with velocity feedback
#define COMMAND_PATH 18 //select tracking path (index)
#define COMMAND_TRACK 19 //tracking target
#define COMMAND_CHIRP 20
#define COMMAND_FLY 21 //fly(u,v,w,r)
#define COMMAND_HOLD 22
#define COMMAND_HOLDPI 99
#define COMMAND_PLAN 23
#define COMMAND_TAKEOFF 24
#define COMMAND_LAND 25
#define COMMAND_ENGINEUP 26
#define COMMAND_ENGINEDOWN 27
#define COMMAND_EMERGENCY 28
#define COMMAND_EMERGENCYGROUND 29
#define COMMAND_TAKEOFFA 30
#define COMMAND_LANDA 31
#define COMMAND_PATHA 32
#define COMMAND_COORDINATE 33
#define COMMAND_GPATH 34
#define COMMAND_DYNAMICPATHRESET 41
#define COMMAND_DYNAMICPATH 42
#define COMMAND_SENDGPSORIGIN 43
#define COMMAND_LEADERUPATE 44
#define COMMAND_FORMATION 45
#define COMMAND_HFORMATION 47
#define COMMAND_FILTER 51
#define COMMAND_PARA 52
#define COMMAND_TEST 61
#define COMMAND_NOTIFY 77
#define COMMAND_NONOTIFY 78
#define COMMAND_GETTRIM 80
#define COMMAND_COOP_PKT   82

#define GRAPHLIMIT 500
#define COORDINATESLIMIT 30
#define SLAMMAXRESOLUTIONLIMIT 1024

/*indexes of page with reference to their tab controller */
#define kINDEXSETTINGS		0
#define	kINDEXPANELS		1
#define kINDEXSUMMARY		2
#define kINDEXMAP			3
#define kINDEXSLAM			4
#define kINDEX3D			5
#define kINDEXIMAGE			6
#define kINDEXMERGED        7

#define kUAVTypeMerlion		0
#define kUAVTypeCANCAM		1

#define kSQLFileName @"UAV"

///for slam
struct UAVCOORD{
	double x;
	double y;
	double state;
};

struct TELEGRAPH {
	//unsigned char from;
    //unsigned char to;
    //unsigned short size;
    //short code;
    //double time; //or //short index
    char content[512];
    //short checksum
};

struct UAVSTATE{
    double x,y,z;	//position
    double u,v,w;	//velocity
    double a,b,c;	//attitude
    double p,q,r;	//rotating
    
    double acx, acy, acz; //accelerate along x,y,z
    double acp, acq, acr;
    
    double ug, vg, wg;	//velocity in user ground frame
    double longitude, latitude, altitude;
    
    double as, bs, rfb; //observable variables
} ;

struct SVODATA {
    double aileron;   // -1 ~ 1
    double elevator;  // -1 ~ 1
    double auxiliary; // -1 ~ 1
    double rudder;    // -1 ~ 1
    double throttle;  // always set to 0
    double sv6;       //additional signal to determine mode of operation (automatic/manual)
};

struct IMAGEHEADER {
	short width;
	short height;
	short depth;
	short type;
	long  size;
};

///content[0]            ---- byte from      // ID of source, eg. Ground station, other UAV
///content[1]            ---- byte to        // ID of destination UAV
///content[2~3]          ---- short nsize    // size of the whole telegraph
///content[4~5]          ---- short code     // code for data type
///content[6~13]         ---- double time    // time when this pkg sent
///content[14~229]       ---- data payload   // the exact data when transferred, such as UAVSTATE (216), SVODATA
///content[230~231]      ---- unsigned short // checksum 

@interface UAV : NSObject {
	///declared within curly braces and outside curly braces
    ///so that it can be accessed internally and externally 
    struct TELEGRAPH *latestTelegraph;
	struct UAVSTATE *latestData;
    struct SVODATA *latestSVOData;
    
	NSLock *sqlLock;
	NSLock *fullDataLock;
	NSLock *fullImageLock;
	NSMutableArray *fullData;
    NSMutableArray *fullImage;
    UIImage *liveImage;
	sqlite3 *db;
	NSData *image;
	NSMutableArray *newest600Data;
	NSDate *firstPacketDate;
	NSString *uavIP;
	NSArray *consoleCommandShortcuts;
	UIActivityIndicatorView *activityIndicator;
	BOOL graphIsZoomed;
    struct sockaddr_in UAVAddr;
    int sendsockfd;
	BOOL packetImproper;
	BOOL uavFound;
	BOOL autoMode;
	NSString *SQLFileName;
	int currentUAVType;
}

@property (nonatomic) sqlite3* db;
@property (nonatomic, retain) NSArray *consoleCommandShortcuts;
@property (nonatomic, retain) NSLock *sqlLock;
@property (nonatomic, retain) NSLock *fullImageLock;
@property (nonatomic, retain) NSLock *fullDataLock;
@property (nonatomic, retain) NSMutableArray *fullData;
@property (nonatomic, retain) NSMutableArray *fullImage;
@property (nonatomic, retain) UIImage *liveImage;
@property (nonatomic, assign) BOOL graphIsZoomed;
@property (nonatomic, retain) NSData *image;
@property (nonatomic, retain) NSMutableArray *newest600Data;
@property (nonatomic) struct TELEGRAPH *latestTelegraph;
@property (nonatomic) struct UAVSTATE *latestData;
@property (nonatomic, retain) NSDate *firstPacketDate;
@property (nonatomic, retain) NSString *uavIP;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL packetImproper;
@property (nonatomic, assign) BOOL uavFound;
@property (nonatomic, assign) BOOL autoMode;
@property (nonatomic, retain) NSString *SQLFileName;
@property (nonatomic, assign) int currentUAVType;

-(void) createSQL;
+ (UAV*)sharedInstance;
-(NSMutableArray*) getLatestRowData;
-(NSMutableArray*) getLatestImageData;
- (NSObject*)convertDataToObject:(const struct UAVSTATE*)current;
-(BOOL) parseAndSendCommand:(NSString *)string;
- (void)removeSpinner;
- (NSMutableArray*)graphData;

//+(UAV*) initialize;


struct COMMAND { 
	short code;
	char parameter[MAXSIZE_PARAMETER];
};


@end
