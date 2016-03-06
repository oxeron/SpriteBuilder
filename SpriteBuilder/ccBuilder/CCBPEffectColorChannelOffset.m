    //
//  CCBPEffectColorChannelOffset.m
//  SpriteBuilder
//
//  Created by Thayer on 12/10/14.
//
//

#import "CCBPEffectColorChannelOffset.h"
#import "CCBDictionaryReader.h"
#import "CCBDictionaryWriter.h"
#import "EffectsUndoHelper.h"

@implementation CCBPEffectColorChannelOffset

@synthesize UUID;

+ (CCEffect<CCEffectProtocol>*)defaultConstruct
{
    return [self effectWithRedOffsetWithPoint:CGPointMake(0.0f, 0.0f) greenOffsetWithPoint:CGPointMake(0.0f, 0.0f) blueOffsetWithPoint:CGPointMake(0.0f, 0.0f)];
}


- (id)serialize
{
    return @[@{@"name" : @"redOffsetWithPoint",   @"type" : @"Point", @"value": [CCBDictionaryWriter serializePoint:self.redOffsetWithPoint] },
             @{@"name" : @"greenOffsetWithPoint", @"type" : @"Point", @"value": [CCBDictionaryWriter serializePoint:self.greenOffsetWithPoint] },
             @{@"name" : @"blueOffsetWithPoint",  @"type" : @"Point", @"value": [CCBDictionaryWriter serializePoint:self.blueOffsetWithPoint] },
             ];
}

- (void)deserialize:(NSArray*)properties
{
    [properties findFirst:^BOOL(NSDictionary * dict, int idx) {\
        return [dict[@"name"] isEqualToString:@"redOffsetWithPoint"];\
    } complete:^(NSDictionary * dict, int idx) {
        
        self.redOffsetWithPoint = [CCBDictionaryReader deserializePoint:dict[@"value"]];
    }];

    [properties findFirst:^BOOL(NSDictionary * dict, int idx) {\
        return [dict[@"name"] isEqualToString:@"greenOffsetWithPoint"];\
    } complete:^(NSDictionary * dict, int idx) {
        
        self.greenOffsetWithPoint = [CCBDictionaryReader deserializePoint:dict[@"value"]];
    }];

    [properties findFirst:^BOOL(NSDictionary * dict, int idx) {\
        return [dict[@"name"] isEqualToString:@"blueOffsetWithPoint"];\
    } complete:^(NSDictionary * dict, int idx) {
        
        self.blueOffsetWithPoint = [CCBDictionaryReader deserializePoint:dict[@"value"]];
    }];
}

- (EffectDescription*)effectDescription
{
    return [EffectsManager effectByClassName: NSStringFromClass([self class])];
}

- (void)willChangeValueForKey:(NSString *)key
{
    [EffectsUndoHelper handleUndoForKey:key effect:self];
    [super willChangeValueForKey:key];
}

@end
