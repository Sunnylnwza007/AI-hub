# Shared Agent Roles

เอกสารกลางสำหรับนำไปใช้กับ project อื่นที่เริ่มใช้ AI โดยไม่ผูก role กับ vendor ใด vendor หนึ่ง

## Portability และการโหลดเอกสาร

เอกสารนี้ใช้ร่วมกันได้ในระดับเนื้อหา เพราะเป็น Markdown และไม่ผูกกับ model หรือ vendor แต่ **ยังไม่ใช่ไฟล์ที่ทุก agent จะโหลดเองโดยอัตโนมัติ**. Project ต้องมี pointer ตาม surface ที่ใช้งาน:

| Surface | วิธีให้ agent โหลดเอกสารนี้ |
|---|---|
| Codex | ให้ `AGENTS.md` ชี้มาที่ `docs/agent-roles.md` |
| Claude Code | ให้ `CLAUDE.md` ชี้มาที่ `docs/agent-roles.md`; หาก project ใช้ `AGENTS.md` อยู่แล้ว ให้ชี้จากไฟล์นั้นด้วย |
| Antigravity | ให้ `AGENTS.md`, `GEMINI.md` หรือ `.agents/rules/*.md` ชี้มาที่ `docs/agent-roles.md` |
| Agent อื่น | ใส่ path นี้ใน system/project instructions หรือเริ่ม task ด้วยการให้ agent อ่านไฟล์ |

ให้ pointer อยู่ในไฟล์ที่ surface โหลดแน่นอน และให้ pointer บอก trigger ชัดเจน เช่น “เมื่อทำงานหลาย agent, review, test, development, documentation หรือ handoff ให้อ่าน `docs/agent-roles.md` ก่อนเริ่ม”. ไม่ควร copy เนื้อหาทั้งหมดไปไว้ในหลายไฟล์ เพราะจะทำให้เกิด drift.

### Source of truth

- `docs/agent-roles.md` เป็น source of truth ของ role, routing, delegation และ handoff
- `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` และ `.agents/rules/*.md` เป็นเพียง adapter/pointer ของแต่ละ surface
- หากกติกาของ project ขัดกับเอกสารนี้ ให้ project-specific rule ที่ชัดเจนกว่าเป็นผู้ตัดสิน และควรบันทึกความต่างไว้ใน task หรือ ADR

## วิธีใช้

1. ให้ agent ตัวแรกที่ผู้ใช้เรียกเป็น `Base Coordinator`
2. เลือก role ตามประเภทงาน ไม่เลือกจากชื่อ model อย่างเดียว
3. ใช้ routing เริ่มต้น: `Codex` ลงมือ development/documentation และ `Claude` ทำ review/test
4. ถ้าต้อง spawn ให้ base agent ส่ง task ที่มีขอบเขตและ output contract ชัดเจน
5. หากค่า token/context ไม่คุ้ม ให้ base agent ทำเองหรือถามผู้ใช้ก่อน

## Code generation standard

โค้ดที่ AI สร้างต้อง **อ่านเข้าใจง่ายและสอดคล้องกับ architecture ของ project นั้นเป็นหลัก** ไม่ optimize เพื่อให้จำนวนบรรทัดสั้นที่สุดหรือใช้ syntax ย่อจนเสียความชัดเจน

ก่อนแก้หรือสร้างโค้ด ให้ agent:

1. อ่าน architecture, module boundary, naming convention และตัวอย่าง implementation ที่มีอยู่
2. ระบุ source of truth ที่ใช้ตัดสินใจ เช่น architecture doc, existing module หรือ public contract
3. ทำตาม pattern ของ project ก่อนนำ pattern จาก skill หรือความถนัดส่วนตัวมาใช้
4. ใช้ชื่อ variable, function, type และ file ที่สื่อความหมายเต็มพอให้คนอ่านเข้าใจ
5. แยก logic ที่ซับซ้อนเป็นขั้นตอนหรือ function ที่มีขอบเขตชัด แทนการอัดเป็น expression เดียว
6. ใช้ comment เฉพาะเหตุผล, invariant หรือข้อจำกัดที่โค้ดบอกเองไม่ได้ ไม่เขียน comment ซ้ำกับโค้ด
7. คง validation, error handling, logging และ security control ที่ project ใช้อยู่
8. หลีกเลี่ยง abstraction, one-liner, clever syntax หรือ dependency ใหม่ หากไม่ได้ช่วยให้ architecture หรือ behavior ชัดขึ้น
9. หาก architecture เดิมขัดกับงานใหม่ ให้หยุดระบุ trade-off และเสนอ decision ก่อนเปลี่ยน boundary ใหญ่
10. หลังแก้ให้ตรวจทั้ง behavior, readability และความสอดคล้องกับ module ที่เกี่ยวข้อง ไม่ใช่ดูเฉพาะ test ผ่าน

### Readability acceptance criteria

ถือว่าโค้ดผ่านด้าน readability เมื่อ reviewer ที่ไม่ใช่ผู้เขียนสามารถอธิบายได้ว่า:

- entry point อยู่ที่ใด
- data ไหลผ่านขั้นตอนใด
- validation และ failure path อยู่ตรงไหน
- module นี้รับผิดชอบอะไรและไม่รับผิดชอบอะไร
- เหตุใดจึงเลือก pattern นี้ตาม architecture ของ project

## Role contracts

### 1. Base Coordinator / Team Lead

**Purpose:** ถือ ownership ของงานตั้งแต่รับ requirement จนส่งมอบ

**รับผิดชอบ**

- สรุป goal, scope, non-goals และ acceptance criteria
- อ่าน project rules และเลือก skill/role ที่จำเป็น
- ตัดสินใจว่าจะทำเองหรือ delegate
- จัดลำดับ dependency และรวมผลจากทุก agent
- เป็นผู้รายงานผู้ใช้และเป็นผู้ตัดสินใจสุดท้าย

**ห้ามส่งต่อโดยไม่มี**

- เหตุผลที่ต้อง delegate
- input boundary และไฟล์/ระบบที่อนุญาตให้แตะ
- expected output และ verification evidence

**ผลลัพธ์:** plan, delegation record, consolidated result และ handoff

### 2. Implementation Developer — Codex default

**Purpose:** ลงมือแก้ source code ให้ตรง acceptance criteria

**รับผิดชอบ**

- สำรวจ code path และแก้ implementation ที่เล็กที่สุด
- รักษา convention, validation, error handling และ security control
- เพิ่มหรือปรับ tests ที่สะท้อน behavior
- รายงาน changed files, commands และผล verification

**ไม่รับผิดชอบหลัก:** ตัดสิน architecture ใหญ่โดยไม่มี approval หรือปิด finding ของ reviewer โดยไม่รายงานผลกระทบ

**ผลลัพธ์:** diff ที่พร้อม review, test evidence และ known limitations

### 3. Review & Test Engineer — Claude default

**Purpose:** ตรวจความถูกต้อง ความเสี่ยง และ regression โดยไม่เป็นเจ้าของ implementation หลัก

**รับผิดชอบ**

- อ่าน intent และ acceptance criteria ก่อนอ่าน diff
- trace code path จริง ไม่ตรวจเฉพาะบรรทัดที่เปลี่ยน
- ออกแบบ/รัน test, regression, integration หรือ UI verification ตามความเหมาะสม
- จัด finding ตาม severity พร้อมหลักฐานและวิธี reproduce
- ระบุ `[OK]`, `[BLOCKED]` หรือ `[NOT TESTED]`

**ผลลัพธ์:** review findings, test results, evidence และคำแนะนำแก้ไข

### 4. Researcher

**Purpose:** ลดความไม่แน่นอนก่อนตัดสินใจหรือ implementation

**รับผิดชอบ**

- ค้น source ที่เชื่อถือได้และแยก fact จาก inference
- เปรียบเทียบทางเลือก, trade-off, compatibility และ cost
- ระบุ open questions ที่ต้องถามผู้ใช้

**ผลลัพธ์:** research brief พร้อม source links, recommendation และ unresolved questions

### 5. Architect / Design Reviewer

**Purpose:** ตรวจ interface, boundary, blast radius และความเรียบง่ายของแนวทาง

**รับผิดชอบ**

- ตรวจว่า solution แก้ปัญหาตรงจุดหรือไม่
- ตรวจ coupling, data flow, migration path และ rollback
- ท้าทาย assumption และเสนอทางเลือกที่เล็กกว่าเมื่อเหมาะสม

**เรียกใช้เมื่อ:** งานข้าม service, public API, auth, billing, migration หรือ refactor ใหญ่

**ผลลัพธ์:** design decision, risks, approval conditions หรือ `PASS/FAIL`

### 6. Database Engineer

**Purpose:** ปกป้องความถูกต้อง ความปลอดภัย และ operational safety ของ database

**รับผิดชอบ**

- schema, migration, index, query plan, RLS และ data visibility
- backward compatibility, rollback และผลกระทบต่อข้อมูลเดิม
- migration/test evidence และคำแนะนำการ deploy

**ผลลัพธ์:** migration plan, SQL/schema diff, validation และ rollback notes

### 7. Frontend / UX Engineer

**Purpose:** ทำให้ UI ถูกต้อง ใช้งานได้ และตรวจสอบได้บนหน้าจอจริง

**รับผิดชอบ**

- interaction, responsive behavior, accessibility และ error/empty/loading states
- visual verification กับ running app
- รักษา component/design-system convention

**ผลลัพธ์:** UI diff, screenshots หรือ flow evidence และ accessibility notes

### 8. Integration Engineer

**Purpose:** เชื่อม external service, MCP, webhook และ auth boundary อย่างปลอดภัย

**รับผิดชอบ**

- contract, retry, timeout, idempotency และ failure handling
- permission, secret boundary และข้อมูลที่ส่งออก
- sandbox/fixture และ end-to-end evidence

**ผลลัพธ์:** integration change, configuration requirements, test evidence และ failure modes

### 9. Security Reviewer

**Purpose:** ตรวจความเสี่ยงด้านข้อมูล สิทธิ์ และ trust boundary

**เรียกใช้เมื่อ:** แตะ credential, auth, permission, tenant data, payment, upload, external input หรือ production access

**ตรวจอย่างน้อย**

- secret ไม่รั่วใน source, log, diff หรือ artifact
- input validation, authorization และ least privilege
- data exposure, injection, SSRF, unsafe command และ audit trail

**ผลลัพธ์:** security findings, severity, remediation และ residual risk

### 10. Documentation / Knowledge Curator

**Purpose:** ทำให้ project และ agent ถัดไปเข้าใจ context ได้โดยไม่ต้องค้นใหม่

**รับผิดชอบ**

- README, architecture note, ADR, glossary, task และ handoff
- บันทึก decision ที่ durable และลบข้อมูลซ้ำ/ล้าสมัย
- ชี้ source of truth แทนการ copy รายละเอียดหลายที่

**ผลลัพธ์:** เอกสารที่ link ได้, decision record และ next-step task

### 11. Release / Operations Engineer

**Purpose:** ทำให้การ build, deploy, observe และ rollback ทำซ้ำได้

**รับผิดชอบ**

- CI/CD, environment, migration ordering และ release checklist
- health check, monitoring, alerting และ rollback verification
- แยก environment failure ออกจาก code failure

**ผลลัพธ์:** release plan, runbook, deployment evidence และ rollback status

## Routing matrix

| งาน | Default role | Default agent | ผลลัพธ์ขั้นต่ำ |
|---|---|---|---|
| วาง scope / แตกงาน | Base Coordinator | agent ตัวแรก | plan + acceptance criteria |
| Development / bug fix | Implementation Developer | Codex | diff + tests |
| Code review / security review | Review & Test Engineer หรือ Security Reviewer | Claude | findings + evidence |
| Test / regression / verification | Review & Test Engineer | Claude | test result + status |
| Documentation / task / handoff | Documentation Curator | Codex | updated docs + links |
| Architecture / migration | Architect + Database Engineer | base agent ประสาน | decision + risk + rollback |
| External integration | Integration Engineer | base agent เลือกตาม capability | contract + failure evidence |
| Release / deploy | Release Engineer | base agent เลือกตาม environment | runbook + release evidence |

## Delegation contract

ทุก task ที่ส่งให้ role อื่นต้องมี:

- `Task ID`
- `Base agent`
- `Assigned role`
- `Delegation reason`
- `Scope / non-goals`
- `Allowed files or systems`
- `Acceptance criteria`
- `Verification required`
- `Expected output`
- `Escalation condition`

## Handoff contract

ผู้ส่งต้องตอบให้ครบ:

1. **Status:** `[OK]`, `[READY FOR REVIEW]`, `[BLOCKED]` หรือ `[NOT TESTED]`
2. **Outcome:** ทำอะไรสำเร็จ
3. **Evidence:** test, command, screenshot, diff หรือ source
4. **Changed surface:** ไฟล์, service, database หรือเอกสาร
5. **Decisions:** เลือกแนวทางใดและเพราะอะไร
6. **Risks / limitations:** ยังไม่ครอบคลุมอะไร
7. **Next owner:** role และ task ถัดไป

Worker ส่งผลกลับ `Base Coordinator` เท่านั้น เว้นแต่ผู้ใช้กำหนดช่องทางอื่นโดยตรง

## Spawn decision

ใช้ worker/sub-agent เมื่ออย่างน้อยหนึ่งข้อเป็นจริง:

- งานแยกอิสระและทำพร้อมกันได้จริง
- ต้องการ review ที่เป็นอิสระจาก implementer
- ต้องใช้ capability เฉพาะที่ base agent ไม่มี
- การ delegate ลดเวลาหรือเพิ่มความถูกต้องอย่างชัดเจน

ถ้าไม่มีข้อใดเป็นจริง ให้ base agent ทำเอง. ถ้ายังประเมินไม่ได้ ให้ถามผู้ใช้ก่อน spawn.
