//
//  PokeCell.swift
//  Pokedex3
//
//  Created by RANDOM on 10/23/17.
//  Copyright © 2017 RANDOM. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 0.5
    }
    
    func configPokeCell(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        self.nameLbl.text = self.pokemon.name
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}
