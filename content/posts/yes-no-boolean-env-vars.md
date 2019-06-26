---
title: "YES/NO Boolean Env Vars"
date: 2019-06-25T00:57:00Z
tags:
- nitpick
- readability
- bash
---

I use `YES` and `NO` in environment variables to store Boolean values. I have come to the conclusion that this is in some way optimal after trying all the other obvious options and finding that each has readability flaws:

- `0` and `1` are confusing in POSIX shells like bash, because `return 0` and `exit 0` usually mean "success" (the command did not fail) which we think of as truthy. Likewise, `1` or any other non-zero number is treated as failure in these contexts, which intuitively feels falseish. Most other programming languages like C treat `0` as false and `1` as true. Potential confusion abounds.
- `true` and `false` (strings) both work, and are not too bad. However there are shell builtin functions with these same names, which can occasionally be confusing. Why entertain that risk?!
-  The empty or nonempty string is pretty bad. If you arbitrarily set it to `true`, `1` or `YES` to be nonempty, then you can guarantee someone will try setting it to `false`, `0` or `NO`, and be gravely disappointed at the result.
- The set or not set variable is the worst of all worlds. It inherits the same issues as the empty or nonempty string, but has some extra quirks all of its own. Unsetting a variable in your own interactive shell isn't that bad `unset VAR` and you're done. However, passing that command down through a stack of Makefiles, scripts, Docker run invocations etc is impossible. Some might try to be clever and set the var to empty, but it doesn't work. Time to get editing that stack of turtles. Be kind, give your users a knob they can use at a distance.

YES and NO cannot be confused with shell builtins, or implicit integer conversations to bools, and the words map rather intuitively to true and false respectively.

The comparison I usually use in practice is:

```
if [ $VAR = YES ]; then
  echo You said yes!
fi
```

Completely ignoring the potential `NO` value, treating anything that's not `YES` as false. Coupling this with default false values  for options dictated by env vars usually makes this safe. If you really need a decision to have been made (i.e. it is not safe to default to false) then you might want to fail if it's not set explicitly to `YES` or `NO`.

So, after many years of writing and maintaining software, I have come to the firm belief that environment variables indicating the Boolean True or False should be stored in environment variables as `YES` or `NO` respectively. This simply sidesteps many potential readability and usability downsides with the other methods. You can be as strict as you like with casing, or ignoring/handling malformed values, but default to YES/NO and stop confusing yourself and others. (Well, me anyway.)