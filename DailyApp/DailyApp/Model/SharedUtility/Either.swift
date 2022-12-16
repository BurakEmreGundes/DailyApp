//
//  Either.swift
//  DailyApp
//
//  Created by Burak Emre gündeş on 16.12.2022.
//

import Foundation


enum Either<T, R> {
    case this(model: T)
    case that(model: R)
    
    var tryThis: T? {
        if case .this(let model) = self {
            return model
        } else { return nil }
    }
    
    var tryThat: R? {
        if case .that(let model) = self {
            return model
        } else { return nil }
    }
    
    func mapThis<C>(_ mapper: (T) -> C) -> Either<C, R> {
        switch self {
        case .this(let model):
            return .this(model: mapper(model))
        case .that(let model):
            return .that(model: model)
        }
    }
    
    func mapThat<C>(_ mapper: (R) -> C) -> Either<T, C> {
        switch self {
        case .that(let model):
            return .that(model: mapper(model))
        case .this(let model):
            return .this(model: model)
        }
    }
    
    func flatMapThis<C>(_ mapper: (T) -> Either<C, R>) -> Either<C, R> {
        switch self {
        case .this(let model):
            return mapper(model)
        case .that(let model):
            return .that(model: model)
        }
    }
}


extension Either: Codable where T: Codable, R: Codable {
    init(from decoder: Decoder) throws {
        do {
            let model = try T(from: decoder)
            self = .this(model: model)
        } catch let thisError {
            do {
                let model = try R(from: decoder)
                self = .that(model: model)
            } catch let thatError {
                throw CarlaError.couldNotDecodeEither(thisError: thisError, thatError: thatError)
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .this(let model):
            try model.encode(to: encoder)
        case .that(let model):
            try model.encode(to: encoder)
        }
    }
}



