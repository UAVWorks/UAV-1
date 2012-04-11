/// as of feb 2012
#import <Foundation/Foundation.h>


@interface UAVSTRUCT : NSObject {
	double x,y,z;	//position
	double u,v,w;	//velocity
	double a,b,c;	//altitude
	double p,q,r;	//rotating
	
	double acx, acy, acz; //acelerate along x,y,z
	double acp, acq, acr;
	
	double ug, vg, wg;	//velocity in user ground frame
	double longitude, latitude, altitude;
	
	double as, bs, rfb; //observable variables
}

@property double x,y,z;	//position
@property double u,v,w;	//velocity
@property double a,b,c;	//altitude
@property double p,q,r;	//rotating
@property double acx, acy, acz; //accelerate along x,y,z
@property double acp, acq, acr;
@property double ug, vg, wg;	//velocity in user ground frame
@property double longitude, latitude, altitude;
@property double as, bs, rfb; //observable variables
@end
