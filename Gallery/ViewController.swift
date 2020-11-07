//
//  ViewController.swift
//  Gallery
//
//  Created by Nivrutti on 06/11/20.
//

import UIKit

class ViewController: UIViewController {
    private let cellIdentifier = "HomeGlobalNewsTableViewCell"
    @IBOutlet weak var tblView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    private func setUpTableView() {
        let viewObj =  UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        viewObj.backgroundColor = UIColor.clear
        tblView?.tableHeaderView = viewObj
        tblView?.delegate = self
        tblView?.dataSource = self
        tblView?.sectionHeaderHeight = 0
        tblView?.sectionFooterHeight = 0
        tblView?.estimatedRowHeight = 100
        tblView?.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tblView?.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HomeGlobalNewsTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
