---
title: "Dev: 멀티부팅 환경에서 블루투스장치 공유하기"
categories:
  - Development
tags:
  - Dev_setting
---

나는 효율적인 자원활용을 위해 OS별로 별도 HW의 개발환경을 구축하기보다 멀티부팅 환경을 설정하는 것을 선호하는 편이다.

주로 Windows와 Ubuntu 듀얼부팅 환경을 세팅하는데, 이런 멀티부팅 환경에서 불편한 점 중 하나는 한 운영체제에 연결된 블루투스 장치를 다른 OS에서 사용할 수 없다는 것이다.  
멀티 페어링 장치의 경우에는 페어링 전환 버튼을 눌러가며 사용할 수 있겠지만, 멀티페어링을 미지원하는 블루투스 장치의 경우나 자주 OS를 바꿔가며 사용하는 개발용 노트북의 경우에는 OS를 바꿀때마다 새로 페어링을 하거나 페어링버튼을 눌러가며 쓰는 것이 귀찮다.

<!--more-->

이미 인터넷에는 듀얼부팅 환경에서 블루투스장치를 공유하는 방법에 대한 글이 많이 있지만, BLE(Bluetooth Low Energy)장치를 공유하는 방법은 조금 다르기에 내가 겪었던 시행착오를 기록으로 남겨보고자 한다.  
자세한 설명은 추후 업데이트 예정.

[참고 사이트](http://console.systems/2014/09/how-to-pair-low-energy-le-bluetooth.html)[^1]

[^1]: http://console.systems/2014/09/how-to-pair-low-energy-le-bluetooth.html
