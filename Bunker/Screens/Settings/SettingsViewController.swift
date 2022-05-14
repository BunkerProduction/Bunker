//
//  SettingsViewController.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 06.05.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    typealias Spair = (String, String)
    
    private let settings = UserSettings.shared
    private var dataSource: [[Any]] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier)
        collectionView.register(VersionCollectionViewCell.self, forCellWithReuseIdentifier: VersionCollectionViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        constructDataSource()
        setupNavBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Update UI
    private func updateUI() {
        constructDataSource()
        let theme = settings.appearance
        self.view.backgroundColor = .BackGround.LayerOne.colorFor(theme)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = UIColor.TextAndIcons.Primary.colorFor(theme)
    }
    
    // MARK: - DataSource
    private func constructDataSource() {
        let volume = settings.volume
        let theme = settings.appearance
        let lang = settings.language
        
        let sectionF = [lang, volume, theme] as [Any]
        
        var sectionS: [Spair] = []
        var sectionT: [Spair] = []
        if(settings.isPremium) {
            sectionS.append(("true",""))
        } else {
            sectionS.append(("false",""))
            sectionS.append(("true",""))
            sectionT.append(("Восстановить покупки","🛍"))
        }
        let dataSource = [sectionF, sectionS, sectionT]
        self.dataSource = dataSource
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
        
        collectionView.pin(to: view, .left, .right, .bottom)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
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
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(6), trailing: .none, bottom: .fixed(6))
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(215),
                    heightDimension: .absolute(280)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(8), top: .none, trailing: .fixed(16), bottom: .none)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 47, leading: 20, bottom: 47, trailing: 20)
                
                // card size animation when scrolling
                section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, point, environment) in
                    let centerX = point.x + ScreenSize.Width / 2
                    visibleItems.forEach { item in
                        guard let cell = self?.collectionView.cellForItem(at: item.indexPath) as? VersionCollectionViewCell
                        else { return }
                        
                        if(cell.frame.minX <= centerX && cell.frame.maxX >= centerX) {
                            cell.transformToLarge()
                        } else {
                            cell.transformBack()
                        }
                    }
                }
                
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
        collectionView.deselectItem(at: indexPath, animated: false)
        if(indexPath.section == 0) {
            let options = OptionsViewController()
            if let option  = dataSource[indexPath.section][indexPath.row] as? SettingsOption {
                options.option = option
            }
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
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! SettingsCollectionViewCell
            cell.setTheme(settings.appearance)
            if let option = dataSource[indexPath.section][indexPath.row] as? SettingsOption {
                let item = (option.optionType, option.associatedIcon())
                cell.configure(item.0, item.1)
            }
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VersionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! VersionCollectionViewCell
            let isPremium = dataSource[indexPath.section][indexPath.row] as? Spair
            let bol = isPremium?.0 == "true" ? true : false
            cell.configure(bol)
            cell.setTheme(settings.appearance)
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! SettingsCollectionViewCell
            cell.setTheme(settings.appearance)
            if let item = dataSource[indexPath.section][indexPath.row] as? Spair {
                cell.configure(item.0, item.1)
            }
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


