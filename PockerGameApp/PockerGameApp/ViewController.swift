//
//  ViewController.swift
//  PockerGameApp
//
//  Created by Jason on 2022/02/24.
//

import UIKit

import Foundation
import UIKit

class ViewController: UIViewController {
        
    let buttonView = ButtonView()
    let playerCardStackView = UIStackView()
    let playerCardViews = (0...PokerPlayers.Count.max.index).map { _ in PlayerCardView() }
    
    let pokerGame = PokerGame()
    
    //MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layout()
        
        pokerGame.action.pokerReset()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake {
            pokerGame.action.pokerPlay()
        }
    }
    
    //MARK: - Method
    private func bind() {
        buttonView.bind(pockerGame: pokerGame)
        
        pokerGame.state.resetPockerBoard = { pockerStud, playerNames in
            (0..<self.playerCardViews.count).forEach {
                let cardView = self.playerCardViews[$0]
                let name = $0 < playerNames.count ? playerNames[$0] : nil
                cardView.resetPockerBoard(pockerStud: pockerStud, name: name)
            }
        }
        
        pokerGame.state.givePlayerCard = { index, cardIndex, card in
            self.playerCardViews[index].setCard(at: cardIndex, card: card)
        }
        
        pokerGame.state.pokerWinner = { winner in
            self.playerCardViews.forEach {
                $0.setWinner(winner: winner)
            }
        }
    }
    
    private func attribute() {
        if let backImage = UIImage(named: "bg_pattern") {
            self.view.backgroundColor = UIColor(patternImage: backImage)
        }
        
        playerCardStackView.spacing = 5
        playerCardStackView.axis = .vertical
        playerCardStackView.distribution = .fillProportionally
    }
    
    private func layout() {
        let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame
        let topOffset = safeAreaFrame.minY
        let leftOffset = 15.0
        let rightOffset = 15.0
        let safeWidth = safeAreaFrame.width - leftOffset - rightOffset
        
        //포커 옵션 레이아웃
        let optionViewHeight = 80.0
        self.view.addSubview(buttonView)
        buttonView.frame = CGRect(x: leftOffset, y: topOffset, width: safeWidth, height: optionViewHeight)
        
        //플레이어 카드뷰 레이아웃
        let optionViewOffset = 10.0
        let cardStackViewTopOffset = topOffset + optionViewHeight + optionViewOffset
        let cardStackViewHeight = safeAreaFrame.height - cardStackViewTopOffset
        self.view.addSubview(playerCardStackView)
        playerCardStackView.frame = CGRect(x: leftOffset, y: cardStackViewTopOffset, width: safeWidth, height: cardStackViewHeight)
        
        playerCardViews.enumerated().forEach {
            playerCardStackView.addArrangedSubview($1)
        }
        
        self.view.layoutIfNeeded()
        
        buttonView.layout()
        playerCardViews.enumerated().forEach {
            $1.layout()
        }
    }
}
