# 기존 채용공고 데이터 가져오기 가이드

현재 홈페이지에 있는 채용공고 리스트를 데이터베이스에 넣는 방법입니다.

## 방법 1: Supabase Dashboard에서 직접 입력

1. Supabase Dashboard → Table Editor → `job_postings` 테이블 클릭
2. "Insert" 버튼 클릭
3. 각 필드에 데이터 입력:
   - `title`: 채용공고 제목
   - `status`: "open" (접수중) 또는 "closed" (마감)
   - `target_audience`: 지원대상 (예: "경력 3년 이상")
   - `deadline`: 접수기한 (날짜 형식)
   - `department`: 모집부문
   - `location`: 지역
   - `position_level`: 직급
   - 기타 필드들...

## 방법 2: SQL로 일괄 입력

Supabase Dashboard → SQL Editor에서 다음 SQL을 실행하세요:

```sql
-- 예시: SaaS/CCaaS Pre-Sales 경력직 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  work_experience,
  main_duties,
  job_description_en,
  required_qualifications,
  preferred_qualifications,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline
) VALUES (
  'SaaS/CCaaS Pre-Sales 경력직 채용',
  'open',
  'Pre-Sales',
  '경력 3년 이상',
  'Pre-Sales',
  '서울',
  '과장',
  1,
  'SaaS/CCaaS Pre-Sales, 과장급',
  '-고객대상 CCaaS/ SaaS 솔루션 제안
-RFP 분석 및 제안서 작성
-제안 프리젠테이션 진행 및 기술 질의응답 대응
-퍼블릭 클라우드 SaaS 아키텍처 및 기능 구성 기반 Pre-Sales
-퍼블릭 클라우드 SaaS 상품 기획/구현 및 최적화 검토
-주요 CSP(AWS, NCP) IaaS, PaaS 이해 및 제안 적용',
  '[필수요건]
- 총 경력 3년 이상
** 클라우드 전문 기술 보유(아래 요건 중 1개 이상 보유)
-솔루션 아키텍처(SA) : 서비스 분석 및 개선, DevOps 프로세스 이해 및 적용
-인프라 아키텍처(TA) : 클라우드 아키텍처 전반의 이해/구현/운영 역량
-클라우드 운영 최적화(안정성, 효율성 및 비용) 경험
-클라우드 프리세일즈 또는 매니징 경험
-국내/외 CCaaS 솔루션
-국내/외 CSP(AWS, Azure, NCP)

[우대사항]
-클라우드 인프라 설계 또는 최적화 및 대규모 사업 구축 경험
-2개이상의 CSP 운영 경험
-SaaS 상품화에 따른 멀티테넌트 클라우드 환경 구성 경험
-퍼블릭클라우드 프리세일즈 전담 경험
-과거 제안사례 또는 발표자료 포트폴리오 지참 우대',
  '',
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  '2025-10-10'
);
```

## 방법 3: 어드민 패널에서 직접 입력

1. 어드민 패널 → 채용공고 관리
2. "공고 작성" 버튼 클릭
3. 모든 필드 입력 후 저장

## 확인

데이터 입력 후:
1. 어드민 패널 → 채용공고 관리에서 목록 확인
2. 각 항목 클릭하여 상세 내용 확인
3. 수정/삭제 기능 테스트

