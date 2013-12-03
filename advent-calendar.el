;;; advent-calendar-2013.el -- Adventure of AdventCalendar in Japan.

;; Author: Wataru MIYAGUNI (gonngo _at_ gmail.com)
;; Keywords: adventcalendar

;; Copyright (c) 2013 Wataru MIYAGUNI
;;
;; MIT License
;;
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;;; Commentary:

;; This program is a tool for Advent Calendar 2013 in Japan.
;; Calendar list was in reference to http://gihyo.jp/news/info/2013/12/0101

;;; Usage:

;;
;; (require 'advent-calendar-2013)
;;

;;; Code:

(eval-when-compile (require 'cl))
(require 'xml)
(require 'helm)

(defconst advent-calendar->buffer-name "*AdventCalendar2013*"
  "Buffer name used to `advent-calendar:http-get'")

(defconst advent-calendar->days-buffer-name "*AdventCalendar2013Days*")

(defconst advent-calendar->list
  '(
    ;; atnd.org
    (:type atnd :url "http://atnd.org/events/38387" :title "Excel方眼紙 Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/39189" :title "ゆとり Advent Calendar")
    (:type atnd :url "http://atnd.org/events/44814" :title "いろふ Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45042" :title "Clojure Advent Calendar 2013 (全部俺)")
    (:type atnd :url "http://atnd.org/events/45043" :title "R Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45072" :title "Vim Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45075" :title "Aizu Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45096" :title "FuelPHP Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45107" :title "PowerShell Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45110" :title "Force.com Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45132" :title "WEB解析 Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45135" :title "DXRuby Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45161" :title "Processing Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45244" :title "Visual Basic Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45245" :title "艦これAdvent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45316" :title "Oculus Rift Advent Calendar")
    (:type atnd :url "http://atnd.org/events/45511" :title "FOSS4G Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45546" :title "WordPress Advent Calendar 2013 全部オレ")
    (:type atnd :url "http://atnd.org/events/45560" :title "ひとりWindowsストアゲームアドベントカレンダー")
    (:type atnd :url "http://atnd.org/events/45595" :title "CloudStack Advent Calendar jp: 2013")
    (:type atnd :url "http://atnd.org/events/45715" :title "もうだめだAdventCalendar")
    (:type atnd :url "http://atnd.org/events/45749" :title "Wakame Users Group Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45763" :title "OpenStack Advent Calendar 2013 JP")
    (:type atnd :url "http://atnd.org/events/45771" :title "セカンドライフ 技術系 Advent Calendar 2013")
    (:type atnd :url "http://atnd.org/events/45874" :title "はてな手帳出し アドベントカレンダー 2013")
    (:type atnd :url "http://atnd.org/events/45968" :title "Debian/Ubuntu JP Advent Calendar 2013")
    ;; qiita.com
    (:type qiita :url "http://qiita.com/advent-calendar/2013/android" :title "Android Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/angularjs-startup" :title "AngularJS Startup Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ansible" :title "Ansible Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/aws" :title "Amazon Web Service Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/azure" :title "Windows Azure Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ceylon" :title "Ceylon Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/civictech" :title "Civic Tech Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/clojure" :title "Clojure Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/cocos2d-x" :title "cocos2d-x Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/cocos3d-x" :title "cocos3d-x Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/codeigniter" :title "CodeIgniter Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/corona" :title "Corona Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/delphi" :title "Delphi Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/distro-pm" :title "ディストリビューション/パッケージマネージャー Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/dlang" :title "D言語 Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/docja" :title "Doc-ja Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/documentation" :title "ドキュメンテーション Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/dot-emacs" :title ".emacs Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/dotfiles" :title "みんなで作ろう最強の設定ファイル Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/doukaku-past-questions" :title "どう書く過去問 Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/elixir" :title "Elixir Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/fluentd" :title "Fluentd Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/gas" :title "Google Apps Script Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/gastah" :title "G*(Groovy, Grails ..) Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/git" :title "Git Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/go" :title "Go Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/gorilla" :title "GorillaScript Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/groonga" :title "全文検索エンジンGroonga Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/grunt-plugins" :title "Grunt Plugins Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/hadoop" :title "Hadoop Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/haskell" :title "Haskell Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/haxe" :title "Haxe Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/hdl" :title "HDL Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/hubot-scripts" :title "hubot-scripts Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ibeacon" :title "iBeacon Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/intellij" :title "IntelliJ IDEA Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ios" :title "iOS Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ios-2" :title "iOS Second Stage Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/javascript" :title "JavaScript - Client Side - Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/jenkinsci" :title "Jenkins CI Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/jsx" :title "JSX Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/kernelvm" :title "カーネル/VM Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/laravel" :title "Laravel Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/latin" :title "ラテン語プログラミング Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/linux" :title "Linux Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/lisp" :title "Lisp Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/machinelearning" :title "Machine Learning Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/math" :title "数学 Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/minor-language" :title "マイナー言語 Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/mongodb" :title "MongoDB Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/mop" :title "Metaobject Protocol(MOP) Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/mruby" :title "mruby Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/one-minute" :title "1分で実現できる有用な技術 Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/osm" :title "OpenStreetMap Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/php" :title "PHP Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/phpstorm" :title "PhpStorm Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/postgresql" :title "PostgreSQL Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/processing" :title "Processing Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/python" :title "Python Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/riak" :title "みんなでやるRiak Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ruby" :title "Ruby Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/ruby-on-rails" :title "Ruby on Rails Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/rubymotion" :title "RubyMotion Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/rust" :title "Rust Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/scala" :title "Scala Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/static_and_machinlearning" :title "統計＆機械学習 Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/tddadventjp" :title "TDD Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/theorem_prover" :title "Theorem Prover Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/unity" :title "Unity Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/webpay" :title "WebPay Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/win-store-app" :title "Windows Store App Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/xamarin" :title "Xamarin Advent Calendar 2013")
    (:type qiita :url "http://qiita.com/advent-calendar/2013/zsh" :title "zsh Advent Calendar 2013")
    ;; adventar.org
    (:type adventar :url "http://www.adventar.org/calendars/101" :title "PHP Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/102" :title "GNOME Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/103" :title "Firefox OS Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/104" :title "Play framework 2.x Java and 1.x Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/105" :title "サーバー構築からWordPressインストールまで Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/106" :title "カレー Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/107" :title "つけ麺 #LOVETSUKEMEN Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/108" :title "Eject Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/109" :title "広島弁 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/110" :title "げんこつハンバーグ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/111" :title "HPC Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/112" :title "おれおれPhotoshoplab Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/113" :title "UEC Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/114" :title "Play framework 2.x Scala Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/115" :title "UX Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/116" :title "UI Design Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/117" :title "d3.js Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/118" :title "果てなき渇望 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/119" :title "C# Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/120" :title "mikutter Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/121" :title "Linux Mint Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/122" :title "ジョジョの奇妙な冒険 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/124" :title "パスタ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/125" :title "HTML5 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/126" :title "Perfume Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/127" :title "ダジャレ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/128" :title "Selenium Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/130" :title "RSpec Tips Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/131" :title "はぐれ学生 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/132" :title "One ASP.NET Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/133" :title "Sitecore Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/134" :title "Office 365 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/135" :title "jQuery Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/136" :title "Fireworks Lover Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/137" :title "Sencha Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/138" :title "もしもしサンタ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/140" :title "野球応援 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/141" :title "NISA前夜　NISAで何買う？　実践　株式投資　10万程度 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/142" :title "Sphero Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/143" :title "Jimdo Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/144" :title "iPhone Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/145" :title "Java Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/146" :title "JavaFX Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/147" :title "プリキュア Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/148" :title "Kotlin Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/149" :title "GlassFish Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/150" :title "アドベント・ぼっち・カレンダー Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/152" :title "Java EE Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/153" :title "Spring Framework Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/155" :title "XAML Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/156" :title "&quot;あの弁当、誰んだー？&quot; Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/158" :title "TED 広める価値のあるアイデア Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/161" :title "Cloud Foundry Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/162" :title "ロマン会議 オススメの一冊 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/164" :title "大掃除 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/165" :title "子育て 読み聞かせ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/166" :title "Python Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/167" :title "Blog Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/168" :title "tumblr reblogging enviroment Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/169" :title "世界の麦汁 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/170" :title "Mathematics Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/171" :title "JBoss / WildFly (全部俺) Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/172" :title "LibreOffice Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/173" :title "コンサドーレ札幌 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/174" :title "コワーキング Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/175" :title "麺道楽 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/176" :title "sbwhitecap Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/177" :title "Twilio for KDDI Web Communications Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/179" :title "リブライズ ～すべての本棚を図書館に～ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/180" :title "Shin x blog Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/181" :title "test Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/182" :title "Adobe AIR Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/183" :title "法務系Tips Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/184" :title "おれのさぶらいむてきすと Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/185" :title "MUGEN Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/186" :title "Microsoft Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/187" :title "TeX &amp; LaTeX Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/189" :title "新潟県コミュニティ・フォーラム Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/190" :title "ソニックムーブ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/192" :title "消しゴムはんこ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/193" :title "岩手・宮城・福島 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/194" :title "我が家の植物自慢 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/195" :title "うどん Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/196" :title "惑星わくわく！ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/198" :title "パーフェクトRuby Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/199" :title "会計・経理系のネタ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/200" :title "Asakusa Framework Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/201" :title "Windows Phone Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/202" :title "Eucalyptus Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/203" :title "お金の知っ得ネタ25連発！ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/204" :title "a-blog cms Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/205" :title "Filemaker Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/206" :title "Atlassian Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/207" :title "webコーダーカルテット Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/208" :title "CA14 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/209" :title "深夜連絡 ASP.NET MVC な Web アプリ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/210" :title "ChatWork Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/211" :title "C++  (fork) Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/212" :title "拡張 POSIX シェルスクリプト Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/213" :title "Teach Myself Lojban Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/215" :title "SLP CEM Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/216" :title "vExperts Blog Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/218" :title "Internet Explorer Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/219" :title "好きなキャラ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/220" :title "オヤ辞林 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/221" :title "Javatter Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/222" :title "baserCMS Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/224" :title "NancyFx Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/226" :title "idol Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/227" :title "(全部俺) Oracle ACE Director Tanel Poder Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/228" :title "SQL Server(T-SQL) Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/229" :title "餃子 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/231" :title "( ・_・) Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/232" :title "明日話したくなる科学豆知識 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/233" :title "UDCP Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/235" :title "Yet Another Internet Explorer Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/238" :title "日本のサッカー選手で Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/239" :title "中国茶 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/240" :title "コミケカタログをスマホで！ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/241" :title "イルミネーション Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/242" :title "UXとかHCDとかその辺りの何かをひとりで黙々とまとめる Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/243" :title "今日読んだマンガ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/244" :title "Playlists Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/245" :title "The Battle for Wesnoth Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/247" :title "Twitterにおいての一年を振り返る Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/247" :title "masawada Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/248" :title "Minecraft Minimum Mods Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/249" :title "eReading Maniacs Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/251" :title "Middleman Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/252" :title "闇 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/254" :title "小ネタアイデア Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/255" :title "25 kindness things to do before Christmas Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/256" :title "(全部俺)何でも Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/257" :title "Advent Calendar Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/258" :title "P4U2稼働記念に何かネタを書くアドベントカレンダー Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/259" :title "ももいろクローバーZ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/260" :title "おまいらの好きなコマンド貼ってけ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/56" :title "Node.js Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/57" :title "CSS Property Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/58" :title "X'mas Card Design Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/59" :title "Editors' &amp; Writers' Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/61" :title "BEM Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/62" :title "Frontrend Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/63" :title "LOVEFONT Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/64" :title "Web Accessibility Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/65" :title "Kosen Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/66" :title "JavaScriptおれおれ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/67" :title "Illumination Photo Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/68" :title "Graphical Web Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/69" :title "クックパッド Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/70" :title "寿司 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/72" :title "仏 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/73" :title "WSD! 14期 ワークショップ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/74" :title "すごい広島 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/75" :title "大都会岡山 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/76" :title "釧路 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/77" :title "道民部 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/78" :title "Titanium&#8482; Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/79" :title "ラーメン Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/80" :title "モンハン Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/81" :title "日高屋 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/82" :title "CodeIQ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/84" :title "つらぽよ Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/85" :title "Dart Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/86" :title "ビール Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/87" :title "東京スカイツリー Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/89" :title "Travel Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/90" :title "Stinger Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/91" :title "Game Development Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/92" :title "Movable Type Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/93" :title "Egison Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/94" :title "Ember.js Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/95" :title "FuniSaya Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/96" :title "Advent Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/97" :title "日本酒 Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/98" :title "Metal Advent Calendar 2013")
    (:type adventar :url "http://www.adventar.org/calendars/99" :title "Sketch.app Advent Calendar 2013")
    ))

(defvar advent-calendar->cache-calendar (make-hash-table :test #'equal))

;;------------------------------
;; Define exception error
;;------------------------------
(put 'advent-calendar:exception-not-retrieved 'error-message
     "Advent Calendar - Not retrieved")
(put 'advent-calendar:exception-not-retrieved 'error-conditions
     '(advent-calendar:exception-not-retrieved error))

;;-----------------------------------------------------
;; Network functions
;;-----------------------------------------------------

(defun advent-calendar:http-get (url &optional buffer coding)
  (message url)
  (if (null buffer) (setq buffer advent-calendar->buffer-name))
  (ignore-errors (kill-buffer buffer))
  (let ((coding-system-for-read coding))
    (unless (eq 0 (call-process "curl" nil `(,buffer nil) nil
                                "-f"
                                "-X" "GET"
                                url))
      (signal 'advent-calendar:exception-not-retrieved
              "The requested URL returned error"))))

;;-----------------------------------------------------
;; HTML parser
;;-----------------------------------------------------

(defun advent-calendar:find-tag-by-class (tree class &optional tag)
  (if (and
       (member class (split-string (xml-get-attribute tree 'class) " "))
       (if (null tag) t (string-equal tag (xml-node-name tree))))
      tree
    (let (nodes node)
      (dolist (child (xml-node-children tree) nodes)
        (when (and (listp child)
                   (setq node (advent-calendar:find-tag-by-class child class tag)))
          (setq nodes (append nodes
                              (if (symbolp (xml-node-name node))
                                  (list node) node))))))))

(defun advent-calendar:lrtrim (text)
  (when text
    (replace-regexp-in-string "\\`\\(?:\\s-\\|\n\\)+\\|\\(?:\\s-\\|\n\\)+\\'" "" text)))

(defun advent-calendar:extract-link-at-uri-text (descriptions)
  (let ((uri-re "\\(https?://[^ \n]+\\)")
        title link)
    (dolist (desc descriptions)
      (when (stringp desc)
        (when (string-match uri-re desc)
          (setq link (match-string 1 desc))
          (setq desc (replace-regexp-in-string (regexp-quote link) "" desc)))
        (setq title (concat title (advent-calendar:lrtrim desc)))))
    (cons title link)))

(defun advent-calendar:extract-link-at-a-tag (descriptions)
  (let (title link)
    (dolist (desc descriptions)
      (setq title (concat
                   title
                   (advent-calendar:lrtrim
                    (cond ((stringp desc) desc)
                          ((eq (xml-node-name desc) 'a)
                           (setq link (xml-get-attribute desc 'href))
                           (nth 2 desc)))))))
    (when link
      (setq title (replace-regexp-in-string (regexp-quote link) "" title)))
    (cons title link)))

(defun advent-calendar:extract-link (descriptions)
  "If exists link text, return '(:url \"http://example.com\" :tilte \"Example Site\").
Not exists, return nil."
  (let (analysis title url)
    (setq analysis (advent-calendar:extract-link-at-a-tag descriptions))
    (setq title (car analysis))
    (setq url (cdr analysis))
    (unless url
      (setq analysis (advent-calendar:extract-link-at-uri-text descriptions))
      (setq title (car analysis))
      (setq url (cdr analysis)))
    (when url
      (setq title (replace-regexp-in-string "\\s-*\n+\\s-*" " " title))
      `(:title ,title :url ,url))))

;;-----------------------------------------------------
;; Qiita
;;-----------------------------------------------------

(defun advent-calendar:qiita:get-url (url)
  (concat url "/feed"))

(defun advent-calendar:qiita:get-entries ()
  (xml-get-children (car (xml-parse-region (point-min) (point-max))) 'entry))

(defun advent-calendar:qiita:parse ()
  (let ((articles (advent-calendar:qiita:get-entries))
        items)
    (dolist (item articles items)
      (let* ((nodes (xml-node-children item))
             (title (nth 2 (assq 'title nodes)))
             (author (nth 2 (assq 'name (assq 'author nodes))))
             (url (xml-get-attribute (assq 'link nodes) 'href))
             (content-node (assq 'content nodes))
             (content-type (xml-get-attribute content-node 'type)))
        (when (string-equal content-type "text")
          (setq title (concat title " " (nth 2 content-node))))
        (when url
          (setq title (replace-regexp-in-string (regexp-quote url) "" title))
          (setq items (append items `((:author ,author :url ,url :title ,title)))))))))


;;-----------------------------------------------------
;; Atnd
;;-----------------------------------------------------

(defun advent-calendar:atnd:get-url (url)
  (concat (replace-regexp-in-string "/events/" "/comments/" url) ".rss"))

(defun advent-calendar:atnd:get-entries ()
  (let ((tree (car (xml-parse-region (point-min) (point-max)))))
    (xml-get-children (assq 'channel (xml-node-children tree)) 'item)))

(defun advent-calendar:atnd:get-link (descriptions)
  (let (title url nodes)
    (dolist (desc descriptions)
      (setq nodes (with-temp-buffer
                    (insert "<hoge>" desc "</hoge>")
                    (car (xml-parse-region (point-min) (point-max)))))
      (when (xml-get-children nodes 'a)
        (setq title (concat
                     title
                     (mapconcat (lambda (x)
                                  (cond ((stringp x) (advent-calendar:lrtrim x))
                                        ((eq (xml-node-name x) 'a)
                                         (setq url (xml-get-attribute x 'href))
                                         (advent-calendar:lrtrim (nth 2 x)))))
                                (cddr nodes) "")))))
    (when title
      (setq title (replace-regexp-in-string "\\s-*\n+\\s-*" " " title)))
    `(:title ,title :url ,url)))

(defun advent-calendar:atnd:parse ()
  (let* ((articles (advent-calendar:atnd:get-entries))
         items)
    (dolist (item articles items)
      (let* ((nodes (xml-node-children item))
             (content (cddr (assq 'description nodes)))
             (author (nth 2 (assq 'author nodes)))
             (link (advent-calendar:atnd:get-link content)))
        (unless (plist-get link :url)
          (setq link (advent-calendar:extract-link content)))
        (when link
          (setq items (append items `(,(plist-put link :author author)))))))))

;;-----------------------------------------------------
;; Atnd
;;-----------------------------------------------------

(defun advent-calendar:adventar:get-url (url)
  (concat url ".rss"))

(defun advent-calendar:adventar:get-entries ()
  (let ((tree (car (xml-parse-region (point-min) (point-max)))))
    (xml-get-children (assq 'channel (xml-node-children tree)) 'item)))

(defun advent-calendar:adventar:parse ()
  (let* ((articles (advent-calendar:adventar:get-entries))
         items)
    (dolist (item articles items)
      (let* ((nodes (xml-node-children item))
             (title (nth 2 (assq 'title nodes)))
             (url (nth 2 (assq 'link nodes)))
             (description (nth 2 (assq 'description nodes))))
        (when description
          (setq title (concat title " / " description)))
        (setq items (append items `((:title ,title :url ,url))))))))


;;-----------------------------------------------------
;;
;;-----------------------------------------------------

(defun advent-calendar:get-days (url func)
  (let (days)
    (or (gethash url advent-calendar->cache-calendar)
        (when func
          (advent-calendar:http-get url advent-calendar->buffer-name)
          (setq days (save-current-buffer
                       (set-buffer advent-calendar->buffer-name)
                       (goto-char (point-min))
                       (funcall func)))
          (puthash url days advent-calendar->cache-calendar)))))

(defun advent-calendar:zusaar:get-url (url)
  url)


;;-----------------------------------------------------
;; Helm candidates maker
;;-----------------------------------------------------

(defun advent-calendar:helm-candidates-list ()
  (loop for item in advent-calendar->list
        collect (cons (format "[%s] %s"
                              (symbol-name (plist-get item :type))
                              (plist-get item :title))
                      item)))

(defun advent-calendar:helm-candidates-days (calendar)
  (let ((type (plist-get calendar :type))
        (title (plist-get calendar :title))
        (url (plist-get calendar :url))
        days)

    (setq days (let (func get-url)
                 (cond ((eq type 'atnd)
                        (setq func 'advent-calendar:atnd:parse)
                        (setq get-url (advent-calendar:atnd:get-url url)))
                       ((eq type 'qiita)
                        (setq func 'advent-calendar:qiita:parse)
                        (setq get-url (advent-calendar:qiita:get-url url)))
                       ((eq type 'adventar)
                        (setq func 'advent-calendar:adventar:parse)
                        (setq get-url (advent-calendar:adventar:get-url url))))
                 (advent-calendar:get-days get-url func)))

    (loop for day in days
          collect (cons (if (plist-get day :author)
                            (format "%s by %s" (plist-get day :title) (plist-get day :author))
                          (plist-get day :title))
                        day))))

;;-----------------------------------------------------
;; Helm action
;;-----------------------------------------------------
(defun advent-calendar:view-calendar (calendar)
  (let ((title (plist-get calendar :title))
        (helm-action-buffer advent-calendar->days-buffer-name))
    (helm :sources `((name . ,title)
                     (candidates . ,(advent-calendar:helm-candidates-days calendar))
                     (action
                      ("Open browser"  . advent-calendar:open-browser)))
          :allow-nest nil)))

(defun advent-calendar:open-browser (calendar)
  (browse-url (plist-get calendar :url)))

;;-----------------------------------------------------
;; User functions
;;-----------------------------------------------------

;;;###autoload
(defun advent-calendar-2013 ()
  (interactive)
  (helm :sources `((name . "Advent Calendar 2013")
                   (candidates . ,(advent-calendar:helm-candidates-list))
                   (action
                    ("Open calendar on browser"  . advent-calendar:open-browser)
                    ("View calendar" . advent-calendar:view-calendar)))))

(provide 'advent-calendar-2013)
