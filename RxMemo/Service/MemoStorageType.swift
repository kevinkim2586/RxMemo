//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
