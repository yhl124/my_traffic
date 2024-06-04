## 실시간 교통 정보 ios 앱 만들기
- 목표 : LLM을 사용해 swift를 최대한 공부하지 않고 하라는 대로 코드 복붙해서 완성하기
- 사용된 LLM : chatgpt3.5, 4, 4o, claude3, gemini

### 개발 환경
os : macOs Sonoma 14.4.1
Xcode : 15.4
최소 지원 iOS 버전 : 17.2

### 구현된 부분
1. 메인 화면
   - 구현 내용 : 실시간 정보 표시(api), 왼쪽 스와이프로 저장된 정보 삭제(coredata), 아래로 내리면 새로 고침
   
![image](https://github.com/yhl124/my_traffic/assets/139377233/2e87a5e9-be96-44b2-95b5-409cb4a9d132)

2. 검색 화면
    - 구현 내용 : 검색어 입력 후 엔터 입력 -> 정류장 검색(api) -> 정류장 선택

![image](https://github.com/yhl124/my_traffic/assets/139377233/2b47ae53-838c-440d-96d3-53602666e250)


3. 노선 선택 화면
    - 구현 내용 : 정류장 선택 -> 노선 출력(api) -> 원하는 노선 선택 -> 저장(coredata)
    - 현재 경기도 버스 api만 사용 중이기 때문에 노선이 없는 경우도 있음

![image](https://github.com/yhl124/my_traffic/assets/139377233/e9f38349-b026-4a82-a91d-e84e9d0ac429)


4. 노선 저장 예외
    - 구현 내용 : 아무 노선도 선택하지 않거나 이미 저장된 정류장을 다시 저장하려고 할 때 알림 출력

![image](https://github.com/yhl124/my_traffic/assets/139377233/e85ee941-f83b-427a-a59d-aa12cb4e27fc)

5. 위젯
    - 구현 내용 : coredata에 저장된 노선을 불러와 api를 호출해 현재 정보 표시

![image](https://github.com/yhl124/my_traffic/assets/139377233/5ce7ae88-439f-4b86-b1f6-2699f68ab6be)

## 사용 api
- 경기도_정류소 조회 : 정류소명/번호 목록조회, 정류소경유노선 목록조회   
https://www.data.go.kr/data/15080666/openapi.do
- 경기도_버스도착정보 조회 : 버스도착정보목록조회  
https://www.data.go.kr/data/15080346/openapi.do

## 직접 코드를 분석했던 부분
- CoreData를 앱과 위젯에서 모두 접근 가능하게 하기 위한 앱 그룹 설정
- 위젯에서 api를 사용해 비동기적으로 출력이 안되던 부분 -> 코드를 부분부분 주석처리 하며 안되는 부분 찾아 질문

## 느낀점
- 체감상 코딩에 chatgpt4, 4o가 적절하다
- gemini는 원하는 답이 안나오고 생략해서 답변하는 경우가 많아 몇번 쓰다가 안쓰게됨
- 문법적으로 에러가 없는데 원하는 결과가 안나오는 경우 모르는 분야라서 설명하기 어렵고 그러다 보니 좋은 답을 구하기도 어렵다

## 앞으로 추가해야 될 부분(희망사항)
1. 위젯 새로고침 버튼 추가
2. 서울 교통 공사 지하철 실시간 정보 출력 기능
3. 코레일 지하철 실시간 정보 출력 기능
4. 서울 버스 실시간 정보 출력 기능
5. 앱, 위젯 설정 기능
   - 위젯 표시 정보 선택
   - 시간별 표시 정보 선택







