# react-quill 설치 가이드

채용공고 관리 페이지의 에디터 기능을 사용하려면 `react-quill` 패키지를 설치해야 합니다.

## 설치 방법

터미널에서 다음 명령어를 실행하세요:

```bash
cd /Users/tommyjang/ecstel-admin
npm install react-quill
```

## 설치 후 확인

설치가 완료되면:
1. 개발 서버 재시작: `npm run dev`
2. 어드민 패널에서 "채용공고 관리" 메뉴 클릭
3. "공고 작성" 버튼 클릭하여 에디터 확인

## 에디터 기능

- 리치 텍스트 에디터 (제목, 굵게, 기울임, 밑줄 등)
- 목록 (순서 있는 목록, 순서 없는 목록)
- 링크 삽입
- 정렬 기능
- HTML 형식으로 저장

## 문제 해결

만약 설치 중 오류가 발생하면:
1. `npm cache clean --force` 실행
2. `node_modules` 폴더 삭제
3. `package-lock.json` 삭제
4. `npm install` 실행
5. `npm install react-quill` 실행

