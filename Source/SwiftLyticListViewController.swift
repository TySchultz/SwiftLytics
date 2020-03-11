//
//  File.swift
//  
//
//  Created by Tyler Schultz on 2/24/20.
//

import Foundation
import UIKit

class SwiftLyticListViewController: UITableViewController {

  private var currentDate: Date = Date()
  private var analyticsItems: [Analytic] = []

  static func Controller(items: [Analytic]) -> SwiftLyticListViewController {
    let controller = SwiftLyticListViewController()
    controller.analyticsItems = items.sorted(by: { (left, right) -> Bool in
      return left.createdDate > right.createdDate
    })
    return controller
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.estimatedRowHeight = 100.0
    self.tableView.rowHeight          = UITableView.automaticDimension;
    self.tableView.register(AnalyticCell.self, forCellReuseIdentifier: AnalyticCell.reuseIdentifier)
    self.tableView.tableHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.analyticsItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AnalyticCell.reuseIdentifier, for: indexPath) as! AnalyticCell
    let analytic = self.analyticsItems[indexPath.row]
    cell.configure(analytic: analytic, currentDate: self.currentDate)
    return cell
  }
}

extension TimeInterval {

  private var seconds: Int {
    return Int(self) % 60
  }

  private var minutes: Int {
    return (Int(self) / 60 ) % 60
  }

  private var hours: Int {
    return Int(self) / 3600
  }

  var stringTime: String {
    if hours != 0 {
      return "\(hours)h \(minutes)m \(seconds)s"
    } else if minutes != 0 {
      return "\(minutes)m \(seconds)s"
    } else {
      return "\(seconds)s"
    }
  }
}


class AnalyticCell: UITableViewCell {
  static let reuseIdentifier: String = "AnalyticCell"

  let titleLabel: UILabel = {
    let label = UILabel()
    label.font          = UIFont.boldSystemFont(ofSize: 17)
    label.numberOfLines = 1
    return label
  }()

  let analyticLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()

  let timeLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font          = UIFont.boldSystemFont(ofSize: 12)
    label.textColor     = UIColor.red.withAlphaComponent(0.6)
    return label
  }()

  let mainStack: UIStackView = {
    let stack          = UIStackView()
    stack.axis         = .vertical
    stack.distribution = .equalSpacing
    stack.spacing = 8
    return stack
  }()

  func configure(analytic: Analytic, currentDate: Date) {
    self.selectionStyle = .none
    timeLabel.text     = configureTimeDifference(analytic: analytic, currentDate: currentDate)
    titleLabel.text    = analytic.title
    analyticLabel.text = configureText(analytic: analytic)

    self.addSubview(mainStack)
    mainStack.addArrangedSubview(timeLabel)
    mainStack.addArrangedSubview(titleLabel)
    mainStack.addArrangedSubview(analyticLabel)

    mainStack.translatesAutoresizingMaskIntoConstraints = false

    mainStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
    mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
    mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true

  }

  private func configureText(analytic: Analytic) -> String {
    var text = ""
    for (key,value) in analytic.properties {
      text += key + ": " + String(describing: value) + "\n"
    }
    return text
  }

  private func configureTimeDifference(analytic: Analytic, currentDate: Date) -> String {
    let createdDate = analytic.createdDate
    let difference  = currentDate.timeIntervalSince(createdDate)
    return difference.stringTime
  }

}
