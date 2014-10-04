

#import "RKBordersLayer.h"

#pragma mark -
#pragma mark Private Declarations

@interface RKBordersLayer (Private)
-(void) commonInit;
-(void) reloadBorders;
// TODO
-(void) roundCornersIfNeeded;
@end

@implementation RKBordersLayer

@synthesize BordersColor, BordersWidth, BordersFlag;

#pragma mark -
#pragma mark Initialization

-(id) init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id) initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void) commonInit
{
    // Initialize defaults
    BordersWidth = 0.0;
    BordersColor = [UIColor blackColor];
    BordersFlag =  DrawBordersLeft | DrawBordersRight | DrawBordersTop | DrawBordersBottom;
}

#pragma mark -
#pragma mark Positioning

// We need the borderLayer to always be the top most layer, so each time the subLayers positioning change, we place the borderLayer at the top.
-(void) layoutSublayers
{
    [super layoutSublayers];
    [self reloadBorders];
    
    // Move the borders to the top
    borderLayer.zPosition = self.sublayers.count;
}

#pragma mark -
#pragma mark Properties

-(void) setBordersFlag:(DrawBordersFlag)newBorderFlag
{
    // Lazily create the border layer only if setting the rk borders property
    if (!borderLayer)
    {
        borderLayer = [[CAShapeLayer alloc] init];
        [self addSublayer:borderLayer];
    }

    BordersFlag = newBorderFlag;
    [self reloadBorders];
}

-(void) setBordersColor:(UIColor *)newrkBordersColor
{
    BordersColor = newrkBordersColor;
    borderLayer.strokeColor = BordersColor.CGColor;
}

-(void) setBordersWidth:(float)newBordersWidth
{
    BordersWidth = newBordersWidth;
    borderLayer.lineWidth = BordersWidth;
}

-(void) setCornerRadius:(CGFloat)cornerRadius
{
    [super setCornerRadius:cornerRadius];
    
    [self roundCornersIfNeeded];
}

#pragma mark -
#pragma mark Drawing

-(void) reloadBorders
{
    if (!borderLayer)
        return;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    if (BordersFlag & DrawBordersLeft)
    { // left border
        CGPoint startPoint = CGPointMake(BordersWidth/2, 0);
        CGPoint endPoint = CGPointMake(BordersWidth/2, CGRectGetMaxY(self.bounds));
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    if (BordersFlag & DrawBordersRight)
    { // right border
        CGPoint startPoint = CGPointMake(CGRectGetMaxX(self.bounds)-BordersWidth/2, 0);
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds)-BordersWidth/2, CGRectGetMaxY(self.bounds));
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    if (BordersFlag & DrawBordersTop)
    { // top border
        CGPoint startPoint = CGPointMake(0, 0+BordersWidth/2);
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds), 0+BordersWidth/2);
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    if (BordersFlag & DrawBordersBottom)
    { // bottom border
        CGPoint startPoint = CGPointMake(0, CGRectGetMaxY(self.bounds)-BordersWidth/2);
        CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)-BordersWidth/2);
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
    }
    
    borderLayer.frame = self.bounds;
    borderLayer.path = path.CGPath;
    
    borderLayer.strokeColor = self.BordersColor.CGColor;
    borderLayer.lineWidth = self.BordersWidth;
}

-(void) roundCornersIfNeeded
{
    // TODO
}

@end
