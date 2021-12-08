//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxSwift
import RxCocoa

///ViewModel 에는 크게 2가지가 들어감
///1. 의존성을 주입하는 생성자
///2. 바인딩에 사용되는 속성과 메서드

class MemoListViewModel: CommonViewModel {
    
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
