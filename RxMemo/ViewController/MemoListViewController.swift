//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var viewModel: MemoListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func bindViewModel() {
        
        /// viewModel 에 저장되어 있는 타이틀이 navigation bar 에 표시됨
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // Observable 과 테이블뷰를 바인딩
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .do(onNext: { [unowned self] (_, indexPath) in
                self.listTableView.deselectRow(at: indexPath, animated: true)
            })
            .map { $0.0 }       // 이제 indexPath는 필요없으니 model만 방출되도록
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
    
    }
    
}
