//
//  SearchViewController.swift
//  favourite-movies-app
//
//  Created by Kapil Rathan on 10/7/17.
//  Copyright © 2017 Kapil Rathan. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func updateFavMoviesList(movie: Movie)
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchText: UITextField!
    @IBOutlet var tableView : UITableView!
    
    var searchResults : [Movie] = []
    var delegate:SearchViewDelegate?
    
    @IBAction func search (sender: UIButton){
        print("searching... ")
        
        let searchterm = searchText.text!
        if searchterm.count > 2 {
            retrieveSearchResults(searchTerm: searchterm)
        }
    }
    func retrieveSearchResults(searchTerm : String){
        let url = "http://www.omdbapi.com/?t=\(searchTerm)&type=movie&r=json&apikey=67a133ab"
        HttpHandler.searchRequest(term: url) { json, error  in
            print(error ?? "nil")
            print(json ?? "nil")
            print("Update views")
            if let repsone = json, let id = repsone["imdbID"] as? String, let title = repsone["Title"] as? String, let year = repsone["Year"] as? String, let imageURL = repsone["Poster"] as? String, let plot = repsone["Plot"] as? String{
                let newMovie = Movie.init(id: id, title: title, year: year, imageURL: imageURL, plot: plot)
                self.searchResults.append(newMovie)
                self.tableView.reloadData()
            }
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MovieCustomPrototypeCellTableViewCell
        
        let idx: Int = indexPath.row
        movieCell.movieTitle?.text = searchResults[idx].title
        movieCell.movieYear?.text = searchResults[idx].year
        movieCell.favourite.tag = idx
        movieCell.delegate = self
        
        
        displayMovieImage(idx, movieCell: movieCell)
        return movieCell
    }

    func getMovieWithTitleAndYear(movieName: String, year: String) -> Movie?{
        for movie in searchResults{
            if movie.title == movieName, movie.year == year{
                return movie
            }
        }
        return nil
    }
    
    func displayMovieImage(_ row: Int, movieCell: MovieCustomPrototypeCellTableViewCell){
        let url: String = (URL(string: searchResults[row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                movieCell.movieImageView?.image = image
            })
            
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Movies"

        // Do any additional setup after loading the view.
    }

}

extension SearchViewController: MovieCustomCellDelegate{
    func didTapFavButton(cell: MovieCustomPrototypeCellTableViewCell) {
        if let title = cell.movieTitle.text, let year = cell.movieYear.text, let favMovie = getMovieWithTitleAndYear(movieName: title, year: year){
            self.delegate?.updateFavMoviesList(movie: favMovie)
        }
    }
}
