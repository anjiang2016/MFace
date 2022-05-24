//
//  Pooling.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Pooling.h"
#import "ImageProcess.h"

@implementation Pooling
@synthesize _kernel_size;
@synthesize _stride;
- (void) forward{
//pooling:(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :[(int)out_channel
   [ [ImageProcess new] pooling:self._input.buff :self._output.buff :self._kernel_size :self._kernel_size :self._input.width :self._input.height :self._input.channel :self._output.channel ];
   
}
@end
