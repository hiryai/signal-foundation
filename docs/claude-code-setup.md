# Claude Code Setup

This is step one of the on-ramp. By the end of this walkthrough you will have Claude Code installed on your computer, signed in to your Anthropic account, the `aiceos-foundation` folder open, the `rtd` plugin marketplace added, the `code-foundations` plugin installed, and a working environment ready to run the rest of the foundation steps.

You will not need to use a terminal. Everything happens through a normal app you download and install like any other.

Each step below is independently followable. If a step fails, fix it before moving on; later steps depend on earlier steps having succeeded.

## What you need before you start

- A Mac or Windows computer
- An internet connection
- An Anthropic account (you'll sign in to it in step 2; if you don't have one yet, you can create one for free at the sign-in screen)

## Step 1. Download and install Claude Code

Go to:

```
https://claude.com/download
```

That page detects whether you're on Mac or Windows and gives you the correct installer. Download it.

On Mac, open the downloaded file and drag Claude Code into your Applications folder, the same way you'd install any other Mac app. Then open it from Applications or Launchpad.

On Windows, open the downloaded installer and follow the prompts. When it finishes, open Claude Code from the Start menu.

You should now see the Claude Code app window open on your screen. If it didn't open, find it in Applications (Mac) or the Start menu (Windows) and click it.

## Step 2. Sign in with your Anthropic account

The first time Claude Code opens, it asks you to sign in. Click the sign-in button and a browser window will open.

If you already have an Anthropic account (the same one you'd use at claude.ai), sign in with it. If you don't have one, click the option to create one — it's free to make, and you can decide later whether to add a paid plan.

After you sign in, the browser will hand control back to the Claude Code app. The app should now show you its main screen, ready to use.

## Step 3. Open the `aiceos-foundation` folder

Claude Code works inside a project folder on your computer. You need to point it at the `aiceos-foundation` folder you downloaded.

In the Claude Code menu bar at the top of the screen, click **File**, then click **Open Folder**.

A file picker will appear. Navigate to wherever you saved the `aiceos-foundation` folder, click on the folder once to select it, and click **Open**.

Important: open the **folder itself**, not a file inside the folder. Claude Code needs the whole folder to be the working area, not a single document.

The Claude Code window will refresh and you'll see the folder name shown in the app. You're now working inside that project.

## Step 4. Add the `rtd` plugin marketplace

At the bottom of the Claude Code window there's a chat input box. That's where you type to Claude.

Click into the input box and type the following exactly, then press enter:

```
/plugin marketplace add ryanthedev/rtd-claude-inn
```

This registers the `rtd` marketplace with your copy of Claude Code. You'll see a confirmation message in the chat that the marketplace was added.

The marketplace name is case-sensitive — the letters need to match exactly as shown above.

## Step 5. Install the `code-foundations` plugin

Still in the same chat input box, type:

```
/plugin install code-foundations@rtd
```

Press enter. Claude Code will ask you whether to install the plugin **for you** (user scope) or for this project only. Choose **Install for you** so the plugin is available across every project, not just this one.

`code-foundations` is the plugin that ships the building, reviewing, and skill set this repo's workflow expects. The `@rtd` suffix tells Claude Code to install it from the marketplace you added in step 4.

You'll see a confirmation message when the install finishes.

## Step 6. Reload plugins

The plugin you just installed isn't active yet — Claude Code needs to reload its plugin list so the new commands show up. In the same chat input box, type:

```
/reload-plugins
```

Press enter. The reload happens in a second or two. Once it's done, the plugin's commands are live in your current session.

## Step 7. Verify

Confirm the install worked.

In the chat input box, type a single forward slash:

```
/
```

A list of available commands will appear above the input box. Scroll through it. You should see commands that start with `/code-foundations` — those are the commands the plugin just added.

If you see at least one `/code-foundations` command in the list, your environment is ready.

You can close the Claude Code app if you want a break, or move directly to step two of the on-ramp (the engine framework doc) — see the README for the full sequence.

## Troubleshooting

- **The installer is blocked on Mac with a message about an unidentified developer.** Right-click (or hold Control and click) the installer file in Finder, then choose **Open** from the menu. Mac will then let you run it. This is a one-time step.
- **Sign-in doesn't complete — the browser opens but Claude Code never updates.** Open a new browser tab, go to claude.ai, sign in there first, then go back to Claude Code and click sign in again. This usually resolves it.
- **Claude Code doesn't recognize the folder you opened.** Make sure you opened the **folder itself**, not a file inside it. Use **File → Open Folder** (not Open File) and click the folder once before clicking Open.
- **`/plugin marketplace add` returns an error.** Check the spelling and capitalization of `ryanthedev/rtd-claude-inn`. It is case-sensitive — every letter has to match exactly.
- **`/plugin install code-foundations@rtd` errors with "marketplace not found".** Step 4 didn't complete successfully. Go back and run step 4 again, wait for the confirmation message, then retry the install.
- **Plugin commands don't appear when you type a forward slash.** You skipped the reload, or it didn't finish. Run `/reload-plugins` again and wait for it to complete.

Once verification passes, return to the README and continue with step two of the on-ramp.
