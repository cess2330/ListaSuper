//
//  ViewController.swift
//  ListaSuper
//
//  Created by Cesar Castillo on 12/02/18.
//  Copyright © 2018 Cesar Castillo. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var listaTableView: UITableView!
    @IBOutlet var articuloTextfield: UITextField!
 
    @IBOutlet var anadirButton: YTRoundedButton!
    
    var articulos = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articuloTextfield.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticuloEntity")
        
        do {
            let resultados = try managedContext.fetch(fetchRequest)
            
            articulos = resultados as! [NSManagedObject]
          
        } catch let error as NSError {
            print("Falló al guardar: \(error), \(error.localizedDescription)")
        }
        
    }
    
    
    func saveItem(articuloAGuardar : String?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "ArticuloEntity", in: managedContext)
        let item =  NSManagedObject(entity: entity!, insertInto: managedContext)
        if (articuloAGuardar != nil) {
            item.setValue(articuloAGuardar, forKey: "nombre")
        }
        
        do {
            try managedContext.save()
            articulos.append(item)
        } catch let error as NSError {
            print("Falló al guardar: \(error), \(error.localizedDescription)")
        }
        
    }
    
    func alertControllerGenerated(mensaje: String, titulo: String) {
        
        let alert =  UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func anadirPressed(_ sender: YTRoundedButton) {
        
        
        if articuloTextfield.text!.isEmpty {
            self.alertControllerGenerated(mensaje: "Debe escribir un articulo para poder ser agregado a la lista.", titulo: "Campo de Texto Vacío")
        } else {
            self.saveItem(articuloAGuardar: articuloTextfield.text!)
            self.articuloTextfield.text = ""
            self.listaTableView.reloadData()
            self.ocultarTeclado()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func ocultarTeclado() {
        articuloTextfield.resignFirstResponder()
    }

}
    
    
    
   
extension ViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return articulos.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SuperTableViewCell
            let articulo = articulos[indexPath.row]
            cell.nombrearticulo.text = articulo.value(forKey: "nombre") as? String
        
        let articuloSeleccionado = articulos[indexPath.row]
        let marcado = articuloSeleccionado.value(forKey: "marcado") as? Bool
        

        if (marcado == true) {
             cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
      
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let taskObject = self.articulos[indexPath.row]
        let taskStatus = taskObject.value(forKey: "marcado") as? Bool ?? false
        
        taskObject.setValue(!taskStatus,forKey:"marcado")
        
        do {
            try managedContext.save()
               // cell?.accessoryType = .checkmark
        } catch let error as NSError {
            print("Falló al guardar: \(error), \(error.localizedDescription)")
        }
        self.ocultarTeclado()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
            }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
                if editingStyle == .delete {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    managedContext.delete(articulos[indexPath.row])
                    articulos.remove(at: indexPath.row)
                    
                    do {
                        try managedContext.save()
                        print("Guardado!")
                    } catch let error as NSError  {
                        print("No se pudo guardar \(error), \(error.userInfo)")
                    } catch {
                        
                    }
                    listaTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
}

