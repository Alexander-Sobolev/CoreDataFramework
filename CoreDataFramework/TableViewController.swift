//
//  TableViewController.swift
//  CoreDataFramework
//
//  Created by Alexander Sobolev on 27.02.2021.
//

import UIKit
import CoreData
 
class TableViewController: UITableViewController {

    // 1. Создали Entety использовали Entety здесь [Task]
    var tasks: [Task] = []
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        // 2. Cоздаем AlertController
        let alertController = UIAlertController(title: "New Task", message: "Please add a new task", preferredStyle: .alert)
        // 3. Cоздаем AlertAction
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            // 4. Cоздаем поле textField
            let tf = alertController.textFields?.first
            // 5. Если textField не пустое поле и в это поле что то введется тогда мы это будем добавлять в массив [Task]
            if let newTaskTitle = tf?.text {
                // 6. Поэтому пишем 
                self.saveTask(withTitle: newTaskTitle)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func saveTask(withTitle title: String) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        // Сохраняем контекст таким образом чтобы наши изменения попали в базу данных
        do {
            try context.save()
            tasks.append(taskObject) // Добавляем объект в массив
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //        let context = getContext()
       //        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
       //        if let objects = try? context.fetch(fetchRequest) {
       //            for object in objects {
       //                context.delete(object)
       //            }
       //        }
       //
       //        do {
       //            try context.save()
       //        } catch let error as NSError {
       //            print(error.localizedDescription)
       //        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest() // Создаем запрос по которому мы можем получить все объекты хранящиеся по Entities Task
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ceo", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title

        return cell
    }
}
