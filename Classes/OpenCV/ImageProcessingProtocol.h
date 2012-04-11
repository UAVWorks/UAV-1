#import <UIKit/UIKit.h>

@protocol ImageProcessingProtocol <NSObject>
- (UIImage*) decompressImage:(char[]) buf withSize:(int) size withHeight:(int) height withWidth:(int) width;
@end
