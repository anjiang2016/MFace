//
//  FileOperate.h
//  MFace
//
//  Created by 赵明明 on 2020/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileOperate : NSObject
- (void) read2show :(NSString * )filePath_in;
- (void) stringArray2FloatArray :(NSString*)sarray :(float *)farray;
@end

NS_ASSUME_NONNULL_END
