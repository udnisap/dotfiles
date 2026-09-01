# `cs` / `ch` — say what you want, get the command

Two zsh helpers that turn a plain-English request into a single shell command,
show it, and run it only after you confirm.

| Alias | Model | Use it for |
|---|---|---|
| `cs` | sonnet | Trickier or multi-step lookups — "which folder is the thing on :3000 running from" |
| `ch` | haiku | Fast recall — "flush the dns cache", "what's the flag to follow a log" |

Defined in [`zsh/.zshrc`](../zsh/.zshrc), symlinked to `~/.zshrc`, so they are
available in any new shell with no install step.

## The basic loop

```
$ cs list the folder localhost:3000 is running on

  lsof -i :3000 -t | xargs -I{} lsof -p {} | awk '$4=="cwd" {print $NF}'

Run? [Y/e/x/n]
```

| Key | What happens |
|---|---|
| `Enter` or `y` | Run it |
| `e` | Drop the command onto an editable line (zsh `vared`) — tweak a flag, then Enter |
| `x` | Ask haiku to explain what the command does, then ask again |
| anything else | Cancel |

The command runs in your **current** shell, so `cd` and `export` actually stick:

```
$ cs cd to the dotfiles repo
  cd ~/.dotfiles
Run? [Y/e/x/n]
$ pwd
/Users/udnisap/.dotfiles
```

It is also pushed into zsh history (`print -s`), so **Up-arrow recalls it**.
That matters more than it sounds: the helper becomes a way to *learn* commands,
not just fire them once. Ask for it, run it, and it is in your history like
anything you typed yourself.

## Dictation workflow (Handy)

This is what the aliases were really built for. [Handy](https://handy.computer)
is an open-source local dictation tool (same idea as Wispr Flow, but the audio
never leaves the machine). With it, the whole loop is voice plus two keys:

1. Type `cs ` (three keystrokes)
2. **Hold your Handy hotkey** (`cmd` here) and say what you want
3. Release — the transcript lands on the command line after `cs `
4. **Enter** — sends it to the model
5. **Enter** again at `Run? [Y/e/x/n]` — runs it

No mouse, no exact syntax, no remembering whether it is `-i` or `-n`. You
describe the outcome; the command is the model's problem.

### Why the design fits dictation

- **`Enter` is the default at the confirm prompt.** The prompt is `[Y/e/x/n]`
  with a capital Y, so the common path — dictate, glance, run — never needs a
  precise keypress.
- **`noglob` on both aliases.** Dictation loves to end a sentence with a
  question mark, and bare `?` in zsh is a glob. Without `noglob`, "what is my ip?"
  dies with `zsh: no matches found`. With it, punctuation is harmless.
- **Sloppy phrasing is fine.** The model gets your `$PWD` and is told to emit
  exactly one macOS/zsh command, so half-formed requests like "the folder that
  port 3000 thing is in" still resolve.

### One thing dictation can't fix

`noglob` stops globbing, but the shell still interprets `>`, `|`, `<` and `#`
before the alias ever sees them. If Handy transcribes a literal `>`, you get a
redirect:

```
$ cs show files > 100mb     # creates a file called 100mb
$ cs 'show files > 100mb'   # correct
```

In practice, say "greater than" rather than the symbol, or quote the request.

## Safety

The model is invoked with `--tools ""`. It has **no ability to run anything** —
it can only emit text. The command executes solely because you pressed a key,
in your shell, under your user.

This is deliberately stronger than letting an agent run commands with
permissions bypassed: there is no path where something executes without you
seeing it first. The tradeoff is that the model cannot inspect your machine to
answer, so it writes the command that *would* find out, and you run it.

Two consequences worth knowing:

- It cannot chain — if answering needs two steps, you will run two commands.
- It is guessing from the request plus your current directory, so read before
  you press Enter. `x` is there for when you do not recognise something.

## Known limitations

- **`~/.claude/CLAUDE.md` is still loaded** into each request. Only `--bare`
  suppresses user memory, and that forces `ANTHROPIC_API_KEY` auth, which would
  break the existing OAuth login. Accepted as a small latency cost.
- **No streaming.** You wait for the full command before seeing anything. With
  `ch` this is usually under a second.
