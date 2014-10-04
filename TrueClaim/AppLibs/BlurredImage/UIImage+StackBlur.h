
#import <Foundation/Foundation.h>

@interface UIImage (StackBlur) 
	- (UIImage*) stackBlur:(NSUInteger)radius;
    - (UIImage *) normalize ;
    + (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius;
@end

