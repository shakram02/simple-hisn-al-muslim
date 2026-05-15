# Mission

Produce the final Google Play **Store listing** for Hisnul Muslim, ready
to paste into Play Console. You will run a two-pass pipeline:
**generation → native-speaker QA → fix application**, then save the
result.

# Inputs (read these first, in full — do not skim)

1. `/mnt/ssd-240/code/personal/azkar/release_notes/store_listing_prompt.md`
   — the generation spec (role, app context, policy bans, output format).
2. `/mnt/ssd-240/code/personal/azkar/release_notes/store_listing_qa_prompt.md`
   — the QA review spec (script integrity, grammar, register, religious
   terminology, punctuation, SEO authenticity, bidi).

These two files are the authoritative spec. Your job is to **orchestrate
and arbitrate**, not to second-guess what they say.

# Process

## Step 1 — Generation pass

Spawn a subagent (`Agent` tool, `subagent_type: "general-purpose"`) with
the **entire contents** of `store_listing_prompt.md` as its prompt. The
subagent approach is preferred over inline generation because it isolates
the generation context from your orchestrator context.

Save the subagent's output verbatim (the full Markdown listing + Summary
table) to:

`/mnt/ssd-240/code/personal/azkar/release_notes/v1.0.20_store_listing_draft.md`

## Step 2 — QA pass

Spawn a second subagent (`Agent` tool, `subagent_type: "general-purpose"`)
with this prompt:

```
<full contents of store_listing_qa_prompt.md>

## INPUT TO REVIEW

<full contents of v1.0.20_store_listing_draft.md>
```

Save the subagent's QA report to:

`/mnt/ssd-240/code/personal/azkar/release_notes/v1.0.20_store_listing_qa.md`

## Step 3 — Apply fixes

Read the QA report. For every flagged issue:

- **Concrete fix proposed AND QA-agent confident** → apply it via Edit.
- **`NEEDS NATIVE REVIEW`** → leave text as-is, append an HTML comment
  next to the field: `<!-- TODO native review (<locale>): <reason from QA> -->`
- **Applying a fix pushes the field over its char cap** → rewrite the
  field to make room. Do NOT simply truncate.
- **You disagree with the QA agent's verdict** → keep the original text
  and add `<!-- QA flag overridden: <one-sentence reason> -->` so the
  user can audit your override.

After every edit, **recount the character count for that field** and
update the Summary table. Character counting is the most common place
LLMs slip — count actual Unicode characters, not bytes, not visual
glyphs.

Save the final to:

`/mnt/ssd-240/code/personal/azkar/release_notes/v1.0.20_store_listing.md`

## Step 4 — Report to user

Print, in this exact form:

```
Final listing: release_notes/v1.0.20_store_listing.md

Locales clean: X/9
Locales with native-review TODOs: Y  ->  <list locale codes>
Locales with QA overrides: Z  ->  <list locale codes>

Top 3 issues caught by QA:
1. <locale> <field>: <one-line summary>
2. ...
3. ...
```

# Hard rules

- **Do not skip the QA pass.** Even if Step 1 output looks clean, run it.
- **Do not invent locale facts** ("most-searched term in Bangladesh is
  X"). Work from what the prompts tell you. Anything beyond that is a
  `NEEDS NATIVE REVIEW`.
- **Do not add or remove locales.** Output exactly the 9: `en-US`, `ar`,
  `es-ES`, `fa`, `hi-IN`, `id`, `pt-PT`, `th`, `zh-CN`.
- **Do not exceed character caps**: App name 30, Short description 80,
  Full description 4000. Recount after every edit.
- **Use Read/Write/Edit tools**, not Bash `cat`/`echo`, for file ops.
- **If the `Agent` tool fails or is unavailable**, fall back to running
  both passes inline in your own context, and note this fallback in the
  final report's preamble.
- **Do not commit anything to git.** This is a draft pipeline; the user
  reviews before any commit.

# Optional: deeper QA via parallel locale subagents

If the user asks for a more thorough QA pass, replace Step 2 with **9
parallel subagent calls in a single message**, one per locale. Each
subagent gets:
- The QA prompt restricted to its single locale (drop the other 8
  locales' rules from the prompt to focus attention).
- Only that locale's three fields from the draft.
- Instructions to output the same per-locale section format.

Merge the 9 reports into a single QA file before Step 3. This costs ~9×
more tokens but produces noticeably deeper script/grammar/religious-term
catches.

# Done condition

You're done when:
1. `v1.0.20_store_listing.md` exists.
2. Every field's character count in the Summary table is verified
   against actual content.
3. Every QA issue is either fixed, overridden with a comment, or flagged
   `NEEDS NATIVE REVIEW`.
4. The user-facing summary block has been printed.
