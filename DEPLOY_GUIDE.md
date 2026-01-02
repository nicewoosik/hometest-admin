# 배포 가이드

## 빌드 완료 ✅

관리자 페이지가 성공적으로 빌드되었습니다:
- `dist/index.html`
- `dist/assets/index-BwEhy0S7.css`
- `dist/assets/index-DK16Grek.js`

## 배포 방법

### 방법 1: Vercel 자동 배포 (권장)

이미 `vercel.json` 파일이 있으므로 Git에 푸시하면 자동으로 배포됩니다:

```bash
# 변경사항 커밋
git add .
git commit -m "Fix TypeScript errors and build for production"

# Git에 푸시 (Vercel이 자동으로 배포)
git push
```

### 방법 2: Vercel CLI로 배포

```bash
# Vercel CLI 설치 (없는 경우)
npm i -g vercel

# 배포
cd /Users/tommyjang/ecstel-admin
vercel --prod
```

### 방법 3: Vercel Dashboard에서 배포

1. [Vercel Dashboard](https://vercel.com/dashboard) 접속
2. 프로젝트 선택
3. "Deployments" 탭에서 "Redeploy" 클릭
4. 또는 Git 저장소 연결 후 자동 배포

## 환경 변수 확인

배포 전에 Vercel 프로젝트 설정에서 환경 변수가 설정되어 있는지 확인:

- `VITE_SUPABASE_URL`: `https://qzymoraaukwicqlhjbsy.supabase.co`
- `VITE_SUPABASE_ANON_KEY`: `sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr`

**Vercel Dashboard → Settings → Environment Variables**에서 확인하세요.

## 배포 후 확인 사항

1. ✅ 관리자 페이지 접속 확인
2. ✅ 로그인 기능 테스트
3. ✅ 간편문의 목록 조회 테스트
4. ✅ 문의 상태 변경 테스트

## 홈페이지 코드 배포

홈페이지 코드 수정사항(`HOMEPAGE_FIXED_CODE.js`)을 홈페이지에 적용해야 합니다:

1. 홈페이지 소스 코드에 `HOMEPAGE_FIXED_CODE.js` 내용 적용
2. 또는 `HOMEPAGE_CODE_FIX.md` 가이드 참고하여 수정
3. 홈페이지 배포

## 문제 해결

배포 후 문제가 발생하면:

1. **환경 변수 확인**: Vercel Dashboard에서 환경 변수가 올바르게 설정되었는지 확인
2. **빌드 로그 확인**: Vercel Dashboard → Deployments → Build Logs 확인
3. **콘솔 오류 확인**: 브라우저 개발자 도구에서 오류 확인

