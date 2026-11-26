# Agent Playbook Installation

เอกสารนี้ใช้เป็นคู่มือเดียวสำหรับติดตั้งแนวทางการทำงานของ AI agent ลงใน repository อื่น

## Source of truth

- Repository: [AI-hub](https://github.com/Sunnylnwza007/AI-hub)
- Manifest: [`install/manifest.yaml`](../install/manifest.yaml)
- Installer: [`tooling/install-agent-playbook.sh`](../tooling/install-agent-playbook.sh)
- Role, routing และ handoff: [`agent-roles.md`](agent-roles.md)
- Operating playbook: [`ai-agent-operating-playbook.md`](ai-agent-operating-playbook.md)

ใช้ tag หรือ commit ที่ต้องการให้ทุก project อ้างอิงตรงกัน แทนการติดตามไฟล์จาก `main` โดยไม่ pin version

## ติดตั้งใน project ใหม่

1. ดาวน์โหลด repository นี้จาก [AI-hub](https://github.com/Sunnylnwza007/AI-hub)
2. รัน `tooling/install-agent-playbook.sh --target <project-path>`
3. ตรวจไฟล์ที่ installer สร้างหรืออัปเดตใน `<project-path>/.ai-agent-playbook/`
4. ให้ agent อ่าน pointer ที่ installer เพิ่มใน `AGENTS.md`, `CLAUDE.md` หรือ `GEMINI.md`
5. รัน `tooling/install-agent-playbook.sh --target <project-path> --check` เพื่อตรวจความครบถ้วน

Installer จะสร้าง adapter เฉพาะเมื่อไฟล์ปลายทางยังไม่มีอยู่แล้ว หากมี `AGENTS.md`, `CLAUDE.md` หรือ `GEMINI.md` อยู่ก่อน จะเพิ่ม pointer ที่ไม่ซ้ำโดยไม่เขียนทับเนื้อหาเดิม

## สิ่งที่ติดตั้ง

- `docs/agent-roles.md`
- `docs/ai-agent-operating-playbook.md`
- `install/manifest.yaml`
- pointer สำหรับ Codex, Claude Code และ Antigravity

เอกสารนี้ไม่ติดตั้ง credential, token, environment variable หรือ skill ที่มีอยู่เฉพาะในเครื่องใดเครื่องหนึ่ง

## Verification

การติดตั้งถือว่าสำเร็จเมื่อ `--check` ผ่าน และ agent สามารถค้นพบไฟล์ playbook ผ่าน pointer ของ surface ที่ใช้งานอยู่
