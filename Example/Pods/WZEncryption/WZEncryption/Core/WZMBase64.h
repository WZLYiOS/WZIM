//
//  WZMBase64.h
//  WZEncryption
//
//  Created by xiaobin liu on 2019/6/27.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 Base64
 */
@interface WZMBase64 : NSObject

/**
 编码数据

 @param data 数据
 @return 一个新的自动释放的带有编码有效负载的NSData。任何错误为nil
 */
+(NSData *)encodeData:(NSData *)data;
    

/**
 Base64解码NSData对象的内容

 @param data 数据
 @return 一个新的自动释放的NSData与解码的有效载荷。任何错误为nil。
 */
+(NSData *)decodeData:(NSData *)data;


/**
 编码字节长度

 @param bytes 字节
 @param length 长度
 @return 一个新的自动释放的带有编码有效负载的NSData。任何错误为nil
 */
+(NSData *)encodeBytes:(const void *)bytes length:(NSUInteger)length;
    

/**
 解码字节长度

 @param bytes 字节
 @param length 长度
 @return 一个新的自动释放的带有编码有效负载的NSData。任何错误为nil
 */
+(NSData *)decodeBytes:(const void *)bytes length:(NSUInteger)length;
    

/**
 编码数据的字符串

 @param data 数据
 @return 一个新的自动释放的带有编码有效负载的NSString。任何错误为nil
 */
+(NSString *)stringByEncodingData:(NSData *)data;


/**
 按字节编码的字符串长度

 @param bytes 字节
 @param length 长度
 @return 一个新的自动释放的带有编码有效负载的NSString。任何错误为nil
 */
+(NSString *)stringByEncodingBytes:(const void *)bytes length:(NSUInteger)length;

    
/**
 解码字符串

 @param string 字符串
 @return 一个新的自动释放的NSData与解码的有效载荷。任何错误为nil
 */
+(NSData *)decodeString:(NSString *)string;
    

/**
 web安全编码数据填充

 @param data 数据
 @param padded 是否填充
 @return 一个新的自动释放的带有编码有效负载的NSData。任何错误为nil
 */
+(NSData *)webSafeEncodeData:(NSData *)data
                      padded:(BOOL)padded;


/**
 网络安全译码数据

 @param data 数据
 @return 一个新的自动释放的NSData与解码的有效载荷。任何错误为nil
 */
+(NSData *)webSafeDecodeData:(NSData *)data;
    

/**
 web安全编码字节:长度:填充

 @param bytes 字节
 @param length 长度
 @param padded 填充
 @return 一个新的自动释放的带有编码有效负载的NSData。任何错误为nil
 */
+(NSData *)webSafeEncodeBytes:(const void *)bytes
                       length:(NSUInteger)length
                       padded:(BOOL)padded;

/**
 web安全解码字节:长度

 @param bytes 字节
 @param length 长度
 @return 一个新的自动释放的带有编码有效负载的NSData。任何错误为nil
 */
+(NSData *)webSafeDecodeBytes:(const void *)bytes length:(NSUInteger)length;


/**
 字符串由Web安全编码数据:填充

 @param data 数据
 @param padded 填充
 @return 一个新的自动释放的带有编码有效负载的NSString。任何错误为nil
 */
+(NSString *)stringByWebSafeEncodingData:(NSData *)data
                                  padded:(BOOL)padded;
    

/**
 字符串由Web安全编码字节:长度:填充

 @param bytes 字节
 @param length 长度
 @param padded 填充
 @return 一个新的自动释放的带有编码有效负载的NSString。任何错误为nil
 */
+(NSString *)stringByWebSafeEncodingBytes:(const void *)bytes
                                   length:(NSUInteger)length
                                   padded:(BOOL)padded;
    
    
/**
 网络安全译码串

 @param string 字符串
 @return 一个新的自动释放的NSData与解码的有效载荷。任何错误为nil
 */
+(NSData *)webSafeDecodeString:(NSString *)string;
    
    // David Lee new added function
    /// Returns:
    // A new autoreleased NSString with Base64 encoded NSString
    

/**
 base64转字符串

 @param base64String  base64String
 @return 一个新的自动释放的NSString，带有Base64编码的NSString
 */
+(NSString *)stringByBase64String:(NSString *)base64String;
    


/**
 字符串转base64

 @param string 字符串
 @return 一个新的自动发布的Base64用NSString编码的NSString
 */
+(NSString *)base64StringBystring:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
