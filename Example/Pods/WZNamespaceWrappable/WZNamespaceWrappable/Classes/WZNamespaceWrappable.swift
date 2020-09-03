//
//  WZNamespaceWrappable.swift
//  WZNamespaceWrappable
//
//  Created by xiaobin liu on 2020/08/12.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import Foundation

/// MARK - 定义个命名空间
/*
 在对 TypeWrapperProtocol 这个协议做 extension 时， where 后面的 WrappedType 约束可以使用 == 或者 :，两者是有区别的。如果扩展的是值类型，比如 String，Date 等，就必须使用 ==，如果扩展的是类，则两者都可以使用，区别是如果使用 == 来约束，则扩展方法只对本类生效，子类无法使用。如果想要在子类也使用扩展方法，则使用 : 来约束。
 还有一些注意的地方
 对类型扩展实现 NamespaceWrappable 协议，只需要写一次。如果对 UIView 已经写了 NamespaceWrappable 协议实现，则 UILabel 不需要再写。实际上写了之后，编译会报错。
 如果在实现的 func 前加上 static 关键字，可以扩展出静态方法。
 */
public protocol WZNamespaceWrappable {
    associatedtype WrapperType
    var wz: WrapperType { get set }
    static var wz: WrapperType.Type { get set }
}

public extension WZNamespaceWrappable {
    var wz: WZNamespaceWrapper<Self> {
        get {
            return WZNamespaceWrapper(value: self)
        } set {
            
        }
    }
    
    static var wz: WZNamespaceWrapper<Self>.Type {
        get {
            return WZNamespaceWrapper.self
        } set {
            
        }
    }
}

public protocol WZTypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct WZNamespaceWrapper<T>: WZTypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}


// MARK: - WZNamespaceWrappable
import class Foundation.NSObject
extension NSObject: WZNamespaceWrappable { }


