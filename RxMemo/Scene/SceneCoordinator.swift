//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.first ?? self
    }
}

//MARK: - 화면 전환 담당
/// Window 인스턴스와 현재 화면에 표시되어있는 Scene 을 속성으로 가지고 있어야 함.
class SceneCoordinator: SceneCoordinatorType {
    
    private let disposeBag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        
        ///전환 결과를 방출할 Subject 필요
        let subject = PublishSubject<Void>()
        
        let targetVC = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = targetVC.sceneViewController
            window.rootViewController = targetVC
            subject.onCompleted()
        case .push:
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .subscribe( onNext: { [unowned self] evt in
                    self.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: disposeBag)
            
            
            nav.pushViewController(targetVC, animated: animated)
            currentVC = targetVC.sceneViewController
            subject.onCompleted()
        case .modal:
            currentVC.present(targetVC, animated: animated) {
                subject.onCompleted()
            }
            currentVC = targetVC.sceneViewController
        }
        return Completable.empty()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        
        ///여기서는 Completable 을 직접 생성해서 리턴하는 방식으로 구현
        
        return Completable.create { [unowned self] completable in
            
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }
            else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
    
    
}
