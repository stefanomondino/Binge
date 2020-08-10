import Nimble
import RxBlocking
import RxSwift

public extension Expectation where T: ObservableType {
    /**
      Expectation with sequence's first element

      Transforms the expression by blocking sequence and returns its first element.
     */
    func first(until timeout: TimeInterval? = nil) -> Expectation<T.Element> {
        return transform { source in
            try source?.toBlocking(timeout: timeout).first()
        }
    }

    /**
     Expectation with sequence's last element

     Transforms the expression by blocking sequence and returns its last element.
     */
    func last(until timeout: TimeInterval? = nil) -> Expectation<T.Element> {
        return transform { source in
            try source?.toBlocking(timeout: timeout).last()
        }
    }

    /**
     Expectation with all sequence's elements

     Transforms the expression by blocking sequence and returns its elements.
     */
    func array(until timeout: TimeInterval? = nil) -> Expectation<[T.Element]> {
        return transform { source in
            try source?.toBlocking(timeout: timeout).toArray()
        }
    }
}

extension Observable {
    var errors: Observable<Swift.Error?> {
        flatMap { _ in Observable<Swift.Error?>.just(nil) }
            .catchError { Observable<Swift.Error?>.just($0) }
    }
}
