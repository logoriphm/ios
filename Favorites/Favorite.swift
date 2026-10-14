//
//  Favorite.swift
//  Favorites
//
//  Created by Kalybay Nurdaulet  on 14.10.2026.
//


struct Favorite {
    let imageName: String
    let title: String
    let recept: String
}

let favorites: [Favorite] = [
    Favorite(imageName: "kuyrdak",
             title: "Куырдак",
             recept: "Обжаренные субпродукты и мясо с луком. Сытное казахское блюдо."),
    Favorite(imageName: "besh",
             title: "Беш",
             recept: "Отварное мясо с тонким тестом и луком в бульоне."),
    Favorite(imageName: "okroshka",
             title: "Окрошка",
             recept: "Холодный летний суп: овощи, яйцо и колбаса на квасе или кефире."),
    Favorite(imageName: "fried_fish",
             title: "Рыба",
             recept: "Рыба в хрустящей панировке, обжаренная до золотистой корочки."),
    Favorite(imageName: "borsch",
             title: "Борщ",
             recept: "Свекольный суп с капустой и мясом, подаётся со сметаной."),
    Favorite(imageName: "solyanka",
             title: "Солянка",
             recept: "Густой суп с копчёностями, солёными огурцами, оливками и лимоном."),
    Favorite(imageName: "shashlik",
             title: "Шашлык",
             recept: "Маринованное мясо, зажаренное на углях на шампурах."),
    Favorite(imageName: "kozhe",
             title: "Коже",
             recept: "Освежающий напиток-суп из айрана со злаками."),
    Favorite(imageName: "manty",
             title: "Манты",
             recept: "Крупные пельмени на пару с рубленым мясом и луком."),
    Favorite(imageName: "vareniki",
             title: "Вареники",
             recept: "Отварное тесто с начинкой из картофеля, творога или вишни."),
]
