---
title: "Dev: 멀티부팅 환경에서 fakeRAID 공유하기"
categories:
  - Development
tags:
  - Dev_setting
---

나는 효율적인 자원활용을 위해 OS별로 별도 HW의 개발환경을 구축하기보다 멀티부팅 환경을 설정하는 것을 선호하는 편이다.

Windows와 Ubuntu 듀얼부팅 환경에서 24TB (RAID 0: 8TB x 3) RAID를 공유하기 위한 삽질기를 올려본다.

<!--more-->

RAID 구현 방식에 따라 3가지로 구분된다.

1. hardware RAID: RAID카드 등의 별도 하드웨어를 통한 RAID
2. software RAID: Windows, Ubuntu등의 OS단에서 구성되는 RAID
3. bios RAID(fakeRAID): 바이오스 칩셋에서 지원하는 RAID


나는 RAID 카드가 없고 software RAID는 OS간 공유가 안되기 때문에 fakeRAID (bios RAID)를 이용했다.  
(software RAID의 RAID array를 양 OS에서 인식시킨다 하더라도, 행여나 RAID가 깨졌을 때 복구과정이 복잡하기 때문에 software RAID는 고려하지 않았다)

우분투에서 RAID Array를 인식시키기 위한 툴로 dmraid와 mdadm가 널리 쓰이고 있다.  
인터넷에는 dmraid는 software RAID와 fakeRAID를 지원하고, mdadm은 software RAID만 지원한다고 되어있는 글도 있지만, 사실 mdadm도 fakeRAID를 지원한다.

dmraid의 경우 대용량 isw(Intel Software RAID)인식에 [버그](https://askubuntu.com/questions/113561/how-to-modify-fix-incorrectly-detected-dmraid-fakeraid-raid-10-array)가 있기 때문에 논외로 한다.  
(나도 24TB/21.83TiB로 인식되지 않고 3.83TiB로 인식되는 동일한 버그를 겪었다.)


<br>
우선 mdadm을 설치한다.

```bash
$ sudo apt install mdadm
```

<br>
스캔하고 assemble한다.

```bash
$ sudo mdadm --assemble --scan

mdadm: Container /dev/md/imsm0 has been assembled with 3 drives
mdadm: Started /dev/md/Volume1_0 with 3 devices
```
여기서 '/dev/md/Volume1_0'이 볼륨명이다.


<br>
설정 내역을 확인한다

```bash
$ sudo mdadm --detail --scan

ARRAY /dev/md/imsm0 metadata=imsm UUID=cf8dcd99:e186a5e1:abe671a1:67a29326
ARRAY /dev/md/Volume1_0 container=/dev/md/imsm0 member=0 UUID=02595f12:57112ef4:e53a3320:09bf0e31
```

<br>
정상적으로 수행되었다면 다음과 같은 결과를 확인할 수 있다.

![mdadm_cmd](/assets/images/2019-07-09-multiboot-sharing-fakeraid_001.png)

<br>
Gparted에서 볼륨을 포맷하고 마운트시켜 사용하면 된다.

![mdadm_gparted](/assets/images/2019-07-09-multiboot-sharing-fakeraid_002.png)
