//
//  APIError.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 25.02.2024.
//

import Foundation

enum APIError: Error {
    case isNotString
    case dataIsNil
    case error(Error)

    var alertMessage: String {
        switch self {
        case .isNotString:
            return "Была получена data, хотя ожидалась строка"
        case .dataIsNil:
            return "Полученные данные is nil"
        case .error:
            return "Соединение с сервером не установленно. Повторите попытку позже."
        }
    }
}
