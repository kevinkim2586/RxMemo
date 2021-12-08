//
//  Scene.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import UIKit

//MARK: - 앱에서 구현할 scene 을 열거형으로 선언

enum Scene {
    case list(MemoListViewModel)        //Scene과 연관된 ViewModel 을 연관값으로 저장
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            
            listVC.bind(viewModel: memoListViewModel)
            return nav
            
        case .detail(let memoDetailViewModel):
            
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            
            detailVC.bind(viewModel: memoDetailViewModel)
            return detailVC
            
        case .compose(let memoComposeViewModel):
            
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
            
            composeVC.bind(viewModel: memoComposeViewModel)
            return nav
        }
    }
}
