//
//  WZIMUnknownTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/3.
//

import UIKit
import SnapKit

// MAKR - 未知消息
public class WZIMUnknownTableViewCell: WZIMBaseTableViewCell {

    private lazy var contentLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(contentLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        
        let maxWidth = WZIMConfig.maxWidth
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.lessThanOrEqualTo(maxWidth)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        contentLabel.textColor = getTextColor()
        contentLabel.text = "未知消息，请更新APP版本查看！"
    }
}
