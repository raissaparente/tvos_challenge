import UIKit

class RoleSelectionViewController: UIViewController {
    var username: String?
    var onRoleSelected: ((AppRole, String) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Escolha seu papel"
        label.font = UIFont(name: "Clash Display", size: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let hostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Host", for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Semibold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customPink
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let playerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Player", for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Semibold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customYellow
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hostButton.addTarget(self, action: #selector(handleHostSelected), for: .touchUpInside)
        playerButton.addTarget(self, action: #selector(handlePlayerSelected), for: .touchUpInside)
    }

    private func setupUI() {
        view.backgroundColor = .black
        view.addBackgroundView(StarsBackgroundView())

        view.addSubview(titleLabel)
        view.addSubview(hostButton)
        view.addSubview(playerButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            hostButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            hostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            hostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            hostButton.heightAnchor.constraint(equalToConstant: 56),

            playerButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 24),
            playerButton.leadingAnchor.constraint(equalTo: hostButton.leadingAnchor),
            playerButton.trailingAnchor.constraint(equalTo: hostButton.trailingAnchor),
            playerButton.heightAnchor.constraint(equalTo: hostButton.heightAnchor)
        ])
    }

    @objc private func handleHostSelected() {
        guard let username = username else { return }
        onRoleSelected?(.host, username)
    }

    @objc private func handlePlayerSelected() {
        guard let username = username else { return }
        onRoleSelected?(.player, username)
    }
}
