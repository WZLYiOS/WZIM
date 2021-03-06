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
    public weak var delegate: WZIMMoreViewDelegate?
    
    /// 列表
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
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
        temView.alwaysBounceHorizontal = true
        temView.register(WZIMMoreCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: WZIMMoreCollectionViewCell.self))
        return temView
    }()
    
    /// 数据源
    private var rowCount: Int = 0
    
    private var itemsInSection: Int = 0
    private var sectionCount: Int = 0
    
    private var itemIndexs:[IndexPath: Int] = [:]
    
    /// 分页器
    private lazy var pageControl: UIPageControl = {
        $0.pageIndicatorTintColor = WZIMToolAppearance.hexadecimal(rgb: "0xcccdce")
        $0.currentPageIndicatorTintColor = WZIMToolAppearance.hexadecimal(rgb: "0x7c7e7f")
        return $0
    }(UIPageControl())
    
    /// 分割线颜色
    public lazy var lineView: UIView = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xE8E8E8")
        return $0
    }(UIView())
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        self.addSubview(lineView)
    }

    public func reloadUI() {
    
        let list = delegate?.listMoreView(moreView: self) ?? []
       
        let columnCount = 4
        rowCount = list.count > columnCount ? 2 : 1
        itemsInSection =  columnCount * rowCount
        sectionCount = Int(ceil(Double(list.count) / Double(itemsInSection)))
        
        for curSection in 0...sectionCount {
            for itemIndex in 0...itemsInSection {
                
                let row = itemIndex % rowCount
                let column = itemIndex / rowCount
                let reIndex = columnCount * row + column + curSection * itemsInSection;
                itemIndexs[IndexPath(row: itemIndex, section: curSection)] = reIndex
            }
        }
        
        pageControl.numberOfPages = sectionCount
        pageControl.isHidden = sectionCount == 1 ? true : false
        collectionView.reloadData()
        collectionView.snp.updateConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(list.count > 4 ? 175 : 100)
        }
        pageControl.snp.updateConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.height.equalTo(7)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13).priority(.low)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalToSuperview()
        }
    }
}

/// MARK - UICollectionViewDataSource
extension WZIMMoreView: UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsInSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WZIMMoreCollectionViewCell.self), for: indexPath) as! WZIMMoreCollectionViewCell
        
        let index = Int(itemIndexs[indexPath] ?? 0)
        let list = delegate!.listMoreView(moreView: self)
        if index <= list.count - 1 {
            cell.reload(model: list[index])
        }else{
            cell.reload(model: nil)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = Int(itemIndexs[indexPath] ?? 0)
        let list = delegate!.listMoreView(moreView: self)
        if index <= list.count - 1 {
            delegate!.moreView(moreView: self, select: list[index])
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = ceil(scrollView.contentOffset.x/self.frame.size.width)
        pageControl.currentPage = Int(x);
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
    public lazy var titleLabel: UILabel = {
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x666666")
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
    
    func reload(model: WZIMMoreItem?) {
        
        guard let ix = model else {
            topImageView.image = nil
            titleLabel.text = ""
            return
        }
        
        topImageView.image = UIImage(named: ix.image)
        titleLabel.text = ix.title
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
