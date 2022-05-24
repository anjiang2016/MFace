//
//  ImageProcess.h
//  MFace
//
//  Created by 赵明明 on 2020/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <Kernel/libkern/crypto/rand.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageProcess : NSObject{
    @public
        float weightsarray[3*64*7*7];
        //NSString* filename_tmp = [Md getModel:weightsarray];
        int in_channel;
        int out_channel;
        //memset(bias,0.0,1*sizeof(*bias));
        int padding;
        int stride;
        int kernel_size;
}
@property int bias;

- (UIImage*)imageBlackToTransparent:(UIImage*)image :(CGFloat)red :(CGFloat)green :(CGFloat)blue;
- (UIImage *)scaleToSize:(UIImage *)img :(CGSize)size;
- (void)UIImage2array:(UIImage*)image :(uint32_t*)imagearray;
- (UIImage *)array2UIImage:(uint32_t*)imagearray :(UIImage*)image;
// 图像缩放
// 卷积计算
//- (UIImage*)passlayer:(UIImage*)image :(float*)weightsarray :(float*)bias :(int)padding :(int)stride;
- (UIImage* )passlayer:(UIImage*)image :(float*)weightsarray :(int)kernel_size :(int*)bias :(int)padding :(int)stride :(int)in_channel :(int)out_channel;
- (void) setBlue:(uint32_t*)rgbImageBuf :(int)pixelNum;
- (void) setRed:(uint32_t*)rgbImageBuf :(int)pixelNum;
- (void) setGreen:(uint32_t*)rgbImageBuf :(int)pixelNum;
//- (void) conv2:(int*_Nullable)filter :(int**)arr :(int**)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH;
- (void) conv2d:(uint32_t*)rgbImageBuf :(uint32_t*)res :(int)imageWidth :(int)imageHeight :(float*)weightsarray :(int)kernel_size :(float)bias :(int)padding :(int)strid :(int)in_channel :(int)out_channel;

- (void) convReluPooling:(uint32_t*)rgbImageBuf :(uint32_t*)res :(int)imageWidth :(int)imageHeight :(float*)weightsarray :(int)kernel_size :(float*)bias :(int)padding :(int)strid :(int)in_channel :(int)out_channel;

- (void) conv2:(float*)filter :(float)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel;
- (void) conv4:(float*)filter :(float*)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel;
-(void)pooling:(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel;


- (void) U2F:(uint32_t*)rgbImageBuf :(uint32_t)pixelNum :(float*)rgbFloatBuf;
- (void) F2U:(uint32_t*)rgbImageBuf :(uint32_t)pixelNum :(float*)rgbFloatBuf;
- (void) U2F_3:(uint32_t*)rgbImageBuf :(uint32_t)pixelNum :(float*)rgbFloatBuf;
- (void) F2U_3:(uint32_t*)rgbImageBuf :(uint32_t)pixelNum :(float*)rgbFloatBuf;
- (void) F2U_channel:(uint32_t*)rgbImageBuf :(uint32_t)pixelNum :(float*)rgbFloatBuf :(int)channel;
- (void) display:(float*)array :(int)num;
- (float)relu:(float)fv;
// pool
@end

NS_ASSUME_NONNULL_END
