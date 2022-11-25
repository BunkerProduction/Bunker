//
//  ViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 30.10.2022.
//

import UIKit

final class SettingsViewModel: NSObject {
    private let settings = UserSettings.shared
    private weak var collectionView: UICollectionView?
    private weak var view: UIViewController?

    private var dataSource: [[SettingsItem]] = [] {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    // MARK: - Item Model
    enum SettingsItem {
        case menuItem(MenuItem)
        case product(ProductItem)

        struct MenuItem {
            let optionReference: SettingsOption?
            let title: String
            let icon: String
        }
        struct ProductItem {
            let product: Product
            let isBought: Bool
        }
    }

    // MARK: - Init
    init(_ vc: UIViewController, _ collectionView: UICollectionView) {
        self.view = vc
        self.collectionView = collectionView
        super.init()
        
        collectionView.dataSource = self
        ProductManager.shared.delegate = self
        constructDataSource()
    }

    // MARK: - DataSource
    private func constructDataSource() {
        let defaultSettings: [SettingsOption] = [settings.language, settings.volume, settings.appearance]
        let topSection: [SettingsItem] = defaultSettings.map {
            let item = SettingsItem.MenuItem(optionReference: $0, title: $0.optionName, icon: $0.associatedIcon())
            return SettingsItem.menuItem(item)
        }

        let products = getProducts()
        var dataSource = [topSection, products]

        if products.contains(where: {
               if case let .product(product) = $0 {
                   return product.isBought == false
               }
               return false
           }) {
            let restoreP = SettingsItem.menuItem(SettingsItem.MenuItem(optionReference: nil, title: "Restore purchases", icon: "🛍"))
            dataSource.append([restoreP])
        }
        self.dataSource = dataSource
    }

    private func getProducts() -> [SettingsItem] {
        let availableProducts = ProductManager.shared.products?.compactMap { Product(rawValue: $0.productIdentifier)}
        let purchasedProducts = UserSettings.shared.ownedProducts

        let mergedProducts = availableProducts?.compactMap { item in
            if let product = purchasedProducts.first(where: { item == $0 }) {
                return SettingsItem.product(SettingsItem.ProductItem(product: product, isBought: true))
            } else {
                return SettingsItem.product(SettingsItem.ProductItem(product: item, isBought: false))
            }
        }
        return mergedProducts ?? []
    }

    private func createViewModelForProduct(_ product: SettingsItem.ProductItem) -> ProductCollectionViewCell.ViewModel {
        let action = product.isBought ? nil : { ProductManager.shared.purchase(product: Product.premium) }
        return ProductCollectionViewCell.ViewModel(
            title: "title",
            desciption: "someDesc",
            price: "some price",
            action: action
        )
    }

    // MARK: - Internal methods
    public func viewWillAppear() {
        constructDataSource()
    }

    public func selectMenuItemAt(_ indexPath: IndexPath) {
        if(indexPath.section == 0) {
            let optionsVC = OptionsViewController()
            if case let .menuItem(item) = dataSource[indexPath.section][indexPath.row] {
                guard let option = item.optionReference else { return }
                optionsVC.option = option
            }
            self.view?.navigationController?.pushViewController(optionsVC, animated: true)
        } else if indexPath.section == 2 {
            ProductManager.shared.restorePurchaes()
        }
    }
}

// MARK: - Collection DataSource
extension SettingsViewModel: UICollectionViewDataSource {
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
            if case let .menuItem(option) = dataSource[indexPath.section][indexPath.row] {
                let item = (option.title, option.icon)
                cell.configure(item.0, item.1)
            }

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! ProductCollectionViewCell
            if case let .product(productOption) = dataSource[indexPath.section][indexPath.row] {
                let viewModel = createViewModelForProduct(productOption)
                cell.configure(viewModel)
            }
            cell.setTheme(settings.appearance)

            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! SettingsCollectionViewCell
            cell.setTheme(settings.appearance)
            if case let .menuItem(option) = dataSource[indexPath.section][indexPath.row] {
                cell.configure(option.title, option.icon)
            }
            return cell
        default:
            fatalError("pizdts")
        }
    }
}

extension SettingsViewModel: ProductManagerDelegate {
    func productPurchased(_ product: Product) {
        settings.saveProduct(product: product)
        self.collectionView?.reloadData()
    }

    func productRestored(_ product: Product) {
        settings.saveProduct(product: product)
        self.collectionView?.reloadData()
    }
}
