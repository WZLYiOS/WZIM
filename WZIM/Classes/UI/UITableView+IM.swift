//
//  UITableView+IM.swift
//  WZIM
//
//  Created by qiuqixiang on 2021/1/6.
//

import UIKit
import Foundation
import WZNamespaceWrappable
import UITableView_FDTemplateLayoutCell

// MARK: - UITableView
public extension WZTypeWrapperProtocol where WrappedType: UITableView {
    
    func debugLogEnabled(_ enabled: Bool) {
        wrappedValue.fd_debugLogEnabled = enabled
    }
    
    /// 自动约束布局
    /// - Parameters:
    ///   - name: 标识符
    ///   - cacheByKey: 缓存key
    func heightForCell<T: UITableViewCell>(withClass name: T.Type, cacheByKey: String? = nil, configuration: @escaping (_ cell: T) -> Void) -> CGFloat{
        let cellId = String(describing: name)
        let cacheKey = cellId + (cacheByKey ?? "") as NSString
        return wrappedValue.fd_heightForCell(withIdentifier: cellId, cacheByKey: cacheKey) { (xcell) in
            let cell = xcell as! T
            cell.fd_isTemplateLayoutCell = true
            configuration(cell)
        }
    }
    
    /// 为I
    func heightForIMCell(withClass name: UITableViewCell.Type, cacheByKey: String? = nil, configuration: @escaping (_ cell: WZIMBaseTableViewCell) -> Void) -> CGFloat{
        return heightForCell(withClass: name, cacheByKey: cacheByKey) { (xcell) in
            configuration(xcell as! WZIMBaseTableViewCell)
        }
    }
}
