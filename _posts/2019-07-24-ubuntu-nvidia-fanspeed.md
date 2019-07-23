---
title: "Dev: 우분투 - Nvidia 그래픽카드 팬 속도 조절하기"
categories:
  - Development
tags:
  - Dev_setting
---

Nvidia의 우분투용 드라이버는 윈도우용에 비해 기능이 부족한 편이다.  
그 중 가장 답답한 것이 Fan 속도 조절인데, 기본세팅에서는 큰 발열이 있는 작업에서 발열 해소를 위해 높은 Fan 속도를 강제할 수 있는 옵션이 없다.

<!--more-->

GPGPU연산 간 발생하는 큰 발열을, 소음을 감수하고서라도 해결하기 위해서 이를 강제로 열어주자.

Nvidia 그래픽카드 드라이버는 미리 설치되어 있다고 가정한다.

![nvidia-settings](/assets/images/2019-07-24-ubuntu-nvidia-fanspeed_002.png)

(기본 설치상태에서는 팬 속도 강제조절 옵션이 없다.)

<br>
기본 상태에서는 Xorg config가 없기 때문에 이를 생성해준다.

```bash
$ sudo nvidia-xconfig
```

<br>
Xorg config를 열어 이 중 `Device` section에 다음과 같이 `Option    "Coolbits" "5"`를 추가해 준다.

![xorg.conf](/assets/images/2019-07-24-ubuntu-nvidia-fanspeed_003.png)

<br>
다음과 같이 Fan 속도 강제조절 옵션이 나타난 것을 확인할 수 있다.

```bash
$ sudo nvidia-settings
```

![nvidia-settings2](/assets/images/2019-07-24-ubuntu-nvidia-fanspeed_004.png)

<br>
GPU 부하가 많은 연산 때 FullLoad 시를 기준으로 그보다 좀 더 높은 값을 적용하면 조금 더 낮은 온도를 유지할 수 있다.  
팬에 부하가 가지 않는 선에서 적당히 설정하여 사용하자.
