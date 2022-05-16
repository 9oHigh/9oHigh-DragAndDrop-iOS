# Drag And Drop 구현 및 테스트

## Draft - Fixed ( Frame )

### 체크리스트

- 모듈
  - [x] 모듈 커스텀

- 캔버스 
  - [x] 30 * 12 격자 사이즈
  - [x] 모듈별 사이즈 대응
  - [x] setLocation, clearLocation 구현 : Copy는 가능, Move의 경우 기존의 자리를 지워야함

- 메뉴바
  - [x] 펼쳐져있을 때, ON ( 드래그 가능 )
  - [x] 접혀있을 때, OFF ( 드래그 불가능 )
  - [ ] 캔버스에 추가 가능 여부 확인 및 알림 

- 드래그 앤 드랍
  - [x] 드랍시 적용가능 여부 파악 : 캔버스 공간 확인 ( 상단의 추가 가능 여부 확인 및 알림과 동일 )
  - [x] 쉐도우 효과
  - [x] 기존의 모듈 이동시 해당자리 바로 지우기
    - [x] 만약 이동불가능한 자리라면 취소 및 다시 해당 자리 채우기
    - [x] 만약 이동이 가능하다면 기존의 자리 지우고 해당 자리 채우기
    - [x] 프리뷰 단계까지만 진입시 제거 불가능 이슈 
        - ModuleViewController의 sessionWillBegin을 활용해 적용
  - [x] 상단 및 좌측으로 드래그시에 쉐도우 지우기 : 드래그 불가능, 드롭으로 해결
  - [x] 트러블 슈팅
     - 기존의 테이블뷰의 Drag delegate가 아닌 Cell에 Drag delegate 적용함으로써 해당 오류 제거 가능
     - 링크 : [CLIENT APP ERROR - Neither the view or container of the UITargetedPreview is currently in a window](https://stackoverflow.com/questions/61829440/client-app-error-neither-the-view-or-container-of-the-uitargetedpreview-is-cur)
  - [ ] 쉐도우 자연스럽게 만들어보기

<br></br>

## Draft - Flexible ( CollectionView )

### 체크리스트

- 드래그 앤 드랍
  - [ ] 드랍시 적용 가능 여부 파악
    - [ ] CollectionView Cell의 Drop Delegate를 이용
    - [ ] CollectionView 전체 셀에 해당하는 배열(Bool) 생성 - 사용할 수 없는 셀 파악 + 쉐도우 빨간색으로 표시

  - [ ] 쉐도우 효과 가능 여부 파악
    - [ ] Session의 Location에 해당하는 위치를 (0,0)으로 잡고 사이즈(Frame) 만큼 쉐도우 효과 
    - [ ] sessionDidUpdate가 호출 될 때마다 쉐도우 효과 + 가능여부 파악

