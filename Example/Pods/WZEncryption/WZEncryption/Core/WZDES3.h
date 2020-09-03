//
//  WZDES3.h
//  WZEncryption
//
//  Created by xiaobin liu on 2019/6/27.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 DES3
 */
@interface WZDES3 : NSObject


/**
 加密方法

 @param plainText 文本
 @param key 原始密钥材料，长度密钥长度字节
 @param iv 初始化向量,可选的。用于密码块链接(CBC)模式。如果存在,必须与所选的长度相同吗，算法的块大小。如果CBC模式是选择(通过不包含任何模式位)选项标志)，没有IV, a将使用NULL(所有零)IV。这是如果使用ECB模式或流，则忽略选择密码算法。良好的加密,总是用随机数据初始化IV
 @return 加密后的字符串
 */
+ (NSString*)encrypt:(NSString*)plainText key: (NSString *)key iv: (NSString *)iv;
    
 
/**
 解密方法

 @param encryptText 解密文本
 @param key 原始密钥材料，长度密钥长度字节
 @param iv 初始化向量,可选的。用于密码块链接(CBC)模式。如果存在,必须与所选的长度相同吗，算法的块大小。如果CBC模式是选择(通过不包含任何模式位)选项标志)，没有IV, a将使用NULL(所有零)IV。这是如果使用ECB模式或流，则忽略选择密码算法。良好的加密,总是用随机数据初始化IV
 @return 解密后的字符串
 */
+ (NSString*)decrypt:(NSString*)encryptText key: (NSString *)key iv: (NSString *)iv;
@end

NS_ASSUME_NONNULL_END
