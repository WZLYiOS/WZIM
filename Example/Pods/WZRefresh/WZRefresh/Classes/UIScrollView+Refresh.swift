//
//  UIScrollView+.swift
//  WZLY
//
//  Created by qiuqixiang on 2019/10/23.
//  Copyright © 2019 我主良缘. All rights reserved.
//

import UIKit
import MJRefresh
import Foundation

/// MARK - 刷新协议
public protocol Refresh {
    
    /// 刷新视图
    var refreshView: MJRefreshComponent { get }
    
    /// 刷新block
    /// - Parameter handler: handler description
    func refreshingBlock(handler: @escaping () -> Void)
    
    /// 刷新
    /// - Parameter target: 目标
    /// - Parameter action: 事件
    func refreshingTarget(_ target: Any, refreshingAction action: Selector)
}

/// MARK - 默认实现
public extension Refresh {
    
    /// 刷新block
    /// - Parameter handler: handler description
    func refreshingBlock(handler: @escaping () -> Void) {
        self.refreshView.refreshingBlock = {
            handler()
        }
    }
    
    /// 刷新
    /// - Parameter target: 目标
    /// - Parameter action: 事件
    func refreshingTarget(_ target: Any, refreshingAction action: Selector) {
        self.refreshView.setRefreshingTarget(target, refreshingAction: action)
    }
}


/// MARK - 默认头部刷新
public class DefaultRefreshHeader: Refresh {

    public lazy var refreshView: MJRefreshComponent = {
        let temElement = MJRefreshNormalHeader()
        temElement.isAutomaticallyChangeAlpha = true
        return temElement
    }()
}


/// MARK - 默认底部自动刷新
public class DefaultRefreshAutoFooter: Refresh {
    
    public lazy var refreshView: MJRefreshComponent = {
        let temElement = MJRefreshAutoStateFooter()
        temElement.setTitle("没有更多数据", for: MJRefreshState.noMoreData)
        temElement.triggerAutomaticallyRefreshPercent = -UIScreen.main.bounds.height/2.0/44.0
        temElement.isOnlyRefreshPerDrag = false
        return temElement
    }()
}

// MARK: - UIScrollView + 刷新的扩展
@objc public extension UIScrollView {
    
    /// MARK: - 底部刷新状态
    @objc enum BottomRefreshState: Int {
        case normal
        case noMoreData
        case hidden
    }

    /// MARK: - 顶部刷新状态
    @objc enum HeadRefreshState: Int {
        case normal
        case hidden
    }
    
    /// 开始刷新
   @objc func wz_beginRefreshing() {
        self.mj_header.beginRefreshing()
    }
    
    /// 停止刷新
   @objc func wz_endRefreshing() {
        
        if (self.mj_header != nil) && self.mj_header.isRefreshing {
           self.mj_header.endRefreshing()
        }
        
        if (self.mj_footer != nil) && self.mj_footer.isRefreshing {
            self.mj_footer.endRefreshing()
        }
    }
     
    /// 移除顶部刷新控件
   @objc func wz_removeHeadRefreshing() {
        self.mj_header = nil
    }
    
    /// 刷新顶部视图状态
    /// - Parameter state: 顶部视图状态
   @objc func wz_headRefreshState(state: HeadRefreshState) {
       switch state {
        case .hidden:
            self.mj_header.isHidden = true
        case .normal:
            self.mj_header.isHidden = false
        }
    }
    
    /// 底部刷新状态
    /// - Parameter state: 状态
    @objc func wz_bottomRefreshState(state: BottomRefreshState) {
        switch state {
        case .hidden:
            self.mj_footer.isHidden = true
        case .noMoreData:
            self.mj_footer.isHidden = false
            self.mj_footer.endRefreshingWithNoMoreData()
        case .normal:
            self.mj_footer.isHidden = false
            self.mj_footer.resetNoMoreData()
        }
    }
    
    
    /// 下拉刷新
    /// - Parameter header: 头部刷新
    /// - Parameter handler: handler description
   @objc func wz_pullToRefresh(target: Any, refreshingAction action: Selector) {
        
        let header = DefaultRefreshHeader()
        header.refreshingTarget(target, refreshingAction: action)
        self.mj_header = (header.refreshView as! MJRefreshHeader)
    }
    
    /// 下拉刷新
    /// - Parameter handler: handler description
   @objc func wz_pullToRefresh(handler: @escaping () -> Void) {
        
        let header = DefaultRefreshHeader()
        self.mj_header = (header.refreshView as! MJRefreshHeader)
        header.refreshingBlock(handler: handler)
    }
    

    /// 加载更多
    /// - Parameter target: target description
    /// - Parameter action: action description
   @objc func wz_loadMoreFooter(target: Any, refreshingAction action: Selector) {
        
        let footer = DefaultRefreshAutoFooter()
        footer.refreshingTarget(target, refreshingAction: action)
        self.mj_footer = (footer.refreshView as! MJRefreshFooter)
    }
    
    /// 加载更多
    /// - Parameter handler: handler description
   @objc func wz_loadMoreFooter(handler: @escaping () -> Void) {
        
        let footer = DefaultRefreshAutoFooter()
        self.mj_footer = (footer.refreshView as! MJRefreshFooter)
        footer.refreshingBlock(handler: handler)
    }
    
    /// 添加背景空视图
    /// - Parameter view: 空视图
    @objc func wz_addBackgroundEmpty(view: UIView) {
        self.wzEmptyView = view
        self.wzObservation = self.observe(\.contentSize, options: .new) { scrollView, change in
            
            scrollView.refreshFootState()
            
            if let tab = scrollView as? UITableView {
                tab.backgroundView = self.mj_totalDataCount() == 0 ? scrollView.wzEmptyView : nil
                return
            }
            
            if let coll = scrollView as? UICollectionView {
                coll.backgroundView = self.mj_totalDataCount() == 0 ? scrollView.wzEmptyView : nil
                return
            }
        }
    }
    
    /// footView 添加占位图
    /// - Parameter view: 空视图
    @objc func wz_addFootEmpty(view: UIView){
        self.wzEmptyView = view
        self.mj_header.endRefreshingCompletionBlock = {
            if let tab = self as? UITableView {
                tab.tableFooterView = self.mj_totalDataCount() == 0 ? self.wzEmptyView : nil
            }
        }
        self.wzObservation = self.observe(\.contentSize, options: .new) { scrollView, change in
            scrollView.refreshFootState()
        }
    }
    
    /// 下拉刷新 针对tableview 和 collectionview  背景view自动添加空视图 将要废弃
    /// - Parameter header: 头部刷新
    /// - Parameter handler: handler description
    @objc func wz_refreshHeaderBackgroundView(target: Any, refreshingAction action: Selector) {
        
        let header = DefaultRefreshHeader()
        header.refreshingTarget(target, refreshingAction: action)
        self.mj_header = (header.refreshView as! MJRefreshHeader)
      
        self.wzObservation = self.observe(\.contentSize, options: .new) { scrollView, change in
            
            scrollView.refreshFootState()
            
            if let tab = scrollView as? UITableView {
                tab.backgroundView = self.mj_totalDataCount() == 0 ? scrollView.wzEmptyView : nil
                return
            }
            
            if let coll = scrollView as? UICollectionView {
                coll.backgroundView = self.mj_totalDataCount() == 0 ? scrollView.wzEmptyView : nil
                return
            }
        }
    }
    
    /// 下拉刷新 针对tableview 和 collectionview  FootView自动添加空视图
    /// - Parameter header: 头部刷新
    /// - Parameter handler: handler description
    @objc func wz_refreshHeaderTableFooterView(target: Any, refreshingAction action: Selector) {
    
        let header = DefaultRefreshHeader()
        header.refreshingTarget(target, refreshingAction: action)
        self.mj_header = (header.refreshView as! MJRefreshHeader)
        self.mj_header.endRefreshingCompletionBlock = {
            if let tab = self as? UITableView {
                tab.tableFooterView = self.mj_totalDataCount() == 0 ? self.wzEmptyView : nil
            }
        }
        self.wzObservation = self.observe(\.contentSize, options: .new) { scrollView, change in
            scrollView.refreshFootState()
        }
    }
    
    /// 更新底部状态
    private func refreshFootState() {
        if (self.mj_footer != nil) && self.mj_footer.state == .idle {
            
            if  self.contentSize.height < self.bounds.height {
                if self.mj_footer.isHidden == false {
                    self.wz_bottomRefreshState(state: .hidden)
                }
            }else {
                if self.mj_footer.isHidden == true && self.mj_header.state == .idle {
                    self.wz_bottomRefreshState(state: .normal)
                }
            }
        }
    }
}

private struct AssociatedKeys {
    static var emptyViewKey: String = "com.wzly.refresh.emptyView"
    
    static var observationKey: String = "com.wzly.refresh.observation"
}

// MAKR - 添加占位视图等刷新机制
 @objc public extension UIScrollView {
    
    /// 空视图占位
    @objc var wzEmptyView: UIView? {
         get {
             return (objc_getAssociatedObject(self, &AssociatedKeys.emptyViewKey) as? UIView)
         }
         set(newValue) {
             objc_setAssociatedObject(self, &AssociatedKeys.emptyViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
         }
     }
     
     /// 监听属性
    private var wzObservation: NSKeyValueObservation? {
         get {
             return (objc_getAssociatedObject(self, &AssociatedKeys.observationKey) as? NSKeyValueObservation)
         }
         set(newValue) {
             objc_setAssociatedObject(self, &AssociatedKeys.observationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
         }
     }
}
