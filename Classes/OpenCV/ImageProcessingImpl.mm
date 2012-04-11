#import "ImageProcessingImpl.hpp"
#include "vector"
#import "UIImage+OpenCV.hpp"

@implementation ImageProcessingImpl

- (UIImage*) decompressImage:(char[]) buf withSize:(int) size withHeight:(int) height withWidth:(int) width
{
    std::vector<unsigned char> vbuf(size); 
    for (int i=0; i<size; i++) { 
        vbuf[i] = buf[i]; 
    } 
    
    cv::Mat cvImage = cv::imdecode(vbuf, 1);
    return [[UIImage alloc] initWithCVMat:cvImage];
}

@end
