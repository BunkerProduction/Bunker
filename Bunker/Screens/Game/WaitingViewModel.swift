//
//  WaitingViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 15.05.2022.
//

import UIKit

final class WaitingViewModel {
    typealias collectionDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>
    typealias collectionSnapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>
    private enum Const {
        static let sectionId = "Players"
    }
    
    private unowned var collectionView: UICollectionView
    
    private lazy var dataSource: collectionDataSource = {
        let dataSource: collectionDataSource = .init(collectionView: collectionView) { [self]
            collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WaitingCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            
            if let cell = cell as? WaitingCollectionViewCell,
               let item = item as? Participant {
                cell.configure("1", item.username)
                cell.setTheme(UserSettings.shared.appearance)
            }
            
            return cell
        }
        return dataSource
    }()
    
    // MARK: - Init
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.dataSource = dataSource
        
        updateDataSource()
    }
    
    private func updateDataSource() {
        var snapshot = collectionSnapshot()
        
        snapshot.appendSections([Const.sectionId])
        snapshot.appendItems(users, toSection: Const.sectionId)
        
        dataSource.apply(snapshot)
    }
    
    // temp for checking layout
    private var users = [
        Participant(username: "Dan", isCreator: true),
        Participant(username: "Dima", isCreator: false),
        Participant(username: "Tima", isCreator: false),
        Participant(username: "Steve", isCreator: false),
        Participant(username: "Clown", isCreator: false)
    ]
}

        
struct Participant: Hashable {
    let username: String
    let isCreator: Bool
}
