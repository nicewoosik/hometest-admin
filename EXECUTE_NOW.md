# 데이터베이스 스키마 업데이트 및 데이터 입력

## 즉시 실행할 SQL

**`APPLY_SCHEMA_AND_DATA.sql` 파일을 Supabase Dashboard → SQL Editor에서 실행하세요.**

이 스크립트는:
1. ✅ 필요한 모든 컬럼을 안전하게 추가 (IF NOT EXISTS 사용)
2. ✅ 현재 홈페이지에 있는 8개의 채용공고 데이터를 입력
3. ✅ 테이블 구조와 데이터 확인

## 실행 방법

1. Supabase Dashboard 열기
2. SQL Editor 클릭
3. `APPLY_SCHEMA_AND_DATA.sql` 파일의 전체 내용 복사
4. SQL Editor에 붙여넣기
5. "Run" 버튼 클릭

## 실행 후 확인

1. 어드민 패널 → 채용공고 관리 메뉴 클릭
2. 8개의 채용공고가 목록에 표시되는지 확인
3. 각 항목 클릭하여 상세 내용 확인
4. 수정/삭제 기능 테스트

## 문제 해결

만약 에러가 발생하면:
- "column already exists" 에러는 무시해도 됩니다 (이미 컬럼이 존재한다는 의미)
- "duplicate key" 에러는 무시해도 됩니다 (이미 데이터가 존재한다는 의미)
- 다른 에러가 발생하면 에러 메시지를 확인하세요
