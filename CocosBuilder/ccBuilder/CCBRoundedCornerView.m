//
//  CCBRoundedCornerView.m
//  CocosBuilder
//
//  Created by Olivier PIERRE on 30/03/2016.
//
//

#import "CCBRoundedCornerView.h"

@implementation CCBRoundedCornerView

- (void)drawRect:(NSRect)dirtyRect
{
    // filling color
    [[NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1.00] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

-(void) awakeFromNib
{
    self.wantsLayer = YES;
    self.layer.frame = self.frame;
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
}

@end
