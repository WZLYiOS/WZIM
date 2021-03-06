//
//  WZIMTimeTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/3.
//

import UIKit
import SnapKit

// MARK - 时间
public class WZIMTimeTableViewCell: WZIMBaseTableViewCell {
    
    private lazy var timeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .center
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x999999")
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(timeLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview()
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        uploadConstraints(type: .center)
        if case let .time(elem) = model.currentElem {
            timeLabel.text = Date.wzImDateText(elem.time)
        }
    }
    
    public override func upload(model: WZMessageData, cDelegate: WZIMTableViewCellDelegate) {
        super.upload(model: model, cDelegate: cDelegate)
        uploadConstraints(type: .center)
        if case let .time(elem) = model {
            timeLabel.text = Date.wzImDateText(elem.time)
        }
    }
}
