-- 채용공고 테이블 스키마 업데이트 (상세 필드 추가)

-- ============================================
-- Step 1: 기존 테이블 확인
-- ============================================
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'job_postings'
ORDER BY ordinal_position;

-- ============================================
-- Step 2: 새로운 컬럼 추가
-- ============================================

-- 모집부문 정보
ALTER TABLE job_postings 
ADD COLUMN IF NOT EXISTS department TEXT,
ADD COLUMN IF NOT EXISTS target_audience TEXT, -- 지원대상 (예: 경력 3년 이상)
ADD COLUMN IF NOT EXISTS job_type TEXT, -- 직무
ADD COLUMN IF NOT EXISTS location TEXT, -- 지역
ADD COLUMN IF NOT EXISTS position_level TEXT, -- 직급
ADD COLUMN IF NOT EXISTS recruitment_count INTEGER DEFAULT 1; -- 모집인원

-- 수행직무 상세 정보
ALTER TABLE job_postings
ADD COLUMN IF NOT EXISTS work_experience TEXT, -- 업무/경력
ADD COLUMN IF NOT EXISTS main_duties TEXT, -- 주요업무
ADD COLUMN IF NOT EXISTS job_description_en TEXT, -- Job Description (영문)
ADD COLUMN IF NOT EXISTS required_qualifications TEXT, -- 필수요건
ADD COLUMN IF NOT EXISTS preferred_qualifications TEXT; -- 우대사항

-- 전형일정 및 지원문의
ALTER TABLE job_postings
ADD COLUMN IF NOT EXISTS recruitment_process TEXT, -- 전형일정
ADD COLUMN IF NOT EXISTS contact_email TEXT DEFAULT 'recruit@ecstel.co.kr', -- 지원문의 이메일
ADD COLUMN IF NOT EXISTS contact_phone TEXT DEFAULT '02-3415-8326'; -- 지원문의 전화번호

-- 조회수
ALTER TABLE job_postings
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0; -- 조회수

-- ============================================
-- Step 3: 업데이트된 테이블 구조 확인
-- ============================================
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'job_postings'
ORDER BY ordinal_position;

