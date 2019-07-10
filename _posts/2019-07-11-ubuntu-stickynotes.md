---
title: "Dev: 우분투 - StickyNotes 설치하기"
categories:
  - Development
tags:
  - Dev_setting
---

윈도우에서 임시 메모 목적이나 TODO List 작성 용도로 StickyNotes를 유용하게 사용중인데,  
우분투 개발환경에서 윈도우의 StickyNotes와 동일 목적으로 사용할 수 있는 indicator-stikynotes의 설치법을 적어본다.

<!--more-->

우분투용 StickyNotes 기능의 앱 중에는 드롭박스 동기화를 지원하는 것도 있고, 여러 부가기능을 가진 프로그램들이 많지만, 내가 이 앱을 사용하는 이유는 간단하다.

이쁘다.

![indicator-stickynotes](/assets/images/2019-07-11-ubuntu-stickynotes_001.png)

<br/>
설치도 딱 세 줄 입력하는 것으로 끝난다.  
repository를 추가하고, 업데이트하고, 설치하면 끝이다.

```bash
$ sudo add-apt-repository ppa:umang/indicator-stickynotes

$ sudo apt-get update

$ sudo apt-get install indicator-stickynotes
```

<br/>
설치 완료.

![installed_indicator-stickynotes](/assets/images/2019-07-11-ubuntu-stickynotes_002.png)

<br/>
Python과 GTK기반으로 동작하는 앱이라 업데이트 시 꼬이는 경우도 있는 것 같지만 2019년 7월 기준으로 아직까지 잘 관리되며 업데이트 되고 있기에 별 일 없는 이상 계속 사용할 예정이다.

작성 완료된 건 자물쇠 아이콘을 클릭해서 실수로 지워지지 않도록 수정 불가모드를 켤 수도 있고, 하트 아이콘을 눌러 카테고리를 설정하거나 Always On을 설정할 수 도 있다.  
배경색상이나 폰트, 글씨크기 등은 카테고리별로 설정 가능하다.

[Launchpad](https://launchpad.net/indicator-stickynotes/)[^98]

[Github](https://github.com/umangv/indicator-stickynotes)[^99]

[^98]: https://launchpad.net/indicator-stickynotes/
[^99]: https://github.com/umangv/indicator-stickynotes