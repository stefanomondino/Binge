import Nimble
import RxRelay

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

    func triggering<U>(closure: @escaping () -> Void) -> Expectation<U?> where T: PublishRelay<U> {
        let publish = (try? expression.evaluate()) ?? PublishRelay<U>()
        let behavior = BehaviorRelay<U?>(value: nil)
        let disposable = publish.bind(to: behavior)
        closure()
        return expect(behavior.do(onDispose: { disposable.dispose() })).first()
    }

    func triggering<U>(closure: @escaping () -> Void) -> Expectation<U?> where T: BehaviorRelay<U?> {
        closure()
        return expect(try? self.expression.evaluate()).first()
    }

    func triggering<U>(closure: @escaping () -> Void) -> Expectation<U> where T: BehaviorRelay<U> {
        closure()
        return expect(try? self.expression.evaluate()).first()
    }
}

// public func expect<T>(_ relay: PublishRelay<T>, _ file: FileString = #file, line: UInt = #line, trigger: @escaping() -> Void) -> Expectation<T> {
//
//    let behavior = BehaviorRelay<T?>(value: nil)
//    _ = relay.bind(to: behavior)
//    trigger()
//    return Expectation(expression: <#T##Expression<_>#>)
//    return Expectation(
//        expression: Expression(
//            expression: { behavior.value }))
// }
