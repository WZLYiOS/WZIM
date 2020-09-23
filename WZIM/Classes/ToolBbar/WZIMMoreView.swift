//
//  WZIMMoreView.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/27.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import SnapKit

// MARK - IMTabbar 更多视图
public class WZIMMoreView: UIView {
    
    /// 横向排列个数
    public weak var delegate: WZIMMoreViewDelegate!
    
    /// 列表
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout = WZIMMoreCollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4, height: 80)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.scrollDirection = .horizontal
        
        let temView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        temView.backgroundColor = UIColor.clear
        temView.dataSource = self
        temView.delegate = self
        temView.showsHorizontalScrollIndicator = false
        temView.showsVerticalScrollIndicator = false
        temView.isPagingEnabled = true
        temView.register(WZIMMoreCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: WZIMMoreCollectionViewCell.self))
        return temView
    }()
    
    /// 分页器
    private lazy var pageControl: UIPageControl = {
        $0.pageIndicatorTintColor = WZIMToolAppearance.hexadecimal(rgb: 0xcccdce)
        $0.currentPageIndicatorTintColor = WZIMToolAppearance.hexadecimal(rgb: 0x7c7e7f)
        return $0
    }(UIPageControl())
    
    public init(delegate: WZIMMoreViewDelegate) {
        super.init(frame: CGRect.zero)
        self.delegate = delegate
        self.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF3F3F3)
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        self.addSubview(collectionView)
        self.addSubview(pageControl)
    }
    func configViewLocation() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(175)
        }
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.height.equalTo(7)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-WZIMToolAppearance.safeAreaInsetsBottom-13)
        }
    }
    
    public func reloadUI() {
        let list = delegate.listMoreView(moreView: self)
        collectionView.reloadData()
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(list.count > 4 ? 175 : 100)
        }
        pageControl.numberOfPages = (list.count+8-1)/8;
        pageControl.isHidden = list.count > 8 ? false : true
    }
}

/// MARK - UICollectionViewDataSource
extension WZIMMoreView: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.listMoreView(moreView: self).count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WZIMMoreCollectionViewCell.self), for: indexPath) as! WZIMMoreCollectionViewCell
        cell.reload(model: delegate.listMoreView(moreView: self)[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.moreView(moreView: self, select: delegate.listMoreView(moreView: self)[indexPath.row])
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = ceil(scrollView.contentOffset.x/self.frame.size.width)
        pageControl.currentPage = Int(x);
    }
}

// MARK - 重写ContentSize
class WZIMMoreCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var collectionViewContentSize: CGSize {
        
        let size: CGSize = super.collectionViewContentSize
        let collectionViewWidth: CGFloat = self.collectionView?.frame.size.width ?? 0
        if collectionViewWidth == 0 {
            return size
        }
        let nbOfScreen: Int = Int(ceil(size.width / collectionViewWidth))
        let newSize: CGSize = CGSize(width: collectionViewWidth * CGFloat(nbOfScreen), height: size.height)
        return newSize
    }
}

// MARK - WZIMMoreViewDelegate
public protocol WZIMMoreViewDelegate: class {
    
    /// 点击回调
    func moreView(moreView: WZIMMoreView, select item: WZIMMoreItem)
    
    /// 获取数据源
    func listMoreView(moreView: WZIMMoreView) -> [WZIMMoreItem]
}

// MARK - 更多cell
final class WZIMMoreCollectionViewCell: UICollectionViewCell {
    
     /// 顶部视图
    private lazy var topImageView: UIImageView = {
        return $0
    }(UIImageView())
    
    /// 文字
    private lazy var titleLabel: UILabel = {
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0x666666)
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12)
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configView() {
        contentView.addSubview(topImageView)
        contentView.addSubview(titleLabel)
    }
    func configViewLocation() {
        topImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalTo(topImageView.snp.bottom).offset(5)
        }
    }
    
    func reload(model: WZIMMoreItem) {
        topImageView.image = UIImage(named: model.image)
        titleLabel.text = model.title
    }
}


// MARK - 数据模型
public class WZIMMoreItem {
    
    /// 图片
   public let image: String
    
    /// 标题
   public let title: String
    
   public init(image: String, title: String) {
        self.image = image
        self.title = title
    }
}
