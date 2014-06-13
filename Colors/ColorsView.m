//
//  ColorsView.m
//  Colors
//
//  Copyright (c) 2013 aram price.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in the 
//  Software without restriction, including without limitation the rights to use, copy, 
//  modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
//  and to permit persons to whom the Software is furnished to do so, subject to the 
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies 
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ColorsView.h"

@implementation ColorsView

static NSString *const ColorsModuleName = @"com.aramprice.Colors";
static NSString *const AnimationIntervalSecondsKey = @"AnimationIntervalSeconds";
static NSString *const PolygonSideCountKey = @"PolygonSideCount";

NSSize displaysize;
ScreenSaverDefaults *defaults;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:ColorsModuleName];
        NSLog(@"initWithFrame -> defaults dictionaryRepresentation: %@", [defaults dictionaryRepresentation]);
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:2.0], AnimationIntervalSecondsKey,
                                    [NSNumber numberWithInt:10], PolygonSideCountKey,
                                    nil];
        [defaults registerDefaults:dictionary];
        [animationIntervalSecondsOption setState:2.0];
        [polygonSideCountOption setState:10];

        NSLog(@"initWithFrame -> dictionary: %@", dictionary);
        NSLog(@"initWithFrame -> defaults dictionaryRepresentation: %@", [defaults dictionaryRepresentation]);
        NSLog(@"initWithFrame -> [defaults floatForKey:@AnimationIntervalSecondsKey]: %f", [defaults floatForKey:AnimationIntervalSecondsKey]);
        [self setAnimationTimeInterval:2.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    displaysize = [self bounds].size;

    [self setRandomBackgroundColor];
    [self createRandomColoredPolygon];

    return;
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:ColorsModuleName];
    NSLog(@"configureSheet -> defaults dictionaryRepresentation: %@", [defaults dictionaryRepresentation]);

    if (!configSheet)
    {
        if ([[NSBundle mainBundle] loadNibNamed:@"ConfigureSheet" owner:self topLevelObjects:nil])
        {
            [[[NSApp delegate] window] beginSheet:self.configureSheet completionHandler:nil];
        }
        else
        {
            NSLog( @"Failed to load configure sheet." );
            NSBeep();
        }
    }

    [animationIntervalSecondsOption setState:[defaults floatForKey:AnimationIntervalSecondsKey]];
    [polygonSideCountOption setState:[defaults integerForKey:PolygonSideCountKey]];
    NSLog(@"configureSheet -> defaults dictionaryRepresentation: %@", [defaults dictionaryRepresentation]);

    return configSheet;
}

- (IBAction)cancelClick:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)okClick:(id)sender
{
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:ColorsModuleName];
    NSLog(@"okClick -> defaults dictionaryRepresentation: %@", [defaults dictionaryRepresentation]);

    // Update our defaults
    [defaults setFloat:[animationIntervalSecondsOption state] forKey:AnimationIntervalSecondsKey];
    [defaults setInteger:[polygonSideCountOption state] forKey:PolygonSideCountKey];

    // Save the settings to disk
    [defaults synchronize];

    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (void)setRandomBackgroundColor
{
    NSColor *color = [NSColor colorWithCalibratedRed:[self randomFloat]
                                               green:[self randomFloat]
                                                blue:[self randomFloat]
                                               alpha:1.0]; // no transparency
    [color set];

    NSBezierPath *background = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0,
                                                                           displaysize.width,
                                                                           displaysize.height)];

    [background fill];
}

- (void)createRandomColoredPolygon
{
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:ColorsModuleName];
    NSLog(@"createRandomColoredPolygon -> defaults dictionaryRepresentation: %@", [defaults dictionaryRepresentation]);
    NSColor *color = [NSColor colorWithCalibratedRed:[self randomFloat]
                                               green:[self randomFloat]
                                                blue:[self randomFloat]
                                               alpha:[self randomFloat]];
    [color set];

    NSBezierPath *polygon = [NSBezierPath bezierPath];

    [polygon moveToPoint: [self randomPoint]];
    NSLog(@"createRandomColoredPolygon -> [defaults integerForKey:@PolygonSideCountKey]: %ld", (long)[defaults integerForKey:PolygonSideCountKey]);
    for (int i = 1; i < 10; i++) {
        [polygon lineToPoint: [self randomPoint]];
    }
    [polygon closePath];

    [polygon fill];
}

- (NSPoint)randomPoint
{
    return NSPointFromCGPoint(CGPointMake(SSRandomFloatBetween(0.0, displaysize.width),
                                          SSRandomFloatBetween(0.0, displaysize.height)));
}

- (float)randomFloat
{
    return SSRandomFloatBetween(0.0, 1.0);
}

@end
