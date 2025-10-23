---
tags: [workflow, claude, cursor, ai-collaboration, teardown-cafe]
created: 2025-10-20
---

# Claude-Cursor Workflow

Collaborative AI workflow where Claude handles architecture/content and Cursor handles implementation.

## Division of Labor

### Claude (Architecture & Content)
- System design and feature specs
- Content creation (teardown entries)
- Image optimization
- Tag strategy
- Commit message design

### Cursor (Implementation)
- Code execution from specs
- Component building
- Technical implementation
- Git operations
- Bug fixes

## Workflow Pattern

```
1. Claude: Creates spec in .cursor-specs/
2. Cursor: Implements from spec
3. Claude: Reviews, iterates if needed
4. Cursor: Commits changes
```

## Spec Documents

Located in `.cursor-specs/`:
- Feature specifications
- Component requirements
- Implementation details
- Success criteria

**Example spec structure:**
```markdown
# Feature Name

## Overview
What and why

## Implementation
- File locations
- Code requirements
- Styling notes

## Success Criteria
How to verify it works
```

## Communication Handoffs

**Session State Files:**
- `.context/current-state.json` - Project status
- `.context/last-change-summary.md` - Recent changes
- `.context/next-ai-context.md` - What to do next

Scripts handle context generation automatically.

## Key Insights

**Strengths:**
- Claude: Creative ideation, content quality, system architecture
- Cursor: Precise code execution, faster implementation

**Efficiency gains:**
- No context switching between planning and coding
- Specs provide clear implementation targets
- Manual corrections only when needed

## Related
- [[Teardown Cafe - Technical Setup]]
- [[Teardown Cafe - Deployment Guide]]
