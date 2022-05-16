//
//  PackCollectionView.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//

import UIKit

protocol PackViewControllerDelegate {
    func packSet(_ pack: Catastrophe)
}

final class PackViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = DynamicLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 24, right: 10)
        collectionView.register(
            PackCollectionViewCell.self,
            forCellWithReuseIdentifier: PackCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.delegate = self
        
        return collectionView
    }()
    private let settings = UserSettings.shared
    public var chosenPack: Catastrophe?
    private var dataSource: [Catastrophe] = []
    public var delegate: PackViewControllerDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = Catastrophe.getAll()
        setupNavBar()
        updateUI()
        setupView()
    }
    
    // MARK: - updateUI
    private func updateUI() {
        let theme = UserSettings.shared.appearance
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
    }
    
    // MARK: - setup UI
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Packs"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.left, .right, .bottom])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    // MARK: - Interactions
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension PackViewController: UIGestureRecognizerDelegate { }

// MARK: - Collection Delegate
extension PackViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred(intensity: 0.5)
        delegate?.packSet(dataSource[indexPath.row])
    }
}

// MARK: - Colllection Datasource
extension PackViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PackCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        if let cell = cell as? PackCollectionViewCell {
            cell.configure(dataSource[indexPath.row])
            cell.setTheme(settings.appearance)
        }
        if dataSource[indexPath.row] == chosenPack {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        
        return cell
    }
}

extension PackViewController: DynamicLayoutDelegate {
    func textForItem(
        _ collectionView: UICollectionView,
        widthForCell: CGFloat,
        textForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let catastropy = dataSource[indexPath.row]
        let heightForDescription = catastropy.shortDescription.lineHeight(
            constraintedWidth: widthForCell - 32,
            font: .customFont.footnote ?? .systemFont(ofSize: 14),
            multiplicator: 1.25
        )
        let heightForName = catastropy.name.lineHeight(
            constraintedWidth: widthForCell - 32,
            font: .customFont.body ?? .systemFont(ofSize: 16),
            multiplicator: 1
        )
        let height = 16 + 20 + 12 + heightForName + 12 + heightForDescription + 16
        
        return height
    }
}
