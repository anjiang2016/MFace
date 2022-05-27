//
//  Matrix.h
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Matrix : NSObject
@property float * buff;
@property int width;
@property int height;
@property int channel;
-(Matrix *)init:(float *)buff :(int)width :(int)height :(int)channel;
-(Matrix *)add:(Matrix *)input;
-(int)descartes2index:(int)in_width :(int)in_height :(int)in_channel;
-(void)free;
-(void)print;
//-(void)print:(int)start_c :(int)end_c;
-(void)print:(int)start_c :(int)end_c :(int)start_w :(int)end_w :(int)start_h :(int)end_h;
-(UIImage *)show;
-(Matrix*)reshape;
@end

NS_ASSUME_NONNULL_END
