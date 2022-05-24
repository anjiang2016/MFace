//
//  Pooling.h
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Layer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pooling : Layer
@property int _kernel_size;
@property int _stride;


@end

NS_ASSUME_NONNULL_END
