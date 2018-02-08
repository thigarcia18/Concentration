//
//  ViewController.swift
//  Concentration
//
//  Created by Thiago Garcia on 05/02/18.
//  Copyright © 2018 iGarcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private let themes = [1:["🎃", "👻", "😱", "👿", "🦇", "💀", "🧛🏻‍♂️", "🧙🏻‍♀️"],
                  2:["🏈", "⚽️", "🏀", "🏓", "🎾", "⛳️", "🥊", "🏒"],
                  3:["🍎", "🍉", "🍌", "🍒", "🍓", "🍇", "🥥", "🍐"],
                  4:["🍗", "🍫", "🍔", "🍕", "🍟", "🌮", "🧀", "🍿"],
                  5:["🐶", "🦁", "🐭", "🐼", "🐴", "🦊", "🐷", "🐳"],
                  6:["😛", "😎", "😍", "😭", "😡", "🤣", "🧐", "🤧"]]
    
    private var emojiChoices = [String]()
    
    private  var emoji = [Int:String]()
    
    private func setEmojiChoices() {
        let randomIndex = Int(arc4random_uniform(UInt32(themes.keys.count)))
        for emoji in themes[randomIndex]! {
            emojiChoices.append(emoji)
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmojiChoices()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

