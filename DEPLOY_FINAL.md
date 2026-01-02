# 최종 배포 가이드

## 현재 상태
✅ 빌드 완료
✅ 커밋 완료
⏳ Git 푸시 필요

## 배포 방법

### 방법 1: Git 푸시 (터미널에서 실행)

터미널에서 다음 명령어를 실행하세요:

```bash
cd /Users/tommyjang/ecstel-admin
git push origin main
```

Vercel이 자동으로 배포를 시작합니다.

### 방법 2: Vercel Dashboard에서 배포

1. [Vercel Dashboard](https://vercel.com/dashboard) 접속
2. 프로젝트 선택
3. "Deployments" 탭에서 "Redeploy" 클릭
4. 또는 Git 저장소가 연결되어 있으면 자동 배포됨

### 방법 3: Vercel CLI로 배포

```bash
# Vercel CLI 설치 (없는 경우)
npm i -g vercel

# 배포
cd /Users/tommyjang/ecstel-admin
vercel --prod
```

## 환경 변수 확인

배포 전에 Vercel 프로젝트 설정에서 환경 변수가 설정되어 있는지 확인:

**Vercel Dashboard → Settings → Environment Variables**

- `VITE_SUPABASE_URL`: `https://qzymoraaukwicqlhjbsy.supabase.co`
- `VITE_SUPABASE_ANON_KEY`: `sb_publishable_9h5TGNNrnzpjvWCu_CYxVg_VuOC7XFr`

## 배포 후 확인 사항

1. ✅ 관리자 페이지 접속 확인
2. ✅ 로그인 기능 테스트
3. ✅ 간편문의 목록 조회 테스트
4. ✅ 문의 상태 변경 테스트

## 홈페이지 코드 배포 (중요!)

관리자 페이지 배포와 별도로, **홈페이지 코드를 수정해야 합니다**:

1. `HOMEPAGE_COMPLETE_CODE.js` 파일 내용 확인
2. 홈페이지 HTML 파일에 코드 적용
3. 홈페이지 배포

자세한 내용은 `HOMEPAGE_APPLY_GUIDE.md` 파일을 참고하세요.

## 완료!

배포가 완료되면:
- 관리자 페이지가 정상 작동하는지 확인
- 홈페이지 코드를 적용하여 RLS 오류 해결

