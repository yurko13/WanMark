WanMark is an addon to mark party members
- in group - it can automatically mark tank and healer;
- in raid - it can automatically mark all tanks;
- not in party playing solo - it can keep your character always marked (idea coming from playing my little invisible goblin rogue);
- additionally, it has private mode, when you can assign list of character names per mark, to keep that characters always marked.


Quick tsartup guide:
1. Install
2. Type "/wmark" to get settings window, configure/enable addon and start using.
3. Setup shortcuts (if needed) at WOW Esc-Menu -> Key Bindings -> Addons -> WanMark


WanMark has two modes:
1) public, to mark
 - in group - tank and healer only;
 - in raid - all tanks (it uses up to 7 marks except skull);
2) private, when you pre-assign a mark per character name (actually you can assign a list of characters per each mark).
For example, usually I play with the same guild mates, each of them has few alts. I want the same person always to be marked with the same mark, does not matter on which alt, I want them marked as soon as they join party, right away, automatically, so I do it using WanMark private mode with auto-marking. 
 

Wanmark auto marking can be disabled or enabled:
- disabled: you can initiate "mark party members" command manually using an assigned key shortcut, to mark group members according to selected mode.
- enabled: WanMark automatically marks party members, as soon as they join your party (also it keeps party marked when you /they re-log or even enter visions).
 

WanMark keeps current settings stored, when you re-log or log under another character (the settings are global, not per character).
Settings stored:
- group marking mode: public or private;
- group auto-marking: disabled (default) or enabled;
- raid group marking: disabled (default) or enabled;
- for public mode marks for tank and healer.
- for private mode lists of characters/marks;
- for solo content self-marking disabled (default) or enabled.
 

WanMark let you assign 3 keybindings (using standard WOW Esc-Menu -> Key Bindings -> Addons -> WanMark):
- 1) hot key to "mark members"
- 2) hot key to "switch mode" (between public or private)
- 3) hot key to "remove all party marks"
(for example, I use \, Shift-\, Alt-\)

WanMark version 1.0.7 and up got settings window, so you can use GUI to change/configure settings.
To get to setting, just use slash command "/wmark" without parameters.
Of course old command line way to manage settings is still available and explained below.


WanMark supports the following slash commands (/wmark):
  /wmark on: enables WanMark automatic mode.
  /wmark off: disables WanMark automatic mode.
  /wmark mark: marks targets (if you do not like shortcuts).
  /wmark demark: removes any party members marks (if you do not like shortcuts).
  /wmark public: switches to public marking mode.
  /wmark private: switches to private marking mode.
  /wmark mode: switches marking mode between private and public (if you do not like shortcuts).
  /wmark raid [on/off]: shows/enables/disables marking/demarking in raid.
  /wmark self [on/off]: shows/enables/disables self-marking if not in party.


WanMark also supports advanced commands for public and private modes.
For public mode:
  /wmark show: shows currently chosen marks for tank and healer.
  /wmark tank 4: sets the current mark for tank to 4 (green triangle)
  /wmark healer 1: sets the current mark for healer to 1 (yellow star)
For private mode:
  /wmark show: shows lists of alts names, one line per mark, from 0 (no mark) to 8 (skull).
  /wmark X none: to clean string for mark number #X (X can be anmy number from 0 to 8).
  /wmark 0 name1 name2 ... nameN: to re-define string for mark #0 (no mark)
  /wmark 1 name1 name2 ... nameN: to re-define string for mark #1 (yellow star)
  /wmark 2 name1 name2 ... nameN: to re-define string for mark #2 (orange circle)
  /wmark 3 name1 name2 ... nameN: to re-define string for mark #3 (violet diamond)
  /wmark 4 name1 name2 ... nameN: to re-define string for mark #4 (green triangle)
  /wmark 5 name1 name2 ... nameN: to re-define string for mark #5 (white moon)
  /wmark 6 name1 name2 ... nameN: to re-define string for mark #6 (blue square)
  /wmark 7 name1 name2 ... nameN: to re-define string for mark #7 (red cross)
  /wmark 8 name1 name2 ... nameN: to re-define string for mark #8 (white skull)
 

You can use mark names instead of a corresponding mark numbers.
For example for public mode:
  /wmark tank triangle
Or for private mode to define characters to be marked with green triangle:
  /wmark triangle Wanmage Wantank

Marks codes corresponding names:
  0: none
  1: star (yellow)
  2: circle (orange)
  3: diamond (purple)
  4: triangle (green)
  5: moon (white)
  6: square (blue)
  7: cross (red)
  8: skull


Example how to configure WanMark to auto-mark party in private mode.
Lets say my usual party has following members:
1 - me, on my mage Wanmage or warrior tank Wantank, always to be marked with green triangle.
2 - my friend1 on priest Holydude. druid Wildcat or rogue Quickblade, always to be marked with yellow star.
3 - my friend2 on warlock Shadowdeath or paladin Crusade, always to be marked with blue square.
List of commands to execute:
  /wmark private
  /wmark 4 Wanmage Wantank
  /wmark 1 Holydude Wildcat Quickblade
  /wmark 6 Shadowdeath Crusade
  /wmark on
Now, if you join any party, you marked as green triangle right away.
If one of your 2 friends joins your party, he is instantly marked with his mark.
To stop auto-marking, you can always do:
  /wmark off
To remove all current party members marks just use assigned shortcut or use the following command:
  /wmark demark

But instead, usually, if we 3 join a dungeon party, I switch to public mode using assigned shortcut or command
 /wmark public
And now all private marks gone, but only tank and healer marked.

OK, I hope it is more clear now.
