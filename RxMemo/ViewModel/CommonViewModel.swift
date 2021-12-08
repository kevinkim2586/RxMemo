//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxSwift
import RxCocoa

/// 앱을 구성하고 있는 모든 Scene 은 Navigation Controller 에 임베드되기 때문에
/// navigation title이 필요하다
/// title 속성을 추가하고 driver 형식으로 선언

class CommonViewModel: NSObject {
    
    let title: Driver<String>       // Navigation Item 에 쉽게 바인딩하기 위함
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    /// 위 2 형식으로 프로토콜로 선언함으로써 의존성 수정이 수월해짐
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
