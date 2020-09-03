//
//  UIImage+.swift
//  WZUIExtension
//
//  Created by xiaobin liu on 2020/8/12.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import WZNamespaceWrappable

// MARK: - 扩展
public extension WZTypeWrapperProtocol where WrappedType: UIImage {
    
    /// UIImage字节大小
    var bytesSize: Int {
        return wrappedValue.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// UIImage1024字节大小
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// UIImage与alwaysoriginal渲染模式。
    var original: UIImage {
        return wrappedValue.withRenderingMode(.alwaysOriginal)
    }
    
    /// UIImage与alwaystemplate渲染模式。
    var template: UIImage {
        return wrappedValue.withRenderingMode(.alwaysTemplate)
    }
    
    /// 九宫格拉伸
    var resizable: UIImage {
        let widthFloat = floor(wrappedValue.size.width/2)
        let heightFloat = floor(wrappedValue.size.height/2)
        return wrappedValue.resizableImage(withCapInsets: UIEdgeInsets(top: heightFloat, left: widthFloat, bottom: heightFloat, right: widthFloat))
}
}


// MARK: - Initializers
public extension UIImage {
    
    // 创建图像来自颜色和大小
    //
    // - Parameters:
    //   - color: 颜色
    //   - size: 大小
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
}

