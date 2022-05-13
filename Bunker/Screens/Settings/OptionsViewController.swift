//
//  OptionsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 12.05.2022.
//

import UIKit

final class OptionsViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.register(
            SettingsCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            IconCollectionViewCell.self,
            forCellWithReuseIdentifier: IconCollectionViewCell.reuseIdentifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = true
        
        return collectionView
    }()
    
    public var option: SettingsOption?
    private var dataSource: [SettingsOption] = []
    private var icons: [AppIcon] = []
    private let settings = UserSettings.shared
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let type = option {
            if type.optionType == Appearence.light.optionType {
                dataSource = type.allCases
                icons = AppIcon.allCases
            } else {
                dataSource = type.allCases
            }
        }
        
        setupNavBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func updateUI() {
        self.collectionView.reloadData()
        
        self.view.backgroundColor = .white
    }
    
    // MARK: - setup UI
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = option?.optionType ?? ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "returnIcon"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupView() {
        self.view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.left, .right, .bottom])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    // MARK: - Layout
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
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
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(80),
                    heightDimension: .absolute(80)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .none, trailing: .fixed(16), bottom: .none)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
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
extension OptionsViewController: UIGestureRecognizerDelegate { }

// MARK: - CollectionViewDelegate
extension OptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0) {
            self.option = settings.setOption(dataSource[indexPath.row])
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1) {
            settings.appIcon = icons[indexPath.row]
        } else {
            self.updateUI()
        }
    }
}


// MARK: - Collection DataSource
extension OptionsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? dataSource.count : icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier, for: indexPath)
            let item = dataSource[indexPath.row]
            if item.optionName == self.option?.optionName {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            if let cell = cell as? SettingsCollectionViewCell {
                cell.configure(item.optionName, item.associatedIcon())
                cell.setTheme(settings.appearance)
            }
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? IconCollectionViewCell {
                cell.configure(icons[indexPath.row])
            }
            
            return cell
        default:
            fatalError("Sad")
        }
    }
}
