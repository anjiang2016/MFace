//
//  ImageProcess.h
//  MFace
//
//  Created by 赵明明 on 2020/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ImageProcess : NSObject
- (UIImage*)imageBlackToTransparent:(UIImage*)image :(CGFloat)red :(CGFloat)green :(CGFloat)blue;
- (UIImage *)scaleToSize:(UIImage *)img :(CGSize)size;
- (void)UIImage2array:(UIImage*)image :(uint32_t*)imagearray;
- (void)array2UIImage:(UIImage*)image :(uint32_t*)imagearray;
// 图像缩放
// 卷积计算
// pool
@end

NS_ASSUME_NONNULL_END
