-- 채용공고 테이블 스키마 업데이트 및 실제 데이터 입력

-- ============================================
-- Step 1: 기존 테이블 구조 확인
-- ============================================
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'job_postings'
ORDER BY ordinal_position;

-- ============================================
-- Step 2: 새로운 컬럼 추가 (IF NOT EXISTS 사용)
-- ============================================

-- 모집부문 정보
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'department') THEN
    ALTER TABLE job_postings ADD COLUMN department TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'target_audience') THEN
    ALTER TABLE job_postings ADD COLUMN target_audience TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'job_type') THEN
    ALTER TABLE job_postings ADD COLUMN job_type TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'location') THEN
    ALTER TABLE job_postings ADD COLUMN location TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'position_level') THEN
    ALTER TABLE job_postings ADD COLUMN position_level TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'recruitment_count') THEN
    ALTER TABLE job_postings ADD COLUMN recruitment_count INTEGER DEFAULT 1;
  END IF;
  
  -- 수행직무 상세 정보
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'work_experience') THEN
    ALTER TABLE job_postings ADD COLUMN work_experience TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'main_duties') THEN
    ALTER TABLE job_postings ADD COLUMN main_duties TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'job_description_en') THEN
    ALTER TABLE job_postings ADD COLUMN job_description_en TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'required_qualifications') THEN
    ALTER TABLE job_postings ADD COLUMN required_qualifications TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'preferred_qualifications') THEN
    ALTER TABLE job_postings ADD COLUMN preferred_qualifications TEXT;
  END IF;
  
  -- 전형일정 및 지원문의
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'recruitment_process') THEN
    ALTER TABLE job_postings ADD COLUMN recruitment_process TEXT;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'contact_email') THEN
    ALTER TABLE job_postings ADD COLUMN contact_email TEXT DEFAULT 'recruit@ecstel.co.kr';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'contact_phone') THEN
    ALTER TABLE job_postings ADD COLUMN contact_phone TEXT DEFAULT '02-3415-8326';
  END IF;
  
  -- 조회수
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'job_postings' AND column_name = 'view_count') THEN
    ALTER TABLE job_postings ADD COLUMN view_count INTEGER DEFAULT 0;
  END IF;
END $$;

-- ============================================
-- Step 3: 실제 채용공고 데이터 입력
-- ============================================

-- 1. SaaS/CCaaS Pre-Sales 경력직 채용
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
  deadline,
  view_count
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
  '<ul>
    <li>고객대상 CCaaS/ SaaS 솔루션 제안</li>
    <li>RFP 분석 및 제안서 작성</li>
    <li>제안 프리젠테이션 진행 및 기술 질의응답 대응</li>
    <li>퍼블릭 클라우드 SaaS 아키텍처 및 기능 구성 기반 Pre-Sales</li>
    <li>퍼블릭 클라우드 SaaS 상품 기획/구현 및 최적화 검토</li>
    <li>주요 CSP(AWS, NCP) IaaS, PaaS 이해 및 제안 적용</li>
  </ul>',
  '<p><strong>[Required Qualifications]</strong></p>
  <ul>
    <li>Minimum 3 years of experience</li>
    <li><strong>Cloud expertise (at least one of the following):</strong>
      <ul>
        <li>Solution Architecture (SA): Service analysis and improvement, DevOps process understanding and application</li>
        <li>Infrastructure Architecture (TA): Overall understanding/implementation/operation of cloud architecture</li>
        <li>Cloud operation optimization (stability, efficiency, and cost) experience</li>
        <li>Cloud presales or managing experience</li>
        <li>Domestic/international CCaaS solutions</li>
        <li>Domestic/international CSP (AWS, Azure, NCP)</li>
      </ul>
    </li>
  </ul>
  <p><strong>[Preferred Qualifications]</strong></p>
  <ul>
    <li>Cloud infrastructure design or optimization and large-scale project construction experience</li>
    <li>Experience operating 2 or more CSPs</li>
    <li>Multi-tenant cloud environment configuration experience for SaaS productization</li>
    <li>Dedicated public cloud presales experience</li>
    <li>Portfolio of past proposal cases or presentation materials preferred</li>
  </ul>',
  '<p><strong>[필수요건]</strong></p>
  <ul>
    <li>총 경력 3년 이상</li>
    <li><strong>클라우드 전문 기술 보유(아래 요건 중 1개 이상 보유)</strong>
      <ul>
        <li>솔루션 아키텍처(SA) : 서비스 분석 및 개선, DevOps 프로세스 이해 및 적용</li>
        <li>인프라 아키텍처(TA) : 클라우드 아키텍처 전반의 이해/구현/운영 역량</li>
        <li>클라우드 운영 최적화(안정성, 효율성 및 비용) 경험</li>
        <li>클라우드 프리세일즈 또는 매니징 경험</li>
        <li>국내/외 CCaaS 솔루션</li>
        <li>국내/외 CSP(AWS, Azure, NCP)</li>
      </ul>
    </li>
  </ul>',
  '<p><strong>[우대사항]</strong></p>
  <ul>
    <li>클라우드 인프라 설계 또는 최적화 및 대규모 사업 구축 경험</li>
    <li>2개이상의 CSP 운영 경험</li>
    <li>SaaS 상품화에 따른 멀티테넌트 클라우드 환경 구성 경험</li>
    <li>퍼블릭클라우드 프리세일즈 전담 경험</li>
    <li>과거 제안사례 또는 발표자료 포트폴리오 지참 우대</li>
  </ul>',
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  '2025-10-10',
  9017
);

-- 2. 기술영업 신입/경력 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  '기술영업 신입/경력 채용',
  'closed',
  '기술영업',
  '신입 또는 경력 3년 이상',
  '기술영업',
  '서울',
  '사원~대리',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- 3. PM(Project Manager) 경력직 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  'PM(Project Manager) 경력직 채용',
  'closed',
  'PM',
  '경력 5년 이상',
  'Project Manager',
  '서울',
  '과장~차장',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- 4. 클라우드 컨택센터 엔지니어 경력직 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  '클라우드 컨택센터 엔지니어 경력직 채용',
  'open',
  '엔지니어링',
  '경력 5년 이상',
  'Cloud Contact Center Engineer',
  '서울',
  '과장',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- 5. IPT & Video 엔지니어 경력직 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  'IPT & Video 엔지니어 경력직 채용',
  'open',
  '엔지니어링',
  '경력 2년 이상',
  'IPT & Video Engineer',
  '서울',
  '대리~과장',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- 6. CTI 개발 경력직 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  'CTI 개발 경력직 채용',
  'closed',
  '개발',
  '경력 5년 이상',
  'CTI Developer',
  '서울',
  '과장',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- 7. Customer Success Pre-Sales 경력직 채용
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  'Customer Success Pre-Sales 경력직 채용',
  'open',
  'Pre-Sales',
  '경력 5년 이상',
  'Customer Success Pre-Sales',
  '서울',
  '과장~차장',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- 8. 사업기획(경력)
INSERT INTO job_postings (
  title,
  status,
  department,
  target_audience,
  job_type,
  location,
  position_level,
  recruitment_count,
  recruitment_process,
  contact_email,
  contact_phone,
  deadline,
  view_count
) VALUES (
  '사업기획(경력)',
  'closed',
  '사업기획',
  '경력 2~5년',
  'Business Planning',
  '서울',
  '대리~과장',
  1,
  '서류전형-1차 실무진 면접- 2차 대표이사 면접- 최종합격',
  'recruit@ecstel.co.kr',
  '02-3415-8326',
  NULL,
  0
);

-- ============================================
-- Step 4: 업데이트된 테이블 구조 확인
-- ============================================
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'job_postings'
ORDER BY ordinal_position;

-- ============================================
-- Step 5: 입력된 데이터 확인
-- ============================================
SELECT 
  id,
  title,
  status,
  department,
  target_audience,
  location,
  position_level,
  created_at
FROM job_postings
ORDER BY created_at DESC;

