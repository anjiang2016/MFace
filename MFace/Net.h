//
//  Net.h
//  MFace
//
//  Created by 赵明明 on 2022/5/24.
//

#import <UIKit/UIKit.h>
#import "Layer.h"
#import "RELU.h"
#import "Pooling.h"
#import "Conv.h"
#import "ImageProcess.h"
#import "Bn.h"
#import "Fc.h"
#import "Layers.h"
NS_ASSUME_NONNULL_BEGIN

@interface Net : NSObject
@property Conv * _conv_layer1;
@property Conv * _conv_layer2;
@property Conv * _conv_layer3;
@property RELU * _relu_layer1;
@property Pooling * _pool_layer1;
@property RELU * _relu_layer2;
@property Pooling * _pool_layer2;
@property RELU * _relu_layer3;
@property Pooling * _pool_layer3;


@property Conv * conv1;
@property Bn * bn1;
@property Layers * layer1;
@property Layers * layer2;
@property Layers * layer3;
@property Layers * layer4;
@property Fc * fc;


-(Net *)init;
-(Net *)torch_init;
-(UIImage* )forward:(UIImage*)image;
-(Matrix * )passlayer:(Matrix *)input;
-(void)free;
@end

NS_ASSUME_NONNULL_END
