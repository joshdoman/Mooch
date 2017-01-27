//
//  Category.swift
//  Mooch
//
//  Created by Josh Doman on 1/12/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    private let superCategory: Category?
    private let categoryName: String!
    private var subcategories: [Category]?
    private let subcategoryNames: [String]?
    private let imageName: String!
    
    init(named: String, superCategory: Category?, subcategories: [String]?) {
        self.categoryName = named
        self.superCategory = superCategory
        self.subcategoryNames = subcategories
        self.imageName = named

    }
    
    private func getCategoriesFromStrings(categoryNames: [String]) -> [Category] {
        var categories = [Category]()
        for categoryName in categoryNames {
            if let category = Model.CategoryDictionary[categoryName] {
                categories.append(category)
            } else {
                let subcategory = Category.createCategory(named: categoryName, prev: self, subcategories: nil)
                categories.append(subcategory)
            }
        }
        return categories
    }
    
    public func getName() -> String {
        return categoryName
    }
    
    public func hasSuper() -> Bool {
        return superCategory != nil
    }
    
    public func getSuper() -> Category? {
        return superCategory
    }
    
    public func getSubcategories() -> [Category]? {
        if let categories = subcategories {
            return categories
        }
        
        if let subcategoryNames = subcategoryNames {
            subcategories = getCategoriesFromStrings(categoryNames: subcategoryNames)
            return subcategories
        }
        return nil
    }
    
    public func getSubcategoryNames() -> [String]? {
        if let categories = subcategoryNames {
            return categories
        }
        return nil
    }
    
    public func getImageName() -> String {
        return imageName
    }
    
    static public func createCategory(named: String, prev: Category?, subcategories: [String]?) -> Category {
        let category = Category(named: named, superCategory: prev, subcategories: subcategories)
        Model.CategoryDictionary[named] = category
        return category
    }
    
}
