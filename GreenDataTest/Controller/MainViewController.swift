//
//  MainViewController.swift
//  GreenDataTest
//
//  Created by yaruncle on 06.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [EPerson] = []
    var pageNum: UInt = 1
    var pageItem: UInt = 30
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        requestPersons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Раскомментируйте, если хотите очистить базу данных
        //DBWorker.deleteEntites(entity: "EPerson")
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    // Конфигурация TableView, установка делегата и источника данных
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        fetchPeople()
        
        if(items.count<30){
            requestPersons()
        }
    }
    
    // Функция загрузки пользователей с RandomUser
    func requestPersons() {
        if(!APIManager.shared.isOnRequest()) {
            APIManager.shared.getUsersList(pageNo: pageNum, itemCnt: pageItem,
                                           onSuccess: successfullyRetrivedUserList(users:),
                                           onFail: failedToRetriveUserList(err:))
        }
    }
    
    // Загружаем данные из базы данных
    func fetchPeople(){
        do {
            let context = DBWorker.coreDataContext()
            self.items = try context.fetch(EPerson.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{            
        }
    }
    
    
    
    // Действия при успешной загрузке
    func successfullyRetrivedUserList(users : Array<Person>) {
        pageNum += 1
        DBWorker.savePersonOnDB(users: users)
        fetchPeople()
        
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    // Действия при неуспешной загрузке
    func failedToRetriveUserList(err : Error) {
        print(err.localizedDescription)
        tableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        ImageManager.shared.cleanCache()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewPerson") {
            (segue.destination as! PersonViewController).person = items[tableView.indexPathForSelectedRow!.row]
        }
    }

}

// Расширения класса для управления TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
//        cell.setData(user: PersonArray[indexPath.row])
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        cell.setData(user: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // For infinite scrolling (Pagination)
        if(indexPath.row == self.items.count - 3) { // pre-load next users list
            requestPersons()
        }
    }
    
}
