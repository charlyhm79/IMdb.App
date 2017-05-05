//
//  APIUTILS.swift
//  IMdb
//
//  Created by formador on 28/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import UIKit

let CONSTANTES = Constantes()

struct Constantes {
    let COLORES = Colores()
    let BASE_URL = Urls()
    let METODOS = Metodos()
}

struct Colores {
    let COLOR_GRIS_TAB_NAV_BAR = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    let COLOR_ROJO_GENERAL = #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)

}

struct Urls {
    let BASE_ITUNES = "https://itunes.apple.com/"
}


struct Metodos {
    let METODO_TOP = "es/rss/topmovies/limit=200/json"
    let METODO_SEARCH = "search"
}






