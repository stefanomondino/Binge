import Nimble
enum ExpectationError: Swift.Error {
    case wrongType
}

extension Expectation {
    #if swift(>=4.1)
    #else
        init(_ expression: Expression<T>) {
            self.expression = expression
        }
    #endif

    internal func transform<U>(_ closure: @escaping (T?) throws -> U?) -> Expectation<U> {
        let exp = expression.cast(closure)
        #if swift(>=4.1)
            return Expectation<U>(expression: exp)
        #else
            return Expectation<U>(exp)
        #endif
    }

    func `as`<U>(_: U.Type, closure: @escaping (U) throws -> Void = { _ in }) -> Expectation<Any> {
        return expect {
            guard let value = try self.expression.evaluate() as? U else {
                throw ExpectationError.wrongType
            }
            expect { try closure(value) }.notTo(throwError())
            return nil
        }
    }
}
