//
//  MetalConver.h
//  MFace
//
//  Created by 赵明明 on 2022/5/28.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
NS_ASSUME_NONNULL_BEGIN

@interface MetalConver : NSObject
- (instancetype) initWithDevice: (id<MTLDevice>) device;
- (void) prepareData;
- (void) getData:(float*)filter :(int)kernel :(int)padding :(int)stride :(float*)bias :(float*)input :(int)in_width :(int)in_height :(int)in_channel :(float*)output :(int)out_channel;
- (void) copyData: (id<MTLBuffer>) buffer :(float *)buff :(int)length;
- (void) sendComputeCommand;
- (float * )getOutput;

@end

NS_ASSUME_NONNULL_END
