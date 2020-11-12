//
//  utils.h
//  MFace
//
//  Created by 赵明明 on 2020/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface utils : NSObject
- (void)ProviderReleaseData:(void *)info :(const void*)data :(size_t)size;
@end

NS_ASSUME_NONNULL_END
