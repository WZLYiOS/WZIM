//
//  UITableView+.swift
//  WZUIExtension
//
//  Created by xiaobin liu on 2020/8/12.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import WZNamespaceWrappable

/// MARK: - UITableView
public extension WZTypeWrapperProtocol where WrappedType: UITableView {
    
    
    /// 索引路径tableview最后一排
    var indexPathForLastRow: IndexPath? {
        return indexPathForLastRow(inSection: lastSection)
    }
    
    /// 最后Section索引
    var lastSection: Int {
        return wrappedValue.numberOfSections > 0 ? wrappedValue.numberOfSections - 1 : 0
    }
    
    /// TableView的行数
    ///
    /// - Returns: The count of all rows in the tableView
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < wrappedValue.numberOfSections {
            rowCount += wrappedValue.numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    /// Section的最后一个IndexPath
    ///
    /// - Parameter section: <#section description#>
    /// - Returns: <#return value description#>
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0 else { return nil }
        guard wrappedValue.numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: wrappedValue.numberOfRows(inSection: section) - 1, section: section)
    }
    
    
    /// 自定义分组类似于ipad的样式
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - cell: <#cell description#>
    ///   - indexPath: <#indexPath description#>
    func group(tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cornerRadius: CGFloat = 5
        cell.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds.insetBy(dx: 8, dy: 0)
        var addLine = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.minY), tangent2End: .init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.minY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(white: 1, alpha: 0.8).cgColor
        
        if (addLine == true) {
            let lineLayer = CALayer()
            let lineHeight = 1.0 / UIScreen.main.scale
            lineLayer.frame = CGRect(x: bounds.minX + 10, y: bounds.size.height - lineHeight, width: bounds.size.width - 10, height: lineHeight)
            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }
        
        let backView = UIView(frame: bounds)
        backView.layer.insertSublayer(layer, at: 0)
        backView.backgroundColor = .clear
        cell.backgroundView = backView
    }
    
    
    /// 重新加载完成方法
    ///
    /// - Parameter completion: <#completion description#>
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.wrappedValue.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 移除TableFooterView
    func removeTableFooterView() {
        wrappedValue.tableFooterView = nil
    }
    
    /// 移除TableHeaderView.
    func removeTableHeaderView() {
        wrappedValue.tableHeaderView = nil
    }
    
    
    /// 滚动到底部
    ///
    /// - Parameter animated: 是否动画
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: wrappedValue.contentSize.height - wrappedValue.bounds.size.height)
        wrappedValue.setContentOffset(bottomOffset, animated: animated)
    }
    
    
    /// 滚动到顶部
    ///
    /// - Parameter animated: 是否动画
    func scrollToTop(animated: Bool = true) {
        wrappedValue.setContentOffset(CGPoint.zero, animated: animated)
    }
    
    
    /// 取消选中的动画
    /// - Parameter vc: 当前控制器
    func deselectRowAnimation(_ vc: UIViewController) {
        if let indexPath = wrappedValue.indexPathForSelectedRow {
            if let transitionCoordinator = vc.transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: { (context) in
                    self.wrappedValue.deselectRow(at: indexPath, animated: true)
                }, completion: nil)
                
                transitionCoordinator.notifyWhenInteractionChanges { (context) in
                    if context.isCancelled {
                        self.wrappedValue.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    }
                }
            } else {
                wrappedValue.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    /// 可重复使用的类名称UITableViewCell出列
    ///
    /// - Parameter name: UITableViewCell类型
    /// - Returns: 关联类UITableViewCell对象名称（可选值）
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        
        guard let cell = wrappedValue.dequeueReusableCell(withIdentifier: String(describing: name)) as? T  else {
            fatalError("请注册Cell")
        }
        return cell
    }
    
    
    /// 可重复使用的类的名字出列UITableViewCell indexpath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell类型
    ///   - indexPath: Tableview细胞定位
    /// - Returns: 相关的类名称UITableViewCell对象
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        
        guard let cell = wrappedValue.dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T  else {
            fatalError("请注册Cell")
        }
        return cell
    }
    
    
    /// 可重复使用的类名称uitableviewheaderfooterview出列
    ///
    /// - Parameter name: UITableViewHeaderFooterView 类型
    /// - Returns: 相关的类名称UITableViewHeaderFooterView对象(optional value)
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        
        guard let cell = wrappedValue.dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T  else {
            fatalError("请注册Cell")
        }
        return cell
    }
    
    
    /// 使用类名UITableViewHeaderFooterView
    ///
    /// - Parameters:
    ///   - nib: nib
    ///   - name: UITableViewHeaderFooterView 类型
    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        wrappedValue.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用类名UITableViewHeaderFooterView
    ///
    /// - Parameter name: UITableViewHeaderFooterView 类型
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        wrappedValue.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用类名UITableViewCell
    ///
    /// - Parameter name: UITableViewCell 类型
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        wrappedValue.register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用类名UITableViewCell
    ///
    /// - Parameters:
    ///   - nib: nil
    ///   - name: UITableViewCell 类型
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        wrappedValue.register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    
    /// 使用其登记UITableViewCell。XIB文件对应的类,假定xib文件名和细胞类有相同的名字。
    ///
    /// - Parameters:
    ///   - name: UITableViewCell 类型
    ///   - bundleClass: 绑定包实例的类
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle? = nil
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        wrappedValue.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
}

