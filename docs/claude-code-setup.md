# Claude Code Setup

This is step one of the on-ramp. By the end of this walkthrough you will have Claude Code installed, your API key configured, the `rtd` plugin marketplace added, the `code-foundations` plugin installed, and a working environment ready to run the rest of the foundation steps.

Each step below is independently followable. If a step fails, fix it before moving on; later steps depend on earlier steps having succeeded.

## What you need before you start

- A terminal (the default Terminal app on macOS, Windows Terminal, or any terminal emulator on Linux)
- An editor (any editor works; Claude Code runs in the terminal independent of your editor)
- An internet connection
- An Anthropic API key (you'll set this up in step 2 if you don't have one yet)

## Step 1. Install Claude Code

Claude Code is Anthropic's official command-line tool for working with Claude inside a repository. Install it from the official source.

Follow the install instructions at:

```
https://docs.anthropic.com/claude/claude-code
```

That page is the canonical install reference and is kept current with whatever the supported install method is on your platform. Follow it end to end.

When the install finishes, confirm it worked by opening a terminal and running:

```
claude --version
```

You should see a version string. If you see a "command not found" error, the install did not complete; go back and rerun the install steps until `claude --version` prints a version.

## Step 2. Configure your API key

Claude Code needs an Anthropic API key to talk to Claude. If you do not yet have one, create it from your Anthropic account console:

```
https://console.anthropic.com/
```

Once you have a key, configure Claude Code to use it. The supported method on every platform is the `ANTHROPIC_API_KEY` environment variable. Set it in your shell profile so it persists across terminal sessions.

For zsh (the default on macOS), add this line to `~/.zshrc`:

```
export ANTHROPIC_API_KEY="your-key-here"
```

For bash, add the same line to `~/.bashrc` or `~/.bash_profile`. For Windows PowerShell, set the environment variable through `System Properties` or via:

```
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "your-key-here", "User")
```

After setting it, open a new terminal so the environment variable is loaded. Verify:

```
echo $ANTHROPIC_API_KEY
```

(or `echo %ANTHROPIC_API_KEY%` on Windows cmd, or `$env:ANTHROPIC_API_KEY` in PowerShell).

You should see your key printed back. If you see an empty line, the variable is not set in this shell session — open a new terminal and try again.

## Step 3. Open Claude Code in this repo

From inside the cloned `aiceos-foundation` directory, run:

```
claude
```

Claude Code starts an interactive session. The next three steps run inside that session, not in your shell. Leave the session open from here on.

## Step 4. Add the `rtd` plugin marketplace

Inside the running Claude Code session, type the following slash command and press enter:

```
/plugin marketplace add ryanthedev/rtd-claude-inn
```

This registers the `rtd` marketplace with your Claude Code install. Claude Code will confirm the marketplace was added. If it errors, check the spelling — the marketplace identifier is case-sensitive.

## Step 5. Install the `code-foundations` plugin

Still inside the Claude Code session, install the foundation plugin from the marketplace you just added:

```
/plugin install code-foundations@rtd
```

`code-foundations` is the plugin that ships the building, reviewing, and skill-set this repo's workflow expects. The `@rtd` suffix tells Claude Code which marketplace to install it from.

Claude Code will fetch the plugin and confirm install. If install fails, the most common cause is that step 4 did not complete; verify the marketplace was added before retrying.

## Step 6. Reload plugins

Plugins do not become active in the running session until plugins reload. Run:

```
/reload-plugins
```

After the reload completes, the plugin's commands and skills are available in the current session.

## Step 7. Verify

Confirm the install worked. Open the slash-command picker by typing `/` in the Claude Code prompt. You should see commands contributed by the `code-foundations` plugin in the list alongside any built-in commands. Their names are namespaced to the plugin.

A second confirmation: run

```
/plugin
```

with no arguments to list installed plugins. `code-foundations` should appear in the list with its version.

If both checks show `code-foundations` present and active, your environment is ready. Close the Claude Code session if you want to take a break, or move directly to step two of the on-ramp (the engine framework doc) — see the README for the full sequence.

## Troubleshooting

- **`claude --version` errors with "command not found".** The install did not finish. Re-run the install instructions from step 1.
- **`echo $ANTHROPIC_API_KEY` prints an empty line.** Either the variable is not set, or you have not opened a fresh terminal since setting it. Open a new terminal window and try again.
- **`/plugin marketplace add` errors.** Check the marketplace identifier exactly as written: `ryanthedev/rtd-claude-inn`. It is case-sensitive.
- **`/plugin install code-foundations@rtd` errors with marketplace not found.** Step 4 did not complete. Re-run step 4, then retry the install.
- **Plugin commands do not appear after install.** You skipped the `/reload-plugins` step or it did not complete. Re-run it.

Once verification passes, return to the README and continue with step two of the on-ramp.
