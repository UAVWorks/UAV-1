#import "ImageProcessingProtocol.h"

@interface ImageProcessingImpl : NSObject<ImageProcessingProtocol>
- (UIImage*) decompressImage:(char[]) buf withSize:(int) size withHeight:(int) height withWidth:(int) width;
@end
