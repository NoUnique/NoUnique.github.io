---
title: "Dev: 우분투 18.04 한글키보드 세팅하기"
categories:
  - Development
tags:
  - Dev_setting
---

리눅스계열 운영체제에서 항상 문제가 되는 것이 한글과 관련된 문제다.

나는 여러 한글관련 이슈를 피하기 위해 설치 시에는 영어로 설치하고 timezone만 Asia/Seoul로 설정하여 사용하는데, 한글입력을 위해서는 별도의 설정 과정이 필수적이다.

<!--more-->

우분투의 여러 LTS배포판을 거쳐보며 (12.04, 14.04, 16.04) 여러 한글입력기를 사용해보았지만 내가 사용하는 여러 개발환경에서 모두 제대로 동작하도록 하는 데에는 지난한 시행착오의 과정을 거쳐야 했었다.  
그 중 가장 난감한 것이 Google Chrome과 SublimeText3 호환문제였는데, 기존에 잘 사용하던 nabi, uim, fcitx의 경우에는 세팅이 복잡하거나, 입력속도가 느리거나, 첫 입력 반응이 느리거나 하는 등의 문제가 있었다.

그래서 18.04에서는 훨씬 깔끔하고 UI적으로도 도드라지지 않는 점이 장점인 ibus로 회귀하려 한다.  
자세한 설명은 추후 업데이트 예정.

[참고 사이트: Gabii 블로그](https://gabii.tistory.com/entry/Ubuntu-1804-LTS-%ED%95%9C%EA%B8%80-%EC%84%A4%EC%B9%98-%EB%B0%8F-%EC%84%A4%EC%A0%95)[^1]

[^1]: https://gabii.tistory.com/entry/Ubuntu-1804-LTS-%ED%95%9C%EA%B8%80-%EC%84%A4%EC%B9%98-%EB%B0%8F-%EC%84%A4%EC%A0%95
