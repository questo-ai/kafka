//
//  DependencyGraph.swift
//  DependencyParser
//
//  Created by Arya Vohra on 28/4/20.
//  Copyright © 2020 Questo. All rights reserved.
//

import UIKit

struct Node {
    var address: Int? = nil
    var word: String? = nil
    var lemma: String? = nil
    var ctag: String? = nil
    var tag: String? = nil
    var feats: String? = nil
    var head: String? = nil
    var deps: [String: [Int]]? = nil
    var rel: String? = nil
    
    init(address: Int? = nil, word: String? = nil, lemma: String? = nil, ctag: String? = nil, tag: String? = nil, feats: String? = nil, head: String? = nil, deps: [String: [Int]]? = nil, rel: String? = nil) {
        self.address = address
        self.word = word
        self.lemma = lemma
        self.ctag = ctag
        self.tag = tag
        self.feats = feats
        self.head = head
        self.deps = deps
        self.rel = rel
    }
}

class DependencyGraph: NSObject {
    var root: Node?
    var nodes = [Int: Node]()
    
    init(tree_str: String? = nil,
         cellExtractor: ((String, String, String) -> (Int, String, String, String, String, String, String, String))? = nil,
         zero_based: Bool = false,
         cellSeparator: CharacterSet? = nil,
        top_relation_label: String = "ROOT") {
        
        self.nodes[0] = Node(address: 0, ctag: "TOP", tag: "TOP")
        if ((tree_str) != nil) {
            
        }
    }
    
    
    func remove_by_address(address: Int) {
        self.nodes.removeValue(forKey: address)
    }
    
    
    func redirect_arcs(originals: [Int: [Node]], redirect: [Int: [Node]]) {
    }
    
    func _parse(input_: String,
                cell_extractor: ((String, String, String) -> (Int, String, String, String, String, String, String, String))? = nil,
                zero_based: Bool = false,
                cellSeparator: CharacterSet? = nil,
                top_relation_label: String = "ROOT") {
        
        func extract_3_cells(cells: (String, String, String), index: Int) -> (Int, String, String, String, String, String, String, String) {
            let word = cells.0
            let tag = cells.1
            let head = cells.2
            return (index, word, word, tag, tag, "", head, "")
        }
        
        func extract_4_cells(cells: (String, String, String, String), index: Int) -> (Int, String, String, String, String, String, String, String) {
            let word = cells.0
            let tag = cells.1
            let head = cells.2
            let rel = cells.3
            return (index, word, word, tag, tag, "", head, rel)
        }
        
        func extract_7_cells(cells: (String, String, String, String, String, String, String), index: Int) -> (Int, String, String, String, String, String, String, String) {
            var castIndex = index
            let line_index = cells.0
            let word = cells.1
            let lemma = cells.2
            let tag = cells.3
            let head = cells.5
            let rel = cells.6
            
            if (Int(line_index) != nil) {
                castIndex = Int(line_index)!
            }
            
            return (castIndex, word, lemma, tag, tag, "", head, rel)
        }
        
        func extract_10_cells(cells: (String, String, String, String, String, String, String, String, String, String), index: Int) -> (Int, String, String, String, String, String, String, String) {
            var castIndex = index
            let line_index = cells.0
            let word = cells.1
            let lemma = cells.2
            let ctag = cells.3
            let tag = cells.4
            let feats = cells.5
            let head = cells.6
            let rel = cells.7
            
            if (Int(line_index) != nil) {
                castIndex = Int(line_index)!
            }
            
            return (castIndex, word, lemma, ctag, tag, feats, head, rel)
        }
        
        let extractors = [
            3: extract_3_cells,
            4: extract_4_cells,
            7: extract_7_cells,
            10: extract_10_cells,
            ] as [Int : Any]
        
        var inputLines = [String]()
        
        if (type(of: input_) == String.self) {
            var inputLines = [String]()
            for line in input_.split(separator: "\n") {
                inputLines.append(String(line))
            }
        } else {
            inputLines = [input_]
        }
        
        var cellNumber: Int? = nil
        for (index, line) in inputLines.enumerated() {
            var cells = line.components(separatedBy: cellSeparator!)
            
            if (cellNumber == nil) {
                cellNumber = cells.count
            } else {
                assert(cellNumber == cells.count)
            }
            
            var cellExtractor: (([String], Int) -> (String, String, String, String, String, String, String, String))
            if (cellSeparator == nil) {
                do {
                    let cellExtractor = extractors[cellNumber!]
                } catch {
                    fatalError("Number of tab-delimited fields" + String(cellNumber!) + " not supported by CoNLL(10) or Malt-Tab(4) format")
                }
            }
            
            do {
                let (index, word, lemma, ctag, tag, feats, head, rel) = cellExtractor(cells, index)
            } catch {
                let (word, lemma, ctag, tag, feats, head, rel) = cellExtractor(cells, index)
            }
        }
        
    }
    
    
}
