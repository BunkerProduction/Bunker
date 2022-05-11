//
//  SettingsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    private var dataSource = [
        [
            ("Язык","🇷🇺"),
            ("Звуки","🔊"),
            ("Тема","🌕")
        ],
        [
            ("True","W"),
            ("False","W")
        ],
        [
            ("Восстановить покупки","🛍")
        ]
    ]
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier)
        collectionView.register(VersionCollectionViewCell.self, forCellWithReuseIdentifier: VersionCollectionViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setupNavBar()
        setupView()
    }
    
    // MARK: - setupView
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Настройки"
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
        
        collectionView.pin(to: view, .left, .right)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    // MARK: - Layout
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0,2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(56)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.82),
                    heightDimension: .absolute(160)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20)
                
                return section
            default:
                return nil
            }
        }
        
        return layout
    }
    
    // MARK: - Interactions
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension SettingsViewController: UIGestureRecognizerDelegate { }

// MARK: - CollectionViewDelegate
extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            let options = OptionsViewController()
            self.navigationController?.pushViewController(options, animated: true)
        }
    }
}


// MARK: - Collection DataSource
extension SettingsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItems = dataSource[section]
        let number = sectionItems.count
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0,2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! SettingsCollectionViewCell
            let item = dataSource[indexPath.section][indexPath.row]
            cell.configure(item.0, item.1)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VersionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! VersionCollectionViewCell
            cell.configure(false)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! SettingsCollectionViewCell
            
            return cell
        }
    }
}
