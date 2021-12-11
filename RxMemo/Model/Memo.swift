//
//  Memo.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation
import RxDataSources
//RxDataSources 는 테이블뷰와 컬렉션뷰에 바인딩 할 수 있는 데이터소스를 제공한다
//데이터소스에 저장되어 있는 모든 데이터는 반드시 IdentifiableType 프로토콜을 준수해야한다.

struct Memo: Equatable, IdentifiableType {
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
