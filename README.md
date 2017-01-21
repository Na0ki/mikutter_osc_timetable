# mikutter_osc_timetable

![01](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/01.png?raw=true)

mikutter をOSCブラウザにするプラグインです。

# 要件

mikutter 3.5.2 以降を使用してください。

# インストール方法

    $ mkdir -p ~/.mikutter/plugin/osc_timetable; git clone https://github.com/Na0ki/mikutter_osc_timetable.git ~/.mikutter/plugin/osc_timetable

# 使い方

## OSCの一覧を得る

![02](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/02.png?raw=true)

プラグインをインストールすると、コマンド「OSC」が追加され、ステータスバーの右にOSCのロゴが追加されます。

![03](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/03.png?raw=true)

これをクリックするなどして実行すると、開催されるOSCの一覧が表示されます。これは開発中なので表示が終わっている上、OSC2017 Osakaにしか対応していません。

## OSC一覧からOSCを開く

![04](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/04.png?raw=true)

上記のリストから開きたいOSCを右クリックし、「開く」を選択します。

![05](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/05.png?raw=true)

開催日程の一覧を取得することができます。OSC Osakaは複数日ありますが、一日のみの開催の場合は一つしか表示されません。

## タイムテーブルを開く

上記開催日程を右クリックして「開く」を選ぶと、タイムテーブルが表示されます。

![01](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/01.png?raw=true)

本家のように表にはなっていません。

## セミナーを開く

上記のセミナーを右クリックして「開く」を選ぶと、ブラウザでそのセミナーのページを開くことができます。

## コマンド

window ロールに、OSC一覧を開くコマンドが定義されているので、ショートカットキーなどでOSC一覧を呼び出せます。

また、標準プラグインの「開く」(intent_open) をダブルクリックなどに割り当てておくと、ダブルクリックでタイムテーブルを開くことができるようになります。

## インテント

TwitterなどでOSCのリンクを踏むと、そのOSCをOSCプラグインで開くことができるようになります。

![06](https://github.com/Na0ki/mikutter_osc_timetable/blob/master/screenshot/06.png?raw=true)
