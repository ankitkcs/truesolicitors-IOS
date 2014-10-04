

#import "UIView+RKBorder.h"

@implementation UIView (RKBorder)

+(Class) layerClass
{
    return [RKBordersLayer class];
}

-(DrawBordersFlag) BordersFlag
{
    RKBordersLayer *borderLayer = (RKBordersLayer *)self.layer;
    return borderLayer.BordersFlag;
}

-(void) setBordersFlag:(DrawBordersFlag)drawBorderFlag
{
    RKBordersLayer *borderLayer = (RKBordersLayer *)self.layer;
    borderLayer.BordersFlag = drawBorderFlag;
}

-(UIColor *)BordersColor
{
    RKBordersLayer *borderLayer = (RKBordersLayer *)self.layer;
    return borderLayer.BordersColor;
}

-(void) setBordersColor:(UIColor *)newBordersColor
{
    RKBordersLayer *borderLayer = (RKBordersLayer *)self.layer;
    borderLayer.BordersColor = newBordersColor;
}

-(float) BordersWidth
{
    RKBordersLayer *borderLayer = (RKBordersLayer *)self.layer;
    return borderLayer.BordersWidth;
}

-(void) setBordersWidth:(float)newBordersWidth
{
    RKBordersLayer *borderLayer = (RKBordersLayer *)self.layer;
    borderLayer.BordersWidth = newBordersWidth;
}

@end
