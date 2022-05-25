//
//  Conv.h
//  MFace
//
//  Created by 赵明明 on 2022/5/24.
//

#import "Layer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Conv : Layer
@property int _kernel_size;
@property int _stride;
@property int _padding;
@property int _out_channel;
@property int _in_channel;
@property float * _filter;
@property float * _bias;
-(Conv *)init:(int)kernel :(int)stride;
-(void)init_weights;
-(Conv *) torch_Conv2d:(int)inChannel :(int)outChannel :(int)kernel_size :(int)stride :(int)padding :(int)dilation :(int)groups;
-(Matrix *) torch_forward:(Matrix *)input;
@end

NS_ASSUME_NONNULL_END
