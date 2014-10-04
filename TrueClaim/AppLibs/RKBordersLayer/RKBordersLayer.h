
#import <QuartzCore/QuartzCore.h>

enum
{
    DrawBordersLeft = 1 <<  0,
    DrawBordersRight = 1 <<  1,
    DrawBordersTop = 1 <<  2,
    DrawBordersBottom = 1 <<  3
};
typedef NSUInteger DrawBordersFlag;


@interface RKBordersLayer : CALayer
{
    CAShapeLayer *borderLayer;
}

@property (nonatomic, strong) UIColor *BordersColor;
@property (nonatomic) float BordersWidth;
@property (nonatomic) DrawBordersFlag BordersFlag;

@end
