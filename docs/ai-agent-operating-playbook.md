# AI Agent Operating Playbook

สถานะเอกสาร: draft 1
วันที่สำรวจ: 2026-10-16
ขอบเขต: inventory ของ skill ที่ติดตั้งในเครื่องนี้, role สำหรับการทำงานร่วมกัน, แนวทางแยกตาม Claude / Codex / Antigravity และ task สำหรับพัฒนาต่อ

Role contracts ที่นำไปใช้ข้าม project ได้อยู่ที่ [`docs/agent-roles.md`](agent-roles.md)

## 1. หลักการใช้งานร่วมกัน

1. ให้ agent อ่านกติกาของ repository ก่อนเริ่มงาน และรักษา `AGENTS.md` เป็นแผนที่สั้น ๆ ไม่ใช่สารานุกรม
2. แยก **rule** (ข้อบังคับถาวร), **skill** (ขั้นตอนที่เรียกใช้เมื่อเกี่ยวข้อง), **role** (ความรับผิดชอบของ agent) และ **task** (งานที่ส่งต่อได้)
3. งานหนึ่งชิ้นต้องมี scope, acceptance criteria, verification command และ artifact ที่ต้องส่งมอบ
4. ใช้ progressive disclosure: เก็บรายละเอียดลึกไว้ใน `docs/` หรือ `references/` แล้วให้ไฟล์กติกาชี้ทาง
5. ทุก handoff ต้องส่งต่อ “สิ่งที่รู้แล้ว, สิ่งที่เปลี่ยน, หลักฐานการตรวจสอบ และสิ่งที่ยังติดขัด”
6. ห้ามใส่ secret, token, credential หรือข้อมูลเฉพาะเครื่องลงใน repository
7. โค้ดที่ AI สร้างต้องอ่านเข้าใจง่าย ไม่ย่อจนเกินไป และยึด architecture/convention ของ project เป็น source of truth

มาตรฐานการสร้างโค้ดแบบละเอียดอยู่ที่ [Shared Agent Roles — Code generation standard](agent-roles.md#code-generation-standard)

## 2. Inventory ที่ตรวจพบในเครื่องนี้

### 2.1 Codex / local Codex skills

แหล่งหลัก: `/Users/trinnakrit.p/.codex/skills`

| กลุ่ม | Skills ที่ติดตั้ง |
|---|---|
| วิธีคิดและคุณภาพ | `caveman`, `ponytail`, `token-efficient-coding`, `context-efficient-debugging`, `tool-selection` |
| สำรวจและออกแบบ codebase | `codegraph-usage`, `graft-usage`, `codebase-design`, `domain-modeling`, `project-knowledge`, `improve-codebase-architecture` |
| แก้ไขและ refactor | `serena-refactoring`, `refactoring-workflow`, `prototype` |
| Debug / review / triage | `grilling`, `grill-with-docs`, `triage`, `scrutinize` |
| วางแผนและแตกงาน | `large-initiative-workflow`, `wayfinder`, `to-spec`, `to-tickets`, `handoff` |
| ฐานข้อมูล | `postgresql-best-practices`, `supabase-postgres-best-practices` |
| Collaboration / team | `orchestration`, `teamai` |
| เอกสารและการกำกับ | `writing-for-agents`, `commit`, `iso27001-commit` |
| Frontend / product | `impeccable` |
| อื่น ๆ | `setup-matt-pocock-skills` |

### 2.2 Agent / Superset skills

แหล่งหลัก: `/Users/trinnakrit.p/.agents/skills`

`find-skills`, `orchestration`, `superset-10x`, `superset-automate`, `superset-browser`, `superset-computer`, `superset-contribute`, `superset-doctor`, `superset-feedback`, `superset-integrations`, `superset-orchestrate`, `superset-page`, `superset-plugins`, `superset-setup`, `superset-standup`

### 2.3 Bundled / plugin skills ที่พบ

พบกลุ่ม `documents`, `pdf`, `presentations`, `spreadsheets`, `template-creator`, `visualize`, `sites`, `plugin-management`, `work-pets` และ template skills สำหรับ dashboard, business review, experiment analysis, budget, strategy, system design และ project tracker ภายใต้ `/Users/trinnakrit.p/.codex/plugins/cache`.

หมายเหตุ: รายการนี้เป็น inventory จาก filesystem ณ วันที่สำรวจ ไม่ใช่สัญญาว่า runtime ทุกตัวจะ expose skill เดียวกันทุก session

### 2.4 คำอธิบาย Codex skills แต่ละตัว

| Skill | ใช้ทำอะไรหลัก | หลักการของ skill |
|---|---|---|
| `caveman` | คุมรูปแบบคำตอบให้สั้นและไม่ซ้ำ | ตัด boilerplate ที่ไม่เพิ่มความถูกต้อง |
| `ponytail` | คุมให้แก้ code เท่าที่จำเป็น | smallest correct diff; ไม่สร้าง abstraction ล่วงหน้า |
| `token-efficient-coding` | ลดการอ่าน code/log เกินจำเป็น | filter ที่ source และอ่านแบบ progressive disclosure |
| `context-efficient-debugging` | วิเคราะห์ log, JSON และ payload ขนาดใหญ่ | สรุปจากข้อมูลที่กรองแล้ว ไม่ dump raw data |
| `tool-selection` | เลือกเครื่องมือสำรวจ/แก้ไขให้เหมาะ | CodeGraph หา scope, Serena เปลี่ยน symbol, RTK ลด output |
| `codegraph-usage` | สำรวจ architecture, symbol และ caller | ตอบว่า code ไหนเกี่ยวข้องก่อนแก้ |
| `graft-usage` | สำรวจ codebase ด้วย Graft | ใช้ graph และ call path แทน blind grep |
| `codebase-design` | ออกแบบ module และ seam ให้ลึก/ทดสอบง่าย | interface ที่แคบแต่ซ่อนความซับซ้อนได้มาก |
| `domain-modeling` | จัดศัพท์ domain, glossary และ ADR | ใช้คำเดียวกันเป็น source of truth ของทีม |
| `project-knowledge` | อ่าน/บันทึก knowledge graph ของโครงการ | ตรวจ fact, decision และ drift ก่อนเริ่มงาน |
| `improve-codebase-architecture` | หาโอกาส deepening ใน codebase | สำรวจแล้วเสนอทางเลือกเป็นรายงานก่อนลงมือ |
| `serena-refactoring` | rename, reference lookup และเปลี่ยน signature | แก้ระดับ symbol ไม่ใช่ replace string |
| `refactoring-workflow` | ทำ cross-file refactor หรือ contract migration | scope → semantic edit → blast-radius check → test |
| `prototype` | ทำ spike เพื่อพิสูจน์ design/behavior | ใช้ของ throwaway ลดความเสี่ยงก่อน production |
| `debug-mantra` | debug bug หรือ stack trace | reproduce → trace fail path → falsify → cross-reference |
| `grilling` | สัมภาษณ์เพื่อ stress-test แผน/ความคิด | เปิด assumption และ decision ที่ยังไม่ชัด |
| `grill-with-docs` | grill พร้อมสร้าง ADR/glossary | เปลี่ยนบทสนทนาให้เป็น decision ที่บันทึกได้ |
| `triage` | คัดกรอง issue และ external PR | state machine: categorise → verify → brief → route |
| `scrutinize` | review แผน, diff, PR หรือ design | เริ่มจาก intent แล้ว trace code path จริง |
| `post-mortem` | เขียน RCA หลัง bug ถูกแก้และ verify แล้ว | root cause → mechanism → fix → validation → escape |
| `large-initiative-workflow` | จัดการ migration/งานหลาย subsystem | แบ่งเป็น phase และ handoff ที่ตรวจได้ |
| `wayfinder` | วางแผนงานที่เกินหนึ่ง session | สร้างแผนที่เป็น decision tickets แล้วแก้ทีละจุด |
| `to-spec` | สังเคราะห์บทสนทนาเป็น specification | เปลี่ยนความต้องการที่กระจัดกระจายเป็น scope เดียว |
| `to-tickets` | แตก spec/plan เป็น tickets | แต่ละ ticket เป็น tracer bullet และประกาศ blocking edge |
| `handoff` | ย่อ context ให้ agent คนถัดไป | ส่งต่อ outcome, evidence, decisions, risks และ next action |
| `orchestration` | ประสาน workers, DAG และ blocking ask/reply | coordinator ถือ ownership และรอผลตามสถานะ |
| `teamai` | sync skills, rules, docs และ project knowledge | ให้ configuration ทีมเป็น source of truth ร่วมกัน |
| `postgresql-best-practices` | ออกแบบ/ดูแล PostgreSQL และ Azure PostgreSQL | correctness, query plan, security และ operations ต้องไปด้วยกัน |
| `supabase-postgres-best-practices` | ทำ schema, migration, RLS, pgvector และ tuning | โหลดก่อนเปลี่ยน database ทุกครั้ง รวมถึง security policy |
| `writing-for-agents` | เขียน skill, `AGENTS.md`, `CLAUDE.md` และ agent docs | แยก steps/reference และใช้ progressive disclosure |
| `commit` | สร้าง commit ที่ audit ได้ | บังคับ CIA impact, classification, control, risk และ reason |
| `iso27001-commit` | สร้าง commit ตาม ISO 27001 | ใช้ security metadata เป็นส่วนหนึ่งของ commit message |
| `impeccable` | ออกแบบ/ปรับปรุง frontend และ UX | hierarchy, accessibility, responsive behavior และ visual polish |
| `management-talk` | แปลงภาษาวิศวกรรมเป็น update สำหรับผู้บริหาร | ปรับตาม audience และ channel โดยไม่เสียสาระ |
| `setup-matt-pocock-skills` | ตั้งค่า repo ก่อนใช้ engineering skills | เตรียม issue tracker, labels และ domain-doc layout ครั้งเดียว |

### 2.5 คำอธิบาย Agent / Superset skills แต่ละตัว

| Skill | ใช้ทำอะไรหลัก | หลักการของ skill |
|---|---|---|
| `find-skills` | ค้นหา skill ที่เหมาะกับความต้องการ | discover ก่อน build เองหรือถามซ้ำ |
| `orchestration` | ประสานงาน agent และการ handoff | แยกงานตาม capability และติดตามสถานะ |
| `superset-10x` | สำรวจความสามารถ Superset ที่ยังไม่ได้ใช้ | audit workflow แล้วตั้งค่าความสามารถที่คุ้มค่า |
| `superset-automate` | ทำงานประจำให้เป็น automation | ระบุ prompt, schedule, target และ review run แรก |
| `superset-browser` | เปิด/อ่าน/คลิก/กรอกเว็บและตรวจ console | ใช้ browser จริงเมื่อ API/CLI ไม่พอ |
| `superset-computer` | ควบคุม native desktop app | ใช้ accessibility-first และไม่ใช้แทน API/CLI ที่ตรงกว่า |
| `superset-contribute` | เตรียม contribution ให้ Superset | clone → setup → follow repo rules → merge-ready PR |
| `superset-doctor` | แก้ปัญหา Superset, host, terminal และ auth | diagnose ก่อนแก้ และแยกปัญหา environment ออกจาก code |
| `superset-feedback` | ส่ง bug report หรือ feature request | เก็บ reproduction และส่งไปยังช่องทางที่ถูกต้อง |
| `superset-integrations` | ค้นหาและเรียก connected integration tools | ตรวจ capability ก่อนเรียก MCP tool |
| `superset-orchestrate` | fan-out coding agents หลาย workspace | dependency tracking, follow-up และ structured result |
| `superset-page` | สร้าง/publish หน้า HTML ให้ทีมอ่านและ comment | artifact มี version และ feedback loop |
| `superset-plugins` | ติดตั้ง/เชื่อมต่อ/เรียก plugin | จัดการ capability และ credential proxy อย่างเป็นระบบ |
| `superset-setup` | ทำ repo ให้พร้อมสร้าง workspace ใหม่ | setup, teardown และ run script ต้อง boot ได้จริง |
| `superset-standup` | สรุปสิ่งที่ agents ทำระหว่างผู้ใช้ไม่อยู่ | sweep งานและรายงาน done, review-needed, blocked |

### 2.6 Bundled / plugin skills ที่ควรรู้จัก

| กลุ่ม | ใช้ทำอะไรหลัก | หลักการของกลุ่ม |
|---|---|---|
| `documents` | สร้าง/แก้/ตรวจ `.docx` | render แล้วตรวจ layout ก่อนส่งมอบ |
| `pdf` | อ่าน/สร้าง/ตรวจ PDF | extract และ render เพื่อยืนยัน visual layout |
| `presentations` | สร้าง/แก้ PowerPoint หรือ Slides | ตรวจ slide structure และภาพจริง |
| `spreadsheets` | วิเคราะห์/สร้าง/แก้ spreadsheet | รักษา formula, formatting และ recalculation |
| `template-creator` | ทำ artifact template ที่ใช้ซ้ำได้ | แยก template skill จากงาน one-off |
| `visualize` | สร้าง chart, simulation และ interactive visual | เลือก visual ที่ช่วยให้เข้าใจ ไม่ใช่แค่ตกแต่ง |
| `sites` | สร้าง/preview/publish เว็บไซต์ | ตรวจหน้า live และ lifecycle ของ site |
| `plugin-management` | ค้นหา/จัดการ plugin และ permission | ตรวจ dependency และ capability ก่อนเปิดใช้ |
| `work-pets` | สร้าง/ตรวจ/อัปเดต animated pet | รักษา asset lifecycle และ sprite requirements |
| artifact templates | dashboard, budget, strategy, system design ฯลฯ | ใช้โครงสร้างที่ผ่านการออกแบบแล้ว ลดเวลาเริ่มต้น |

## 3. Role มาตรฐานของ agent

### 3.1 Base-agent-first coordination policy

หลักการใหม่ของเครื่องนี้คือ **agent ตัวแรกที่ผู้ใช้เรียกเป็น `team-lead` / coordinator หลัก** ไม่ผูก coordinator ไว้กับ Claude, Codex หรือ Antigravity แบบถาวร

| สถานการณ์ | ผู้รับผิดชอบหลัก | การทำงานต่อ |
|---|---|---|
| ผู้ใช้เริ่มจาก Claude | Claude session แรก | Claude วางแผนและตัดสินใจว่าจะทำเองหรือส่งต่อ |
| ผู้ใช้เริ่มจาก Codex | Codex session แรก | Codex เป็น coordinator และถือ context หลัก |
| ผู้ใช้เริ่มจาก Antigravity | Antigravity session แรก | Antigravity เป็น coordinator และถือ artifact/verification หลัก |
| เรียก agent อื่นภายหลัง | Base agent เดิม | ทำหน้าที่เป็น worker/reviewer ตาม task ที่ได้รับ ไม่แย่ง ownership |

#### กติกาการ spawn

1. Base agent ต้องสำรวจ scope, dependency และ acceptance criteria ก่อน spawn role อื่น
2. งานเล็ก, มี scope ชัด หรือไม่มี parallelism ที่คุ้มค่า ให้ base agent ทำเอง
3. Spawn เมื่อมีเหตุผลที่ตรวจได้ เช่น งานแยกอิสระจริง, ต้องการมุมมอง reviewer, ต้องใช้ capability เฉพาะ หรือช่วยลดเวลาได้ชัดเจน
4. ก่อน spawn ให้ base agent อ้างอิง role/skill ของตัวเองเป็น source of truth และส่ง task ที่แคบพร้อม output contract
5. ถ้าการ spawn เพิ่ม token หรือ context อย่างมีนัยสำคัญ และยังไม่ใช่กรณีจำเป็น ให้ถามผู้ใช้ก่อน
6. ห้ามให้ worker spawn ต่อแบบอิสระ เว้นแต่ base agent อนุมัติไว้ใน task หรือผู้ใช้สั่งโดยตรง
7. Base agent เป็นผู้รวมผล, ตรวจความขัดแย้ง, ตัดสินใจสุดท้าย และรายงานผู้ใช้
8. หาก base agent ถูก handoff ให้ส่งต่อ ownership อย่างชัดเจน: มี base agent ใหม่เพียงหนึ่งตัว และปิด/หยุด coordinator เดิม

#### Token budget decision

ก่อน spawn ให้ตอบคำถามสั้น ๆ ภายในการวางแผน:

- งานนี้แยกเป็นงานอิสระจริงหรือไม่
- worker จะลดเวลาหรือเพิ่มความถูกต้องมากกว่าค่า context/token หรือไม่
- ผลลัพธ์ของ worker ตรวจรับได้ด้วย artifact หรือ evidence ใด
- ถ้าไม่ spawn base agent ทำเองได้หรือไม่

ค่าเริ่มต้นคือ **ทำเองก่อน, spawn เมื่อคุ้ม, ถ้าไม่แน่ใจให้ถามก่อน**.

#### Default execution routing

เมื่อ base agent เห็นว่างานควรส่งต่อ ให้ใช้ routing นี้เป็นค่าเริ่มต้น:

| ประเภทงาน | Agent หลักที่ลงมือ | ขอบเขต |
|---|---|---|
| Review code, review plan, security review, regression review | Claude | อ่านและตรวจ code path, diff, risk และสรุป finding/evidence |
| Test design, test execution, verification และ QA check | Claude | สร้าง/รัน test, ตรวจผล และรายงาน `[OK]` หรือ `[BLOCKED]` |
| Development, bug fix และ implementation | Codex | แก้ source code, refactor, integration และ commit-ready diff |
| Documentation, task, ADR, glossary และ handoff artifact | Codex | แก้เอกสารใน repository ให้สอดคล้องกับ source of truth |
| Architecture decision หรือ scope ที่ยังไม่ชัด | Base agent + Reviewer | base agent ประสาน; ถ้าต้องการมุมมองเพิ่มให้เรียก Claude review ก่อน Codex ลงมือ |

Routing นี้เป็น **default executor assignment** ไม่ได้ย้าย ownership: base agent ตัวแรกยังคงเป็นผู้จัดลำดับ, อนุมัติการส่งต่อ, รวมผล และรายงานผู้ใช้. หากผู้ใช้ระบุ agent อื่นโดยตรง ให้ถือคำสั่งผู้ใช้เป็น priority สูงสุด.

ลำดับมาตรฐานสำหรับงานพัฒนาเต็มวงจรคือ: **base agent วาง scope → Codex แก้ไข → Claude review/test → Codex แก้ตาม finding → base agent สรุป handoff**. หากงานเล็กจนไม่คุ้มกับการส่งต่อ ให้ base agent ทำเองตามกติกา token budget.

| Role | หน้าที่หลัก | เหมาะกับงาน |
|---|---|---|
| Tech Lead / Coordinator | แตกงาน, จัดลำดับ, ตรวจ dependency, ตัดสินใจ handoff | งานหลาย subsystem หรือหลาย agent |
| Researcher | ค้นเอกสาร, ตรวจข้อเท็จจริง, สรุปทางเลือกพร้อมแหล่งอ้างอิง | API, library, product decision |
| Architect / Reviewer | ตรวจ intent, interface, blast radius, security และความง่ายของทางเลือก | refactor ใหญ่, public API, auth, billing, migration |
| Backend Developer | แก้ service, domain logic, API, persistence และ tests | งาน backend |
| Frontend Developer | แก้ UI, interaction, accessibility และ visual verification | งาน frontend |
| Database Engineer | schema, migration, index, RLS, query และ rollback | งาน database |
| Integration Engineer | MCP, external service, webhook, auth boundary | งานเชื่อมต่อระบบ |
| QA / Test Engineer | ออกแบบ test จาก behavior, regression และ acceptance evidence | งานที่ test strategy สำคัญ |
| Security Reviewer | ตรวจ secret handling, trust boundary, permission และข้อมูลรั่วไหล | งาน security-sensitive |
| Docs / Knowledge Curator | บันทึก decision, glossary, context และ runbook | งานที่ต้อง handoff หรือทำซ้ำ |

### กติกาเลือก role

- งานเล็กและชัดเจน: role เดียวทำครบได้
- งานข้าม service, migration, auth, billing หรือ public API: ให้ Tech Lead ส่ง Reviewer และ Security Reviewer เข้าตรวจ
- งานที่ dependency ยังไม่รู้: เริ่ม Researcher หรือ Prototype ก่อน implementation
- งานที่ต้องแก้ symbol หลายไฟล์: ใช้ `serena-refactoring`; งานที่ต้องรู้ blast radius: ใช้ `codegraph-usage` หรือ `graft-usage`

## 4. Claude Code

### สิ่งที่ควรวางใน repository

- `CLAUDE.md`: กติกาถาวร, architecture, test standard และ pointers
- `.claude/skills/<name>/SKILL.md`: workflow ที่ทำซ้ำได้; รองรับ supporting files
- `.claude/commands/`: convention เดิมยังใช้ได้ แต่ skill เป็นรูปแบบหลัก
- hooks: งานก่อน/หลัง action เช่น format, lint หรือ guardrail
- subagents: role เฉพาะ เช่น researcher, reviewer, security reviewer

Claude Code ใช้ `AGENTS.md` แทน `CLAUDE.md` ได้ใน repository ที่มีอยู่แล้ว และรองรับ MCP, skills, hooks, parallel agents และ Agent SDK ตามเอกสารทางการ [Claude Code overview](https://code.claude.com/docs/en/overview) และ [Claude Code skills](https://code.claude.com/docs/en/skills).

### แนวทางพัฒนา skill สำหรับ Claude

1. เขียน trigger ให้ชัดว่า skill ใช้เมื่อใด
2. ให้ `SKILL.md` มีขั้นตอนสั้นและ completion criteria
3. ย้าย reference ยาว, template และ script ออกไปไว้ข้างเคียง
4. แยก skill ที่เป็น procedure ออกจาก `CLAUDE.md` ที่เป็น invariant
5. ทดสอบทั้งกรณีที่ควร trigger และไม่ควร trigger

### Role ที่เหมาะกับ Claude

ใช้ Claude เป็น **orchestrator / implementer / reviewer** ได้ดีเมื่อ task ต้องอ่าน codebase หลายไฟล์, เรียก tools ต่อเนื่อง, ใช้ subagent หรือทำ verification กับ running app.

## 5. Codex

### สิ่งที่ควรวางใน repository

- `AGENTS.md`: กติกาและแผนที่ของ repository; Codex รวมคำแนะนำจาก global ไปยัง directory ที่ลึกขึ้น
- `SKILL.md`: workflow ที่ reusable พร้อม resources หรือ scripts
- `docs/`: source of truth สำหรับ architecture, decision, plans และ handoff
- `harness/` หรือโครงสร้างเทียบเท่า: เก็บ phase context, build log และ review evidence เฉพาะเมื่อโครงการต้องการ

Codex รองรับ Agent Skills แบบ `SKILL.md`, `AGENTS.md`, MCP และ multi-agent orchestration. รายละเอียดเรื่องการ merge `AGENTS.md` และ skill อยู่ใน [Codex prompting guide](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide), [OpenAI Skills](https://developers.openai.com/api/docs/guides/tools-skills) และ [Agents API](https://developers.openai.com/api/docs/guides/agents-api/overview).

### แนวทางพัฒนา skill สำหรับ Codex

1. ทำ `AGENTS.md` ให้เป็น index และ link ไป source of truth แทนการยัดรายละเอียดทั้งหมด
2. ใช้ skill ตาม capability ไม่ใช่ตามชื่อทีม เช่น `safe-migration`, `debug-failure`, `review-api`
3. ระบุ command สำหรับ test และหลักฐานที่ต้องแนบใน handoff
4. เก็บ context ที่เปลี่ยนตาม phase แยกจากกติกาถาวร
5. ทบทวน description ของ skill เป็นระยะเพื่อลด context bloat

### Role ที่เหมาะกับ Codex

ใช้ Codex เป็น **worker ที่แก้ code จริง, coordinator ของงานหลายขั้น และ reviewer ที่ต้องการ evidence จาก shell/test/git**. รูปแบบที่เหมาะคือ task เล็ก, branch/worktree ชัด, acceptance criteria ตรวจได้.

## 6. Antigravity

### สถานะในเครื่องนี้

จาก path ที่สำรวจไม่พบ installation/config ของ Antigravity ใน workspace นี้ จึงยังไม่มี local inventory ของ skill หรือ role ของ Antigravity; ส่วนนี้เป็นแนวทางเตรียม repository ให้รองรับ ไม่ใช่หลักฐานว่าติดตั้งแล้ว

### โครงสร้างที่ควรเตรียม

- `.agents/rules/`: rules แบบ persistent เช่น coding constraints และ architecture invariants
- `.agents/skills/<name>/SKILL.md`: skill แบบ reusable และ progressive disclosure
- `.agents/workflows/`: workflow แบบเรียกใช้เป็นลำดับเมื่อผู้ใช้ต้องการ
- `AGENTS.md` หรือ `GEMINI.md`: กติการะดับ directory/workspace

Antigravity แยก rule สำหรับ constraint ออกจาก skill สำหรับ multi-step workflow และ workflow สำหรับ sequence ที่เรียกใช้ตามต้องการ. ตำแหน่งและการค้นหา skill/rule อ้างอิง [Antigravity skills](https://www.antigravity.google/docs/skills), [Antigravity rules](https://www.antigravity.google/docs/rules-workflows) และ [Antigravity agent](https://www.antigravity.google/docs/agent/). เอกสารทางการระบุว่า workflow รุ่นปัจจุบันมีแผนหยุดทำงานวันที่ 2026-10-19 จึงควรออกแบบของใหม่ให้ย้ายไป Agent Skills ได้.

### Role ที่เหมาะกับ Antigravity

ใช้ Antigravity เป็น **agent-first executor** สำหรับงานที่ต้องใช้ editor, terminal, browser, artifacts และการตรวจผลแบบ end-to-end. ควรแยก role ผ่าน rule/skill/workflow มากกว่าการทำ prompt ยาวก้อนเดียว.

## 7. รูปแบบ task สำหรับการทำทีละตัว

ใช้ไฟล์ `docs/tasks/<task-id>.md` ต่อหนึ่ง task และตั้งชื่อแบบ `AI-###-short-name`.

### Template

```md
# AI-###: <ชื่อ task>

สถานะ: proposed | ready | in-progress | blocked | review | done
Owner role: <role>
Target surface: Claude | Codex | Antigravity | shared
Dependencies: <task IDs หรือ none>

## Goal
<ผลลัพธ์ที่ต้องการและเหตุผล>

## Scope
- In scope: ...
- Out of scope: ...

## Acceptance criteria
- [ ] ...
- [ ] ...

## Implementation steps
1. ...
2. ...

## Verification
- Command / UI flow: ...
- Expected evidence: ...

## Handoff
- Changed files: ...
- Decisions: ...
- Tests and results: ...
- Known limitations: ...
- Next owner: ...
```

## 8. Backlog แนะนำสำหรับพัฒนาทีละตัว

| ID | Task | Surface | Owner role | Done เมื่อ |
|---|---|---|---|---|
| AI-001 | สร้าง `docs/` index และ source-of-truth map | shared | Docs / Knowledge Curator | มี index ที่ชี้ architecture, decisions, tasks และ handoff |
| AI-002 | ปรับ `AGENTS.md` ให้เป็นแผนที่สั้นและชี้เอกสารนี้ | Codex / shared | Tech Lead | ไม่มี rule ซ้ำและทุก pointer ใช้งานได้ |
| AI-003 | สร้าง skill `task-handoff` แบบ shared Agent Skills | shared | Docs / Knowledge Curator | มี `SKILL.md`, trigger, template และ verification |
| AI-004 | สร้าง Codex skill `verify-change` | Codex | QA / Test Engineer | task code ทุกชิ้นระบุ command และ evidence ได้ |
| AI-005 | สร้าง Claude skill `review-change` และ hook ที่จำเป็น | Claude | Reviewer | skill trigger ถูกและไม่รันงานแพงโดยไม่จำเป็น |
| AI-006 | สร้าง Antigravity `.agents/rules` ชุดเล็ก | Antigravity | Architect / Reviewer | rules แยกจาก workflows และไม่ซ้ำกับ `AGENTS.md` |
| AI-007 | สร้าง Antigravity workflow สำหรับ bug-to-verified-fix | Antigravity | Debugger / QA | workflow จบด้วย evidence และ handoff |
| AI-008 | เพิ่ม role-specific handoff examples 3 แบบ | shared | Tech Lead | มี backend, frontend และ research example |
| AI-009 | ทำ eval set สำหรับ skill trigger | shared | QA / Test Engineer | มี positive/negative prompts และผลรอบ baseline |
| AI-010 | ตรวจ drift ของ skill และเอกสารทุก release | shared | Docs / Knowledge Curator | มี checklist และ owner รอบตรวจ |
| AI-011 | เปลี่ยน coordination เป็น base-agent-first | shared | Tech Lead / Coordinator | agent ตัวแรกถือ ownership, spawn ตามเกณฑ์ และถามก่อนเมื่อ token ไม่คุ้ม |

## 9. Handoff contract

ผู้ส่งต้องสรุปตามลำดับนี้เสมอ:

1. **Outcome:** ทำสำเร็จอะไร
2. **Evidence:** test, command, screenshot, diff หรือ source ที่ยืนยัน
3. **Changed surface:** ไฟล์, service, skill หรือ config ที่แตะ
4. **Decisions:** เลือกแนวทางใดและเพราะอะไร
5. **Risks / limitations:** สิ่งที่ยังไม่ครอบคลุม
6. **Next action:** งานถัดไป, owner และ dependency
7. **Status:** `[OK]`, `BLOCKED`, `NOT TESTED` หรือ `READY FOR REVIEW`

### Base-agent handoff เพิ่มเติม

เมื่อมีการส่งงานไป worker หรือ sub-agent ต้องระบุ `base agent`, `worker role`, `delegation reason`, `token rationale`, `input boundary`, `expected output` และ `return deadline/condition`. Worker ส่งผลกลับ base agent เท่านั้น; ผู้ใช้รับรายงานรวมจาก base agent.

หากติดขัด ให้ระบุ error เดิม, สิ่งที่ลองแล้ว, ไฟล์ที่เปลี่ยน และสิ่งที่ต้องการจาก role ถัดไป ห้ามส่งต่อเพียงคำว่า “ทำต่อไม่ได้”.

## 10. Checklist ก่อนถือว่างานเสร็จ

- [ ] skill/role ที่ใช้ตรงกับงานและไม่โหลดรายละเอียดเกินจำเป็น
- [ ] task มี acceptance criteria และ owner ถัดไป
- [ ] มี verification evidence ที่ทำซ้ำได้
- [ ] ไม่มี secret หรือ machine-specific state ใน diff
- [ ] เอกสารที่เปลี่ยนไม่ซ้ำกับ source of truth อื่น
- [ ] handoff ระบุ changed files, decisions, risks และ next action ครบ

## แหล่งอ้างอิง

- Anthropic: [Claude Code overview](https://code.claude.com/docs/en/overview), [skills](https://code.claude.com/docs/en/skills), [subagents](https://code.claude.com/docs/en/sub-agents)
- OpenAI: [Codex prompting guide](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide), [Skills](https://developers.openai.com/api/docs/guides/tools-skills), [Agents API](https://developers.openai.com/api/docs/guides/agents-api/overview)
- Google: [Antigravity skills](https://www.antigravity.google/docs/skills), [rules and workflows](https://www.antigravity.google/docs/rules-workflows), [agent](https://www.antigravity.google/docs/agent/)
