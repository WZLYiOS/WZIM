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

    private var dataArray: [WZConversationProcotol] = []
    
    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableViewAutomaticDimension
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView()
        $0.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
        $0.wz_pullToRefresh(target: self, refreshingAction: #selector(pullToRefresh))
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
        pullToRefresh()
    }
    
    @objc func pullToRefresh() {
        
        
        UserSession.shared.imManager.wzGetConversationList(nextSeq: 0, count: 100) { [self] (list, seq, isFinish) in
            self.dataArray =  list
            self.tableView.reloadData()
        } fail: { (code, msg) in
            debugPrint("获取会话列表失败")
        }
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
        vc.userId = model.receiverId
        self.navigationController?.pushViewController(vc, animated: true)
        

//        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
}
