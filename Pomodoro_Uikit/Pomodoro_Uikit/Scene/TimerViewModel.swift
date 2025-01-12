import UIKit
import Foundation
import RxSwift
import RxCocoa

class TimerViewModel {
    struct Input {
        let startButtonTap: Observable<Void>
    }
    
    struct Output {
        let timerText: Observable<String>
        let startButtonTitle: Observable<String>
        let startButtonColor: Observable<UIColor>
    }
    
    private let isTimerRunning = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.startButtonTap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isTimerRunning.accept(!self.isTimerRunning.value)
            })
            .disposed(by: disposeBag)
        
        
        let timerText = isTimerRunning
            .flatMapLatest { isRunning -> Observable<Int> in
                if isRunning {
                    return Observable<Int>
                        .interval(.seconds(1), scheduler: MainScheduler.instance)
                        .startWith(0)
                } else {
                    return Observable.empty()
                }
            }
            .map { seconds in
                let hours = seconds / 3600
                let minutes = (seconds % 3600) / 60
                let seconds = seconds % 60
                return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            }
        
        let startButtonTitle = isTimerRunning
            .map { $0 ? "정지" : "시작" }
        
        let startButtonColor = isTimerRunning
            .map { $0 ? UIColor.systemRed : UIColor.systemBlue }
        
        return Output(
            timerText: timerText,
            startButtonTitle: startButtonTitle,
            startButtonColor: startButtonColor
        )
    }
}

