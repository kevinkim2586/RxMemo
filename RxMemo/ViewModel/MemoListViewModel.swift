//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import RxDataSources

/// 메모 목록은 하나의 섹션에서 표시되고, 테이블뷰에서 섹션 헤더나 푸터는 표시하지 않기 때문에 SectionData 는 신경 쓸 필요 X

// 우리가 사용할 Section Model 은 아래와 같음 -> SectionData 의 형식은 Int, Row data 의 형식은 Memo
typealias MemoSectionModel = AnimatableSectionModel<Int, Memo>

///ViewModel 에는 크게 2가지가 들어감
///1. 의존성을 주입하는 생성자
///2. 바인딩에 사용되는 속성과 메서드

class MemoListViewModel: CommonViewModel {
    
//    var memoList: Observable<[Memo]> {
//        return storage.memoList()
//    }
    
    ///테이블뷰에 section 이 1개라면 rxcocoa 에서 제공하는걸로 충분하지만, section 이 2개라면 rxdatasource 를 활용하는 것이 더 좋을 것임
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel> { (dataSource, tableView, indexPath, memo) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        }
        ds.canEditRowAtIndexPath = { _, _ in return true }
        return ds
    }()
    
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList()
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(
                        title: "새 메모",
                        sceneCoordinator: self.sceneCoordinator,
                        storage: self.storage,
                        saveAction: self.performUpdate(memo: memo),
                        cancelAction: self.performCancel(memo: memo)
                    )
                    
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map { _ in }
                }
        }
    }
    
    //속성 형태로 구현 instead of method 형태 -> 다양한 코드 볼 수 있도록
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            
            let detailViewModel = MemoDetailViewModel(
                memo: memo,
                title: "메모 보기",
                sceneCoordinator: self.sceneCoordinator,
                storage: self.storage
            )
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map { _ in }
        }
    }()
    
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action { memo in
            return self.storage.delete(memo: memo).ignoreElements()
        }
    }()

}
