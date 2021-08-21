//
//  SUITableViewVC.swift
//  Swing
//
//  Created by rambohhhlan on 2021/8/21.
//

import UIKit
import SwiftUI

struct SMenuVC: UIViewControllerRepresentable {
    
    var controller: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let menuController = MenuVC()
        return menuController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
}

class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private struct ItemName {
        static let MememoryGame = "MememoryGame"
        static let EmojiGame = "EmojiGame"
        static let Pictures = "Pictures"
    }
    
    var tableViewData: Array<RowViewInfo> = [
        RowViewInfo(title: ItemName.MememoryGame, imageName: "circle"),
        RowViewInfo(title: ItemName.EmojiGame, imageName: "circle"),
        RowViewInfo(title: ItemName.Pictures, imageName: "circle")
    ]
    
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Menu"
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = self.tableViewData[indexPath.row].title
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.textLabel?.text = self.tableViewData[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellID = self.tableViewData[indexPath.row].title
        if cellID == ItemName.MememoryGame {
            let game = EmojiMemoryGameVM()
            let contentView = EmojiMemoryGameView(game: game)
            let vc = UIHostingController(rootView: contentView)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertController = UIAlertController(title: "提示", message: "这是第\(indexPath.row)个cell", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

struct RowViewInfo: Identifiable {
    let title: String
    let imageName: String
    let id = UUID()
}
