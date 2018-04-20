//
//  Movie.swift
//  favourite-movies-app
//
//  Created by Kapil Rathan on 10/7/17.
//  Copyright © 2017 Kapil Rathan. All rights reserved.
//

import Foundation

class Movie{
    var id : String = ""
    var title : String = ""
    var year : String = ""
    var imageUrl : String = ""
    var plot : String = ""
    
    init(id:String, title:String, year:String, imageURL:String, plot:String = "") {
        self.id = id
        self.title = title
        self.year = year
        self.imageUrl = imageURL
        self.plot = plot
    }
}

class MovieStore{
    var movieArray: [Movie] = []
    
    func findMovie(name: String, year: String) -> Movie?{
        for movie in movieArray{
            if movie.title == name, movie.year == year{
                return movie
            }
        }
        return nil
    }
}
