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
@property float * _filter;
@property float * _bias;
-(Conv *)init:(int)kernel :(int)stride;
@end

NS_ASSUME_NONNULL_END
