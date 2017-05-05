//
//  MovieManager+Maping.swift
//  IMdb
//
//  Created by formador on 28/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation

extension MovieManager{
    // lo que conseguimos con esto es que  sobre cualquier objeto manage podra ejecutar el retorno de un objeto del tipo movieModel
    func mappedObj() -> MovieModel{
        return MovieModel(pId: self.id!,
                          pTitle: self.title!,
                          pOrder: Int(self.order),
                          pSummary: self.summary!,
                          pImage: self.image!,
                          pCategory: self.category,
                          pDirector: self.director!)
    }
}
