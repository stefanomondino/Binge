//
//  Validator.swift
//  Skeleton
//
//  Created by Stefano Mondino on 10/08/2020.
//

import Foundation

enum ValidationError: Swift.Error {
    case email
    case empty
    case password
    case undefined
}

enum ValidationType {
    case email
    case password
}

protocol Validator {
    func validate(_ string: String?, for type: ValidationType) -> ValidationError?
}

struct DefaultValidator: Validator {
    struct Checker {
        var string: String
        func validateEmpty() throws {
            guard string.isEmpty == false else { throw ValidationError.empty }
        }

        func validateEmail() throws {
            try validateEmpty()
            guard matchesRegExp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}") else {
                throw ValidationError.email
            }
        }

        func validatePassword() throws {
            try validateEmpty()
            guard matchesRegExp("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}") else {
                throw ValidationError.password
            }
        }

        private func matchesRegExp(_ regexp: String) -> Bool {
            NSPredicate(format: "SELF MATCHES %@", regexp).evaluate(with: string)
        }
    }

    func validate(_ string: String?, for type: ValidationType) -> ValidationError? {
        let checker = Checker(string: string ?? "")
        do {
            switch type {
            case .email: try checker.validateEmail()
            case .password: try checker.validatePassword()
            }
        } catch {
            return error as? ValidationError ?? .undefined
        }
        return nil
    }
}
