//
//  utils.m
//  MFace
//
//  Created by 赵明明 on 2020/11/11.
//

#import "utils.h"

@implementation utils
- (void)ProviderReleaseData:(void *)info :(const void*)data :(size_t)size
{
    free((void*)data);
}

@end
