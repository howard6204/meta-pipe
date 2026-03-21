# Meta-Pipe Dashboard GUI — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** A local web dashboard (`localhost:6666`) that visualizes all meta-analysis projects' progress, stage status, dependencies, and workflow.

**Architecture:** A monorepo `dashboard/` directory with a React + Vite frontend and a tiny Express API server. The API server spawns `uv run project_status.py` to get real data for each project. A single `pnpm serve` command starts both the API and serves the built frontend.

**Tech Stack:** React 19, Vite, TypeScript, Express, Tailwind CSS v4, pnpm

---

## Design Overview

```
dashboard/
├── package.json          # pnpm workspace, scripts: dev, build, serve
├── tsconfig.json
├── vite.config.ts
├── tailwind.config.ts
├── index.html
├── server.ts             # Express API (port 6666)
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── api.ts            # fetch helpers
│   ├── types.ts          # shared types
│   ├── components/
│   │   ├── ProjectCard.tsx
│   │   ├── StageTimeline.tsx
│   │   ├── DependencyGraph.tsx
│   │   └── Header.tsx
│   └── hooks/
│       └── useProjects.ts
└── public/
```

### API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/projects` | List all projects with status |
| GET | `/api/projects/:name` | Single project detail |
| GET | `/api/pipeline` | Pipeline stage definitions + dependencies |

### UI Layout

```
┌──────────────────────────────────────────────────┐
│  🔬 Meta-Pipe Dashboard                         │
├──────────────────────────────────────────────────┤
│  Pipeline Overview (dependency flow diagram)      │
│  [01] → [02] → [03] → [04] → [05] → [06] → ... │
├──────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │Project 1 │  │ Project 2 │  │ Project 3 │      │
│  │ ████░░░  │  │ ██████░  │  │ █░░░░░░  │       │
│  │ 33%      │  │ 67%      │  │ 11%      │       │
│  │ Stage 02 │  │ Stage 06 │  │ Stage 01 │       │
│  └──────────┘  └──────────┘  └──────────┘       │
│                                                   │
│  Selected Project: ici-breast-cancer              │
│  ┌─────────────────────────────────────────────┐ │
│  │ Stage Timeline (vertical)                    │ │
│  │ ✅ 01_protocol    — 6 files, 2026-02-10     │ │
│  │ 🔄 02_search      — 5 files, missing dedupe │ │
│  │ 🔄 03_screening   — 7 files                 │ │
│  │ ⬜ 04_fulltext    —                          │ │
│  │ ...                                          │ │
│  └─────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────┘
```

### Pipeline Dependencies (hardcoded from CLAUDE.md)

```
01_protocol → 02_search → 03_screening → 04_fulltext → 05_extraction
                                                             ↓
                                          06_analysis ←──────┘
                                              ↓
                                          07_manuscript → 08_reviews → 09_qa
```

Additionally, at stage 03b, an analysis type gate determines if 06a (pairwise) or 06b (NMA) is used.

---

## Task 1: Scaffold dashboard project with pnpm + Vite + React + TS

**Files:**
- Create: `dashboard/package.json`
- Create: `dashboard/tsconfig.json`
- Create: `dashboard/tsconfig.node.json`
- Create: `dashboard/vite.config.ts`
- Create: `dashboard/index.html`
- Create: `dashboard/src/main.tsx`
- Create: `dashboard/src/App.tsx`
- Create: `dashboard/src/vite-env.d.ts`
- Modify: `.gitignore` (add `dashboard/node_modules`, `dashboard/dist`)

**Step 1: Create `dashboard/package.json`**

```json
{
  "name": "meta-pipe-dashboard",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "serve": "node --import tsx server.ts"
  },
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "devDependencies": {
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "@vitejs/plugin-react": "^4.4.0",
    "typescript": "^5.7.0",
    "vite": "^6.0.0",
    "express": "^5.0.0",
    "@types/express": "^5.0.0",
    "tsx": "^4.19.0",
    "tailwindcss": "^4.0.0",
    "@tailwindcss/vite": "^4.0.0"
  }
}
```

**Step 2: Create Vite config**

`dashboard/vite.config.ts`:
```ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    proxy: {
      "/api": "http://localhost:6666",
    },
  },
});
```

**Step 3: Create minimal `index.html`, `src/main.tsx`, `src/App.tsx`**

`dashboard/index.html`:
```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Meta-Pipe Dashboard</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

`dashboard/src/main.tsx`:
```tsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./index.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <App />
  </StrictMode>
);
```

`dashboard/src/index.css`:
```css
@import "tailwindcss";
```

`dashboard/src/App.tsx`:
```tsx
export default function App() {
  return (
    <div className="min-h-screen bg-gray-950 text-gray-100 p-8">
      <h1 className="text-3xl font-bold">Meta-Pipe Dashboard</h1>
      <p className="text-gray-400 mt-2">Loading...</p>
    </div>
  );
}
```

**Step 4: Create TypeScript configs**

`dashboard/tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "jsx": "react-jsx",
    "strict": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "noEmit": true,
    "isolatedModules": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

`dashboard/tsconfig.node.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "noEmit": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["vite.config.ts"]
}
```

**Step 5: Install dependencies**

```bash
cd dashboard && pnpm install
```

**Step 6: Verify dev server starts**

```bash
cd dashboard && pnpm dev
# Expected: Vite server starts on localhost:5173
# Ctrl+C to stop
```

**Step 7: Update root `.gitignore`**

Append:
```
dashboard/node_modules/
dashboard/dist/
```

**Step 8: Commit**

```bash
git add dashboard/ .gitignore
git commit -m "feat(dashboard): scaffold Vite + React + Tailwind project"
```

---

## Task 2: Types and API client

**Files:**
- Create: `dashboard/src/types.ts`
- Create: `dashboard/src/api.ts`

**Step 1: Define TypeScript types matching `project_status.py` JSON output**

`dashboard/src/types.ts`:
```ts
export interface StageStatus {
  stage: string;
  name: string;
  exists: boolean;
  validated: boolean;
  key_files_present: string[];
  key_files_missing: string[];
  file_count: number;
  last_modified: string | null;
}

export interface ProjectStatus {
  project_name: string;
  project_root: string;
  timestamp: string;
  stages: Record<string, StageStatus>;
  current_stage: string | null;
  completion_percentage: number;
  next_action: string;
}

export interface PipelineStage {
  id: string;
  name: string;
  depends_on: string[];
}

export const PIPELINE_STAGES: PipelineStage[] = [
  { id: "01_protocol", name: "Protocol", depends_on: [] },
  { id: "02_search", name: "Search", depends_on: ["01_protocol"] },
  { id: "03_screening", name: "Screening", depends_on: ["02_search"] },
  { id: "04_fulltext", name: "Full-text", depends_on: ["03_screening"] },
  { id: "05_extraction", name: "Extraction", depends_on: ["04_fulltext"] },
  { id: "06_analysis", name: "Analysis", depends_on: ["05_extraction"] },
  { id: "07_manuscript", name: "Manuscript", depends_on: ["06_analysis"] },
  { id: "08_reviews", name: "Reviews", depends_on: ["07_manuscript"] },
  { id: "09_qa", name: "QA", depends_on: ["08_reviews"] },
];
```

**Step 2: Create API client**

`dashboard/src/api.ts`:
```ts
import type { ProjectStatus } from "./types";

const BASE = "/api";

export async function fetchProjects(): Promise<ProjectStatus[]> {
  const res = await fetch(`${BASE}/projects`);
  if (!res.ok) throw new Error(`Failed to fetch projects: ${res.status}`);
  return res.json();
}

export async function fetchProject(name: string): Promise<ProjectStatus> {
  const res = await fetch(`${BASE}/projects/${encodeURIComponent(name)}`);
  if (!res.ok) throw new Error(`Failed to fetch project: ${res.status}`);
  return res.json();
}
```

**Step 3: Commit**

```bash
git add dashboard/src/types.ts dashboard/src/api.ts
git commit -m "feat(dashboard): add TypeScript types and API client"
```

---

## Task 3: Express API server

**Files:**
- Create: `dashboard/server.ts`

**Step 1: Write the Express server**

`dashboard/server.ts`:
```ts
import express from "express";
import { execFile } from "node:child_process";
import { readdir } from "node:fs/promises";
import { join, resolve } from "node:path";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

const app = express();
const PORT = 6666;

// Resolve paths relative to this script's location
const REPO_ROOT = resolve(import.meta.dirname, "..");
const PROJECTS_DIR = join(REPO_ROOT, "projects");
const STATUS_SCRIPT = join(REPO_ROOT, "tooling", "python", "project_status.py");

// Serve built frontend in production
app.use(express.static(join(import.meta.dirname, "dist")));

async function listProjectNames(): Promise<string[]> {
  const entries = await readdir(PROJECTS_DIR, { withFileTypes: true });
  return entries
    .filter((e) => e.isDirectory() && e.name !== "legacy" && !e.name.startsWith("."))
    .map((e) => e.name)
    .sort();
}

async function getProjectStatus(name: string) {
  const projectPath = join(PROJECTS_DIR, name);
  const { stdout } = await execFileAsync("uv", ["run", STATUS_SCRIPT, "--project", projectPath, "--json", "/dev/stdout"], {
    cwd: join(REPO_ROOT, "tooling", "python"),
    timeout: 15000,
  });

  // project_status.py outputs JSON then prints a report — extract only the JSON
  const jsonEnd = stdout.lastIndexOf("}");
  const jsonStr = stdout.slice(0, jsonEnd + 1);
  return JSON.parse(jsonStr);
}

// --- Routes ---

app.get("/api/projects", async (_req, res) => {
  try {
    const names = await listProjectNames();
    const statuses = await Promise.all(
      names.map(async (name) => {
        try {
          return await getProjectStatus(name);
        } catch {
          return { project_name: name, error: true, completion_percentage: 0, stages: {} };
        }
      })
    );
    res.json(statuses);
  } catch (err) {
    res.status(500).json({ error: String(err) });
  }
});

app.get("/api/projects/:name", async (req, res) => {
  try {
    const status = await getProjectStatus(req.params.name);
    res.json(status);
  } catch (err) {
    res.status(500).json({ error: String(err) });
  }
});

app.get("/api/pipeline", (_req, res) => {
  res.json({
    stages: [
      { id: "01_protocol", name: "Protocol Development", depends_on: [] },
      { id: "02_search", name: "Literature Search", depends_on: ["01_protocol"] },
      { id: "03_screening", name: "Title/Abstract Screening", depends_on: ["02_search"] },
      { id: "04_fulltext", name: "Full-text Retrieval", depends_on: ["03_screening"] },
      { id: "05_extraction", name: "Data Extraction", depends_on: ["04_fulltext"] },
      { id: "06_analysis", name: "Meta-Analysis", depends_on: ["05_extraction"] },
      { id: "07_manuscript", name: "Manuscript Assembly", depends_on: ["06_analysis"] },
      { id: "08_reviews", name: "GRADE Assessment", depends_on: ["07_manuscript"] },
      { id: "09_qa", name: "Quality Assurance", depends_on: ["08_reviews"] },
    ],
  });
});

// SPA fallback — serve index.html for non-API routes
app.get("*", (_req, res) => {
  res.sendFile(join(import.meta.dirname, "dist", "index.html"));
});

app.listen(PORT, () => {
  console.log(`🔬 Meta-Pipe Dashboard running at http://localhost:${PORT}`);
});
```

**Step 2: Test the API**

```bash
cd dashboard && pnpm serve &
sleep 2
curl -s http://localhost:6666/api/projects | head -c 500
# Expected: JSON array with project statuses
kill %1
```

**Step 3: Commit**

```bash
git add dashboard/server.ts
git commit -m "feat(dashboard): add Express API server calling project_status.py"
```

---

## Task 4: useProjects hook

**Files:**
- Create: `dashboard/src/hooks/useProjects.ts`

**Step 1: Write the hook**

`dashboard/src/hooks/useProjects.ts`:
```ts
import { useEffect, useState } from "react";
import type { ProjectStatus } from "../types";
import { fetchProjects } from "../api";

export function useProjects() {
  const [projects, setProjects] = useState<ProjectStatus[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      try {
        const data = await fetchProjects();
        if (!cancelled) {
          setProjects(data);
          setLoading(false);
        }
      } catch (err) {
        if (!cancelled) {
          setError(String(err));
          setLoading(false);
        }
      }
    }

    load();

    // Auto-refresh every 30 seconds
    const interval = setInterval(load, 30_000);

    return () => {
      cancelled = true;
      clearInterval(interval);
    };
  }, []);

  return { projects, loading, error };
}
```

**Step 2: Commit**

```bash
git add dashboard/src/hooks/useProjects.ts
git commit -m "feat(dashboard): add useProjects data hook with auto-refresh"
```

---

## Task 5: Header component

**Files:**
- Create: `dashboard/src/components/Header.tsx`

**Step 1: Write Header**

`dashboard/src/components/Header.tsx`:
```tsx
interface HeaderProps {
  projectCount: number;
}

export default function Header({ projectCount }: HeaderProps) {
  return (
    <header className="flex items-center justify-between mb-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">
          Meta-Pipe Dashboard
        </h1>
        <p className="text-gray-400 mt-1">
          {projectCount} project{projectCount !== 1 ? "s" : ""} tracked
        </p>
      </div>
      <div className="text-sm text-gray-500">
        Auto-refreshes every 30s
      </div>
    </header>
  );
}
```

**Step 2: Commit**

```bash
git add dashboard/src/components/Header.tsx
git commit -m "feat(dashboard): add Header component"
```

---

## Task 6: ProjectCard component

**Files:**
- Create: `dashboard/src/components/ProjectCard.tsx`

**Step 1: Write ProjectCard**

`dashboard/src/components/ProjectCard.tsx`:
```tsx
import type { ProjectStatus } from "../types";

interface ProjectCardProps {
  project: ProjectStatus;
  selected: boolean;
  onClick: () => void;
}

function stageIcon(validated: boolean, exists: boolean) {
  if (validated) return "bg-emerald-500";
  if (exists) return "bg-amber-500";
  return "bg-gray-700";
}

export default function ProjectCard({ project, selected, onClick }: ProjectCardProps) {
  const stages = Object.values(project.stages);

  return (
    <button
      onClick={onClick}
      className={`w-full text-left rounded-xl p-5 transition-all cursor-pointer ${
        selected
          ? "bg-gray-800 ring-2 ring-blue-500"
          : "bg-gray-900 hover:bg-gray-800"
      }`}
    >
      <div className="flex items-center justify-between mb-3">
        <h2 className="font-semibold text-lg truncate">{project.project_name}</h2>
        <span className="text-2xl font-bold tabular-nums">
          {project.completion_percentage}%
        </span>
      </div>

      {/* Progress bar */}
      <div className="w-full bg-gray-700 rounded-full h-2 mb-3">
        <div
          className="bg-blue-500 h-2 rounded-full transition-all duration-500"
          style={{ width: `${project.completion_percentage}%` }}
        />
      </div>

      {/* Stage dots */}
      <div className="flex gap-1">
        {stages.map((s) => (
          <div
            key={s.stage}
            className={`h-2 flex-1 rounded-full ${stageIcon(s.validated, s.exists)}`}
            title={`${s.stage}: ${s.name}`}
          />
        ))}
      </div>

      {/* Current stage */}
      {project.current_stage && (
        <p className="text-xs text-gray-400 mt-3 truncate">
          Next: {project.next_action}
        </p>
      )}
    </button>
  );
}
```

**Step 2: Commit**

```bash
git add dashboard/src/components/ProjectCard.tsx
git commit -m "feat(dashboard): add ProjectCard component with progress bar"
```

---

## Task 7: StageTimeline component

**Files:**
- Create: `dashboard/src/components/StageTimeline.tsx`

**Step 1: Write the timeline**

`dashboard/src/components/StageTimeline.tsx`:
```tsx
import type { ProjectStatus } from "../types";
import { PIPELINE_STAGES } from "../types";

interface StageTimelineProps {
  project: ProjectStatus;
}

export default function StageTimeline({ project }: StageTimelineProps) {
  return (
    <div className="bg-gray-900 rounded-xl p-6">
      <h3 className="text-lg font-semibold mb-4">
        {project.project_name} — Stage Detail
      </h3>

      <div className="space-y-1">
        {PIPELINE_STAGES.map((def) => {
          const stage = project.stages[def.id];
          if (!stage) return null;

          const isCurrent = project.current_stage === def.id;

          return (
            <div
              key={def.id}
              className={`flex items-start gap-4 p-3 rounded-lg ${
                isCurrent ? "bg-gray-800" : ""
              }`}
            >
              {/* Icon */}
              <div className="mt-0.5 text-lg">
                {stage.validated ? "✅" : stage.exists ? "🔄" : "⬜"}
              </div>

              {/* Info */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className="font-mono text-sm text-gray-400">
                    {def.id}
                  </span>
                  <span className="font-medium">{stage.name}</span>
                  {isCurrent && (
                    <span className="text-xs bg-blue-500/20 text-blue-400 px-2 py-0.5 rounded-full">
                      current
                    </span>
                  )}
                </div>

                {stage.exists && (
                  <div className="flex gap-4 mt-1 text-xs text-gray-500">
                    <span>{stage.file_count} files</span>
                    {stage.last_modified && (
                      <span>
                        modified{" "}
                        {new Date(stage.last_modified).toLocaleDateString()}
                      </span>
                    )}
                  </div>
                )}

                {/* Missing files */}
                {stage.key_files_missing.length > 0 && (
                  <div className="mt-1 text-xs text-red-400">
                    Missing: {stage.key_files_missing.join(", ")}
                  </div>
                )}

                {/* Present files */}
                {stage.key_files_present.length > 0 && (
                  <div className="mt-1 text-xs text-emerald-400">
                    ✓ {stage.key_files_present.join(", ")}
                  </div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
```

**Step 2: Commit**

```bash
git add dashboard/src/components/StageTimeline.tsx
git commit -m "feat(dashboard): add StageTimeline component"
```

---

## Task 8: DependencyGraph component (pipeline flow visualization)

**Files:**
- Create: `dashboard/src/components/DependencyGraph.tsx`

**Step 1: Write the dependency graph using pure CSS/HTML (no library needed)**

`dashboard/src/components/DependencyGraph.tsx`:
```tsx
import type { ProjectStatus } from "../types";
import { PIPELINE_STAGES } from "../types";

interface DependencyGraphProps {
  project: ProjectStatus | null;
}

function nodeColor(project: ProjectStatus | null, stageId: string) {
  if (!project) return "bg-gray-700 text-gray-400";
  const stage = project.stages[stageId];
  if (!stage) return "bg-gray-700 text-gray-400";
  if (stage.validated) return "bg-emerald-600 text-white";
  if (stage.exists) return "bg-amber-600 text-white";
  return "bg-gray-700 text-gray-400";
}

export default function DependencyGraph({ project }: DependencyGraphProps) {
  return (
    <div className="bg-gray-900 rounded-xl p-6 mb-6">
      <h3 className="text-sm font-medium text-gray-400 mb-4">
        Pipeline Flow
        {project && <span className="ml-2 text-gray-500">— {project.project_name}</span>}
      </h3>
      <div className="flex items-center gap-1 overflow-x-auto pb-2">
        {PIPELINE_STAGES.map((stage, i) => (
          <div key={stage.id} className="flex items-center shrink-0">
            <div
              className={`px-3 py-2 rounded-lg text-xs font-mono font-medium ${nodeColor(project, stage.id)}`}
              title={stage.name}
            >
              {stage.id.replace("_", " ")}
            </div>
            {i < PIPELINE_STAGES.length - 1 && (
              <div className="text-gray-600 mx-1">→</div>
            )}
          </div>
        ))}
      </div>
      <div className="flex gap-4 mt-3 text-xs text-gray-500">
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded bg-emerald-600 inline-block" /> Complete
        </span>
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded bg-amber-600 inline-block" /> In Progress
        </span>
        <span className="flex items-center gap-1">
          <span className="w-3 h-3 rounded bg-gray-700 inline-block" /> Not Started
        </span>
      </div>
    </div>
  );
}
```

**Step 2: Commit**

```bash
git add dashboard/src/components/DependencyGraph.tsx
git commit -m "feat(dashboard): add DependencyGraph pipeline flow component"
```

---

## Task 9: Wire up App.tsx with all components

**Files:**
- Modify: `dashboard/src/App.tsx`

**Step 1: Assemble the full app**

`dashboard/src/App.tsx`:
```tsx
import { useState } from "react";
import Header from "./components/Header";
import ProjectCard from "./components/ProjectCard";
import StageTimeline from "./components/StageTimeline";
import DependencyGraph from "./components/DependencyGraph";
import { useProjects } from "./hooks/useProjects";

export default function App() {
  const { projects, loading, error } = useProjects();
  const [selectedName, setSelectedName] = useState<string | null>(null);

  const selectedProject =
    projects.find((p) => p.project_name === selectedName) ?? null;

  // Auto-select first project
  if (!selectedName && projects.length > 0) {
    setSelectedName(projects[0].project_name);
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-950 text-gray-100 p-8">
        <p className="text-red-400">Error: {error}</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-950 text-gray-100 p-8 max-w-7xl mx-auto">
      <Header projectCount={projects.length} />

      {loading ? (
        <p className="text-gray-400">Loading project data...</p>
      ) : (
        <>
          <DependencyGraph project={selectedProject} />

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Left: project cards */}
            <div className="space-y-3">
              {projects.map((p) => (
                <ProjectCard
                  key={p.project_name}
                  project={p}
                  selected={p.project_name === selectedName}
                  onClick={() => setSelectedName(p.project_name)}
                />
              ))}
            </div>

            {/* Right: stage detail */}
            <div className="lg:col-span-2">
              {selectedProject && <StageTimeline project={selectedProject} />}
            </div>
          </div>
        </>
      )}
    </div>
  );
}
```

**Step 2: Verify the dev build compiles**

```bash
cd dashboard && pnpm dev
# Visit http://localhost:5173 — should see "Loading project data..."
# (API isn't running yet in dev mode, so it'll show error — that's fine)
# Ctrl+C
```

**Step 3: Commit**

```bash
git add dashboard/src/App.tsx
git commit -m "feat(dashboard): wire up App with all components"
```

---

## Task 10: Add `pnpm serve` production command

**Files:**
- Modify: `dashboard/package.json` (already has the script)

**Step 1: Build and test production mode**

```bash
cd dashboard && pnpm build
# Expected: dist/ directory created

pnpm serve &
sleep 2
curl -s http://localhost:6666/api/projects | python3 -m json.tool | head -20
# Expected: JSON array of project statuses

# Open http://localhost:6666 in browser — full dashboard should render
kill %1
```

**Step 2: Commit**

```bash
git add dashboard/
git commit -m "feat(dashboard): production build and serve command"
```

---

## Task 11: Add root-level convenience script

**Files:**
- Modify: root `package.json` (create if needed) OR add a shell alias

**Step 1: Add a `serve-dashboard` script to root**

Create `dashboard/README.md` is NOT needed. Instead, update the root `CLAUDE.md` or just document in the commit message.

Create a simple shell script at root for convenience:

`serve-dashboard.sh`:
```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/dashboard"

if [ ! -d node_modules ]; then
  echo "Installing dependencies..."
  pnpm install
fi

if [ ! -d dist ] || [ "$(find src -newer dist/index.html 2>/dev/null | head -1)" ]; then
  echo "Building dashboard..."
  pnpm build
fi

echo "Starting Meta-Pipe Dashboard on http://localhost:6666"
exec pnpm serve
```

```bash
chmod +x serve-dashboard.sh
```

**Step 2: Commit**

```bash
git add serve-dashboard.sh
git commit -m "feat: add serve-dashboard.sh convenience launcher"
```

---

## Task 12: End-to-end smoke test

**Step 1: Full build + serve + verify**

```bash
cd dashboard
pnpm install && pnpm build
pnpm serve &
sleep 2

# Test API
curl -sf http://localhost:6666/api/projects | python3 -c "
import json, sys
data = json.load(sys.stdin)
assert len(data) >= 1, 'No projects found'
for p in data:
    assert 'project_name' in p
    assert 'completion_percentage' in p
    assert 'stages' in p
    print(f\"  {p['project_name']}: {p['completion_percentage']}%\")
print(f'OK — {len(data)} projects loaded')
"

# Test SPA serving
curl -sf http://localhost:6666/ | grep -q 'Meta-Pipe Dashboard'
echo "SPA serving: OK"

kill %1
echo "All smoke tests passed"
```

**Step 2: Final commit**

```bash
git add -A
git commit -m "feat(dashboard): complete v0.1 — project progress dashboard on localhost:6666"
```

---

## Summary

| Task | What | Est. |
|------|------|------|
| 1 | Scaffold Vite + React + Tailwind | 5 min |
| 2 | Types + API client | 3 min |
| 3 | Express API server | 5 min |
| 4 | useProjects hook | 2 min |
| 5 | Header component | 2 min |
| 6 | ProjectCard component | 3 min |
| 7 | StageTimeline component | 3 min |
| 8 | DependencyGraph component | 3 min |
| 9 | Wire up App.tsx | 3 min |
| 10 | Build + production serve | 3 min |
| 11 | Root convenience script | 2 min |
| 12 | Smoke test | 3 min |

**Total: ~37 min**

## Future Enhancements (not in scope now)

- WebSocket for live updates (watch filesystem)
- Session log viewer (from `session_log.py`)
- TOPIC.txt preview in sidebar
- Dark/light theme toggle
- Filter/sort projects by completion
- NMA vs pairwise analysis type badge
- Export status report as PDF
