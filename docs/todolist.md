# DIALOGUE [x]
- Shouldn't make the text too long

- Branching is curbersome. maybe just make a variable to hold which branch we're in
- Or we can use flags, but theorically we want flags for something less branchy, global in gameplay
# INTERACTION [x]

# TEXTBOX_DRAWING
- One generic 9 part box texture is not very easy to implement for small sizes
-> Made 3 parts version for each box 

# TRANSITIONS
- Fade in [x]
- Fade out [x]
# CUTSCENES
- Cutscene have scene scripts, which is just function that return true (done) or false 
- Should cutscenes have it owns update
function ?
-> yes, we don't know how to handle dynamic situation with only sequenced scripts

- How to handle cutscene exit
    - When to exit ?
    -> Exit when nothing more to do
        -> How ??
    - We can call play_cutscene() but that will not call previous cutscene's exit, and it doesn't make sense.
    - For now we can just store a variable to indicate when the cutscene can exit and use that in the update function
    -> Super clunky
# PROLOGUE
- 

