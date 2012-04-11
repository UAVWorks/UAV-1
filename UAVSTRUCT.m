#import "UAVSTRUCT.h"


@implementation UAVSTRUCT

@synthesize x,y,z;	//position
@synthesize u,v,w;	//velocity
@synthesize a,b,c;	//altitude
@synthesize p,q,r;	//rotating
@synthesize acx, acy, acz; //acelerate along x,y,z
@synthesize acp, acq, acr;
@synthesize ug, vg, wg;	//velocity in user ground frame
@synthesize longitude, latitude, altitude;
@synthesize as, bs, rfb; //observable variables
@end
