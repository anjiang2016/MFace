//
//  scale.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Scale.h"
#import "Matrix.h"
@implementation Scale

@synthesize  _scale;

- (void) forward{
    int i=0;
    int input_len = self._input.width*self._input.width*self._input.channel;
    for(i=0;i<input_len;i++){
        self._output.buff[i]=self._input.buff[i]*self._scale;
    }
}
- (Matrix *) torch_forward:(Matrix* )input :(float)scale{
    int i=0;
    int input_len = input.width*input.width*input.channel;
    for(i=0;i<input_len;i++){
        input.buff[i]=input.buff[i]*scale;
    }
    return input;
}
@end
