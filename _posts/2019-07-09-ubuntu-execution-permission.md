---
title: "Dev: 우분투 - 스크립트 바로 실행하기"
categories:
  - Development
tags:
  - Dev
---

쉘의 호출 없이 스크립트를 직접 실행하기 위해서는 스크립트 자체에 실행권한이 있어야 한다.  
간단히 스크립트의 경로를 입력하는 것만으로 스크립트를 실행시켜보자.

<!--more-->

스크립트를 직접 실행시키기 위해서는, 스크립트의 첫 줄에 어떤 인터프리터를 사용할 지 지정해야한다. 

스크립트파일을 열고 첫 줄에 shebang을 추가한다  
(shebang, sha-bang, hashbang, pound-bang, hash-pling 등으로 불림)  

```bash
$ vi compose.sh
```

{% highlight bash linenos %}
#!/bin/bash

echo 'Hello'
{% endhighlight %}

<br>
다음 명령어로 퍼미션을 확인한다.

```bash
$ ls -al

-rw-r--r-x 1 nounique nounique 5214  7월  9 05:04 compose.sh*
```

<br>
chmod 명령어를 통해 실행권한('x')을 추가('+')할 수 있다.

```bash
$ chmod +x compose.sh
```

<br>
추가된 실행권한 확인

```bash
$ ls -al

-rwxr-xr-x 1 nounique nounique 5214  7월  9 05:04 compose.sh*
```

<br>
직접 실행이 가능하다

```bash
$ ./compose.sh

Hello
```
