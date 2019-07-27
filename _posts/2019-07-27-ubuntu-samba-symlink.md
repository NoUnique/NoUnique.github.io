---
title: "Dev: 우분투 - Samba 서버 심볼릭 링크 접근하기"
categories:
  - Development
tags:
  - Dev_setting
---

우분투 Samba 서버 내의 Symbolic link에 접근가능하도록 설정해보자

<!--more-->

Samba 설정파일을 열고 global 섹션에 다음과 같은 세 라인을 추가해준다.
(global 섹션에 추가해야만 적용이 된다.)

```bash
$ sudo vi /etc/samba/smb.conf
```

{% highlight bash linenos %}
[global]
    follow symlinks = yes
    wide links = yes
    unix extensions = no
{% endhighlight %}

<br>
설정을 완료하면 Samba 서버 서비스를 재시작하여 설정을 적용시켜준다.

```bash
$ sudo service smbd restart
```

<br>
Samba 서버의 Symbolic link 설정이 적용되어 Symbollic link 폴더에 접근할 수 있는 것을 확인할 수 있다.

![samba-symlink](/assets/images/2019-07-27-ubuntu-samba-symlink_001.png)
