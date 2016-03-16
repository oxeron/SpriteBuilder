/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "ResolutionSetting.h"

@implementation ResolutionSetting

@synthesize enabled;
@synthesize name;
@synthesize width;
@synthesize height;
@synthesize ext;
@synthesize scale;
@synthesize centeredOrigin;
@synthesize exts;

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    enabled = NO;
    self.name = @"Custom";
    self.width = 1000;
    self.height = 1000;
    self.ext = @" ";
    self.scale = 1;
    
    return self;
}

- (id) initWithSerialization:(id)serialization
{
    self = [self init];
    if (!self) return NULL;
    
    self.enabled = YES;
    self.name = [serialization objectForKey:@"name"];
    self.width = [[serialization objectForKey:@"width"] intValue];
    self.height = [[serialization objectForKey:@"height"] intValue];
    self.ext = [serialization objectForKey:@"ext"];
		// TODO should store separate values for these.
    self.scale = [[serialization objectForKey:@"scale"] floatValue];
    self.centeredOrigin = [[serialization objectForKey:@"centeredOrigin"] boolValue];
    
    return self;
}

-(void)setScale:(float)_scale
{
	NSAssert(_scale > 0.0, @"scale must be positive.");
	
//	if(_scale <= 0.0){
//		NSLog(@"WARNING: scale must be positive. (1.0 was substituted for %f)", _scale);
//		_scale = 1.0;
//	}
	
	scale = _scale;
}

- (id) serialize
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:name forKey:@"name"];
    [dict setObject:[NSNumber numberWithInt:width] forKey:@"width"];
    [dict setObject:[NSNumber numberWithInt:height] forKey:@"height"];
    [dict setObject:ext forKey:@"ext"];
    [dict setObject:[NSNumber numberWithFloat:scale] forKey:@"scale"];
    [dict setObject:[NSNumber numberWithBool:centeredOrigin] forKey:@"centeredOrigin"];
    
    return dict;
}

- (void) setExt:(NSString *)e
{
    
    ext = [e copy];
    
    if (!e || [e isEqualToString:@" "] || [e isEqualToString:@""])
    {
        exts = [[NSArray alloc] init];
    }
    else
    {
        exts = [e componentsSeparatedByString:@" "];
    }
}

- (void) dealloc
{
    self.ext = NULL;
    
}

+ (ResolutionSetting*) settingFixed
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Fixed";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablet phonehd";
    setting.scale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingFixedLandscape
{
    ResolutionSetting* setting = [self settingFixed];
    
    setting.name = @"Fixed Landscape";
    setting.width = 568;
    setting.height = 384;
    
    return setting;
}

+ (ResolutionSetting*) settingFixedPortrait
{
    ResolutionSetting* setting = [self settingFixed];
    
    setting.name = @"Fixed Portrait";
    setting.width = 384;
    setting.height = 568;
    
    return setting;
}


+ (ResolutionSetting*) settingIPhone
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"iPhone";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"phone";
    setting.scale = 1;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhoneLandscape
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone Landscape (short)";
    setting.width = 480;
    setting.height = 320;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhonePortrait
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone Portrait (short)";
    setting.width = 320;
    setting.height = 480;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone5Landscape
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone Landscape";
    setting.width = 568;
    setting.height = 320;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone5Portrait
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone Portrait";
    setting.width = 320;
    setting.height = 568;
    
    return setting;
}

+ (ResolutionSetting*) settingIPad
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"Tablet";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"tablet phonehd";
    setting.scale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadLandscape
{
    ResolutionSetting* setting = [self settingIPad];
    
    setting.name = @"Tablet Landscape";
    setting.width = 512;
    setting.height = 384;
    
    return setting;
}

+ (ResolutionSetting*) settingIPadPortrait
{
    ResolutionSetting* setting = [self settingIPad];
    
    setting.name = @"Tablet Portrait";
    setting.width = 384;
    setting.height = 512;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6Landscape
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone6 Landscape";
    setting.width = 667;
    setting.height = 375;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6Portrait
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone6 Portrait";
    setting.width = 375;
    setting.height = 667;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6PlusLandscape
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone6Plus Landscape";
    setting.width = 736;
    setting.height = 414;
    
    return setting;
}

+ (ResolutionSetting*) settingIPhone6PlusPortrait
{
    ResolutionSetting* setting = [self settingIPhone];
    
    setting.name = @"iPhone6Plus Portrait";
    setting.width = 414;
    setting.height = 736;
    
    return setting;
}

+ (ResolutionSetting*) settingHTML5
{
    ResolutionSetting* setting = [[ResolutionSetting alloc] init];
    
    setting.name = @"HTML 5";
    setting.width = 0;
    setting.height = 0;
    setting.ext = @"html5";
    setting.scale = 2;
    
    return setting;
}

+ (ResolutionSetting*) settingHTML5Landscape
{
    ResolutionSetting* setting = [self settingHTML5];
    
    setting.name = @"HTML 5 Landscape";
    setting.width = 1024;
    setting.height = 768;
    
    return setting;
}

+ (ResolutionSetting*) settingHTML5Portrait
{
    ResolutionSetting* setting = [self settingHTML5];
    
    setting.name = @"HTML 5 Portrait";
    setting.width = 768;
    setting.height = 1024;
    
    return setting;
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"%@ <0x%x> (%d x %d)", NSStringFromClass([self class]), (unsigned int)self, width, height];
}

- (id) copyWithZone:(NSZone*)zone
{
    ResolutionSetting* copy = [[ResolutionSetting alloc] init];
    
    copy.enabled = enabled;
    copy.name = name;
    copy.width = width;
    copy.height = height;
    copy.ext = ext;
    copy.scale = scale;
    copy.centeredOrigin = centeredOrigin;
    
    return copy;
}

@end
