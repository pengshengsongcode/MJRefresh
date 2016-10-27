//
//  ViewController.swift
//  MJRefresh
//
//  Created by 彭盛凇 on 2016/10/27.
//  Copyright © 2016年 huangbaoche. All rights reserved.
//

import UIKit

let screen_width  = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let cellID        = "cellID"

class ViewController: UIViewController {
    
    var limitCount: Int = 10        //分页数
    
    var shanglaCount: Int = 0       //上拉数
    
    var dataList: Array<Int> = []   //总数据源
    
    var limitList: Array<Int> = []  //分页数据源
    

    lazy var tableView: UITableView = {
       
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 20, width: screen_width, height: screen_height - 20), style: .plain)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        return tableView
        
    }()

    func xialaRefresh() {//下拉重新加载
        
        shanglaCount = 0//重置上拉数
        
        limitList = Array(dataList[0..<limitCount])//0,1,2,3,4,5,6,7,8,9 十组数据
        
        shanglaCount = limitCount //10
        
        tableView.reloadData()
        
        tableView.mj_header.endRefreshing()
        
        tableView.mj_footer.isHidden = false
        
        tableView.mj_footer.resetNoMoreData()//重置没有更多的数据
        
    }
    
    func shanglaRefresh() {//上拉追加数组
        
        if limitList.count < dataList.count {//如果没有加载完全，继续加载
            
            limitList += Array(dataList[shanglaCount..<shanglaCount + limitCount]) //第一次上拉 10..< 10 + 10
            
            shanglaCount += limitCount
            
            tableView.mj_footer.endRefreshing()
            
            tableView.reloadData()
            
        }else {//加载完全，显示已加载完全所有数据
            
            tableView.mj_footer.endRefreshingWithNoMoreData()

        }
        
    }
    
    func setupDataList() {
        for i in 0..<20 {   dataList.insert(i, at: i)   } //总数据源初始化
    }
    
    func setupHeader() {
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(xialaRefresh))
        
        header?.ignoredScrollViewContentInsetTop = 1//忽略多少scrollView的contentInset的top 正值向上，负值向下
        
        header?.labelLeftInset = 100//水平距离，正箭头向左，负箭头向右
        
        header?.stateLabel.isHidden = false//文字整体label，隐藏只有箭头
        
        header?.setTitle("123", for: .pulling)//设置不同状态时的文字
        
        header?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray//设置小菊花的样式
        
        header?.isAutomaticallyChangeAlpha = true //根据拖拽比例自动切换透明度
        
        tableView.mj_header = header
        
        tableView.mj_header.beginRefreshing()   //进入界面，直接下拉刷新
    }
    
    func setupFooter() {
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(shanglaRefresh))

        tableView.mj_footer = footer
        
        tableView.mj_footer.isHidden = true     //进入界面，隐藏上拉控件

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataList()
        
        setupHeader()
        
        setupFooter()

        view.addSubview(tableView)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return limitList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = "\(limitList[indexPath.row])"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //取消选中
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
