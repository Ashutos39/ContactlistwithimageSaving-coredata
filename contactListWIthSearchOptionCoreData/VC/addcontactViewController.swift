//
//  addcontactViewController.swift
//  contactListWIthSearchOptionCoreData
//
//   Created by Sds mac mini on 26/11/18.
//  Copyright © 2018 straightdrive.co.in. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData
import Alamofire
import SVProgressHUD

class addcontactViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var dataPicker: UIPickerView!
    @IBOutlet weak var startingName: SkyFloatingLabelTextField!
    @IBOutlet weak var endName: SkyFloatingLabelTextField!
    @IBOutlet weak var emailIdTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNumberTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeTxtFld: SkyFloatingLabelTextField!
    
    @IBOutlet weak var addContact: UIButton!{
        didSet {
            addContact.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!{
        didSet {
            profileImage.layer.borderWidth = 1.0
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = UIColor.black.cgColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
        }
    }
    @IBOutlet var countryNameSelectionBtn: UIButton!
    @IBOutlet var pickerrView: UIView!
    
    
    let Url = "https://restcountries.eu/rest/v1/all"
    var ctrVariable : Int = 0
    var userUpdate : [NSManagedObject] = []
    
    var countryList = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumberTxtFld.delegate = self
        emailIdTxtFld.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        pickerrView.isHidden = true
        countryCodeTxtFld.isUserInteractionEnabled = false
        getCityList()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == emailIdTxtFld {
            let str = (NSString(string: textField.text!)).replacingCharacters(in: range, with: string)
            if str.count <= 50 {
                return true
            }
            textField.text = str.substring(to: str.index(str.startIndex, offsetBy: 50))
            return false
        }
        if textField == mobileNumberTxtFld {
            let str = (NSString(string: textField.text!)).replacingCharacters(in: range, with: string)
            if str.count <= 10 {
                return true
            }
            textField.text = str.substring(to: str.index(str.startIndex, offsetBy: 10))
            return false
        }
        return true
    }
    
    // Alert
    func showAlert(withTitleMessageAndAction title:String, message:String , action: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        if action {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
        } else{
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        pickerrView.isHidden = true
        if profileImage.image == nil{
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add Profile Image", action: false)
            return
            
        }else if startingName.text == "" {
            
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add start name  please", action: false)
            return
            
        } else if endName.text == "" {
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add endname  please", action: false)
            return
        } else if emailIdTxtFld.text == "" {
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add your email please", action: false)
            return
            
        } else if((emailIdTxtFld.text) != ""  && !isValidEmail(testStr: emailIdTxtFld.text!)){
            
            if (!isValidEmail(testStr: emailIdTxtFld.text!)){
                showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Please add a valid emailId", action: false)
                return
            }
        } else if mobileNumberTxtFld.text == ""{
            
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add contact mobile Number please", action: false)
            return
            
        }else if((mobileNumberTxtFld.text) != ""  && (mobileNumberTxtFld.text!.count) != 10) {
            if ((mobileNumberTxtFld.text!.count) != 10){
                showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Please enter 10 digit mobile no.", action: false)
                return
            }
        }else if countryCodeTxtFld.text == ""{
            showAlert(withTitleMessageAndAction: "Warning!!!!", message: "Add your country", action: false)
            return
        }
        view.endEditing(true)
        save()
    }
    
    
    func save(){
        print("its working......")
        
        ctrVariable = ctrVariable + 1
        let managedObjectContext = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contact",in: managedObjectContext)
        let contact = Contact(entity: entityDescription!,insertInto: managedObjectContext)
        contact.setValue(ctrVariable, forKeyPath: "id")
        
        let profileData = compressImage(image: (profileImage.image!))
        
        contact.profileImage = profileData as Data
        contact.countryCode = countryCodeTxtFld.text
        contact.emailId = emailIdTxtFld.text
        contact.name = startingName.text! + " " + endName.text!
        //        contact.profileImage = profileImage.image
        contact.countryCode = countryCodeTxtFld.text!
        
        do {
            print("its saving.....")
            try managedObjectContext.save()
            userUpdate.append(contact)
            showAlert(withTitleMessageAndAction: "Sucess!!", message: "Contact Saved sucessfully.", action: true)
            
        } catch let error as NSError{
            showAlert(withTitleMessageAndAction: "Fail!!...", message: "Could not save\(error),\(error.userInfo)", action: false)
            
            print(error.localizedDescription)
        }
    }
    
    //dataPicker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let countryDetails = countryList[row]
        return countryDetails["name"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let countryDetails = countryList[row]
        countryCodeTxtFld.text = countryDetails["name"] as? String
        pickerrView.isHidden = true
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    
    func getCityList() {
        
        SVProgressHUD.show(withStatus: "Please Wait...")
        self.view.isUserInteractionEnabled = false
        WebService.sharedService.countryDetails { (data, error) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            if (error != nil){

                let alertController = UIAlertController(title: "Warning!", message: "Please Check your internet connection and try again later", preferredStyle: .alert)
                let Retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.getCityList()
                })
                alertController.addAction(Retry)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if let retrievedData = data as? [[String: AnyObject]]{
                
                self.countryList = retrievedData
                self.dataPicker.reloadAllComponents()
            }
        }
        
    }
    
    @IBAction func countryNameSelectionBtnPressed(_ sender: Any) {
        view.endEditing(true)
        pickerrView.isHidden = false
    }
    
    @IBAction func CancelBtnPressed(_ sender: Any) {
        pickerrView.isHidden = true
    }
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        if countryCodeTxtFld.text == ""{
            let countryDetails = countryList[0]
            countryCodeTxtFld.text = countryDetails["name"] as? String
        }
        pickerrView.isHidden = true
    }
    
    @IBAction func profileImageBtnPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera is not available")
            }
        })
        )
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func compressImage(image:UIImage) -> NSData {
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.1
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        let rect = CGRect(x:0.0,y: 0.0,width: actualWidth,height: actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        return imageData! as NSData;
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
