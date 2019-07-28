---
title: "Dev: 우분투 18.04 - 원격제어 설정하기(VNC)"
categories:
  - Development
tags:
  - Dev_setting
---

외부나 윈도우 PC, 모바일에서 우분투 워크스테이션에서 하던 작업을 이어 하기 위해 우분투 서버에 원격제어 환경을 설정해보자.

<!--more-->

내가 필요한 원격제어 환경의 조건은 다음과 같다.

1. 우분투 데스크톱과 동일한 테마를 가져야 한다.
2. 별도 데스크톱을 생성하지 않고 동일 데스크톱을 보여줘야 한다.
3. (optional) 웹브라우저에서 접근이 가능해야 한다.

<br>
1번 조건은 심미적 이유(디자인적 통일성)에서 원하는 기능이고  
2번 조건은 작업의 일관성 때문에 필요하며  
3번 조건은 편의성을 위해 추가적으로 필요한 조건이다.

특히 2번 조건은 윈도우의 '원격 데스크톱 연결' 같은 사용성을 갖고싶기 때문에 필요한 조건인데,  
매번 별도 세션을 생성하는 대신, 작업하던 세션에 어디서든 로그인할 수 있어야 흐름을 끊지 않고 작업을 이어 할 수 있기 때문이다.

원격 데스크톱 환경 구축에는 VNC(Virtual Network Computing)와 RDP(Remote Desktop Protocol)의 두 가지 방법이 있다.  
우선 VNC로 원격 데스크톱 환경을 구축하는 방법부터 정리해본다.

<br>
VNC server에는 많은 구현체가 있는데, 그 중 vino는 GNOME 데스크톱을 위한 VNC 서버다.  
우분투 18.04에서는 기존의 Unity 를 버리고 GNOME 으로 회귀하였으며, 
vino를 설치할 경우 우분투 설정에서 Sharing에 Screen Sharing옵션이 생기고, 이를 활성화 하는 것 만으로 손쉽게 설정이 가능하므로 vino를 사용하자.

vino를 설치해준다.

```bash
$ sudo apt install vino
```

vino의 설치가 완료되면 우분투 Setting > Sharing에서 Screen Sharing 옵션이 활성화되는 것을 확인할 수 있다.  

![vnc1](/assets/images/2019-07-28-ubuntu-remote-desktop-vnc_001.png)

Screen Sharing 옵션을 눌러 `Active`로 바꿔주고  
외부에서의 접근을 위하여 다음과 같이 비번을 통하여 접근할 수 있도록 설정하자.

![vnc2](/assets/images/2019-07-28-ubuntu-remote-desktop-vnc_002.png)

실제 사용을 위해서는 몇가지 설정을 더 해주어야하는데 설정을 위하여 dconf-editor를 사용한다.  
설치되어있지 않다면 설치해주자.

```bash
$ sudo apt install dconf-editor
```

dconf-editor에서 /org/gnome/desktop/remote-access 에 접근하여 설정을 바꿔주자.

윈도우에서 VNC viewer를 사용한 접근과 noVNC를 이용하여 웹브라우저에서 접근하기위해서는 데이터 암호화 설정을 해제해야한다.  
(물론 해제하지 않고 SSL certification 설정을 통해 사용할 수 있지만, 과정이 복잡하기 때문에 나는 그냥 암호화 설정을 해제하여 사용한다)

![vnc3](/assets/images/2019-07-28-ubuntu-remote-desktop-vnc_003.png)

Setting > Sharing의 Screen Sharing 옵션을 통해 암호를 설정하면 설정 가능한 암호의 길이가 제한되어 있는데, dconf-editor를 이용하여 이 제한을 강제로 풀고 사용할 수 있다.

사용할 암호를 base64로 변환하여 'vnc-password'에 입력해주면 된다.  
우선 암호를 base64로 변환하자.

```bash
$ echo -n "PASSWORD"|base64

BASE64_ENCODED_PASSWORD
```
여기서 echo의 '-n' 옵션은 라인 끝의 `newline`을 제외시키는 옵션이다.  
출력된 패스워드를 vnc-password에 입력하면 정해진 길이(8 bytes)보다 긴 암호를 사용할 수 있다.


위의 과정은 gsettings로 설정할 수도 있다.

```bash
$ gsettings set org.gnome.Vino enabled true
$ gsettings set org.gnome.Vino require-encryption false
$ gsettings set org.gnome.Vino vnc-password $(echo -n "PASSWORD"|base64)
```

noVNC 서버를 통해 웹브라우저로 VNC 원격 데스크톱에 접속하는 방법은 별도의 글에 기술하도록 하겠다.
