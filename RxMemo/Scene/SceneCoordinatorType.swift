//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxSwift

//MARK: - Scene Coordinator 가 공통적으로 구현해야 하는 멤버를 선언

protocol SceneCoordinatorType {
    
    /// 새로운 Scene 을 표시한다.
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    /// 현재 Scene 을 닫고 이전 Scene 으로 돌아간다.
    /// 여기에 구독자를 추가하고, 화면 전환이 완료되면 원하는 작업을 구현 가능. 필요없으면 안 써도 됨.
    @discardableResult
    func close(animated: Bool) -> Completable
}
