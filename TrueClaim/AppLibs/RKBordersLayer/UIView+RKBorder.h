
#import <UIKit/UIKit.h>
#import "RKBordersLayer.h"

// Importing this category will replace UIView's default CALayer with an RKBordersLayer, so that you can use the rk borders directly as properties of the view.
@interface UIView (RKBorder)

@property (nonatomic, strong) UIColor *BordersColor;
@property (nonatomic) float BordersWidth;
@property (nonatomic) DrawBordersFlag BordersFlag;

@end
