# Tiptap 에디터 설치 가이드

최신 Tiptap 에디터를 사용하기 위해 필요한 패키지를 설치하세요.

## 설치 방법

터미널에서 다음 명령어를 실행하세요:

```bash
cd /Users/tommyjang/ecstel-admin
npm install @tiptap/react @tiptap/starter-kit @tiptap/extension-placeholder @tiptap/extension-link @tiptap/extension-image @tiptap/extension-table @tiptap/extension-table-row @tiptap/extension-table-cell @tiptap/extension-table-header @tiptap/extension-text-align @tiptap/extension-color @tiptap/extension-text-style @tiptap/extension-highlight @tiptap/extension-underline
```

## 설치 후 확인

설치가 완료되면:
1. 개발 서버 재시작: `npm run dev`
2. 어드민 패널에서 "채용공고 관리" 메뉴 클릭
3. "공고 작성" 버튼 클릭하여 새로운 에디터 확인

## 새로운 에디터 기능

### 기본 기능
- ✅ 굵게, 기울임, 밑줄, 취소선
- ✅ 제목 (H1, H2, H3)
- ✅ 순서 있는/없는 목록
- ✅ 인용구
- ✅ 코드 블록

### 고급 기능
- ✅ 텍스트 색상 변경 (12가지 색상 팔레트)
- ✅ 하이라이트 (6가지 색상)
- ✅ 텍스트 정렬 (왼쪽, 가운데, 오른쪽, 양쪽)
- ✅ 링크 삽입
- ✅ 이미지 삽입 (URL 입력)
- ✅ 표 삽입 (3x3 기본)
- ✅ 실행 취소/다시 실행

### UI 개선
- ✅ 현대적인 툴바 디자인
- ✅ 호버 효과
- ✅ 활성 상태 표시
- ✅ 반응형 레이아웃

## 문제 해결

만약 설치 중 오류가 발생하면:
1. `npm cache clean --force` 실행
2. `node_modules` 폴더 삭제
3. `package-lock.json` 삭제
4. `npm install` 실행
5. 위의 Tiptap 패키지 설치 명령어 다시 실행

## Tailwind CSS 설정

Tiptap 에디터가 제대로 작동하려면 Tailwind CSS의 `prose` 클래스가 필요합니다. 
`tailwind.config.js`에 다음이 포함되어 있는지 확인하세요:

```js
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

