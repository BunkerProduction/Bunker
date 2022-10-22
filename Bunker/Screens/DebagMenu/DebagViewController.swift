//
//  DebagViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.10.2022.
//

import UIKit

protocol DebagViewControllerDelegate {
    func didDisappear()
}

final class DebagViewController: UIViewController {
    private let tableView = UITableView()

    public var delegate: DebagViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavbar()
        tableView.register(DebugTableViewCell.self, forCellReuseIdentifier: DebugTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .black
        self.title = "Debug Menu"

        SHLogger.shared.delegate = self
        setupUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        delegate?.didDisappear()
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func configureNavbar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Clear",
            style: .done,
            target: self,
            action: #selector(clearLogs)
        )
    }

    private func setupUI() {
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    @objc private func goBack() {
        self.dismiss(animated: true)
    }

    @objc private func clearLogs() {
        SHLogger.shared.sessionLogs.removeAll()
        reloadData()
    }
}

extension DebagViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SHLogger.shared.sessionLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DebugTableViewCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        if let cell = cell as? DebugTableViewCell {
            cell.configure(text: SHLogger.shared.sessionLogs[indexPath.row].debugString)
        }
        return cell
    }
}


extension DebagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DebagViewController: SHLoggerDelegate {
    func newLogs() {
        reloadData()
    }
}
