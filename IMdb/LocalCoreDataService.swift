//
//  LocalCoreDataService.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService{
    
    let remotemovieService = RemoteItunesMovieServie()
    let stack = CoreDataStack.shared
    
    func searchMovie(_ byTerm : String , remoteHandler : @escaping([MovieModel]?) ->()){
        
        remotemovieService.searchMovies(byTerm) { (result) in
            if let movieData = result{
                var modelMovie = [MovieModel] ()
                for c_movie in movieData{
                    let obj = MovieModel(pId:c_movie["id"]!,
                                        pTitle:c_movie ["title"]!,
                                        pOrder: nil,
                                        pSummary: c_movie["summary"]!,
                                        pImage:c_movie ["image"]!,
                                        pCategory:c_movie ["category"]!,
                                        pDirector: c_movie["director"]!)
                    
                    modelMovie.append(obj)
                }
                remoteHandler(modelMovie)
            }else{
                print("Error mientras se llama a los servicios de iTunes")
                remoteHandler(nil)
            }
        }
    
    }
    
    //funcion algo
    func topMovie(_ localHandler : @escaping ([MovieModel]?) -> (),remoteHandler : @escaping ([MovieModel]?) -> ()){
        
        localHandler(queryTopMovies())
        
        remotemovieService.getTopMovies {(result) in
            if let moviesData = result{
                
                
                self.markAllmoviesAnunsync()
                
                var order = 1
                for c_movieDiccionario in moviesData{
                    
                    if let movieDatasDes = self.getMovieById(c_movieDiccionario["id"]!, favorito: false){
                        //UPDATE
                        
                        self.UpdateMovie(c_movieDiccionario, movie: movieDatasDes, order: order)
                    }else{
                        //INSERT
                        self.insertMovie(c_movieDiccionario, order: order)
                        
                    }
                    order += 1
                }
                
                //Metodo de remover los no favoritos
                
                remoteHandler(self.queryTopMovies())
                
            }else{
                print("Error mientras se llama a la API de ITUNES")
                remoteHandler(nil)
            }
        }
    }
    
    //funcion algo
    func queryTopMovies()->[MovieModel]?{
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        
        do{
            
            let fechMovies = try context.fetch(request)
            var movie = [MovieModel]()
            
            for c_movie  in fechMovies{
                movie.append(c_movie.mappedObj())
                
            }
            
            return movie
            
        }catch{
            print("Error mientras se obtienen las peliculas de coreData")
            
            return nil
            
        }
        
    }
    
    //OTRA FUNCION
    
    func markAllmoviesAnunsync(){
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        
        do{
            
            let fetchMovies = try context.fetch(request)
            
            for c_manage in fetchMovies{
                c_manage.sync = false
            }
            
            try context.save()
        }catch{
            print("Error mientras se actualizan las pelis")
            
        }
        
    }
    //FUNC
    
    func getMovieById(_ id: String, favorito : Bool)->MovieManager?{
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager>=MovieManager.fetchRequest()
        let customtomPredicate = NSPredicate(format: "id = \(id) and favorito = \(favorito)")
        request.predicate = customtomPredicate
        
        
        do{
            let fetchmovies = try context.fetch(request)
            if fetchmovies.count>0{
                return fetchmovies.last
            }else{
                return nil
            }
        }catch{
            print("Error mientras se obtienen las películas de CoreData")
            return nil
        }
    }
    
    func insertMovie( _ movieDiccionario : [String:String] , order : Int){
        
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        movie.id = movieDiccionario["id"]
        
        
        UpdateMovie(movieDiccionario, movie: movie, order: order)
        
        
    }
    
    
    
    //Func
    
    func UpdateMovie ( _ movieDiccionario : [String:String], movie : MovieManager ,order : Int){
        
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        
        let image = movie.image
        
        movie.sync = true
        do{
            try context.save()
            
            
        }catch{
            print("Error mientras se actualiza el coreData")
            
        }
    }
    
    
}








