# Git 배포 문제 해결 가이드

## 일반적인 에러 및 해결 방법

### 1. "fatal: remote origin already exists"
**원인**: 이미 원격 저장소가 설정되어 있음

**해결**:
```bash
# 기존 원격 저장소 제거
git remote remove origin

# 새로 추가
git remote add origin https://github.com/nicewoosik/hometest-admin.git
```

### 2. "error: could not write config file .git/config: Operation not permitted"
**원인**: Git 설정 파일 쓰기 권한 문제

**해결**:
```bash
# 디렉토리 권한 확인
ls -la .git

# 필요시 권한 수정 (신중하게 사용)
sudo chown -R $(whoami) .git
```

### 3. "Permission denied (publickey)" 또는 인증 오류
**원인**: GitHub 인증 문제

**해결 방법 1 - HTTPS 사용**:
```bash
git remote set-url origin https://github.com/nicewoosik/hometest-admin.git
git push -u origin main
```

**해결 방법 2 - Personal Access Token 사용**:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token" 클릭
3. 권한 선택: `repo` 체크
4. 토큰 생성 후 복사
5. 푸시 시 비밀번호 대신 토큰 입력

### 4. "error: src refspec main does not match any"
**원인**: 커밋이 없거나 브랜치가 없음

**해결**:
```bash
# 파일 추가 및 커밋 확인
git status
git add .
git commit -m "Initial commit"

# 브랜치 확인
git branch
```

### 5. "Updates were rejected because the remote contains work"
**원인**: 원격 저장소에 이미 파일이 있음

**해결**:
```bash
# 원격 저장소 내용 가져오기
git pull origin main --allow-unrelated-histories

# 충돌 해결 후 다시 푸시
git push -u origin main
```

## 전체 과정 다시 시도

```bash
cd /Users/tommyjang/ecstel-admin

# 1. Git 상태 확인
git status

# 2. 기존 원격 저장소 제거 (있는 경우)
git remote remove origin 2>/dev/null || true

# 3. 원격 저장소 추가
git remote add origin https://github.com/nicewoosik/hometest-admin.git

# 4. 브랜치 확인 및 변경
git branch -M main

# 5. 푸시
git push -u origin main
```

## GitHub 리포지토리가 이미 있는 경우

만약 GitHub에서 리포지토리를 이미 생성했다면:

```bash
cd /Users/tommyjang/ecstel-admin

# 원격 저장소 연결
git remote add origin https://github.com/nicewoosik/hometest-admin.git

# 원격 저장소 내용 가져오기
git pull origin main --allow-unrelated-histories

# 푸시
git push -u origin main
```


