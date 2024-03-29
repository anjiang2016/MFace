//
//  model.h
//  MFace
//
//  Created by 赵明明 on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import "Net.h"
NS_ASSUME_NONNULL_BEGIN

@interface model : NSObject
//-(NSString*)getModel:(float*)farray;
//-(NSString*)getModel :(float*)farray :(NSString *)model_path :(Net *)net;
-(NSString*)getModel :(float*)farray :(NSString *)model_path :(Net *)net;
-(NSArray*)pth2array :(NSArray*)array :(NSString *)model_path;
-(float * )pth2fload :(float *)img :(NSString *)model_path;
@end

NS_ASSUME_NONNULL_END
