# Git 배포 가이드

## GitHub 리포지토리 생성

1. https://github.com 접속
2. 우측 상단 "+" 버튼 클릭 → "New repository"
3. Repository name: `hometest-admin`
4. Description: "ECSTEL 관리자 페이지"
5. Public 또는 Private 선택
6. **"Initialize this repository with a README" 체크 해제** (이미 파일이 있으므로)
7. "Create repository" 클릭

## Git 원격 저장소 연결 및 푸시

터미널에서 실행:

```bash
cd /Users/tommyjang/ecstel-admin

# 원격 저장소 추가 (GitHub 사용자명: nicewoosik)
git remote add origin https://github.com/nicewoosik/hometest-admin.git

# 메인 브랜치로 푸시
git branch -M main
git push -u origin main
```

## Vercel 배포 (선택사항)

1. https://vercel.com 접속
2. "Add New Project" 클릭
3. GitHub에서 `hometest-admin` 리포지토리 선택
4. Framework Preset: Vite 선택
5. Root Directory: `./` (기본값)
6. Build Command: `npm run build`
7. Output Directory: `dist`
8. Environment Variables 추가:
   - `VITE_SUPABASE_URL`: Supabase 프로젝트 URL
   - `VITE_SUPABASE_ANON_KEY`: Supabase Publishable key
9. "Deploy" 클릭

