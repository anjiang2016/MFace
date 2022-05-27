//
//  relu.h
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Layer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RELU : Layer
- (Matrix *) torch_forward:(Matrix *) input;
@end

NS_ASSUME_NONNULL_END
