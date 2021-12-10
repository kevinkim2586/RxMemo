//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    var viewModel: MemoComposeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        
    }
    
    func bindViewModel() {
        
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // 메모 쓰기 모드에서는 빈문자열이 표시되고, 편지 모드에서는 편집할 메모가 표시된다
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        cancelButton.rx.action = viewModel.cancelAction
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) // 더블탭을 막기 위해 0.5초에 한번씩만 tap 이벤트 처리
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }

}
