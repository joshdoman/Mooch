//
//  Model.swift
//  Camera
//
//  Created by Josh Doman on 1/6/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

class Model {
    static let MasterCategories: [String] = ["Clothing", "Sports", "Books", "Magazines", "Board games", "Toiletries", "Tools", "Crafts", "Food & Drinks", "Electronics", "Bags", "Shoes", "Hair", "Jewelry", "First Aid", "Video games", "Alcohol", "School Supplies", "Religion"]
    static let Master: Category = Category(named: "Master", superCategory: nil, subcategories: MasterCategories)

    
    static let SportsCategories: [String] = ["Tennis", "Football", "Ice Hockey", "Baseball", "Table Tennis"]
    static let Sports: Category = Category(named: "Sports", superCategory: Master, subcategories: SportsCategories)
    
    static var CategoryDictionary: [String: Category] = ["Master": Master, "Sports": Sports]
    
    static private var AllCategories: [Category: [Category]] = [Category: [Category]]()
    
    static func GetAllSubCategories(category: Category) -> [Category] {
        if let categories = AllCategories[category] {
            return categories
        }
        
        var categories: [Category] = [Category]()
        if category.getName() != "Master" {
            categories.append(category)
        }
        
        if let subcategories = category.getSubcategories() {
            
            for category in subcategories {
                categories.append(contentsOf: GetAllSubCategories(category: category))
            }
        }

        return categories
    }
    
    static func GetCategory(name: String) -> Category? {
        if let category = CategoryDictionary[name] {
            return category
        }
        return nil
    }
    
    static func createAllCategoriesAndAddToDictionary() {
        for category in CategoryDictionary.values {
            _ = category.getSubcategories()
        }
    }
}
