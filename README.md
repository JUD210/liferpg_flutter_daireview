# Daily Review 앱

Flutter로 개발된 Daily Review 캘린더 앱입니다. 이 앱은 사용자가 일일 리뷰를 기록하고 관리할 수 있도록 돕기 위해 설계되었습니다.

## 프로젝트 구조
- **main.dart**: 앱 시작 파일로, 기본 설정과 초기화를 담당합니다.
- **lib/utils**: 공통 유틸리티 함수와 도구들을 포함합니다.
- **lib/widgets**: 재사용 가능한 커스텀 위젯들이 위치해 있어, UI의 일관성과 효율성을 높입니다.
- **lib/pages**: 앱의 주요 화면을 정의하며, 홈, 캘린더, 인트로 등의 페이지로 구성됩니다.

## 주요 기능
- **캘린더 모듈**: `aleksanderwozniak/table_calendar` 패키지를 사용해 일일 리뷰 캘린더를 구현했습니다.
- **애니메이션**: 인트로 화면에 페이드 인 및 줌 인 애니메이션을 추가하여 사용자 경험을 강화했습니다.
- **네비게이션**: 여러 페이지 간 이동을 위한 라우터 기능이 포함되어 있습니다.

## 커밋 기록
- **feat**: 기능 추가
- **chore**: 코드 유지보수 및 설정 변경
- **refactor**: 코드 구조 변경 및 모듈화

## 사용 방법
1. 이 프로젝트를 클론합니다.
   ```bash
   git clone <repository_url>
   cd <project_directory>
   ```
2. 의존성 패키지를 설치합니다.
   ```bash
   flutter pub get
   ```
3. 앱을 실행합니다.
   ```bash
   flutter run
   ```

## 요구 사항
- Flutter SDK 설치
- Android Studio 또는 Visual Studio Code 설치

## 참고 자료
- `aleksanderwozniak/table_calendar`: [GitHub Repository](https://github.com/aleksanderwozniak/table_calendar)
