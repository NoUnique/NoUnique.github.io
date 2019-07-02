---
title: "Dev: 우분투 18.04 - Nvidia 드라이버 설치하기"
categories:
  - Development
tags:
  - Dev_setting
---

CUDA연산을 이용한 작업을 위해서는 Nvidia 드라이버 설치가 필수적이다.

예전 드라이버 설치 때에는 오픈소스 드라이버인 nouveau와의 충돌문제로 더 많은 설정이 필요했지만, 근래의 드라이버에는 자동으로 blacklist에 추가하는 과정이 포함되어있으므로 별다른 설정 없이 드라이버만 설치해주면 된다.

<!--more-->

CUDA 10.0 이상을 사용하기 위해서는 410.48 버전 이상을 설치해 주어야 한다.[^1]  
특별히, Titan Xp와 같은 Tesla 칩셋을 사용한 카드의 경우에는 384.111+ 버전에서도 동작한다.[^2]  

[^1]: https://docs.nvidia.com/deploy/cuda-compatibility/#binary-compatibility
[^2]: https://docs.nvidia.com/deploy/cuda-compatibility/#cuda-application-compatibility

자세한 설명은 추후 업데이트 예정.

[참고 사이트: HiSEON 블로그](https://hiseon.me/linux/ubuntu/install_nvidia_driver/)[^99]

[^99]: https://hiseon.me/linux/ubuntu/install_nvidia_driver/