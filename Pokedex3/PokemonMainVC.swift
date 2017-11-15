//
//  ViewController.swift
//  Pokedex3
//
//  Created by RANDOM on 10/23/17.
//  Copyright © 2017 RANDOM. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonMainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "opening", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let pokemon = Pokemon(name: name, pokedexId: pokeId)
                pokemons.append(pokemon)
            }
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let pokemon: Pokemon!
            if inSearchMode{
                pokemon = filteredPokemons[indexPath.row]
            }else{
                pokemon = pokemons[indexPath.row]
            }
            cell.configPokeCell(pokemon)
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        if inSearchMode {
            poke = filteredPokemons[indexPath.row]
        }else {
            poke = pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "pokemonDetailSegue", sender: poke)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemons.count
        }
        return pokemons.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) ->CGSize
    {
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.3
        }else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        }else {
            inSearchMode = true
            let lower = searchBar.text?.lowercased()
            filteredPokemons = pokemons.filter({$0.name.range(of: lower!) != nil})
            collection.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetailSegue" {
            if let PokemonDetailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                   PokemonDetailVC.pokemon = poke
                }
            }
        }
    }

}

