import RxSwift
import StoreKit

public extension Reactive where Base: SKRequest {

    public var observe: Observable<SKRequest> {
        return Observable.create { observer in
            let observable = SKRequestObserver(observer: observer, request: self.base)
            observable.start()
            return Disposables.create {
                observable.cancel()
            }
        }
    }
}

private class SKRequestObserver: NSObject {

    private let observer: AnyObserver<SKRequest>
    private let request: SKRequest

    init(observer: AnyObserver<SKRequest>, request: SKRequest) {
        self.observer = observer
        self.request = request
        super.init()
    }

    func start() {
        request.start()
    }

    func cancel() {
        request.cancel()
    }
}

extension SKRequestObserver: SKRequestDelegate {

    func requestDidFinish(_ request: SKRequest) {
        observer.onNext(request)
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        observer.onError(error)
    }
}
