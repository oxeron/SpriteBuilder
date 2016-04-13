//
//  PreviewSpriteSheetViewController.h
//  CocosBuilder
//
//  Created by Nicky Weber on 26.08.14.
//
//

#import <Cocoa/Cocoa.h>
#import "PreviewViewControllerProtocol.h"

@class CCBImageView;
@class PreviewBaseViewController;

@interface PreviewSpriteSheetViewController : PreviewBaseViewController <PreviewViewControllerProtocol>

@property (nonatomic, weak) IBOutlet CCBImageView* previewSpriteSheet;

@property (nonatomic) BOOL trimSprites;

@property (nonatomic) int  format_ios;
@property (nonatomic) BOOL format_ios_dither;
@property (nonatomic) BOOL format_ios_compress;
@property (nonatomic) BOOL format_ios_dither_enabled;
@property (nonatomic) BOOL format_ios_compress_enabled;

@property (nonatomic) int  format_tvos;
@property (nonatomic) BOOL format_tvos_dither;
@property (nonatomic) BOOL format_tvos_compress;
@property (nonatomic) BOOL format_tvos_dither_enabled;
@property (nonatomic) BOOL format_tvos_compress_enabled;

@end
