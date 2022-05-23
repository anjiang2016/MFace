//
//  layer.h
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface layer : NSObject

- (void) forward :(float *)input :(float *)output;


@end

NS_ASSUME_NONNULL_END
