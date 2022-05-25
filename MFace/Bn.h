//
//  Bn.h
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import "Layer.h"
#import "Matrix.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bn : Layer
@property float * weight;
@property float *bias;
@property float running_mean;
@property float running_var;
@property int num_batches_tracked;
-(Bn *)torch_bn:(int)channel;
-(Bn *)init:(int)channel;
-(Matrix *)torch_forward:(Matrix *)input;

@end

NS_ASSUME_NONNULL_END
