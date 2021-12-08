//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Kevin Kim on 2021/12/08.
//

import Foundation

//MARK: - 화면 전환 방식에 대한 열거형

enum TransitionStyle {
    case root
    case push
    case modal
}

//MARK: - 화면 전환에서 에러가 발생했을 때를 위한 Error enum
 
enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
