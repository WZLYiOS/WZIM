//
//  UITableView+WZIM.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/14.
//

import Foundation

/// 注册cell
public extension UITableView {
    
    /// 注册cell
    func wzIMRegisterCell() {
        wzRegister(cellWithClass: WZIMBaseTableViewCell.self)
        wzRegister(cellWithClass: WZIMActivityTableViewCell.self)
        wzRegister(cellWithClass: WZIMMakingCourseTableViewCell.self)
        wzRegister(cellWithClass: WZIMNameAuthInvateTableViewCell.self)
        wzRegister(cellWithClass: WZIMPictureTableViewCell.self)
        wzRegister(cellWithClass: WZIMRecommendCardTableViewCell.self)
        wzRegister(cellWithClass: WZIMServiceCompactTableViewCell.self)
        wzRegister(cellWithClass: WZIMTextTableViewCell.self)
        wzRegister(cellWithClass: WZIMTimeTableViewCell.self)
        wzRegister(cellWithClass: WZIMUnknownTableViewCell.self)
        wzRegister(cellWithClass: WZIMVideoInviteTableViewCell.self)
        wzRegister(cellWithClass: WZIMVoiceTableViewCell.self)
    }
    
    /// 使用类名UITableViewCell
    private func wzRegister<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
}
