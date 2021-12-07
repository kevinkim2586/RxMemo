//
//  Memo.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation

struct Memo: Equatable {
    var content: String     // 메모 내용
    var insertDate: Date    // 생성 날짜
    var identity: String    // 메모를 구분할 때 사용되는 속성
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}
