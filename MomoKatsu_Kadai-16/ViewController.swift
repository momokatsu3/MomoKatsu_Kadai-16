//
//  ViewController.swift
//  MomoKatsu_Kadai-16
//  Part16 既存の項目の名前を変更できる機能
//  Created by モモカツ on 2023/07/21.

import UIKit

class ViewController: UIViewController {

    // 編集用インデックスパスnadoを設定
    var selectMode: String = ""
    private var editSelectedIndexPath: IndexPath?

    // テーブルビューとのインスタンス変数設定（？？）
    @IBOutlet weak var tableView: UITableView!

    // 構造体を設定
    struct ItemValue {
        var name: String
        var check: Bool
    }
    // 表示する値を構造体で設定
    var selectItems:[ItemValue] = []

     override func viewDidLoad() {
        super.viewDidLoad()
        // テーブルビュー表示内容
        selectItems = [
            ItemValue(name: "りんご", check: false),
            ItemValue(name: "みかん", check: true),
            ItemValue(name: "バナナ", check: false),
            ItemValue(name: "パイナップル", check: true),
        ]
    }

    // AddItemViewController で新規登録する内容のテキストフィールド値を追加・テーブルビュー再描画
    @IBAction func inputNameTextField(unwindSegue: UIStoryboardSegue) {

        guard let addEditItemVC = unwindSegue.source as? AddEditItemViewController else { return }

        //print("選択モード：", selectMode)
        // AddItemViewController で追加した内容を表示
        //print("追加内容：'", addEditItemVC.inputName as Any, "'")

        // 追加モードの処理
        if selectMode == "AddMode" {
            // 追加した内容を構造体へ追加
            selectItems.append(ItemValue(name: addEditItemVC.inputName  as Any as! String, check: false))
            //print("追加入力後のデータ個数：", selectItems.count)
            //print(selectItems)
        }
        // 編集モードの処理
        if selectMode == "EditMode" {
            selectItems[editSelectedIndexPath!.row].name = addEditItemVC.inputName  as Any as! String
            selectItems[editSelectedIndexPath!.row].check = false
            //print(selectItems)
        }
        //テーブルを再描画
        tableView.reloadData()
    }

    // performSegueで遷移した編集画面の内容を処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // 画面遷移する際の segue.identifier を確認
        //print("選択seghue：", segue.identifier as Any)

        if let addEditItemVC = segue.destination as? AddEditItemViewController {
            switch segue.identifier ?? "" {
            case "AddSegue" :
                // 遷移先画面を追加モードに設定
                selectMode = "AddMode"
                addEditItemVC.mode = AddEditItemViewController.Mode.Add
                break
            case "EditSegue" :
                // 遷移先画面を編集モードに設定
                selectMode = "EditMode"
                addEditItemVC.mode = AddEditItemViewController.Mode.Edit
                guard let indexPath = sender as? NSIndexPath else { break } //NSIndexPathでエラーの可能性がある
                addEditItemVC.inputName = selectItems[indexPath.row].name
                //print(addEditItemVC.inputName as Any, selectItems[indexPath.row].name, selectItems[indexPath.row].check)
                break
            default:
                break;
            }
        }
    }

}


// ストリーボードの TableView と ViewController を Delegate で紐付けするが必要。
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    // テーブルビューに表示するセルの生成（データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される））
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //セルを取得する
        let cell = UITableViewCell(style: .default, reuseIdentifier: "selectCell")
        // アクセサリに「DetailButton」を指定する場合
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton

        // 選択テーブルビュー位置を表示
        //print("indexPath=", indexPath)

        // チェックマークを"true"の場合付ける
        if selectItems[indexPath.row].check {
            cell.imageView!.image = UIImage(named: "check")
        } else {
            cell.imageView!.image = UIImage(named: "nocheck")
        }

        cell.textLabel!.text = selectItems[indexPath.row].name
        return cell
    }

    // テーブルビューに表示するデータ個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        //print("データ個数：", selectItems.count)
        return selectItems.count
    }

    // didSelectRowAtでセルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // チェックマークを反転
        selectItems[indexPath.row].check.toggle()
        //print("チェックマーク：", selectItems[indexPath.row].check, ",   名 前：", selectItems[indexPath.row].name)

        // TableView の特定の行だけをリロード
        self.tableView.reloadRows(at: [indexPath], with: .fade)//automatic) .none)
    }

    //各indexPathのcellのアクセサリボタンがタップされた際の処理
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        editSelectedIndexPath = indexPath
        // selectedEditIndexPathを使用して "EditSegue"を呼び出す
        performSegue(withIdentifier: "EditSegue", sender: indexPath)

        //print("accessory button was tapped")
        // 選択テーブルビュー位置を表示
        //print("indexPath=", indexPath)

    }

}
// ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
