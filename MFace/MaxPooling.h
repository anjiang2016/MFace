//
//  MaxPooling.h
//  MFace
//
//  Created by 赵明明 on 2022/5/26.
//

#import "Layer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaxPooling : Layer
- (Matrix *) torch_forward:(Matrix *) input :(int)kernel :(int)padding :(int)stride;
@end

NS_ASSUME_NONNULL_END
