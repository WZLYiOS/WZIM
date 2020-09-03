//
//  UICollectionView+.swift
//  WZUIExtension
//
//  Created by xiaobin liu on 2020/8/12.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import WZNamespaceWrappable


// MARK: - UICollectionView
public extension WZTypeWrapperProtocol where WrappedType: UICollectionView {
    
    /// 最后一项在collectionView中的索引路径
    var indexPathForLastItem: IndexPath? {
        return self.indexPathForLastItem(inSection: lastSection)
    }
    
    /// 最后一项的Section是多少
    var lastSection: Int {
        return wrappedValue.numberOfSections > 0 ? wrappedValue.numberOfSections - 1 : 0
    }
    
    
    /// 集合视图所有部分的所有项的数量
    ///
    /// - Returns: 数量
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < wrappedValue.numberOfSections {
            itemsCount += wrappedValue.numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }
    
    /// 用于最后一项的IndexPath
    ///
    /// - Parameter section: 最后一项的Section
    /// - Returns: 最后一个indexPath(如果适用)。
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < wrappedValue.numberOfSections else {
            return nil
        }
        guard wrappedValue.numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: wrappedValue.numberOfItems(inSection: section) - 1, section: section)
    }
    
    
    /// 用一个完成处理器重新加载数据
    ///
    /// - Parameter completion: 在reloadData完成后运行的完成处理程序。
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.wrappedValue.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    
    /// 使用类名Dequeue重用UICollectionViewCell
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell 类型
    ///   - indexPath: 单元格在集合视图中的位置
    /// - Returns: 具有相关类名的UICollectionViewCell对象。
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        
        guard let cell = wrappedValue.dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("请注册Cell")
        }
        
        return cell
    }
    
    
    /// 使用类名Dequeue重用UICollectionReusableView。
    ///
    /// - Parameters:
    ///   - kind: 检索的补充视图。这个值由layout对象定义。
    ///   - name: UICollectionReusableView 类型
    ///   - indexPath: 单元格在集合视图中的位置
    /// - Returns: 具有相关类名的UICollectionReusableView对象。
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
        
        guard let cell = wrappedValue.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("请注册Cell")
        }
        return cell
    }
    
    
    /// 使用类名注册UICollectionReusableView。
    ///
    /// - Parameters:
    ///   - kind: 检索的补充视图。这个值由layout对象定义。
    ///   - name: UICollectionReusableView类型
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        wrappedValue.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用类名注册UICollectionViewCell
    ///
    /// - Parameters:
    ///   - nib: 用于创建collectionView单元格的Nib文件。
    ///   - name: UICollectionViewCell类型
    func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        wrappedValue.register(nib, forCellWithReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用类名注册UICollectionViewCell。
    ///
    /// - Parameter name: UICollectionViewCell 类型
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        wrappedValue.register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用类名注册UICollectionReusableView
    ///
    /// - Parameters:
    ///   - nib: 用于创建可重用视图的Nib文件
    ///   - kind: 检索的补充视图。这个值由layout对象定义。
    ///   - name: UICollectionReusableView类型
    func register<T: UICollectionReusableView>(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass name: T.Type) {
        wrappedValue.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用.xib文件注册UICollectionViewCell，只使用相应的类,假设.xib文件名和cell类具有相同的名称
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell类型
    ///   - bundleClass: 绑定包实例的类
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle? = nil
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        wrappedValue.register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
}
