//
//  ListViewController.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import WZIM

class ListViewController: UIViewController {

    private var dataArray: [WZIMConversationProcotol] {
        return UserSession.shared.wzTim.getConversationList()
    }
    
    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableViewAutomaticDimension
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView()
        $0.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(greetingTextFieldChanged(obj:)), name: UserSession.ImLoginSucessNotification, object: nil)
    }
    
    @objc
    func greetingTextFieldChanged(obj: Notification) {
        debugPrint(dataArray)
        self.tableView.reloadData()
    }
}

// MARK - HBConversationViewController
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let model = dataArray[indexPath.row]
        cell.reload(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        let vc = WZIMConversionViewController()
        vc.userId = model.wzReceiverId()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
