WanMark is a WOW addon to mark party members.
WanMark allows you to mark people automatically, when they join your group, and keep them re-marked even if you enter visions, dungeons, etc..


### WanMark has two modes:
1) public, to mark tank and healer only.
2) private, when you pre-assign a mark per character name (actually you can assign a list of characters per each mark).
For example, usually I play with the same guild mates, each of them has few alts. I want the same person always to be marked with the same mark, does not matter on which alt, I want them marked as soon as they join party, right away, automatically, so I do it using WanMark private mode with auto-marking. 
 

### Wanmark auto marking can be disabled or enabled:
- disabled: you can initiate "mark party members" command manually using an assigned key shortcut, to mark group members according to selected mode.
- enabled: WanMark automatically marks party members, as soon as they join your party (also it keeps party marked when you /they re-log or even enter visions).
 

### WanMark keeps current settings stored, when you re-log or log under another character (the settings are global, not per character):
 - current mode, which can be public or private;
 - current auto-mark setting, which can be enabled or disabled;
 - current raid setting: disabled (default) or enabled marking in raid group;
 - for public mode chosen marks for tank and healer.
 - for private mode lists of characters/marks.

### WanMark let you assign 3 keybindings (using standard WOW Esc-Menu -> Key Bindings -> Addons -> WanMark):
 1) hot key to "mark members"
 2) hot key to "switch mode" (between public or private)
 3) hot key to "remove all party marks"
 
(for example, I use \, Shift-\, Ctrl-\)


### WanMark supports the following slash commands (/wmark):
  - /wmark on: enables WanMark automatic mode.
  - /wmark off: disables WanMark automatic mode.
  - /wmark mark: marks targets (if you do not like shortcuts).
  - /wmark demark: removes any party members marks (if you do not like shortcuts).
  - /wmark public: switches to public marking mode.
  - /wmark private: switches to private marking mode.
  - /wmark mode: switches marking mode between private and public (if you do not like shortcuts).
  - /wmark raid [on/off]: shows/enables/disables marking/demarking in raid.


### WanMark also supports advanced commands for public and private modes.
#### For public mode:
  - /wmark show: shows currently chosen marks for tank and healer.
  - /wmark tank 4: sets the current mark for tank to 4 (green triangle)
  - /wmark healer 1: sets the current mark for healer to 1 (yellow star)
#### For private mode:
  - /wmark show: shows lists of alts names, one line per mark, from 0 (no mark) to 8 (skull).
  - /wmark X none: to clean string for mark number #X (X can be any number from 0 to 8).
  - /wmark X name1 name2 ... nameN: to re-define string for mark #X

#### Where X is one of the following marks:
  - 0: none
  - 1: star (yellow)
  - 2: circle (orange)
  - 3: diamond (purple)
  - 4: triangle (green)
  - 5: moon (white)
  - 6: square (blue)
  - 7: cross (red)
  - 8: skull


### You can use marks names instead of numbers.
For example for public mode:
  - /wmark tank triangleor

Or for private mode to define characters to be marked with green triangle:
  - /wmark triangle Wanmage Wantank


## Examples/Explanations.

### Public mode with auto-mark enabled:
  - /wmark public
  - /wmark on

Now you just simply always have tank and healer marked, as soon as they join your group using a tank/healer role.

### Private mode with auto-mark enabled example.
Lets say my usual party has following members:
  1) me, on my mage Wanmage or warrior tank Wantank, always to be marked with green triangle.
  2) my friend1 on priest Holydude. druid Wildcat or rogue Quickblade, always to be marked with yellow star.
  3) my friend2 on warlock Shadowdeath or paladin Crusade, always to be marked with blue square.

List of commands to execute:
  - /wmark private
  - /wmark 4 Wanmage Wantank
  - /wmark 1 Holydude Wildcat Quickblade
  - /wmark 6 Shadowdeath Crusade
  - /wmark on

Now, if you join any party, you marked as green triangle right away.
If one of your 2 friends joins your party, he is instantly marked with his mark.
That's how I have things set up, and there is no need to change it often.

### To stop auto-marking, you do:
  - /wmark off

And now to remove all current party members mark just use assigned shortcut or use the following command:
  - /wmark demark

OK, I hope it is more clear now.
