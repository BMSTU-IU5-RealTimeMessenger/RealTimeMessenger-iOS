//
//  Aliases.swift
//  RealTimeMessenger
//
//  Created by Dmitriy Permyakov on 25.02.2024.
//

import Foundation

typealias MRKVoidBlock = () -> Void
typealias MRKBoolBlock = (Bool) -> Void
typealias MRKStringBlock = (String) -> Void
typealias MRKGenericBlock<T> = (T) -> Void
typealias MRKResultBlock<T, T1: Error> = (Result<T, T1>) -> Void
