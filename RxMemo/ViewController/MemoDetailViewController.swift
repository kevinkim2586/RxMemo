//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import UIKit

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    var viewModel: MemoDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        
    }


}
