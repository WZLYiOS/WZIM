//
//  WZLame.h
//  WZLame
//
//  Created by qiuqixiang on 2020/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZLame : NSObject

+(void)conventToMp3:(NSString *)sourcePath withFilePath:(NSString *)mp3FilePath withStop:(BOOL)isStop;

@end

NS_ASSUME_NONNULL_END
