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
    
    /// 获取用户id路径
    public static func getUserInfoPath(userId: String) -> String {
        var path = getDBPath(name: "userinfo")
        path.append(userId)
        return path
    }
    
    
    /// 获取音频路径
    public static func getVoicePathMp3(userId: String, uuid: String = "") -> String {
        var path = getDBPath(name: "voice")
        path.append(userId)
        let custom = uuid.count > 0 ? uuid : "\(Int(NSDate().timeIntervalSince1970))"
        path.append("_\(custom)")
        path.append(".mp3")
        return path
    }
    
    /// 时间转成时分秒
    public static func getFormatPlayTime(secounds:TimeInterval)->String{
            if secounds.isNaN{
                return "00:00"
            }
            var Min = Int(secounds / 60)
            let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
            var Hour = 0
            if Min>=60 {
                Hour = Int(Min / 60)
                Min = Min - Hour*60
                return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
            }
            return String(format: "%02d:%02d", Min, Sec)
        }
}


