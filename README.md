# 🖥️ Computer Architecture

컴퓨터구조 과목에서 진행한 과제 프로젝트와 교재 연습문제 풀이를 모아둔 저장소입니다.  
논리 소자로 만든 간단한 프로세서부터 MIPS CPU의 제어 설계, 파이프라인, 캐시 성능 분석까지 다룹니다.

<br>

## 🗂️ Projects

|  #  | 프로젝트              | 핵심 내용                   |                                                               바로가기                                                               |
| :-: | :-------------------- | :-------------------------- | :----------------------------------------------------------------------------------------------------------------------------------: |
|  0  | MU0 프로세서 구현     | 순차 회로, 16-bit 프로세서  |  [![Project 0](https://img.shields.io/badge/Project_0-MU0_Processor-555555?style=for-the-badge)](./Project0_MU0-Processor-Logisim)   |
|  1  | MIPS Single-Cycle CPU | 제어 신호 설계, 기계어 작성 | [![Project 1](https://img.shields.io/badge/Project_1-Single_Cycle_CPU-4A90E2?style=for-the-badge)](./Project1_MIPS-Single-Cycle-CPU) |
|  2  | MIPS Multi-Cycle CPU  | FSM, 마이크로코드           |  [![Project 2](https://img.shields.io/badge/Project_2-Multi_Cycle_CPU-7B68EE?style=for-the-badge)](./Project2_MIPS-Multi-Cycle-CPU)  |
|  3  | Pipeline Hazard 해결  | NOP 삽입 vs Forwarding      |  [![Project 3](https://img.shields.io/badge/Project_3-Pipeline-2ECC71?style=for-the-badge)](./Project3_Pipeline-Hazard-Forwarding)   |
|  4  | Cache 성능 분석       | SimpleScalar, AMAT          |        [![Project 4](https://img.shields.io/badge/Project_4-Cache-E74C3C?style=for-the-badge)](./Project4_Cache-SimpleScalar)        |

<br>

## ✏️ Homework

교재(_Computer Organization and Design_, MIPS Edition) 연습문제 풀이입니다.

|  #  |  챕터   | 주요 내용                                                               |                                                                      바로가기                                                                       |
| :-: | :-----: | :---------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------: |
|  1  | Ch 2, 3 | MIPS 명령어·인코딩, 오버플로, 나눗셈 하드웨어, IEEE 754 부동소수점      |    [![HW1](https://img.shields.io/badge/HW_1-ISA_&_Arithmetic-4A90E2?style=for-the-badge)](./Problem-Solving/HW1_Ch2-3_MIPS-ISA-Arithmetic.pdf)     |
|  2  | Ch 1, 4 | CPI·실행 시간 성능 분석, 멀티프로세서 속도 향상, 단일 사이클 데이터패스 | [![HW2](https://img.shields.io/badge/HW_2-Performance_&_Datapath-7B68EE?style=for-the-badge)](./Problem-Solving/HW2_Ch1-4_Performance-Datapath.pdf) |
|  3  |  Ch 4   | 파이프라인 Hazard, 포워딩, 지연 슬롯, 분기 예측, 2-issue 스케줄링       |        [![HW3](https://img.shields.io/badge/HW_3-Pipeline-2ECC71?style=for-the-badge)](./Problem-Solving/HW3_Ch4_Pipeline-Hazard-Branch.pdf)        |
|  4  |  Ch 5   | 캐시 HIT/MISS 분석, 다단계 캐시, 가상 메모리·페이지 테이블, 캐시 일관성 |    [![HW4](https://img.shields.io/badge/HW_4-Memory_Hierarchy-E74C3C?style=for-the-badge)](./Problem-Solving/HW4_Ch5_Memory-Hierarchy-Cache.pdf)    |

<br>

## 📝 Project Summary

### 0️⃣ MU0 프로세서 구현

기본 논리 소자부터 순차 회로를 단계적으로 쌓아 올린 뒤, 간단한 16-bit MU0 프로세서를 구현했습니다.

- **단계적 설계** : Transmission Gate → **2:1 MUX** → **Latch** → **D Flip-Flop** → **동기식 Up/Down Counter** 순서로, 앞에서 만든 회로를 부품 삼아 다음 회로를 구성
- **MU0 프로세서** : Accumulator(ACC), Instruction Register, PC, ALU, 메모리로 구성된 16-bit 프로세서
- **명령어 구현** : `LDA` · `STO` · `ADD` · `SUB` · `JMP` · `JGE` · `JNE` · `STP`
- **동작 검증** : 메모리 이미지를 불러와 명령어별 Fetch–Execute 과정과 ACC·메모리 변화를 확인
- **도구** : Logisim-evolution

### 1️⃣ MIPS Single-Cycle CPU

Single-Cycle MIPS 프로세서에 새로운 명령어를 추가하고, 직접 작성한 기계어 프로그램으로 동작을 검증했습니다.

- **제어 신호 설계** : 명령어별 opcode·funct를 분석해 `ALUop`, `RegDst`, `ALUsrcB` 등 제어 신호를 정의하고 **PLA 표**(`PLA_AND.txt`, `PLA_OR.txt`)로 구현
- **추가 명령어** : `and` · `nor` · `sltu` · `srl` · `addi` · `lui` · `ori` · `lb` · `sh` · `bne` · `jalr` 등 산술·논리·메모리·분기·점프 명령어
- **기계어 직접 작성** : 테스트 프로그램을 32-bit 이진수로 인코딩해 `M_TEXT_SEG.txt`에 작성
- **검증** : Icarus Verilog로 시뮬레이션하고, 레지스터·메모리 덤프와 GTKWave 파형으로 결과 확인

### 2️⃣ MIPS Multi-Cycle CPU

명령어를 여러 단계로 나누어 실행하는 Multi-Cycle MIPS 프로세서의 제어부를 FSM과 마이크로코드로 설계했습니다.

- **FSM 설계** : 공통 단계인 Fetch(`0x00`)와 Decode(`0x01`) 이후, 명령어 유형별로 실행·메모리 접근·쓰기 단계로 분기하는 상태도 설계
- **마이크로코드** : 각 상태의 제어 신호를 `ROM_MICRO.txt`에, 명령어별 다음 상태 분기를 `ROM_DISP.txt`에 작성
- **명령어 유형별 흐름** : R-type(`and`, `nor`, `sltu`, `srl`), I-type(`addi`, `lb`, `sh`), 분기(`bne`, `bgez`), 점프(`jalr`)의 서로 다른 상태 흐름 구현
- **검증** : 시뮬레이션 결과와 파형으로 상태 전이와 제어 신호 확인

### 3️⃣ Pipeline Hazard 해결

Shell Sort를 MIPS 어셈블리로 작성하고, 5단계 파이프라인에서 발생하는 Hazard를 두 가지 방식으로 해결해 성능을 비교했습니다.

- **어셈블리 작성** : Shell Sort 알고리즘을 MIPS 어셈블리(`shell_sort.asm`)로 직접 구현
- **Hazard 분석** : Structural · Data(RAW) · Control Hazard가 발생하는 지점을 명령어 단위로 분석
- **No Forwarding** : 의존성이 있는 명령어 사이에 **NOP를 삽입**하는 소프트웨어 방식으로 해결
- **Forwarding** : Forward 제어 신호를 추가해 앞선 명령어의 결과를 바로 전달하고, 꼭 필요한 NOP(Load-Use, Branch Delay Slot)만 남김
- **결과** : 전체 실행 사이클 **3200 → 2502** 로 약 **22% 단축**

### 4️⃣ Cache 성능 분석

캐시 메모리의 동작을 파형으로 관찰하고, 다양한 캐시 구성에서 벤치마크 성능을 비교했습니다.

- **1단계 · 동작 관찰** : Bubble Sort와 Random Access 프로그램에서 I/D L1 캐시의 hit/miss, L2·메인 메모리 접근 시점을 파형으로 분석
- **접근 패턴 비교** : 규칙적인 접근(Bubble Sort)은 공간 지역성으로 hit이 이어지는 반면, 무작위 접근은 set 충돌로 miss가 잦아지는 차이 확인
- **2단계 · 구성별 비교** : **SimpleScalar**(`sim-cache`)로 SPEC95 벤치마크(go, m88ksim, swim)를 실행하며 Unified/Split 구조, set 수, block size, associativity를 바꿔 실험
- **성능 지표** : Miss Rate와 **AMAT**(평균 메모리 접근 시간)를 계산해 가장 효율적인 구성 도출

<br>

## 🛠️ Tech Stack

![MIPS](https://img.shields.io/badge/MIPS_Assembly-CC0000?style=flat-square)
![Logisim](https://img.shields.io/badge/Logisim--evolution-555555?style=flat-square)
![Icarus Verilog](https://img.shields.io/badge/Icarus_Verilog-1E90FF?style=flat-square)
![GTKWave](https://img.shields.io/badge/GTKWave-2E8B57?style=flat-square)
![SimpleScalar](https://img.shields.io/badge/SimpleScalar-8B4513?style=flat-square)

<br>

## 📁 Repository Structure

```
Computer-Architecture/
├── Homework/
│   ├── HW1_Ch2-3_MIPS-ISA-Arithmetic.pdf
│   ├── HW2_Ch1-4_Performance-Datapath.pdf
│   ├── HW3_Ch4_Pipeline-Hazard-Branch.pdf
│   └── HW4_Ch5_Memory-Hierarchy-Cache.pdf
├── Project0_MU0-Processor-Logisim/
├── Project1_MIPS-Single-Cycle-CPU/
├── Project2_MIPS-Multi-Cycle-CPU/
├── Project3_Pipeline-Hazard-Forwarding/
│   ├── noforwarding/
│   └── forwarding/
└── Project4_Cache-SimpleScalar/
```

<br>

## ⚠️ Note

과제 명세서, 강의 자료, 교수님이 제공한 시뮬레이션 파일(`tb_*.o`)과 SPEC95 벤치마크 바이너리는 저작권 및 라이선스 문제로 포함하지 않았습니다.  
이 저장소에는 직접 작성한 제어 신호 표, 마이크로코드, 어셈블리 코드, 시뮬레이션 결과와 보고서, 연습문제 풀이만 포함되어 있습니다.  
연습문제의 문제 원문은 교재 출판사에 저작권이 있습니다.

<br>

## ©️ Copyright

Copyright © 2025 장서현. All rights reserved.

이 저장소의 코드, 보고서, 풀이는 학습 및 포트폴리오 목적으로 공개합니다.  
**무단 복제 및 과제 제출 용도로의 사용을 금지합니다.**
