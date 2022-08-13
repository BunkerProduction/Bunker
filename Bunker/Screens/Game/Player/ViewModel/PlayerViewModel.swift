//
//  GameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit
import Combine

final class PlayerViewModel: NSObject {
    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private var gameModelSubscriber: AnyCancellable?
    private var gameModel: Game? {
        didSet {
            updateDataSource()
        }
    }
    private var dataSource: [Attribute] = []

    private weak var coordinator: GameCoordinator?
    private weak var collectionView: UICollectionView?

    // MARK: - Init
    init(collectionView: UICollectionView, gameCoordinator: GameCoordinator) {
        super.init()
        
        self.coordinator = gameCoordinator
        self.collectionView = collectionView
        collectionView.dataSource = self
        binding()
        updateDataSource()
    }

    // MARK: - DataSource
    private func updateDataSource() {
        guard let gameModel = gameModel else {
            return
        }
        dataSource = gameModel.myPlayer.attributes
        collectionView?.reloadData()
    }

    // MARK: - Binding
    private func binding() {
        gameModelSubscriber = networkService.gameModelRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.gameModel, on: self)
    }

    private func unbind() {
        gameModelSubscriber?.cancel()
    }
}

extension PlayerViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? AttributeCollectionViewCell {
            cell.configure(dataSource[indexPath.row])
            cell.setTheme(settings.appearance)
        }

        return cell
    }
}
