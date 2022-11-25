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
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()

    private var viewModel: SettingsViewModel?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SettingsViewModel(self, self.collectionView)
        self.view.backgroundColor = .white
        setupNavBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.viewWillAppear()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        let screenHeight =  ScreenSize.Height - view.safeAreaInsets.top
        if(height <= screenHeight) {
            collectionView.isScrollEnabled = false
        } else {
            collectionView.isScrollEnabled = true
        }
    }
    
    // MARK: - Update UI
    private func updateUI() {
        let theme = settings.appearance
        self.view.backgroundColor = .Background.LayerOne.colorFor(theme)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.TextAndIcons.Primary.colorFor(theme)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
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
            sectionT.append(("RESTORE_PURCHASES".localize(lan: settings.language),"🛍"))
        }
        let dataSource = [sectionF, sectionS, sectionT]
        self.dataSource = dataSource
    }
    
    // MARK: - setupView
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "SETTINGS".localize(lan: settings.language)
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
                    heightDimension: .absolute(52)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(6), trailing: .none, bottom: .fixed(6))
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 20, trailing: 20)
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.59),
                    heightDimension: .fractionalWidth(0.77)
//                    widthDimension: .absolute(215),
//                    heightDimension: .absolute(280)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                    leading: .none,
                    top: .none,
                    trailing: .fixed(ScreenSize.Width * 0.04),
                    bottom: .none
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 46, leading: 80, bottom: 46, trailing: 80)
                
                // card size animation when scrolling
                section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, point, environment) in
                    let centerX = point.x + ScreenSize.Width / 2
                    visibleItems.forEach { item in
                        guard let cell = self?.collectionView.cellForItem(at: item.indexPath) as? ProductCollectionViewCell
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
        viewModel?.selectMenuItemAt(indexPath)
    }
}
