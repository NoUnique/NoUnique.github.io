---
title: "Dev: 우분투 18.04 - 마우스 측면버튼 설정하기"
categories:
  - Development
tags:
  - Dev_setting
---

우분투 기본 설정에서 마우스 측면버튼이 정상동작 하지 않는 경우에 대한 설정방법을 적어본다.

<!--more-->

내가 사용중인 마우스(Glorious Model O)와 환경(xrdp)에서 마우스 측면버튼이 의도한 바 대로 동작하지 않는 문제가 있다.
<br>
(좌측면 두 측면버튼이 각각 `앞으로`, `뒤로`로 동작해야 하나, `사이드스크롤`로 동작한다)

윈도우와 동일 사용경험을 가지기 위해서는 마우스 측면버튼 동작을 강제로 수정해야 한다.

윈도우 상의 웹 브라우저에서 마우스 측면버튼들은 각각 `Alt + →`(앞으로), `Alt + ←`(뒤로)에 해당하므로
각 버튼에 해당 키 down/up 이벤트를 할당하면 원하는 대로 동작할 것이다.

마우스 이벤트를 통해 버튼 번호를 확인하려면 xev가 필요하다.
<br>
우분투 18.04에는 기본적으로 설치되어 있으나, 만약 없다면 x11-utils를 설치하면 된다.
```bash
$ sudo apt install x11-utils
```

<br>
xev를 통해 측면버튼의 번호를 확인한다.
```bash
$ xev
```

```
ButtonRelease event, serial 37, synthetic NO, window 0x4000001,
    root 0x29a, subw 0x0, time 3418308, (117,65), root:(212,638),
    state 0x0, button 7, same_screen YES

ButtonPress event, serial 37, synthetic NO, window 0x4000001,
    root 0x29a, subw 0x0, time 3418467, (117,65), root:(212,638),
    state 0x0, button 6, same_screen YES
```

<br>
매핑을 위해 xte가 필요하므로 xte를 포함하는 xautomation을 설치한다.
```bash
$ sudo apt install xautomation
```

<br>
`.xbindkeysrc`파일을 생성하여 키 이벤트를 각 버튼에 할당한다.
```bash
$ vi ~/.xbindkeysrc
```

{% highlight bash linenos %}
"xte 'keydown Alt_L' 'keydown Left' 'keyup Left' 'keyup Alt_L'"
    b:6

"xte 'keydown Alt_L' 'keydown Right' 'keyup Right' 'keyup Alt_L'"
    b:7
{% endhighlight %}

<br>
설정 적용을 위해 xbindkeys 프로세스를 종료 후 재실행한다.
```bash
$ killall xbindkeys

$ xbindkeys
```

<br>
행여나 설정파일의 위치를 인식하지 못하면 설정파일 위치를 지정해주면 된다.
```bash
$ killall xbindkeys

$ xbindkeys -f ~/.xbindkeysrc
```

--- 19.10.21 추가내용 ---

내 원격환경에서  버튼을 눌렀을 때 두 번 눌린 것처럼 인식되는 문제가 있어 스크립트를 수정했다.
<br>
(한번 눌렀음에도 press -> release -> press -> release 이벤트 발생)

파일 생성/삭제와 존재여부 체크를 변수 토글처럼 이용해서 0.5초 내에 버튼이 두번 눌릴 경우 앞으로/뒤로 가기 기능이 동작하도록 수정하였다.
(방향키의 keydown -> keyup도 key 하나로 수정)

{% highlight bash linenos %}
"if ls ~/.xbk_double_m6; then xte 'keydown Alt_L' 'key Left' 'keyup Alt_L'; else touch ~/.xbk_double_m6; sleep .5; rm ~/.xbk_double_m6; fi"
    b:6 

"if ls ~/.xbk_double_m7; then xte 'keydown Alt_L' 'key Right' 'keyup Alt_L'; else touch ~/.xbk_double_m7; sleep .5; rm ~/.xbk_double_m7; fi"
    b:7
{% endhighlight %}
