//
//  WZDES3.m
//  WZEncryption
//
//  Created by xiaobin liu on 2019/6/27.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import "WZDES3.h"
#import "WZMBase64.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation WZDES3



/**
 加密方法
 
 @param plainText 文本
 @param key 原始密钥材料，长度密钥长度字节
 @param iv 初始化向量,可选的。用于密码块链接(CBC)模式。如果存在,必须与所选的长度相同吗，算法的块大小。如果CBC模式是选择(通过不包含任何模式位)选项标志)，没有IV, a将使用NULL(所有零)IV。这是如果使用ECB模式或流，则忽略选择密码算法。良好的加密,总是用随机数据初始化IV
 @return 加密后的字符串
 */
+ (NSString*)encrypt:(NSString*)plainText key: (NSString *)key iv: (NSString *)iv {
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [iv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [WZMBase64 stringByEncodingData:myData];
    return result;
}


/**
 解密方法
 
 @param encryptText 解密文本
 @param key 原始密钥材料，长度密钥长度字节
 @param iv 初始化向量,可选的。用于密码块链接(CBC)模式。如果存在,必须与所选的长度相同吗，算法的块大小。如果CBC模式是选择(通过不包含任何模式位)选项标志)，没有IV, a将使用NULL(所有零)IV。这是如果使用ECB模式或流，则忽略选择密码算法。良好的加密,总是用随机数据初始化IV
 @return 解密后的字符串
 */
+ (NSString*)decrypt:(NSString*)encryptText key: (NSString *)key iv: (NSString *)iv {
    
    NSData *encryptData = [WZMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [iv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}
@end
