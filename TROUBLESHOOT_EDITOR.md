# 에디터 문제 해결 가이드

## 문제 진단

에디터가 정상 동작하지 않을 때 확인할 사항:

### 1. 브라우저 콘솔 확인

브라우저 개발자 도구(F12) → Console 탭에서 다음을 확인:
- 에러 메시지가 있는지 확인
- "Cannot find module" 에러가 있는지 확인
- "useEditor is not a function" 같은 에러가 있는지 확인

### 2. 패키지 설치 확인

터미널에서 확인:
```bash
cd /Users/tommyjang/ecstel-admin
npm list @tiptap/react
```

모든 Tiptap 패키지가 설치되어 있는지 확인:
```bash
npm list | grep tiptap
```

### 3. 개발 서버 재시작

패키지를 설치한 후 개발 서버를 재시작:
```bash
npm run dev
```

## 일반적인 문제 해결

### 문제 1: "Cannot find module '@tiptap/react'"

**해결 방법:**
```bash
npm install @tiptap/react @tiptap/starter-kit @tiptap/extension-placeholder @tiptap/extension-link @tiptap/extension-image @tiptap/extension-table @tiptap/extension-table-row @tiptap/extension-table-cell @tiptap/extension-table-header @tiptap/extension-text-align @tiptap/extension-color @tiptap/extension-text-style @tiptap/extension-highlight @tiptap/extension-underline
```

### 문제 2: 에디터가 표시되지 않음

**해결 방법:**
1. 브라우저 콘솔에서 에러 확인
2. `node_modules` 삭제 후 재설치:
```bash
rm -rf node_modules package-lock.json
npm install
npm install @tiptap/react @tiptap/starter-kit @tiptap/extension-placeholder @tiptap/extension-link @tiptap/extension-image @tiptap/extension-table @tiptap/extension-table-row @tiptap/extension-table-cell @tiptap/extension-table-header @tiptap/extension-text-align @tiptap/extension-color @tiptap/extension-text-style @tiptap/extension-highlight @tiptap/extension-underline
```

### 문제 3: 스타일이 적용되지 않음

**해결 방법:**
1. `editor.css` 파일이 제대로 import되었는지 확인
2. 브라우저 개발자 도구에서 CSS가 로드되었는지 확인

## 대안: ReactQuill로 되돌리기

만약 Tiptap이 계속 문제가 있다면, ReactQuill로 되돌릴 수 있습니다:

1. `JobPostingForm.tsx`에서 `RichTextEditor`를 `ReactQuill`로 교체
2. 기존 ReactQuill 코드 사용

## 디버깅 정보 제공

문제를 해결하기 위해 다음 정보를 제공해주세요:
1. 브라우저 콘솔의 에러 메시지
2. 어떤 동작이 안 되는지 (에디터가 안 보임, 버튼이 안 작동함 등)
3. 개발 서버 콘솔의 에러 메시지

