/*
 * Cocos2D : http://cocos2d-objc.org
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

#import "cocos2d.h"
#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import "MainScene.h"


@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary* cocos2dSetup;

    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    // We are done ...
    // Lets get this thing on the road!
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    
    // uncomment this code to upscale your assets for iPhone6 and iPhone6Plus
    /*
    NSInteger device = [[CCConfiguration sharedConfiguration] runningDevice];
    if (device == CCDeviceiPhone6 || device == CCDeviceiPhone6Plus) {
        // if portrait
        [CCDirector sharedDirector].contentScaleFactor *= [UIScreen mainScreen].bounds.size.height/568.0;
        
        // if landscape
        //[CCDirector sharedDirector].contentScaleFactor *= [UIScreen mainScreen].bounds.size.width/568.0;
    }
    */
    
    // Create a scene
    //CCScene* main = [MainScene new];
    CCScene* main = [CCBReader loadAsScene:@"MainScene"];
    
    // Run the director with the scene.
    // Push as much scenes as you want (maybe useful for 3D touch)
    [director runWithScene:main];
    
    // Stay positive. Always return a YES :)
    return YES;
}

@end
