//
//  Matrix.h
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Matrix : NSObject
@property float * buff;
@property int width;
@property int height;
@property int channel;
-(Matrix *)init:(float *)buff :(int)width :(int)height :(int)channel;
-(Matrix *)add:(Matrix *)input;
-(void)free;
@end

NS_ASSUME_NONNULL_END
