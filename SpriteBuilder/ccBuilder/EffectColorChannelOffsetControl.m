//
//  EffectColorChannelOffsetControl.m
//  SpriteBuilder
//
//  Created by Thayer on 12/10/14.
//
//

#import "EffectColorChannelOffsetControl.h"

@interface EffectColorChannelOffsetControl ()

@end

@implementation EffectColorChannelOffsetControl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setRedOffsetX:(float)x
{
    [self.effect willChangeValueForKey:@"redOffsetWithPoint"];

    self.effect.redOffsetWithPoint = CGPointMake(x, self.effect.redOffsetWithPoint.y);

    [self.effect didChangeValueForKey:@"redOffsetWithPoint"];
}

- (float)redOffsetX
{
    return self.effect.redOffsetWithPoint.x;
}

- (void)setRedOffsetY:(float)y
{
    [self.effect willChangeValueForKey:@"redOffsetWithPoint"];

    self.effect.redOffsetWithPoint = CGPointMake(self.effect.redOffsetWithPoint.x, y);

    [self.effect didChangeValueForKey:@"redOffsetWithPoint"];
}

- (float)redOffsetY
{
    return self.effect.redOffsetWithPoint.y;
}

- (void)setGreenOffsetX:(float)x
{
    [self.effect willChangeValueForKey:@"greenOffsetWithPoint"];
    
    self.effect.greenOffsetWithPoint = CGPointMake(x, self.effect.greenOffsetWithPoint.y);
    
    [self.effect didChangeValueForKey:@"greenOffsetWithPoint"];
}

- (float)greenOffsetX
{
    return self.effect.greenOffsetWithPoint.x;
}

- (void)setGreenOffsetY:(float)y
{
    [self.effect willChangeValueForKey:@"greenOffsetWithPoint"];
    
    self.effect.greenOffsetWithPoint = CGPointMake(self.effect.greenOffsetWithPoint.x, y);
    
    [self.effect didChangeValueForKey:@"greenOffsetWithPoint"];
}

- (float)greenOffsetY
{
    return self.effect.greenOffsetWithPoint.y;
}

- (void)setBlueOffsetX:(float)x
{
    [self.effect willChangeValueForKey:@"blueOffsetWithPoint"];
    
    self.effect.blueOffsetWithPoint = CGPointMake(x, self.effect.blueOffsetWithPoint.y);
    
    [self.effect didChangeValueForKey:@"blueOffsetWithPoint"];
}

- (float)blueOffsetX
{
    return self.effect.blueOffsetWithPoint.x;
}

- (void)setBlueOffsetY:(float)y
{
    [self.effect willChangeValueForKey:@"blueOffsetWithPoint"];
    
    self.effect.blueOffsetWithPoint = CGPointMake(self.effect.blueOffsetWithPoint.x, y);
    
    [self.effect didChangeValueForKey:@"blueOffsetWithPoint"];
}

- (float)blueOffsetY
{
    return self.effect.blueOffsetWithPoint.y;
}

@end
