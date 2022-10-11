//
//  InstructionsViewController.swift
//  Bunker
//
//  Created by Danila Kokin on 21.08.2022.
//

import UIKit

final class InstructionsViewController: UIViewController {

    private let settings = UserSettings.shared
    private let exitButton = UIButton()
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
//        transitioningDelegate = self
    }

    private func setupUI() {
        setupNavbar()
        setupCollectionView()
        setupExitButton()

        let theme = settings.appearance
        view.backgroundColor = .Background.Accent.colorFor(theme)
        exitButton.imageView?.tintColor = .TextAndIcons.Primary.colorFor(theme)
    }

    private func setupNavbar() {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    private func setupExitButton() {
        view.addSubview(exitButton)
        let icon = UIImage(named: "closeIcon")
        exitButton.setImage(icon, for: .normal)

        exitButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 12)
        exitButton.pinRight(to: view, 12)
        exitButton.setWidth(to: 36)
        exitButton.setHeight(to: 36)

        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
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

    @objc
    private func goBack() {
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
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

//extension InstructionsViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AnimationController(animationDuration: 1, .present)
//    }
//}
