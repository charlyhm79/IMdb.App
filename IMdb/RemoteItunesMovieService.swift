//
//  RemoteItunesMovieService.swift
//  IMdb
//
//  Created by formador on 28/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RemoteItunesMovieServie {
    
    //metodo top Movies
    func getTopMovies(_ completionHandler : @escaping ([[String : String]]?) -> ()){
        
        
        let urlData = CONSTANTES.BASE_URL.BASE_ITUNES + CONSTANTES.METODOS.METODO_TOP
        
        Alamofire.request(URL(string: urlData)!,method: .get).validate().responseJSON { (responseData) in
            switch responseData.result{
            case .success:
                if let valorData = responseData.result.value{
                    
                    let json = JSON(valorData)
                    var resultData = [[String : String]]()
                    let entries = json["feed"]["entry"].arrayValue
                    for c_entry in entries{
                        
                        var movieDiccionario = [String : String]()
                        movieDiccionario["id"] = c_entry["id"]["attributes"]["im:id"].stringValue
                        movieDiccionario["title"] = c_entry["im:name"]["label"].stringValue
                        movieDiccionario["summary"] = c_entry["summary"]["label"].stringValue
                        movieDiccionario["image"] = c_entry["im:image"][0]["label"].stringValue.replacingOccurrences(of:"60x60",with: "500x500")
                        movieDiccionario["category"] = c_entry["category"]["attributes"]["label"].stringValue
                        movieDiccionario["director"] = c_entry["im:artist"]["label"].stringValue
                                    
                        
                        
                        
                        resultData.append(movieDiccionario)
                    }
                    completionHandler(resultData)
                }
                
                
                
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
        
        
        
        
        
    }
    
    //Metodo de búsqueda
    
    func searchMovies( _ byTerm:String , completionHandler : @escaping ([[String:String]]?) -> ()){
     
        let urlData = URL(string : CONSTANTES.BASE_URL.BASE_ITUNES + CONSTANTES.METODOS.METODO_SEARCH)!
        Alamofire.request(urlData,
                          method: .get,
                          parameters : ["media": "movie" , "attribute":"movieTerm","term": byTerm],
                          encoding : URLEncoding.default,
                          headers : nil).validate().responseJSON { (responseData) in
                                            
                            switch responseData.result{
                            case.success:
                                
                                
                                if let valorData = responseData.result.value{
                                    
                                    let json = JSON(valorData)
                                    var resultData = [[String : String]]()
                                    let entries = json["feed"]["entry"].arrayValue
                                    for c_entry in entries{
                                                
                                        var movieDiccionario = [String : String]()
                                        movieDiccionario["id"] = c_entry["trackId"].stringValue
                                        movieDiccionario["title"] = c_entry["trackName"].stringValue
                                        movieDiccionario["summary"] = c_entry["longDEscription"].stringValue
                                        movieDiccionario["image"] = c_entry["artWorkUr100"].stringValue.replacingOccurrences(of:"60x60",with: "500x500")
                                        movieDiccionario["category"] = c_entry["primaryGenreName"].stringValue
                                        movieDiccionario["director"] = c_entry["artistName"].stringValue
                                        
                                        
                                        
                                        
                                        resultData.append(movieDiccionario)
                                   }
                                    
                                    completionHandler(resultData)
                                    
                                }
                                
                                
                            case .failure(let error):
                                print("Error \(error.localizedDescription)")
                                completionHandler(nil)

        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    }
    
    
    
    
}
