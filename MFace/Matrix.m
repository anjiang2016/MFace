//
//  Matrix.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Matrix.h"

@implementation Matrix
@synthesize buff;
@synthesize width;
@synthesize height;
@synthesize channel;
-(Matrix *) init:(float *)feature :(int)width :(int)height :(int)channel{
    self.buff=feature;
    self.width=width;
    self.height=height;
    self.channel = channel;
    return self;
}

@end
