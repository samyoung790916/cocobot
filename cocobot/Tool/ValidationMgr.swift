//
//  ValidationMgr.swift
//  cocobot
//
//  Created by samyoung79 on 22/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import Foundation



import Foundation

extension String {
    public var fullRange : NSRange {
        return NSMakeRange(0, self.count)
    }
    public func replace(of targetString: String?, with withString: String) -> String {
        guard let target = targetString else {return self}
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

class ValidationMgr {
    
    enum FailureReason {
        case length
        case invalidation
        case dismatch
    }
    
    struct PhoneNumber {
        let withHypen : String
        let withoutHypen : String
    }
    
    enum ValidationResult {
        case success (_ : PhoneNumber?)
        case failure (FailureReason)
    }
    
    enum `Type` {
        case email (address : String)
        case phone (number : String)
        case password(pw: String, check: String)
        case range (text : String, range : CountableRange<Int>)
        case id(id : String)
    }
    
    static let shared = ValidationMgr()
    private init() {}
    
    open var emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    open var phoneNumberRegex = "^(\\d{2,3})-?(\\d{3,4}?)-?(\\d{3,4})$"
    open var idRegex = "^[a-z0-9]*$"
    private var validator : Validator!
    
    func validate(_ type : `Type`, completion : (ValidationResult) -> ()) {
        switch type {
        case .phone(let phone):
            validator = .phone(regex: phoneNumberRegex)
            switch validator.validate(phoneNumber: phone) {
            case .success(let numberWithHypen, let numberWithoutHypen):
                completion(.success(PhoneNumber(withHypen: numberWithHypen, withoutHypen : numberWithoutHypen)))
            case .failure:
                completion(.failure(.invalidation))
            }
        case .email(let email):
            validator = .email(regex : emailRegex)
            if validator.validate(value: email) {
                completion(.success(nil))
            }
            completion(.failure(.invalidation))
        case .password(let pw, let check):
            guard pw == check else {
                completion(.failure(.dismatch))
                return
            }
            completion(.success(nil))
        case .range(let text, let range) :
            guard range.contains(text.count) else {
                completion(.failure(.length))
                return
            }
            completion(.success(nil))
        case .id(let id):
            validator = .id(regex: idRegex)
            if validator.validate(value: id) {
                completion(.success(nil))
            } else {
                completion(.failure(.invalidation))
            }
        }
    }
}

private enum Validator {
    
    enum PhoneResult {
        case success (withHypen : String, withoutHypen : String)
        case failure
    }
    
    case email (regex : String)
    case phone (regex : String)
    case password (password : String, check : String)
    case id (regex : String)
    
    private var pattern : NSRegularExpression? {
        switch self {
        case .id(let regex):
            return try? NSRegularExpression(pattern: regex, options: [])
        case .phone(let regex):
            return try? NSRegularExpression(pattern: regex, options: [])
        case .email(let regex):
            return try? NSRegularExpression(pattern: regex, options: [])
        case .password (_, _):
            return nil
        }
    }
    
    func validate(value : String) -> Bool {
        switch self {
        case .email(let regex):
            let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", regex)
            return emailTest.evaluate(with: value)
        case .id(_):
            guard let pattern = self.pattern,
                let _ = pattern.firstMatch(in: value, options: [], range: value.fullRange) else {
                    debugPrint("invalid Regex")
                    return false
            }
            return true
        default:
            return false
        }
    }
    
    func validate(phoneNumber : String) -> PhoneResult {
        switch self {
        case .phone(_):
            guard let pattern = self.pattern,
                let match = pattern.firstMatch(in: phoneNumber, options: [], range: phoneNumber.fullRange) else {
                    debugPrint("invalid Regex")
                    return .failure
            }
            var matchStrings = [String]()
            for i in 1 ..< match.numberOfRanges {
                if let range = Range(match.range(at: i), in : phoneNumber) {
                    matchStrings.append(String(phoneNumber[range]))
                }
            }
            return .success(withHypen: matchStrings.joined(separator: "-"), withoutHypen: matchStrings.joined(separator: ""))
        default:
            return .failure
        }
    }
}
