//
//  DatabaseManager.swift
//  Day06
//
//  Created by Duy Anh on 1/17/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation

let kPokemonID = "id"
let kPokemonName = "name"
let kPokemonTag = "tag"
let kPokemonGen = "gen"
let kPokemonImage = "img"
let kPokemonColor = "color"

class DatabaseManager {
    static let shared = DatabaseManager()
    
    var database: FMDatabase? {
        let db = FMDatabase(path: databasePath)
        return db
    }
    var databasePath: String {
        var dest = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        dest += "/pokemon.db"
        return dest
    }
    
    func copyIfNeeded() {
        guard !FileManager.default.fileExists(atPath: databasePath) else { return }
        let path = Bundle.main.path(forResource: "pokemon", ofType: "db")
        try! FileManager.default.copyItem(atPath: path!, toPath: databasePath)
    }
    
    var numberOfPokemons: Int {
        guard let db = database else { return 0 }
        var count = 0
        db.open()
        do {
            let result = try db.executeQuery("Select count(*) as CountOfPokemons from pokemon where gen=1 or 2", values: nil)
            while result.next() {
                count = Int(result.int(forColumn: "CountOfPokemons"))
            }
        } catch {
            print("Error executing querry")
            count = 0
        }
        db.close()
        return count
    }
    
    func getPokemonIDs(generations: [Int]) -> [Int] {
        var array: [Int] = []
        getAllPokemons(generations: generations).forEach {
            array.append($0.id)
        }
        return array
    }
    
    func getAllPokemons(generations: [Int]) -> [Pokemon] {
        var gensString = "("
        for (index,gen) in generations.enumerated() {
            gensString += gen.description
            if index != generations.count - 1 {
                gensString += ","
            } else {
                gensString += ")"
            }
        }
        
        guard let db = database else { return [] }
        var array: [Pokemon] = []
        
        db.open()
        do {
            let result = try db.executeQuery("Select * from pokemon where gen in " + gensString, values: nil)
            while result.next() {
                let pkm = pokemonFrom(result: result)
                array.append(pkm)
            }
        } catch {
            print("Failed to get pokemon")
        }
        db.close()
        return array
    }
    
    func getPokemon(id: Int) -> Pokemon? {
        guard let db = database else { return nil }
        var pkm: Pokemon? = nil
        
        db.open()
        do {
            let result = try db.executeQuery("Select * from pokemon where id=\(id)", values: nil)
            result.next()
            pkm = pokemonFrom(result: result)
        } catch {
            print("Failed to get pokemon")
        }
        db.close()
        return pkm
    }
    
    func nameOfPokemon(id: Int) -> String? {
        let pkm = self.getPokemon(id: id)
        return pkm?.name
    }
    
    func pokemonFrom(result: FMResultSet) -> Pokemon {
        let id = Int(result.int(forColumn: kPokemonID))
        let name = result.string(forColumn: kPokemonName)!
        let gen = Int(result.int(forColumn: kPokemonGen))
        let tag = result.string(forColumn: kPokemonTag)!
        let color = result.string(forColumn: kPokemonColor)!
        let img = result.string(forColumn: kPokemonImage)!
        return Pokemon(id: id, name: name, tag: tag, gen: gen, img: img, color: color)
    }
}


