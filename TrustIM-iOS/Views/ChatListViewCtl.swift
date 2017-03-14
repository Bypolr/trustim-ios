//
// Created by towry on 13/03/2017.
// Copyright (c) 2017 towry. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ChatListViewCtl: BaseViewCtl {
    var tableView: UITableView!
    let disposeBag = DisposeBag
    let viewModel = ChatListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conversation"

        tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(tableView)

        // let dataSource = RxTableViewReactiveArrayDataSource
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "kCellId")
//        cell.textLabel?.text = "New York"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 50
//    }
}