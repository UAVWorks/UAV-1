// WBImage.mm -- extra UIImage methods
// by allen brunson  march 29 2009

#include "rotateImage.h"

static inline CGFloat degreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
	
    size.width  = size.height;
    size.height = swap;
	
    return size;
}

@implementation UIImage (WBImage)

// rotate an image to any 90-degree orientation, with or without mirroring.
// original code by kevin lohman, heavily modified by yours truly.
// http://blog.logichigh.com/2008/06/05/uiimage-fix/

-(UIImage*)rotate:(NSInteger)degrees
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGRect             rect = CGRectZero;
//    CGAffineTransform  tran = CGAffineTransformIdentity;
	
    bnds.size = self.size;
    rect.size = self.size;

	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
	double angle = degrees+270;
	CGContextRotateCTM(ctxt, degreesToRadians(angle));
	
	CGContextTranslateCTM(ctxt, sin(degreesToRadians(angle+45))*45.254834-32, cos(degreesToRadians(angle+45))*45.254834-32);


	CGContextDrawImage(ctxt, rect, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

@end
