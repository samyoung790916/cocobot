//
//  MainViewController.swift
//  cocobot
//
//  Created by samyoung79 on 03/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit
import KYDrawerController

class MainViewController: UIViewController,UIScrollViewDelegate,TAPageControlDelegate {
    
    @IBOutlet weak var MainMenuTable: UITableView!
    var bannerList = NSArray()
    var index = 0
    var timer = Timer()
    var customPageControl: TAPageControl? = nil
    var imageList = Array<Any>()
    var bannerCell:BannerCell?
    
    @objc func addTapped(){
        if let drawController = navigationController?.parent as? KYDrawerController{
            drawController.setDrawerState(.opened, animated: true)
        }
    }
    
    @objc func LoginTapped(){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.BannerRequest()

        let nibMainName = UINib(nibName: "MainMenuCell", bundle: nil)
        MainMenuTable.register(nibMainName, forCellReuseIdentifier: "MainCell")
        
        let nibSubName = UINib(nibName: "SubCell", bundle: nil)
        MainMenuTable.register(nibSubName, forCellReuseIdentifier: "SubCell")
        
        let nibBannerNmae = UINib(nibName: "BannerCell", bundle: nil)
        MainMenuTable.register(nibBannerNmae, forCellReuseIdentifier: "BannerCell")
        
        MainMenuTable.backgroundColor = UIColor.black
        MainMenuTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.navigationItem.title = "COCO"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(LoginTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LoginViewController.isLogin == true{
            
            MainMenuTable.reloadData()
            
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runImages), userInfo: nil, repeats: true)
            print("/(LoginViewController.)")
        }
        else{
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    @objc func runImages() {
        
        if index == self.imageList.count - 1 {
            index = 0
        }else{
            index = index + 1
        }
        self.customPageControl!.currentPage = index
        self.taPageControl(customPageControl, didSelectPageAt: index)
    }
    
    func taPageControl(_ pageControl: TAPageControl!, didSelectPageAt currentIndex: Int) {
        
        index = currentIndex
        
        let boundRect:CGRect = CGRect(x: (self.bannerCell?.contentView.frame.size.width)! * CGFloat(currentIndex), y: 0, width: (self.bannerCell?.contentView.frame.width)!, height: (self.bannerCell?.adImageScrollview.frame.size.height)!)
        
        self.bannerCell?.adImageScrollview.scrollRectToVisible(boundRect,animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "LoginShow", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            if LoginViewController.isLogin == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainMenuCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let main_string = "CoCo의 회원에 가입하시면 블록체인 암호화폐인\n 커피 코인을 드립니다."
                let range = (main_string as NSString).range(of: "CoCo")
                let font = UIFont(name:"Apple Color Emoji" , size: 20)
                let attribute = NSMutableAttributedString.init(string: main_string)
                
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                attribute.addAttribute(NSAttributedString.Key.font, value: font as Any, range: range)
                
                cell.MainLabel.attributedText = attribute
                cell.MainLabel.numberOfLines  = 0
                cell.SubLabel.text = "-> 커피코인 획득: 회원가입, 친구 추천, 매장추천, 잭팟 등\n-> 커피코인 활용: 코인 거래소 상장 후 현금화"
                
                cell.LoginBtn.layer.borderColor = UIColor.black.cgColor
                cell.LoginBtn.layer.cornerRadius = 15.0
                cell.LoginBtn.layer.borderWidth = 1.0
                
                
                cell.LoginBtn.addTarget(self, action: #selector(loginMainEvent(_:)), for: .touchUpInside)
                cell.JoinBtn.addTarget(self, action: #selector(joinMainEvent(_:)), for: .touchUpInside)
                
                cell.JoinBtn.layer.borderColor = UIColor.black.cgColor
                cell.JoinBtn.layer.cornerRadius = 15.0
                cell.JoinBtn.layer.borderWidth = 1.0
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as! BannerCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                self.bannerCell = cell
  
                for nIndex in 0..<self.imageList.count{
                    let xPos = cell.contentView.frame.size.width * CGFloat(nIndex)
                    let imageView = UIImageView(frame: CGRect(x: xPos, y: 0, width: cell.contentView.frame.width, height: cell.adImageScrollview.frame.size.height))
                    
                    imageView.contentMode = .scaleToFill
                    imageView.image = (imageList[nIndex] as! UIImage)
                    
                    cell.adImageScrollview.addSubview(imageView)
                }
                
                cell.adImageScrollview.delegate = self
                
                if self.customPageControl == nil{
                    let customrect =  CGRect(x: 0, y: cell.contentView.frame.size.height - 40, width: cell.contentView.frame.size.width, height: 40)
                    self.customPageControl = TAPageControl(frame: customrect)
                
                    self.customPageControl!.delegate = self as TAPageControlDelegate
                    self.customPageControl!.numberOfPages = self.imageList.count
                    self.customPageControl!.dotSize = CGSize(width: 10, height: 10)
                    
                    cell.adImageScrollview.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(self.imageList.count), height: cell.adImageScrollview.frame.size.height)
                    
                    cell.contentView.addSubview(customPageControl!)
                }
                return cell
            }
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! SubCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.separatorInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            if indexPath.row == 1{
                cell.TitleImage.image = UIImage(named: "wallet_btn")
                
                cell.MainTitle.textColor = UIColor.white
                cell.SubTitle.textColor = UIColor.lightGray
                
                cell.MainTitle.text = "내 지갑"
                cell.SubTitle.text = "현재 보유 디지털 토큰"
            }
            else if indexPath.row == 2{
                cell.TitleImage.image = UIImage(named: "order_btn")
                
                cell.MainTitle.textColor = UIColor.white
                cell.SubTitle.textColor = UIColor.lightGray
                
                cell.MainTitle.text = "가맹점 찾기 및 메뉴 주문"
                cell.SubTitle.text = "주위 가맹점을 찾고 메뉴를 주문해 보세요"
            }
            else if indexPath.row == 3{
                cell.TitleImage.image = UIImage(named: "event_btn")
                
                cell.MainTitle.textColor = UIColor.white
                cell.SubTitle.textColor = UIColor.lightGray
                
                cell.MainTitle.text = "이벤트 및 공지사항"
                cell.SubTitle.text = "다양한 이벤트에 참여해 디지털 토큰을 적립하세요"
            }
            else if indexPath.row == 4{
                cell.TitleImage.image = UIImage(named: "recommend_btn")
                
                cell.MainTitle.textColor = UIColor.white
                cell.SubTitle.textColor = UIColor.lightGray
                
                cell.MainTitle.text = "친구추천"
                cell.SubTitle.text = "커피봇을 추처한고 디지털 토큰을 발행하세요"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 200.0
        }else{
            return 70.0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func BannerRequest(){
        APIService.shared.post(url: "getad_list?sort=kr", string: nil) { (result, resultDict) in
            if result == .success{
                
                var nIndex:Int = 0
                
                let bannerList = resultDict["adlist"] as! NSArray
                var imageData = Array<Any>()
                
                bannerList.forEach { (word) in
                    let item = word as! NSObject
                    imageData.append(item.value(forKey: "AD_ADDRESS")!)
                    
                    let imageUrlString = imageData[nIndex] as! String
                    let imageUrl:URL = URL(string: imageUrlString)!
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    
                    self.imageList.append(UIImage(data: imageData as Data) as Any)
                    nIndex = nIndex + 1
                }
            }
        }
    }
    @objc func loginMainEvent(_ sender : UIButton) {
        performSegue(withIdentifier: "LoginShow", sender: self)
    }
    @objc func joinMainEvent(_ sender : UIButton) {
        performSegue(withIdentifier: "JoinShow", sender: self)
    }
}
extension Dictionary{
    func json() -> String{
        var string : String = ""
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []){
                string = String(data: jsonData, encoding: .utf8)!
        }
        return "[\(string)]"
    }
}
extension String{
    func base64() -> String{
        return Data(self.utf8).base64EncodedString()
    }
}
