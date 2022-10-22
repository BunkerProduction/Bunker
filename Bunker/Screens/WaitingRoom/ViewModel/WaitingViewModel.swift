//
//  WaitingViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 15.05.2022.
//

import UIKit
import Combine

final class WaitingViewModel {
    typealias collectionDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>
    typealias collectionSnapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>
    
    private enum Const {
        static let sectionId = "Players"
    }
    
    private let socketController = WebSocketController.shared
    private unowned var collectionView: UICollectionView
    private weak var viewController: WaitingRoomViewController?
    private weak var codeView: SplittedDigitInput?
    private var roomModel: WaitingRoom? {
        didSet {
            codeView?.setValues(roomModel?.roomCode ?? "")
            updateDataSource()
            updateUI()
        }
    }
    private var gameModel: Game? {
        didSet {
            if(gameModel != nil) {
                proceedToGame()
            }
        }
    }

    private var flowError: ErrorMessage? {
        didSet {
            if let flowError = flowError {
                viewController?.showError(errorString: flowError.message)
            }
        }
    }

    private var roomModelSubscriber: AnyCancellable?
    private var gameModelSubscriber: AnyCancellable?
    private var errorModelSubscriber: AnyCancellable?
    
    private lazy var dataSource: collectionDataSource = {
        let dataSource: collectionDataSource = .init(collectionView: collectionView) { [weak self]
            collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WaitingCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? WaitingCollectionViewCell,
               let item = item as? User {
                cell.configure(item)
                cell.setTheme(UserSettings.shared.appearance)
            }
            return cell
        }
        return dataSource
    }()
    
    // MARK: - Init
    init(_ collectionView: UICollectionView,
         _ roomCode: SplittedDigitInput,
         _ model: WaitingRoom,
         viewController: WaitingRoomViewController
    ) {
        self.viewController = viewController
        self.codeView = roomCode
        self.collectionView = collectionView
        self.collectionView.dataSource = dataSource
        self.roomModel = model
        updateUI()
        
        binding()
    }
    
    deinit {
        print("WaitingViewModel deinit called")
    }
    
    // MARK: - Binding
    private func binding() {
        roomModelSubscriber = socketController.waitingRoomRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.roomModel, on: self)
        gameModelSubscriber = socketController.gameModelRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.gameModel, on: self)
        errorModelSubscriber = socketController.florErrorRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.flowError, on: self)
    }
    
    private func unbind() {
        // cancel subscribtion
        roomModelSubscriber?.cancel()
        gameModelSubscriber?.cancel()
        errorModelSubscriber?.cancel()
    }
    
    // MARK: - DataSource update
    private func updateDataSource() {
        guard let model = roomModel else { return }
        var snapshot = collectionSnapshot()
        
        snapshot.appendSections([Const.sectionId])
        snapshot.appendItems(model.players, toSection: Const.sectionId)
        
        dataSource.apply(snapshot)
    }

    private func updateUI() {
        viewController?.isStartGameVisible(roomModel?.isCreator ?? false)
    }

    // MARK: - Navigation
    private func proceedToGame() {
        unbind()
        
        let gameController = TabGameViewController()
        self.viewController?.navigationController?.pushViewController(gameController, animated: true)
    }

    // MARK: - Public
    public func disconnect() {
        unbind()
        // disconnect from room
        socketController.disconnect()
        
        self.viewController?.navigationController?.popViewController(animated: true)
    }

    public func startGame() {
        socketController.startGame()
    }

    public func shareRoom() {
        guard let roomModel = roomModel else {
            return
        }
        let link = URL(string: "shelterGame://join?code=\(roomModel.roomCode)")!
        self.viewController?.shareLink(link: link)
    }
}
