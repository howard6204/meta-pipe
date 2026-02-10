---
name: brainstorm-topic
description: Interactive brainstorming to develop a meta-analysis topic. Use when user wants to explore ideas, refine a topic, or needs help formulating a research question.
---

# Topic Brainstorming Skill

Guide users through developing a well-formed meta-analysis topic via interactive conversation.

## Trigger Phrases

- "help me find a topic"
- "brainstorm topic"
- "I'm not sure what to study"
- "help me refine my topic"
- "/brainstorm"

## Conversation Flow

### Phase 1: Initial Exploration

Ask ONE question at a time. Start with:

> **What clinical area or health topic interests you?**
>
> Examples: mental health, cardiovascular disease, cancer treatment, rehabilitation, nutrition...

Wait for response. Then probe deeper based on their answer.

### Phase 2: Narrow Down (PICO Elements)

Guide through PICO iteratively:

**Population:**

> Within [their area], which patient group interests you most?
>
> - Age group? (pediatric, adult, elderly)
> - Condition severity? (mild, moderate, severe)
> - Setting? (outpatient, inpatient, community)

**Intervention:**

> What treatment or intervention do you want to evaluate?
>
> - Drug vs drug?
> - Therapy vs control?
> - New technique vs standard care?

**Comparator:**

> What should we compare it against?
>
> - Placebo/sham?
> - Active comparator?
> - Standard of care / treatment as usual?
> - Waitlist control?

**Outcomes:**

> What outcomes matter most?
>
> - Primary: symptom reduction, mortality, quality of life?
> - Secondary: adverse events, adherence, cost?

### Phase 3: Feasibility Check (USE WEB SEARCH)

**IMPORTANT: Always use WebSearch tool to check feasibility before finalizing.**

Before finalizing, perform these web searches:

1. **Search for existing reviews**:

   ```
   WebSearch: "[intervention] [condition] systematic review meta-analysis"
   ```

   - Check if recent reviews exist (within 2-3 years)
   - If yes: Can we update it? Focus on a subgroup? Add new outcomes?

2. **Estimate study volume**:

   ```
   WebSearch: "[intervention] [condition] randomized controlled trial"
   ```

   - Look for study counts in search results
   - Aim for 5+ studies minimum for a useful meta-analysis

3. **Check Cochrane Library**:

   ```
   WebSearch: "cochrane review [intervention] [condition]"
   ```

   - Cochrane reviews are gold standard - check if one exists
   - If outdated (>3 years), an update is valuable

4. **Identify research gaps**:

   ```
   WebSearch: "[condition] treatment gaps research priorities"
   ```

   - Find areas where evidence is lacking

Report findings to user:

> Based on my search:
>
> - Found X existing systematic reviews, most recent from [year]
> - Estimated Y RCTs available
> - [Gap/opportunity identified]
> - Recommendation: [proceed / narrow focus / consider different angle]

### Phase 4: Refine & Output

Present the refined topic in structured format:

```markdown
## Your Meta-Analysis Topic

**Research Question:**
[Full PICO question in sentence form]

**Population:** [specific group]
**Intervention:** [specific treatment]
**Comparator:** [specific control]
**Outcomes:**

- Primary: [main outcome]
- Secondary: [additional outcomes]

**Study Designs:** [RCTs / RCTs + observational]
**Estimated Studies:** [rough estimate from quick search]
```

Ask: **"Does this capture what you want to study? Any adjustments?"**

### Phase 5: Save to TOPIC.txt

Once confirmed:

```bash
# Write the finalized topic
cat > TOPIC.txt << 'EOF'
[Paste the formatted topic here]
EOF
```

Then say:

> ✅ Topic saved to `TOPIC.txt`.
>
> Ready to start? Just say **"start"** and I'll begin the protocol stage.

## Conversation Guidelines

1. **One question at a time** - Don't overwhelm
2. **Offer examples** - Help spark ideas
3. **Validate choices** - "Great choice, because..."
4. **Flag concerns early** - "This might have limited studies..."
5. **Be encouraging** - Research questions evolve

## Example Dialogue

```
User: help me brainstorm a topic

Claude: Happy to help! What clinical area interests you most?
        Examples: mental health, cardiology, oncology, pediatrics, surgery...

User: mental health

Claude: Great area with lots of research. Within mental health,
        which condition draws your attention?
        - Depression
        - Anxiety disorders
        - PTSD
        - Schizophrenia
        - Substance use
        - Something else?

User: depression, specifically in teenagers

Claude: Adolescent depression is important and well-studied.
        What intervention are you curious about?
        - Medications (SSRIs, SNRIs)
        - Psychotherapy (CBT, IPT, DBT)
        - Digital interventions (apps, online therapy)
        - Combined treatments
        - School-based programs

User: I'm interested in whether apps actually work

Claude: Digital mental health interventions for adolescent depression -
        that's timely and relevant! Let me check the literature...

        [Quick search shows ~15-20 RCTs available]

        Good news: There's enough research for a meta-analysis.

        What should we compare the apps against?
        - Waitlist (no treatment)
        - Treatment as usual
        - Face-to-face therapy
        - Attention control (non-therapeutic app)

User: waitlist seems cleanest

Claude: Agreed - waitlist gives the clearest effect estimate.

        For outcomes, depression apps typically measure:
        - Depression symptoms (PHQ-A, CDI, BDI)
        - Anxiety (often comorbid)
        - App engagement/adherence
        - Quality of life

        Which is your primary outcome?

User: depression symptoms measured by any validated scale

Claude: Perfect. Here's your refined topic:

        ## Your Meta-Analysis Topic

        **Research Question:**
        Are smartphone applications effective for reducing depression
        symptoms in adolescents compared to waitlist control?

        **Population:** Adolescents (12-18 years) with depression symptoms
        **Intervention:** Smartphone-based mental health applications
        **Comparator:** Waitlist control
        **Outcomes:**
        - Primary: Depression symptoms (validated scales)
        - Secondary: Anxiety, app adherence, quality of life

        **Study Designs:** RCTs
        **Estimated Studies:** 15-20

        Does this capture what you want to study? Any adjustments?

User: looks good!

Claude: ✅ Topic saved to TOPIC.txt.

        Ready to start the systematic review? Just say "start"!
```

## Quick Topic Templates

If user is stuck, offer templates:

| Template           | Example                                             |
| ------------------ | --------------------------------------------------- |
| Drug vs Drug       | "SSRIs vs SNRIs for generalized anxiety"            |
| Therapy vs Control | "CBT vs waitlist for insomnia"                      |
| New vs Standard    | "Robotic surgery vs open surgery for prostatectomy" |
| Dose comparison    | "High-dose vs standard-dose statins for ACS"        |
| Delivery format    | "Telehealth vs in-person therapy for depression"    |
| Timing             | "Early vs delayed intervention for stroke rehab"    |
