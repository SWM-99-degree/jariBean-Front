## 자리:Bean - 카페 자리 예약 및 매칭 서비스


![image](https://github.com/SWM-99-degree/jariBean-Front/assets/57629885/79d41475-ae8c-48e0-b5ae-b84029514d53)

### 프로젝트 소개
 자리:Bean은 고객에게 카페의 자리 예약 서비스와 매칭 서비스를 제공합니다. 예약 서비스를 통해서 원하는 시간대에 자리를 예약하여 자리가 없는 상황을 방지할 수 있습니다. 카페 매칭 서비스를 통해서 현재 주변에 자리가 있는 카페와 매칭되어 즉시 사용할 수 있습니다. 자리:Bean과 즐거운 카페 생활을 즐겨보세요!

### 배포

- [Google Play](https://play.google.com/store/apps/details?id=com.jari_bean.app) 
- [App Store](https://apps.apple.com/kr/app/%EC%9E%90%EB%A6%AC-bean/id6471389388?l=ko-KR)

## 개발 환경

- Flutter : v3.13.7
- 이슈 관리, Github, Github Issues
- 협업 : Discord, Notion, Postman
- 와이어프레임 : Figma
- 배포 : Fastlane

## 컨벤션 & 전략

### 커밋 컨벤션 - git hooks

- pre-commit : `.dart`파일들에 오류가 있는지 검사하고, 포맷팅을 한 후 지정된 테스트를 수행한다.
- commit-msg : 커밋 메시지가 정해진 형태로 작성됐는지 검사한다. 앞에 태그를 붙이고, 끝에 이슈 티켓 번호를 붙여야 한다.

<details>
<summary>pre-commit</summary>

```bash
#!/usr/bin/env bash

printf "\e[33;1m%s\e[0m\n" 'Pre-Commit'

# Undo the stash of the files
pop_stash_files () {
    if [ -n "$hasChanges" ]; then
        printf "\e[33;1m%s\e[0m\n" '=== Applying git stash changes ==='
        git stash pop
    fi
}

hasChanges=$(git diff)
if [ -n "$hasChanges" ]; then
    printf "\e[33;1m%s\e[0m\n" 'Stashing unstaged changes'
    git stash push --keep-index 
fi

# Stash unstaged files
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter Formatter ==='
for file in $(git diff --cached --name-only | grep -E '.dart$')
do
  printf "\e[33;1m%s\e[0m\n" "Formatting $file : "
  dart format $file
  printf "\e[32;1m%s\e[0m\n\n" "Formatted $file"
done


hasNewFilesFormatted=$(git diff)
if [ -n "$hasNewFilesFormatted" ]; then
    git add .
    printf "\e[33;1m%s\e[0m\n" 'Formmated files added to git stage'
fi
printf "\e[32;1m%s\e[0m\n" 'Finished running Flutter Formatter'
printf '%s\n' "${avar}"

# Flutter Analyzer
for file in $(git diff --cached --name-status | grep -E '^[M|U]{1}.+dart$' | tr '\t\t' '\n' | grep 'dart$')
do
  printf "\e[33;1m%s\e[0m\n" '=== Running Flutter Analyzer ==='
  git show ":$file" | flutter analyze --no-pub --no-current-package "$file"
  if [ $? -ne 0 ]; then
	printf "\e[31;1m%s\e[0m\n" '=== Flutter analyzer error ==='
	pop_stash_files
    exit 1
  fi
done
printf "\e[32;1m%s\e[0m\n" 'Finished running Flutter analyzer'
printf '%s\n' "${avar}"

#flutter analyze
#if [ $? -ne 0 ]; then
#  printf "\e[31;1m%s\e[0m\n" '=== Flutter analyzer error ==='
#  pop_stash_files
#  exit 1
#fi

# Unit tests
# printf "\e[33;1m%s\e[0m\n" '=== Running Unit Tests ==='
# flutter test
# if [ $? -ne 0 ]; then
#   printf "\e[31;1m%s\e[0m\n" '=== Unit tests error ==='
#   pop_stash_files
#   exit 1
# fi
# printf "\e[32;1m%s\e[0m\n" 'Finished running Unit Tests'
# printf '%s\n' "${avar}"

pop_stash_files
```
</details>

<details>
<summary>commit-msg</summary>

```bash
#!/bin/bash

commit_message_file=$1

commit_message=$(cat "$commit_message_file")

commit_message_format="^\[(FEAT|REFACTOR|FIX|RESOURCE|TEST|STYLE|CHORE|RELEASE)\]{1}[[:space:]][[:upper:]]{1}.+[[:space:]]#{1}[[:digit:]]+$"

if ! [[ $commit_message =~ $commit_message_format ]]; then
	echo "[COMMIT-MSG] Invalid commit message format!"
	echo "[COMMIT-MSG] Should have format : [(FEAT|REFACTOR|FIX|RESOURCE|TEST|STYLE)] \${your_commit_message} #\${issue_number}"
	exit 1
fi

echo "[COMMIT-MSG] Format matched!"
```
</details>

### Flutter lints

- `require_trailing_commas` 옵션으로 일정한 코드 형태를 지키며, 품질을 유지. 

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    avoid_print: false
    prefer_const_constructors: false
    require_trailing_commas: true

analyzer:
  exclude:
    - "**/*.g.dart"
    - "lib/common/icons/**"
  errors:
    avoid_print: info
    prefer_const_constructors: info
    require_trailing_commas: warning

```

### 브랜치 전략
- Git-flow 와 Github-flow를 적절히 섞어서 사용하였음.
- main, develop, feature과 hotfix 브랜치로 개발
  - main : 배포된 버전
  - develop : 각 feature들을 종합, 배포되기 직전 상태
  - feature : 각 기능을 구현.
  - hotfix : 배포 이후 발생한 시급히 수정해야 하는 오류 수정,
- Github의 PR기능을 이용해 pull & merge.


## Flutter Dependencies

### Riverpod

- 상태관리를 위해 사용.
- MVVM 패턴을 통해 코드의 책임을 줄임.

### Dio & Retrofit & JsonSerializable

- repository & provider 를 통해 ViewModel 역할 수행.
- Code generation으로 반복되는 코드 사용을 줄임.

### GoRouter

- 페이지 라우팅을 위해 사용.
- 강력한 session 관리를 통해, 유저의 권한에 따라 사용할 수 있는 페이지를 제공.

### Firebase Messaging & Flutter Local Notification
- FCM을 통한 푸쉬알림 받기.
- 서버에 Query한 내용을 유저에게 푸쉬알림의 형태로 제공. 

### SQLite
- 로컬 DB로써 사용.
- 서버에서 응답받은 내용을 저장해, 캐시처럼 사용.

### Flutter Web Auth & Sign in with Apple
- OAuth 로그인 스크린창 제공.
- 서비스 서버로 부터 Code를 받고 해당 Code를 우리의 서버로 전달.

### Skeletons
- UX 증진을 위해 Skeleton Widget 구현

![images](https://private-user-images.githubusercontent.com/57629885/278509504-d5c31b7f-4d04-4acd-888d-00e2112b8f37.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTEzNzgzMTgsIm5iZiI6MTcxMTM3ODAxOCwicGF0aCI6Ii81NzYyOTg4NS8yNzg1MDk1MDQtZDVjMzFiN2YtNGQwNC00YWNkLTg4OGQtMDBlMjExMmI4ZjM3LmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAzMjUlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMzI1VDE0NDY1OFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTExNTQzNTliNGUxZWQ4MTM4OWRlMDAyYzQ5NGRlYzMxYzc4ZDMxY2ZlNTc1MjQzOTY0YmUzNzUxN2I2M2YxNzYmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.drnbrVvvD8U86eF5M5l2MxVh4NlxMRuaoAoGV3LHDls)


## 파일 구조

### 전체

<details>
<summary>전체</summary>

```
├── README.md
├── analysis_options.yaml
├── android
│   ├── build.gradle
│   ├── fastlane
...
├── assets
│   ├── fonts
│   └── images
├── build
│   ├── d1e25e033e83e0237fd5ee906d81ede1.cache.dill.track.dill
│   ├── fbd368e2a27b48d48b73a6c7ceb9446a
│   └── ios
├── ios
│   ├── Flutter
...
│   ├── fastlane
│   └── firebase_app_id_file.json
├── jari_bean.iml
├── lib
│   ├── alert
│   ├── cafe
│   ├── common
│   ├── firebase_options.dart
│   ├── history
│   ├── main.dart
│   ├── matching
│   ├── reservation
│   └── user
├── pubspec.lock
├── pubspec.yaml
├── test
│   └── widget_test.dart
```
  
</details>



### lib 하위

<details>
  <summary>lib</summary>
  
```
lib
├── alert
│   ├── component
│   ├── model
│   ├── provider
│   ├── repository
│   └── screens
├── cafe
...
├── common
│   ├── component
│   ├── config
│   ├── const
│   ├── dio
│   ├── exception
│   ├── firebase
│   ├── icons
│   ├── layout
│   ├── models
│   ├── notification
│   ├── provider
│   ├── repository
│   ├── screens
│   ├── secure_storage
│   ├── style
│   └── utils
├── reservation
├── matching
├── user
├── history
...
```
  
</details>


## 고민들

[혼자]
- [OAuth 구현](https://github.com/SWM-99-degree/jariBean-Front/issues/11)
- [Pagination 구현](https://github.com/SWM-99-degree/jariBean-Front/issues/129)
- [Android & iOS에서의 FCM](https://github.com/SWM-99-degree/jariBean-Front/issues/88)
- [Debouncer로 불필요한 계산 줄이기](https://github.com/SWM-99-degree/jariBean-Front/issues/173)
- [VoC받고 개선하기](https://github.com/SWM-99-degree/jariBean-Front/issues/196)
- [Fastlane을 통한 배포 자동화](https://github.com/SWM-99-degree/jariBean-Front/issues/200)

등의 수많은 고민과 버그, 해결 기록들을 Github issues에 기록, 비슷한 문제를 답습하지 않도록 했다.

[팀원들과]
- [컨트롤러 경로 수정 제안](https://github.com/SWM-99-degree/jariBean/issues/109)
- [API 구조 설계에 대한 토의](https://github.com/SWM-99-degree/jariBean/issues/129)
- [유사한 DTO에 대한 모델링 토의](https://github.com/SWM-99-degree/jariBean/issues/180)

이상과 같은 정답이 없는 문제에 대하여, 팀원들과 건강하고 건전한 토의를 통해 최상의 해결책을 얻을 수 있도록 했다.
