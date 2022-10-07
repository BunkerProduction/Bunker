//
//  InstructionsViewController.swift
//  Bunker
//
//  Created by Danila Kokin on 21.08.2022.
//

import UIKit

final class InstructionsViewController: UIViewController {

    private let settings = UserSettings.shared
    private var instructionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(
            InstructionCollectionViewCell.self,
            forCellWithReuseIdentifier: InstructionCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()
    let data = InstructionModel.testPages

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        instructionCollectionView.delegate = self
        instructionCollectionView.dataSource = self
    }

    private func setupNavbar() {
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "closeIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setupCollectionView() {
        view.addSubview(instructionCollectionView)

        instructionCollectionView.backgroundColor = .clear
        instructionCollectionView.showsHorizontalScrollIndicator = false

        instructionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            instructionCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            instructionCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            instructionCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            instructionCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupUI() {
        setupNavbar()
        setupCollectionView()

        let theme = settings.appearance
        view.backgroundColor = .Background.Accent.colorFor(theme)
    }

    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    private func close() { }
}

extension InstructionsViewController: UIGestureRecognizerDelegate { }

extension InstructionsViewController: UICollectionViewDelegate { }

extension InstructionsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
      }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = instructionCollectionView.dequeueReusableCell(
            withReuseIdentifier: InstructionCollectionViewCell.reuseIdentifier,
            for: indexPath)

        if let cell = cell as? InstructionCollectionViewCell {
            cell.configure(data[indexPath.item])
        }

        return cell
    }
}

extension InstructionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
    }
}
