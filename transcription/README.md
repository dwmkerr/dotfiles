# Transcription

Voice-to-text transcription setup and tools.

## SuperWhisper

Primary tool in use: [SuperWhisper](https://superwhisper.com/). Install via `brew install superwhisper`.

### Modes

| Mode | STT Model | LLM | Purpose |
|------|-----------|-----|---------|
| Voice to text | Parakeet Multilanguage | none | Pure transcription, no reformatting |
| Super | Parakeet Multilanguage | GPT-5 mini | Context-aware reformatting with app detection |
| Meeting | Parakeet Multilanguage | GPT-5 mini | Meeting transcript summarizer with action items |
| Message | Parakeet Multilanguage | GPT-5 mini | Clean text reformatter, fixes grammar and speech artifacts |

### Preferences

- **Active mode:** Super
- **Push to talk:** Right Command
- **Toggle recording:** Option + Space
- **Cancel recording:** Escape
- **Mini recorder:** Always shown

### Notes

- SuperWhisper stores mode configurations internally (no portable config file). After a fresh install, recreate modes manually in the app.
- The Parakeet Multilanguage model downloads automatically on first use.
- Cloud LLM models (GPT-5 mini etc.) are provided by SuperWhisper's Pro subscription.

## Tools to Evaluate

- [ ] Vibe Transcribe

## More Reading

- [Move Over Superwhisper: These AI Tools Are Just as Sharp](https://medium.com/@theo-james/move-over-superwhisper-these-ai-tools-are-just-as-sharp-200b0d5cd048)
