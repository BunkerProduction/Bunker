//
//  GameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 23.05.2022.
//

import UIKit
import Combine

final class PlayerViewModel: NSObject, PlayerScreenLogic {
    private let settings = UserSettings.shared
    private let networkService = WebSocketController.shared

    private var gameModelSubscriber: AnyCancellable?
    private var choosenAttributeIndex: Int?
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

    deinit {
        unbind()
    }

    // MARK: - DataSource
    private func updateDataSource() {
        guard let gameModel = gameModel else {
            return
        }
        if gameModel.myPlayer.UID == gameModel.turn {
            collectionView?.allowsSelection = true
        } else {
            collectionView?.allowsSelection = false
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

    public func cellSelected(indexPath: IndexPath) {
        guard let gameModel = gameModel else {
            return
        }
        if collectionView?.cellForItem(at: indexPath) is AttributeCollectionViewCell {
            self.choosenAttributeIndex = indexPath.row
        } else {
            guard let index = choosenAttributeIndex else {
                return
            }
            networkService.sendChosenAttribute(attribute: AttributeChoiceMessage(
                attributePos: index,
                playerID: gameModel.myPlayer.UID
            ))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PlayerViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let gameModel = gameModel, gameModel.myPlayer.UID == gameModel.turn {
            return 2
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return dataSource.count
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case 0 = indexPath.section {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? AttributeCollectionViewCell {
                cell.configure(dataSource[indexPath.row])
                cell.setTheme(settings.appearance)
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? ButtonCollectionViewCell {
                cell.configure("Открыть карту")
                cell.setTheme(settings.appearance, false)
            }
            return cell
        }
    }
}
