---
title: "Dev: 우분투 - SSH 서버 설치하기"
categories:
  - Development
tags:
  - Dev_setting
---

우분투 개발의 기본이 되는 원격접속을 위해 SSH Server를 설치해보자

<!--more-->

우분투 18.04 Desktop 에는 기본적으로 SSH Client가 설치되어있지만 SSH Server는 설치되어있지 않기 때문에 터미널 원격접속을 통해 개발하기 위해서는 별도로 OpenSSH Server를 설치해야 한다.

```bash
$ sudo apt install openssh-server
```

<br>
설치완료 여부를 확인하기 위해서는 which나 wheris를 이용하면 된다.

```bash
$ which sshd

/usr/sbin/sshd
```
```bash
$ whereis sshd

sshd: /usr/sbin/sshd /usr/share/man/man8/sshd.8.gz
```

<br>
기본상태는 보안이 취약한 상태이니 ssh 서버 데몬 기본설정을 변경하자

```bash
$ sudo vi /etc/ssh/sshd_config
```

보안을 위해서 iptables나 ufw (Ubuntu Firewall)를 활성화 해준 뒤 포트제어를 해주고, 외부 접속을 위해서는 포트포워딩을 통해 접속 가능한 포트를 연결해주어야 한다.
(22포트는 Brute-force 공격이 많이 들어오는 포트 중 하나이므로 ID & PW 접속을 허용한 경우에는 22번 포트가 아닌 다른 포트를 통해 접속하는 것이 그나마 보안상 유리하다)


<br>
ufw를 활성화 해주고 22번 포트를 예외처리해서 사용하도록 하자.

```bash
$ sudo ufw enable
$ sudo ufw allow 22
```

<br>
sshd 서비스를 실행하여 사용하면 된다.

```bash
$ sudo service sshd start

(or)

$ sudo systemctl start sshd
```