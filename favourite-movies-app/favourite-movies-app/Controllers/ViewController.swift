//
//  ViewController.swift
//  favourite-movies-app
//
//  Created by Kapil Rathan on 10/7/17.
//  Copyright © 2017 Kapil Rathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchViewDelegate{

    var favouriteMovies : [Movie] = []
    @IBOutlet var mainTableView :UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MovieCustomPrototypeCellTableViewCell
        
        let idx = indexPath.row
        movieCell.movieTitle?.text = favouriteMovies[idx].title
        movieCell.movieYear?.text = favouriteMovies[idx].year
        displayMovieImage(idx, movieCell: movieCell)
        return movieCell
    }
    
    func displayMovieImage(_ row: Int, movieCell: MovieCustomPrototypeCellTableViewCell){
        let url: String = (URL(string: favouriteMovies[row].imageUrl)?.absoluteString)!
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
    
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
        if favouriteMovies.count == 0 {
            favouriteMovies.append(Movie(id: "123", title: "Star Wars", year: "2017", imageURL: "http://a.dilcdn.com/bl/wp-content/uploads/sites/6/2017/10/star-wars-books-phasma-book-cover.jpg"))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAV Movies"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapFindMovieButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewVC") as? SearchViewController{
            searchVC.delegate = self
            navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
}

//Mark : SearchViewDelegate Delegate

extension ViewController{
    func updateFavMoviesList(movie: Movie) {
        for item in favouriteMovies{
            if item.id == movie.id{
                let alert = UIAlertController.init(title: "Favourites", message: "This movie, \(movie.title) is already favourited", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alert.accessibilityLabel = "FavouritesAlert"
                alert.addAction(action)
                present(alert, animated: false, completion: nil)
                return
            }
        }
        self.favouriteMovies.append(movie)
    }
    
}
