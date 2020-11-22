//
//  PersonViewController.swift
//  GreenDataTest
//
//  Created by yaruncle on 10.11.2020.
//  Copyright © 2020 yaruncle. All rights reserved.
//

import UIKit
import Nuke

class PersonViewController: UIViewController {
    
    var person: EPerson?

    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var namePerson: UILabel!
    @IBOutlet weak var sexPerson: UIImageView!
    @IBOutlet weak var birthdayPerson: UILabel!
    @IBOutlet weak var emailPerson: UILabel!
    @IBOutlet weak var timePerson: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        imageInteraction()

        // Do any additional setup after loading the view.
    }
    
    func prepareView(){
        title = "\(person!.firstName!.makeFirstCharUpper()) \(person!.lastName!.makeFirstCharUpper())"
        
        // Thumbnail image
        Nuke.loadImage(with: person!.imageURL!, into: self.imagePerson)
        
        imagePerson.layer.cornerRadius = self.imagePerson.frame.width / 2.0
        imagePerson.layer.masksToBounds = true
        
        // Set date format
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        // fetch data
        namePerson.text = self.title
        
        timePerson.text = Time()
        
        birthdayPerson.text = formatter.string(from: person!.birthday!) + " (\(person!.age))"
        
        if person!.sex {
            sexPerson.image = UIImage(named: "ImageMan")
        }
        else {
            sexPerson.image = UIImage(named: "ImageGirl")
        }
        emailPerson.text = person!.email
        
        
    }
    
    func Time() -> String {
        let now = Date()

        let formatter = DateFormatter()

        formatter.timeZone = TimeZone(abbreviation: "GMT\(person!.locationOffset!)")

        formatter.dateFormat = "HH:mm"

        let dateString = formatter.string(from: now)
        timezoneLabel.text = (person!.locationDescription! + " GMT" + person!.locationOffset!)
        
        return dateString
    }
    
    func imageInteraction(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imagePerson.isUserInteractionEnabled = true
        imagePerson.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imagePerson
        }

        let imageViewerController = ImageViewerController(configuration: configuration)

        present(imageViewerController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
