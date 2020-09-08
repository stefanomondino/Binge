import Quick

extension QuickSpec {
    func wait(for seconds: TimeInterval) {
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: seconds)
    }

    func sync() {
        wait(for: 0.1)
    }

    func executeAndSync(waitingFor seconds: TimeInterval = 0.1, closure: @escaping () -> Void) {
        closure()
        wait(for: seconds)
    }
}
