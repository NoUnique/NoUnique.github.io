---
title: "Dev: GIT 스크립트 실행권한 설정하기"
categories:
  - Development
tags:
  - Dev
---

스크립트 자체에 실행권한을 주더라도 git clone/pull을 통해 다운로드한 코드에는 권한이 없는 경우가 있다.  
여러 PC에서 코드를 실행시키는 경우 스크립트 바로실행이 불가능해서 귀찮아지는 경우가 있는데, 간단한 git 설정으로 이를 해결해보자.

<!--more-->

git에 권한이 변경된 파일을 적용하기 위해서는 git 파일권한 변경 추적기능이 켜져있어야 한다.  
혹시 꺼져있다면 켜주도록 하자.
```bash
$ git config core.fileMode

false
```

```bash
$ git config core.fileMode true
```
<br/>


파일권한 변경 추적이 켜져있다면 파일 권한 변경만으로도 적용이 가능하다.

```bash
$ chmod +x compose.sh
```
<br/>


혹시나 위의 방법으로 적용이 안될 경우에는 강제로 git index를 업데이트시켜주어야 한다.


다음 명령어로 퍼미션을 확인한다.

```bash
$ git ls-tree HEAD

100644 blob 6dc27becc23538923880dccca4314f54c4df60cc    compose.sh
```
<br/>

실행권한을 추가해준다

```bash
$ git update-index --chmod=+x compose.sh
```
<br/>

완료

```bash
$ git ls-tree HEAD

100755 blob 6dc27becc23538923880dccca4314f54c4df60cc    compose.sh

$ ls -al

-rwxr-xr-x 1 nounique nounique 5214  7월  9 05:04 compose.sh*
```
