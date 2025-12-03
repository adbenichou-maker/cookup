# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CookUp is a Rails 7.1 cooking assistant application that uses AI (via RubyLLM gem) to suggest recipes based on user's available ingredients, skill level, and time constraints. Users can track their cooking skills, save recipes, and leave reviews.

## Common Commands

```bash
# Start development server
bin/rails server

# Database operations
bin/rails db:migrate
bin/rails db:seed
bin/rails db:reset  # drops, creates, migrates, seeds

# Run tests
bin/rails test                           # all tests
bin/rails test test/models/              # model tests only
bin/rails test test/controllers/         # controller tests only
bin/rails test test/models/recipe_test.rb  # single file

# Rails console
bin/rails console

# Asset pipeline (importmap)
bin/importmap pin <package>
```

## Architecture

### Tech Stack
- Ruby 3.3.5, Rails 7.1 with PostgreSQL
- Hotwire (Turbo + Stimulus) for frontend interactivity
- Importmap for JavaScript (no Node.js bundler)
- Bootstrap 5.3 with SASSC for styling
- Devise for authentication

### Core Domain Models

**Chat System (AI-powered recipe suggestions):**
- `Chat` belongs to User, has many Messages. Contains `SYSTEM_PROMPT` defining AI behavior.
- `Message` stores conversation history with `role` (user/assistant) and `content`
- `Recipe` can be AI-generated (belongs_to message) or user-created. Has JSONB `ingredients`, enum `recipe_level`, and `RecipeSchema` for structured LLM output.

**Learning/Tracking:**
- `Skill` - cooking techniques with video tutorials and difficulty levels
- `UserSkill` - tracks user's completed skills
- `UserRecipe` - saves recipes to user's collection
- `Step` - recipe instructions, optionally linked to Skills

**Search:**
- PgSearch on Recipe model for full-text search across title, description, ingredients

### LLM Integration
- Uses `ruby_llm` gem with `ruby_llm-schema` for structured outputs
- Chat flow: user provides constraints → AI suggests 3 recipes → user selects → AI provides full recipe
- System prompt in `app/models/chat.rb` defines AI persona and response format
- Markdown responses rendered with Kramdown/Rouge

### Key Patterns
- Nested routes for chat/messages and recipe/steps
- `current_user.chats.find(params[:id])` pattern for authorization
- Recipes use enum for difficulty: `beginner`, `intermediate`, `expert`

## Environment

Requires `.env` file with API keys for LLM provider (see `dotenv-rails` gem).
