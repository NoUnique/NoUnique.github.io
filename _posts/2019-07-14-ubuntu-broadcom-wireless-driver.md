---
title: "Dev: 우분투 18.04 - Broadcom 무선랜 드라이버 설치하기"
categories:
  - Development
tags:
  - Dev
---

Ubuntu 개발환경을 쓰다 유일하게 Windows가 그리워지는 순간이 있다. 바로 새 시스템 세팅 후 드라이버를 잡아주는 순간.  
우분투에서 자동으로 설치되지 않는 Broadcom BCM4360 Wireless LAN driver를 설치해보자.

<!--more-->

윈도우는 대부분의 드라이버를 자동으로 잡아주지만, 우분투는 자동으로 드라이버를 설치해주는 매우 대중적인 장치들 외에는 수동으로 설치하거나, 서드파티 드라이버를 찾거나, 더 심각한 경우에는 직접 코드를 수정하여 빌드 후 설치해야 할 수도 있다.

다행히 내 워크스테이션의 X99칩셋 마더보드는 비교적 대중적인 Broadcomm의 802.11ac 무선랜 칩셋을 사용하고 있다.  

검색을 통해 접근할 수 있는 많은 사이트들에서는 다음과 같이 HWE(Hardware Enablement)커널 설치를 통한 랜카드 드라이버 인식을 권장하고 있는데,  

```bash
$ sudo apt-get install --install-recommends linux-generic-hwe-18.04
```
이 방법은 업데이트 보장기간(6개월간)도 제한되어있고 본인의 장치를 지원하지 않는 경우도 있어 다른 방법을 사용해본다.


<br>
나는 ASUS ROG Rampage V Edition 10 메인보드를 사용중인데, 사용설명서나 온라인 Specification을 보더라도 무선랜 802.11ac 지원 여부만 표기되어있을 뿐, 어떤 제조사의 무선랜 어뎁터가 사용되었는지 알 수 없었다.

우선 lspci를 통해 PCI장치들의 정보를 확인한다.  
여러 장치들이 출력되지만 이중에서 확인해야 할 것은 다음 정보들이다.


```bash
$ lspci -k

...
Ethernet controller: Intel Corporation I211 Gigabit Network Connection (rev 03)
    Subsystem: ASUSTeK Computer Inc. I211 Gigabit Network Connection
    Kernel driver in use: igb
    Kernel modules: igb
0e:00.0 Network controller: Broadcom Inc. and subsidiaries BCM4360 802.11ac Wireless Network Adapter (rev 03)
    Subsystem: ASUSTeK Computer Inc. BCM4360 802.11ac Wireless Network Adapter
    Kernel driver in use:
    Kernel modules: bcma
...

```

Intel의 I211 Gigabit Network Connection은 유선랜 디바이스다. 커널모듈과 드라이버도 igb로 자동으로 잡혀 잘 동작하는 것을 확인할 수 있다.

스펙시트에 적혀있지 않았던 랜 어댑터는 브로드컴의 BCM4360으로 밝혀졌다.  
하지만 랜 어댑터는 드라이버가 제대로 잡혀있지 않다. 이걸 바로잡아주면 정상적으로 Wi-fi를 통한 연결이 가능하다.

<br>
이제 우분투 18.04에 맞는 BCM4360 드라이버를 설치해주면 되는데 브로드컴 Wireless 어댑터 드라이버를 설치하는 방법은 매우 다양하다.[^1]

[^1]: https://help.ubuntu.com/community/WifiDocs/Driver/bcm43xx

크게 네가지 방법으로 나눠보자면, 
1. 제조사 홈페이지를 통한 설치(빌드 필요, 버전업 때마다 반복)
2. 제조사에서 배포하는 커널소스 패키지를 modprobe에 등록하여 사용
3. **DKMS(Dynamic Kernel Module Support)를 이용하는 방법**
4. OpenSource 드라이버(b43) 설치

![broadcom-sta](/assets/images/2019-07-14-ubuntu-broadcom-wireless-driver_001.png)
(제조사 홈페이지에서 제공하는 broadcom-sta source파일. 직접 빌드해야한다.)

다른 귀찮은 방법들을 모두 차치하고, 제조사가 제공하는 안정적인 드라이버(broadcom-sta)를 설치과정이 쉽고 유지보수가 편한 방식(DKMS)으로 설치하고자 한다.

**DKMS**는 모듈 소스파일을 가지고있다가 커널 최초 부팅 시 컴파일하여 자동 적재하는 방식으로, 첫 부팅때에는 빌드시간이 소요로 인해 부팅이 느리다는 단점이 있지만, 한번 빌드 후에는 자동으로 적재를 해 주고 커널 업데이트때마다 따로 컴파일 할 필요 없이 자동으로 컴파일과 적재를 해 준다는 장점이 있다.

설치는 매우 간단하다. 단 한 줄만 입력하면 완료된다.

```bash
$ sudo apt install broadcom-sta-dkms
```

<br>
설치가 완료되면 드라이버가 정상적으로 설치되었는 지 확인해볼 수 있다.

```bash
$ lspci -k

...
0e:00.0 Network controller: Broadcom Inc. and subsidiaries BCM4360 802.11ac Wireless Network Adapter (rev 03)
    Subsystem: ASUSTeK Computer Inc. BCM4360 802.11ac Wireless Network Adapter
    Kernel driver in use: wl
    Kernel modules: bcma, wl
...

```

커널 드라이버가 wl(wireless) 모듈에서 정상적으로 사용중이며, 연결가능한 와이파이 목록도 확인할 수 있다.

![wl-module](/assets/images/2019-07-14-ubuntu-broadcom-wireless-driver_002.png)