//
//  Block.h
//  MFace
//
//  Created by 赵明明 on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "Conv.h"
#import "Bn.h"
#import "Matrix.h"
#import "Downsample.h"

NS_ASSUME_NONNULL_BEGIN

@interface Block : NSObject
@property Conv* conv1;
@property Bn* bn1;
@property Downsample *downsample1;
@property Conv* conv2;
@property Bn* bn2;
-(Block *)torch_block:(int)in_channel:(int)out_channel;
-(Matrix *) torch_forward:(Matrix *)input;
-(void)free;
@end

NS_ASSUME_NONNULL_END
