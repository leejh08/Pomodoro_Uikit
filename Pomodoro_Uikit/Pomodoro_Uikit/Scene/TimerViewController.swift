import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = TimerViewModel()
    
    private let timerLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 48, weight: .bold)
        $0.textAlignment = .center
        $0.text = "00:00:00"
    }
    
    private let startButton = UIButton().then {
        $0.setTitle("시작", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        
        timerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }
    }
    
    private func bind() {
        let input = TimerViewModel.Input(startButtonTap: startButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.timerText
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.startButtonTitle
            .bind(to: startButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.startButtonColor
            .bind(to: startButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
