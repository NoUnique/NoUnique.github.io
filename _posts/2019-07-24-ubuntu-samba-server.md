---
title: "Dev: 우분투 - Samba서버 설치하기"
categories:
  - Development
tags:
  - Dev_setting
---

우분투 파일교환을 위해 Samba Server를 설치해보자

<!--more-->

간단히 apt 커맨드로 설치해준다

```bash
$ sudo apt install samba
```

<br>
Samba 서버 설치 후 사용할 계정을 추가한다.

```bash
$ sudo smbpasswd -a nounique
```

<br>
Samba 설정파일을 열어서 기본설정을 완료해준다.

```bash
$ sudo vi /etc/samba/smb.conf
```

<br>
다른 설정은 잘 나와있는 설명들을 참조하여 설정하고, 나는 필요한 다음 내용만 추가했다.

{% highlight bash linenos %}
[nounique]
   comment = Users profiles
   path = /home/nounique/
   guest ok = no
   read only = no
   browseable = yes 
   create mask = 0644
   directory mask = 0755
{% endhighlight %}

![samba-setting](/assets/images/2019-07-24-ubuntu-samba-server_001.png)


<br>
설정을 완료하면 Samba 서버 서비스를 재시작하여 설정을 적용시켜준다.

```bash
$ sudo service smbd restart
```