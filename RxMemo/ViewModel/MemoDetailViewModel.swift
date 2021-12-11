//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxSwift
import RxCocoa
import Action


class MemoDetailViewModel: CommonViewModel {

    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    /// 왜 BehaviorSubject인가?
    /// 메모를 편집한 다음에 다시 보기화면으로 오면 편집한 내용이 반영되어야한다.
    /// 이렇게 하기 위해서는 새로운 문자열 배열을 방출해야함
    /// 일반 Observable 로 하면 이게 불간으함
    var contents: BehaviorSubject<[String]>

    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { updated in
                    self.contents.onNext([
                        updated.content,
                        self.formatter.string(from: updated.insertDate)
                    ])
                })
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }

    func makeDeleteAction() -> CocoaAction {
        return CocoaAction { input in
            self.storage.delete(memo: self.memo)
            return self.sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
    }

}
