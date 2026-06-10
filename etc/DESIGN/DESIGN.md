---
name: Siljeok Mate
colors:
  surface: '#f8f9fa'
  surface-dim: '#d9dadb'
  surface-bright: '#f8f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f5'
  surface-container: '#edeeef'
  surface-container-high: '#e7e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#424754'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#727785'
  outline-variant: '#c2c6d6'
  surface-tint: '#005ac2'
  primary: '#0058be'
  on-primary: '#ffffff'
  primary-container: '#2170e4'
  on-primary-container: '#fefcff'
  inverse-primary: '#adc6ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#825100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a36700'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004395'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#f8f9fa'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-padding: 20px
  stack-gap-lg: 24px
  stack-gap-md: 16px
  stack-gap-sm: 8px
  grid-gutter: 12px
---

## Brand & Style
이 디자인 시스템은 사용자의 자산과 실적을 관리하는 'Smart Financial Helper'로서의 정체성을 가집니다. **Corporate / Modern** 스타일을 기반으로 하며, 금융 서비스의 핵심인 신뢰감과 실시간 데이터의 명확성을 최우선으로 합니다. 

복잡한 금융 수치를 단순하고 직관적으로 전달하기 위해 불필요한 장식을 배제하고, 여백을 활용한 미니멀리즘과 데이터 가독성을 높이는 인터랙티브 요소를 결합합니다. 사용자가 자신의 소비 현황을 '마이크로 컨트롤'하고 있다는 통제감을 느낄 수 있도록 정교하고 정제된 인터페이스를 지향합니다.

## Colors
색상 체계는 정보의 상태를 즉각적으로 인지할 수 있도록 설계되었습니다.

- **Primary (Trust Blue):** 신뢰와 보안을 상징하는 Deep Indigo/Blue 계열을 사용하여 전문적인 이미지를 구축합니다. 브랜드의 주요 행동 유도(CTA) 및 핵심 브랜드 요소에 적용합니다.
- **Secondary (Success Green):** 실적 달성, 혜택 적용, 긍정적 변화 등 '완료' 상태를 나타내는 데 사용됩니다.
- **Tertiary (Warning Gold):** 실적 미달 주의, 기간 만료 임박 등 사용자의 주의가 필요한 정보에 적용합니다.
- **Background & Neutrals:** 깨끗한 화이트와 부드러운 그레이(#F9FAFB)를 층층이 쌓아 정보의 계층을 구분하며, 장시간 이용에도 피로감이 적은 화면을 구성합니다.

## Typography
금융 데이터의 가독성을 극대화하기 위해 시스템 폰트와 호환성이 높고 가독성이 검증된 **Inter**를 사용합니다. 

숫자와 한글이 혼용되는 환경에서 시각적 균형을 맞추기 위해 Letter-spacing을 미세하게 조정했습니다. 중요한 금액 정보와 실적 수치는 `headline-lg` 또는 `md`를 사용하여 사용자가 화면에 진입하자마자 핵심 정보를 파악할 수 있게 합니다. 본문 텍스트는 명확한 정보 전달을 위해 충분한 행간을 확보합니다.

## Layout & Spacing
모바일 환경에 최적화된 **4컬럼 플루이드 그리드(Fluid Grid)** 시스템을 사용합니다. 

- **Margins:** 화면 좌우 기본 마진은 20px로 설정하여 콘텐츠의 집중도를 높입니다.
- **Rhythm:** 모든 간격은 4px 또는 8px의 배수를 기본 단위로 하여 일관된 리듬을 유지합니다. 
- **Hierarchy:** 연관된 정보 그룹(카드 내 요소 등)은 8px 간격을, 독립된 섹션 간에는 24px 이상의 간격을 두어 시각적 구조를 명확히 합니다. 실시간 업데이트 정보를 담는 대시보드에서는 정보의 밀도를 조절하여 한 화면에 필요한 마이크로 데이터가 충분히 노출되도록 구성합니다.

## Elevation & Depth
물리적인 종이의 겹침보다는 **Tonal Layers**와 **Ambient Shadows**를 사용하여 깊이감을 표현합니다.

- **Surface Levels:** 배경(#F9FAFB) 위에 흰색 카드 레이어를 올려 정보를 그룹화합니다.
- **Shadows:** 카드 요소에는 아주 부드러운 확산형 그림자(Blur: 15-20px, Opacity: 4-6%, Color: Primary 컬러가 미세하게 섞인 그레이)를 적용하여 바닥에서 살짝 떠 있는 듯한 느낌을 줍니다.
- **Borders:** 그림자만으로 구분이 어려운 경우 1px의 아주 연한 보더(#E2E8F0)를 병행 사용하여 경계를 정의합니다. 이는 금융 앱 특유의 정갈하고 정밀한 인상을 강화합니다.

## Shapes
현대적이고 친근한 금융 앱의 느낌을 주기 위해 둥근 모서리 스타일을 적극적으로 활용합니다.

- **Default (Card/Input):** 16px의 곡률을 기본으로 사용합니다. (`rounded-lg`)
- **Large Container:** 대시보드의 메인 카드나 하단 시트 등에는 24px의 큰 곡률을 적용하여 부드러운 인상을 줍니다. (`rounded-xl`)
- **Small Elements (Chips/Buttons):** 버튼과 상태 칩은 완전한 곡선(Pill-shaped)을 사용하여 인터랙티브한 요소임을 직관적으로 알립니다.

## Components
이 디자인 시스템의 컴포넌트는 데이터의 '상태'를 보여주는 데 특화되어 있습니다.

- **Data Visualization:**
    - **Progress Bars:** 실적 달성률을 나타내며, Secondary(Green) 컬러를 활용해 진행 상태를 시각화합니다. 배경 바는 연한 그레이를 사용하여 대비를 높입니다.
    - **Ring Charts:** 카드별 혜택 한도나 소비 카테고리 비중을 나타낼 때 사용하며, 굵은 스트로크와 라운드 캡(Round Cap) 처리를 통해 현대적인 느낌을 줍니다.
- **Interactive Controls:**
    - **Toggle Buttons:** [실적 인정] / [실적 제외] 상태를 전환하는 토글은 스위치 형태가 아닌, 탭(Segmented Control) 형태를 권장하여 현재 선택된 상태를 텍스트로 명확히 보여줍니다.
    - **Status Chips:** 실적 충족 여부를 나타내는 칩은 배경색에 투명도를 준 스타일(Subtle background)을 사용하여 텍스트 컬러와의 조화를 꾀합니다.
- **Input Fields:** 입력 필드는 포커스 시 Primary 컬러의 보더와 미세한 글로우 효과를 주어 현재 편집 중임을 강조합니다.
- **Cards:** 각 신용카드 정보는 개별 카드 컨테이너에 담기며, 상단에 카드의 실물 이미지를 연상시키는 포인트 컬러 바를 배치하여 식별성을 높입니다.