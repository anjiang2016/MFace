//
//  Downsample.h
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "Conv.h"
#import "Bn.h"

NS_ASSUME_NONNULL_BEGIN

@interface Downsample : NSObject
@property Conv* conv1;
@property Bn* bn1;
-(Downsample *)torch_downsample:(int)in_channel:(int)out_channel;
-(Matrix *)torch_forward:(Matrix *)input;
-(void)free;
@end

NS_ASSUME_NONNULL_END
