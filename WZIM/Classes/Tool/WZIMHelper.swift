//
//  WZIMHelper.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/31.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation

/**
 颜色外观
 */
public enum WZIMToolAppearance {
    
    /// 主题颜色
    public static let theme = WZIMToolAppearance.hexadecimal(rgb: "0xfb4d38")
    
    /// 副主题颜色
    public static let vice = WZIMToolAppearance.rgb(r: 170, g: 170, b: 170)
    
    /// 线颜色
    public static let line = WZIMToolAppearance.rgb(r: 244, g: 244, b: 244)
    
    /// 文本颜色
    public static let textColor = WZIMToolAppearance.hexadecimal(rgb: "0x1C1C1C")
    
    /// 文字light颜色
    public static let lightedTextColor = WZIMToolAppearance.hexadecimal(rgb: "0xFB4D38")
    
    /// tintColor
    public static let tint = UIColor.white
    
    /// 控制器背景颜色
    public static let vcBG = UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1.0)
    
    /// RGB
    public static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /// 16进制颜色方法
    /// - Parameter rgb: 16进制
    /// - Parameter alpha: 透明度
    public static func hexadecimal(rgb: String, alpha: Float = 1) -> UIColor {
        var cstr = rgb.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
         if(cstr.length < 6){
             return UIColor.clear;
          }
         if(cstr.hasPrefix("0X")){
             cstr = cstr.substring(from: 2) as NSString
         }
         if(cstr.hasPrefix("#")){
           cstr = cstr.substring(from: 1) as NSString
         }
          if(cstr.length != 6){
           return UIColor.clear;
         }
         var range = NSRange.init()
         range.location = 0
         range.length = 2
         //r
         let rStr = cstr.substring(with: range);
         //g
         range.location = 2;
         let gStr = cstr.substring(with: range)
         //b
         range.location = 4;
         let bStr = cstr.substring(with: range)
         var r :UInt32 = 0x0;
         var g :UInt32 = 0x0;
         var b :UInt32 = 0x0;
         Scanner.init(string: rStr).scanHexInt32(&r);
         Scanner.init(string: gStr).scanHexInt32(&g);
         Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha));
    }
    
    /// 安全区域底部
    public static var safeAreaInsetsBottom: Int {
        if #available(iOS 11.0, *) {
            return Int(UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0)
        } else {
            return 0
        }
    }
    
    /// 颜色转图片
    public static func image(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    /// 路径
    public static func getDBPath(name: String) -> String {
        var path = NSHomeDirectory()
        path.append("/Documents/com_wz_imsdk_\(name)/")
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("文件夹创建失败")
            }
        }
        return path
    }
    
    /// 路径名
    public enum DBType: String {
        case nomar = "nomar"
        case voice = "voice"
        case file = "file"
        case userinfo = "userinfo"
        
        /// 获取文件路径
        func getPath(userId: String = "", uuid: String = "") -> String {
            
            /// 文件路径
            var path = NSHomeDirectory()
            path.append("/Documents/com_wz_imsdk_\(self.rawValue)/")
            if !FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    debugPrint("文件夹创建失败")
                }
            }
            if userId.count > 0 {
                path.append(userId)
            }
            if uuid.count > 0 {
                path.append(uuid)
            }
            switch self {
            case .voice:
                path.append(".mp3")
            default: break
            }
            return path
        }
    }
    
    
    
    
    /// 大小转M
    public static func getDataLeng(size: Int) -> String {
        var len = Double(size)
        let array = ["Bytes", "K", "M", "G", "T"]
        var factor: Int = 0
        while (len > 1024) {
            len /= 1024
            factor += 1
            if(factor >= 4){
                break;
            }
        }
        let text: String = String(format: "%4.2f", len)
        let num = NSNumber(value: Float(text) ?? 0.0)
        return String(format: "%@%@", num, array[factor])
    }
}



