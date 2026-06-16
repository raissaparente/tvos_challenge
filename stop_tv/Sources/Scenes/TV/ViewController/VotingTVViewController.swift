import UIKit
import Combine
import StopPlay

class VotingTVViewController: UIViewController {
    var roundVM: RoundViewModel
    var coordinator: AppCoordinator
    var votingVM: VotingViewModel
    var matchManager: MatchManager

    private var cancellables = Set<AnyCancellable>()

    private let letterLabel = UILabel()
    private let rodadaLabel = UILabel()
    private let categoryLabel = UILabel()
    private let submitButton = CapsuleButton.createForTV(withTitle: "Continuar")

    private let hStack = UIStackView()
    private let vStackLeft = UIStackView()
    private let vStackRight = UIStackView()
    private let contentStack = UIStackView()

    init(viewModel: RoundViewModel,
         coordinator: AppCoordinator,
         matchManager: MatchManager,
         votingVM: VotingViewModel) {
        self.roundVM = viewModel
        self.coordinator = coordinator
        self.matchManager = matchManager
        self.votingVM = votingVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupLayout()
        observeViewModel()
        reloadWords()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
        votingVM.hasHandledEndVote = false
    }

    private func observeViewModel() {
        
        roundVM.gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                print("MUDOU O GAME STATUS NA VOTING: \(status)")

                if status == .endVote, !votingVM.hasHandledEndVote {
                    votingVM.hasHandledEndVote = true

                    if roundVM.isLastCategory {
                        coordinator.showPartialRanking_TV(from: self)
                    } else {
                        self.roundVM.changeCategory()
                        coordinator.showCategory_TV(from: self)
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        letterLabel.text = "Letra \(matchManager.currentLetter ?? "")"
        letterLabel.font =  UIFont(name: "ClashDisplay-Semibold", size: 40)

        rodadaLabel.text = "\(matchManager.currentRound + 1)ª RODADA"
        rodadaLabel.font =  UIFont(name: "ClashDisplay-Semibold", size: 40)

        categoryLabel.text = roundVM.currentCategory
        categoryLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 50)
        categoryLabel.textAlignment = .center

        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 32

        [vStackLeft, vStackRight].forEach {
            $0.axis = .vertical
            $0.spacing = 16
            $0.distribution = .equalSpacing
            hStack.addArrangedSubview($0)
        }

        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentStack)

        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.distribution = .equalSpacing
        topRow.translatesAutoresizingMaskIntoConstraints = false
        topRow.addArrangedSubview(letterLabel)
        topRow.addArrangedSubview(rodadaLabel)
        contentStack.addArrangedSubview(topRow)

        let categorySpacer = UIView()
        categorySpacer.heightAnchor.constraint(equalToConstant: 32).isActive = true
        contentStack.addArrangedSubview(categorySpacer)

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(categoryLabel)

        let responseSpacer = UIView()
        responseSpacer.heightAnchor.constraint(equalToConstant: 24).isActive = true
        contentStack.addArrangedSubview(responseSpacer)

        hStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(hStack)

        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleEndVotingButtonTapped), for: .primaryActionTriggered)
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),

//            hStack.heightAnchor.constraint(lessThanOrEqualToConstant: 500),

            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

//            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: submitButton.topAnchor, constant: -24)
        ])
        
        //Background
        let bg = UIImageView(image: UIImage(named: "paperTexture"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(bg, at: 0)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func reloadWords() {
        vStackLeft.arrangedSubviews.forEach { $0.removeFromSuperview() }
        vStackRight.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let words = roundVM.answers[roundVM.currentCategory]

        for (index, word) in words!.enumerated() {
            let fatia = FatiaView()
            fatia.configure(numero: index + 1, texto: word.text)

            if index % 2 == 0 {
                vStackLeft.addArrangedSubview(fatia)
            } else {
                vStackRight.addArrangedSubview(fatia)
            }
        }
        
        let leftSpacer = UIView()
        leftSpacer.translatesAutoresizingMaskIntoConstraints = false
        leftSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        leftSpacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        vStackLeft.addArrangedSubview(leftSpacer)

        let rightSpacer = UIView()
        rightSpacer.translatesAutoresizingMaskIntoConstraints = false
        rightSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        rightSpacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        vStackRight.addArrangedSubview(rightSpacer)
    }

    @objc private func handleEndVotingButtonTapped(_ sender: UIButton) {
        // ação do botão
    }
}
