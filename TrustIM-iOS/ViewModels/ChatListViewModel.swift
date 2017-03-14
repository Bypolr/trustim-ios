//
// Created by towry on 14/03/2017.
// Copyright (c) 2017 towry. All rights reserved.
//

import RxSwift
import RxDataSources

class ChatListViewModel {
    func getChatList() -> Observable<[SectionModel<String, ChatItem>]> {
        return Observable.create { (observer) -> Disposable in
            let list = [
                ChatItem(icon: "demo.png", nickname: "towry", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry2", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry3", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry4", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry5", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry6", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry7", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry8", datetime: "2017-10-10", unread: 23, message: "hello"),
                ChatItem(icon: "demo.png", nickname: "towry9", datetime: "2017-10-10", unread: 23, message: "hello"),
            ]

            let section: [SectionModel<String, ChatItem>] = [SectionModel(model: "", items: list)]
            observer.onNext(section)
            observer.onCompleted()

            return AnonymousDisposable{}
        }
    }
}